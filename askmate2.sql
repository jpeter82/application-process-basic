--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.7
-- Dumped by pg_dump version 9.5.7

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: applicants_id_seq; Type: SEQUENCE; Schema: public; Owner: jpeter82
--

CREATE SEQUENCE applicants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE applicants_id_seq OWNER TO jpeter82;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: applicants; Type: TABLE; Schema: public; Owner: jpeter82
--

CREATE TABLE applicants (
    id integer DEFAULT nextval('applicants_id_seq'::regclass) NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    phone_number character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    application_code integer NOT NULL
);


ALTER TABLE applicants OWNER TO jpeter82;

--
-- Name: applicants_mentors; Type: TABLE; Schema: public; Owner: jpeter82
--

CREATE TABLE applicants_mentors (
    applicant_id integer NOT NULL,
    mentor_id integer NOT NULL,
    creation_date date DEFAULT ('now'::text)::date NOT NULL
);


ALTER TABLE applicants_mentors OWNER TO jpeter82;

--
-- Name: mentors_id_seq; Type: SEQUENCE; Schema: public; Owner: jpeter82
--

CREATE SEQUENCE mentors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mentors_id_seq OWNER TO jpeter82;

--
-- Name: mentors; Type: TABLE; Schema: public; Owner: jpeter82
--

CREATE TABLE mentors (
    id integer DEFAULT nextval('mentors_id_seq'::regclass) NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    nick_name character varying(255),
    phone_number character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    favourite_number integer
);


ALTER TABLE mentors OWNER TO jpeter82;

--
-- Name: schools_id_seq; Type: SEQUENCE; Schema: public; Owner: jpeter82
--

CREATE SEQUENCE schools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE schools_id_seq OWNER TO jpeter82;

--
-- Name: schools; Type: TABLE; Schema: public; Owner: jpeter82
--

CREATE TABLE schools (
    id integer DEFAULT nextval('schools_id_seq'::regclass) NOT NULL,
    name character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    country character varying(255) NOT NULL,
    contact_person integer
);


ALTER TABLE schools OWNER TO jpeter82;

--
-- Name: solution1; Type: VIEW; Schema: public; Owner: jpeter82
--

CREATE VIEW solution1 AS
 SELECT m.first_name,
    m.last_name,
    s.name,
    s.country
   FROM (mentors m
     JOIN schools s ON (((m.city)::text = (s.city)::text)))
  ORDER BY m.id;


ALTER TABLE solution1 OWNER TO jpeter82;

--
-- Name: solution2; Type: VIEW; Schema: public; Owner: jpeter82
--

CREATE VIEW solution2 AS
 SELECT m.first_name,
    m.last_name,
    s.name,
    s.country
   FROM (schools s
     LEFT JOIN mentors m ON (((m.city)::text = (s.city)::text)))
  ORDER BY m.id;


ALTER TABLE solution2 OWNER TO jpeter82;

--
-- Name: solution3; Type: VIEW; Schema: public; Owner: jpeter82
--

CREATE VIEW solution3 AS
 SELECT s.country,
    count(*) AS count
   FROM (schools s
     LEFT JOIN mentors m ON (((m.city)::text = (s.city)::text)))
  GROUP BY s.country
  ORDER BY s.country;


ALTER TABLE solution3 OWNER TO jpeter82;

--
-- Name: solution4; Type: VIEW; Schema: public; Owner: jpeter82
--

CREATE VIEW solution4 AS
 SELECT s.name,
    m.first_name,
    m.last_name
   FROM (schools s
     JOIN mentors m ON ((m.id = s.contact_person)))
  ORDER BY s.name;


ALTER TABLE solution4 OWNER TO jpeter82;

--
-- Name: solution5; Type: VIEW; Schema: public; Owner: jpeter82
--

CREATE VIEW solution5 AS
 SELECT a.first_name,
    a.application_code,
    am.creation_date
   FROM (applicants a
     JOIN applicants_mentors am ON ((a.id = am.applicant_id)))
  WHERE (am.creation_date > '2016-01-01'::date)
  ORDER BY am.creation_date DESC;


ALTER TABLE solution5 OWNER TO jpeter82;

--
-- Name: solution6; Type: VIEW; Schema: public; Owner: jpeter82
--

CREATE VIEW solution6 AS
 SELECT a.first_name AS applicant_first_name,
    a.application_code,
    COALESCE(m.first_name, 'None'::character varying) AS mentor_first_name,
    COALESCE(m.last_name, 'None'::character varying) AS mentor_last_name
   FROM ((applicants a
     LEFT JOIN applicants_mentors am ON ((a.id = am.applicant_id)))
     LEFT JOIN mentors m ON ((m.id = am.mentor_id)))
  ORDER BY a.id;


ALTER TABLE solution6 OWNER TO jpeter82;

--
-- Data for Name: applicants; Type: TABLE DATA; Schema: public; Owner: jpeter82
--

COPY applicants (id, first_name, last_name, phone_number, email, application_code) FROM stdin;
1	Dominique	Williams	003630/734-4926	dolor@laoreet.co.uk	61823
2	Jemima	Foreman	003620/834-6898	magna@etultrices.net	58324
3	Zeph	Massey	003630/216-5351	a.feugiat.tellus@montesnasceturridiculus.co.uk	61349
4	Joseph	Crawford	003670/923-2669	lacinia.mattis@arcu.co.uk	12916
5	Ifeoma	Bird	003630/465-8994	diam.duis.mi@orcitinciduntadipiscing.com	65603
6	Arsenio	Matthews	003620/804-1652	semper.pretium.neque@mauriseu.net	39220
7	Jemima	Cantu	003620/423-4261	et.risus.quisque@mollis.co.uk	10384
8	Carol	Arnold	003630/179-1827	dapibus.rutrum@litoratorquent.com	70730
9	Jane	Forbes	003670/653-5392	janiebaby@adipiscingenimmi.edu	56882
10	Ursa	William	003620/496-7064	malesuada@mauriseu.net	91220
\.


--
-- Name: applicants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jpeter82
--

SELECT pg_catalog.setval('applicants_id_seq', 10, true);


--
-- Data for Name: applicants_mentors; Type: TABLE DATA; Schema: public; Owner: jpeter82
--

COPY applicants_mentors (applicant_id, mentor_id, creation_date) FROM stdin;
1	1	2015-09-28
2	1	2015-10-10
3	2	2015-10-11
4	3	2015-10-11
5	4	2016-01-10
6	5	2016-03-01
7	5	2016-03-12
8	6	2016-04-11
9	7	2016-05-23
\.


--
-- Data for Name: mentors; Type: TABLE DATA; Schema: public; Owner: jpeter82
--

COPY mentors (id, first_name, last_name, nick_name, phone_number, email, city, favourite_number) FROM stdin;
1	Attila	Molnár	Atesz	003670/630-0539	attila.molnar@codecool.com	Budapest	23
2	Pál	Monoczki	Pali	003630/327-2663	pal.monoczki@codecool.com	Miskolc	\N
3	Sándor	Szodoray	Szodi	003620/519-9152	sandor.szodoray@codecool.com	Miskolc	7
4	Dániel	Salamon	Dani	003620/508-0706	daniel.salamon@codecool.com	Budapest	4
5	Miklós	Beöthy	Miki	003630/256-8118	miklos.beothy@codecool.com	Budapest	42
6	Tamás	Tompa	Tomi	003630/370-0748	tamas.tompa@codecool.com	Budapest	42
7	Mateusz	Ostafil	Mateusz	003648/518-664-923	mateusz.ostafil@codecool.com	Krakow	13
8	Anikó	Fenyvesi	Anikó	003670/111-2222	aniko.fenyvesi@codecool.com	Budapest	11
9	Immánuel	Fodor	Immi	003620/123-6234	immanuel.fodor@codecool.com	Budapest	3
10	László	Molnár	Laci	003620/222-5566	laszlo.molnar@codecool.com	Budapest	5
11	Mátyás	Forián Szabó	Matyi	003630/111-5532	matyas.forian.szabo@codecool.com	Budapest	90
12	Zoltán	Sallay	Zozi	003670/898-3122	zoltan.sallay@codecool.com	Budapest	5
13	Szilveszter	Erdős	Sly	003620/444-5555	szilveszter.erdos@codecool.com	Budapest	13
14	László	Terray	Laci	003670/402-2435	laszlo.terray@codecool.com	Budapest	8
15	Árpád	Törzsök	Árpád	003630/222-1221	arpad.torzsok@codecool.com	Budapest	9
16	Imre	Lindi	Imi	003670/222-1233	imre.lindi@codecool.com	Miskolc	3
17	Róbert	Kohányi	Robi	003630/123-5553	robert.kohanyi@codecool.com	Miskolc	\N
18	Przemysław	Ciąćka	Przemek	003670/222-4554	przemyslaw.ciacka@codecool.com	Krakow	55
19	Marcin	Izworski	Marcin	003670/999-2323	marcin.izworski@codecool.com	Krakow	55
20	Rafał	Stępień	Rafal	003630/323-5343	rafal.stepien@codecool.com	Krakow	3
21	Agnieszka	Koszany	Agi	003630/111-5343	agnieszka.koszany@codecool.com	Krakow	77
22	Mateusz	Steliga	Mateusz	003630/123-5343	mateusz.steliga@codecool.com	Krakow	5
\.


--
-- Name: mentors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jpeter82
--

SELECT pg_catalog.setval('mentors_id_seq', 22, true);


--
-- Data for Name: schools; Type: TABLE DATA; Schema: public; Owner: jpeter82
--

COPY schools (id, name, city, country, contact_person) FROM stdin;
1	Codecool Msc	Miskolc	Hungary	1
2	Codecool BP	Budapest	Hungary	4
3	Codecool Krak	Krakow	Poland	7
4	Codecool Wars	Warsaw	Poland	\N
\.


--
-- Name: schools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jpeter82
--

SELECT pg_catalog.setval('schools_id_seq', 4, true);


--
-- Name: applicant_pk; Type: CONSTRAINT; Schema: public; Owner: jpeter82
--

ALTER TABLE ONLY applicants
    ADD CONSTRAINT applicant_pk PRIMARY KEY (id);


--
-- Name: applicants_mentors_pk; Type: CONSTRAINT; Schema: public; Owner: jpeter82
--

ALTER TABLE ONLY applicants_mentors
    ADD CONSTRAINT applicants_mentors_pk PRIMARY KEY (applicant_id, mentor_id);


--
-- Name: application_code_uk; Type: CONSTRAINT; Schema: public; Owner: jpeter82
--

ALTER TABLE ONLY applicants
    ADD CONSTRAINT application_code_uk UNIQUE (application_code);


--
-- Name: mentors_pk; Type: CONSTRAINT; Schema: public; Owner: jpeter82
--

ALTER TABLE ONLY mentors
    ADD CONSTRAINT mentors_pk PRIMARY KEY (id);


--
-- Name: schools_pk; Type: CONSTRAINT; Schema: public; Owner: jpeter82
--

ALTER TABLE ONLY schools
    ADD CONSTRAINT schools_pk PRIMARY KEY (id);


--
-- Name: applicants_mentors_applicant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jpeter82
--

ALTER TABLE ONLY applicants_mentors
    ADD CONSTRAINT applicants_mentors_applicant_id_fkey FOREIGN KEY (applicant_id) REFERENCES applicants(id);


--
-- Name: applicants_mentors_mentor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jpeter82
--

ALTER TABLE ONLY applicants_mentors
    ADD CONSTRAINT applicants_mentors_mentor_id_fkey FOREIGN KEY (mentor_id) REFERENCES mentors(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

