import { createClient } from 'jsr:@supabase/supabase-js@2';

Deno.serve(async (req) => {
  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
      { auth: { persistSession: false } },
    );

    const authHeader = req.headers.get('Authorization');
    if (!authHeader) throw new Error('Unauthorized');
    const token = authHeader.replace('Bearer ', '');
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);
    if (authError || !user) throw new Error('Unauthorized');

    const { package_id, method } = await req.json();

    // Fetch package legs for the ICS
    const { data: legs } = await supabase
      .from('package_legs')
      .select('*')
      .eq('package_id', package_id);

    if (method === 'google') {
      // Google Calendar API integration — requires OAuth token
      return new Response(JSON.stringify({
        url: 'https://calendar.google.com/calendar/render?action=TEMPLATE',
      }), { headers: { 'Content-Type': 'application/json' } });
    }

    // Generate ICS
    const icsLines = [
      'BEGIN:VCALENDAR',
      'VERSION:2.0',
      'BEGIN:VEVENT',
      'SUMMARY:TripSync Trip',
      `DTSTART:${new Date().toISOString().replace(/[-:]/g, '').split('.')[0]}Z`,
      'END:VEVENT',
      'END:VCALENDAR',
    ];

    return new Response(icsLines.join('\n'), {
      status: 200,
      headers: { 'Content-Type': 'text/calendar' },
    });
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err instanceof Error ? err.message : 'Unknown' }),
      { status: 500, headers: { 'Content-Type': 'application/json' } },
    );
  }
});
