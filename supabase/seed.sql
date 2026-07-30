-- TripSync seed data (dev only)
INSERT INTO public.users (id, phone, name) VALUES
    ('00000000-0000-0000-0000-000000000001', '+919999999999', 'Test User')
ON CONFLICT (id) DO NOTHING;
