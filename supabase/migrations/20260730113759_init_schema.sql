-- TripSync Core Schema — 8 tables per DDS §5
-- Migration 1: tables, constraints, triggers

-- 5.1 users
CREATE TABLE public.users (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    phone       text NOT NULL,
    name        text,
    created_at  timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT users_phone_format_check CHECK (phone ~ '^\+[1-9]\d{7,14}$')
);
CREATE UNIQUE INDEX idx_users_phone ON public.users (phone);

-- 5.2 user_preferences
CREATE TABLE public.user_preferences (
    user_id             uuid PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
    preferred_airlines  text[] DEFAULT '{}',
    hotel_tier          text CHECK (hotel_tier IN ('budget','mid','luxury')),
    budget_band         text,
    updated_at          timestamptz NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END; $$;

CREATE TRIGGER trg_user_preferences_set_updated_at
    BEFORE UPDATE ON public.user_preferences
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- 5.3 trips
CREATE TABLE public.trips (
    id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id          uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    source           text NOT NULL,
    destination      text NOT NULL,
    departure_date   date NOT NULL,
    return_date      date,
    purpose          text,
    meeting_address  text,
    meeting_lat      numeric(9,6),
    meeting_lng      numeric(9,6),
    traveller_count  int NOT NULL DEFAULT 1,
    budget           numeric(12,2),
    status           text NOT NULL DEFAULT 'draft',
    created_at       timestamptz NOT NULL DEFAULT now(),
    updated_at       timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT trips_source_ne_destination_check CHECK (source <> destination),
    CONSTRAINT trips_traveller_count_check CHECK (traveller_count >= 1),
    CONSTRAINT trips_return_after_departure_check CHECK (return_date IS NULL OR return_date >= departure_date),
    CONSTRAINT trips_budget_positive_check CHECK (budget IS NULL OR budget > 0),
    CONSTRAINT trips_status_check CHECK (status IN ('draft','generating','generated','failed','selected'))
);

CREATE TRIGGER trg_trips_set_updated_at
    BEFORE UPDATE ON public.trips
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- 5.4 trip_packages
CREATE TABLE public.trip_packages (
    id                        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id                   uuid NOT NULL REFERENCES public.trips(id) ON DELETE CASCADE,
    package_type              text NOT NULL CHECK (package_type IN ('cheap','balanced','premium')),
    total_cost                numeric(12,2) NOT NULL CHECK (total_cost >= 0),
    total_travel_time_minutes int NOT NULL CHECK (total_travel_time_minutes >= 0),
    confidence_score          numeric(3,2) CHECK (confidence_score BETWEEN 0 AND 1),
    rationale                 text CHECK (char_length(rationale) <= 280),
    pros                      text[] DEFAULT '{}',
    cons                      text[] DEFAULT '{}',
    current_revision_id       uuid,
    created_at                timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT trip_packages_trip_type_unique UNIQUE (trip_id, package_type)
);

-- 5.5 package_legs
CREATE TABLE public.package_legs (
    id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    package_id     uuid NOT NULL REFERENCES public.trip_packages(id) ON DELETE CASCADE,
    leg_type       text NOT NULL CHECK (leg_type IN ('flight','hotel','cab','train','bus')),
    provider       text NOT NULL,
    price          numeric(12,2) NOT NULL CHECK (price >= 0),
    details        jsonb NOT NULL,
    deep_link_url  text NOT NULL,
    is_hidden      boolean NOT NULL DEFAULT false
);

-- 5.6 package_revisions (append-only audit trail)
CREATE TABLE public.package_revisions (
    id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    package_id         uuid NOT NULL REFERENCES public.trip_packages(id) ON DELETE CASCADE,
    user_message       text NOT NULL CHECK (char_length(user_message) BETWEEN 1 AND 300),
    parsed_constraint  jsonb NOT NULL,
    parser_confidence  numeric(3,2) CHECK (parser_confidence BETWEEN 0 AND 1),
    created_at         timestamptz NOT NULL DEFAULT now()
);

-- Deferred FK: trip_packages → package_revisions
ALTER TABLE public.trip_packages
    ADD CONSTRAINT trip_packages_current_revision_fk
    FOREIGN KEY (current_revision_id) REFERENCES public.package_revisions(id)
    DEFERRABLE INITIALLY DEFERRED;

-- 5.7 provider_snapshot (debug/ops — no client read)
CREATE TABLE public.provider_snapshot (
    id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id        uuid NOT NULL REFERENCES public.trips(id) ON DELETE CASCADE,
    provider_name  text NOT NULL,
    raw_payload    jsonb NOT NULL,
    fetched_at     timestamptz NOT NULL DEFAULT now()
);

-- 5.8 analytics_events (write-only from client)
CREATE TABLE public.analytics_events (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid REFERENCES public.users(id) ON DELETE SET NULL,
    event_name  text NOT NULL,
    properties  jsonb NOT NULL DEFAULT '{}',
    created_at  timestamptz NOT NULL DEFAULT now()
);
