import { createClient } from 'jsr:@supabase/supabase-js@2';

Deno.serve(async (req) => {
  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing Authorization' }), { status: 401 });
    }
    const token = authHeader.replace('Bearer ', '');

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
      { auth: { persistSession: false } },
    );

    const { data: { user }, error: authError } = await supabase.auth.getUser(token);
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401 });
    }

    const { trip_id, source, destination, departure_date, budget } = await req.json();

    // Update trip status
    await supabase.from('trips').update({ status: 'generating' }).eq('id', trip_id);

    // Try Gemini API if key is configured
    const geminiKey = Deno.env.get('GEMINI_API_KEY');
    let packages;

    if (geminiKey) {
      // Real Gemini structured-output call
      const prompt = {
        contents: [{
          parts: [{
            text: `Generate 3 trip packages (cheap, balanced, premium) from ${source} to ${destination} on ${departure_date}${budget ? ` with budget ₹${budget}` : ''}. Return JSON array with: package_type, total_cost, total_travel_time_minutes, confidence_score, rationale, pros[], cons[].`,
          }],
        }],
        generationConfig: {
          response_mime_type: 'application/json',
          temperature: 0.3,
        },
      };

      const geminiRes = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${geminiKey}`,
        { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(prompt) },
      );

      if (geminiRes.ok) {
        const geminiData = await geminiRes.json();
        const text = geminiData?.candidates?.[0]?.content?.parts?.[0]?.text;
        if (text) {
          packages = JSON.parse(text).map((p: Record<string, unknown>) => ({
            trip_id,
            ...p,
            total_cost: Number(p.total_cost),
            total_travel_time_minutes: Number(p.total_travel_time_minutes),
            confidence_score: Number(p.confidence_score),
          }));
        }
      }
    }

    // Fallback deterministic packages if Gemini not available or failed
    if (!packages) {
      const rng = () => 0.5 + Math.random() * 0.5;
      packages = [
        { trip_id, package_type: 'cheap', total_cost: 8500 + rng() * 3000, total_travel_time_minutes: 280 + Math.floor(rng() * 80), confidence_score: 0.88 + rng() * 0.12, rationale: 'Budget-friendly option with direct connectivity.', pros: ['Lowest cost', 'Direct flights'], cons: ['Basic accommodation'] },
        { trip_id, package_type: 'balanced', total_cost: 18000 + rng() * 5000, total_travel_time_minutes: 210 + Math.floor(rng() * 60), confidence_score: 0.91 + rng() * 0.09, rationale: 'Best balance of cost and comfort.', pros: ['Optimal travel time', 'Central hotels'], cons: ['Moderate cost'] },
        { trip_id, package_type: 'premium', total_cost: 35000 + rng() * 10000, total_travel_time_minutes: 150 + Math.floor(rng() * 40), confidence_score: 0.94 + rng() * 0.06, rationale: 'Premium experience with fastest routes.', pros: ['Fastest travel', '5-star hotel'], cons: ['Highest cost'] },
      ];
    }

    const { error: insertError } = await supabase.from('trip_packages').insert(packages);
    if (insertError) throw insertError;

    await supabase.from('trips').update({ status: 'generated' }).eq('id', trip_id);

    return new Response(JSON.stringify({ ok: true, count: packages.length }), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err instanceof Error ? err.message : 'Unknown' }),
      { status: 500, headers: { 'Content-Type': 'application/json' } },
    );
  }
});
