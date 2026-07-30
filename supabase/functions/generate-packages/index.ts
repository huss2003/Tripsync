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

    const { trip_id, source, destination } = await req.json();

    // Update trip status
    await supabase.from('trips').update({ status: 'generating' }).eq('id', trip_id);

    const packages = [
      {
        trip_id,
        package_type: 'cheap',
        total_cost: 8500 + Math.random() * 3000,
        total_travel_time_minutes: 280 + Math.floor(Math.random() * 80),
        confidence_score: 0.88 + Math.random() * 0.12,
        rationale: 'Budget-friendly option with direct connectivity and affordable stays.',
        pros: ['Lowest cost option', 'Direct flights available', 'Budget hotels nearby'],
        cons: ['Limited meal inclusions', 'Basic accommodation'],
      },
      {
        trip_id,
        package_type: 'balanced',
        total_cost: 18000 + Math.random() * 5000,
        total_travel_time_minutes: 210 + Math.floor(Math.random() * 60),
        confidence_score: 0.91 + Math.random() * 0.09,
        rationale: 'Best balance of cost, convenience, and comfort for your business trip.',
        pros: ['Optimal travel time', 'Central hotels', 'Breakfast included'],
        cons: ['Moderate cost'],
      },
      {
        trip_id,
        package_type: 'premium',
        total_cost: 35000 + Math.random() * 10000,
        total_travel_time_minutes: 150 + Math.floor(Math.random() * 40),
        confidence_score: 0.94 + Math.random() * 0.06,
        rationale: 'Premium experience with fastest routes and top-rated accommodation.',
        pros: ['Fastest travel', '5-star hotel', 'All meals + lounge'],
        cons: ['Highest cost'],
      },
    ];

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
