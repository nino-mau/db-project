SET
  statement_timeout = 0;

SET
  lock_timeout = 0;

SET
  idle_in_transaction_session_timeout = 0;

SET
  transaction_timeout = 0;

SET
  client_encoding = 'UTF8';

SET
  standard_conforming_strings = on;

SELECT
  pg_catalog.set_config ('search_path', '', false);

SET
  check_function_bodies = false;

SET
  xmloption = content;

SET
  client_min_messages = warning;

SET
  row_security = off;

ALTER TABLE ONLY public.visit
DROP CONSTRAINT visit_visitor_id_fkey;

ALTER TABLE ONLY public.visit
DROP CONSTRAINT visit_adoption_file_id_fkey;

ALTER TABLE ONLY public.vaccination
DROP CONSTRAINT vaccination_vaccine_fk;

ALTER TABLE ONLY public.vaccination
DROP CONSTRAINT vaccination_user_fk;

ALTER TABLE ONLY public.vaccination
DROP CONSTRAINT vaccination_medical_file_id_fkey;

ALTER TABLE ONLY public.medical_file
DROP CONSTRAINT medical_file_animal_id_fkey;

ALTER TABLE ONLY public.medical_care
DROP CONSTRAINT medical_care_user_fk;

ALTER TABLE ONLY public.medical_care
DROP CONSTRAINT medical_care_medical_file_id_fkey;

ALTER TABLE ONLY public.medical_care
DROP CONSTRAINT medical_care_medical_care_type_fk;

ALTER TABLE ONLY public.donation
DROP CONSTRAINT donation_donator_id_fkey;

ALTER TABLE ONLY public.animal_race
DROP CONSTRAINT animal_race_animal_specie_fk;

ALTER TABLE ONLY public.animal
DROP CONSTRAINT animal_animal_specie_fk;

ALTER TABLE ONLY public.adoption_request
DROP CONSTRAINT adoption_request_requester_id_fkey;

ALTER TABLE ONLY public.adoption_request
DROP CONSTRAINT adoption_request_adoption_file_id_fkey;

ALTER TABLE ONLY public.adoption_file
DROP CONSTRAINT adoption_file_animal_id_fkey;

DROP INDEX public.user_phone_idx;

DROP INDEX public.user_password_idx;

DROP INDEX public.user_name_idx;

DROP INDEX public.user_email_idx;

DROP INDEX public.medical_file_animal_id_idx;

DROP INDEX public.animal_specie_idx;

DROP INDEX public.animal_race_idx;

DROP INDEX public.animal_name_idx;

DROP INDEX public.animal_age_idx;

DROP INDEX public.adoption_file_animal_id_idx;

ALTER TABLE ONLY public.visit
DROP CONSTRAINT visit_pkey;

ALTER TABLE ONLY public.vaccine
DROP CONSTRAINT vaccine_pk;

ALTER TABLE ONLY public.vaccination
DROP CONSTRAINT vaccination_pkey;

ALTER TABLE ONLY public."user"
DROP CONSTRAINT user_pkey;

ALTER TABLE ONLY public.medical_file
DROP CONSTRAINT medical_file_pkey;

ALTER TABLE ONLY public.medical_care_type
DROP CONSTRAINT medical_care_type_pk;

ALTER TABLE ONLY public.medical_care
DROP CONSTRAINT medical_care_pkey;

ALTER TABLE ONLY public.donation
DROP CONSTRAINT donation_pkey;

ALTER TABLE ONLY public.animal_specie
DROP CONSTRAINT animal_specie_pk;

ALTER TABLE ONLY public.animal_race
DROP CONSTRAINT animal_race_pk;

ALTER TABLE ONLY public.animal
DROP CONSTRAINT animal_pkey;

ALTER TABLE ONLY public.adoption_request
DROP CONSTRAINT adoption_request_pkey;

ALTER TABLE ONLY public.adoption_file
DROP CONSTRAINT adoption_file_pkey;

ALTER TABLE public.visit
ALTER COLUMN created_at
DROP DEFAULT;

ALTER TABLE public.vaccine
ALTER COLUMN created_at
DROP DEFAULT;

ALTER TABLE public.vaccination
ALTER COLUMN created_at
DROP DEFAULT;

ALTER TABLE public."user"
ALTER COLUMN created_at
DROP DEFAULT;

ALTER TABLE public.medical_file
ALTER COLUMN created_at
DROP DEFAULT;

ALTER TABLE public.medical_care_type
ALTER COLUMN created_at
DROP DEFAULT;

ALTER TABLE public.medical_care
ALTER COLUMN created_at
DROP DEFAULT;

ALTER TABLE public.donation
ALTER COLUMN created_at
DROP DEFAULT;

ALTER TABLE public.animal_specie
ALTER COLUMN created_at
DROP DEFAULT;

ALTER TABLE public.animal_race
ALTER COLUMN created_at
DROP DEFAULT;

ALTER TABLE public.animal
ALTER COLUMN created_at
DROP DEFAULT;

ALTER TABLE public.adoption_request
ALTER COLUMN created_at
DROP DEFAULT;

ALTER TABLE public.adoption_file
ALTER COLUMN created_at
DROP DEFAULT;

DROP TABLE public.visit;

DROP TABLE public.vaccine;

DROP TABLE public.vaccination;

DROP TABLE public."user";

DROP TABLE public.medical_file;

DROP TABLE public.medical_care_type;

DROP TABLE public.medical_care;

DROP TABLE public.donation;

DROP TABLE public.animal_specie;

DROP TABLE public.animal_race;

DROP TABLE public.animal;

DROP TABLE public.adoption_request;

DROP TABLE public.adoption_file;

DROP TABLE public.base_timestamp;

DROP TYPE public.vaccination_status_enum;

DROP TYPE public.user_role_enum;

DROP TYPE public.medical_care_status_enum;

DROP TYPE public.animal_sex_enum;

DROP TYPE public.adoption_request_status_enum;
