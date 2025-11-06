--
-- PostgreSQL database dump
--

\restrict gjW31eTmlbKqsmClvFha42q8OFGG3NbR1OLIAKpcDmfs4ORnuvS0IvinSIowA78

-- Dumped from database version 17.6 (Debian 17.6-2.pgdg13+1)
-- Dumped by pg_dump version 17.6 (Debian 17.6-2.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: adopted_animal_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.adopted_animal_status_enum AS ENUM (
    'na',
    'adjustment',
    'returned'
);


ALTER TYPE public.adopted_animal_status_enum OWNER TO postgres;

--
-- Name: adoption_request_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.adoption_request_status_enum AS ENUM (
    'accepted',
    'rejected',
    'pending'
);


ALTER TYPE public.adoption_request_status_enum OWNER TO postgres;

--
-- Name: animal_sex_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.animal_sex_enum AS ENUM (
    'male',
    'female'
);


ALTER TYPE public.animal_sex_enum OWNER TO postgres;

--
-- Name: campaign_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.campaign_status_enum AS ENUM (
    'active',
    'inactive',
    'completed'
);


ALTER TYPE public.campaign_status_enum OWNER TO postgres;

--
-- Name: health_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.health_status_enum AS ENUM (
    'healthy',
    'injured',
    'sick',
    'recovering'
);


ALTER TYPE public.health_status_enum OWNER TO postgres;

--
-- Name: injury_severity_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.injury_severity_enum AS ENUM (
    'minor',
    'moderate',
    'serious',
    'severe',
    'critical',
    'maximal'
);


ALTER TYPE public.injury_severity_enum OWNER TO postgres;

--
-- Name: injury_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.injury_status_enum AS ENUM (
    'remission',
    'recovered',
    'treated',
    'waiting treatment'
);


ALTER TYPE public.injury_status_enum OWNER TO postgres;

--
-- Name: medical_care_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.medical_care_status_enum AS ENUM (
    'done',
    'upcoming',
    'reported'
);


ALTER TYPE public.medical_care_status_enum OWNER TO postgres;

--
-- Name: user_role_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role_enum AS ENUM (
    'admin',
    'user',
    'vet',
    'volunteer'
);


ALTER TYPE public.user_role_enum OWNER TO postgres;

--
-- Name: vaccination_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.vaccination_status_enum AS ENUM (
    'done',
    'upcoming',
    'reported'
);


ALTER TYPE public.vaccination_status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adoption_file; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adoption_file (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    vaccination_rate integer NOT NULL,
    description text,
    animal_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.adoption_file OWNER TO postgres;

--
-- Name: adoption_followup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adoption_followup (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    adoption_file_id text NOT NULL,
    animal_status public.adopted_animal_status_enum NOT NULL,
    note text,
    adopted_at date NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_deleted boolean,
    deleted_at timestamp without time zone
);


ALTER TABLE public.adoption_followup OWNER TO postgres;

--
-- Name: adoption_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adoption_request (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    status public.adoption_request_status_enum NOT NULL,
    description text,
    requester_note text,
    refusal_note text,
    pickup_datetime timestamp without time zone,
    requester_id text NOT NULL,
    adoption_file_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.adoption_request OWNER TO postgres;

--
-- Name: animal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animal (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    age integer NOT NULL,
    sex public.animal_sex_enum NOT NULL,
    picture_url text,
    type_id text NOT NULL,
    race_id text NOT NULL,
    description text,
    is_deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.animal OWNER TO postgres;

--
-- Name: animal_injury; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animal_injury (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    medical_file_id text NOT NULL,
    status public.injury_status_enum NOT NULL,
    severity public.injury_severity_enum NOT NULL,
    note text,
    type_id text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.animal_injury OWNER TO postgres;

--
-- Name: animal_race; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animal_race (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    type_id text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.animal_race OWNER TO postgres;

--
-- Name: animal_treatment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animal_treatment (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    medical_file_id text NOT NULL,
    for_injury_id text,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    note text,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.animal_treatment OWNER TO postgres;

--
-- Name: animal_treatment_medicine; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animal_treatment_medicine (
    animal_treatment_id text NOT NULL,
    medicine_type_id text NOT NULL
);


ALTER TABLE public.animal_treatment_medicine OWNER TO postgres;

--
-- Name: animal_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animal_type (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    specie text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.animal_type OWNER TO postgres;

--
-- Name: behavior_file; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.behavior_file (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    animal_id text NOT NULL,
    behavior_type_id text NOT NULL,
    note text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.behavior_file OWNER TO postgres;

--
-- Name: behavior_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.behavior_type (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.behavior_type OWNER TO postgres;

--
-- Name: campaign; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaign (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    goal_amount numeric NOT NULL,
    status public.campaign_status_enum NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.campaign OWNER TO postgres;

--
-- Name: donation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donation (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    amount numeric NOT NULL,
    means text,
    donator_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    campaign_id text NOT NULL,
    donated_at date NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.donation OWNER TO postgres;

--
-- Name: injury_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.injury_type (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.injury_type OWNER TO postgres;

--
-- Name: medical_care; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_care (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    type_id text NOT NULL,
    status public.medical_care_status_enum NOT NULL,
    description text,
    datetime timestamp without time zone,
    vet_id text NOT NULL,
    medical_file_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.medical_care OWNER TO postgres;

--
-- Name: medical_care_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_care_type (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.medical_care_type OWNER TO postgres;

--
-- Name: TABLE medical_care_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.medical_care_type IS 'Type of a medical care act';


--
-- Name: COLUMN medical_care_type.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.medical_care_type.description IS 'Description of the medical care act, can contains other useful informations';


--
-- Name: medical_file; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_file (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    vaccination_rate integer NOT NULL,
    description text,
    animal_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    health_status public.health_status_enum NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.medical_file OWNER TO postgres;

--
-- Name: medicine_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicine_type (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.medicine_type OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone text,
    password text NOT NULL,
    role public.user_role_enum NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: vaccination; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vaccination (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    vaccine_id text NOT NULL,
    status public.vaccination_status_enum NOT NULL,
    description text,
    datetime timestamp without time zone,
    vet_id text NOT NULL,
    medical_file_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.vaccination OWNER TO postgres;

--
-- Name: vaccine_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vaccine_type (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.vaccine_type OWNER TO postgres;

--
-- Name: TABLE vaccine_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.vaccine_type IS 'Type of vaccine';


--
-- Name: visit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visit (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    description text,
    datetime timestamp without time zone,
    visitor_id text NOT NULL,
    adoption_file_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.visit OWNER TO postgres;

--
-- Name: COLUMN visit.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.visit.description IS 'Contains useful informations on the visit';


--
-- Name: COLUMN visit.datetime; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.visit.datetime IS 'Datetime at which the visit is planned';


--
-- Data for Name: adoption_file; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adoption_file (id, vaccination_rate, description, animal_id, is_deleted, created_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: adoption_followup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adoption_followup (id, adoption_file_id, animal_status, note, adopted_at, created_at, is_deleted, deleted_at) FROM stdin;
\.


--
-- Data for Name: adoption_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adoption_request (id, status, description, requester_note, refusal_note, pickup_datetime, requester_id, adoption_file_id, is_deleted, created_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: animal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animal (id, name, age, sex, picture_url, type_id, race_id, description, is_deleted, created_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: animal_injury; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animal_injury (id, medical_file_id, status, severity, note, type_id, created_at, is_deleted, deleted_at) FROM stdin;
\.


--
-- Data for Name: animal_race; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animal_race (id, name, type_id, created_at) FROM stdin;
\.


--
-- Data for Name: animal_treatment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animal_treatment (id, medical_file_id, for_injury_id, start_date, end_date, note, is_deleted, deleted_at, created_at) FROM stdin;
\.


--
-- Data for Name: animal_treatment_medicine; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animal_treatment_medicine (animal_treatment_id, medicine_type_id) FROM stdin;
\.


--
-- Data for Name: animal_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animal_type (id, name, created_at) FROM stdin;
\.


--
-- Data for Name: behavior_file; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.behavior_file (id, animal_id, behavior_type_id, note, created_at, is_deleted, deleted_at) FROM stdin;
\.


--
-- Data for Name: behavior_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.behavior_type (id, name, description, created_at) FROM stdin;
\.


--
-- Data for Name: campaign; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.campaign (id, title, description, goal_amount, status, start_date, end_date, created_at, is_deleted, deleted_at) FROM stdin;
\.


--
-- Data for Name: donation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donation (id, amount, means, donator_id, is_deleted, campaign_id, donated_at, created_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: injury_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.injury_type (id, name, description, created_at) FROM stdin;
\.


--
-- Data for Name: medical_care; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_care (id, type_id, status, description, datetime, vet_id, medical_file_id, is_deleted, created_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: medical_care_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_care_type (id, name, description, created_at) FROM stdin;
\.


--
-- Data for Name: medical_file; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_file (id, vaccination_rate, description, animal_id, is_deleted, health_status, created_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: medicine_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicine_type (id, name, description, created_at) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, name, email, phone, password, role, is_deleted, deleted_at, created_at) FROM stdin;
\.


--
-- Data for Name: vaccination; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vaccination (id, vaccine_id, status, description, datetime, vet_id, medical_file_id, is_deleted, created_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: vaccine_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vaccine_type (id, name, created_at) FROM stdin;
\.


--
-- Data for Name: visit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visit (id, description, datetime, visitor_id, adoption_file_id, is_deleted, deleted_at, created_at) FROM stdin;
\.


--
-- Name: adoption_file adoption_file_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoption_file
    ADD CONSTRAINT adoption_file_pkey PRIMARY KEY (id);


--
-- Name: adoption_followup adoption_followup_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoption_followup
    ADD CONSTRAINT adoption_followup_pk PRIMARY KEY (id);


--
-- Name: adoption_request adoption_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoption_request
    ADD CONSTRAINT adoption_request_pkey PRIMARY KEY (id);


--
-- Name: animal_injury animal_injury_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_injury
    ADD CONSTRAINT animal_injury_pk PRIMARY KEY (id);


--
-- Name: animal animal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal
    ADD CONSTRAINT animal_pkey PRIMARY KEY (id);


--
-- Name: animal_race animal_race_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_race
    ADD CONSTRAINT animal_race_pk PRIMARY KEY (id);


--
-- Name: animal_type animal_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_type
    ADD CONSTRAINT animal_type_pk PRIMARY KEY (id);


--
-- Name: animal_treatment_medicine animal_treatment_medicine_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_treatment_medicine
    ADD CONSTRAINT animal_treatment_medicine_pk PRIMARY KEY (animal_treatment_id);


--
-- Name: animal_treatment animal_treatment_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_treatment
    ADD CONSTRAINT animal_treatment_pk PRIMARY KEY (id);


--
-- Name: behavior_file behavior_file_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.behavior_file
    ADD CONSTRAINT behavior_file_pk PRIMARY KEY (id);


--
-- Name: behavior_type behavior_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.behavior_type
    ADD CONSTRAINT behavior_type_pk PRIMARY KEY (id);


--
-- Name: campaign campaign_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign
    ADD CONSTRAINT campaign_pk PRIMARY KEY (id);


--
-- Name: donation donation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation
    ADD CONSTRAINT donation_pkey PRIMARY KEY (id);


--
-- Name: injury_type injury_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.injury_type
    ADD CONSTRAINT injury_type_pk PRIMARY KEY (id);


--
-- Name: medical_care medical_care_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_care
    ADD CONSTRAINT medical_care_pkey PRIMARY KEY (id);


--
-- Name: medical_care_type medical_care_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_care_type
    ADD CONSTRAINT medical_care_type_pk PRIMARY KEY (id);


--
-- Name: medical_file medical_file_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_file
    ADD CONSTRAINT medical_file_pkey PRIMARY KEY (id);


--
-- Name: medicine_type medicine_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine_type
    ADD CONSTRAINT medicine_type_pk PRIMARY KEY (id);


--
-- Name: user user_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_unique UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: vaccine_type vaccine_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaccine_type
    ADD CONSTRAINT vaccine_type_pk PRIMARY KEY (id);


--
-- Name: visit visit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT visit_pkey PRIMARY KEY (id);


--
-- Name: adoption_file_animal_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX adoption_file_animal_id_idx ON public.adoption_file USING btree (animal_id);


--
-- Name: medical_file_animal_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX medical_file_animal_id_idx ON public.medical_file USING btree (animal_id);


--
-- Name: user_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_email_idx ON public."user" USING btree (email);


--
-- Name: adoption_file adoption_file_animal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoption_file
    ADD CONSTRAINT adoption_file_animal_id_fkey FOREIGN KEY (animal_id) REFERENCES public.animal(id);


--
-- Name: adoption_followup adoption_followup_adoption_file_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoption_followup
    ADD CONSTRAINT adoption_followup_adoption_file_fk FOREIGN KEY (adoption_file_id) REFERENCES public.adoption_file(id);


--
-- Name: adoption_request adoption_request_adoption_file_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoption_request
    ADD CONSTRAINT adoption_request_adoption_file_id_fkey FOREIGN KEY (adoption_file_id) REFERENCES public.adoption_file(id);


--
-- Name: adoption_request adoption_request_requester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoption_request
    ADD CONSTRAINT adoption_request_requester_id_fkey FOREIGN KEY (requester_id) REFERENCES public."user"(id);


--
-- Name: animal animal_animal_race_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal
    ADD CONSTRAINT animal_animal_race_fk FOREIGN KEY (race_id) REFERENCES public.animal_race(id);


--
-- Name: animal animal_animal_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal
    ADD CONSTRAINT animal_animal_type_fk FOREIGN KEY (type_id) REFERENCES public.animal_type(id);


--
-- Name: behavior_file animal_behavior_animal_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.behavior_file
    ADD CONSTRAINT animal_behavior_animal_fk FOREIGN KEY (animal_id) REFERENCES public.animal(id);


--
-- Name: behavior_file animal_behavior_behavior_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.behavior_file
    ADD CONSTRAINT animal_behavior_behavior_type_fk FOREIGN KEY (behavior_type_id) REFERENCES public.behavior_type(id);


--
-- Name: animal_injury animal_injury_injury_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_injury
    ADD CONSTRAINT animal_injury_injury_type_fk FOREIGN KEY (type_id) REFERENCES public.injury_type(id);


--
-- Name: animal_injury animal_injury_medical_file_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_injury
    ADD CONSTRAINT animal_injury_medical_file_fk FOREIGN KEY (medical_file_id) REFERENCES public.medical_file(id);


--
-- Name: animal_race animal_race_animal_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_race
    ADD CONSTRAINT animal_race_animal_type_fk FOREIGN KEY (type_id) REFERENCES public.animal_type(id);


--
-- Name: animal_treatment animal_treatment_animal_injury_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_treatment
    ADD CONSTRAINT animal_treatment_animal_injury_fk FOREIGN KEY (for_injury_id) REFERENCES public.animal_injury(id);


--
-- Name: animal_treatment animal_treatment_medical_file_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_treatment
    ADD CONSTRAINT animal_treatment_medical_file_fk FOREIGN KEY (medical_file_id) REFERENCES public.medical_file(id);


--
-- Name: animal_treatment_medicine animal_treatment_medicine_animal_treatment_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_treatment_medicine
    ADD CONSTRAINT animal_treatment_medicine_animal_treatment_fk FOREIGN KEY (animal_treatment_id) REFERENCES public.animal_treatment(id);


--
-- Name: animal_treatment_medicine animal_treatment_medicine_medicine_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_treatment_medicine
    ADD CONSTRAINT animal_treatment_medicine_medicine_type_fk FOREIGN KEY (medicine_type_id) REFERENCES public.medicine_type(id);


--
-- Name: donation donation_campaign_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation
    ADD CONSTRAINT donation_campaign_fk FOREIGN KEY (campaign_id) REFERENCES public.campaign(id);


--
-- Name: donation donation_donator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation
    ADD CONSTRAINT donation_donator_id_fkey FOREIGN KEY (donator_id) REFERENCES public."user"(id);


--
-- Name: medical_care medical_care_medical_care_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_care
    ADD CONSTRAINT medical_care_medical_care_type_fk FOREIGN KEY (type_id) REFERENCES public.medical_care_type(id);


--
-- Name: medical_care medical_care_medical_file_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_care
    ADD CONSTRAINT medical_care_medical_file_id_fkey FOREIGN KEY (medical_file_id) REFERENCES public.medical_file(id);


--
-- Name: medical_care medical_care_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_care
    ADD CONSTRAINT medical_care_user_fk FOREIGN KEY (vet_id) REFERENCES public."user"(id);


--
-- Name: medical_file medical_file_animal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_file
    ADD CONSTRAINT medical_file_animal_id_fkey FOREIGN KEY (animal_id) REFERENCES public.animal(id);


--
-- Name: vaccination vaccination_medical_file_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaccination
    ADD CONSTRAINT vaccination_medical_file_id_fkey FOREIGN KEY (medical_file_id) REFERENCES public.medical_file(id);


--
-- Name: vaccination vaccination_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaccination
    ADD CONSTRAINT vaccination_user_fk FOREIGN KEY (vet_id) REFERENCES public."user"(id);


--
-- Name: vaccination vaccination_vaccine_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaccination
    ADD CONSTRAINT vaccination_vaccine_fk FOREIGN KEY (vaccine_id) REFERENCES public.vaccine_type(id);


--
-- Name: visit visit_adoption_file_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT visit_adoption_file_id_fkey FOREIGN KEY (adoption_file_id) REFERENCES public.adoption_file(id);


--
-- Name: visit visit_visitor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT visit_visitor_id_fkey FOREIGN KEY (visitor_id) REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--

\unrestrict gjW31eTmlbKqsmClvFha42q8OFGG3NbR1OLIAKpcDmfs4ORnuvS0IvinSIowA78


