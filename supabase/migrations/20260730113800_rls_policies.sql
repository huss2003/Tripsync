-- TripSync RLS Policies per DDS §13
-- Every user-data table has RLS enabled, scoped to auth.uid()

-- users
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
CREATE POLICY users_select_own ON public.users
    FOR SELECT USING (auth.uid() = id);
CREATE POLICY users_update_own ON public.users
    FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);
-- INSERT: service-role only (auth-bridge EF)

-- user_preferences
ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;
CREATE POLICY user_preferences_owner_all ON public.user_preferences
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- trips
ALTER TABLE public.trips ENABLE ROW LEVEL SECURITY;
CREATE POLICY trips_select_own ON public.trips
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY trips_insert_own ON public.trips
    FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY trips_update_own ON public.trips
    FOR UPDATE USING (auth.uid() = user_id);
-- No DELETE policy: cascade only

-- trip_packages (ownership via trip join)
ALTER TABLE public.trip_packages ENABLE ROW LEVEL SECURITY;
CREATE POLICY trip_packages_select_via_trip_owner ON public.trip_packages
    FOR SELECT USING (
        EXISTS (SELECT 1 FROM public.trips t WHERE t.id = trip_packages.trip_id AND t.user_id = auth.uid())
    );
-- No client INSERT/UPDATE/DELETE: Edge Functions only

-- package_legs (ownership via 2-hop join)
ALTER TABLE public.package_legs ENABLE ROW LEVEL SECURITY;
CREATE POLICY package_legs_select_via_owner ON public.package_legs
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.trip_packages tp
            JOIN public.trips t ON t.id = tp.trip_id
            WHERE tp.id = package_legs.package_id AND t.user_id = auth.uid()
        )
    );

-- package_revisions (append-only, SELECT via owner join)
ALTER TABLE public.package_revisions ENABLE ROW LEVEL SECURITY;
CREATE POLICY package_revisions_select_via_owner ON public.package_revisions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.trip_packages tp
            JOIN public.trips t ON t.id = tp.trip_id
            WHERE tp.id = package_revisions.package_id AND t.user_id = auth.uid()
        )
    );
-- No UPDATE/DELETE policy for any role

-- provider_snapshot (service-role only — no client read)
ALTER TABLE public.provider_snapshot ENABLE ROW LEVEL SECURITY;
-- Zero policies for authenticated role

-- analytics_events (write-only from client)
ALTER TABLE public.analytics_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY analytics_events_insert_own ON public.analytics_events
    FOR INSERT WITH CHECK (auth.uid() = user_id);
-- No SELECT policy: read via service role / BI tooling
