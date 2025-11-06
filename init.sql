--
-- PostgreSQL database dump
--

\restrict Cw9XgJYjIKi2YIbQN997POZd6FqvTwPvmgj8KpPVaY2zliFdTU47sR6BcFVudOe

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
    race_id text,
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
850e8400-e29b-41d4-a716-446655440001	75	Ready for adoption	650e8400-e29b-41d4-a716-446655440001	f	2025-11-06 09:58:49.224076	\N
850e8400-e29b-41d4-a716-446655440002	60	Will be ready soon	650e8400-e29b-41d4-a716-446655440002	f	2025-11-06 09:58:49.224076	\N
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
b50e8400-e29b-41d4-a716-446655440001	pending	Interested in adopting Max	I have a big yard and experience with dogs	\N	\N	550e8400-e29b-41d4-a716-446655440004	850e8400-e29b-41d4-a716-446655440001	f	2025-11-06 09:58:49.243941	\N
\.


--
-- Data for Name: animal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animal (id, name, age, sex, picture_url, type_id, race_id, description, is_deleted, created_at, deleted_at) FROM stdin;
650e8400-e29b-41d4-a716-446655440001	Max	3	male	\N	616150f0-62ef-4894-9dd0-d7c3282046c6	\N	Friendly golden retriever, rescued from streets	f	2025-11-06 09:58:49.210937	\N
650e8400-e29b-41d4-a716-446655440002	Whiskers	2	female	\N	2dda8820-e485-4336-8245-7027fe8a80d2	\N	Orange tabby cat, very playful	f	2025-11-06 09:58:49.210937	\N
650e8400-e29b-41d4-a716-446655440003	Fluffy	1	male	\N	3a79b58f-85d4-4758-b403-d3e916502796	\N	White rabbit, calm personality	f	2025-11-06 09:58:49.210937	\N
7e6680b1-6728-4199-a5f1-0d77dd69028a	Caroline	5	female	\N	2dda8820-e485-4336-8245-7027fe8a80d2	\N	Black wild cat	f	2025-11-06 11:39:16.672448	\N
\.


--
-- Data for Name: animal_injury; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animal_injury (id, medical_file_id, status, severity, note, type_id, created_at, is_deleted, deleted_at) FROM stdin;
efe271f1-28ec-4668-80e4-e28f2eb96672	59e8787b-c7a0-4852-bb99-cdd681faa889	waiting treatment	moderate	Laceration head to be treated	250e8400-e29b-41d4-a716-446655440002	2025-11-06 11:43:02.174426	f	\N
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

COPY public.animal_type (id, name, specie, created_at) FROM stdin;
612a9027-1f01-4bb1-b5ca-c0ab7b822a51	Aardvark	Mammal	2025-11-06 09:51:56.472777
75d121e9-ec6c-49a5-be66-436802f08f10	Albatross	Bird	2025-11-06 09:51:56.472777
1df4b644-7c60-4749-b17b-963565e24e39	Alligator	Reptile	2025-11-06 09:51:56.472777
cb78d989-7dd7-4332-87c6-7221c50567ec	Alpaca	Mammal	2025-11-06 09:51:56.472777
be2f5252-6f98-4297-8e5c-927535608967	Ant	Insect	2025-11-06 09:51:56.472777
1c28aa26-77c0-40fa-aa53-884cf35b3258	Anteater	Mammal	2025-11-06 09:51:56.472777
b8b5de89-5454-420e-b42e-39a90d9cabf8	Antelope	Mammal	2025-11-06 09:51:56.472777
a44247fe-00d0-4987-9db6-47486da3e4a0	Ape	Mammal	2025-11-06 09:51:56.472777
8d773272-64b6-4cac-9976-439737d303de	Armadillo	Mammal	2025-11-06 09:51:56.472777
84e95f9f-e28e-4c84-91c1-7ba0b315f63e	Donkey	Mammal	2025-11-06 09:51:56.472777
378a582b-6016-4a2f-b1e9-8ed72b29bdff	Baboon	Mammal	2025-11-06 09:51:56.472777
070f4ae9-babf-4ac8-9f27-3a786f68f39d	Badger	Mammal	2025-11-06 09:51:56.472777
1f947ba7-93c5-4123-9b7b-4dfcd553b76e	Barracuda	Fish	2025-11-06 09:51:56.472777
05840eca-e8dc-44cb-b61b-ba284bc09eda	Bat	Mammal	2025-11-06 09:51:56.472777
b0b3fa8d-973d-41ae-929c-c928cff1a4d1	Bear	Mammal	2025-11-06 09:51:56.472777
adaf5d0b-7bf4-40fe-99b6-b73ae21cdccd	Beaver	Mammal	2025-11-06 09:51:56.472777
a76b8edd-139c-4ea3-bb3a-11b79ccb4a1c	Bee	Insect	2025-11-06 09:51:56.472777
159b4b73-7a73-44a0-80db-c17a30dd266c	Bison	Mammal	2025-11-06 09:51:56.472777
d4e2039e-9f2a-49a6-9d5f-56ad93fd5e7b	Boar	Mammal	2025-11-06 09:51:56.472777
0777cd37-9be8-4b73-bae1-6ad66393cd87	Buffalo	Mammal	2025-11-06 09:51:56.472777
eb73c879-bddc-4368-bd4c-af787e54880d	Butterfly	Insect	2025-11-06 09:51:56.472777
ebf291c7-1db8-422d-a248-c6d3dde02ccb	Camel	Mammal	2025-11-06 09:51:56.472777
7b5b73fb-aad3-4ee1-89ef-4a7e1f25e47e	Capybara	Mammal	2025-11-06 09:51:56.472777
645106f0-d987-406a-b061-687c960dacbd	Caribou	Mammal	2025-11-06 09:51:56.472777
9fdbad27-0575-4cb5-a069-0d2dca2a3c30	Cassowary	Bird	2025-11-06 09:51:56.472777
2dda8820-e485-4336-8245-7027fe8a80d2	Cat	Mammal	2025-11-06 09:51:56.472777
60a42b3e-82ce-4d7e-87c6-bd8345ce2e4d	Caterpillar	Insect	2025-11-06 09:51:56.472777
d9f930e9-b903-4e49-8205-8e2f721bb61c	Cattle	Mammal	2025-11-06 09:51:56.472777
c014422c-6962-41e6-9616-3ee9eb080525	Chamois	Mammal	2025-11-06 09:51:56.472777
f3eea387-cdce-4a93-99a9-f44ee1865a7b	Cheetah	Mammal	2025-11-06 09:51:56.472777
27b8c7b0-8bb4-4169-9f8a-00c7cd389b80	Chicken	Bird	2025-11-06 09:51:56.472777
992eb75e-3c38-40bc-bc18-af45c0947137	Chimpanzee	Mammal	2025-11-06 09:51:56.472777
df5c76cd-0a1c-4e6f-b88c-ab6045da4026	Chinchilla	Mammal	2025-11-06 09:51:56.472777
876a67b1-e0cf-4835-ab57-4685b7c50570	Chough	Bird	2025-11-06 09:51:56.472777
363a2ea4-b7e0-4609-a76b-6009e6859c10	Clam	Mollusk	2025-11-06 09:51:56.472777
ff8d5522-6752-4ee5-b229-ed1abc8a711a	Cobra	Reptile	2025-11-06 09:51:56.472777
4a881a53-436a-45a8-a524-3cee1fd8222f	Cockroach	Insect	2025-11-06 09:51:56.472777
2686d7a8-d38f-4466-9ffc-8defc0a348ff	Cod	Fish	2025-11-06 09:51:56.472777
8aa8f77e-1065-43b6-ad1c-4f9288ef43d2	Cormorant	Bird	2025-11-06 09:51:56.472777
8b9095da-87c9-486e-80e6-bc5c60d7bfb1	Coyote	Mammal	2025-11-06 09:51:56.472777
926e685a-c3ac-4ccd-8b7e-05d10d6e6933	Crab	Crustacean	2025-11-06 09:51:56.472777
caec4c06-1878-4316-a1dd-dcb8465a698f	Crane	Bird	2025-11-06 09:51:56.472777
3a3eb91b-9597-4a0b-8375-69aef0c7e8f1	Crocodile	Reptile	2025-11-06 09:51:56.472777
6fee701f-5f8a-4488-967d-8a8bf919c581	Crow	Bird	2025-11-06 09:51:56.472777
d296c3eb-351f-436d-83e4-f0cf7c9fbe91	Curlew	Bird	2025-11-06 09:51:56.472777
57de6c5b-52a3-41be-8f11-09232087ffe3	Deer	Mammal	2025-11-06 09:51:56.472777
837cfe2e-cc75-41d0-9be4-18af38361fba	Dinosaur	Reptile	2025-11-06 09:51:56.472777
616150f0-62ef-4894-9dd0-d7c3282046c6	Dog	Mammal	2025-11-06 09:51:56.472777
cdf9d4fd-51f3-407f-bad1-ab5aa13ba8d7	Dogfish	Fish	2025-11-06 09:51:56.472777
1a15a513-3bd5-478c-8c95-b23e7f2c3440	Dolphin	Mammal	2025-11-06 09:51:56.472777
7e0f62e8-54de-4a04-a28b-beb48b93083b	Dotterel	Bird	2025-11-06 09:51:56.472777
bb26cbc5-8669-47bf-b507-be5fe27711b6	Dove	Bird	2025-11-06 09:51:56.472777
d2254c5c-b59f-4f8d-bba2-d5bc84ef2c9c	Dragonfly	Insect	2025-11-06 09:51:56.472777
d4de82e9-7fa9-473a-bb3f-f7f53f1ada31	Duck	Bird	2025-11-06 09:51:56.472777
96c8d774-864b-4337-87b4-ea9483dcd933	Dugong	Mammal	2025-11-06 09:51:56.472777
2e0badd7-33ea-428d-abee-bd0c46c85e07	Dunlin	Bird	2025-11-06 09:51:56.472777
e2492b0e-bc5c-4de5-b3c8-0fbf5ba52f80	Eagle	Bird	2025-11-06 09:51:56.472777
8c48f1b2-7726-4b0e-b48c-dea5526f86ee	Echidna	Mammal	2025-11-06 09:51:56.472777
1f7e60e3-a9d2-4233-a696-ec84bde05fd9	Eel	Fish	2025-11-06 09:51:56.472777
4d313f6b-4ca2-4e85-8c1b-8a0e04a4d052	Eland	Mammal	2025-11-06 09:51:56.472777
ed143743-3982-4b29-85a0-5b12dad34946	Elephant	Mammal	2025-11-06 09:51:56.472777
b0fb2ad3-687d-4082-a5fb-4b5cacf6343e	Elk	Mammal	2025-11-06 09:51:56.472777
69108cbd-c899-4ef4-8971-5f5698079cbf	Emu	Bird	2025-11-06 09:51:56.472777
9c2383b2-e62b-4352-a272-c78033b446dd	Falcon	Bird	2025-11-06 09:51:56.472777
e976ff5c-027d-4586-8e4b-15f38709eed3	Ferret	Mammal	2025-11-06 09:51:56.472777
56ca827f-6b2b-4415-b8bc-75867449d32a	Finch	Bird	2025-11-06 09:51:56.472777
6d10a187-b85a-47db-b5b6-6bdda924e1cd	Fish	Fish	2025-11-06 09:51:56.472777
d84acb9e-33d7-4657-bad0-cbd251dcce80	Flamingo	Bird	2025-11-06 09:51:56.472777
6e8ed4a7-4ce3-450e-baca-772363da3f6a	Fly	Insect	2025-11-06 09:51:56.472777
7cb29a83-344e-4a03-9cb2-775960966f19	Fox	Mammal	2025-11-06 09:51:56.472777
ea4c594f-b7dd-4c08-8233-520844a0f8f7	Frog	Amphibian	2025-11-06 09:51:56.472777
ad327d01-4a0b-44d1-9948-d9c028bfdfca	Gaur	Mammal	2025-11-06 09:51:56.472777
4b23200e-1d10-4e43-b0f6-90f6bc2daf84	Gazelle	Mammal	2025-11-06 09:51:56.472777
d8310ef3-2783-41b5-a30a-299a6452a9ad	Gerbil	Mammal	2025-11-06 09:51:56.472777
71056a41-46c4-4e13-90f6-91f6eca11d96	Giraffe	Mammal	2025-11-06 09:51:56.472777
9514a0b6-3134-4ce3-bbef-998412372b3c	Gnat	Insect	2025-11-06 09:51:56.472777
360661b8-99bd-45d8-8ec9-fd7d4824a439	Gnu	Mammal	2025-11-06 09:51:56.472777
b00799b7-33ad-43fe-aed1-28873d76b647	Goat	Mammal	2025-11-06 09:51:56.472777
3581c527-344c-43f1-9ee8-8656c270da49	Goldfinch	Bird	2025-11-06 09:51:56.472777
b569d56b-498a-48f6-b71f-7e403b65e173	Goldfish	Fish	2025-11-06 09:51:56.472777
c91da28d-ebc1-4257-b4a5-36fc33b77830	Goose	Bird	2025-11-06 09:51:56.472777
7f3865d2-69b5-4f6c-b94b-13738b8d7c07	Gorilla	Mammal	2025-11-06 09:51:56.472777
79afdcf6-f6db-4724-a447-f0a2c685d5de	Goshawk	Bird	2025-11-06 09:51:56.472777
bca2b2ae-c810-4715-a86f-e06d8fc85f92	Grasshopper	Insect	2025-11-06 09:51:56.472777
c9b506f7-c546-45d2-836f-70cff17f9be4	Grouse	Bird	2025-11-06 09:51:56.472777
598a7748-0f28-40e7-9f56-64be4810ea28	Guanaco	Mammal	2025-11-06 09:51:56.472777
1d204c4f-be82-44e8-9b3d-fa2d1a4ce46e	Gull	Bird	2025-11-06 09:51:56.472777
23623442-6f65-451b-a4ab-f639311fd7b4	Hamster	Mammal	2025-11-06 09:51:56.472777
91565462-d3c5-44ff-b78d-a2fd195b30ea	Hare	Mammal	2025-11-06 09:51:56.472777
5dbf4051-765b-476b-91e2-e3ddfaefd2e2	Hawk	Bird	2025-11-06 09:51:56.472777
d4ea1b4b-4a71-4056-8674-3f5c98caab10	Hedgehog	Mammal	2025-11-06 09:51:56.472777
4fed878f-c2ea-4571-a77a-742a98a3402b	Heron	Bird	2025-11-06 09:51:56.472777
6bcb2715-ccf1-43fb-8fbe-ef670a6b63d5	Herring	Fish	2025-11-06 09:51:56.472777
dbcc60a8-6a22-420c-8559-2b6fb81f4a8d	Hippopotamus	Mammal	2025-11-06 09:51:56.472777
cbb028f0-fa98-4981-992f-ac13ee0f629b	Hornet	Insect	2025-11-06 09:51:56.472777
ef396826-012b-4ed7-b3d0-0ace60e0edc5	Horse	Mammal	2025-11-06 09:51:56.472777
28c6af82-811d-4872-80f5-d36ee182bdd5	Human	Mammal	2025-11-06 09:51:56.472777
632bc089-e389-4d77-a046-31f4f0ef28f3	Hummingbird	Bird	2025-11-06 09:51:56.472777
4af1c213-3fee-4e3b-81a8-115769017fa1	Hyena	Mammal	2025-11-06 09:51:56.472777
cfd00184-f3a2-421f-9e0e-75304eac1c3b	Ibex	Mammal	2025-11-06 09:51:56.472777
77aae96a-106a-4fc1-b067-79472acade73	Ibis	Bird	2025-11-06 09:51:56.472777
19972962-f4e2-4873-90e9-eded959bcd0f	Jackal	Mammal	2025-11-06 09:51:56.472777
15f08bf9-bba9-4c4b-b967-6d30afc13998	Jaguar	Mammal	2025-11-06 09:51:56.472777
c4dc6dfa-4ec1-49cb-8057-61d843d5b4e8	Jay	Bird	2025-11-06 09:51:56.472777
e0899278-4004-42b9-a52d-b10bbbae33cf	Jellyfish	Marine	2025-11-06 09:51:56.472777
1e150333-b9b6-4d22-b5ba-178cb60255b9	Kangaroo	Mammal	2025-11-06 09:51:56.472777
8eb40ca2-609a-473a-8e51-90e55a825b81	Kingfisher	Bird	2025-11-06 09:51:56.472777
525a9c27-9b8a-402b-825b-e5318063f8d5	Koala	Mammal	2025-11-06 09:51:56.472777
74b92fd8-afea-4408-9a78-65aed19d2ad2	Kookabura	Bird	2025-11-06 09:51:56.472777
13fc52b4-c4d5-4a2f-890b-60e2e1e28e2a	Kouprey	Mammal	2025-11-06 09:51:56.472777
a74587eb-3a8d-4ff3-8ef8-126b1ac5a3c3	Kudu	Mammal	2025-11-06 09:51:56.472777
c7c9fcd9-70ce-4ba4-b793-b9ea48ef94dd	Lapwing	Bird	2025-11-06 09:51:56.472777
8e16f05b-116f-4a2f-bb20-b77699903c50	Lark	Bird	2025-11-06 09:51:56.472777
ea10afc5-f2cd-44ba-9ea5-4c142e6e1cd4	Lemur	Mammal	2025-11-06 09:51:56.472777
7e670548-a682-43cc-abe8-f1a645fa91ad	Leopard	Mammal	2025-11-06 09:51:56.472777
aca79f3d-ef40-4140-87b4-169cb1895a12	Lion	Mammal	2025-11-06 09:51:56.472777
e8fd05ad-81eb-49dc-a38a-1e92f866dd80	Llama	Mammal	2025-11-06 09:51:56.472777
ea382b8e-8a6c-46c5-8a9e-1211831851bc	Lobster	Crustacean	2025-11-06 09:51:56.472777
dd171317-de7d-4ca6-ae79-757c2a8ad0f0	Locust	Insect	2025-11-06 09:51:56.472777
0b30e6dd-0b2b-4401-85e5-263562197f17	Loris	Mammal	2025-11-06 09:51:56.472777
2a687c5a-f4c3-44c6-8606-abc8c3de5780	Louse	Insect	2025-11-06 09:51:56.472777
64892f3f-6ac2-4b71-b41d-6a92f679603d	Lyrebird	Bird	2025-11-06 09:51:56.472777
1f73743f-12b0-4829-8399-f53b2ef8c992	Magpie	Bird	2025-11-06 09:51:56.472777
85d93abd-dc1b-42c7-934b-9691893b2e97	Mallard	Bird	2025-11-06 09:51:56.472777
b7dade18-89dd-4b8e-a09a-81f15072fad4	Manatee	Mammal	2025-11-06 09:51:56.472777
27fc4770-eea2-4eff-8d1c-e0bcda030930	Mandrill	Mammal	2025-11-06 09:51:56.472777
7cfc170c-deec-4c3a-8f15-97b6e2fb1963	Mantis	Insect	2025-11-06 09:51:56.472777
f0d147a9-1c12-4dc9-aeaf-7f5dfb03bf2a	Marten	Mammal	2025-11-06 09:51:56.472777
7ec459a5-e4c9-48f4-9f9a-e1f69e04c75e	Meerkat	Mammal	2025-11-06 09:51:56.472777
f22a7230-f718-4488-abe9-553aa8e619c6	Mink	Mammal	2025-11-06 09:51:56.472777
531eb9e4-5854-460c-a495-74e059109634	Mole	Mammal	2025-11-06 09:51:56.472777
9f49dada-ea75-4f69-b2f0-a59f6fcf5c01	Mongoose	Mammal	2025-11-06 09:51:56.472777
4df8b7c3-0274-4c93-9da4-20400b621b07	Monkey	Mammal	2025-11-06 09:51:56.472777
08d4457b-bd34-4c6e-aadd-bfe0e631c9e9	Moose	Mammal	2025-11-06 09:51:56.472777
f84dafb5-f1c8-4eab-9d24-077ce826e6e7	Mosquito	Insect	2025-11-06 09:51:56.472777
84143a9b-b690-4ac8-977a-d032a8115a91	Mouse	Mammal	2025-11-06 09:51:56.472777
88e3c169-a588-45ae-9d43-e3558a584f54	Mule	Mammal	2025-11-06 09:51:56.472777
bdab5a1f-39f1-414f-944c-1195ba6df0c3	Narwhal	Mammal	2025-11-06 09:51:56.472777
2e2a6faf-25ed-40c3-b116-5835bfdb2920	Newt	Amphibian	2025-11-06 09:51:56.472777
0a8688aa-e8fd-49d4-bcc7-4605252be7a6	Nightingale	Bird	2025-11-06 09:51:56.472777
81081d3c-9923-4235-ba85-8682dd21c56b	Octopus	Mollusk	2025-11-06 09:51:56.472777
52fa10e9-ee2e-4cfa-8465-409abee22e75	Okapi	Mammal	2025-11-06 09:51:56.472777
9647caef-7013-4a3f-925d-00dec89606bf	Opossum	Mammal	2025-11-06 09:51:56.472777
b0a661bd-7856-44a1-b7a5-b130ff3f18d1	Oryx	Mammal	2025-11-06 09:51:56.472777
88b2c9ee-d070-4904-b110-46f5ab7684d8	Ostrich	Bird	2025-11-06 09:51:56.472777
7ee8bc2e-7443-400b-b997-947d17c3c7e5	Otter	Mammal	2025-11-06 09:51:56.472777
4a5bfd5a-aebe-495a-8838-24e4c6e4b39f	Owl	Bird	2025-11-06 09:51:56.472777
a026bcf3-a2bc-4cd1-a6be-266a0a84513c	Oyster	Mollusk	2025-11-06 09:51:56.472777
7e73ee18-1900-42df-998b-427488a6ced4	Panther	Mammal	2025-11-06 09:51:56.472777
612ce78d-f5c3-4c12-b41f-bf285d20e833	Parrot	Bird	2025-11-06 09:51:56.472777
f5409939-7aa8-4830-a3eb-bcfab994abe7	Partridge	Bird	2025-11-06 09:51:56.472777
0b28dae8-3d6b-41de-9c05-692be6e9c4f2	Peafowl	Bird	2025-11-06 09:51:56.472777
01bfc9d6-9a07-48ca-afb6-b05b9aba2194	Pelican	Bird	2025-11-06 09:51:56.472777
99147984-11cd-49c4-bd5d-fc44f932dd6f	Penguin	Bird	2025-11-06 09:51:56.472777
0102f345-c773-4a1f-a448-eca72262b220	Pheasant	Bird	2025-11-06 09:51:56.472777
6be9b59f-7046-4ad9-b220-3599b9f0a676	Pig	Mammal	2025-11-06 09:51:56.472777
4604f4bf-1766-4418-8aca-075cc61982ec	Pigeon	Bird	2025-11-06 09:51:56.472777
aa703c82-0a03-44df-87d7-c3323f13c579	Pony	Mammal	2025-11-06 09:51:56.472777
432575d1-158d-48ff-83a3-9cf783c1f245	Porcupine	Mammal	2025-11-06 09:51:56.472777
178dc895-5f18-4768-a0d5-e7125d2b0a11	Porpoise	Mammal	2025-11-06 09:51:56.472777
6366e078-fd07-43cb-9ad7-0e9384853b8e	Quail	Bird	2025-11-06 09:51:56.472777
02dec541-4d3d-4380-a1e9-e1039f52bfc4	Quelea	Bird	2025-11-06 09:51:56.472777
acbc3450-0582-47d3-bc13-e21418b67d3e	Quetzal	Bird	2025-11-06 09:51:56.472777
3a79b58f-85d4-4758-b403-d3e916502796	Rabbit	Mammal	2025-11-06 09:51:56.472777
6d013052-4923-48de-807f-90bd02f5652f	Raccoon	Mammal	2025-11-06 09:51:56.472777
dfd87e0a-b8d3-4ea8-896f-5ba5965e690d	Rail	Bird	2025-11-06 09:51:56.472777
5cfd0c95-4b64-4606-9c73-0ee7504435bd	Ram	Mammal	2025-11-06 09:51:56.472777
b782b133-b755-48e6-bf27-938ad10f0a38	Rat	Mammal	2025-11-06 09:51:56.472777
54591f94-76ca-4fd5-afcf-deb3431db524	Raven	Bird	2025-11-06 09:51:56.472777
09eb88d8-0aef-4d74-a74e-4ce1a8812943	Red deer	Mammal	2025-11-06 09:51:56.472777
1aaa12b2-7de1-4ea4-9da5-10fdf041658a	Red panda	Mammal	2025-11-06 09:51:56.472777
e615bc6f-4e65-4c0f-98a5-45883a99dc14	Reindeer	Mammal	2025-11-06 09:51:56.472777
1255150a-8d2a-4dc0-994f-c83a902ebacf	Rhinoceros	Mammal	2025-11-06 09:51:56.472777
aacfaefb-e432-44ba-a278-2cf6ac24caf8	Rook	Bird	2025-11-06 09:51:56.472777
2a6d24f6-c51a-4ee1-9142-9cd7d8f1b247	Salamander	Amphibian	2025-11-06 09:51:56.472777
c3283e7b-d48f-4cbd-b5cd-c6c61b396e1f	Salmon	Fish	2025-11-06 09:51:56.472777
de112fa3-c0e2-4e83-b192-61ce56ffe21a	Sand Dollar	Echinoderm	2025-11-06 09:51:56.472777
45685ec9-56de-4cb1-9c21-d1fe8bfd8780	Sandpiper	Bird	2025-11-06 09:51:56.472777
a43eb4ca-e63b-4e6f-8094-4353e2d68586	Sardine	Fish	2025-11-06 09:51:56.472777
f9827c82-8fdc-4e7e-8598-8ee901792473	Scorpion	Arachnid	2025-11-06 09:51:56.472777
eed850d1-1ea1-469a-ab7e-a1ca073ad609	Seahorse	Fish	2025-11-06 09:51:56.472777
2f09d8e9-516b-4e8a-a616-fbb3d8c15ebd	Seal	Mammal	2025-11-06 09:51:56.472777
dd39f5ec-f325-4a4d-8cf5-8b1d994c3cfa	Shark	Fish	2025-11-06 09:51:56.472777
5fbe7b50-31d9-44bf-9058-05f3ef2f34cd	Sheep	Mammal	2025-11-06 09:51:56.472777
757653c4-9088-4933-bdae-e2b703303535	Shrew	Mammal	2025-11-06 09:51:56.472777
4222504f-236e-43c6-a876-394a1a88c0d6	Skunk	Mammal	2025-11-06 09:51:56.472777
93d8423d-bc0d-4454-a6c3-1ab1caddcecc	Snail	Mollusk	2025-11-06 09:51:56.472777
2c1c576f-c9d1-489a-93be-f2b8b33eeeee	Snake	Reptile	2025-11-06 09:51:56.472777
ada1cacc-0137-44d8-bfbf-5a386f19edba	Sparrow	Bird	2025-11-06 09:51:56.472777
ead89e09-8c41-4d49-9ff4-60e32bd1f3a9	Spider	Arachnid	2025-11-06 09:51:56.472777
b6cb8950-6824-473e-9132-7a0c8dfdfd7c	Spoonbill	Bird	2025-11-06 09:51:56.472777
1b56ab45-1ca6-498c-a4fc-d5e3178c346e	Squid	Mollusk	2025-11-06 09:51:56.472777
cd5fa347-2ed9-4840-873a-12ea47b2edf0	Squirrel	Mammal	2025-11-06 09:51:56.472777
bc9b4c07-4ac8-4ac3-ad41-25cb31d0d74d	Starling	Bird	2025-11-06 09:51:56.472777
9180e743-f3bd-4c26-9aaf-2a18718c8c01	Stingray	Fish	2025-11-06 09:51:56.472777
03379519-2d1f-41c3-b7fa-88c8b8b9ace6	Stinkbug	Insect	2025-11-06 09:51:56.472777
5c585e26-9878-43c4-affa-aad1094c3307	Stork	Bird	2025-11-06 09:51:56.472777
c8aa5061-082f-4479-91dd-f3d4500a14d7	Swallow	Bird	2025-11-06 09:51:56.472777
f65c5954-ce3c-4885-accb-7cda25d0d834	Swan	Bird	2025-11-06 09:51:56.472777
f1e9da33-8586-4a9c-8e09-694618c54f5b	Tapir	Mammal	2025-11-06 09:51:56.472777
58584886-d978-43c6-89d7-314e760bb5fc	Tarsier	Mammal	2025-11-06 09:51:56.472777
16bf6fad-e787-4545-8366-78e641bf01a2	Termite	Insect	2025-11-06 09:51:56.472777
23e19c8e-455b-4f0b-b915-608e5f3db719	Tiger	Mammal	2025-11-06 09:51:56.472777
ceb1463c-5b9f-4c8c-a841-02949bf153b2	Toad	Amphibian	2025-11-06 09:51:56.472777
4846e44d-da55-44a8-b377-062f3d98f521	Trout	Fish	2025-11-06 09:51:56.472777
8523b941-e641-4d38-b55a-33c51d35093c	Turkey	Bird	2025-11-06 09:51:56.472777
a14b1c50-c2ea-4964-96ff-699ed8ce8c97	Turtle	Reptile	2025-11-06 09:51:56.472777
ef05f5fd-c85c-4263-95ca-3f73c1061726	Viper	Reptile	2025-11-06 09:51:56.472777
33bdf01c-40d5-472c-9b0f-988c50d3c7f0	Vulture	Bird	2025-11-06 09:51:56.472777
f2891e31-9de3-462c-9267-354a662f3402	Wallaby	Mammal	2025-11-06 09:51:56.472777
3d3cbc8f-19f8-4684-b6e1-2dcdad44b5e4	Walrus	Mammal	2025-11-06 09:51:56.472777
43e5df24-a61a-4eea-a42c-70dabedde37d	Wasp	Insect	2025-11-06 09:51:56.472777
e8d944e8-c4b4-4af0-b825-321b71943d8e	Weasel	Mammal	2025-11-06 09:51:56.472777
87ec8a62-8cc1-4ab8-8bb2-519179b1e490	Whale	Mammal	2025-11-06 09:51:56.472777
49e27b5a-a7eb-4a4d-9cb9-e7cced13b318	Wildcat	Mammal	2025-11-06 09:51:56.472777
32c926a2-6123-404a-b6d1-69d94fedf9b2	Wolf	Mammal	2025-11-06 09:51:56.472777
7abe0e89-ed85-4d82-b1c5-e23e377700a8	Wolverine	Mammal	2025-11-06 09:51:56.472777
df8deec3-35e9-4e48-be43-bad32d9356a2	Wombat	Mammal	2025-11-06 09:51:56.472777
7994e90c-109a-4892-82fd-57f497a66e92	Woodcock	Bird	2025-11-06 09:51:56.472777
4ff1d474-a173-42eb-b113-83e06648871c	Woodpecker	Bird	2025-11-06 09:51:56.472777
b533dd2b-9bf1-4d72-b734-4e1c883d33c1	Worm	Invertebrate	2025-11-06 09:51:56.472777
1b1ea79f-fd9f-4fff-aaec-cff34d1cbd26	Wren	Bird	2025-11-06 09:51:56.472777
4c204d7e-2ff4-4c2f-99da-727d4ea98615	Yak	Mammal	2025-11-06 09:51:56.472777
4e3429f0-3b4b-4674-a0b3-c683c4dba7bd	Zebra	Mammal	2025-11-06 09:51:56.472777
\.


--
-- Data for Name: behavior_file; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.behavior_file (id, animal_id, behavior_type_id, note, created_at, is_deleted, deleted_at) FROM stdin;
d50e8400-e29b-41d4-a716-446655440001	650e8400-e29b-41d4-a716-446655440001	c50e8400-e29b-41d4-a716-446655440001	Max loves to play fetch and is great with kids	2025-11-06 09:58:49.256922	f	\N
d50e8400-e29b-41d4-a716-446655440002	650e8400-e29b-41d4-a716-446655440002	c50e8400-e29b-41d4-a716-446655440003	Whiskers is very active and loves to climb	2025-11-06 09:58:49.256922	f	\N
\.


--
-- Data for Name: behavior_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.behavior_type (id, name, description, created_at) FROM stdin;
c50e8400-e29b-41d4-a716-446655440001	Friendly	Animal is social	2025-11-06 09:58:49.251402
c50e8400-e29b-41d4-a716-446655440002	Shy	Animal needs time to warm up to strangers	2025-11-06 09:58:49.251402
c50e8400-e29b-41d4-a716-446655440003	Energetic	Animal is very active and playful	2025-11-06 09:58:49.251402
4d4c5ae0-eb72-4bd8-b2d6-943f4e52beff	Aggressive	Animal is aggressive	2025-11-06 11:36:32.718254
\.


--
-- Data for Name: campaign; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.campaign (id, title, description, goal_amount, status, start_date, end_date, created_at, is_deleted, deleted_at) FROM stdin;
e50e8400-e29b-41d4-a716-446655440001	Summer Care Initiative	Help us care for rescued animals during summer	5000	active	2025-11-06	2025-12-06	2025-11-06 09:58:49.263645	f	\N
e50e8400-e29b-41d4-a716-446655440002	Medical Equipment Fund	Raise funds for veterinary equipment	10000	active	2025-11-06	2026-01-05	2025-11-06 09:58:49.263645	f	\N
\.


--
-- Data for Name: donation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donation (id, amount, means, donator_id, is_deleted, campaign_id, donated_at, created_at, deleted_at) FROM stdin;
f50e8400-e29b-41d4-a716-446655440001	500	credit_card	550e8400-e29b-41d4-a716-446655440004	f	e50e8400-e29b-41d4-a716-446655440001	2025-11-06	2025-11-06 09:58:49.269217	\N
f50e8400-e29b-41d4-a716-446655440002	1000	bank_transfer	550e8400-e29b-41d4-a716-446655440003	f	e50e8400-e29b-41d4-a716-446655440002	2025-11-01	2025-11-06 09:58:49.269217	\N
\.


--
-- Data for Name: injury_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.injury_type (id, name, description, created_at) FROM stdin;
250e8400-e29b-41d4-a716-446655440001	Fracture	Broken bone	2025-11-06 09:58:49.290989
250e8400-e29b-41d4-a716-446655440002	Laceration	Deep cut or wound	2025-11-06 09:58:49.290989
250e8400-e29b-41d4-a716-446655440003	Burn	Heat-related injury	2025-11-06 09:58:49.290989
\.


--
-- Data for Name: medical_care; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_care (id, type_id, status, description, datetime, vet_id, medical_file_id, is_deleted, created_at, deleted_at) FROM stdin;
150e8400-e29b-41d4-a716-446655440001	050e8400-e29b-41d4-a716-446655440001	done	Regular check-up for Max	2025-10-22 09:58:49.282741	550e8400-e29b-41d4-a716-446655440002	750e8400-e29b-41d4-a716-446655440001	f	2025-11-06 09:58:49.282741	\N
150e8400-e29b-41d4-a716-446655440002	050e8400-e29b-41d4-a716-446655440003	upcoming	Dental cleaning scheduled for Whiskers	2025-11-16 09:58:49.282741	550e8400-e29b-41d4-a716-446655440002	750e8400-e29b-41d4-a716-446655440002	f	2025-11-06 09:58:49.282741	\N
\.


--
-- Data for Name: medical_care_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_care_type (id, name, description, created_at) FROM stdin;
050e8400-e29b-41d4-a716-446655440001	Check-up	General health examination	2025-11-06 09:58:49.276496
050e8400-e29b-41d4-a716-446655440002	Wound Treatment	Treatment for injuries and wounds	2025-11-06 09:58:49.276496
050e8400-e29b-41d4-a716-446655440003	Dental Cleaning	Professional tooth cleaning	2025-11-06 09:58:49.276496
\.


--
-- Data for Name: medical_file; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_file (id, vaccination_rate, description, animal_id, is_deleted, health_status, created_at, deleted_at) FROM stdin;
750e8400-e29b-41d4-a716-446655440001	75	Initial health check done	650e8400-e29b-41d4-a716-446655440001	f	healthy	2025-11-06 09:58:49.217927	\N
750e8400-e29b-41d4-a716-446655440002	60	Needs vaccination update	650e8400-e29b-41d4-a716-446655440002	f	healthy	2025-11-06 09:58:49.217927	\N
750e8400-e29b-41d4-a716-446655440003	100	Up to date on all vaccines	650e8400-e29b-41d4-a716-446655440003	f	healthy	2025-11-06 09:58:49.217927	\N
59e8787b-c7a0-4852-bb99-cdd681faa889	0	Needs health check up and vaccinations update, is injuried	7e6680b1-6728-4199-a5f1-0d77dd69028a	f	injured	2025-11-06 11:40:41.496796	\N
\.


--
-- Data for Name: medicine_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicine_type (id, name, description, created_at) FROM stdin;
350e8400-e29b-41d4-a716-446655440001	Antibiotics	For bacterial infections	2025-11-06 09:58:49.295533
350e8400-e29b-41d4-a716-446655440002	Pain Reliever	For pain management	2025-11-06 09:58:49.295533
350e8400-e29b-41d4-a716-446655440003	Anti-inflammatory	To reduce swelling	2025-11-06 09:58:49.295533
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, name, email, phone, password, role, is_deleted, deleted_at, created_at) FROM stdin;
550e8400-e29b-41d4-a716-446655440001	Admin User	admin@test.com	555-0001	hashed_password_123	admin	f	\N	2025-11-06 09:58:49.197556
550e8400-e29b-41d4-a716-446655440002	Dr. Sarah Vet	sarah.vet@test.com	555-0002	hashed_password_456	vet	f	\N	2025-11-06 09:58:49.197556
550e8400-e29b-41d4-a716-446655440003	John Volunteer	john@test.com	555-0003	hashed_password_789	volunteer	f	\N	2025-11-06 09:58:49.197556
550e8400-e29b-41d4-a716-446655440004	Jane Donor	jane.donor@test.com	555-0004	hashed_password_abc	user	f	\N	2025-11-06 09:58:49.197556
\.


--
-- Data for Name: vaccination; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vaccination (id, vaccine_id, status, description, datetime, vet_id, medical_file_id, is_deleted, created_at, deleted_at) FROM stdin;
a50e8400-e29b-41d4-a716-446655440001	950e8400-e29b-41d4-a716-446655440001	done	Rabies vaccination for Max	2025-10-07 09:58:49.23599	550e8400-e29b-41d4-a716-446655440002	750e8400-e29b-41d4-a716-446655440001	f	2025-11-06 09:58:49.23599	\N
a50e8400-e29b-41d4-a716-446655440002	950e8400-e29b-41d4-a716-446655440003	upcoming	Feline vaccine for Whiskers	2025-11-13 09:58:49.23599	550e8400-e29b-41d4-a716-446655440002	750e8400-e29b-41d4-a716-446655440002	f	2025-11-06 09:58:49.23599	\N
\.


--
-- Data for Name: vaccine_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vaccine_type (id, name, created_at) FROM stdin;
950e8400-e29b-41d4-a716-446655440001	Rabies	2025-11-06 09:58:49.229765
950e8400-e29b-41d4-a716-446655440002	DHPP (Dog)	2025-11-06 09:58:49.229765
950e8400-e29b-41d4-a716-446655440003	FVRCP (Cat)	2025-11-06 09:58:49.229765
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
-- Name: animal_type animal_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_type
    ADD CONSTRAINT animal_type_pk PRIMARY KEY (id);


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

\unrestrict Cw9XgJYjIKi2YIbQN997POZd6FqvTwPvmgj8KpPVaY2zliFdTU47sR6BcFVudOe

