import { createClient } from 'jsr:@supabase/supabase-js@2';

// Tip: Set the FIREBASE_ADMIN_PROJECT_ID secret in your Supabase project settings.
// This Edge Function exchanges a Firebase ID token for a Supabase JWT session.

Deno.serve(async (req) => {
  try {
    const { firebase_id_token } = await req.json();
    if (!firebase_id_token) {
      return new Response(
        JSON.stringify({ error: 'Missing firebase_id_token' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } },
      );
    }

    // Verify Firebase token using Google's tokeninfo endpoint.
    const verifyRes = await fetch(
      `https://oauth2.googleapis.com/tokeninfo?id_token=${firebase_id_token}`,
    );
    if (!verifyRes.ok) {
      return new Response(
        JSON.stringify({ error: 'Invalid Firebase token' }),
        { status: 401, headers: { 'Content-Type': 'application/json' } },
      );
    }
    const payload = await verifyRes.json();

    // Extract phone from verified token.
    const phone = payload.phone_number as string;

    // Create Supabase admin client (service_role key).
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
      { auth: { persistSession: false } },
    );

    // Upsert user.
    const { data: user, error: upsertError } = await supabase.from('users')
      .upsert({ phone }, { onConflict: 'phone' }).select('id').single();
    if (upsertError) throw upsertError;

    // Mint Supabase session for this user.
    const { data: session, error: sessionError } = await supabase.auth.admin
      .createSession({
        user_id: user.id,
        // 7-day expiry.
        expires_in: 60 * 60 * 24 * 7,
      });
    if (sessionError) throw sessionError;

    return new Response(JSON.stringify(session), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err instanceof Error ? err.message : 'Unknown' }),
      { status: 500, headers: { 'Content-Type': 'application/json' } },
    );
  }
});
