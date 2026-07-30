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

    const { package_id, message } = await req.json();

    // Store the revision
    await supabase.from('package_revisions').insert({
      package_id,
      user_message: message,
      parsed_constraint: { raw: message },
      parser_confidence: 0.85,
    });

    // Simulate AI response (real Gemini integration in future)
    const replies: Record<string, string> = {
      'cheaper': 'I\'ve found some budget-friendly alternatives. The new package is 15% cheaper with adjusted hotel tier.',
      'earlier': 'I\'ve shifted the departure to 6 AM. Your new itinerary starts earlier with more buffer time.',
      'better hotel': 'Upgraded to a 4-star hotel near your meeting location. The new package costs ₹2,000 more.',
    };

    let reply = 'I\'ve updated the package based on your request.';
    for (const [key, val] of Object.entries(replies)) {
      if (message.toLowerCase().includes(key)) reply = val;
    }

    return new Response(JSON.stringify({ reply }), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err instanceof Error ? err.message : 'Unknown' }),
      { status: 500, headers: { 'Content-Type': 'application/json' } },
    );
  }
});
