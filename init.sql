--
-- PostgreSQL database dump
--

\restrict KqOKSNxfdULddWUoaN4euh1zQ7QUjevEZIGB0vu2xZIOAxcAN7iFfkRTICBW58e

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
    id text NOT NULL,
    vaccination_rate integer NOT NULL,
    description text,
    animal_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.adoption_file OWNER TO postgres;

--
-- Name: adoption_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adoption_request (
    id text NOT NULL,
    status public.adoption_request_status_enum NOT NULL,
    description text,
    requester_note text,
    refusal_note text,
    pickup_datetime timestamp without time zone,
    requester_id text NOT NULL,
    adoption_file_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.adoption_request OWNER TO postgres;

--
-- Name: animal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animal (
    id text NOT NULL,
    name text NOT NULL,
    age integer NOT NULL,
    sex public.animal_sex_enum NOT NULL,
    picture_url text,
    specie_id text NOT NULL,
    race_id text NOT NULL,
    description text,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.animal OWNER TO postgres;

--
-- Name: animal_race; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animal_race (
    id text NOT NULL,
    name text NOT NULL,
    specie_id text NOT NULL
);


ALTER TABLE public.animal_race OWNER TO postgres;

--
-- Name: animal_specie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animal_specie (
    id text NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.animal_specie OWNER TO postgres;

--
-- Name: donation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donation (
    id text NOT NULL,
    amount integer NOT NULL,
    means text,
    donator_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.donation OWNER TO postgres;

--
-- Name: medical_care; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_care (
    id text NOT NULL,
    type_id text NOT NULL,
    status public.medical_care_status_enum NOT NULL,
    description text,
    datetime timestamp without time zone,
    vet_id text NOT NULL,
    medical_file_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.medical_care OWNER TO postgres;

--
-- Name: medical_care_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_care_type (
    id text NOT NULL,
    name text NOT NULL,
    description text
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
    id text NOT NULL,
    vaccination_rate integer NOT NULL,
    description text,
    animal_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.medical_file OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone text,
    password text NOT NULL,
    role public.user_role_enum NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: vaccination; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vaccination (
    id text NOT NULL,
    vaccine_id text NOT NULL,
    status public.vaccination_status_enum NOT NULL,
    description text,
    datetime timestamp without time zone,
    vet_id text NOT NULL,
    medical_file_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.vaccination OWNER TO postgres;

--
-- Name: vaccine; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vaccine (
    id text NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.vaccine OWNER TO postgres;

--
-- Name: TABLE vaccine; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.vaccine IS 'Type of vaccine';


--
-- Name: visit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visit (
    id text NOT NULL,
    description text,
    datetime timestamp without time zone,
    visitor_id text NOT NULL,
    adoption_file_id text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
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

COPY public.adoption_file (id, vaccination_rate, description, animal_id, is_deleted) FROM stdin;
\.


--
-- Data for Name: adoption_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adoption_request (id, status, description, requester_note, refusal_note, pickup_datetime, requester_id, adoption_file_id, is_deleted) FROM stdin;
\.


--
-- Data for Name: animal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animal (id, name, age, sex, picture_url, specie_id, race_id, description, is_deleted) FROM stdin;
\.


--
-- Data for Name: animal_race; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animal_race (id, name, specie_id) FROM stdin;
\.


--
-- Data for Name: animal_specie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animal_specie (id, name) FROM stdin;
\.


--
-- Data for Name: donation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donation (id, amount, means, donator_id, is_deleted) FROM stdin;
\.


--
-- Data for Name: medical_care; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_care (id, type_id, status, description, datetime, vet_id, medical_file_id, is_deleted) FROM stdin;
\.


--
-- Data for Name: medical_care_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_care_type (id, name, description) FROM stdin;
\.


--
-- Data for Name: medical_file; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_file (id, vaccination_rate, description, animal_id, is_deleted) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, name, email, phone, password, role, is_deleted) FROM stdin;
\.


--
-- Data for Name: vaccination; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vaccination (id, vaccine_id, status, description, datetime, vet_id, medical_file_id, is_deleted) FROM stdin;
\.


--
-- Data for Name: vaccine; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vaccine (id, name) FROM stdin;
\.


--
-- Data for Name: visit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visit (id, description, datetime, visitor_id, adoption_file_id, is_deleted) FROM stdin;
\.


--
-- Name: adoption_file adoption_file_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoption_file
    ADD CONSTRAINT adoption_file_pkey PRIMARY KEY (id);


--
-- Name: adoption_request adoption_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoption_request
    ADD CONSTRAINT adoption_request_pkey PRIMARY KEY (id);


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
-- Name: animal_specie animal_specie_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_specie
    ADD CONSTRAINT animal_specie_pk PRIMARY KEY (id);


--
-- Name: donation donation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation
    ADD CONSTRAINT donation_pkey PRIMARY KEY (id);


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
-- Name: vaccine vaccine_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaccine
    ADD CONSTRAINT vaccine_pk PRIMARY KEY (id);


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
-- Name: animal_age_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX animal_age_idx ON public.animal USING btree (age);


--
-- Name: animal_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX animal_name_idx ON public.animal USING btree (name);


--
-- Name: animal_race_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX animal_race_idx ON public.animal USING btree (race_id);


--
-- Name: animal_specie_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX animal_specie_idx ON public.animal USING btree (specie_id);


--
-- Name: medical_file_animal_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX medical_file_animal_id_idx ON public.medical_file USING btree (animal_id);


--
-- Name: user_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_email_idx ON public."user" USING btree (email);


--
-- Name: user_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_name_idx ON public."user" USING btree (name);


--
-- Name: user_password_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_password_idx ON public."user" USING btree (password);


--
-- Name: user_phone_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_phone_idx ON public."user" USING btree (phone);


--
-- Name: adoption_file adoption_file_animal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoption_file
    ADD CONSTRAINT adoption_file_animal_id_fkey FOREIGN KEY (animal_id) REFERENCES public.animal(id);


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
-- Name: animal animal_animal_specie_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal
    ADD CONSTRAINT animal_animal_specie_fk FOREIGN KEY (specie_id) REFERENCES public.animal_specie(id);


--
-- Name: animal_race animal_race_animal_specie_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_race
    ADD CONSTRAINT animal_race_animal_specie_fk FOREIGN KEY (specie_id) REFERENCES public.animal_specie(id);


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
    ADD CONSTRAINT vaccination_vaccine_fk FOREIGN KEY (vaccine_id) REFERENCES public.vaccine(id);


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

\unrestrict KqOKSNxfdULddWUoaN4euh1zQ7QUjevEZIGB0vu2xZIOAxcAN7iFfkRTICBW58e


