-- TripSync History view + settings for Phase 7

-- v_trip_history_summary — reverse-chronological view of past trips
CREATE OR REPLACE VIEW public.v_trip_history_summary AS
SELECT
    t.id,
    t.user_id,
    t.source,
    t.destination,
    t.departure_date,
    t.return_date,
    t.status,
    t.created_at,
    tp.package_type,
    tp.total_cost
FROM public.trips t
LEFT JOIN LATERAL (
    SELECT package_type, total_cost
    FROM public.trip_packages
    WHERE trip_id = t.id AND current_revision_id IS NOT NULL
    ORDER BY created_at DESC
    LIMIT 1
) tp ON true
ORDER BY t.created_at DESC;
