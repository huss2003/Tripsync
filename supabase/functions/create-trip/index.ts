import { createClient } from 'jsr:@supabase/supabase-js@2';

Deno.serve(async (req) => {
  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing Authorization' }), { status: 401 });
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
      { auth: { persistSession: false } },
    );

    const token = authHeader.replace('Bearer ', '');
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401 });
    }

    const body = await req.json();

    const { data: trip, error: insertError } = await supabase.from('trips').insert({
      user_id: user.id,
      source: body.source,
      destination: body.destination,
      departure_date: body.departure_date,
      return_date: body.return_date ?? null,
      purpose: body.purpose ?? null,
      meeting_address: body.meeting_address ?? null,
      traveller_count: body.traveller_count ?? 1,
      budget: body.budget ? parseFloat(body.budget) : null,
      status: 'draft',
    }).select('id').single();

    if (insertError) throw insertError;

    return new Response(JSON.stringify(trip), {
      status: 201,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err instanceof Error ? err.message : 'Unknown' }),
      { status: 500, headers: { 'Content-Type': 'application/json' } },
    );
  }
});
