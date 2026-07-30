-- TripSync Indexes (DDS §8) + RPC Functions (DDS §11)

-- Indexes
CREATE INDEX idx_trips_user_id_created_at ON public.trips (user_id, created_at DESC);
CREATE INDEX idx_trips_user_id_status ON public.trips (user_id, status);
CREATE INDEX idx_trip_packages_trip_id ON public.trip_packages (trip_id);
CREATE INDEX idx_package_legs_package_id ON public.package_legs (package_id);
CREATE INDEX idx_package_legs_details_gin ON public.package_legs USING gin (details);
CREATE INDEX idx_package_revisions_package_id_created_at ON public.package_revisions (package_id, created_at);
CREATE INDEX idx_provider_snapshot_trip_id ON public.provider_snapshot (trip_id);
CREATE INDEX idx_provider_snapshot_fetched_at ON public.provider_snapshot (fetched_at);
CREATE INDEX idx_analytics_events_user_id_created_at ON public.analytics_events (user_id, created_at DESC);
CREATE INDEX idx_analytics_events_event_name ON public.analytics_events (event_name);

-- RPC: select_package — mark a trip package as selected
CREATE OR REPLACE FUNCTION public.select_package(p_package_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    UPDATE public.trip_packages SET current_revision_id = NULL WHERE id = p_package_id;
    UPDATE public.trips SET status = 'selected' WHERE id = (
        SELECT trip_id FROM public.trip_packages WHERE id = p_package_id
    );
END; $$;

-- RPC: get_trip_dashboard_recent — most recent trips for home screen
CREATE OR REPLACE FUNCTION public.get_trip_dashboard_recent(p_user_id uuid)
RETURNS TABLE(
    id uuid, source text, destination text,
    departure_date date, return_date date, status text,
    created_at timestamptz
) LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    RETURN QUERY
    SELECT t.id, t.source, t.destination, t.departure_date, t.return_date, t.status, t.created_at
    FROM public.trips t
    WHERE t.user_id = p_user_id
    ORDER BY t.created_at DESC
    LIMIT 5;
END; $$;
