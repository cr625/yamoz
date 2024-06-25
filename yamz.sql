--
-- PostgreSQL database dump
--

-- Dumped from database version 12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)

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
-- Name: yamz; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE yamz WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE yamz OWNER TO postgres;

\connect yamz

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
-- Name: status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status AS ENUM (
    'archived',
    'published',
    'draft'
);


ALTER TYPE public.status OWNER TO postgres;

--
-- Name: term_class; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.term_class AS ENUM (
    'vernacular',
    'canonical',
    'deprecated'
);


ALTER TYPE public.term_class OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    owner_id integer,
    term_id integer,
    created timestamp without time zone,
    modified timestamp without time zone,
    comment_string text,
    comment_string_html text
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    sender_id integer,
    recipient_id integer,
    body character varying(140),
    "timestamp" timestamp without time zone,
    sent boolean
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.messages_id_seq OWNER TO postgres;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    name character varying(128),
    user_id integer,
    "timestamp" timestamp without time zone,
    payload_json text
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: relationships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relationships (
    id integer NOT NULL,
    parent_id integer,
    child_id integer,
    predicate character varying(64),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.relationships OWNER TO postgres;

--
-- Name: relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.relationships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relationships_id_seq OWNER TO postgres;

--
-- Name: relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.relationships_id_seq OWNED BY public.relationships.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    user_id integer,
    "timestamp" timestamp without time zone,
    category text,
    value text,
    description text
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: term_sets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.term_sets (
    set_id integer,
    term_id integer
);


ALTER TABLE public.term_sets OWNER TO postgres;

--
-- Name: term_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.term_tags (
    tag_id integer,
    term_id integer
);


ALTER TABLE public.term_tags OWNER TO postgres;

--
-- Name: terms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.terms (
    id integer NOT NULL,
    ark_id integer,
    shoulder character varying(64),
    naan character varying(64),
    owner_id integer,
    created timestamp without time zone,
    modified timestamp without time zone,
    term_string text,
    definition text,
    examples text,
    concept_id character varying(64),
    status public.status,
    class public.term_class,
    definition_html text,
    examples_html text,
    search_vector tsvector
);


ALTER TABLE public.terms OWNER TO postgres;

--
-- Name: terms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.terms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.terms_id_seq OWNER TO postgres;

--
-- Name: terms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.terms_id_seq OWNED BY public.terms.id;


--
-- Name: termsets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.termsets (
    id integer NOT NULL,
    source text,
    description text,
    created timestamp without time zone,
    updated timestamp without time zone,
    user_id integer,
    name text,
    ark_id integer
);


ALTER TABLE public.termsets OWNER TO postgres;

--
-- Name: termsets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.termsets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.termsets_id_seq OWNER TO postgres;

--
-- Name: termsets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.termsets_id_seq OWNED BY public.termsets.id;


--
-- Name: tracking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tracking (
    user_id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.tracking OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    authority character varying(64) NOT NULL,
    auth_id character varying(64) NOT NULL,
    last_name character varying(64) NOT NULL,
    first_name character varying(64) NOT NULL,
    email character varying(64) NOT NULL,
    orcid character varying(64),
    reputation integer,
    enotify boolean,
    super_user boolean,
    last_message_read_time timestamp without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.votes (
    user_id integer NOT NULL,
    term_id integer NOT NULL,
    vote integer NOT NULL
);


ALTER TABLE public.votes OWNER TO postgres;

--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: relationships id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relationships ALTER COLUMN id SET DEFAULT nextval('public.relationships_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: terms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.terms ALTER COLUMN id SET DEFAULT nextval('public.terms_id_seq'::regclass);


--
-- Name: termsets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.termsets ALTER COLUMN id SET DEFAULT nextval('public.termsets_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
cb747e25aff8
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, owner_id, term_id, created, modified, comment_string, comment_string_html) FROM stdin;
1	1166	7929	2022-09-19 21:13:03.077373	2022-09-19 21:13:03.077373	Bacon ipsum dolor amet landjaeger jowl andouille strip steak tail turducken.	\N
2	1165	7929	2022-09-19 21:15:15.98194	2022-09-19 21:15:15.98194	Kielbasa frankfurter biltong sausage t-bone doner tri-tip prosciutto brisket ball tip rump pork.	\N
3	1165	7931	2022-09-19 21:22:56.849276	2022-09-19 21:22:56.849276	Brisket filet mignon rump ham hock bacon prosciutto chuck beef ribs swine.	\N
4	1166	7931	2022-09-19 21:23:00.656908	2022-09-19 21:23:00.656908	Doner meatball leberkas fatback, tri-tip rump picanha cow!	\N
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, sender_id, recipient_id, body, "timestamp", sent) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, name, user_id, "timestamp", payload_json) FROM stdin;
2	Term Watched	1129	2022-04-18 18:52:19.245653	{"term_string": "Pleistocene", "term_id": 2933, "term_concept_id": "h3041"}
3	Term Watched	1	2022-04-18 18:52:19.288262	{"term_string": "Pleistocene", "term_id": 2933, "term_concept_id": "h3041"}
4	Term Updated	1129	2022-05-24 02:28:36.991652	{"term_string": "Accreted ice", "term_id": 4343, "term_concept_id": "h4460"}
5	Term Updated	1129	2022-05-24 02:31:43.318573	{"term_string": "Accreted ice", "term_id": 4343, "term_concept_id": "h4460"}
6	Term Updated	1007	2022-06-13 18:21:43.269208	{"term_string": "CVP", "term_id": 1003, "term_concept_id": "h1199"}
7	Term Updated	1096	2022-06-13 19:32:56.254804	{"term_string": "dispersion", "term_id": 1291, "term_concept_id": "h1372"}
\.


--
-- Data for Name: relationships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.relationships (id, parent_id, child_id, predicate, "timestamp") FROM stdin;
1	2214	3779	extractedFrom	2022-03-08 18:21:31.021366
2	2214	3779	extractedFrom	2022-03-08 18:21:31.159861
3	2512	3780	extractedFrom	2022-03-08 18:21:31.380525
4	2512	3781	extractedFrom	2022-03-08 18:21:31.5222
5	2512	3781	extractedFrom	2022-03-08 18:21:31.629644
6	3415	3782	extractedFrom	2022-03-08 18:21:31.887033
\.


--
-- Data for Name: term_sets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.term_sets (set_id, term_id) FROM stdin;
3	7933
3	7934
3	7935
3	7936
3	7937
7	7996
7	7997
7	7998
7	7999
7	8000
7	8001
\.


--
-- Data for Name: terms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.terms (id, ark_id, shoulder, naan, owner_id, created, modified, term_string, definition, examples, concept_id, status, class, definition_html, examples_html, search_vector) FROM stdin;
1	1234	h	99152	1129	2022-03-08 18:23:45.22927	2023-03-27 20:32:20.655803	Median iceberg limit	Sea ice terminology describing the position where the historical or statistical frequency of occurrence of the iceberg limit is 50 per cent. 	\N	h4440	published	vernacular	\N	\N	'50':20 'cent':22 'describ':4 'ecccanada':24 'frequenc':12 'gcw':23 'histor':9 'ice':2 'iceberg':17 'limit':18 'occurr':14 'per':21 'posit':6 'sea':1 'statist':11 'terminolog':3
2	2345	h	99152	1129	2017-06-06 19:46:39.254342	2022-03-08 18:21:31.818979	Subsea permafrost	Permafrost occurring beneath the sea bottom. #{g: xqNSIDCCryosphere | h1635}\n\nPermafrost occurring beneath the sea bottom #{g: xqIPAPermafrost | h1630}\n\nForm of permafrost that exists beneath the sea in ocean sediments. #{g: xqPhysicalGeography | h1636}\n\n#{g: xqGCW | h1619}		h3523	archived	vernacular	\N	\N	\N
100	9876	h	99152	1129	2022-03-08 18:34:13.289832	2023-03-27 20:35:20.87719	Air freezing index	The cumulative number of degree-days below 0C for the air temperature during a given time period. The Air Freezing Index differs from the corresponding surface Freezing Index (see n-factor). SUM (T_1) < 0 	\N	h6913	published	vernacular	\N	\N	'0':37 '0c':9 '1':36 'air':12,20 'correspond':26 'cumul':2 'day':7 'degre':6 'degree-day':5 'differ':23 'factor':33 'freez':21,28 'gcw':38 'given':16 'index':22,29 'n':32 'n-factor':31 'number':3 'period':18 'see':30 'sum':34 'surfac':27 'temperatur':13 'time':17 'trombottogeocryolog':39
101	8765	h	99152	1129	2017-06-06 17:41:18.736116	2022-03-08 18:21:35.054156	Altitude	The vertical distance of a point above a datum. The vertical datum is usually an estimate of mean sea level. Older measurements were often determined in a local coordinate system and were not tied to a global reference frame. Some were made not with surveying instruments but with barometers, in reliance on the decrease of atmospheric pressure with altitude. It is now usual to measure altitude or elevation using the Global Positioning System or an equivalent global navigation satellite system. Altitude and elevation are synonyms in common usage, although altitude is less ambiguous. The unqualified word 'elevation' can also refer, for example, to the act of elevating or to angular distance above a horizontal plane. #{g: xqIHPGlacierMassBalance | h1629}\n\nVertical distance of a level, a point or an object considered as a point, measured from mean sea level. (TR) #{g: xqWMOHydrology | h1642}\n\nA measure (or condition) of height, especially of great height, as a mountain top or aircraft flight level. In meteorology, altitude is used almost exclusively with respect to the height of an airborne object above the earth's surface, above a constant-pressure surface, or above mean sea level. The measurement of altitude is accomplished by altimeters in aeronautics, and the entire study is called altimetry. #{g: xqAMSglossary | h1620}\n\nVertical distance above sea-level. #{g: xqPhysicalGeography | h1636}\n\n#{g: xqGCW | h1619}		h1711	archived	vernacular	\N	\N	\N
200	1357	h	99152	1129	2017-06-06 19:36:49.070972	2022-03-08 18:21:35.799628	Seasonally-active permafrost	The uppermost layer of the permafrost which undergoes seasonal phase changes due to the lowered thawing temperature and freezing-point depression of its pore water. #{g: xqNSIDCCryosphere | h1635}\n\nThe uppermost layer of the permafrost which undergoes seasonal phase changes due to the lowered thawing temperature and freezing-point depression of its pore water #{g: xqIPAPermafrost | h1630}\n\n#{g: xqGCW | h1619}		h3267	archived	vernacular	\N	\N	\N
\.


--
-- Data for Name: termsets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.termsets (id, source, description, created, updated, user_id, name, ark_id) FROM stdin;
1	Test Set,	Fabricated Test Set 2024-06-25 00:11:06.698012	2024-06-25 00:11:06.698013	1	Test Set	\N
42	Lorem Ipsum Set A second fabricate test set	2023-04-16 23:45:13.730086	2023-04-16 23:45:13.730086	17	A second fabricated test set	\N
\.


--
-- Data for Name: tracking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tracking (user_id, term_id) FROM stdin;
1	4692
1	6780
1	7426
1	5373
1	2933
1	7927
1170	4381
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, authority, auth_id, last_name, first_name, email, orcid, reputation, enotify, super_user, last_message_read_time) FROM stdin;
1002	google	112635160614837780008	Smith	John	jsmith@example.com	\N	50	f	f	\N
1003	google	113264384537331141490	Doe Jane	jdoe@foo.com	\N	200	f	f	\N
1004	google	105267514831512253030	Nobody	Joe	joe@nobody.com	\N	20	f	f	\N
\.


--
-- Data for Name: votes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.votes (user_id, term_id, vote) FROM stdin;
1002	1	1
1002	2	1
1003	100	1
1004	101	-1
1004	200	-1
1004	100	-1
\.


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 64, true);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messages_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 63, true);


--
-- Name: relationships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.relationships_id_seq', 6294, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_id_seq', 143, true);


--
-- Name: terms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.terms_id_seq', 27359, true);


--
-- Name: termsets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.termsets_id_seq', 17, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1192, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: relationships relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relationships
    ADD CONSTRAINT relationships_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: terms terms_ark_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.terms
    ADD CONSTRAINT terms_ark_id_key UNIQUE (ark_id);


--
-- Name: terms terms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.terms
    ADD CONSTRAINT terms_pkey PRIMARY KEY (id);


--
-- Name: termsets termsets_ark_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.termsets
    ADD CONSTRAINT termsets_ark_id_key UNIQUE (ark_id);


--
-- Name: termsets termsets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.termsets
    ADD CONSTRAINT termsets_pkey PRIMARY KEY (id);


--
-- Name: tracking tracking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tracking
    ADD CONSTRAINT tracking_pkey PRIMARY KEY (user_id, term_id);


--
-- Name: users users_auth_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_auth_id_key UNIQUE (auth_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: votes votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (user_id, term_id);


--
-- Name: ix_messages_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_messages_timestamp ON public.messages USING btree ("timestamp");


--
-- Name: ix_notifications_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notifications_name ON public.notifications USING btree (name);


--
-- Name: ix_term_search_vector; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_term_search_vector ON public.terms USING gin (search_vector);


--
-- Name: comments comments_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: comments comments_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.terms(id);


--
-- Name: messages messages_recipient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public.users(id);


--
-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: relationships relationships_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relationships
    ADD CONSTRAINT relationships_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.terms(id);


--
-- Name: relationships relationships_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relationships
    ADD CONSTRAINT relationships_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.terms(id);


--
-- Name: tags tags_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: term_sets term_sets_set_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.term_sets
    ADD CONSTRAINT term_sets_set_id_fkey FOREIGN KEY (set_id) REFERENCES public.termsets(id);


--
-- Name: term_sets term_sets_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.term_sets
    ADD CONSTRAINT term_sets_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.terms(id);


--
-- Name: term_tags term_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.term_tags
    ADD CONSTRAINT term_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: term_tags term_tags_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.term_tags
    ADD CONSTRAINT term_tags_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.terms(id);


--
-- Name: terms terms_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.terms
    ADD CONSTRAINT terms_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: termsets termsets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.termsets
    ADD CONSTRAINT termsets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tracking tracking_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tracking
    ADD CONSTRAINT tracking_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.terms(id);


--
-- Name: tracking tracking_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tracking
    ADD CONSTRAINT tracking_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: votes votes_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.terms(id);


--
-- Name: votes votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

