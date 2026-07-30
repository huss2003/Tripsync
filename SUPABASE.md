name: tripsync
description: "AI-powered business travel planning platform"

# Create Supabase client once, reuse everywhere.
# Edge Functions use their own imported supabase-js client.

For Flutter:
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
```

For Edge Functions (Deno):
```ts
import { createClient } from 'jsr:@supabase/supabase-js@2';
const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  { auth: { persistSession: false } },
);
```
