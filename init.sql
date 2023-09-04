--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Homebrew)
-- Dumped by pg_dump version 14.9 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: geonames; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE geonames WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C';


\connect geonames

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin1_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin1_codes (
    country_code character varying(2) NOT NULL,
    admin1_code character varying(10) NOT NULL,
    admin1_name character varying(50) NOT NULL,
    admin1_name_ascii character varying(50) NOT NULL,
    geoname_id integer NOT NULL
);


--
-- Name: admin2_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin2_codes (
    country_code character varying(2) NOT NULL,
    admin1_code character varying(10) NOT NULL,
    admin2_code character varying(10) NOT NULL,
    admin2_name character varying(100),
    admin2_name_ascii character varying(100),
    geoname_id integer
);


--
-- Name: alt_names; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alt_names (
    alt_name_id integer NOT NULL,
    geoname_id integer,
    iso_language character varying(7),
    alt_name character varying(400) NOT NULL,
    is_preferred boolean,
    is_short boolean,
    is_colloquial boolean,
    is_historic boolean,
    "from" character varying(20),
    "to" character varying(20)
);


--
-- Name: country_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.country_info (
    iso character varying(2) NOT NULL,
    iso3 character varying(3),
    iso_numeric character varying(3),
    fips character varying(2),
    country character varying(50) NOT NULL,
    capital character varying(30),
    area_in_sq_km real NOT NULL,
    population integer NOT NULL,
    continent character varying(2) NOT NULL,
    tld character varying(3),
    currency_code character varying(3),
    currency_name character varying(30),
    phone_prefix character varying(30),
    post_code_format character varying(60),
    post_code_regex character varying(200),
    languages character varying(100),
    geoname_id integer NOT NULL,
    neighbours character varying(50),
    eq_fips_code character varying(3)
);


--
-- Name: feature_classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feature_classes (
    feature_class character(1),
    feature_class_description character varying(100)
);


--
-- Name: feature_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feature_codes (
    feature_class character varying(1) NOT NULL,
    feature_code character varying(7) NOT NULL,
    feature_name character varying(50) NOT NULL,
    feature_description character varying(500)
);


--
-- Name: geonames; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geonames (
    geoname_id integer NOT NULL,
    geoname character varying(200),
    asciiname character varying(200),
    latitude numeric(7,5),
    longitude numeric(8,5),
    feature_class character(1),
    feature_code character varying(10),
    country_code character varying(2),
    alt_country_code character varying(200),
    admin1_code character varying(20),
    admin2_code character varying(80),
    admin3_code character varying(20),
    admin4_code character varying(20),
    population bigint,
    elevation integer,
    dem integer,
    timezone character varying(40),
    gn_modification_date date
);


--
-- Name: hierarchy; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hierarchy (
    parent_gnid integer NOT NULL,
    child_gnid integer NOT NULL,
    hierarchy_type character varying(50)
);


--
-- Name: iso_language_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.iso_language_codes (
    iso_639_3 character varying(3),
    iso_639_2 character varying(20),
    iso_639_1 character varying(2),
    language character varying(60) NOT NULL
);


--
-- Name: timezones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timezones (
    country_code character varying(2) NOT NULL,
    timezone_id character varying(50) NOT NULL,
    gmt_offset_01jan23 real NOT NULL,
    dst_offset_01jul23 real NOT NULL,
    raw_offset real NOT NULL
);


--
-- Name: user_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_tags (
    geoname_id integer,
    tag character varying(100)
);


--
-- Name: admin1_codes admin1_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin1_codes
    ADD CONSTRAINT admin1_codes_pkey PRIMARY KEY (country_code, admin1_code);


--
-- Name: admin2_codes admin2_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin2_codes
    ADD CONSTRAINT admin2_codes_pkey PRIMARY KEY (country_code, admin1_code, admin2_code);


--
-- Name: alt_names alt_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alt_names
    ADD CONSTRAINT alt_names_pkey PRIMARY KEY (alt_name_id);


--
-- Name: country_info country_info_country_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.country_info
    ADD CONSTRAINT country_info_country_key UNIQUE (country);


--
-- Name: country_info country_info_fips_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.country_info
    ADD CONSTRAINT country_info_fips_key UNIQUE (fips);


--
-- Name: country_info country_info_geoname_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.country_info
    ADD CONSTRAINT country_info_geoname_id_key UNIQUE (geoname_id);


--
-- Name: country_info country_info_iso3_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.country_info
    ADD CONSTRAINT country_info_iso3_key UNIQUE (iso3);


--
-- Name: country_info country_info_iso_numeric_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.country_info
    ADD CONSTRAINT country_info_iso_numeric_key UNIQUE (iso_numeric);


--
-- Name: country_info country_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.country_info
    ADD CONSTRAINT country_info_pkey PRIMARY KEY (iso);


--
-- Name: feature_classes feature_classes_feature_class_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_classes
    ADD CONSTRAINT feature_classes_feature_class_key UNIQUE (feature_class);


--
-- Name: feature_codes feature_codes_feature_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_codes
    ADD CONSTRAINT feature_codes_feature_code_key UNIQUE (feature_code);


--
-- Name: feature_codes feature_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_codes
    ADD CONSTRAINT feature_codes_pkey PRIMARY KEY (feature_class, feature_name);


--
-- Name: geonames geonames_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geonames
    ADD CONSTRAINT geonames_pkey PRIMARY KEY (geoname_id);


--
-- Name: hierarchy hierarchy_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hierarchy
    ADD CONSTRAINT hierarchy_pkey PRIMARY KEY (parent_gnid, child_gnid);


--
-- Name: iso_language_codes iso_language_codes_iso_639_1_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.iso_language_codes
    ADD CONSTRAINT iso_language_codes_iso_639_1_key UNIQUE (iso_639_1);


--
-- Name: iso_language_codes iso_language_codes_iso_639_2_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.iso_language_codes
    ADD CONSTRAINT iso_language_codes_iso_639_2_key UNIQUE (iso_639_2);


--
-- Name: iso_language_codes iso_language_codes_iso_639_3_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.iso_language_codes
    ADD CONSTRAINT iso_language_codes_iso_639_3_key UNIQUE (iso_639_3);


--
-- Name: timezones timezones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timezones
    ADD CONSTRAINT timezones_pkey PRIMARY KEY (timezone_id);


--
-- Name: admin2_codes admin2_codes_country_code_admin1_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin2_codes
    ADD CONSTRAINT admin2_codes_country_code_admin1_code_fkey FOREIGN KEY (country_code, admin1_code) REFERENCES public.admin1_codes(country_code, admin1_code);


--
-- Name: alt_names alt_names_geoname_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alt_names
    ADD CONSTRAINT alt_names_geoname_id_fkey FOREIGN KEY (geoname_id) REFERENCES public.geonames(geoname_id);


--
-- Name: feature_codes feature_codes_feature_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_codes
    ADD CONSTRAINT feature_codes_feature_class_fkey FOREIGN KEY (feature_class) REFERENCES public.feature_classes(feature_class);


--
-- PostgreSQL database dump complete
--

