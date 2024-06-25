--
-- PostgreSQL database dump
--

-- Dumped from database version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)

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
    __ts_vector__ tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, ((((term_string || ' '::text) || definition) || ' '::text) || examples))) STORED,
    definition_html text,
    examples_html text
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
    name text
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
45593e8774b6
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, owner_id, term_id, created, modified, comment_string, comment_string_html) FROM stdin;
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
1	Term Updated	1	2022-04-08 02:44:26.985782	{"term_string": "test", "term_id": 7923, "term_concept_id": "h8040"}
2	Term Watched	1129	2022-04-18 18:52:19.245653	{"term_string": "Pleistocene", "term_id": 2933, "term_concept_id": "h3041"}
3	Term Watched	1	2022-04-18 18:52:19.288262	{"term_string": "Pleistocene", "term_id": 2933, "term_concept_id": "h3041"}
4	Term Updated	1129	2022-05-24 02:28:36.991652	{"term_string": "Accreted ice", "term_id": 4343, "term_concept_id": "h4460"}
5	Term Updated	1129	2022-05-24 02:31:43.318573	{"term_string": "Accreted ice", "term_id": 4343, "term_concept_id": "h4460"}
6	Term Updated	1007	2022-06-13 18:21:43.269208	{"term_string": "CVP", "term_id": 1003, "term_concept_id": "h1199"}
7	Term Updated	1096	2022-06-13 19:32:56.254804	{"term_string": "dispersion", "term_id": 1291, "term_concept_id": "h1372"}
8	Term Updated	1096	2022-06-13 19:33:44.809692	{"term_string": "internal pressure", "term_id": 1295, "term_concept_id": "h1376"}
9	Term Updated	1096	2022-06-13 19:34:07.949363	{"term_string": "pressure test", "term_id": 1296, "term_concept_id": "h1377"}
10	Term Updated	1096	2022-06-13 19:34:54.320844	{"term_string": "incident flow", "term_id": 1278, "term_concept_id": "h1359"}
11	Term Updated	1096	2022-06-13 19:35:44.440674	{"term_string": "open jet wind tunnel", "term_id": 1301, "term_concept_id": "h1383"}
12	Term Updated	1096	2022-06-13 19:36:10.019387	{"term_string": "multi-hole pressure probe", "term_id": 1277, "term_concept_id": "h1358"}
13	Term Updated	1096	2022-06-13 19:37:32.233289	{"term_string": "aeroelastic model", "term_id": 1287, "term_concept_id": "h1368"}
14	Term Updated	1096	2022-06-13 19:38:02.931777	{"term_string": "hot wire anemometer", "term_id": 1276, "term_concept_id": "h1357"}
15	Term Updated	1096	2022-06-13 19:38:25.855992	{"term_string": "exposure", "term_id": 1283, "term_concept_id": "h1364"}
16	Term Updated	1096	2022-06-13 19:39:26.399548	{"term_string": "closed circuit wind tunnel", "term_id": 1300, "term_concept_id": "h1382"}
17	Term Updated	1096	2022-06-13 19:39:39.952406	{"term_string": "wind tunnel", "term_id": 1298, "term_concept_id": "h1380"}
18	Term Updated	1096	2022-06-13 19:39:57.201732	{"term_string": "bridge section model", "term_id": 1286, "term_concept_id": "h1367"}
19	Term Updated	1096	2022-06-13 19:40:16.212528	{"term_string": "rigid model", "term_id": 1284, "term_concept_id": "h1365"}
20	Term Updated	1096	2022-06-13 19:40:37.323507	{"term_string": "external pressure", "term_id": 1294, "term_concept_id": "h1375"}
21	Term Updated	1096	2022-06-13 19:41:13.795057	{"term_string": "tall building", "term_id": 1288, "term_concept_id": "h1369"}
22	Term Updated	1096	2022-06-13 19:41:36.705878	{"term_string": "pedestrian level wind", "term_id": 1275, "term_concept_id": "h1356"}
23	Term Updated	1096	2022-06-13 19:41:56.517604	{"term_string": "Pitot tube", "term_id": 1292, "term_concept_id": "h1373"}
24	Term Updated	1096	2022-06-13 19:42:46.26344	{"term_string": "complex topography", "term_id": 1293, "term_concept_id": "h1374"}
25	Term Updated	1096	2022-06-13 19:43:08.726335	{"term_string": "low-rise building", "term_id": 1285, "term_concept_id": "h1366"}
26	Term Updated	1096	2022-06-13 19:43:35.764199	{"term_string": "velocimetry", "term_id": 1289, "term_concept_id": "h1370"}
27	Term Updated	1096	2022-06-13 19:43:59.183167	{"term_string": "towers/masts/chimneys", "term_id": 1303, "term_concept_id": "h1385"}
28	Term Updated	1096	2022-06-13 19:44:20.803367	{"term_string": "gusting flow", "term_id": 1281, "term_concept_id": "h1362"}
29	Term Updated	1096	2022-06-13 19:44:40.415365	{"term_string": "uniform flow", "term_id": 1279, "term_concept_id": "h1360"}
30	Term Updated	1096	2022-06-13 19:44:59.499069	{"term_string": "boundary layer flow", "term_id": 1280, "term_concept_id": "h1361"}
31	Term Updated	1096	2022-06-13 19:45:29.279775	{"term_string": "force balance test", "term_id": 1297, "term_concept_id": "h1378"}
32	Term Updated	1129	2022-06-14 15:34:04.480539	{"term_string": "Pleistocene", "term_id": 2933, "term_concept_id": "h3041"}
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
7	3415	3783	extractedFrom	2022-03-08 18:21:32.086893
8	3415	3784	extractedFrom	2022-03-08 18:21:32.319176
9	3415	3784	extractedFrom	2022-03-08 18:21:32.375456
10	3474	3785	extractedFrom	2022-03-08 18:21:32.55658
11	3474	3786	extractedFrom	2022-03-08 18:21:32.724066
12	3474	3787	extractedFrom	2022-03-08 18:21:33.171563
13	3474	3788	extractedFrom	2022-03-08 18:21:33.830816
14	3474	3789	extractedFrom	2022-03-08 18:21:34.024015
15	3474	3789	extractedFrom	2022-03-08 18:21:34.358482
16	2053	3790	extractedFrom	2022-03-08 18:21:34.5614
17	2053	3791	extractedFrom	2022-03-08 18:21:34.808853
18	2053	3792	extractedFrom	2022-03-08 18:21:34.951078
19	2053	3792	extractedFrom	2022-03-08 18:21:34.993954
20	1604	3793	extractedFrom	2022-03-08 18:21:35.211699
21	1604	3794	extractedFrom	2022-03-08 18:21:35.287985
22	1604	3795	extractedFrom	2022-03-08 18:21:35.363409
23	1604	3796	extractedFrom	2022-03-08 18:21:35.463448
24	1604	3796	extractedFrom	2022-03-08 18:21:35.666489
25	3159	3797	extractedFrom	2022-03-08 18:21:35.882236
26	3159	3798	extractedFrom	2022-03-08 18:21:36.07758
27	3159	3798	extractedFrom	2022-03-08 18:21:36.159127
28	2611	3799	extractedFrom	2022-03-08 18:21:36.32429
29	2611	3800	extractedFrom	2022-03-08 18:21:36.536861
30	2611	3801	extractedFrom	2022-03-08 18:21:36.946057
31	2611	3801	extractedFrom	2022-03-08 18:21:37.067911
32	2020	3802	extractedFrom	2022-03-08 18:21:37.304849
33	2020	3802	extractedFrom	2022-03-08 18:21:37.420236
34	3225	3803	extractedFrom	2022-03-08 18:21:37.632313
35	3225	3804	extractedFrom	2022-03-08 18:21:37.776349
36	3225	3805	extractedFrom	2022-03-08 18:21:37.918981
37	3225	3805	extractedFrom	2022-03-08 18:21:38.011032
38	1555	3806	extractedFrom	2022-03-08 18:21:38.152156
39	1555	3807	extractedFrom	2022-03-08 18:21:38.251584
40	1555	3808	extractedFrom	2022-03-08 18:21:38.330242
41	1555	3809	extractedFrom	2022-03-08 18:21:38.397051
42	1555	3810	extractedFrom	2022-03-08 18:21:38.745837
43	1555	3811	extractedFrom	2022-03-08 18:21:38.813465
44	1555	3812	extractedFrom	2022-03-08 18:21:39.058516
45	1555	3813	extractedFrom	2022-03-08 18:21:39.329782
46	1555	3814	extractedFrom	2022-03-08 18:21:39.509711
47	1555	3815	extractedFrom	2022-03-08 18:21:39.856294
48	1555	3815	extractedFrom	2022-03-08 18:21:40.053148
49	1681	3816	extractedFrom	2022-03-08 18:21:40.346681
50	1681	3817	extractedFrom	2022-03-08 18:21:40.735002
51	1681	3818	extractedFrom	2022-03-08 18:21:41.037876
52	1681	3819	extractedFrom	2022-03-08 18:21:41.535355
53	1681	3820	extractedFrom	2022-03-08 18:21:42.26308
54	1681	3821	extractedFrom	2022-03-08 18:21:42.796917
55	1681	3822	extractedFrom	2022-03-08 18:21:43.403744
56	1681	3823	extractedFrom	2022-03-08 18:21:43.80809
57	1681	3823	extractedFrom	2022-03-08 18:21:43.908128
58	3523	3824	extractedFrom	2022-03-08 18:21:44.422346
59	3523	3824	extractedFrom	2022-03-08 18:21:44.588362
60	2087	3825	extractedFrom	2022-03-08 18:21:45.330148
61	2087	3826	extractedFrom	2022-03-08 18:21:45.562048
62	2087	3827	extractedFrom	2022-03-08 18:21:45.805392
63	2087	3827	extractedFrom	2022-03-08 18:21:46.047824
64	1730	3828	extractedFrom	2022-03-08 18:21:46.501327
65	1730	3829	extractedFrom	2022-03-08 18:21:46.792612
66	1730	3830	extractedFrom	2022-03-08 18:21:47.181679
67	1730	3831	extractedFrom	2022-03-08 18:21:47.635607
68	1730	3831	extractedFrom	2022-03-08 18:21:47.798032
69	2033	3832	extractedFrom	2022-03-08 18:21:48.544762
70	2033	3832	extractedFrom	2022-03-08 18:21:48.712249
71	1811	3833	extractedFrom	2022-03-08 18:21:49.153522
72	1811	3834	extractedFrom	2022-03-08 18:21:49.678668
73	1811	3835	extractedFrom	2022-03-08 18:21:50.280785
74	1811	3836	extractedFrom	2022-03-08 18:21:51.141157
75	1811	3836	extractedFrom	2022-03-08 18:21:51.448668
76	1670	3837	extractedFrom	2022-03-08 18:21:52.198213
77	1670	3838	extractedFrom	2022-03-08 18:21:52.959581
78	1670	3838	extractedFrom	2022-03-08 18:21:53.91738
79	3684	3839	extractedFrom	2022-03-08 18:21:54.538912
80	3684	3840	extractedFrom	2022-03-08 18:21:54.901226
81	3684	3840	extractedFrom	2022-03-08 18:21:55.091884
82	3233	3841	extractedFrom	2022-03-08 18:21:55.434475
83	3233	3842	extractedFrom	2022-03-08 18:21:55.733454
84	3233	3843	extractedFrom	2022-03-08 18:21:56.093337
85	3233	3844	extractedFrom	2022-03-08 18:21:56.875587
86	3233	3845	extractedFrom	2022-03-08 18:21:57.436757
87	3233	3846	extractedFrom	2022-03-08 18:21:57.967301
88	3233	3846	extractedFrom	2022-03-08 18:21:58.190766
89	2540	3847	extractedFrom	2022-03-08 18:21:58.760609
90	2540	3848	extractedFrom	2022-03-08 18:21:59.201583
91	2540	3849	extractedFrom	2022-03-08 18:21:59.652459
92	2540	3850	extractedFrom	2022-03-08 18:22:00.146303
93	2540	3851	extractedFrom	2022-03-08 18:22:00.856362
94	2540	3852	extractedFrom	2022-03-08 18:22:01.323167
95	2540	3853	extractedFrom	2022-03-08 18:22:01.591804
96	2540	3854	extractedFrom	2022-03-08 18:22:01.985143
97	2540	3855	extractedFrom	2022-03-08 18:22:02.469133
98	2540	3856	extractedFrom	2022-03-08 18:22:02.82064
99	2540	3857	extractedFrom	2022-03-08 18:22:03.293012
100	2540	3858	extractedFrom	2022-03-08 18:22:03.93188
101	2540	3858	extractedFrom	2022-03-08 18:22:04.440501
102	2439	3859	extractedFrom	2022-03-08 18:22:05.218769
103	2439	3860	extractedFrom	2022-03-08 18:22:05.565487
104	2439	3861	extractedFrom	2022-03-08 18:22:05.890108
105	2439	3862	extractedFrom	2022-03-08 18:22:06.369149
106	2439	3863	extractedFrom	2022-03-08 18:22:06.894783
107	2439	3864	extractedFrom	2022-03-08 18:22:07.272559
108	2439	3864	extractedFrom	2022-03-08 18:22:07.636015
109	1793	3865	extractedFrom	2022-03-08 18:22:07.810991
110	1793	3865	extractedFrom	2022-03-08 18:22:08.029534
111	2428	3866	extractedFrom	2022-03-08 18:22:08.606126
112	2428	3867	extractedFrom	2022-03-08 18:22:09.057239
113	2428	3867	extractedFrom	2022-03-08 18:22:09.273619
114	3519	3868	extractedFrom	2022-03-08 18:22:09.578245
115	3519	3869	extractedFrom	2022-03-08 18:22:09.988571
116	3519	3870	extractedFrom	2022-03-08 18:22:10.74448
117	3519	3870	extractedFrom	2022-03-08 18:22:11.109728
118	1559	3871	extractedFrom	2022-03-08 18:22:11.47473
119	1559	3871	extractedFrom	2022-03-08 18:22:11.563434
120	1602	3872	extractedFrom	2022-03-08 18:22:11.755705
121	1602	3873	extractedFrom	2022-03-08 18:22:12.120398
122	1602	3873	extractedFrom	2022-03-08 18:22:12.257401
123	2475	3874	extractedFrom	2022-03-08 18:22:12.516099
124	2475	3875	extractedFrom	2022-03-08 18:22:12.855415
125	2475	3876	extractedFrom	2022-03-08 18:22:13.198022
126	2475	3876	extractedFrom	2022-03-08 18:22:13.29733
127	2449	3877	extractedFrom	2022-03-08 18:22:13.476918
128	2449	3877	extractedFrom	2022-03-08 18:22:13.572198
129	2275	3878	extractedFrom	2022-03-08 18:22:13.838926
130	2275	3878	extractedFrom	2022-03-08 18:22:13.928831
131	3113	3879	extractedFrom	2022-03-08 18:22:14.132884
132	3113	3879	extractedFrom	2022-03-08 18:22:14.333832
133	2784	3880	extractedFrom	2022-03-08 18:22:14.500812
134	2784	3881	extractedFrom	2022-03-08 18:22:14.6654
135	2784	3881	extractedFrom	2022-03-08 18:22:14.711995
136	1919	3882	extractedFrom	2022-03-08 18:22:14.831856
137	1919	3883	extractedFrom	2022-03-08 18:22:14.902841
138	1919	3884	extractedFrom	2022-03-08 18:22:15.140254
139	1919	3885	extractedFrom	2022-03-08 18:22:15.496198
140	1919	3886	extractedFrom	2022-03-08 18:22:15.633886
141	1919	3886	extractedFrom	2022-03-08 18:22:15.942505
142	3457	3887	extractedFrom	2022-03-08 18:22:16.1592
143	3457	3888	extractedFrom	2022-03-08 18:22:16.349547
144	3457	3889	extractedFrom	2022-03-08 18:22:16.529367
145	3457	3889	extractedFrom	2022-03-08 18:22:16.672581
146	1618	3890	extractedFrom	2022-03-08 18:22:16.865701
147	1618	3890	extractedFrom	2022-03-08 18:22:16.989643
148	3325	3891	extractedFrom	2022-03-08 18:22:17.453034
149	3325	3892	extractedFrom	2022-03-08 18:22:17.811552
150	3325	3893	extractedFrom	2022-03-08 18:22:18.266961
151	3325	3893	extractedFrom	2022-03-08 18:22:18.347415
152	2972	3894	extractedFrom	2022-03-08 18:22:18.499234
153	2972	3894	extractedFrom	2022-03-08 18:22:18.687516
154	1786	3895	extractedFrom	2022-03-08 18:22:19.166355
155	1786	3896	extractedFrom	2022-03-08 18:22:19.576991
156	1786	3897	extractedFrom	2022-03-08 18:22:19.866502
157	1786	3897	extractedFrom	2022-03-08 18:22:20.068323
158	2420	3898	extractedFrom	2022-03-08 18:22:20.290672
159	2420	3899	extractedFrom	2022-03-08 18:22:20.520301
160	2420	3900	extractedFrom	2022-03-08 18:22:20.921703
161	2420	3901	extractedFrom	2022-03-08 18:22:21.233779
162	2420	3902	extractedFrom	2022-03-08 18:22:21.56543
163	2420	3902	extractedFrom	2022-03-08 18:22:21.661195
164	1736	3903	extractedFrom	2022-03-08 18:22:21.797949
165	1736	3904	extractedFrom	2022-03-08 18:22:21.89373
166	1736	3905	extractedFrom	2022-03-08 18:22:21.997856
167	1736	3906	extractedFrom	2022-03-08 18:22:22.104514
168	1736	3907	extractedFrom	2022-03-08 18:22:22.970479
169	1736	3908	extractedFrom	2022-03-08 18:22:23.151626
170	1736	3908	extractedFrom	2022-03-08 18:22:23.32159
171	2705	3909	extractedFrom	2022-03-08 18:22:23.496473
172	2705	3909	extractedFrom	2022-03-08 18:22:23.627265
173	2827	3910	extractedFrom	2022-03-08 18:22:23.867935
174	2827	3911	extractedFrom	2022-03-08 18:22:24.180822
175	2827	3912	extractedFrom	2022-03-08 18:22:24.367294
176	2827	3912	extractedFrom	2022-03-08 18:22:24.419235
177	2193	3913	extractedFrom	2022-03-08 18:22:24.560391
178	2193	3914	extractedFrom	2022-03-08 18:22:24.68973
179	2193	3915	extractedFrom	2022-03-08 18:22:25.03047
180	2193	3915	extractedFrom	2022-03-08 18:22:25.219963
181	3535	3916	extractedFrom	2022-03-08 18:22:25.422856
182	3535	3916	extractedFrom	2022-03-08 18:22:25.513977
183	1874	3917	extractedFrom	2022-03-08 18:22:25.766669
184	1874	3918	extractedFrom	2022-03-08 18:22:25.922672
185	1874	3919	extractedFrom	2022-03-08 18:22:26.096889
186	1874	3919	extractedFrom	2022-03-08 18:22:26.384238
187	2115	3920	extractedFrom	2022-03-08 18:22:26.53612
188	2115	3921	extractedFrom	2022-03-08 18:22:26.650189
189	2115	3922	extractedFrom	2022-03-08 18:22:26.790144
190	2115	3922	extractedFrom	2022-03-08 18:22:26.852401
191	1806	3923	extractedFrom	2022-03-08 18:22:26.996253
192	1806	3923	extractedFrom	2022-03-08 18:22:27.104472
193	3277	3924	extractedFrom	2022-03-08 18:22:27.265452
194	3277	3925	extractedFrom	2022-03-08 18:22:27.441749
195	3277	3925	extractedFrom	2022-03-08 18:22:27.521291
196	2262	3926	extractedFrom	2022-03-08 18:22:27.743615
197	2262	3927	extractedFrom	2022-03-08 18:22:28.051614
198	2262	3928	extractedFrom	2022-03-08 18:22:28.325917
199	2262	3929	extractedFrom	2022-03-08 18:22:28.592424
200	2262	3930	extractedFrom	2022-03-08 18:22:28.750418
201	2262	3930	extractedFrom	2022-03-08 18:22:28.865447
202	2264	3931	extractedFrom	2022-03-08 18:22:29.063678
203	2264	3931	extractedFrom	2022-03-08 18:22:29.154226
204	1605	3932	extractedFrom	2022-03-08 18:22:29.378014
205	1605	3933	extractedFrom	2022-03-08 18:22:29.628549
206	1605	3933	extractedFrom	2022-03-08 18:22:29.760826
207	1712	3934	extractedFrom	2022-03-08 18:22:30.132519
208	1712	3934	extractedFrom	2022-03-08 18:22:30.374163
209	2089	3935	extractedFrom	2022-03-08 18:22:30.578451
210	2089	3936	extractedFrom	2022-03-08 18:22:30.828672
211	2089	3936	extractedFrom	2022-03-08 18:22:30.929605
212	1952	3937	extractedFrom	2022-03-08 18:22:31.180575
213	1952	3938	extractedFrom	2022-03-08 18:22:31.404085
214	1952	3938	extractedFrom	2022-03-08 18:22:31.540247
215	2704	3939	extractedFrom	2022-03-08 18:22:31.786433
216	2704	3939	extractedFrom	2022-03-08 18:22:31.907677
217	2691	3940	extractedFrom	2022-03-08 18:22:32.447176
218	2691	3940	extractedFrom	2022-03-08 18:22:32.503504
219	1630	3941	extractedFrom	2022-03-08 18:22:32.595616
220	1630	3941	extractedFrom	2022-03-08 18:22:32.843642
221	3250	3942	extractedFrom	2022-03-08 18:22:32.950826
222	3250	3943	extractedFrom	2022-03-08 18:22:33.261643
223	3250	3943	extractedFrom	2022-03-08 18:22:33.329729
224	3594	3944	extractedFrom	2022-03-08 18:22:33.456327
225	3594	3945	extractedFrom	2022-03-08 18:22:33.59811
226	3594	3945	extractedFrom	2022-03-08 18:22:33.655385
227	2572	3946	extractedFrom	2022-03-08 18:22:34.133885
228	2572	3946	extractedFrom	2022-03-08 18:22:34.265562
229	3602	3947	extractedFrom	2022-03-08 18:22:34.398381
230	3602	3947	extractedFrom	2022-03-08 18:22:34.535786
231	2953	3948	extractedFrom	2022-03-08 18:22:34.690445
232	2953	3949	extractedFrom	2022-03-08 18:22:34.903586
233	2953	3950	extractedFrom	2022-03-08 18:22:35.003928
234	2953	3950	extractedFrom	2022-03-08 18:22:35.117711
235	3522	3951	extractedFrom	2022-03-08 18:22:35.192416
236	3522	3951	extractedFrom	2022-03-08 18:22:35.236951
237	2951	3952	extractedFrom	2022-03-08 18:22:35.304328
238	2951	3952	extractedFrom	2022-03-08 18:22:35.346228
239	1799	3953	extractedFrom	2022-03-08 18:22:35.410112
240	1799	3954	extractedFrom	2022-03-08 18:22:35.515036
241	1799	3955	extractedFrom	2022-03-08 18:22:36.010764
242	1799	3956	extractedFrom	2022-03-08 18:22:36.091269
243	1799	3957	extractedFrom	2022-03-08 18:22:36.479916
244	1799	3957	extractedFrom	2022-03-08 18:22:36.524197
245	1652	3958	extractedFrom	2022-03-08 18:22:36.590961
246	1652	3958	extractedFrom	2022-03-08 18:22:36.635172
247	2197	3959	extractedFrom	2022-03-08 18:22:36.707291
248	2197	3960	extractedFrom	2022-03-08 18:22:36.800878
249	2197	3961	extractedFrom	2022-03-08 18:22:36.956262
250	2197	3961	extractedFrom	2022-03-08 18:22:37.083926
251	1577	3962	extractedFrom	2022-03-08 18:22:37.21904
252	1577	3963	extractedFrom	2022-03-08 18:22:37.415803
253	1577	3963	extractedFrom	2022-03-08 18:22:37.60682
254	1792	3964	extractedFrom	2022-03-08 18:22:38.196531
255	1792	3965	extractedFrom	2022-03-08 18:22:38.352057
256	1792	3966	extractedFrom	2022-03-08 18:22:38.558586
257	1792	3966	extractedFrom	2022-03-08 18:22:38.625522
258	2880	3967	extractedFrom	2022-03-08 18:22:38.882764
259	2880	3968	extractedFrom	2022-03-08 18:22:39.462398
260	2880	3968	extractedFrom	2022-03-08 18:22:39.505796
261	3224	3969	extractedFrom	2022-03-08 18:22:39.585387
262	3224	3970	extractedFrom	2022-03-08 18:22:39.690492
263	3224	3971	extractedFrom	2022-03-08 18:22:39.764167
264	3224	3971	extractedFrom	2022-03-08 18:22:39.809779
265	2736	3972	extractedFrom	2022-03-08 18:22:39.880594
266	2736	3972	extractedFrom	2022-03-08 18:22:39.919809
267	1623	3973	extractedFrom	2022-03-08 18:22:39.985073
268	1623	3974	extractedFrom	2022-03-08 18:22:40.055646
269	1623	3974	extractedFrom	2022-03-08 18:22:40.162879
270	2122	3975	extractedFrom	2022-03-08 18:22:40.243963
271	2122	3976	extractedFrom	2022-03-08 18:22:40.314596
272	2122	3977	extractedFrom	2022-03-08 18:22:40.417409
273	2122	3978	extractedFrom	2022-03-08 18:22:40.564153
274	2122	3979	extractedFrom	2022-03-08 18:22:40.692067
275	2122	3980	extractedFrom	2022-03-08 18:22:40.997173
276	2122	3980	extractedFrom	2022-03-08 18:22:41.138785
277	3324	3981	extractedFrom	2022-03-08 18:22:41.334282
278	3324	3981	extractedFrom	2022-03-08 18:22:41.514529
279	2047	3982	extractedFrom	2022-03-08 18:22:42.143113
280	2047	3983	extractedFrom	2022-03-08 18:22:42.25418
281	2047	3984	extractedFrom	2022-03-08 18:22:42.379685
282	2047	3985	extractedFrom	2022-03-08 18:22:42.588941
283	2047	3986	extractedFrom	2022-03-08 18:22:42.71411
284	2047	3987	extractedFrom	2022-03-08 18:22:42.794338
285	2047	3988	extractedFrom	2022-03-08 18:22:42.855097
286	2047	3988	extractedFrom	2022-03-08 18:22:42.898519
287	2792	3989	extractedFrom	2022-03-08 18:22:43.081237
288	2792	3990	extractedFrom	2022-03-08 18:22:43.15632
289	2792	3991	extractedFrom	2022-03-08 18:22:43.222379
290	2792	3992	extractedFrom	2022-03-08 18:22:43.289565
291	2792	3993	extractedFrom	2022-03-08 18:22:43.406795
292	2792	3993	extractedFrom	2022-03-08 18:22:43.543084
293	1957	3994	extractedFrom	2022-03-08 18:22:43.650201
294	1957	3995	extractedFrom	2022-03-08 18:22:43.773816
295	1957	3995	extractedFrom	2022-03-08 18:22:43.827705
296	3357	3996	extractedFrom	2022-03-08 18:22:43.931051
297	3357	3996	extractedFrom	2022-03-08 18:22:44.082808
298	3092	3997	extractedFrom	2022-03-08 18:22:44.266483
299	3092	3998	extractedFrom	2022-03-08 18:22:44.413813
300	3092	3999	extractedFrom	2022-03-08 18:22:44.513543
301	3092	4000	extractedFrom	2022-03-08 18:22:44.720264
302	3092	4001	extractedFrom	2022-03-08 18:22:44.838828
303	3092	4002	extractedFrom	2022-03-08 18:22:44.933096
304	3092	4002	extractedFrom	2022-03-08 18:22:45.051912
305	1569	4003	extractedFrom	2022-03-08 18:22:45.171334
306	1569	4004	extractedFrom	2022-03-08 18:22:45.2334
307	1569	4005	extractedFrom	2022-03-08 18:22:45.301013
308	1569	4005	extractedFrom	2022-03-08 18:22:45.500847
309	2842	4006	extractedFrom	2022-03-08 18:22:45.568016
310	2842	4006	extractedFrom	2022-03-08 18:22:45.611721
311	2436	4007	extractedFrom	2022-03-08 18:22:45.732402
312	2436	4007	extractedFrom	2022-03-08 18:22:45.793715
313	2154	4008	extractedFrom	2022-03-08 18:22:45.973562
314	2154	4008	extractedFrom	2022-03-08 18:22:46.073743
315	2175	4009	extractedFrom	2022-03-08 18:22:46.222117
316	2175	4009	extractedFrom	2022-03-08 18:22:46.343908
317	2460	4010	extractedFrom	2022-03-08 18:22:46.537842
318	2460	4011	extractedFrom	2022-03-08 18:22:46.689445
319	2460	4012	extractedFrom	2022-03-08 18:22:46.886329
320	2460	4013	extractedFrom	2022-03-08 18:22:47.002378
321	2460	4014	extractedFrom	2022-03-08 18:22:47.148601
322	2460	4015	extractedFrom	2022-03-08 18:22:47.280239
323	2460	4015	extractedFrom	2022-03-08 18:22:47.36389
324	3109	4016	extractedFrom	2022-03-08 18:22:47.506489
325	3109	4017	extractedFrom	2022-03-08 18:22:47.603584
326	3109	4018	extractedFrom	2022-03-08 18:22:47.704475
327	3109	4018	extractedFrom	2022-03-08 18:22:47.758751
328	1904	4019	extractedFrom	2022-03-08 18:22:47.874253
329	1904	4019	extractedFrom	2022-03-08 18:22:47.921394
330	2190	4020	extractedFrom	2022-03-08 18:22:47.991319
331	2190	4020	extractedFrom	2022-03-08 18:22:48.034977
332	2950	4021	extractedFrom	2022-03-08 18:22:48.099745
333	2950	4022	extractedFrom	2022-03-08 18:22:48.174827
334	2950	4023	extractedFrom	2022-03-08 18:22:48.259881
335	2950	4023	extractedFrom	2022-03-08 18:22:48.303063
336	2065	4024	extractedFrom	2022-03-08 18:22:48.376014
337	2065	4025	extractedFrom	2022-03-08 18:22:48.44828
338	2065	4026	extractedFrom	2022-03-08 18:22:48.517542
339	2065	4027	extractedFrom	2022-03-08 18:22:48.62636
340	2065	4028	extractedFrom	2022-03-08 18:22:48.69844
341	2065	4029	extractedFrom	2022-03-08 18:22:48.946468
342	2065	4030	extractedFrom	2022-03-08 18:22:49.077286
343	2065	4030	extractedFrom	2022-03-08 18:22:49.156323
344	1839	4031	extractedFrom	2022-03-08 18:22:49.306936
345	1839	4031	extractedFrom	2022-03-08 18:22:49.379415
346	2851	4032	extractedFrom	2022-03-08 18:22:49.594876
347	2851	4032	extractedFrom	2022-03-08 18:22:49.654317
348	2768	4033	extractedFrom	2022-03-08 18:22:49.912132
349	2768	4034	extractedFrom	2022-03-08 18:22:50.052966
350	2768	4035	extractedFrom	2022-03-08 18:22:50.526138
351	2768	4035	extractedFrom	2022-03-08 18:22:50.631977
352	1603	4036	extractedFrom	2022-03-08 18:22:50.796463
353	1603	4036	extractedFrom	2022-03-08 18:22:50.849
354	3403	4037	extractedFrom	2022-03-08 18:22:50.912121
355	3403	4037	extractedFrom	2022-03-08 18:22:50.979059
356	2498	4038	extractedFrom	2022-03-08 18:22:51.241963
357	2498	4039	extractedFrom	2022-03-08 18:22:51.307548
358	2498	4039	extractedFrom	2022-03-08 18:22:51.819425
359	2500	4040	extractedFrom	2022-03-08 18:22:52.063601
360	2500	4041	extractedFrom	2022-03-08 18:22:52.163776
361	2500	4042	extractedFrom	2022-03-08 18:22:52.398286
362	2500	4043	extractedFrom	2022-03-08 18:22:52.614503
363	2500	4044	extractedFrom	2022-03-08 18:22:52.768938
364	2500	4045	extractedFrom	2022-03-08 18:22:52.896188
365	2500	4046	extractedFrom	2022-03-08 18:22:53.204052
366	2500	4047	extractedFrom	2022-03-08 18:22:53.490491
367	2500	4048	extractedFrom	2022-03-08 18:22:53.659133
368	2500	4049	extractedFrom	2022-03-08 18:22:53.819744
369	2500	4049	extractedFrom	2022-03-08 18:22:53.934931
370	3471	4050	extractedFrom	2022-03-08 18:22:54.070413
371	3471	4050	extractedFrom	2022-03-08 18:22:54.174955
372	2828	4051	extractedFrom	2022-03-08 18:22:54.313109
373	2828	4052	extractedFrom	2022-03-08 18:22:54.429826
374	2828	4053	extractedFrom	2022-03-08 18:22:54.51855
375	2828	4054	extractedFrom	2022-03-08 18:22:54.591669
376	2828	4055	extractedFrom	2022-03-08 18:22:54.686225
377	2828	4055	extractedFrom	2022-03-08 18:22:54.755501
378	2422	4056	extractedFrom	2022-03-08 18:22:54.825103
379	2422	4057	extractedFrom	2022-03-08 18:22:54.900476
380	2422	4058	extractedFrom	2022-03-08 18:22:54.971844
381	2422	4059	extractedFrom	2022-03-08 18:22:55.045653
382	2422	4060	extractedFrom	2022-03-08 18:22:55.117141
383	2422	4061	extractedFrom	2022-03-08 18:22:55.203671
384	2422	4062	extractedFrom	2022-03-08 18:22:55.270555
385	2422	4063	extractedFrom	2022-03-08 18:22:55.368169
386	2422	4064	extractedFrom	2022-03-08 18:22:55.890145
387	2422	4065	extractedFrom	2022-03-08 18:22:55.959785
388	2422	4066	extractedFrom	2022-03-08 18:22:56.160402
389	2422	4066	extractedFrom	2022-03-08 18:22:56.208256
390	2408	4067	extractedFrom	2022-03-08 18:22:56.276642
391	2408	4068	extractedFrom	2022-03-08 18:22:56.406242
392	2408	4068	extractedFrom	2022-03-08 18:22:56.45514
393	2992	4069	extractedFrom	2022-03-08 18:22:56.520661
394	2992	4070	extractedFrom	2022-03-08 18:22:56.588365
395	2992	4070	extractedFrom	2022-03-08 18:22:56.631281
396	2124	4071	extractedFrom	2022-03-08 18:22:56.777093
397	2124	4072	extractedFrom	2022-03-08 18:22:56.854283
398	2124	4073	extractedFrom	2022-03-08 18:22:56.926094
399	2124	4074	extractedFrom	2022-03-08 18:22:56.99906
400	2124	4075	extractedFrom	2022-03-08 18:22:57.067737
401	2124	4076	extractedFrom	2022-03-08 18:22:57.160066
402	2124	4076	extractedFrom	2022-03-08 18:22:57.201161
403	2800	4077	extractedFrom	2022-03-08 18:22:57.272198
404	2800	4078	extractedFrom	2022-03-08 18:22:57.489201
405	2800	4078	extractedFrom	2022-03-08 18:22:57.665386
406	2778	4079	extractedFrom	2022-03-08 18:22:57.749625
407	2778	4080	extractedFrom	2022-03-08 18:22:57.822067
408	2778	4081	extractedFrom	2022-03-08 18:22:57.980816
409	2778	4082	extractedFrom	2022-03-08 18:22:58.053814
410	2778	4083	extractedFrom	2022-03-08 18:22:58.129265
411	2778	4083	extractedFrom	2022-03-08 18:22:58.173753
412	1996	4084	extractedFrom	2022-03-08 18:22:58.240643
413	1996	4085	extractedFrom	2022-03-08 18:22:58.312771
414	1996	4086	extractedFrom	2022-03-08 18:22:58.503214
415	1996	4087	extractedFrom	2022-03-08 18:22:58.657026
416	1996	4087	extractedFrom	2022-03-08 18:22:58.730974
417	1590	4088	extractedFrom	2022-03-08 18:22:58.875175
418	1590	4088	extractedFrom	2022-03-08 18:22:58.945602
419	2404	4089	extractedFrom	2022-03-08 18:22:59.219405
420	2404	4090	extractedFrom	2022-03-08 18:22:59.397291
421	2404	4091	extractedFrom	2022-03-08 18:22:59.572238
422	2404	4092	extractedFrom	2022-03-08 18:22:59.69827
423	2404	4093	extractedFrom	2022-03-08 18:22:59.873126
424	2404	4094	extractedFrom	2022-03-08 18:23:00.04923
425	2404	4095	extractedFrom	2022-03-08 18:23:00.160478
426	2404	4095	extractedFrom	2022-03-08 18:23:00.207921
427	2763	4096	extractedFrom	2022-03-08 18:23:00.281239
428	2763	4097	extractedFrom	2022-03-08 18:23:00.348613
429	2763	4098	extractedFrom	2022-03-08 18:23:00.482833
430	2763	4099	extractedFrom	2022-03-08 18:23:00.586229
431	2763	4099	extractedFrom	2022-03-08 18:23:00.690827
432	3036	4100	extractedFrom	2022-03-08 18:23:00.76559
433	3036	4101	extractedFrom	2022-03-08 18:23:00.83681
434	3036	4102	extractedFrom	2022-03-08 18:23:00.911485
435	3036	4103	extractedFrom	2022-03-08 18:23:00.980456
436	3036	4104	extractedFrom	2022-03-08 18:23:01.048901
437	3036	4104	extractedFrom	2022-03-08 18:23:01.091715
438	2155	4105	extractedFrom	2022-03-08 18:23:01.29844
439	2155	4106	extractedFrom	2022-03-08 18:23:01.373804
440	2155	4107	extractedFrom	2022-03-08 18:23:01.451705
441	2155	4107	extractedFrom	2022-03-08 18:23:01.505293
442	3343	4108	extractedFrom	2022-03-08 18:23:01.746641
443	3343	4108	extractedFrom	2022-03-08 18:23:01.790904
444	2148	4109	extractedFrom	2022-03-08 18:23:01.873581
445	2148	4110	extractedFrom	2022-03-08 18:23:02.065136
446	2148	4110	extractedFrom	2022-03-08 18:23:02.131691
447	1551	4111	extractedFrom	2022-03-08 18:23:02.206996
448	1551	4111	extractedFrom	2022-03-08 18:23:02.251522
449	2887	4112	extractedFrom	2022-03-08 18:23:02.316538
450	2887	4112	extractedFrom	2022-03-08 18:23:02.41275
451	2625	4113	extractedFrom	2022-03-08 18:23:02.509105
452	2625	4113	extractedFrom	2022-03-08 18:23:02.559779
453	2919	4114	extractedFrom	2022-03-08 18:23:02.634788
454	2919	4115	extractedFrom	2022-03-08 18:23:02.706985
455	2919	4116	extractedFrom	2022-03-08 18:23:02.797467
456	2919	4117	extractedFrom	2022-03-08 18:23:02.976754
457	2919	4118	extractedFrom	2022-03-08 18:23:03.134582
458	2919	4119	extractedFrom	2022-03-08 18:23:03.225791
459	2919	4119	extractedFrom	2022-03-08 18:23:03.272405
460	3174	4120	extractedFrom	2022-03-08 18:23:03.446565
461	3174	4120	extractedFrom	2022-03-08 18:23:03.495402
462	2455	4121	extractedFrom	2022-03-08 18:23:03.563801
463	2455	4122	extractedFrom	2022-03-08 18:23:03.699033
464	2455	4123	extractedFrom	2022-03-08 18:23:03.834554
465	2455	4123	extractedFrom	2022-03-08 18:23:03.919909
466	2612	4124	extractedFrom	2022-03-08 18:23:04.102971
467	2612	4124	extractedFrom	2022-03-08 18:23:04.267621
468	3476	4125	extractedFrom	2022-03-08 18:23:04.374621
469	3476	4125	extractedFrom	2022-03-08 18:23:04.457673
470	1934	4126	extractedFrom	2022-03-08 18:23:04.67983
471	1934	4127	extractedFrom	2022-03-08 18:23:04.872982
472	1934	4127	extractedFrom	2022-03-08 18:23:04.958981
473	2358	4128	extractedFrom	2022-03-08 18:23:05.308499
474	2358	4129	extractedFrom	2022-03-08 18:23:05.594484
475	2358	4130	extractedFrom	2022-03-08 18:23:05.72862
476	2358	4131	extractedFrom	2022-03-08 18:23:05.825664
477	2358	4131	extractedFrom	2022-03-08 18:23:05.882338
478	2589	4132	extractedFrom	2022-03-08 18:23:05.964151
479	2589	4132	extractedFrom	2022-03-08 18:23:06.009243
480	1664	4133	extractedFrom	2022-03-08 18:23:06.083594
481	1664	4133	extractedFrom	2022-03-08 18:23:06.136623
482	2109	4134	extractedFrom	2022-03-08 18:23:06.206241
483	2109	4134	extractedFrom	2022-03-08 18:23:06.252047
484	1920	4135	extractedFrom	2022-03-08 18:23:06.32393
485	1920	4135	extractedFrom	2022-03-08 18:23:06.482495
486	2514	4136	extractedFrom	2022-03-08 18:23:06.662733
487	2514	4137	extractedFrom	2022-03-08 18:23:06.747675
488	2514	4138	extractedFrom	2022-03-08 18:23:06.958675
489	2514	4139	extractedFrom	2022-03-08 18:23:07.154672
490	2514	4140	extractedFrom	2022-03-08 18:23:07.23681
491	2514	4140	extractedFrom	2022-03-08 18:23:07.306759
492	2592	4141	extractedFrom	2022-03-08 18:23:07.383676
493	2592	4141	extractedFrom	2022-03-08 18:23:07.428502
494	3557	4142	extractedFrom	2022-03-08 18:23:07.502363
495	3557	4142	extractedFrom	2022-03-08 18:23:07.546745
496	3577	4143	extractedFrom	2022-03-08 18:23:07.619287
497	3577	4144	extractedFrom	2022-03-08 18:23:07.784964
498	3577	4144	extractedFrom	2022-03-08 18:23:07.829086
499	2997	4145	extractedFrom	2022-03-08 18:23:07.899924
500	2997	4145	extractedFrom	2022-03-08 18:23:07.943108
501	1718	4146	extractedFrom	2022-03-08 18:23:08.014278
502	1718	4146	extractedFrom	2022-03-08 18:23:08.389087
503	3333	4147	extractedFrom	2022-03-08 18:23:08.487056
504	3333	4148	extractedFrom	2022-03-08 18:23:08.641318
505	3333	4148	extractedFrom	2022-03-08 18:23:08.719641
506	1803	4149	extractedFrom	2022-03-08 18:23:08.836432
507	1803	4150	extractedFrom	2022-03-08 18:23:08.986861
508	1803	4150	extractedFrom	2022-03-08 18:23:09.057585
509	3583	4151	extractedFrom	2022-03-08 18:23:09.171406
510	3583	4151	extractedFrom	2022-03-08 18:23:09.235384
511	2495	4152	extractedFrom	2022-03-08 18:23:09.328852
512	2495	4153	extractedFrom	2022-03-08 18:23:09.486575
513	2495	4154	extractedFrom	2022-03-08 18:23:09.847291
514	2495	4155	extractedFrom	2022-03-08 18:23:10.293175
515	2495	4156	extractedFrom	2022-03-08 18:23:10.412778
516	2495	4156	extractedFrom	2022-03-08 18:23:10.684362
517	2222	4157	extractedFrom	2022-03-08 18:23:10.920555
518	2222	4157	extractedFrom	2022-03-08 18:23:10.980838
519	1746	4158	extractedFrom	2022-03-08 18:23:11.078947
520	1746	4158	extractedFrom	2022-03-08 18:23:11.20774
521	1713	4159	extractedFrom	2022-03-08 18:23:11.296974
522	1713	4159	extractedFrom	2022-03-08 18:23:11.354873
523	2949	4160	extractedFrom	2022-03-08 18:23:11.443387
524	2949	4160	extractedFrom	2022-03-08 18:23:11.50134
525	3395	4161	extractedFrom	2022-03-08 18:23:11.593001
526	3395	4161	extractedFrom	2022-03-08 18:23:11.646067
527	2461	4162	extractedFrom	2022-03-08 18:23:11.724877
528	2461	4162	extractedFrom	2022-03-08 18:23:11.777262
529	3484	4163	extractedFrom	2022-03-08 18:23:11.856254
530	3484	4164	extractedFrom	2022-03-08 18:23:12.133155
531	3484	4164	extractedFrom	2022-03-08 18:23:12.258209
532	1773	4165	extractedFrom	2022-03-08 18:23:12.425497
533	1773	4165	extractedFrom	2022-03-08 18:23:12.560845
534	3016	4166	extractedFrom	2022-03-08 18:23:12.705712
535	3016	4166	extractedFrom	2022-03-08 18:23:12.765614
536	2967	4167	extractedFrom	2022-03-08 18:23:12.873633
537	2967	4168	extractedFrom	2022-03-08 18:23:13.027399
538	2967	4168	extractedFrom	2022-03-08 18:23:13.160185
539	2279	4169	extractedFrom	2022-03-08 18:23:13.354143
540	2279	4169	extractedFrom	2022-03-08 18:23:13.425765
541	1764	4170	extractedFrom	2022-03-08 18:23:13.653577
542	1764	4170	extractedFrom	2022-03-08 18:23:13.753281
543	3410	4171	extractedFrom	2022-03-08 18:23:13.838765
544	3410	4172	extractedFrom	2022-03-08 18:23:13.922422
545	3410	4173	extractedFrom	2022-03-08 18:23:14.007166
546	3410	4173	extractedFrom	2022-03-08 18:23:14.055547
547	2082	4174	extractedFrom	2022-03-08 18:23:14.138682
548	2082	4174	extractedFrom	2022-03-08 18:23:14.18719
549	3360	4175	extractedFrom	2022-03-08 18:23:14.50689
550	3360	4175	extractedFrom	2022-03-08 18:23:14.554327
551	2624	4176	extractedFrom	2022-03-08 18:23:14.668378
552	2624	4176	extractedFrom	2022-03-08 18:23:14.711669
553	2260	4177	extractedFrom	2022-03-08 18:23:14.786158
554	2260	4177	extractedFrom	2022-03-08 18:23:14.828584
555	3509	4178	extractedFrom	2022-03-08 18:23:14.903213
556	3509	4179	extractedFrom	2022-03-08 18:23:15.092475
557	3509	4179	extractedFrom	2022-03-08 18:23:15.149973
558	3076	4180	extractedFrom	2022-03-08 18:23:15.214745
559	3076	4180	extractedFrom	2022-03-08 18:23:15.263449
560	1825	4181	extractedFrom	2022-03-08 18:23:15.334886
561	1825	4182	extractedFrom	2022-03-08 18:23:15.440371
562	1825	4182	extractedFrom	2022-03-08 18:23:15.484626
563	1911	4183	extractedFrom	2022-03-08 18:23:15.691779
564	1911	4183	extractedFrom	2022-03-08 18:23:15.738976
565	3386	4184	extractedFrom	2022-03-08 18:23:15.813345
566	3386	4184	extractedFrom	2022-03-08 18:23:15.858937
567	2058	4185	extractedFrom	2022-03-08 18:23:15.918819
568	2058	4185	extractedFrom	2022-03-08 18:23:15.982291
569	2909	4186	extractedFrom	2022-03-08 18:23:16.217027
570	2909	4187	extractedFrom	2022-03-08 18:23:16.376544
571	2909	4188	extractedFrom	2022-03-08 18:23:16.531668
572	2909	4189	extractedFrom	2022-03-08 18:23:16.67012
573	2909	4189	extractedFrom	2022-03-08 18:23:16.731717
574	1560	4190	extractedFrom	2022-03-08 18:23:16.902218
575	1560	4190	extractedFrom	2022-03-08 18:23:16.998978
576	1907	4191	extractedFrom	2022-03-08 18:23:17.122398
577	1907	4191	extractedFrom	2022-03-08 18:23:17.192046
578	3175	4192	extractedFrom	2022-03-08 18:23:17.341836
579	3175	4193	extractedFrom	2022-03-08 18:23:17.479301
580	3175	4194	extractedFrom	2022-03-08 18:23:17.571046
581	3175	4194	extractedFrom	2022-03-08 18:23:17.665401
582	3414	4195	extractedFrom	2022-03-08 18:23:17.854969
583	3414	4195	extractedFrom	2022-03-08 18:23:17.982737
584	2694	4196	extractedFrom	2022-03-08 18:23:18.224096
585	2694	4196	extractedFrom	2022-03-08 18:23:18.271468
586	3244	4197	extractedFrom	2022-03-08 18:23:18.354608
587	3244	4197	extractedFrom	2022-03-08 18:23:18.491448
588	3022	4198	extractedFrom	2022-03-08 18:23:18.567538
589	3022	4198	extractedFrom	2022-03-08 18:23:18.61498
590	3057	4199	extractedFrom	2022-03-08 18:23:18.693689
591	3057	4199	extractedFrom	2022-03-08 18:23:18.839687
592	2886	4200	extractedFrom	2022-03-08 18:23:18.932943
593	2886	4200	extractedFrom	2022-03-08 18:23:18.976513
594	2347	4201	extractedFrom	2022-03-08 18:23:19.042032
595	2347	4201	extractedFrom	2022-03-08 18:23:19.218619
596	3621	4202	extractedFrom	2022-03-08 18:23:19.503947
597	3621	4203	extractedFrom	2022-03-08 18:23:19.575844
598	3621	4204	extractedFrom	2022-03-08 18:23:19.657902
599	3621	4204	extractedFrom	2022-03-08 18:23:19.708637
600	2587	4205	extractedFrom	2022-03-08 18:23:19.825666
601	2587	4205	extractedFrom	2022-03-08 18:23:19.908121
602	1938	4206	extractedFrom	2022-03-08 18:23:20.107652
603	1938	4207	extractedFrom	2022-03-08 18:23:20.225745
604	1938	4208	extractedFrom	2022-03-08 18:23:20.396568
605	1938	4208	extractedFrom	2022-03-08 18:23:20.473333
606	3447	4209	extractedFrom	2022-03-08 18:23:20.749049
607	3447	4209	extractedFrom	2022-03-08 18:23:20.960673
608	1692	4210	extractedFrom	2022-03-08 18:23:21.154383
609	1692	4211	extractedFrom	2022-03-08 18:23:21.377405
610	1692	4211	extractedFrom	2022-03-08 18:23:21.623583
611	3337	4212	extractedFrom	2022-03-08 18:23:21.718492
612	3337	4213	extractedFrom	2022-03-08 18:23:21.827526
613	3337	4213	extractedFrom	2022-03-08 18:23:21.871301
614	2934	4214	extractedFrom	2022-03-08 18:23:21.93532
615	2934	4215	extractedFrom	2022-03-08 18:23:22.002209
616	2934	4215	extractedFrom	2022-03-08 18:23:22.045716
617	3616	4216	extractedFrom	2022-03-08 18:23:22.108577
618	3616	4216	extractedFrom	2022-03-08 18:23:22.146968
619	3618	4217	extractedFrom	2022-03-08 18:23:22.338038
620	3618	4217	extractedFrom	2022-03-08 18:23:22.386163
621	3388	4218	extractedFrom	2022-03-08 18:23:22.483649
622	3388	4218	extractedFrom	2022-03-08 18:23:22.53855
623	1616	4219	extractedFrom	2022-03-08 18:23:22.663583
624	1616	4219	extractedFrom	2022-03-08 18:23:22.709154
625	2830	4220	extractedFrom	2022-03-08 18:23:22.786021
626	2830	4221	extractedFrom	2022-03-08 18:23:23.064799
627	2830	4221	extractedFrom	2022-03-08 18:23:23.122457
628	3420	4222	extractedFrom	2022-03-08 18:23:23.25476
629	3420	4222	extractedFrom	2022-03-08 18:23:23.334837
630	2646	4223	extractedFrom	2022-03-08 18:23:23.463024
631	2646	4223	extractedFrom	2022-03-08 18:23:23.523314
632	3166	4224	extractedFrom	2022-03-08 18:23:23.659221
633	3166	4224	extractedFrom	2022-03-08 18:23:23.780698
634	3452	4225	extractedFrom	2022-03-08 18:23:23.939007
635	3452	4225	extractedFrom	2022-03-08 18:23:24.02964
636	1768	4226	extractedFrom	2022-03-08 18:23:24.163281
637	1768	4226	extractedFrom	2022-03-08 18:23:24.245501
638	2687	4227	extractedFrom	2022-03-08 18:23:24.360424
639	2687	4227	extractedFrom	2022-03-08 18:23:24.432616
640	3117	4228	extractedFrom	2022-03-08 18:23:24.704855
641	3117	4228	extractedFrom	2022-03-08 18:23:24.746642
642	2534	4229	extractedFrom	2022-03-08 18:23:24.826331
643	2534	4229	extractedFrom	2022-03-08 18:23:24.97814
644	2288	4230	extractedFrom	2022-03-08 18:23:25.184294
645	2288	4231	extractedFrom	2022-03-08 18:23:25.257873
646	2288	4231	extractedFrom	2022-03-08 18:23:25.302599
647	2425	4232	extractedFrom	2022-03-08 18:23:25.375277
648	2425	4233	extractedFrom	2022-03-08 18:23:25.498659
649	2425	4233	extractedFrom	2022-03-08 18:23:25.627658
650	3475	4234	extractedFrom	2022-03-08 18:23:25.747353
651	3475	4234	extractedFrom	2022-03-08 18:23:25.824965
652	3318	4235	extractedFrom	2022-03-08 18:23:25.94663
653	3318	4235	extractedFrom	2022-03-08 18:23:26.029003
654	2518	4236	extractedFrom	2022-03-08 18:23:26.186592
655	2518	4236	extractedFrom	2022-03-08 18:23:26.255365
656	3072	4237	extractedFrom	2022-03-08 18:23:26.408876
657	3072	4238	extractedFrom	2022-03-08 18:23:26.576584
658	3072	4239	extractedFrom	2022-03-08 18:23:26.712503
659	3072	4239	extractedFrom	2022-03-08 18:23:26.799446
660	3037	4240	extractedFrom	2022-03-08 18:23:27.202225
661	3037	4241	extractedFrom	2022-03-08 18:23:27.368832
662	3037	4241	extractedFrom	2022-03-08 18:23:27.414714
663	2938	4242	extractedFrom	2022-03-08 18:23:27.553879
664	2938	4243	extractedFrom	2022-03-08 18:23:27.629327
665	2938	4243	extractedFrom	2022-03-08 18:23:27.680581
666	1931	4244	extractedFrom	2022-03-08 18:23:27.76564
667	1931	4244	extractedFrom	2022-03-08 18:23:27.817405
668	3528	4245	extractedFrom	2022-03-08 18:23:27.884378
669	3528	4245	extractedFrom	2022-03-08 18:23:27.928901
670	3642	4246	extractedFrom	2022-03-08 18:23:28.102775
671	3642	4246	extractedFrom	2022-03-08 18:23:28.182496
672	2615	4247	extractedFrom	2022-03-08 18:23:28.394516
673	2615	4247	extractedFrom	2022-03-08 18:23:28.482925
674	2644	4248	extractedFrom	2022-03-08 18:23:28.621823
675	2644	4249	extractedFrom	2022-03-08 18:23:28.912531
676	2644	4249	extractedFrom	2022-03-08 18:23:28.984808
677	2772	4250	extractedFrom	2022-03-08 18:23:29.162333
678	2772	4251	extractedFrom	2022-03-08 18:23:29.301359
679	2772	4251	extractedFrom	2022-03-08 18:23:29.380719
680	3553	4252	extractedFrom	2022-03-08 18:23:29.516734
681	3553	4252	extractedFrom	2022-03-08 18:23:29.608601
682	3558	4253	extractedFrom	2022-03-08 18:23:29.716939
683	3558	4253	extractedFrom	2022-03-08 18:23:29.802919
684	2833	4254	extractedFrom	2022-03-08 18:23:29.900301
685	2833	4255	extractedFrom	2022-03-08 18:23:29.979914
686	2833	4255	extractedFrom	2022-03-08 18:23:30.01955
687	2995	4256	extractedFrom	2022-03-08 18:23:30.082728
688	2995	4256	extractedFrom	2022-03-08 18:23:30.127797
689	3321	4257	extractedFrom	2022-03-08 18:23:30.19233
690	3321	4257	extractedFrom	2022-03-08 18:23:30.234891
691	2145	4258	extractedFrom	2022-03-08 18:23:30.557003
692	2145	4258	extractedFrom	2022-03-08 18:23:30.605835
693	1950	4259	extractedFrom	2022-03-08 18:23:30.675239
694	1950	4259	extractedFrom	2022-03-08 18:23:30.838923
695	3570	4260	extractedFrom	2022-03-08 18:23:31.084837
696	3570	4260	extractedFrom	2022-03-08 18:23:31.127404
697	3530	4261	extractedFrom	2022-03-08 18:23:31.192153
698	3530	4261	extractedFrom	2022-03-08 18:23:31.236614
699	1908	4262	extractedFrom	2022-03-08 18:23:31.298682
700	1908	4262	extractedFrom	2022-03-08 18:23:31.369146
701	2620	4263	extractedFrom	2022-03-08 18:23:31.559612
702	2620	4263	extractedFrom	2022-03-08 18:23:31.837843
703	2316	4264	extractedFrom	2022-03-08 18:23:31.923756
704	2316	4264	extractedFrom	2022-03-08 18:23:31.96208
705	2437	4265	extractedFrom	2022-03-08 18:23:32.203037
706	2437	4265	extractedFrom	2022-03-08 18:23:32.380607
707	2968	4266	extractedFrom	2022-03-08 18:23:32.556132
708	2968	4266	extractedFrom	2022-03-08 18:23:32.658993
709	2574	4267	extractedFrom	2022-03-08 18:23:32.804363
710	2574	4267	extractedFrom	2022-03-08 18:23:32.918838
711	1754	4268	extractedFrom	2022-03-08 18:23:33.060231
712	1754	4269	extractedFrom	2022-03-08 18:23:33.180438
713	1754	4269	extractedFrom	2022-03-08 18:23:33.283099
714	2875	4270	extractedFrom	2022-03-08 18:23:33.457834
715	2875	4271	extractedFrom	2022-03-08 18:23:33.702005
716	2875	4271	extractedFrom	2022-03-08 18:23:33.785671
717	2338	4272	extractedFrom	2022-03-08 18:23:34.073491
718	2338	4273	extractedFrom	2022-03-08 18:23:34.323433
719	2338	4274	extractedFrom	2022-03-08 18:23:34.431394
720	2338	4275	extractedFrom	2022-03-08 18:23:34.565677
721	2338	4276	extractedFrom	2022-03-08 18:23:34.77652
722	2338	4276	extractedFrom	2022-03-08 18:23:34.818788
723	2317	4277	extractedFrom	2022-03-08 18:23:34.881226
724	2317	4277	extractedFrom	2022-03-08 18:23:34.931078
725	1655	4278	extractedFrom	2022-03-08 18:23:35.009434
726	1655	4278	extractedFrom	2022-03-08 18:23:35.054337
727	1780	4279	extractedFrom	2022-03-08 18:23:35.202446
728	1780	4279	extractedFrom	2022-03-08 18:23:35.43838
729	3069	4280	extractedFrom	2022-03-08 18:23:35.520852
730	3069	4280	extractedFrom	2022-03-08 18:23:35.564426
731	1850	4281	extractedFrom	2022-03-08 18:23:35.632413
732	1850	4282	extractedFrom	2022-03-08 18:23:35.734098
733	1850	4282	extractedFrom	2022-03-08 18:23:35.809155
734	1682	4283	extractedFrom	2022-03-08 18:23:35.956165
735	1682	4284	extractedFrom	2022-03-08 18:23:36.077675
736	1682	4284	extractedFrom	2022-03-08 18:23:36.186343
737	3637	4285	extractedFrom	2022-03-08 18:23:36.437178
738	3637	4285	extractedFrom	2022-03-08 18:23:36.551802
739	3146	4286	extractedFrom	2022-03-08 18:23:36.736679
740	3146	4287	extractedFrom	2022-03-08 18:23:36.899602
741	3146	4288	extractedFrom	2022-03-08 18:23:37.345979
742	3146	4288	extractedFrom	2022-03-08 18:23:37.454049
743	1753	4289	extractedFrom	2022-03-08 18:23:37.653355
744	1753	4290	extractedFrom	2022-03-08 18:23:37.846289
745	1753	4290	extractedFrom	2022-03-08 18:23:37.960268
746	2925	4291	extractedFrom	2022-03-08 18:23:38.050963
747	2925	4291	extractedFrom	2022-03-08 18:23:38.095639
748	1960	4292	extractedFrom	2022-03-08 18:23:38.163732
749	1960	4292	extractedFrom	2022-03-08 18:23:38.21216
750	3202	4293	extractedFrom	2022-03-08 18:23:38.274359
751	3202	4293	extractedFrom	2022-03-08 18:23:38.318569
752	1671	4294	extractedFrom	2022-03-08 18:23:38.458634
753	1671	4294	extractedFrom	2022-03-08 18:23:38.532156
754	1905	4295	extractedFrom	2022-03-08 18:23:38.709762
755	1905	4295	extractedFrom	2022-03-08 18:23:38.876961
756	3676	4296	extractedFrom	2022-03-08 18:23:39.039548
757	3676	4296	extractedFrom	2022-03-08 18:23:39.132413
758	3317	4297	extractedFrom	2022-03-08 18:23:39.49553
759	3317	4298	extractedFrom	2022-03-08 18:23:39.633054
760	3317	4299	extractedFrom	2022-03-08 18:23:39.76736
761	3317	4299	extractedFrom	2022-03-08 18:23:39.875505
762	3083	4300	extractedFrom	2022-03-08 18:23:40.05516
763	3083	4301	extractedFrom	2022-03-08 18:23:40.214535
764	3083	4301	extractedFrom	2022-03-08 18:23:40.336501
765	1646	4302	extractedFrom	2022-03-08 18:23:40.448242
766	1646	4302	extractedFrom	2022-03-08 18:23:40.591032
767	3287	4303	extractedFrom	2022-03-08 18:23:40.662888
768	3287	4303	extractedFrom	2022-03-08 18:23:40.791963
769	1880	4304	extractedFrom	2022-03-08 18:23:40.860673
770	1880	4304	extractedFrom	2022-03-08 18:23:40.904719
771	3104	4305	extractedFrom	2022-03-08 18:23:40.968828
772	3104	4305	extractedFrom	2022-03-08 18:23:41.045228
773	2095	4306	extractedFrom	2022-03-08 18:23:41.13574
774	2095	4306	extractedFrom	2022-03-08 18:23:41.184952
775	2747	4307	extractedFrom	2022-03-08 18:23:41.433159
776	2747	4307	extractedFrom	2022-03-08 18:23:41.551905
777	1986	4308	extractedFrom	2022-03-08 18:23:41.871326
778	1986	4308	extractedFrom	2022-03-08 18:23:41.950853
779	1662	4309	extractedFrom	2022-03-08 18:23:42.096615
780	1662	4309	extractedFrom	2022-03-08 18:23:42.182222
781	2557	4310	extractedFrom	2022-03-08 18:23:42.315515
782	2557	4311	extractedFrom	2022-03-08 18:23:42.579612
783	2557	4311	extractedFrom	2022-03-08 18:23:42.661911
784	3153	4312	extractedFrom	2022-03-08 18:23:42.951778
785	3153	4313	extractedFrom	2022-03-08 18:23:43.274358
786	3153	4313	extractedFrom	2022-03-08 18:23:43.451335
787	3216	4314	extractedFrom	2022-03-08 18:23:43.62096
788	3216	4314	extractedFrom	2022-03-08 18:23:43.727057
789	3482	4315	extractedFrom	2022-03-08 18:23:44.018545
790	3482	4316	extractedFrom	2022-03-08 18:23:44.088108
791	3482	4316	extractedFrom	2022-03-08 18:23:44.132571
792	2105	4317	extractedFrom	2022-03-08 18:23:44.196693
793	2105	4317	extractedFrom	2022-03-08 18:23:44.240632
794	3229	4318	extractedFrom	2022-03-08 18:23:44.313341
795	3229	4318	extractedFrom	2022-03-08 18:23:44.352661
796	2740	4319	extractedFrom	2022-03-08 18:23:44.428682
797	2740	4319	extractedFrom	2022-03-08 18:23:44.532833
798	3613	4320	extractedFrom	2022-03-08 18:23:44.607802
799	3613	4320	extractedFrom	2022-03-08 18:23:44.66754
800	2836	4321	extractedFrom	2022-03-08 18:23:44.854736
801	2836	4321	extractedFrom	2022-03-08 18:23:44.932787
802	2677	4322	extractedFrom	2022-03-08 18:23:45.054781
803	2677	4322	extractedFrom	2022-03-08 18:23:45.151032
804	2725	4323	extractedFrom	2022-03-08 18:23:45.28066
805	2725	4323	extractedFrom	2022-03-08 18:23:45.368267
806	1898	4324	extractedFrom	2022-03-08 18:23:45.530289
807	1898	4325	extractedFrom	2022-03-08 18:23:45.67314
808	1898	4325	extractedFrom	2022-03-08 18:23:45.755928
809	2485	4326	extractedFrom	2022-03-08 18:23:45.907158
810	2485	4326	extractedFrom	2022-03-08 18:23:46.08252
811	1759	4327	extractedFrom	2022-03-08 18:23:46.361354
812	1759	4327	extractedFrom	2022-03-08 18:23:46.445785
813	3238	4328	extractedFrom	2022-03-08 18:23:46.570843
814	3238	4328	extractedFrom	2022-03-08 18:23:46.61641
815	3377	4329	extractedFrom	2022-03-08 18:23:46.68779
816	3377	4329	extractedFrom	2022-03-08 18:23:46.730756
817	3362	4330	extractedFrom	2022-03-08 18:23:46.800529
818	3362	4331	extractedFrom	2022-03-08 18:23:46.966134
819	3362	4331	extractedFrom	2022-03-08 18:23:47.022859
820	2069	4332	extractedFrom	2022-03-08 18:23:47.135599
821	2069	4332	extractedFrom	2022-03-08 18:23:47.224783
822	1836	4333	extractedFrom	2022-03-08 18:23:47.414362
823	1836	4333	extractedFrom	2022-03-08 18:23:47.601334
824	2363	4334	extractedFrom	2022-03-08 18:23:47.779866
825	2363	4334	extractedFrom	2022-03-08 18:23:47.918233
826	2456	4335	extractedFrom	2022-03-08 18:23:48.257576
827	2456	4336	extractedFrom	2022-03-08 18:23:48.395021
828	2456	4337	extractedFrom	2022-03-08 18:23:48.557915
829	2456	4337	extractedFrom	2022-03-08 18:23:48.64998
830	1863	4338	extractedFrom	2022-03-08 18:23:48.791105
831	1863	4338	extractedFrom	2022-03-08 18:23:48.863149
832	2672	4339	extractedFrom	2022-03-08 18:23:49.05736
833	2672	4339	extractedFrom	2022-03-08 18:23:49.162566
834	3370	4340	extractedFrom	2022-03-08 18:23:49.446234
835	3370	4340	extractedFrom	2022-03-08 18:23:49.530459
836	2748	4341	extractedFrom	2022-03-08 18:23:49.64045
837	2748	4342	extractedFrom	2022-03-08 18:23:49.709363
838	2748	4342	extractedFrom	2022-03-08 18:23:49.753902
839	1553	4343	extractedFrom	2022-03-08 18:23:49.825697
840	1553	4343	extractedFrom	2022-03-08 18:23:49.905131
841	2594	4344	extractedFrom	2022-03-08 18:23:50.052223
842	2594	4345	extractedFrom	2022-03-08 18:23:50.307983
843	2594	4345	extractedFrom	2022-03-08 18:23:50.440648
844	3567	4346	extractedFrom	2022-03-08 18:23:50.61849
845	3567	4346	extractedFrom	2022-03-08 18:23:50.714479
846	2119	4347	extractedFrom	2022-03-08 18:23:50.908339
847	2119	4347	extractedFrom	2022-03-08 18:23:51.02395
848	1687	4348	extractedFrom	2022-03-08 18:23:51.160836
849	1687	4348	extractedFrom	2022-03-08 18:23:51.255728
850	2665	4349	extractedFrom	2022-03-08 18:23:51.664898
851	2665	4349	extractedFrom	2022-03-08 18:23:51.752471
852	1582	4350	extractedFrom	2022-03-08 18:23:52.022225
853	1582	4350	extractedFrom	2022-03-08 18:23:52.21338
854	2374	4351	extractedFrom	2022-03-08 18:23:52.458054
855	2374	4351	extractedFrom	2022-03-08 18:23:52.499136
856	2671	4352	extractedFrom	2022-03-08 18:23:52.568737
857	2671	4352	extractedFrom	2022-03-08 18:23:52.613923
858	2613	4353	extractedFrom	2022-03-08 18:23:52.714318
859	2613	4353	extractedFrom	2022-03-08 18:23:52.757624
860	2289	4354	extractedFrom	2022-03-08 18:23:52.820899
861	2289	4354	extractedFrom	2022-03-08 18:23:52.874034
862	3240	4355	extractedFrom	2022-03-08 18:23:52.940827
863	3240	4356	extractedFrom	2022-03-08 18:23:53.11535
864	3240	4356	extractedFrom	2022-03-08 18:23:53.156437
865	3662	4357	extractedFrom	2022-03-08 18:23:53.22656
866	3662	4357	extractedFrom	2022-03-08 18:23:53.268296
867	2184	4358	extractedFrom	2022-03-08 18:23:53.332337
868	2184	4359	extractedFrom	2022-03-08 18:23:53.404689
869	2184	4359	extractedFrom	2022-03-08 18:23:53.51889
870	3061	4360	extractedFrom	2022-03-08 18:23:53.648508
871	3061	4360	extractedFrom	2022-03-08 18:23:53.721359
872	2952	4361	extractedFrom	2022-03-08 18:23:53.890941
873	2952	4361	extractedFrom	2022-03-08 18:23:54.073119
874	2256	4362	extractedFrom	2022-03-08 18:23:54.237152
875	2256	4362	extractedFrom	2022-03-08 18:23:54.349317
876	2196	4363	extractedFrom	2022-03-08 18:23:54.534602
877	2196	4363	extractedFrom	2022-03-08 18:23:54.628822
878	3379	4364	extractedFrom	2022-03-08 18:23:54.790496
879	3379	4364	extractedFrom	2022-03-08 18:23:54.958578
880	2762	4365	extractedFrom	2022-03-08 18:23:55.164533
881	2762	4365	extractedFrom	2022-03-08 18:23:55.264671
882	1862	4366	extractedFrom	2022-03-08 18:23:55.466322
883	1862	4367	extractedFrom	2022-03-08 18:23:55.628025
884	1862	4367	extractedFrom	2022-03-08 18:23:55.718951
885	2801	4368	extractedFrom	2022-03-08 18:23:55.791298
886	2801	4369	extractedFrom	2022-03-08 18:23:55.968222
887	2801	4369	extractedFrom	2022-03-08 18:23:56.059927
888	2066	4370	extractedFrom	2022-03-08 18:23:56.24016
889	2066	4370	extractedFrom	2022-03-08 18:23:56.312289
890	2905	4371	extractedFrom	2022-03-08 18:23:56.612502
891	2905	4371	extractedFrom	2022-03-08 18:23:56.723168
892	2966	4372	extractedFrom	2022-03-08 18:23:56.946304
893	2966	4372	extractedFrom	2022-03-08 18:23:57.083016
894	2488	4373	extractedFrom	2022-03-08 18:23:57.35624
895	2488	4373	extractedFrom	2022-03-08 18:23:57.430629
896	1734	4374	extractedFrom	2022-03-08 18:23:57.612844
897	1734	4374	extractedFrom	2022-03-08 18:23:57.713861
898	2724	4375	extractedFrom	2022-03-08 18:23:57.858068
899	2724	4375	extractedFrom	2022-03-08 18:23:57.9916
900	2294	4376	extractedFrom	2022-03-08 18:23:58.459292
901	2294	4376	extractedFrom	2022-03-08 18:23:58.53241
902	3438	4377	extractedFrom	2022-03-08 18:23:58.666651
903	3438	4377	extractedFrom	2022-03-08 18:23:58.758632
904	1961	4378	extractedFrom	2022-03-08 18:23:58.914025
905	1961	4378	extractedFrom	2022-03-08 18:23:59.008343
906	2676	4379	extractedFrom	2022-03-08 18:23:59.353663
907	2676	4379	extractedFrom	2022-03-08 18:23:59.432319
908	2939	4380	extractedFrom	2022-03-08 18:23:59.641964
909	2939	4380	extractedFrom	2022-03-08 18:23:59.721549
910	1547	4381	extractedFrom	2022-03-08 18:23:59.927693
911	1547	4382	extractedFrom	2022-03-08 18:24:00.148476
912	1547	4382	extractedFrom	2022-03-08 18:24:00.301442
913	2829	4383	extractedFrom	2022-03-08 18:24:00.474649
914	2829	4384	extractedFrom	2022-03-08 18:24:00.635069
915	2829	4384	extractedFrom	2022-03-08 18:24:00.681265
916	3365	4385	extractedFrom	2022-03-08 18:24:00.75493
917	3365	4385	extractedFrom	2022-03-08 18:24:00.822263
918	2259	4386	extractedFrom	2022-03-08 18:24:00.922886
919	2259	4386	extractedFrom	2022-03-08 18:24:00.985411
920	2380	4387	extractedFrom	2022-03-08 18:24:01.145845
921	2380	4387	extractedFrom	2022-03-08 18:24:01.216413
922	2906	4388	extractedFrom	2022-03-08 18:24:01.485967
923	2906	4388	extractedFrom	2022-03-08 18:24:01.559562
924	2199	4389	extractedFrom	2022-03-08 18:24:01.696669
925	2199	4389	extractedFrom	2022-03-08 18:24:01.773173
926	3598	4390	extractedFrom	2022-03-08 18:24:02.044734
927	3598	4390	extractedFrom	2022-03-08 18:24:02.121006
928	3674	4391	extractedFrom	2022-03-08 18:24:02.279335
929	3674	4391	extractedFrom	2022-03-08 18:24:02.361361
930	3533	4392	extractedFrom	2022-03-08 18:24:02.613784
931	3533	4392	extractedFrom	2022-03-08 18:24:02.726982
932	2692	4393	extractedFrom	2022-03-08 18:24:02.841347
933	2692	4394	extractedFrom	2022-03-08 18:24:03.093367
934	2692	4395	extractedFrom	2022-03-08 18:24:03.186803
935	2692	4396	extractedFrom	2022-03-08 18:24:03.263817
936	2692	4397	extractedFrom	2022-03-08 18:24:03.338874
937	2692	4398	extractedFrom	2022-03-08 18:24:03.406498
938	2692	4399	extractedFrom	2022-03-08 18:24:03.482687
939	2692	4400	extractedFrom	2022-03-08 18:24:03.64959
940	2692	4401	extractedFrom	2022-03-08 18:24:03.845565
941	2692	4401	extractedFrom	2022-03-08 18:24:03.907859
942	1696	4402	extractedFrom	2022-03-08 18:24:04.150154
943	1696	4402	extractedFrom	2022-03-08 18:24:04.333791
944	3122	4403	extractedFrom	2022-03-08 18:24:04.573546
945	3122	4403	extractedFrom	2022-03-08 18:24:04.672964
946	3672	4404	extractedFrom	2022-03-08 18:24:04.84962
947	3672	4404	extractedFrom	2022-03-08 18:24:04.989411
948	2535	4405	extractedFrom	2022-03-08 18:24:05.152997
949	2535	4406	extractedFrom	2022-03-08 18:24:05.310815
950	2535	4406	extractedFrom	2022-03-08 18:24:05.44468
951	2790	4407	extractedFrom	2022-03-08 18:24:05.675731
952	2790	4407	extractedFrom	2022-03-08 18:24:05.75664
953	2252	4408	extractedFrom	2022-03-08 18:24:05.972552
954	2252	4408	extractedFrom	2022-03-08 18:24:06.038337
955	1945	4409	extractedFrom	2022-03-08 18:24:06.110651
956	1945	4410	extractedFrom	2022-03-08 18:24:06.178708
957	1945	4410	extractedFrom	2022-03-08 18:24:06.249286
958	3295	4411	extractedFrom	2022-03-08 18:24:06.468027
959	3295	4411	extractedFrom	2022-03-08 18:24:06.558353
960	1909	4412	extractedFrom	2022-03-08 18:24:06.677843
961	1909	4412	extractedFrom	2022-03-08 18:24:06.754162
962	2884	4413	extractedFrom	2022-03-08 18:24:06.883826
963	2884	4413	extractedFrom	2022-03-08 18:24:06.993746
964	3421	4414	extractedFrom	2022-03-08 18:24:07.14629
965	3421	4414	extractedFrom	2022-03-08 18:24:07.329521
966	2657	4415	extractedFrom	2022-03-08 18:24:07.523966
967	2657	4416	extractedFrom	2022-03-08 18:24:07.731684
968	2657	4416	extractedFrom	2022-03-08 18:24:07.838206
969	3090	4417	extractedFrom	2022-03-08 18:24:08.066561
970	3090	4417	extractedFrom	2022-03-08 18:24:08.175199
971	3155	4418	extractedFrom	2022-03-08 18:24:08.408961
972	3155	4419	extractedFrom	2022-03-08 18:24:08.491187
973	3155	4419	extractedFrom	2022-03-08 18:24:08.535276
974	3319	4420	extractedFrom	2022-03-08 18:24:08.657794
975	3319	4420	extractedFrom	2022-03-08 18:24:08.703216
976	3141	4421	extractedFrom	2022-03-08 18:24:08.838406
977	3141	4421	extractedFrom	2022-03-08 18:24:08.940959
978	3628	4422	extractedFrom	2022-03-08 18:24:09.103378
979	3628	4422	extractedFrom	2022-03-08 18:24:09.171138
980	2282	4423	extractedFrom	2022-03-08 18:24:09.289529
981	2282	4424	extractedFrom	2022-03-08 18:24:09.446802
982	2282	4424	extractedFrom	2022-03-08 18:24:09.543279
983	2926	4425	extractedFrom	2022-03-08 18:24:09.785564
984	2926	4425	extractedFrom	2022-03-08 18:24:09.867493
985	3654	4426	extractedFrom	2022-03-08 18:24:10.141407
986	3654	4427	extractedFrom	2022-03-08 18:24:10.35775
987	3654	4428	extractedFrom	2022-03-08 18:24:10.534441
988	3654	4428	extractedFrom	2022-03-08 18:24:10.623372
989	1689	4429	extractedFrom	2022-03-08 18:24:10.698897
990	1689	4429	extractedFrom	2022-03-08 18:24:10.746979
991	3096	4430	extractedFrom	2022-03-08 18:24:10.82622
992	3096	4431	extractedFrom	2022-03-08 18:24:10.899694
993	3096	4431	extractedFrom	2022-03-08 18:24:10.947762
994	2153	4432	extractedFrom	2022-03-08 18:24:11.010604
995	2153	4433	extractedFrom	2022-03-08 18:24:11.085639
996	2153	4434	extractedFrom	2022-03-08 18:24:11.152405
997	2153	4435	extractedFrom	2022-03-08 18:24:11.37699
998	2153	4436	extractedFrom	2022-03-08 18:24:11.625535
999	2153	4437	extractedFrom	2022-03-08 18:24:11.714566
1000	2153	4438	extractedFrom	2022-03-08 18:24:11.857729
1001	2153	4439	extractedFrom	2022-03-08 18:24:12.006727
1002	2153	4440	extractedFrom	2022-03-08 18:24:12.180236
1003	2153	4440	extractedFrom	2022-03-08 18:24:12.301298
1004	1814	4441	extractedFrom	2022-03-08 18:24:12.570788
1005	1814	4442	extractedFrom	2022-03-08 18:24:12.801134
1006	1814	4442	extractedFrom	2022-03-08 18:24:12.864932
1007	3376	4443	extractedFrom	2022-03-08 18:24:13.079764
1008	3376	4443	extractedFrom	2022-03-08 18:24:13.255038
1009	3467	4444	extractedFrom	2022-03-08 18:24:13.465431
1010	3467	4444	extractedFrom	2022-03-08 18:24:13.510581
1011	2295	4445	extractedFrom	2022-03-08 18:24:13.576768
1012	2295	4445	extractedFrom	2022-03-08 18:24:13.643371
1013	3293	4446	extractedFrom	2022-03-08 18:24:13.708431
1014	3293	4446	extractedFrom	2022-03-08 18:24:13.756808
1015	1675	4447	extractedFrom	2022-03-08 18:24:13.846131
1016	1675	4447	extractedFrom	2022-03-08 18:24:13.960613
1017	1794	4448	extractedFrom	2022-03-08 18:24:14.108444
1018	1794	4448	extractedFrom	2022-03-08 18:24:14.181694
1019	2670	4449	extractedFrom	2022-03-08 18:24:14.301501
1020	2670	4449	extractedFrom	2022-03-08 18:24:14.420351
1021	2573	4450	extractedFrom	2022-03-08 18:24:14.591632
1022	2573	4451	extractedFrom	2022-03-08 18:24:14.793607
1023	2573	4451	extractedFrom	2022-03-08 18:24:14.924605
1024	2121	4452	extractedFrom	2022-03-08 18:24:15.292906
1025	2121	4452	extractedFrom	2022-03-08 18:24:15.4016
1026	2227	4453	extractedFrom	2022-03-08 18:24:15.528806
1027	2227	4454	extractedFrom	2022-03-08 18:24:15.671191
1028	2227	4454	extractedFrom	2022-03-08 18:24:15.742799
1029	3480	4455	extractedFrom	2022-03-08 18:24:15.850947
1030	3480	4456	extractedFrom	2022-03-08 18:24:15.970059
1031	3480	4457	extractedFrom	2022-03-08 18:24:16.039286
1032	3480	4457	extractedFrom	2022-03-08 18:24:16.084101
1033	2532	4458	extractedFrom	2022-03-08 18:24:16.167835
1034	2532	4458	extractedFrom	2022-03-08 18:24:16.25604
1035	3300	4459	extractedFrom	2022-03-08 18:24:16.457647
1036	3300	4459	extractedFrom	2022-03-08 18:24:16.512873
1037	2386	4460	extractedFrom	2022-03-08 18:24:16.642392
1038	2386	4461	extractedFrom	2022-03-08 18:24:16.738295
1039	2386	4462	extractedFrom	2022-03-08 18:24:16.957077
1040	2386	4463	extractedFrom	2022-03-08 18:24:17.189611
1041	2386	4464	extractedFrom	2022-03-08 18:24:17.359113
1042	2386	4465	extractedFrom	2022-03-08 18:24:17.500468
1043	2386	4466	extractedFrom	2022-03-08 18:24:17.664043
1044	2386	4466	extractedFrom	2022-03-08 18:24:17.758922
1045	3486	4467	extractedFrom	2022-03-08 18:24:17.905709
1046	3486	4468	extractedFrom	2022-03-08 18:24:18.048677
1047	3486	4468	extractedFrom	2022-03-08 18:24:18.095294
1048	1810	4469	extractedFrom	2022-03-08 18:24:18.176809
1049	1810	4469	extractedFrom	2022-03-08 18:24:18.2515
1050	3043	4470	extractedFrom	2022-03-08 18:24:18.41362
1051	3043	4470	extractedFrom	2022-03-08 18:24:18.619283
1052	2954	4471	extractedFrom	2022-03-08 18:24:18.891114
1053	2954	4472	extractedFrom	2022-03-08 18:24:19.150308
1054	2954	4473	extractedFrom	2022-03-08 18:24:19.266528
1055	2954	4474	extractedFrom	2022-03-08 18:24:19.431246
1056	2954	4474	extractedFrom	2022-03-08 18:24:19.50418
1057	2601	4475	extractedFrom	2022-03-08 18:24:19.666658
1058	2601	4476	extractedFrom	2022-03-08 18:24:19.856141
1059	2601	4476	extractedFrom	2022-03-08 18:24:19.918826
1060	2554	4477	extractedFrom	2022-03-08 18:24:20.06685
1061	2554	4478	extractedFrom	2022-03-08 18:24:20.213861
1062	2554	4478	extractedFrom	2022-03-08 18:24:20.28527
1063	1707	4479	extractedFrom	2022-03-08 18:24:20.371613
1064	1707	4479	extractedFrom	2022-03-08 18:24:20.415225
1065	2151	4480	extractedFrom	2022-03-08 18:24:20.522883
1066	2151	4481	extractedFrom	2022-03-08 18:24:20.609772
1067	2151	4481	extractedFrom	2022-03-08 18:24:20.657316
1068	1589	4482	extractedFrom	2022-03-08 18:24:20.806926
1069	1589	4483	extractedFrom	2022-03-08 18:24:21.008057
1070	1589	4484	extractedFrom	2022-03-08 18:24:21.258473
1071	1589	4484	extractedFrom	2022-03-08 18:24:21.341483
1072	2693	4485	extractedFrom	2022-03-08 18:24:21.521587
1073	2693	4485	extractedFrom	2022-03-08 18:24:21.642479
1074	3358	4486	extractedFrom	2022-03-08 18:24:21.860453
1075	3358	4486	extractedFrom	2022-03-08 18:24:21.992077
1076	3380	4487	extractedFrom	2022-03-08 18:24:22.17477
1077	3380	4488	extractedFrom	2022-03-08 18:24:22.351071
1078	3380	4488	extractedFrom	2022-03-08 18:24:22.431258
1079	3653	4489	extractedFrom	2022-03-08 18:24:22.605684
1080	3653	4490	extractedFrom	2022-03-08 18:24:22.931273
1081	3653	4490	extractedFrom	2022-03-08 18:24:23.020729
1082	2660	4491	extractedFrom	2022-03-08 18:24:23.094243
1083	2660	4491	extractedFrom	2022-03-08 18:24:23.138667
1084	2771	4492	extractedFrom	2022-03-08 18:24:23.20101
1085	2771	4493	extractedFrom	2022-03-08 18:24:23.270011
1086	2771	4494	extractedFrom	2022-03-08 18:24:23.345128
1087	2771	4495	extractedFrom	2022-03-08 18:24:23.428062
1088	2771	4495	extractedFrom	2022-03-08 18:24:23.547732
1089	3601	4496	extractedFrom	2022-03-08 18:24:23.830219
1090	3601	4497	extractedFrom	2022-03-08 18:24:24.004655
1091	3601	4497	extractedFrom	2022-03-08 18:24:24.30632
1092	1955	4498	extractedFrom	2022-03-08 18:24:24.403405
1093	1955	4498	extractedFrom	2022-03-08 18:24:24.48156
1094	3409	4499	extractedFrom	2022-03-08 18:24:24.670943
1095	3409	4499	extractedFrom	2022-03-08 18:24:24.748153
1096	3000	4500	extractedFrom	2022-03-08 18:24:24.898736
1097	3000	4501	extractedFrom	2022-03-08 18:24:25.049237
1098	3000	4502	extractedFrom	2022-03-08 18:24:25.125558
1099	3000	4503	extractedFrom	2022-03-08 18:24:25.237219
1100	3000	4504	extractedFrom	2022-03-08 18:24:25.299817
1101	3000	4504	extractedFrom	2022-03-08 18:24:25.487015
1102	3344	4505	extractedFrom	2022-03-08 18:24:25.586822
1103	3344	4506	extractedFrom	2022-03-08 18:24:25.860604
1104	3344	4506	extractedFrom	2022-03-08 18:24:25.948683
1105	3375	4507	extractedFrom	2022-03-08 18:24:26.099418
1106	3375	4507	extractedFrom	2022-03-08 18:24:26.193745
1107	3284	4508	extractedFrom	2022-03-08 18:24:26.414641
1108	3284	4508	extractedFrom	2022-03-08 18:24:26.615721
1109	3488	4509	extractedFrom	2022-03-08 18:24:26.844114
1110	3488	4510	extractedFrom	2022-03-08 18:24:27.014126
1111	3488	4510	extractedFrom	2022-03-08 18:24:27.137514
1112	3266	4511	extractedFrom	2022-03-08 18:24:27.332459
1113	3266	4512	extractedFrom	2022-03-08 18:24:27.526474
1114	3266	4513	extractedFrom	2022-03-08 18:24:27.694894
1115	3266	4514	extractedFrom	2022-03-08 18:24:27.787719
1116	3266	4515	extractedFrom	2022-03-08 18:24:27.95312
1117	3266	4515	extractedFrom	2022-03-08 18:24:28.017728
1118	1632	4516	extractedFrom	2022-03-08 18:24:28.17651
1119	1632	4516	extractedFrom	2022-03-08 18:24:28.2747
1120	2568	4517	extractedFrom	2022-03-08 18:24:28.545289
1121	2568	4517	extractedFrom	2022-03-08 18:24:28.670766
1122	1650	4518	extractedFrom	2022-03-08 18:24:28.850342
1123	1650	4518	extractedFrom	2022-03-08 18:24:28.938532
1124	1809	4519	extractedFrom	2022-03-08 18:24:29.045861
1125	1809	4519	extractedFrom	2022-03-08 18:24:29.145223
1126	3507	4520	extractedFrom	2022-03-08 18:24:29.287368
1127	3507	4521	extractedFrom	2022-03-08 18:24:29.62372
1128	3507	4521	extractedFrom	2022-03-08 18:24:29.711672
1129	1947	4522	extractedFrom	2022-03-08 18:24:29.81933
1130	1947	4523	extractedFrom	2022-03-08 18:24:29.996739
1131	1947	4524	extractedFrom	2022-03-08 18:24:30.122217
1132	1947	4524	extractedFrom	2022-03-08 18:24:30.174037
1133	2504	4525	extractedFrom	2022-03-08 18:24:30.246561
1134	2504	4526	extractedFrom	2022-03-08 18:24:30.33121
1135	2504	4526	extractedFrom	2022-03-08 18:24:30.417419
1136	2823	4527	extractedFrom	2022-03-08 18:24:30.576141
1137	2823	4528	extractedFrom	2022-03-08 18:24:30.667406
1138	2823	4528	extractedFrom	2022-03-08 18:24:30.712345
1139	3084	4529	extractedFrom	2022-03-08 18:24:30.867202
1140	3084	4530	extractedFrom	2022-03-08 18:24:30.934914
1141	3084	4531	extractedFrom	2022-03-08 18:24:31.014074
1142	3084	4531	extractedFrom	2022-03-08 18:24:31.057985
1143	3619	4532	extractedFrom	2022-03-08 18:24:31.330173
1144	3619	4532	extractedFrom	2022-03-08 18:24:31.397777
1145	2083	4533	extractedFrom	2022-03-08 18:24:31.64885
1146	2083	4534	extractedFrom	2022-03-08 18:24:31.963269
1147	2083	4534	extractedFrom	2022-03-08 18:24:32.023907
1148	2776	4535	extractedFrom	2022-03-08 18:24:32.19431
1149	2776	4535	extractedFrom	2022-03-08 18:24:32.25623
1150	1598	4536	extractedFrom	2022-03-08 18:24:32.435074
1151	1598	4536	extractedFrom	2022-03-08 18:24:32.541525
1152	3620	4537	extractedFrom	2022-03-08 18:24:32.807896
1153	3620	4537	extractedFrom	2022-03-08 18:24:32.932108
1154	2357	4538	extractedFrom	2022-03-08 18:24:33.133931
1155	2357	4539	extractedFrom	2022-03-08 18:24:33.254006
1156	2357	4540	extractedFrom	2022-03-08 18:24:33.326934
1157	2357	4541	extractedFrom	2022-03-08 18:24:33.401937
1158	2357	4542	extractedFrom	2022-03-08 18:24:33.496371
1159	2357	4542	extractedFrom	2022-03-08 18:24:33.700104
1160	3118	4543	extractedFrom	2022-03-08 18:24:33.805175
1161	3118	4544	extractedFrom	2022-03-08 18:24:33.90402
1162	3118	4545	extractedFrom	2022-03-08 18:24:33.979749
1163	3118	4545	extractedFrom	2022-03-08 18:24:34.024358
1164	2236	4546	extractedFrom	2022-03-08 18:24:34.086773
1165	2236	4546	extractedFrom	2022-03-08 18:24:34.16357
1166	3114	4547	extractedFrom	2022-03-08 18:24:34.380587
1167	3114	4548	extractedFrom	2022-03-08 18:24:34.47478
1168	3114	4549	extractedFrom	2022-03-08 18:24:34.759152
1169	3114	4550	extractedFrom	2022-03-08 18:24:34.838802
1170	3114	4551	extractedFrom	2022-03-08 18:24:34.984564
1171	3114	4552	extractedFrom	2022-03-08 18:24:35.082656
1172	3114	4553	extractedFrom	2022-03-08 18:24:35.155826
1173	3114	4554	extractedFrom	2022-03-08 18:24:35.224993
1174	3114	4554	extractedFrom	2022-03-08 18:24:35.276315
1175	2824	4555	extractedFrom	2022-03-08 18:24:35.413969
1176	2824	4555	extractedFrom	2022-03-08 18:24:35.493642
1177	3014	4556	extractedFrom	2022-03-08 18:24:35.68615
1178	3014	4556	extractedFrom	2022-03-08 18:24:35.74149
1179	1658	4557	extractedFrom	2022-03-08 18:24:35.850663
1180	1658	4557	extractedFrom	2022-03-08 18:24:35.93766
1181	2075	4558	extractedFrom	2022-03-08 18:24:36.061551
1182	2075	4558	extractedFrom	2022-03-08 18:24:36.153841
1183	3243	4559	extractedFrom	2022-03-08 18:24:36.348699
1184	3243	4559	extractedFrom	2022-03-08 18:24:36.415846
1185	1781	4560	extractedFrom	2022-03-08 18:24:36.633268
1186	1781	4560	extractedFrom	2022-03-08 18:24:36.70544
1187	2956	4561	extractedFrom	2022-03-08 18:24:36.847192
1188	2956	4561	extractedFrom	2022-03-08 18:24:36.940672
1189	2401	4562	extractedFrom	2022-03-08 18:24:37.069385
1190	2401	4563	extractedFrom	2022-03-08 18:24:37.329504
1191	2401	4563	extractedFrom	2022-03-08 18:24:37.37825
1192	2373	4564	extractedFrom	2022-03-08 18:24:37.524352
1193	2373	4564	extractedFrom	2022-03-08 18:24:37.589504
1194	2799	4565	extractedFrom	2022-03-08 18:24:37.655556
1195	2799	4565	extractedFrom	2022-03-08 18:24:37.701549
1196	2893	4566	extractedFrom	2022-03-08 18:24:37.772537
1197	2893	4567	extractedFrom	2022-03-08 18:24:37.966118
1198	2893	4568	extractedFrom	2022-03-08 18:24:38.113976
1199	2893	4569	extractedFrom	2022-03-08 18:24:38.194187
1200	2893	4570	extractedFrom	2022-03-08 18:24:38.266375
1201	2893	4570	extractedFrom	2022-03-08 18:24:38.308308
1202	2654	4571	extractedFrom	2022-03-08 18:24:38.37192
1203	2654	4571	extractedFrom	2022-03-08 18:24:38.750067
1204	2638	4572	extractedFrom	2022-03-08 18:24:38.840854
1205	2638	4572	extractedFrom	2022-03-08 18:24:38.883849
1206	2023	4573	extractedFrom	2022-03-08 18:24:38.947502
1207	2023	4573	extractedFrom	2022-03-08 18:24:38.990649
1208	1739	4574	extractedFrom	2022-03-08 18:24:39.056055
1209	1739	4575	extractedFrom	2022-03-08 18:24:39.179792
1210	1739	4576	extractedFrom	2022-03-08 18:24:39.243303
1211	1739	4576	extractedFrom	2022-03-08 18:24:39.286997
1212	2471	4577	extractedFrom	2022-03-08 18:24:39.348599
1213	2471	4577	extractedFrom	2022-03-08 18:24:39.444567
1214	3401	4578	extractedFrom	2022-03-08 18:24:39.684997
1215	3401	4579	extractedFrom	2022-03-08 18:24:39.819702
1216	3401	4579	extractedFrom	2022-03-08 18:24:39.937098
1217	1856	4580	extractedFrom	2022-03-08 18:24:40.11876
1218	1856	4581	extractedFrom	2022-03-08 18:24:40.314743
1219	1856	4582	extractedFrom	2022-03-08 18:24:40.428293
1220	1856	4583	extractedFrom	2022-03-08 18:24:40.592343
1221	1856	4584	extractedFrom	2022-03-08 18:24:40.754952
1222	1856	4585	extractedFrom	2022-03-08 18:24:40.960067
1223	1856	4586	extractedFrom	2022-03-08 18:24:41.205081
1224	1856	4586	extractedFrom	2022-03-08 18:24:41.258019
1225	1550	4587	extractedFrom	2022-03-08 18:24:41.399345
1226	1550	4588	extractedFrom	2022-03-08 18:24:41.525286
1227	1550	4588	extractedFrom	2022-03-08 18:24:41.604615
1228	3017	4589	extractedFrom	2022-03-08 18:24:41.786071
1229	3017	4589	extractedFrom	2022-03-08 18:24:41.842379
1230	2947	4590	extractedFrom	2022-03-08 18:24:41.911246
1231	2947	4590	extractedFrom	2022-03-08 18:24:41.955678
1232	2505	4591	extractedFrom	2022-03-08 18:24:42.271512
1233	2505	4592	extractedFrom	2022-03-08 18:24:42.566275
1234	2505	4592	extractedFrom	2022-03-08 18:24:42.608333
1235	2476	4593	extractedFrom	2022-03-08 18:24:42.799359
1236	2476	4593	extractedFrom	2022-03-08 18:24:42.849239
1237	3089	4594	extractedFrom	2022-03-08 18:24:43.039164
1238	3089	4595	extractedFrom	2022-03-08 18:24:43.30817
1239	3089	4596	extractedFrom	2022-03-08 18:24:43.377802
1240	3089	4597	extractedFrom	2022-03-08 18:24:43.444951
1241	3089	4598	extractedFrom	2022-03-08 18:24:43.568616
1242	3089	4599	extractedFrom	2022-03-08 18:24:43.923847
1243	3089	4599	extractedFrom	2022-03-08 18:24:43.982333
1244	3298	4600	extractedFrom	2022-03-08 18:24:44.21651
1245	3298	4601	extractedFrom	2022-03-08 18:24:44.402719
1246	3298	4601	extractedFrom	2022-03-08 18:24:44.4874
1247	2192	4602	extractedFrom	2022-03-08 18:24:44.623893
1248	2192	4602	extractedFrom	2022-03-08 18:24:44.715432
1249	2579	4603	extractedFrom	2022-03-08 18:24:44.836634
1250	2579	4604	extractedFrom	2022-03-08 18:24:44.989037
1251	2579	4604	extractedFrom	2022-03-08 18:24:45.059952
1252	3422	4605	extractedFrom	2022-03-08 18:24:45.216454
1253	3422	4605	extractedFrom	2022-03-08 18:24:45.552283
1254	1984	4606	extractedFrom	2022-03-08 18:24:45.63056
1255	1984	4607	extractedFrom	2022-03-08 18:24:45.746412
1256	1984	4608	extractedFrom	2022-03-08 18:24:45.822299
1257	1984	4608	extractedFrom	2022-03-08 18:24:45.874164
1258	2581	4609	extractedFrom	2022-03-08 18:24:45.953338
1259	2581	4609	extractedFrom	2022-03-08 18:24:46.001498
1260	2253	4610	extractedFrom	2022-03-08 18:24:46.07716
1261	2253	4611	extractedFrom	2022-03-08 18:24:46.155604
1262	2253	4612	extractedFrom	2022-03-08 18:24:46.311869
1263	2253	4612	extractedFrom	2022-03-08 18:24:46.466136
1264	2392	4613	extractedFrom	2022-03-08 18:24:46.558578
1265	2392	4614	extractedFrom	2022-03-08 18:24:46.631212
1266	2392	4614	extractedFrom	2022-03-08 18:24:46.68282
1267	2730	4615	extractedFrom	2022-03-08 18:24:47.016591
1268	2730	4615	extractedFrom	2022-03-08 18:24:47.131736
1269	2742	4616	extractedFrom	2022-03-08 18:24:47.208433
1270	2742	4616	extractedFrom	2022-03-08 18:24:47.247874
1271	3270	4617	extractedFrom	2022-03-08 18:24:47.312376
1272	3270	4618	extractedFrom	2022-03-08 18:24:47.383658
1273	3270	4619	extractedFrom	2022-03-08 18:24:47.450308
1274	3270	4619	extractedFrom	2022-03-08 18:24:47.490519
1275	1956	4620	extractedFrom	2022-03-08 18:24:47.555353
1276	1956	4621	extractedFrom	2022-03-08 18:24:47.720434
1277	1956	4622	extractedFrom	2022-03-08 18:24:47.794476
1278	1956	4622	extractedFrom	2022-03-08 18:24:47.831983
1279	3399	4623	extractedFrom	2022-03-08 18:24:47.905032
1280	3399	4623	extractedFrom	2022-03-08 18:24:48.005541
1281	3453	4624	extractedFrom	2022-03-08 18:24:48.122681
1282	3453	4625	extractedFrom	2022-03-08 18:24:48.235736
1283	3453	4625	extractedFrom	2022-03-08 18:24:48.32368
1284	2352	4626	extractedFrom	2022-03-08 18:24:48.44601
1285	2352	4626	extractedFrom	2022-03-08 18:24:48.512245
1286	3373	4627	extractedFrom	2022-03-08 18:24:48.998325
1287	3373	4627	extractedFrom	2022-03-08 18:24:49.12778
1288	3193	4628	extractedFrom	2022-03-08 18:24:49.357349
1289	3193	4629	extractedFrom	2022-03-08 18:24:49.515595
1290	3193	4629	extractedFrom	2022-03-08 18:24:49.651078
1291	2225	4630	extractedFrom	2022-03-08 18:24:49.729292
1292	2225	4630	extractedFrom	2022-03-08 18:24:49.771261
1293	3106	4631	extractedFrom	2022-03-08 18:24:49.843778
1294	3106	4631	extractedFrom	2022-03-08 18:24:49.890907
1295	1564	4632	extractedFrom	2022-03-08 18:24:49.964196
1296	1564	4633	extractedFrom	2022-03-08 18:24:50.050266
1297	1564	4634	extractedFrom	2022-03-08 18:24:50.13229
1298	1564	4635	extractedFrom	2022-03-08 18:24:50.252083
1299	1564	4636	extractedFrom	2022-03-08 18:24:50.327824
1300	1564	4637	extractedFrom	2022-03-08 18:24:50.427602
1301	1564	4637	extractedFrom	2022-03-08 18:24:50.476506
1302	2079	4638	extractedFrom	2022-03-08 18:24:50.560699
1303	2079	4639	extractedFrom	2022-03-08 18:24:50.637856
1304	2079	4640	extractedFrom	2022-03-08 18:24:50.910619
1305	2079	4640	extractedFrom	2022-03-08 18:24:50.956724
1306	2808	4641	extractedFrom	2022-03-08 18:24:51.046675
1307	2808	4641	extractedFrom	2022-03-08 18:24:51.096042
1308	1897	4642	extractedFrom	2022-03-08 18:24:51.173769
1309	1897	4643	extractedFrom	2022-03-08 18:24:51.249271
1310	1897	4644	extractedFrom	2022-03-08 18:24:51.329872
1311	1897	4644	extractedFrom	2022-03-08 18:24:51.428851
1312	2969	4645	extractedFrom	2022-03-08 18:24:51.610901
1313	2969	4646	extractedFrom	2022-03-08 18:24:51.74842
1314	2969	4646	extractedFrom	2022-03-08 18:24:51.87554
1315	2779	4647	extractedFrom	2022-03-08 18:24:52.00571
1316	2779	4647	extractedFrom	2022-03-08 18:24:52.125572
1317	1798	4648	extractedFrom	2022-03-08 18:24:52.272554
1318	1798	4648	extractedFrom	2022-03-08 18:24:52.370678
1319	2733	4649	extractedFrom	2022-03-08 18:24:52.53738
1320	2733	4650	extractedFrom	2022-03-08 18:24:52.718571
1321	2733	4650	extractedFrom	2022-03-08 18:24:52.787314
1322	2669	4651	extractedFrom	2022-03-08 18:24:52.963438
1323	2669	4651	extractedFrom	2022-03-08 18:24:53.036069
1324	3187	4652	extractedFrom	2022-03-08 18:24:53.184251
1325	3187	4652	extractedFrom	2022-03-08 18:24:53.251229
1326	2709	4653	extractedFrom	2022-03-08 18:24:53.346633
1327	2709	4654	extractedFrom	2022-03-08 18:24:53.411992
1328	2709	4655	extractedFrom	2022-03-08 18:24:53.478525
1329	2709	4655	extractedFrom	2022-03-08 18:24:53.52274
1330	2777	4656	extractedFrom	2022-03-08 18:24:53.641276
1331	2777	4656	extractedFrom	2022-03-08 18:24:53.733586
1332	3383	4657	extractedFrom	2022-03-08 18:24:53.805495
1333	3383	4657	extractedFrom	2022-03-08 18:24:53.850154
1334	2761	4658	extractedFrom	2022-03-08 18:24:53.913644
1335	2761	4658	extractedFrom	2022-03-08 18:24:53.958216
1336	1716	4659	extractedFrom	2022-03-08 18:24:54.022037
1337	1716	4659	extractedFrom	2022-03-08 18:24:54.068018
1338	1968	4660	extractedFrom	2022-03-08 18:24:54.197484
1339	1968	4661	extractedFrom	2022-03-08 18:24:54.364074
1340	1968	4661	extractedFrom	2022-03-08 18:24:54.408284
1341	3257	4662	extractedFrom	2022-03-08 18:24:54.490563
1342	3257	4662	extractedFrom	2022-03-08 18:24:54.745678
1343	3494	4663	extractedFrom	2022-03-08 18:24:54.823712
1344	3494	4664	extractedFrom	2022-03-08 18:24:54.89761
1345	3494	4665	extractedFrom	2022-03-08 18:24:55.035184
1346	3494	4665	extractedFrom	2022-03-08 18:24:55.094494
1347	3404	4666	extractedFrom	2022-03-08 18:24:55.191147
1348	3404	4667	extractedFrom	2022-03-08 18:24:55.432308
1349	3404	4667	extractedFrom	2022-03-08 18:24:55.576833
1350	3499	4668	extractedFrom	2022-03-08 18:24:55.693022
1351	3499	4668	extractedFrom	2022-03-08 18:24:55.776266
1352	3518	4669	extractedFrom	2022-03-08 18:24:55.934771
1353	3518	4670	extractedFrom	2022-03-08 18:24:56.102609
1354	3518	4670	extractedFrom	2022-03-08 18:24:56.174805
1355	2537	4671	extractedFrom	2022-03-08 18:24:56.324517
1356	2537	4672	extractedFrom	2022-03-08 18:24:56.469113
1357	2537	4673	extractedFrom	2022-03-08 18:24:56.619813
1358	2537	4673	extractedFrom	2022-03-08 18:24:56.67958
1359	2821	4674	extractedFrom	2022-03-08 18:24:56.845838
1360	2821	4675	extractedFrom	2022-03-08 18:24:57.003234
1361	2821	4676	extractedFrom	2022-03-08 18:24:57.176415
1362	2821	4677	extractedFrom	2022-03-08 18:24:57.268478
1363	2821	4678	extractedFrom	2022-03-08 18:24:57.36168
1364	2821	4678	extractedFrom	2022-03-08 18:24:57.771807
1365	2717	4679	extractedFrom	2022-03-08 18:24:58.127276
1366	2717	4679	extractedFrom	2022-03-08 18:24:58.189179
1367	3431	4680	extractedFrom	2022-03-08 18:24:58.26315
1368	3431	4680	extractedFrom	2022-03-08 18:24:58.31988
1369	2052	4681	extractedFrom	2022-03-08 18:24:58.386939
1370	2052	4681	extractedFrom	2022-03-08 18:24:58.430299
1371	2509	4682	extractedFrom	2022-03-08 18:24:58.6831
1372	2509	4682	extractedFrom	2022-03-08 18:24:58.77753
1373	3258	4683	extractedFrom	2022-03-08 18:24:58.898558
1374	3258	4683	extractedFrom	2022-03-08 18:24:58.946024
1375	3639	4684	extractedFrom	2022-03-08 18:24:59.022959
1376	3639	4685	extractedFrom	2022-03-08 18:24:59.100783
1377	3639	4685	extractedFrom	2022-03-08 18:24:59.145608
1378	3123	4686	extractedFrom	2022-03-08 18:24:59.236093
1379	3123	4686	extractedFrom	2022-03-08 18:24:59.333915
1380	3673	4687	extractedFrom	2022-03-08 18:24:59.581843
1381	3673	4687	extractedFrom	2022-03-08 18:24:59.63282
1382	2834	4688	extractedFrom	2022-03-08 18:24:59.699741
1383	2834	4689	extractedFrom	2022-03-08 18:25:00.11607
1384	2834	4689	extractedFrom	2022-03-08 18:25:00.171598
1385	3075	4690	extractedFrom	2022-03-08 18:25:00.294642
1386	3075	4691	extractedFrom	2022-03-08 18:25:00.501891
1387	3075	4691	extractedFrom	2022-03-08 18:25:00.576088
1388	1625	4692	extractedFrom	2022-03-08 18:25:00.755365
1389	1625	4692	extractedFrom	2022-03-08 18:25:00.869024
1390	2117	4693	extractedFrom	2022-03-08 18:25:00.972081
1391	2117	4693	extractedFrom	2022-03-08 18:25:01.069141
1392	2815	4694	extractedFrom	2022-03-08 18:25:01.231865
1393	2815	4694	extractedFrom	2022-03-08 18:25:01.412427
1394	1916	4695	extractedFrom	2022-03-08 18:25:01.635078
1395	1916	4695	extractedFrom	2022-03-08 18:25:01.730691
1396	1906	4696	extractedFrom	2022-03-08 18:25:01.863419
1397	1906	4696	extractedFrom	2022-03-08 18:25:01.939691
1398	3269	4697	extractedFrom	2022-03-08 18:25:02.192589
1399	3269	4697	extractedFrom	2022-03-08 18:25:02.242753
1400	2104	4698	extractedFrom	2022-03-08 18:25:02.312837
1401	2104	4698	extractedFrom	2022-03-08 18:25:02.353119
1402	2287	4699	extractedFrom	2022-03-08 18:25:02.561101
1403	2287	4699	extractedFrom	2022-03-08 18:25:02.60662
1404	1829	4700	extractedFrom	2022-03-08 18:25:02.678304
1405	1829	4700	extractedFrom	2022-03-08 18:25:02.723073
1406	2237	4701	extractedFrom	2022-03-08 18:25:02.800327
1407	2237	4701	extractedFrom	2022-03-08 18:25:02.850674
1408	2242	4702	extractedFrom	2022-03-08 18:25:02.925135
1409	2242	4703	extractedFrom	2022-03-08 18:25:03.01217
1410	2242	4703	extractedFrom	2022-03-08 18:25:03.056342
1411	3569	4704	extractedFrom	2022-03-08 18:25:03.120769
1412	3569	4705	extractedFrom	2022-03-08 18:25:03.20139
1413	3569	4705	extractedFrom	2022-03-08 18:25:03.308728
1414	3497	4706	extractedFrom	2022-03-08 18:25:03.421127
1415	3497	4706	extractedFrom	2022-03-08 18:25:03.503968
1416	3361	4707	extractedFrom	2022-03-08 18:25:03.944073
1417	3361	4707	extractedFrom	2022-03-08 18:25:04.035796
1418	2930	4708	extractedFrom	2022-03-08 18:25:04.151023
1419	2930	4709	extractedFrom	2022-03-08 18:25:04.380843
1420	2930	4709	extractedFrom	2022-03-08 18:25:04.480544
1421	2864	4710	extractedFrom	2022-03-08 18:25:04.648861
1422	2864	4710	extractedFrom	2022-03-08 18:25:04.726749
1423	3605	4711	extractedFrom	2022-03-08 18:25:04.88801
1424	3605	4711	extractedFrom	2022-03-08 18:25:05.001013
1425	3595	4712	extractedFrom	2022-03-08 18:25:05.144103
1426	3595	4712	extractedFrom	2022-03-08 18:25:05.187199
1427	3210	4713	extractedFrom	2022-03-08 18:25:05.354047
1428	3210	4714	extractedFrom	2022-03-08 18:25:05.577755
1429	3210	4714	extractedFrom	2022-03-08 18:25:05.621424
1430	2376	4715	extractedFrom	2022-03-08 18:25:05.692039
1431	2376	4715	extractedFrom	2022-03-08 18:25:05.737971
1432	3254	4716	extractedFrom	2022-03-08 18:25:05.803946
1433	3254	4716	extractedFrom	2022-03-08 18:25:05.8485
1434	2138	4717	extractedFrom	2022-03-08 18:25:05.921175
1435	2138	4718	extractedFrom	2022-03-08 18:25:06.053057
1436	2138	4718	extractedFrom	2022-03-08 18:25:06.09921
1437	3364	4719	extractedFrom	2022-03-08 18:25:06.170395
1438	3364	4719	extractedFrom	2022-03-08 18:25:06.214953
1439	3575	4720	extractedFrom	2022-03-08 18:25:06.286034
1440	3575	4721	extractedFrom	2022-03-08 18:25:06.380647
1441	3575	4721	extractedFrom	2022-03-08 18:25:06.43142
1442	2026	4722	extractedFrom	2022-03-08 18:25:06.51117
1443	2026	4723	extractedFrom	2022-03-08 18:25:06.659877
1444	2026	4723	extractedFrom	2022-03-08 18:25:06.713366
1445	2343	4724	extractedFrom	2022-03-08 18:25:06.813285
1446	2343	4725	extractedFrom	2022-03-08 18:25:06.917834
1447	2343	4726	extractedFrom	2022-03-08 18:25:07.127985
1448	2343	4727	extractedFrom	2022-03-08 18:25:07.258556
1449	2343	4727	extractedFrom	2022-03-08 18:25:07.314325
1450	2447	4728	extractedFrom	2022-03-08 18:25:07.473793
1451	2447	4728	extractedFrom	2022-03-08 18:25:07.546431
1452	2261	4729	extractedFrom	2022-03-08 18:25:07.704108
1453	2261	4729	extractedFrom	2022-03-08 18:25:07.822307
1454	1648	4730	extractedFrom	2022-03-08 18:25:08.01376
1455	1648	4730	extractedFrom	2022-03-08 18:25:08.079494
1456	3151	4731	extractedFrom	2022-03-08 18:25:08.226633
1457	3151	4731	extractedFrom	2022-03-08 18:25:08.365613
1458	2176	4732	extractedFrom	2022-03-08 18:25:08.507534
1459	2176	4732	extractedFrom	2022-03-08 18:25:08.604231
1460	1779	4733	extractedFrom	2022-03-08 18:25:08.73735
1461	1779	4733	extractedFrom	2022-03-08 18:25:08.788789
1462	1572	4734	extractedFrom	2022-03-08 18:25:08.860016
1463	1572	4734	extractedFrom	2022-03-08 18:25:08.911415
1464	2200	4735	extractedFrom	2022-03-08 18:25:08.975669
1465	2200	4735	extractedFrom	2022-03-08 18:25:09.022162
1466	2722	4736	extractedFrom	2022-03-08 18:25:09.123836
1467	2722	4737	extractedFrom	2022-03-08 18:25:09.213888
1468	2722	4738	extractedFrom	2022-03-08 18:25:09.287191
1469	2722	4738	extractedFrom	2022-03-08 18:25:09.33121
1470	2060	4739	extractedFrom	2022-03-08 18:25:09.396027
1471	2060	4739	extractedFrom	2022-03-08 18:25:09.442763
1472	2388	4740	extractedFrom	2022-03-08 18:25:09.541222
1473	2388	4741	extractedFrom	2022-03-08 18:25:09.612999
1474	2388	4742	extractedFrom	2022-03-08 18:25:09.688586
1475	2388	4743	extractedFrom	2022-03-08 18:25:09.762572
1476	2388	4743	extractedFrom	2022-03-08 18:25:09.835506
1477	2385	4744	extractedFrom	2022-03-08 18:25:09.909877
1478	2385	4744	extractedFrom	2022-03-08 18:25:09.966765
1479	1568	4745	extractedFrom	2022-03-08 18:25:10.137726
1480	1568	4745	extractedFrom	2022-03-08 18:25:10.186606
1481	3470	4746	extractedFrom	2022-03-08 18:25:10.337922
1482	3470	4746	extractedFrom	2022-03-08 18:25:10.414535
1483	2159	4747	extractedFrom	2022-03-08 18:25:10.544655
1484	2159	4748	extractedFrom	2022-03-08 18:25:10.76565
1485	2159	4748	extractedFrom	2022-03-08 18:25:10.939958
1486	1636	4749	extractedFrom	2022-03-08 18:25:11.05115
1487	1636	4750	extractedFrom	2022-03-08 18:25:11.253592
1488	1636	4750	extractedFrom	2022-03-08 18:25:11.357029
1489	2591	4751	extractedFrom	2022-03-08 18:25:11.49965
1490	2591	4752	extractedFrom	2022-03-08 18:25:11.60107
1491	2591	4753	extractedFrom	2022-03-08 18:25:11.733648
1492	2591	4753	extractedFrom	2022-03-08 18:25:11.793427
1493	2487	4754	extractedFrom	2022-03-08 18:25:11.863574
1494	2487	4755	extractedFrom	2022-03-08 18:25:11.929907
1495	2487	4755	extractedFrom	2022-03-08 18:25:12.043942
1496	1767	4756	extractedFrom	2022-03-08 18:25:12.164212
1497	1767	4756	extractedFrom	2022-03-08 18:25:12.23545
1498	3213	4757	extractedFrom	2022-03-08 18:25:12.300562
1499	3213	4757	extractedFrom	2022-03-08 18:25:12.345035
1500	2888	4758	extractedFrom	2022-03-08 18:25:12.416066
1501	2888	4759	extractedFrom	2022-03-08 18:25:12.526964
1502	2888	4759	extractedFrom	2022-03-08 18:25:12.57809
1503	3440	4760	extractedFrom	2022-03-08 18:25:12.682152
1504	3440	4760	extractedFrom	2022-03-08 18:25:12.729847
1505	2839	4761	extractedFrom	2022-03-08 18:25:12.88729
1506	2839	4762	extractedFrom	2022-03-08 18:25:12.986615
1507	2839	4762	extractedFrom	2022-03-08 18:25:13.049367
1508	3682	4763	extractedFrom	2022-03-08 18:25:13.16394
1509	3682	4763	extractedFrom	2022-03-08 18:25:13.326192
1510	3064	4764	extractedFrom	2022-03-08 18:25:13.522262
1511	3064	4764	extractedFrom	2022-03-08 18:25:13.644363
1512	3189	4765	extractedFrom	2022-03-08 18:25:14.135606
1513	3189	4766	extractedFrom	2022-03-08 18:25:14.403802
1514	3189	4766	extractedFrom	2022-03-08 18:25:14.527836
1515	2679	4767	extractedFrom	2022-03-08 18:25:14.698202
1516	2679	4767	extractedFrom	2022-03-08 18:25:14.78413
1517	1998	4768	extractedFrom	2022-03-08 18:25:14.851926
1518	1998	4768	extractedFrom	2022-03-08 18:25:14.893073
1519	2059	4769	extractedFrom	2022-03-08 18:25:14.981848
1520	2059	4769	extractedFrom	2022-03-08 18:25:15.023149
1521	2178	4770	extractedFrom	2022-03-08 18:25:15.469611
1522	2178	4770	extractedFrom	2022-03-08 18:25:15.520942
1523	2524	4771	extractedFrom	2022-03-08 18:25:15.587515
1524	2524	4771	extractedFrom	2022-03-08 18:25:16.064008
1525	2974	4772	extractedFrom	2022-03-08 18:25:16.218377
1526	2974	4772	extractedFrom	2022-03-08 18:25:16.275772
1527	3152	4773	extractedFrom	2022-03-08 18:25:16.354767
1528	3152	4773	extractedFrom	2022-03-08 18:25:16.399555
1529	3490	4774	extractedFrom	2022-03-08 18:25:16.455486
1530	3490	4775	extractedFrom	2022-03-08 18:25:16.6723
1531	3490	4776	extractedFrom	2022-03-08 18:25:16.747555
1532	3490	4776	extractedFrom	2022-03-08 18:25:16.916769
1533	2900	4777	extractedFrom	2022-03-08 18:25:17.073147
1534	2900	4778	extractedFrom	2022-03-08 18:25:17.247867
1535	2900	4779	extractedFrom	2022-03-08 18:25:17.556695
1536	2900	4780	extractedFrom	2022-03-08 18:25:17.683489
1537	2900	4781	extractedFrom	2022-03-08 18:25:17.817145
1538	2900	4782	extractedFrom	2022-03-08 18:25:17.987905
1539	2900	4783	extractedFrom	2022-03-08 18:25:18.173376
1540	2900	4784	extractedFrom	2022-03-08 18:25:18.402092
1541	2900	4785	extractedFrom	2022-03-08 18:25:18.568261
1542	2900	4785	extractedFrom	2022-03-08 18:25:18.774544
1543	2332	4786	extractedFrom	2022-03-08 18:25:19.063707
1544	2332	4786	extractedFrom	2022-03-08 18:25:19.11323
1545	1978	4787	extractedFrom	2022-03-08 18:25:19.190984
1546	1978	4787	extractedFrom	2022-03-08 18:25:19.237083
1547	2877	4788	extractedFrom	2022-03-08 18:25:19.573854
1548	2877	4789	extractedFrom	2022-03-08 18:25:19.658751
1549	2877	4789	extractedFrom	2022-03-08 18:25:19.70377
1550	3427	4790	extractedFrom	2022-03-08 18:25:19.778258
1551	3427	4790	extractedFrom	2022-03-08 18:25:19.827505
1552	1669	4791	extractedFrom	2022-03-08 18:25:19.906244
1553	1669	4792	extractedFrom	2022-03-08 18:25:19.979329
1554	1669	4792	extractedFrom	2022-03-08 18:25:20.024418
1555	2915	4793	extractedFrom	2022-03-08 18:25:20.185723
1556	2915	4793	extractedFrom	2022-03-08 18:25:20.413087
1557	2793	4794	extractedFrom	2022-03-08 18:25:20.621874
1558	2793	4794	extractedFrom	2022-03-08 18:25:20.756159
1559	2564	4795	extractedFrom	2022-03-08 18:25:20.959637
1560	2564	4795	extractedFrom	2022-03-08 18:25:21.096675
1561	2467	4796	extractedFrom	2022-03-08 18:25:21.362915
1562	2467	4797	extractedFrom	2022-03-08 18:25:21.504547
1563	2467	4798	extractedFrom	2022-03-08 18:25:21.653611
1564	2467	4799	extractedFrom	2022-03-08 18:25:21.798524
1565	2467	4800	extractedFrom	2022-03-08 18:25:22.004687
1566	2467	4801	extractedFrom	2022-03-08 18:25:22.073064
1567	2467	4801	extractedFrom	2022-03-08 18:25:22.117263
1568	1953	4802	extractedFrom	2022-03-08 18:25:22.180954
1569	1953	4803	extractedFrom	2022-03-08 18:25:22.25372
1570	1953	4803	extractedFrom	2022-03-08 18:25:22.307539
1571	2292	4804	extractedFrom	2022-03-08 18:25:22.380622
1572	2292	4805	extractedFrom	2022-03-08 18:25:22.558125
1573	2292	4805	extractedFrom	2022-03-08 18:25:22.605081
1574	1609	4806	extractedFrom	2022-03-08 18:25:22.722876
1575	1609	4806	extractedFrom	2022-03-08 18:25:22.801234
1576	2383	4807	extractedFrom	2022-03-08 18:25:23.005701
1577	2383	4808	extractedFrom	2022-03-08 18:25:23.325927
1578	2383	4809	extractedFrom	2022-03-08 18:25:23.728671
1579	2383	4810	extractedFrom	2022-03-08 18:25:24.002946
1580	2383	4811	extractedFrom	2022-03-08 18:25:24.192826
1581	2383	4811	extractedFrom	2022-03-08 18:25:24.260235
1582	2330	4812	extractedFrom	2022-03-08 18:25:24.694105
1583	2330	4812	extractedFrom	2022-03-08 18:25:24.917541
1584	3067	4813	extractedFrom	2022-03-08 18:25:25.003324
1585	3067	4813	extractedFrom	2022-03-08 18:25:25.148251
1586	2914	4814	extractedFrom	2022-03-08 18:25:25.30523
1587	2914	4815	extractedFrom	2022-03-08 18:25:25.483043
1588	2914	4815	extractedFrom	2022-03-08 18:25:25.623541
1589	3669	4816	extractedFrom	2022-03-08 18:25:25.692927
1590	3669	4816	extractedFrom	2022-03-08 18:25:25.744537
1591	3063	4817	extractedFrom	2022-03-08 18:25:25.808211
1592	3063	4817	extractedFrom	2022-03-08 18:25:25.97218
1593	3278	4818	extractedFrom	2022-03-08 18:25:26.081886
1594	3278	4819	extractedFrom	2022-03-08 18:25:26.280128
1595	3278	4820	extractedFrom	2022-03-08 18:25:26.466237
1596	3278	4821	extractedFrom	2022-03-08 18:25:26.815254
1597	3278	4822	extractedFrom	2022-03-08 18:25:26.882738
1598	3278	4822	extractedFrom	2022-03-08 18:25:27.045795
1599	2822	4823	extractedFrom	2022-03-08 18:25:27.270497
1600	2822	4824	extractedFrom	2022-03-08 18:25:27.33795
1601	2822	4825	extractedFrom	2022-03-08 18:25:27.409322
1602	2822	4826	extractedFrom	2022-03-08 18:25:27.537681
1603	2822	4826	extractedFrom	2022-03-08 18:25:27.58751
1604	1552	4827	extractedFrom	2022-03-08 18:25:27.765868
1605	1552	4828	extractedFrom	2022-03-08 18:25:28.20899
1606	1552	4828	extractedFrom	2022-03-08 18:25:28.258044
1607	1815	4829	extractedFrom	2022-03-08 18:25:28.333286
1608	1815	4829	extractedFrom	2022-03-08 18:25:28.378342
1609	3680	4830	extractedFrom	2022-03-08 18:25:28.576635
1610	3680	4831	extractedFrom	2022-03-08 18:25:28.750255
1611	3680	4831	extractedFrom	2022-03-08 18:25:28.992859
1612	1778	4832	extractedFrom	2022-03-08 18:25:29.08245
1613	1778	4832	extractedFrom	2022-03-08 18:25:29.127539
1614	3200	4833	extractedFrom	2022-03-08 18:25:29.222152
1615	3200	4833	extractedFrom	2022-03-08 18:25:29.330203
1616	2708	4834	extractedFrom	2022-03-08 18:25:29.934472
1617	2708	4835	extractedFrom	2022-03-08 18:25:30.378096
1618	2708	4835	extractedFrom	2022-03-08 18:25:30.642739
1619	3418	4836	extractedFrom	2022-03-08 18:25:31.007508
1620	3418	4836	extractedFrom	2022-03-08 18:25:31.05884
1621	2186	4837	extractedFrom	2022-03-08 18:25:31.257862
1622	2186	4838	extractedFrom	2022-03-08 18:25:31.340438
1623	2186	4839	extractedFrom	2022-03-08 18:25:31.41543
1624	2186	4840	extractedFrom	2022-03-08 18:25:31.532785
1625	2186	4840	extractedFrom	2022-03-08 18:25:31.722416
1626	2773	4841	extractedFrom	2022-03-08 18:25:31.888661
1627	2773	4842	extractedFrom	2022-03-08 18:25:32.359131
1628	2773	4842	extractedFrom	2022-03-08 18:25:32.52618
1629	2937	4843	extractedFrom	2022-03-08 18:25:32.704474
1630	2937	4843	extractedFrom	2022-03-08 18:25:32.895391
1631	2628	4844	extractedFrom	2022-03-08 18:25:32.976275
1632	2628	4844	extractedFrom	2022-03-08 18:25:33.019395
1633	2255	4845	extractedFrom	2022-03-08 18:25:33.249501
1634	2255	4845	extractedFrom	2022-03-08 18:25:33.297412
1635	1889	4846	extractedFrom	2022-03-08 18:25:33.613376
1636	1889	4847	extractedFrom	2022-03-08 18:25:34.091662
1637	1889	4847	extractedFrom	2022-03-08 18:25:34.262455
1638	1958	4848	extractedFrom	2022-03-08 18:25:34.403621
1639	1958	4848	extractedFrom	2022-03-08 18:25:34.445373
1640	2508	4849	extractedFrom	2022-03-08 18:25:34.567122
1641	2508	4849	extractedFrom	2022-03-08 18:25:34.636566
1642	2152	4850	extractedFrom	2022-03-08 18:25:34.852015
1643	2152	4851	extractedFrom	2022-03-08 18:25:34.925921
1644	2152	4852	extractedFrom	2022-03-08 18:25:34.985466
1645	2152	4852	extractedFrom	2022-03-08 18:25:35.029771
1646	3502	4853	extractedFrom	2022-03-08 18:25:35.276171
1647	3502	4853	extractedFrom	2022-03-08 18:25:35.753542
1648	1879	4854	extractedFrom	2022-03-08 18:25:36.01338
1649	1879	4854	extractedFrom	2022-03-08 18:25:36.065543
1650	2062	4855	extractedFrom	2022-03-08 18:25:36.420623
1651	2062	4855	extractedFrom	2022-03-08 18:25:36.500625
1652	1672	4856	extractedFrom	2022-03-08 18:25:36.586634
1653	1672	4856	extractedFrom	2022-03-08 18:25:36.643332
1654	1899	4857	extractedFrom	2022-03-08 18:25:36.728641
1655	1899	4857	extractedFrom	2022-03-08 18:25:36.776511
1656	2207	4858	extractedFrom	2022-03-08 18:25:37.183671
1657	2207	4858	extractedFrom	2022-03-08 18:25:37.241822
1658	3231	4859	extractedFrom	2022-03-08 18:25:37.321734
1659	3231	4859	extractedFrom	2022-03-08 18:25:37.37572
1660	3185	4860	extractedFrom	2022-03-08 18:25:37.607929
1661	3185	4861	extractedFrom	2022-03-08 18:25:37.760406
1662	3185	4861	extractedFrom	2022-03-08 18:25:37.822569
1663	2144	4862	extractedFrom	2022-03-08 18:25:38.107497
1664	2144	4863	extractedFrom	2022-03-08 18:25:38.254925
1665	2144	4864	extractedFrom	2022-03-08 18:25:38.338049
1666	2144	4865	extractedFrom	2022-03-08 18:25:38.906877
1667	2144	4866	extractedFrom	2022-03-08 18:25:39.27445
1668	2144	4867	extractedFrom	2022-03-08 18:25:39.349671
1669	2144	4867	extractedFrom	2022-03-08 18:25:39.393716
1670	2135	4868	extractedFrom	2022-03-08 18:25:39.69549
1671	2135	4868	extractedFrom	2022-03-08 18:25:39.800121
1672	2322	4869	extractedFrom	2022-03-08 18:25:39.972131
1673	2322	4870	extractedFrom	2022-03-08 18:25:40.049838
1674	2322	4870	extractedFrom	2022-03-08 18:25:40.120406
1675	2315	4871	extractedFrom	2022-03-08 18:25:40.514936
1676	2315	4872	extractedFrom	2022-03-08 18:25:40.591291
1677	2315	4873	extractedFrom	2022-03-08 18:25:41.1752
1678	2315	4874	extractedFrom	2022-03-08 18:25:41.543177
1679	2315	4875	extractedFrom	2022-03-08 18:25:41.999377
1680	2315	4876	extractedFrom	2022-03-08 18:25:42.505382
1681	2315	4876	extractedFrom	2022-03-08 18:25:42.553329
1682	2130	4877	extractedFrom	2022-03-08 18:25:42.614051
1683	2130	4878	extractedFrom	2022-03-08 18:25:42.827158
1684	2130	4878	extractedFrom	2022-03-08 18:25:42.940877
1685	2533	4879	extractedFrom	2022-03-08 18:25:43.125537
1686	2533	4879	extractedFrom	2022-03-08 18:25:43.170564
1687	2614	4880	extractedFrom	2022-03-08 18:25:43.238297
1688	2614	4881	extractedFrom	2022-03-08 18:25:43.324928
1689	2614	4881	extractedFrom	2022-03-08 18:25:43.458174
1690	2162	4882	extractedFrom	2022-03-08 18:25:43.757137
1691	2162	4882	extractedFrom	2022-03-08 18:25:43.850392
1692	2802	4883	extractedFrom	2022-03-08 18:25:43.954944
1693	2802	4884	extractedFrom	2022-03-08 18:25:44.707238
1694	2802	4884	extractedFrom	2022-03-08 18:25:44.841728
1695	3267	4885	extractedFrom	2022-03-08 18:25:45.018917
1696	3267	4886	extractedFrom	2022-03-08 18:25:45.325512
1697	3267	4886	extractedFrom	2022-03-08 18:25:45.491678
1698	2194	4887	extractedFrom	2022-03-08 18:25:45.731915
1699	2194	4888	extractedFrom	2022-03-08 18:25:46.025275
1700	2194	4889	extractedFrom	2022-03-08 18:25:46.223497
1701	2194	4890	extractedFrom	2022-03-08 18:25:46.318976
1702	2194	4890	extractedFrom	2022-03-08 18:25:46.36545
1703	1870	4891	extractedFrom	2022-03-08 18:25:46.583086
1704	1870	4892	extractedFrom	2022-03-08 18:25:46.663495
1705	1870	4893	extractedFrom	2022-03-08 18:25:47.019993
1706	1870	4893	extractedFrom	2022-03-08 18:25:47.142528
1707	2845	4894	extractedFrom	2022-03-08 18:25:47.334396
1708	2845	4894	extractedFrom	2022-03-08 18:25:47.390343
1709	3524	4895	extractedFrom	2022-03-08 18:25:47.727862
1710	3524	4895	extractedFrom	2022-03-08 18:25:47.951517
1711	3145	4896	extractedFrom	2022-03-08 18:25:48.157042
1712	3145	4896	extractedFrom	2022-03-08 18:25:48.211641
1713	2235	4897	extractedFrom	2022-03-08 18:25:48.288652
1714	2235	4897	extractedFrom	2022-03-08 18:25:48.346823
1715	2737	4898	extractedFrom	2022-03-08 18:25:48.572728
1716	2737	4898	extractedFrom	2022-03-08 18:25:48.629965
1717	2224	4899	extractedFrom	2022-03-08 18:25:48.958887
1718	2224	4899	extractedFrom	2022-03-08 18:25:49.050224
1719	2365	4900	extractedFrom	2022-03-08 18:25:49.183679
1720	2365	4901	extractedFrom	2022-03-08 18:25:49.260398
1721	2365	4901	extractedFrom	2022-03-08 18:25:49.304489
1722	3136	4902	extractedFrom	2022-03-08 18:25:49.589216
1723	3136	4902	extractedFrom	2022-03-08 18:25:49.706557
1724	2102	4903	extractedFrom	2022-03-08 18:25:49.921051
1725	2102	4904	extractedFrom	2022-03-08 18:25:50.069913
1726	2102	4904	extractedFrom	2022-03-08 18:25:50.239626
1727	2596	4905	extractedFrom	2022-03-08 18:25:50.32659
1728	2596	4905	extractedFrom	2022-03-08 18:25:50.414931
1729	3588	4906	extractedFrom	2022-03-08 18:25:50.615631
1730	3588	4906	extractedFrom	2022-03-08 18:25:50.675333
1731	2879	4907	extractedFrom	2022-03-08 18:25:50.973098
1732	2879	4907	extractedFrom	2022-03-08 18:25:51.019345
1733	1749	4908	extractedFrom	2022-03-08 18:25:51.088551
1734	1749	4908	extractedFrom	2022-03-08 18:25:51.151683
1735	2898	4909	extractedFrom	2022-03-08 18:25:51.222644
1736	2898	4910	extractedFrom	2022-03-08 18:25:51.501952
1737	2898	4911	extractedFrom	2022-03-08 18:25:51.590215
1738	2898	4911	extractedFrom	2022-03-08 18:25:51.726497
1739	2367	4912	extractedFrom	2022-03-08 18:25:51.979263
1740	2367	4912	extractedFrom	2022-03-08 18:25:52.02685
1741	2458	4913	extractedFrom	2022-03-08 18:25:52.280858
1742	2458	4913	extractedFrom	2022-03-08 18:25:52.529919
1743	2561	4914	extractedFrom	2022-03-08 18:25:52.644669
1744	2561	4915	extractedFrom	2022-03-08 18:25:52.945536
1745	2561	4916	extractedFrom	2022-03-08 18:25:53.085517
1746	2561	4916	extractedFrom	2022-03-08 18:25:53.320162
1747	2745	4917	extractedFrom	2022-03-08 18:25:53.530171
1748	2745	4917	extractedFrom	2022-03-08 18:25:53.582997
1749	1747	4918	extractedFrom	2022-03-08 18:25:53.833133
1750	1747	4919	extractedFrom	2022-03-08 18:25:53.915875
1751	1747	4919	extractedFrom	2022-03-08 18:25:53.963831
1752	2546	4920	extractedFrom	2022-03-08 18:25:54.141493
1753	2546	4921	extractedFrom	2022-03-08 18:25:54.216437
1754	2546	4921	extractedFrom	2022-03-08 18:25:54.333789
1755	1611	4922	extractedFrom	2022-03-08 18:25:54.6298
1756	1611	4922	extractedFrom	2022-03-08 18:25:54.69553
1757	1567	4923	extractedFrom	2022-03-08 18:25:54.874392
1758	1567	4923	extractedFrom	2022-03-08 18:25:54.922551
1759	3352	4924	extractedFrom	2022-03-08 18:25:55.047748
1760	3352	4924	extractedFrom	2022-03-08 18:25:55.1901
1761	3077	4925	extractedFrom	2022-03-08 18:25:55.713974
1762	3077	4925	extractedFrom	2022-03-08 18:25:55.810959
1763	1735	4926	extractedFrom	2022-03-08 18:25:55.888891
1764	1735	4927	extractedFrom	2022-03-08 18:25:56.434993
1765	1735	4927	extractedFrom	2022-03-08 18:25:56.588121
1766	2301	4928	extractedFrom	2022-03-08 18:25:56.819534
1767	2301	4929	extractedFrom	2022-03-08 18:25:56.89413
1768	2301	4930	extractedFrom	2022-03-08 18:25:56.969121
1769	2301	4931	extractedFrom	2022-03-08 18:25:57.074809
1770	2301	4932	extractedFrom	2022-03-08 18:25:57.24065
1771	2301	4933	extractedFrom	2022-03-08 18:25:57.430405
1772	2301	4934	extractedFrom	2022-03-08 18:25:57.572787
1773	2301	4934	extractedFrom	2022-03-08 18:25:57.710662
1774	2936	4935	extractedFrom	2022-03-08 18:25:58.050632
1775	2936	4935	extractedFrom	2022-03-08 18:25:58.15435
1776	2622	4936	extractedFrom	2022-03-08 18:25:58.252239
1777	2622	4936	extractedFrom	2022-03-08 18:25:58.296323
1778	2384	4937	extractedFrom	2022-03-08 18:25:58.639154
1779	2384	4938	extractedFrom	2022-03-08 18:25:58.989289
1780	2384	4939	extractedFrom	2022-03-08 18:25:59.154255
1781	2384	4940	extractedFrom	2022-03-08 18:25:59.37982
1782	2384	4940	extractedFrom	2022-03-08 18:25:59.781411
1783	1695	4941	extractedFrom	2022-03-08 18:26:00.106033
1784	1695	4942	extractedFrom	2022-03-08 18:26:00.315515
1785	1695	4943	extractedFrom	2022-03-08 18:26:00.399177
1786	1695	4943	extractedFrom	2022-03-08 18:26:00.4653
1787	2416	4944	extractedFrom	2022-03-08 18:26:00.593916
1788	2416	4945	extractedFrom	2022-03-08 18:26:00.76223
1789	2416	4946	extractedFrom	2022-03-08 18:26:00.971313
1790	2416	4946	extractedFrom	2022-03-08 18:26:01.055928
1791	2173	4947	extractedFrom	2022-03-08 18:26:01.1424
1792	2173	4948	extractedFrom	2022-03-08 18:26:01.406128
1793	2173	4949	extractedFrom	2022-03-08 18:26:01.61012
1794	2173	4950	extractedFrom	2022-03-08 18:26:01.920278
1795	2173	4950	extractedFrom	2022-03-08 18:26:02.164394
1796	1558	4951	extractedFrom	2022-03-08 18:26:02.264823
1797	1558	4952	extractedFrom	2022-03-08 18:26:03.025795
1798	1558	4952	extractedFrom	2022-03-08 18:26:03.170981
1799	2621	4953	extractedFrom	2022-03-08 18:26:03.943189
1800	2621	4953	extractedFrom	2022-03-08 18:26:04.05771
1801	3627	4954	extractedFrom	2022-03-08 18:26:04.287019
1802	3627	4954	extractedFrom	2022-03-08 18:26:04.443427
1803	3531	4955	extractedFrom	2022-03-08 18:26:04.521615
1804	3531	4955	extractedFrom	2022-03-08 18:26:04.589109
1805	2167	4956	extractedFrom	2022-03-08 18:26:05.150852
1806	2167	4957	extractedFrom	2022-03-08 18:26:05.296875
1807	2167	4958	extractedFrom	2022-03-08 18:26:05.380971
1808	2167	4959	extractedFrom	2022-03-08 18:26:05.880326
1809	2167	4959	extractedFrom	2022-03-08 18:26:06.114461
1810	3144	4960	extractedFrom	2022-03-08 18:26:06.285003
1811	3144	4960	extractedFrom	2022-03-08 18:26:06.658209
1812	2375	4961	extractedFrom	2022-03-08 18:26:07.066365
1813	2375	4961	extractedFrom	2022-03-08 18:26:07.120693
1814	2663	4962	extractedFrom	2022-03-08 18:26:07.431474
1815	2663	4963	extractedFrom	2022-03-08 18:26:07.770558
1816	2663	4964	extractedFrom	2022-03-08 18:26:07.932481
1817	2663	4964	extractedFrom	2022-03-08 18:26:07.983804
1818	1591	4965	extractedFrom	2022-03-08 18:26:08.336672
1819	1591	4965	extractedFrom	2022-03-08 18:26:08.424605
1820	3466	4966	extractedFrom	2022-03-08 18:26:08.881485
1821	3466	4967	extractedFrom	2022-03-08 18:26:09.001159
1822	3466	4967	extractedFrom	2022-03-08 18:26:09.055078
1823	2003	4968	extractedFrom	2022-03-08 18:26:09.123877
1824	2003	4968	extractedFrom	2022-03-08 18:26:09.569084
1825	3424	4969	extractedFrom	2022-03-08 18:26:10.09738
1826	3424	4969	extractedFrom	2022-03-08 18:26:10.144277
1827	2078	4970	extractedFrom	2022-03-08 18:26:10.322204
1828	2078	4970	extractedFrom	2022-03-08 18:26:10.384888
1829	2163	4971	extractedFrom	2022-03-08 18:26:10.792453
1830	2163	4971	extractedFrom	2022-03-08 18:26:10.878883
1831	3088	4972	extractedFrom	2022-03-08 18:26:11.370932
1832	3088	4973	extractedFrom	2022-03-08 18:26:11.76017
1833	3088	4974	extractedFrom	2022-03-08 18:26:11.892705
1834	3088	4975	extractedFrom	2022-03-08 18:26:12.075762
1835	3088	4976	extractedFrom	2022-03-08 18:26:12.196896
1836	3088	4977	extractedFrom	2022-03-08 18:26:12.475817
1837	3088	4978	extractedFrom	2022-03-08 18:26:12.67018
1838	3088	4978	extractedFrom	2022-03-08 18:26:12.73506
1839	1840	4979	extractedFrom	2022-03-08 18:26:12.984903
1840	1840	4980	extractedFrom	2022-03-08 18:26:13.068835
1841	1840	4981	extractedFrom	2022-03-08 18:26:13.373729
1842	1840	4981	extractedFrom	2022-03-08 18:26:13.55252
1843	2706	4982	extractedFrom	2022-03-08 18:26:13.836946
1844	2706	4982	extractedFrom	2022-03-08 18:26:13.991818
1845	3208	4983	extractedFrom	2022-03-08 18:26:14.328512
1846	3208	4984	extractedFrom	2022-03-08 18:26:14.518465
1847	3208	4985	extractedFrom	2022-03-08 18:26:14.655522
1848	3208	4985	extractedFrom	2022-03-08 18:26:14.739437
1849	1910	4986	extractedFrom	2022-03-08 18:26:14.887367
1850	1910	4986	extractedFrom	2022-03-08 18:26:15.177213
1851	3323	4987	extractedFrom	2022-03-08 18:26:15.613656
1852	3323	4987	extractedFrom	2022-03-08 18:26:15.846388
1853	2325	4988	extractedFrom	2022-03-08 18:26:16.169705
1854	2325	4988	extractedFrom	2022-03-08 18:26:16.266375
1855	2812	4989	extractedFrom	2022-03-08 18:26:16.757975
1856	2812	4989	extractedFrom	2022-03-08 18:26:16.804671
1857	1698	4990	extractedFrom	2022-03-08 18:26:16.877355
1858	1698	4990	extractedFrom	2022-03-08 18:26:16.923456
1859	3600	4991	extractedFrom	2022-03-08 18:26:17.100998
1860	3600	4991	extractedFrom	2022-03-08 18:26:17.202327
1861	2903	4992	extractedFrom	2022-03-08 18:26:17.304213
1862	2903	4993	extractedFrom	2022-03-08 18:26:17.442394
1863	2903	4994	extractedFrom	2022-03-08 18:26:17.673784
1864	2903	4994	extractedFrom	2022-03-08 18:26:17.72988
1865	3532	4995	extractedFrom	2022-03-08 18:26:17.817169
1866	3532	4995	extractedFrom	2022-03-08 18:26:17.861547
1867	1873	4996	extractedFrom	2022-03-08 18:26:17.942802
1868	1873	4996	extractedFrom	2022-03-08 18:26:18.035179
1869	2327	4997	extractedFrom	2022-03-08 18:26:18.209613
1870	2327	4997	extractedFrom	2022-03-08 18:26:18.253266
1871	1638	4998	extractedFrom	2022-03-08 18:26:18.315988
1872	1638	4999	extractedFrom	2022-03-08 18:26:18.728016
1873	1638	5000	extractedFrom	2022-03-08 18:26:18.807597
1874	1638	5000	extractedFrom	2022-03-08 18:26:18.862632
1875	3413	5001	extractedFrom	2022-03-08 18:26:19.087757
1876	3413	5002	extractedFrom	2022-03-08 18:26:19.36729
1877	3413	5003	extractedFrom	2022-03-08 18:26:19.484134
1878	3413	5003	extractedFrom	2022-03-08 18:26:19.541462
1879	3283	5004	extractedFrom	2022-03-08 18:26:19.613908
1880	3283	5004	extractedFrom	2022-03-08 18:26:19.659514
1881	3062	5005	extractedFrom	2022-03-08 18:26:19.729625
1882	3062	5006	extractedFrom	2022-03-08 18:26:19.962596
1883	3062	5007	extractedFrom	2022-03-08 18:26:20.032861
1884	3062	5008	extractedFrom	2022-03-08 18:26:20.152625
1885	3062	5009	extractedFrom	2022-03-08 18:26:20.457476
1886	3062	5009	extractedFrom	2022-03-08 18:26:20.53062
1887	2927	5010	extractedFrom	2022-03-08 18:26:20.776385
1888	2927	5010	extractedFrom	2022-03-08 18:26:20.828911
1889	2344	5011	extractedFrom	2022-03-08 18:26:21.074063
1890	2344	5012	extractedFrom	2022-03-08 18:26:21.156774
1891	2344	5012	extractedFrom	2022-03-08 18:26:21.389887
1892	2349	5013	extractedFrom	2022-03-08 18:26:21.781001
1893	2349	5014	extractedFrom	2022-03-08 18:26:21.954382
1894	2349	5015	extractedFrom	2022-03-08 18:26:22.166246
1895	2349	5016	extractedFrom	2022-03-08 18:26:22.29713
1896	2349	5017	extractedFrom	2022-03-08 18:26:22.420355
1897	2349	5018	extractedFrom	2022-03-08 18:26:22.572817
1898	2349	5019	extractedFrom	2022-03-08 18:26:22.64899
1899	2349	5020	extractedFrom	2022-03-08 18:26:22.878297
1900	2349	5020	extractedFrom	2022-03-08 18:26:23.021225
1901	3047	5021	extractedFrom	2022-03-08 18:26:23.199489
1902	3047	5021	extractedFrom	2022-03-08 18:26:23.259181
1903	3513	5022	extractedFrom	2022-03-08 18:26:23.518007
1904	3513	5023	extractedFrom	2022-03-08 18:26:23.872868
1905	3513	5023	extractedFrom	2022-03-08 18:26:24.004604
1906	1973	5024	extractedFrom	2022-03-08 18:26:24.241577
1907	1973	5025	extractedFrom	2022-03-08 18:26:24.3235
1908	1973	5026	extractedFrom	2022-03-08 18:26:24.483761
1909	1973	5026	extractedFrom	2022-03-08 18:26:24.537342
1910	2933	5027	extractedFrom	2022-03-08 18:26:24.612767
1911	2933	5027	extractedFrom	2022-03-08 18:26:24.657705
1912	3563	5028	extractedFrom	2022-03-08 18:26:25.309751
1913	3563	5028	extractedFrom	2022-03-08 18:26:25.45155
1914	1762	5029	extractedFrom	2022-03-08 18:26:25.78772
1915	1762	5030	extractedFrom	2022-03-08 18:26:25.911573
1916	1762	5031	extractedFrom	2022-03-08 18:26:25.998783
1917	1762	5032	extractedFrom	2022-03-08 18:26:26.162864
1918	1762	5033	extractedFrom	2022-03-08 18:26:26.251983
1919	1762	5033	extractedFrom	2022-03-08 18:26:26.296777
1920	2486	5034	extractedFrom	2022-03-08 18:26:26.407477
1921	2486	5035	extractedFrom	2022-03-08 18:26:27.026718
1922	2486	5036	extractedFrom	2022-03-08 18:26:27.159416
1923	2486	5037	extractedFrom	2022-03-08 18:26:27.315949
1924	2486	5037	extractedFrom	2022-03-08 18:26:27.394093
1925	3461	5038	extractedFrom	2022-03-08 18:26:27.564729
1926	3461	5039	extractedFrom	2022-03-08 18:26:27.813574
1927	3461	5040	extractedFrom	2022-03-08 18:26:27.997451
1928	3461	5041	extractedFrom	2022-03-08 18:26:28.176148
1929	3461	5042	extractedFrom	2022-03-08 18:26:28.288446
1930	3461	5043	extractedFrom	2022-03-08 18:26:28.657833
1931	3461	5043	extractedFrom	2022-03-08 18:26:28.811284
1932	3173	5044	extractedFrom	2022-03-08 18:26:28.919558
1933	3173	5044	extractedFrom	2022-03-08 18:26:29.112835
1934	3058	5045	extractedFrom	2022-03-08 18:26:29.445528
1935	3058	5045	extractedFrom	2022-03-08 18:26:29.504695
1936	1685	5046	extractedFrom	2022-03-08 18:26:29.662091
1937	1685	5046	extractedFrom	2022-03-08 18:26:29.712293
1938	2263	5047	extractedFrom	2022-03-08 18:26:29.815677
1939	2263	5048	extractedFrom	2022-03-08 18:26:30.127227
1940	2263	5049	extractedFrom	2022-03-08 18:26:30.27985
1941	2263	5049	extractedFrom	2022-03-08 18:26:30.467631
1942	2506	5050	extractedFrom	2022-03-08 18:26:30.86303
1943	2506	5051	extractedFrom	2022-03-08 18:26:31.015592
1944	2506	5052	extractedFrom	2022-03-08 18:26:31.118379
1945	2506	5052	extractedFrom	2022-03-08 18:26:31.235908
1946	2141	5053	extractedFrom	2022-03-08 18:26:31.370453
1947	2141	5054	extractedFrom	2022-03-08 18:26:31.461335
1948	2141	5055	extractedFrom	2022-03-08 18:26:31.75216
1949	2141	5055	extractedFrom	2022-03-08 18:26:32.135559
1950	3650	5056	extractedFrom	2022-03-08 18:26:32.417983
1951	3650	5056	extractedFrom	2022-03-08 18:26:32.597541
1952	2310	5057	extractedFrom	2022-03-08 18:26:33.192086
1953	2310	5057	extractedFrom	2022-03-08 18:26:33.254139
1954	2098	5058	extractedFrom	2022-03-08 18:26:33.336499
1955	2098	5059	extractedFrom	2022-03-08 18:26:33.422209
1956	2098	5060	extractedFrom	2022-03-08 18:26:33.703021
1957	2098	5061	extractedFrom	2022-03-08 18:26:33.962528
1958	2098	5062	extractedFrom	2022-03-08 18:26:34.053772
1959	2098	5062	extractedFrom	2022-03-08 18:26:34.108472
1960	2794	5063	extractedFrom	2022-03-08 18:26:34.448366
1961	2794	5064	extractedFrom	2022-03-08 18:26:34.80987
1962	2794	5064	extractedFrom	2022-03-08 18:26:34.853209
1963	3259	5065	extractedFrom	2022-03-08 18:26:34.984176
1964	3259	5065	extractedFrom	2022-03-08 18:26:35.02827
1965	3429	5066	extractedFrom	2022-03-08 18:26:35.098964
1966	3429	5066	extractedFrom	2022-03-08 18:26:35.228559
1967	2754	5067	extractedFrom	2022-03-08 18:26:35.667423
1968	2754	5067	extractedFrom	2022-03-08 18:26:35.711404
1969	2114	5068	extractedFrom	2022-03-08 18:26:35.908721
1970	2114	5068	extractedFrom	2022-03-08 18:26:36.006889
1971	2516	5069	extractedFrom	2022-03-08 18:26:36.068045
1972	2516	5069	extractedFrom	2022-03-08 18:26:36.103079
1973	3651	5070	extractedFrom	2022-03-08 18:26:36.176663
1974	3651	5070	extractedFrom	2022-03-08 18:26:36.264767
1975	2335	5071	extractedFrom	2022-03-08 18:26:36.607122
1976	2335	5071	extractedFrom	2022-03-08 18:26:36.709653
1977	1789	5072	extractedFrom	2022-03-08 18:26:37.62352
1978	1789	5072	extractedFrom	2022-03-08 18:26:37.830178
1979	3008	5073	extractedFrom	2022-03-08 18:26:38.039691
1980	3008	5073	extractedFrom	2022-03-08 18:26:38.177946
1981	1556	5074	extractedFrom	2022-03-08 18:26:38.338635
1982	1556	5075	extractedFrom	2022-03-08 18:26:38.658111
1983	1556	5076	extractedFrom	2022-03-08 18:26:38.781165
1984	1556	5077	extractedFrom	2022-03-08 18:26:39.127199
1985	1556	5078	extractedFrom	2022-03-08 18:26:39.419672
1986	1556	5078	extractedFrom	2022-03-08 18:26:39.543518
1987	2283	5079	extractedFrom	2022-03-08 18:26:39.999387
1988	2283	5080	extractedFrom	2022-03-08 18:26:40.117126
1989	2283	5081	extractedFrom	2022-03-08 18:26:40.478745
1990	2283	5082	extractedFrom	2022-03-08 18:26:40.786505
1991	2283	5083	extractedFrom	2022-03-08 18:26:41.038573
1992	2283	5084	extractedFrom	2022-03-08 18:26:41.147914
1993	2283	5085	extractedFrom	2022-03-08 18:26:41.391335
1994	2283	5086	extractedFrom	2022-03-08 18:26:41.616109
1995	2283	5087	extractedFrom	2022-03-08 18:26:42.008415
1996	2283	5088	extractedFrom	2022-03-08 18:26:42.350733
1997	2283	5088	extractedFrom	2022-03-08 18:26:42.434227
1998	1691	5089	extractedFrom	2022-03-08 18:26:42.503279
1999	1691	5089	extractedFrom	2022-03-08 18:26:42.547857
2000	2941	5090	extractedFrom	2022-03-08 18:26:42.695241
2001	2941	5091	extractedFrom	2022-03-08 18:26:42.776385
2002	2941	5091	extractedFrom	2022-03-08 18:26:42.820649
2003	3179	5092	extractedFrom	2022-03-08 18:26:42.9763
2004	3179	5092	extractedFrom	2022-03-08 18:26:43.020268
2005	3647	5093	extractedFrom	2022-03-08 18:26:43.159134
2006	3647	5093	extractedFrom	2022-03-08 18:26:43.205723
2007	2481	5094	extractedFrom	2022-03-08 18:26:43.29302
2008	2481	5095	extractedFrom	2022-03-08 18:26:43.593694
2009	2481	5096	extractedFrom	2022-03-08 18:26:43.765684
2010	2481	5097	extractedFrom	2022-03-08 18:26:43.865447
2011	2481	5097	extractedFrom	2022-03-08 18:26:43.909036
2012	2045	5098	extractedFrom	2022-03-08 18:26:44.006281
2013	2045	5098	extractedFrom	2022-03-08 18:26:44.152144
2014	3446	5099	extractedFrom	2022-03-08 18:26:44.340727
2015	3446	5099	extractedFrom	2022-03-08 18:26:44.468662
2016	2583	5100	extractedFrom	2022-03-08 18:26:44.613458
2017	2583	5100	extractedFrom	2022-03-08 18:26:44.776729
2018	2470	5101	extractedFrom	2022-03-08 18:26:44.913248
2019	2470	5101	extractedFrom	2022-03-08 18:26:44.957912
2020	2841	5102	extractedFrom	2022-03-08 18:26:45.048758
2021	2841	5103	extractedFrom	2022-03-08 18:26:45.192653
2022	2841	5104	extractedFrom	2022-03-08 18:26:45.272974
2023	2841	5105	extractedFrom	2022-03-08 18:26:45.347933
2024	2841	5106	extractedFrom	2022-03-08 18:26:45.875488
2025	2841	5107	extractedFrom	2022-03-08 18:26:46.066072
2026	2841	5108	extractedFrom	2022-03-08 18:26:46.23807
2027	2841	5108	extractedFrom	2022-03-08 18:26:46.324041
2028	2290	5109	extractedFrom	2022-03-08 18:26:47.367865
2029	2290	5109	extractedFrom	2022-03-08 18:26:47.449863
2030	1676	5110	extractedFrom	2022-03-08 18:26:47.984214
2031	1676	5110	extractedFrom	2022-03-08 18:26:48.070196
2032	1827	5111	extractedFrom	2022-03-08 18:26:48.452922
2033	1827	5111	extractedFrom	2022-03-08 18:26:48.565723
2034	1915	5112	extractedFrom	2022-03-08 18:26:48.954154
2035	1915	5113	extractedFrom	2022-03-08 18:26:49.253734
2036	1915	5113	extractedFrom	2022-03-08 18:26:49.386846
2037	2314	5114	extractedFrom	2022-03-08 18:26:49.999954
2038	2314	5114	extractedFrom	2022-03-08 18:26:50.607872
2039	2571	5115	extractedFrom	2022-03-08 18:26:51.166484
2040	2571	5115	extractedFrom	2022-03-08 18:26:51.217097
2041	3508	5116	extractedFrom	2022-03-08 18:26:51.402694
2042	3508	5117	extractedFrom	2022-03-08 18:26:51.669699
2043	3508	5117	extractedFrom	2022-03-08 18:26:51.733345
2044	3501	5118	extractedFrom	2022-03-08 18:26:52.039089
2045	3501	5119	extractedFrom	2022-03-08 18:26:52.555582
2046	3501	5119	extractedFrom	2022-03-08 18:26:52.913346
2047	3156	5120	extractedFrom	2022-03-08 18:26:53.279001
2048	3156	5121	extractedFrom	2022-03-08 18:26:53.842998
2049	3156	5121	extractedFrom	2022-03-08 18:26:53.89506
2050	2874	5122	extractedFrom	2022-03-08 18:26:54.061507
2051	2874	5122	extractedFrom	2022-03-08 18:26:54.233567
2052	3101	5123	extractedFrom	2022-03-08 18:26:54.375201
2053	3101	5124	extractedFrom	2022-03-08 18:26:54.728852
2054	3101	5124	extractedFrom	2022-03-08 18:26:54.795205
2055	1742	5125	extractedFrom	2022-03-08 18:26:55.126437
2056	1742	5125	extractedFrom	2022-03-08 18:26:55.377536
2057	2684	5126	extractedFrom	2022-03-08 18:26:56.028438
2058	2684	5126	extractedFrom	2022-03-08 18:26:56.11119
2059	2110	5127	extractedFrom	2022-03-08 18:26:56.301956
2060	2110	5127	extractedFrom	2022-03-08 18:26:56.454755
2061	1837	5128	extractedFrom	2022-03-08 18:26:56.8058
2062	1837	5128	extractedFrom	2022-03-08 18:26:56.878906
2063	2387	5129	extractedFrom	2022-03-08 18:26:57.058235
2064	2387	5130	extractedFrom	2022-03-08 18:26:57.421819
2065	2387	5131	extractedFrom	2022-03-08 18:26:57.735209
2066	2387	5132	extractedFrom	2022-03-08 18:26:58.062348
2067	2387	5133	extractedFrom	2022-03-08 18:26:58.291212
2068	2387	5134	extractedFrom	2022-03-08 18:26:58.38711
2069	2387	5134	extractedFrom	2022-03-08 18:26:58.57328
2070	2774	5135	extractedFrom	2022-03-08 18:26:58.931273
2071	2774	5136	extractedFrom	2022-03-08 18:26:59.629421
2072	2774	5137	extractedFrom	2022-03-08 18:27:00.095897
2073	2774	5137	extractedFrom	2022-03-08 18:27:00.192047
2074	3157	5138	extractedFrom	2022-03-08 18:27:00.616611
2075	3157	5139	extractedFrom	2022-03-08 18:27:00.907278
2076	3157	5139	extractedFrom	2022-03-08 18:27:01.023721
2077	3349	5140	extractedFrom	2022-03-08 18:27:01.231877
2078	3349	5141	extractedFrom	2022-03-08 18:27:01.443076
2079	3349	5142	extractedFrom	2022-03-08 18:27:01.736113
2080	3349	5142	extractedFrom	2022-03-08 18:27:01.841754
2081	2550	5143	extractedFrom	2022-03-08 18:27:02.012179
2082	2550	5144	extractedFrom	2022-03-08 18:27:02.191956
2083	2550	5145	extractedFrom	2022-03-08 18:27:02.475672
2084	2550	5145	extractedFrom	2022-03-08 18:27:02.663186
2085	3460	5146	extractedFrom	2022-03-08 18:27:03.063522
2086	3460	5146	extractedFrom	2022-03-08 18:27:03.36173
2087	1581	5147	extractedFrom	2022-03-08 18:27:03.765272
2088	1581	5147	extractedFrom	2022-03-08 18:27:04.207747
2089	2483	5148	extractedFrom	2022-03-08 18:27:04.602999
2090	2483	5149	extractedFrom	2022-03-08 18:27:04.709218
2091	2483	5150	extractedFrom	2022-03-08 18:27:04.926299
2092	2483	5150	extractedFrom	2022-03-08 18:27:05.228851
2093	1592	5151	extractedFrom	2022-03-08 18:27:05.64983
2094	1592	5152	extractedFrom	2022-03-08 18:27:06.881867
2095	1592	5153	extractedFrom	2022-03-08 18:27:07.340466
2096	1592	5154	extractedFrom	2022-03-08 18:27:07.513303
2097	1592	5155	extractedFrom	2022-03-08 18:27:07.965431
2098	1592	5156	extractedFrom	2022-03-08 18:27:08.647409
2099	1592	5157	extractedFrom	2022-03-08 18:27:08.942632
2100	1592	5158	extractedFrom	2022-03-08 18:27:09.551439
2101	1592	5159	extractedFrom	2022-03-08 18:27:10.157099
2102	1592	5160	extractedFrom	2022-03-08 18:27:10.694775
2103	1592	5161	extractedFrom	2022-03-08 18:27:11.077719
2104	1592	5162	extractedFrom	2022-03-08 18:27:12.424324
2105	1592	5163	extractedFrom	2022-03-08 18:27:12.576818
2106	1592	5164	extractedFrom	2022-03-08 18:27:13.118708
2107	1592	5164	extractedFrom	2022-03-08 18:27:13.564326
2108	2781	5165	extractedFrom	2022-03-08 18:27:14.353116
2109	2781	5165	extractedFrom	2022-03-08 18:27:14.482547
2110	3683	5166	extractedFrom	2022-03-08 18:27:15.212764
2111	3683	5167	extractedFrom	2022-03-08 18:27:15.993445
2112	3683	5168	extractedFrom	2022-03-08 18:27:16.356845
2113	3683	5169	extractedFrom	2022-03-08 18:27:16.956572
2114	3683	5170	extractedFrom	2022-03-08 18:27:17.399078
2115	3683	5171	extractedFrom	2022-03-08 18:27:17.829507
2116	3683	5172	extractedFrom	2022-03-08 18:27:18.107337
2117	3683	5172	extractedFrom	2022-03-08 18:27:18.194143
2118	2133	5173	extractedFrom	2022-03-08 18:27:18.601042
2119	2133	5174	extractedFrom	2022-03-08 18:27:19.056897
2120	2133	5175	extractedFrom	2022-03-08 18:27:19.552433
2121	2133	5175	extractedFrom	2022-03-08 18:27:19.819018
2122	2826	5176	extractedFrom	2022-03-08 18:27:19.970849
2123	2826	5177	extractedFrom	2022-03-08 18:27:20.218642
2124	2826	5178	extractedFrom	2022-03-08 18:27:20.519712
2125	2826	5179	extractedFrom	2022-03-08 18:27:21.140395
2126	2826	5179	extractedFrom	2022-03-08 18:27:21.493726
2127	1622	5180	extractedFrom	2022-03-08 18:27:21.793047
2128	1622	5180	extractedFrom	2022-03-08 18:27:21.858923
2129	2818	5181	extractedFrom	2022-03-08 18:27:22.236515
2130	2818	5182	extractedFrom	2022-03-08 18:27:22.33849
2131	2818	5183	extractedFrom	2022-03-08 18:27:22.519475
2132	2818	5184	extractedFrom	2022-03-08 18:27:22.972802
2133	2818	5185	extractedFrom	2022-03-08 18:27:23.850469
2134	2818	5186	extractedFrom	2022-03-08 18:27:24.223548
2135	2818	5186	extractedFrom	2022-03-08 18:27:24.416253
2136	1725	5187	extractedFrom	2022-03-08 18:27:24.706661
2137	1725	5187	extractedFrom	2022-03-08 18:27:24.76935
2138	3521	5188	extractedFrom	2022-03-08 18:27:25.021751
2139	3521	5188	extractedFrom	2022-03-08 18:27:25.078557
2140	3687	5189	extractedFrom	2022-03-08 18:27:25.35957
2141	3687	5190	extractedFrom	2022-03-08 18:27:25.473552
2142	3687	5191	extractedFrom	2022-03-08 18:27:25.566767
2143	3687	5191	extractedFrom	2022-03-08 18:27:25.688501
2144	2267	5192	extractedFrom	2022-03-08 18:27:25.864144
2145	2267	5192	extractedFrom	2022-03-08 18:27:25.987922
2146	3217	5193	extractedFrom	2022-03-08 18:27:26.08953
2147	3217	5193	extractedFrom	2022-03-08 18:27:26.13142
2148	2996	5194	extractedFrom	2022-03-08 18:27:26.329043
2149	2996	5195	extractedFrom	2022-03-08 18:27:26.553355
2150	2996	5196	extractedFrom	2022-03-08 18:27:26.643754
2151	2996	5197	extractedFrom	2022-03-08 18:27:26.785386
2152	2996	5198	extractedFrom	2022-03-08 18:27:26.95254
2153	2996	5199	extractedFrom	2022-03-08 18:27:27.225854
2154	2996	5200	extractedFrom	2022-03-08 18:27:27.326678
2155	2996	5200	extractedFrom	2022-03-08 18:27:27.384245
2156	1750	5201	extractedFrom	2022-03-08 18:27:27.568143
2157	1750	5202	extractedFrom	2022-03-08 18:27:27.810566
2158	1750	5203	extractedFrom	2022-03-08 18:27:27.965608
2159	1750	5204	extractedFrom	2022-03-08 18:27:28.0905
2160	1750	5205	extractedFrom	2022-03-08 18:27:28.314801
2161	1750	5206	extractedFrom	2022-03-08 18:27:28.510893
2162	1750	5207	extractedFrom	2022-03-08 18:27:28.718472
2163	1750	5208	extractedFrom	2022-03-08 18:27:28.918672
2164	1750	5209	extractedFrom	2022-03-08 18:27:29.053007
2165	1750	5209	extractedFrom	2022-03-08 18:27:29.13117
2166	2158	5210	extractedFrom	2022-03-08 18:27:29.35166
2167	2158	5211	extractedFrom	2022-03-08 18:27:29.487136
2168	2158	5211	extractedFrom	2022-03-08 18:27:29.581352
2169	2590	5212	extractedFrom	2022-03-08 18:27:29.77312
2170	2590	5213	extractedFrom	2022-03-08 18:27:29.898517
2171	2590	5214	extractedFrom	2022-03-08 18:27:29.981251
2172	2590	5214	extractedFrom	2022-03-08 18:27:30.034135
2173	2302	5215	extractedFrom	2022-03-08 18:27:30.31937
2174	2302	5215	extractedFrom	2022-03-08 18:27:30.402098
2175	1851	5216	extractedFrom	2022-03-08 18:27:30.551116
2176	1851	5216	extractedFrom	2022-03-08 18:27:30.650019
2177	2904	5217	extractedFrom	2022-03-08 18:27:30.996707
2178	2904	5218	extractedFrom	2022-03-08 18:27:31.1598
2179	2904	5219	extractedFrom	2022-03-08 18:27:31.462821
2180	2904	5219	extractedFrom	2022-03-08 18:27:31.565152
2181	3186	5220	extractedFrom	2022-03-08 18:27:31.953943
2182	3186	5221	extractedFrom	2022-03-08 18:27:32.079286
2183	3186	5222	extractedFrom	2022-03-08 18:27:32.191868
2184	3186	5223	extractedFrom	2022-03-08 18:27:32.299658
2185	3186	5224	extractedFrom	2022-03-08 18:27:32.400578
2186	3186	5225	extractedFrom	2022-03-08 18:27:32.668266
2187	3186	5226	extractedFrom	2022-03-08 18:27:32.899879
2188	3186	5226	extractedFrom	2022-03-08 18:27:32.977575
2189	1621	5227	extractedFrom	2022-03-08 18:27:33.143587
2190	1621	5227	extractedFrom	2022-03-08 18:27:33.229327
2191	2251	5228	extractedFrom	2022-03-08 18:27:33.992598
2192	2251	5229	extractedFrom	2022-03-08 18:27:34.811154
2193	2251	5229	extractedFrom	2022-03-08 18:27:35.157
2194	2042	5230	extractedFrom	2022-03-08 18:27:35.508303
2195	2042	5231	extractedFrom	2022-03-08 18:27:35.641352
2196	2042	5231	extractedFrom	2022-03-08 18:27:35.736536
2197	2853	5232	extractedFrom	2022-03-08 18:27:35.976582
2198	2853	5232	extractedFrom	2022-03-08 18:27:36.104594
2199	3412	5233	extractedFrom	2022-03-08 18:27:36.227473
2200	3412	5234	extractedFrom	2022-03-08 18:27:36.354433
2201	3412	5235	extractedFrom	2022-03-08 18:27:36.486406
2202	3412	5235	extractedFrom	2022-03-08 18:27:36.581731
2203	2000	5236	extractedFrom	2022-03-08 18:27:36.809489
2204	2000	5237	extractedFrom	2022-03-08 18:27:36.970777
2205	2000	5237	extractedFrom	2022-03-08 18:27:37.062785
2206	2883	5238	extractedFrom	2022-03-08 18:27:37.199704
2207	2883	5239	extractedFrom	2022-03-08 18:27:37.30844
2208	2883	5240	extractedFrom	2022-03-08 18:27:37.551243
2209	2883	5241	extractedFrom	2022-03-08 18:27:37.766529
2210	2883	5242	extractedFrom	2022-03-08 18:27:37.885401
2211	2883	5242	extractedFrom	2022-03-08 18:27:38.089912
2212	3444	5243	extractedFrom	2022-03-08 18:27:38.298771
2213	3444	5243	extractedFrom	2022-03-08 18:27:38.363388
2214	1731	5244	extractedFrom	2022-03-08 18:27:38.485389
2215	1731	5244	extractedFrom	2022-03-08 18:27:38.546388
2216	3241	5245	extractedFrom	2022-03-08 18:27:38.866857
2217	3241	5246	extractedFrom	2022-03-08 18:27:39.12417
2218	3241	5247	extractedFrom	2022-03-08 18:27:39.232267
2219	3241	5248	extractedFrom	2022-03-08 18:27:39.529445
2220	3241	5249	extractedFrom	2022-03-08 18:27:39.661224
2221	3241	5250	extractedFrom	2022-03-08 18:27:39.866421
2222	3241	5250	extractedFrom	2022-03-08 18:27:39.926514
2223	2743	5251	extractedFrom	2022-03-08 18:27:40.033118
2224	2743	5251	extractedFrom	2022-03-08 18:27:40.100683
2225	2457	5252	extractedFrom	2022-03-08 18:27:40.560684
2226	2457	5253	extractedFrom	2022-03-08 18:27:40.749704
2227	2457	5254	extractedFrom	2022-03-08 18:27:41.101225
2228	2457	5255	extractedFrom	2022-03-08 18:27:41.291587
2229	2457	5256	extractedFrom	2022-03-08 18:27:41.446163
2230	2457	5257	extractedFrom	2022-03-08 18:27:41.554995
2231	2457	5257	extractedFrom	2022-03-08 18:27:41.632981
2232	1576	5258	extractedFrom	2022-03-08 18:27:41.850432
2233	1576	5258	extractedFrom	2022-03-08 18:27:41.901736
2234	2890	5259	extractedFrom	2022-03-08 18:27:42.024997
2235	2890	5259	extractedFrom	2022-03-08 18:27:42.10198
2236	3433	5260	extractedFrom	2022-03-08 18:27:42.374588
2237	3433	5260	extractedFrom	2022-03-08 18:27:42.426222
2238	3534	5261	extractedFrom	2022-03-08 18:27:42.53297
2239	3534	5262	extractedFrom	2022-03-08 18:27:42.761313
2240	3534	5263	extractedFrom	2022-03-08 18:27:42.844033
2241	3534	5263	extractedFrom	2022-03-08 18:27:42.904481
2242	1848	5264	extractedFrom	2022-03-08 18:27:43.169678
2243	1848	5264	extractedFrom	2022-03-08 18:27:43.239994
2244	1612	5265	extractedFrom	2022-03-08 18:27:43.34523
2245	1612	5265	extractedFrom	2022-03-08 18:27:43.438358
2246	2895	5266	extractedFrom	2022-03-08 18:27:43.61246
2247	2895	5266	extractedFrom	2022-03-08 18:27:43.689321
2248	2844	5267	extractedFrom	2022-03-08 18:27:43.955441
2249	2844	5268	extractedFrom	2022-03-08 18:27:44.174366
2250	2844	5269	extractedFrom	2022-03-08 18:27:44.674336
2251	2844	5269	extractedFrom	2022-03-08 18:27:45.003578
2252	2964	5270	extractedFrom	2022-03-08 18:27:45.112049
2253	2964	5270	extractedFrom	2022-03-08 18:27:45.224567
2254	2576	5271	extractedFrom	2022-03-08 18:27:45.353397
2255	2576	5272	extractedFrom	2022-03-08 18:27:45.470793
2256	2576	5272	extractedFrom	2022-03-08 18:27:45.544223
2257	3110	5273	extractedFrom	2022-03-08 18:27:45.770207
2258	3110	5274	extractedFrom	2022-03-08 18:27:46.007592
2259	3110	5275	extractedFrom	2022-03-08 18:27:46.218123
2260	3110	5276	extractedFrom	2022-03-08 18:27:46.366517
2261	3110	5277	extractedFrom	2022-03-08 18:27:46.566437
2262	3110	5278	extractedFrom	2022-03-08 18:27:46.78701
2263	3110	5279	extractedFrom	2022-03-08 18:27:47.162467
2264	3110	5279	extractedFrom	2022-03-08 18:27:47.414947
2265	3527	5280	extractedFrom	2022-03-08 18:27:47.548101
2266	3527	5280	extractedFrom	2022-03-08 18:27:47.615701
2267	3574	5281	extractedFrom	2022-03-08 18:27:47.890673
2268	3574	5282	extractedFrom	2022-03-08 18:27:48.016163
2269	3574	5282	extractedFrom	2022-03-08 18:27:48.145844
2270	2241	5283	extractedFrom	2022-03-08 18:27:48.251616
2271	2241	5284	extractedFrom	2022-03-08 18:27:48.374782
2272	2241	5284	extractedFrom	2022-03-08 18:27:48.447605
2273	3170	5285	extractedFrom	2022-03-08 18:27:48.634293
2274	3170	5285	extractedFrom	2022-03-08 18:27:48.700687
2275	2112	5286	extractedFrom	2022-03-08 18:27:48.893956
2276	2112	5286	extractedFrom	2022-03-08 18:27:48.976645
2277	3517	5287	extractedFrom	2022-03-08 18:27:49.106376
2278	3517	5288	extractedFrom	2022-03-08 18:27:49.419324
2279	3517	5288	extractedFrom	2022-03-08 18:27:49.463019
2280	1801	5289	extractedFrom	2022-03-08 18:27:50.0359
2281	1801	5290	extractedFrom	2022-03-08 18:27:50.406126
2282	1801	5291	extractedFrom	2022-03-08 18:27:50.840594
2283	1801	5291	extractedFrom	2022-03-08 18:27:50.957743
2284	2916	5292	extractedFrom	2022-03-08 18:27:51.269735
2285	2916	5292	extractedFrom	2022-03-08 18:27:51.537546
2286	1745	5293	extractedFrom	2022-03-08 18:27:52.138968
2287	1745	5293	extractedFrom	2022-03-08 18:27:52.265715
2288	2881	5294	extractedFrom	2022-03-08 18:27:52.565733
2289	2881	5294	extractedFrom	2022-03-08 18:27:52.642761
2290	2558	5295	extractedFrom	2022-03-08 18:27:52.93554
2291	2558	5296	extractedFrom	2022-03-08 18:27:53.131016
2292	2558	5296	extractedFrom	2022-03-08 18:27:53.227138
2293	1883	5297	extractedFrom	2022-03-08 18:27:53.325147
2294	1883	5298	extractedFrom	2022-03-08 18:27:53.662664
2295	1883	5299	extractedFrom	2022-03-08 18:27:53.866561
2296	1883	5300	extractedFrom	2022-03-08 18:27:54.037937
2297	1883	5300	extractedFrom	2022-03-08 18:27:54.123749
2298	2409	5301	extractedFrom	2022-03-08 18:27:54.288916
2299	2409	5301	extractedFrom	2022-03-08 18:27:54.365525
2300	3196	5302	extractedFrom	2022-03-08 18:27:54.475532
2301	3196	5303	extractedFrom	2022-03-08 18:27:54.760497
2302	3196	5303	extractedFrom	2022-03-08 18:27:54.871991
2303	1791	5304	extractedFrom	2022-03-08 18:27:55.043633
2304	1791	5305	extractedFrom	2022-03-08 18:27:55.337101
2305	1791	5306	extractedFrom	2022-03-08 18:27:55.534308
2306	1791	5307	extractedFrom	2022-03-08 18:27:55.697105
2307	1791	5308	extractedFrom	2022-03-08 18:27:55.78855
2308	1791	5309	extractedFrom	2022-03-08 18:27:55.880052
2309	1791	5310	extractedFrom	2022-03-08 18:27:56.22569
2310	1791	5310	extractedFrom	2022-03-08 18:27:56.302895
2311	3087	5311	extractedFrom	2022-03-08 18:27:56.442263
2312	3087	5311	extractedFrom	2022-03-08 18:27:56.620052
2313	2648	5312	extractedFrom	2022-03-08 18:27:57.063169
2314	2648	5313	extractedFrom	2022-03-08 18:27:57.234687
2315	2648	5314	extractedFrom	2022-03-08 18:27:57.351496
2316	2648	5315	extractedFrom	2022-03-08 18:27:57.478637
2317	2648	5316	extractedFrom	2022-03-08 18:27:57.604226
2318	2648	5316	extractedFrom	2022-03-08 18:27:57.68078
2319	2390	5317	extractedFrom	2022-03-08 18:27:57.86142
2320	2390	5317	extractedFrom	2022-03-08 18:27:57.942455
2321	3350	5318	extractedFrom	2022-03-08 18:27:58.192839
2322	3350	5318	extractedFrom	2022-03-08 18:27:58.311141
2323	2728	5319	extractedFrom	2022-03-08 18:27:58.83148
2324	2728	5319	extractedFrom	2022-03-08 18:27:58.938061
2325	3374	5320	extractedFrom	2022-03-08 18:27:59.207804
2326	3374	5320	extractedFrom	2022-03-08 18:27:59.280557
2327	2272	5321	extractedFrom	2022-03-08 18:27:59.463641
2328	2272	5321	extractedFrom	2022-03-08 18:27:59.541424
2329	3086	5322	extractedFrom	2022-03-08 18:27:59.703104
2330	3086	5323	extractedFrom	2022-03-08 18:27:59.842765
2331	3086	5323	extractedFrom	2022-03-08 18:28:00.036552
2332	3636	5324	extractedFrom	2022-03-08 18:28:00.14651
2333	3636	5325	extractedFrom	2022-03-08 18:28:00.246883
2334	3636	5325	extractedFrom	2022-03-08 18:28:00.316146
2335	3423	5326	extractedFrom	2022-03-08 18:28:00.419663
2336	3423	5326	extractedFrom	2022-03-08 18:28:00.506403
2337	3355	5327	extractedFrom	2022-03-08 18:28:00.803225
2338	3355	5327	extractedFrom	2022-03-08 18:28:00.903365
2339	1835	5328	extractedFrom	2022-03-08 18:28:00.975019
2340	1835	5328	extractedFrom	2022-03-08 18:28:01.028765
2341	3608	5329	extractedFrom	2022-03-08 18:28:01.133464
2342	3608	5329	extractedFrom	2022-03-08 18:28:01.212749
2343	2405	5330	extractedFrom	2022-03-08 18:28:01.33671
2344	2405	5330	extractedFrom	2022-03-08 18:28:01.416048
2345	1693	5331	extractedFrom	2022-03-08 18:28:01.553853
2346	1693	5331	extractedFrom	2022-03-08 18:28:01.605693
2347	1982	5332	extractedFrom	2022-03-08 18:28:01.704818
2348	1982	5332	extractedFrom	2022-03-08 18:28:01.787564
2349	1818	5333	extractedFrom	2022-03-08 18:28:01.911518
2350	1818	5333	extractedFrom	2022-03-08 18:28:01.98219
2351	2716	5334	extractedFrom	2022-03-08 18:28:02.1511
2352	2716	5334	extractedFrom	2022-03-08 18:28:02.212354
2353	2189	5335	extractedFrom	2022-03-08 18:28:02.301318
2354	2189	5336	extractedFrom	2022-03-08 18:28:02.407012
2355	2189	5336	extractedFrom	2022-03-08 18:28:02.493122
2356	2216	5337	extractedFrom	2022-03-08 18:28:02.632964
2357	2216	5337	extractedFrom	2022-03-08 18:28:02.73576
2358	2239	5338	extractedFrom	2022-03-08 18:28:03.097809
2359	2239	5338	extractedFrom	2022-03-08 18:28:03.220684
2360	1962	5339	extractedFrom	2022-03-08 18:28:03.438061
2361	1962	5340	extractedFrom	2022-03-08 18:28:03.679292
2362	1962	5341	extractedFrom	2022-03-08 18:28:03.769132
2363	1962	5341	extractedFrom	2022-03-08 18:28:03.828949
2364	1717	5342	extractedFrom	2022-03-08 18:28:03.935871
2365	1717	5343	extractedFrom	2022-03-08 18:28:04.061171
2366	1717	5344	extractedFrom	2022-03-08 18:28:04.211172
2367	1717	5344	extractedFrom	2022-03-08 18:28:04.280804
2368	2468	5345	extractedFrom	2022-03-08 18:28:04.479237
2369	2468	5345	extractedFrom	2022-03-08 18:28:04.534503
2370	2450	5346	extractedFrom	2022-03-08 18:28:04.64601
2371	2450	5347	extractedFrom	2022-03-08 18:28:04.8796
2372	2450	5347	extractedFrom	2022-03-08 18:28:04.941567
2373	2356	5348	extractedFrom	2022-03-08 18:28:05.226619
2374	2356	5349	extractedFrom	2022-03-08 18:28:05.482134
2375	2356	5350	extractedFrom	2022-03-08 18:28:05.679521
2376	2356	5350	extractedFrom	2022-03-08 18:28:05.946061
2377	3049	5351	extractedFrom	2022-03-08 18:28:06.080567
2378	3049	5351	extractedFrom	2022-03-08 18:28:06.148568
2379	3451	5352	extractedFrom	2022-03-08 18:28:06.262315
2380	3451	5352	extractedFrom	2022-03-08 18:28:06.321352
2381	3044	5353	extractedFrom	2022-03-08 18:28:06.44512
2382	3044	5353	extractedFrom	2022-03-08 18:28:06.523885
2383	1921	5354	extractedFrom	2022-03-08 18:28:06.936442
2384	1921	5354	extractedFrom	2022-03-08 18:28:06.985113
2385	2578	5355	extractedFrom	2022-03-08 18:28:07.091725
2386	2578	5355	extractedFrom	2022-03-08 18:28:07.253263
2387	2597	5356	extractedFrom	2022-03-08 18:28:07.368212
2388	2597	5357	extractedFrom	2022-03-08 18:28:07.64443
2389	2597	5357	extractedFrom	2022-03-08 18:28:07.724136
2390	3626	5358	extractedFrom	2022-03-08 18:28:07.857722
2391	3626	5358	extractedFrom	2022-03-08 18:28:07.935491
2392	3161	5359	extractedFrom	2022-03-08 18:28:08.238669
2393	3161	5359	extractedFrom	2022-03-08 18:28:08.307005
2394	3018	5360	extractedFrom	2022-03-08 18:28:08.397061
2395	3018	5360	extractedFrom	2022-03-08 18:28:08.456792
2396	2424	5361	extractedFrom	2022-03-08 18:28:08.597371
2397	2424	5361	extractedFrom	2022-03-08 18:28:08.843841
2398	3686	5362	extractedFrom	2022-03-08 18:28:08.938725
2399	3686	5363	extractedFrom	2022-03-08 18:28:09.046061
2400	3686	5364	extractedFrom	2022-03-08 18:28:09.149525
2401	3686	5364	extractedFrom	2022-03-08 18:28:09.201212
2402	2943	5365	extractedFrom	2022-03-08 18:28:09.366297
2403	2943	5366	extractedFrom	2022-03-08 18:28:09.510859
2404	2943	5366	extractedFrom	2022-03-08 18:28:09.561226
2405	3046	5367	extractedFrom	2022-03-08 18:28:09.998351
2406	3046	5368	extractedFrom	2022-03-08 18:28:10.107375
2407	3046	5368	extractedFrom	2022-03-08 18:28:10.168855
2408	1939	5369	extractedFrom	2022-03-08 18:28:10.349594
2409	1939	5370	extractedFrom	2022-03-08 18:28:10.57517
2410	1939	5370	extractedFrom	2022-03-08 18:28:10.636277
2411	2711	5371	extractedFrom	2022-03-08 18:28:10.752417
2412	2711	5372	extractedFrom	2022-03-08 18:28:10.886138
2413	2711	5372	extractedFrom	2022-03-08 18:28:11.014149
2414	1732	5373	extractedFrom	2022-03-08 18:28:11.110426
2415	1732	5374	extractedFrom	2022-03-08 18:28:11.287268
2416	1732	5375	extractedFrom	2022-03-08 18:28:11.475095
2417	1732	5376	extractedFrom	2022-03-08 18:28:11.622736
2418	1732	5377	extractedFrom	2022-03-08 18:28:11.734128
2419	1732	5378	extractedFrom	2022-03-08 18:28:11.841292
2420	1732	5378	extractedFrom	2022-03-08 18:28:11.913525
2421	2056	5379	extractedFrom	2022-03-08 18:28:12.226945
2422	2056	5380	extractedFrom	2022-03-08 18:28:12.387173
2423	2056	5380	extractedFrom	2022-03-08 18:28:12.451212
2424	2961	5381	extractedFrom	2022-03-08 18:28:12.553787
2425	2961	5382	extractedFrom	2022-03-08 18:28:12.811243
2426	2961	5382	extractedFrom	2022-03-08 18:28:12.918757
2427	2497	5383	extractedFrom	2022-03-08 18:28:13.074072
2428	2497	5384	extractedFrom	2022-03-08 18:28:13.308542
2429	2497	5385	extractedFrom	2022-03-08 18:28:13.428776
2430	2497	5386	extractedFrom	2022-03-08 18:28:13.518295
2431	2497	5386	extractedFrom	2022-03-08 18:28:13.695345
2432	1744	5387	extractedFrom	2022-03-08 18:28:13.86678
2433	1744	5387	extractedFrom	2022-03-08 18:28:13.968341
2434	3035	5388	extractedFrom	2022-03-08 18:28:14.346588
2435	3035	5389	extractedFrom	2022-03-08 18:28:14.496289
2436	3035	5389	extractedFrom	2022-03-08 18:28:14.70375
2437	1833	5390	extractedFrom	2022-03-08 18:28:14.810117
2438	1833	5390	extractedFrom	2022-03-08 18:28:14.855942
2439	2489	5391	extractedFrom	2022-03-08 18:28:15.097152
2440	2489	5392	extractedFrom	2022-03-08 18:28:15.451663
2441	2489	5392	extractedFrom	2022-03-08 18:28:15.532771
2442	2418	5393	extractedFrom	2022-03-08 18:28:15.662319
2443	2418	5394	extractedFrom	2022-03-08 18:28:15.774487
2444	2418	5395	extractedFrom	2022-03-08 18:28:15.887458
2445	2418	5395	extractedFrom	2022-03-08 18:28:15.951542
2446	3280	5396	extractedFrom	2022-03-08 18:28:16.153098
2447	3280	5397	extractedFrom	2022-03-08 18:28:16.277608
2448	3280	5398	extractedFrom	2022-03-08 18:28:16.370217
2449	3280	5399	extractedFrom	2022-03-08 18:28:16.494402
2450	3280	5399	extractedFrom	2022-03-08 18:28:16.558026
2451	2459	5400	extractedFrom	2022-03-08 18:28:16.670285
2452	2459	5401	extractedFrom	2022-03-08 18:28:16.919977
2453	2459	5401	extractedFrom	2022-03-08 18:28:16.983644
2454	1633	5402	extractedFrom	2022-03-08 18:28:17.161835
2455	1633	5402	extractedFrom	2022-03-08 18:28:17.21645
2456	3292	5403	extractedFrom	2022-03-08 18:28:17.311833
2457	3292	5403	extractedFrom	2022-03-08 18:28:17.442721
2458	3111	5404	extractedFrom	2022-03-08 18:28:17.603686
2459	3111	5404	extractedFrom	2022-03-08 18:28:17.675739
2460	1928	5405	extractedFrom	2022-03-08 18:28:17.995674
2461	1928	5405	extractedFrom	2022-03-08 18:28:18.058755
2462	2274	5406	extractedFrom	2022-03-08 18:28:18.18824
2463	2274	5406	extractedFrom	2022-03-08 18:28:18.243033
2464	2402	5407	extractedFrom	2022-03-08 18:28:18.337812
2465	2402	5408	extractedFrom	2022-03-08 18:28:18.531566
2466	2402	5409	extractedFrom	2022-03-08 18:28:18.658581
2467	2402	5410	extractedFrom	2022-03-08 18:28:18.885615
2468	2402	5411	extractedFrom	2022-03-08 18:28:19.006587
2469	2402	5412	extractedFrom	2022-03-08 18:28:19.11772
2470	2402	5413	extractedFrom	2022-03-08 18:28:19.234058
2471	2402	5414	extractedFrom	2022-03-08 18:28:19.417606
2472	2402	5415	extractedFrom	2022-03-08 18:28:19.669839
2473	2402	5416	extractedFrom	2022-03-08 18:28:19.772566
2474	2402	5416	extractedFrom	2022-03-08 18:28:19.99264
2475	2111	5417	extractedFrom	2022-03-08 18:28:20.247941
2476	2111	5417	extractedFrom	2022-03-08 18:28:20.307769
2477	3624	5418	extractedFrom	2022-03-08 18:28:20.421668
2478	3624	5419	extractedFrom	2022-03-08 18:28:20.595488
2479	3624	5420	extractedFrom	2022-03-08 18:28:20.825929
2480	3624	5420	extractedFrom	2022-03-08 18:28:20.878059
2481	3622	5421	extractedFrom	2022-03-08 18:28:20.983787
2482	3622	5422	extractedFrom	2022-03-08 18:28:21.21404
2483	3622	5422	extractedFrom	2022-03-08 18:28:21.361254
2484	3568	5423	extractedFrom	2022-03-08 18:28:21.472455
2485	3568	5423	extractedFrom	2022-03-08 18:28:21.533137
2486	2908	5424	extractedFrom	2022-03-08 18:28:21.664361
2487	2908	5425	extractedFrom	2022-03-08 18:28:21.80585
2488	2908	5425	extractedFrom	2022-03-08 18:28:21.878495
2489	2142	5426	extractedFrom	2022-03-08 18:28:21.974531
2490	2142	5427	extractedFrom	2022-03-08 18:28:22.166747
2491	2142	5428	extractedFrom	2022-03-08 18:28:22.325063
2492	2142	5428	extractedFrom	2022-03-08 18:28:22.444407
2493	2044	5429	extractedFrom	2022-03-08 18:28:22.550555
2494	2044	5429	extractedFrom	2022-03-08 18:28:22.660408
2495	1881	5430	extractedFrom	2022-03-08 18:28:22.815546
2496	1881	5431	extractedFrom	2022-03-08 18:28:22.994363
2497	1881	5431	extractedFrom	2022-03-08 18:28:23.157978
2498	3236	5432	extractedFrom	2022-03-08 18:28:23.248555
2499	3236	5432	extractedFrom	2022-03-08 18:28:23.316824
2500	2852	5433	extractedFrom	2022-03-08 18:28:23.593462
2501	2852	5434	extractedFrom	2022-03-08 18:28:23.71945
2502	2852	5435	extractedFrom	2022-03-08 18:28:24.216976
2503	2852	5435	extractedFrom	2022-03-08 18:28:24.353224
2504	3095	5436	extractedFrom	2022-03-08 18:28:24.457275
2505	3095	5436	extractedFrom	2022-03-08 18:28:24.506135
2506	2785	5437	extractedFrom	2022-03-08 18:28:24.641924
2507	2785	5437	extractedFrom	2022-03-08 18:28:24.72775
2508	1927	5438	extractedFrom	2022-03-08 18:28:24.824888
2509	1927	5438	extractedFrom	2022-03-08 18:28:24.878258
2510	3190	5439	extractedFrom	2022-03-08 18:28:24.983807
2511	3190	5439	extractedFrom	2022-03-08 18:28:25.194132
2512	2983	5440	extractedFrom	2022-03-08 18:28:25.298974
2513	2983	5441	extractedFrom	2022-03-08 18:28:25.407482
2514	2983	5442	extractedFrom	2022-03-08 18:28:25.619288
2515	2983	5443	extractedFrom	2022-03-08 18:28:25.777439
2516	2983	5444	extractedFrom	2022-03-08 18:28:25.970199
2517	2983	5445	extractedFrom	2022-03-08 18:28:26.138507
2518	2983	5446	extractedFrom	2022-03-08 18:28:26.343165
2519	2983	5446	extractedFrom	2022-03-08 18:28:26.453497
2520	2639	5447	extractedFrom	2022-03-08 18:28:26.549081
2521	2639	5447	extractedFrom	2022-03-08 18:28:26.603754
2522	1593	5448	extractedFrom	2022-03-08 18:28:26.755346
2523	1593	5449	extractedFrom	2022-03-08 18:28:26.84697
2524	1593	5449	extractedFrom	2022-03-08 18:28:26.918014
2525	2946	5450	extractedFrom	2022-03-08 18:28:27.054913
2526	2946	5450	extractedFrom	2022-03-08 18:28:27.130381
2527	2685	5451	extractedFrom	2022-03-08 18:28:27.214212
2528	2685	5452	extractedFrom	2022-03-08 18:28:27.297161
2529	2685	5452	extractedFrom	2022-03-08 18:28:27.375382
2530	2636	5453	extractedFrom	2022-03-08 18:28:27.573315
2531	2636	5453	extractedFrom	2022-03-08 18:28:27.625401
2532	3448	5454	extractedFrom	2022-03-08 18:28:27.731267
2533	3448	5455	extractedFrom	2022-03-08 18:28:28.051187
2534	3448	5456	extractedFrom	2022-03-08 18:28:28.271955
2535	3448	5457	extractedFrom	2022-03-08 18:28:28.396928
2536	3448	5457	extractedFrom	2022-03-08 18:28:28.482704
2537	3121	5458	extractedFrom	2022-03-08 18:28:28.597208
2538	3121	5458	extractedFrom	2022-03-08 18:28:28.860773
2539	2921	5459	extractedFrom	2022-03-08 18:28:29.000596
2540	2921	5460	extractedFrom	2022-03-08 18:28:29.285432
2541	2921	5460	extractedFrom	2022-03-08 18:28:29.354007
2542	3437	5461	extractedFrom	2022-03-08 18:28:29.559326
2543	3437	5461	extractedFrom	2022-03-08 18:28:29.700687
2544	2107	5462	extractedFrom	2022-03-08 18:28:29.816173
2545	2107	5462	extractedFrom	2022-03-08 18:28:29.900902
2546	1639	5463	extractedFrom	2022-03-08 18:28:30.107128
2547	1639	5463	extractedFrom	2022-03-08 18:28:30.150084
2548	2963	5464	extractedFrom	2022-03-08 18:28:30.38204
2549	2963	5465	extractedFrom	2022-03-08 18:28:30.844338
2550	2963	5465	extractedFrom	2022-03-08 18:28:31.044766
2551	1606	5466	extractedFrom	2022-03-08 18:28:31.267395
2552	1606	5467	extractedFrom	2022-03-08 18:28:31.711675
2553	1606	5467	extractedFrom	2022-03-08 18:28:31.792082
2554	3589	5468	extractedFrom	2022-03-08 18:28:31.922254
2555	3589	5469	extractedFrom	2022-03-08 18:28:32.038494
2556	3589	5470	extractedFrom	2022-03-08 18:28:32.277783
2557	3589	5470	extractedFrom	2022-03-08 18:28:32.353699
2558	1963	5471	extractedFrom	2022-03-08 18:28:32.499863
2559	1963	5472	extractedFrom	2022-03-08 18:28:32.614794
2560	1963	5472	extractedFrom	2022-03-08 18:28:32.733469
2561	1644	5473	extractedFrom	2022-03-08 18:28:32.919571
2562	1644	5474	extractedFrom	2022-03-08 18:28:33.010967
2563	1644	5474	extractedFrom	2022-03-08 18:28:33.076571
2564	3262	5475	extractedFrom	2022-03-08 18:28:33.363606
2565	3262	5475	extractedFrom	2022-03-08 18:28:33.440851
2566	1720	5476	extractedFrom	2022-03-08 18:28:33.615494
2567	1720	5477	extractedFrom	2022-03-08 18:28:33.740635
2568	1720	5478	extractedFrom	2022-03-08 18:28:33.907482
2569	1720	5479	extractedFrom	2022-03-08 18:28:34.15902
2570	1720	5480	extractedFrom	2022-03-08 18:28:34.440727
2571	1720	5481	extractedFrom	2022-03-08 18:28:34.57391
2572	1720	5481	extractedFrom	2022-03-08 18:28:34.643354
2573	3481	5482	extractedFrom	2022-03-08 18:28:34.765871
2574	3481	5483	extractedFrom	2022-03-08 18:28:34.849151
2575	3481	5484	extractedFrom	2022-03-08 18:28:35.06743
2576	3481	5484	extractedFrom	2022-03-08 18:28:35.213483
2577	3544	5485	extractedFrom	2022-03-08 18:28:35.304416
2578	3544	5486	extractedFrom	2022-03-08 18:28:35.446195
2579	3544	5487	extractedFrom	2022-03-08 18:28:35.596071
2580	3544	5488	extractedFrom	2022-03-08 18:28:35.699245
2581	3544	5489	extractedFrom	2022-03-08 18:28:35.887247
2582	3544	5489	extractedFrom	2022-03-08 18:28:36.002695
2583	2203	5490	extractedFrom	2022-03-08 18:28:36.103462
2584	2203	5491	extractedFrom	2022-03-08 18:28:36.217501
2585	2203	5491	extractedFrom	2022-03-08 18:28:36.277676
2586	3015	5492	extractedFrom	2022-03-08 18:28:36.393132
2587	3015	5492	extractedFrom	2022-03-08 18:28:36.445547
2588	3253	5493	extractedFrom	2022-03-08 18:28:36.584588
2589	3253	5494	extractedFrom	2022-03-08 18:28:36.702459
2590	3253	5495	extractedFrom	2022-03-08 18:28:36.82637
2591	3253	5495	extractedFrom	2022-03-08 18:28:36.888374
2592	1882	5496	extractedFrom	2022-03-08 18:28:37.001202
2593	1882	5497	extractedFrom	2022-03-08 18:28:37.128694
2594	1882	5497	extractedFrom	2022-03-08 18:28:37.217236
2595	1705	5498	extractedFrom	2022-03-08 18:28:37.539325
2596	1705	5498	extractedFrom	2022-03-08 18:28:37.66895
2597	2580	5499	extractedFrom	2022-03-08 18:28:37.763867
2598	2580	5499	extractedFrom	2022-03-08 18:28:37.823556
2599	1756	5500	extractedFrom	2022-03-08 18:28:37.921173
2600	1756	5500	extractedFrom	2022-03-08 18:28:37.9743
2601	3050	5501	extractedFrom	2022-03-08 18:28:38.160888
2602	3050	5501	extractedFrom	2022-03-08 18:28:38.2198
2603	1583	5502	extractedFrom	2022-03-08 18:28:38.315308
2604	1583	5502	extractedFrom	2022-03-08 18:28:38.368915
2605	2451	5503	extractedFrom	2022-03-08 18:28:38.466916
2606	2451	5503	extractedFrom	2022-03-08 18:28:38.543064
2607	1924	5504	extractedFrom	2022-03-08 18:28:38.640704
2608	1924	5504	extractedFrom	2022-03-08 18:28:38.693113
2609	2539	5505	extractedFrom	2022-03-08 18:28:38.800549
2610	2539	5506	extractedFrom	2022-03-08 18:28:39.181836
2611	2539	5506	extractedFrom	2022-03-08 18:28:39.30379
2612	2360	5507	extractedFrom	2022-03-08 18:28:39.462021
2613	2360	5508	extractedFrom	2022-03-08 18:28:39.641597
2614	2360	5508	extractedFrom	2022-03-08 18:28:39.749197
2615	2127	5509	extractedFrom	2022-03-08 18:28:39.846725
2616	2127	5510	extractedFrom	2022-03-08 18:28:40.067773
2617	2127	5510	extractedFrom	2022-03-08 18:28:40.128867
2618	1913	5511	extractedFrom	2022-03-08 18:28:40.25069
2619	1913	5512	extractedFrom	2022-03-08 18:28:40.334207
2620	1913	5512	extractedFrom	2022-03-08 18:28:40.411652
2621	2070	5513	extractedFrom	2022-03-08 18:28:40.667636
2622	2070	5513	extractedFrom	2022-03-08 18:28:40.779172
2623	1755	5514	extractedFrom	2022-03-08 18:28:41.058309
2624	1755	5515	extractedFrom	2022-03-08 18:28:41.183259
2625	1755	5515	extractedFrom	2022-03-08 18:28:41.261346
2626	2901	5516	extractedFrom	2022-03-08 18:28:41.367427
2627	2901	5517	extractedFrom	2022-03-08 18:28:41.476199
2628	2901	5518	extractedFrom	2022-03-08 18:28:41.567206
2629	2901	5518	extractedFrom	2022-03-08 18:28:41.661226
2630	1979	5519	extractedFrom	2022-03-08 18:28:41.786746
2631	1979	5519	extractedFrom	2022-03-08 18:28:41.839412
2632	3039	5520	extractedFrom	2022-03-08 18:28:41.987252
2633	3039	5520	extractedFrom	2022-03-08 18:28:42.038827
2634	2464	5521	extractedFrom	2022-03-08 18:28:42.162203
2635	2464	5521	extractedFrom	2022-03-08 18:28:42.224796
2636	2929	5522	extractedFrom	2022-03-08 18:28:42.364184
2637	2929	5523	extractedFrom	2022-03-08 18:28:42.580649
2638	2929	5523	extractedFrom	2022-03-08 18:28:42.63114
2639	1774	5524	extractedFrom	2022-03-08 18:28:42.807673
2640	1774	5524	extractedFrom	2022-03-08 18:28:42.88233
2641	3426	5525	extractedFrom	2022-03-08 18:28:42.986839
2642	3426	5526	extractedFrom	2022-03-08 18:28:43.196412
2643	3426	5527	extractedFrom	2022-03-08 18:28:43.287829
2644	3426	5528	extractedFrom	2022-03-08 18:28:43.406741
2645	3426	5528	extractedFrom	2022-03-08 18:28:43.459369
2646	2767	5529	extractedFrom	2022-03-08 18:28:43.582491
2647	2767	5529	extractedFrom	2022-03-08 18:28:43.742961
2648	1997	5530	extractedFrom	2022-03-08 18:28:43.886827
2649	1997	5531	extractedFrom	2022-03-08 18:28:44.024255
2650	1997	5531	extractedFrom	2022-03-08 18:28:44.085548
2651	2369	5532	extractedFrom	2022-03-08 18:28:44.358814
2652	2369	5532	extractedFrom	2022-03-08 18:28:44.527993
2653	2016	5533	extractedFrom	2022-03-08 18:28:44.760751
2654	2016	5533	extractedFrom	2022-03-08 18:28:44.938405
2655	1930	5534	extractedFrom	2022-03-08 18:28:45.085166
2656	1930	5535	extractedFrom	2022-03-08 18:28:45.193708
2657	1930	5535	extractedFrom	2022-03-08 18:28:45.262563
2658	2165	5536	extractedFrom	2022-03-08 18:28:45.351986
2659	2165	5536	extractedFrom	2022-03-08 18:28:45.434886
2660	3368	5537	extractedFrom	2022-03-08 18:28:45.70998
2661	3368	5537	extractedFrom	2022-03-08 18:28:45.87091
2662	2965	5538	extractedFrom	2022-03-08 18:28:45.989404
2663	2965	5538	extractedFrom	2022-03-08 18:28:46.053531
2664	2635	5539	extractedFrom	2022-03-08 18:28:46.273938
2665	2635	5539	extractedFrom	2022-03-08 18:28:46.325855
2666	3232	5540	extractedFrom	2022-03-08 18:28:46.445059
2667	3232	5541	extractedFrom	2022-03-08 18:28:46.549009
2668	3232	5541	extractedFrom	2022-03-08 18:28:46.626563
2669	2244	5542	extractedFrom	2022-03-08 18:28:46.924031
2670	2244	5542	extractedFrom	2022-03-08 18:28:46.97429
2671	3625	5543	extractedFrom	2022-03-08 18:28:47.311357
2672	3625	5543	extractedFrom	2022-03-08 18:28:47.412836
2673	2715	5544	extractedFrom	2022-03-08 18:28:47.519428
2674	2715	5545	extractedFrom	2022-03-08 18:28:47.611408
2675	2715	5546	extractedFrom	2022-03-08 18:28:47.854228
2676	2715	5546	extractedFrom	2022-03-08 18:28:47.931601
2677	1634	5547	extractedFrom	2022-03-08 18:28:48.046396
2678	1634	5547	extractedFrom	2022-03-08 18:28:48.152138
2679	1977	5548	extractedFrom	2022-03-08 18:28:48.465933
2680	1977	5548	extractedFrom	2022-03-08 18:28:48.530442
2681	2108	5549	extractedFrom	2022-03-08 18:28:48.743888
2682	2108	5549	extractedFrom	2022-03-08 18:28:48.851251
2683	2202	5550	extractedFrom	2022-03-08 18:28:49.026758
2684	2202	5551	extractedFrom	2022-03-08 18:28:49.265848
2685	2202	5551	extractedFrom	2022-03-08 18:28:49.328011
2686	1988	5552	extractedFrom	2022-03-08 18:28:49.457264
2687	1988	5552	extractedFrom	2022-03-08 18:28:49.544698
2688	3056	5553	extractedFrom	2022-03-08 18:28:49.738716
2689	3056	5553	extractedFrom	2022-03-08 18:28:49.816164
2690	1783	5554	extractedFrom	2022-03-08 18:28:49.923508
2691	1783	5555	extractedFrom	2022-03-08 18:28:50.097331
2692	1783	5555	extractedFrom	2022-03-08 18:28:50.216287
2693	2128	5556	extractedFrom	2022-03-08 18:28:50.46213
2694	2128	5557	extractedFrom	2022-03-08 18:28:50.671646
2695	2128	5558	extractedFrom	2022-03-08 18:28:50.755288
2696	2128	5559	extractedFrom	2022-03-08 18:28:50.889652
2697	2128	5560	extractedFrom	2022-03-08 18:28:51.059885
2698	2128	5561	extractedFrom	2022-03-08 18:28:51.337878
2699	2128	5562	extractedFrom	2022-03-08 18:28:51.454459
2700	2128	5563	extractedFrom	2022-03-08 18:28:51.807767
2701	2128	5564	extractedFrom	2022-03-08 18:28:51.932371
2702	2128	5565	extractedFrom	2022-03-08 18:28:52.040193
2703	2128	5565	extractedFrom	2022-03-08 18:28:52.465909
2704	2712	5566	extractedFrom	2022-03-08 18:28:52.824753
2705	2712	5566	extractedFrom	2022-03-08 18:28:52.938281
2706	3614	5567	extractedFrom	2022-03-08 18:28:53.604981
2707	3614	5567	extractedFrom	2022-03-08 18:28:53.673341
2708	2113	5568	extractedFrom	2022-03-08 18:28:54.010603
2709	2113	5568	extractedFrom	2022-03-08 18:28:54.240699
2710	3192	5569	extractedFrom	2022-03-08 18:28:54.36447
2711	3192	5569	extractedFrom	2022-03-08 18:28:54.553965
2712	3094	5570	extractedFrom	2022-03-08 18:28:54.665892
2713	3094	5571	extractedFrom	2022-03-08 18:28:54.799027
2714	3094	5572	extractedFrom	2022-03-08 18:28:55.017469
2715	3094	5573	extractedFrom	2022-03-08 18:28:55.193426
2716	3094	5574	extractedFrom	2022-03-08 18:28:55.36008
2717	3094	5575	extractedFrom	2022-03-08 18:28:55.592661
2718	3094	5576	extractedFrom	2022-03-08 18:28:55.735618
2719	3094	5576	extractedFrom	2022-03-08 18:28:55.814053
2720	1853	5577	extractedFrom	2022-03-08 18:28:55.969295
2721	1853	5578	extractedFrom	2022-03-08 18:28:56.247739
2722	1853	5579	extractedFrom	2022-03-08 18:28:56.352002
2723	1853	5580	extractedFrom	2022-03-08 18:28:56.452555
2724	1853	5580	extractedFrom	2022-03-08 18:28:56.524155
2725	2231	5581	extractedFrom	2022-03-08 18:28:56.921755
2726	2231	5581	extractedFrom	2022-03-08 18:28:56.99455
2727	2701	5582	extractedFrom	2022-03-08 18:28:57.122716
2728	2701	5582	extractedFrom	2022-03-08 18:28:57.186204
2729	2710	5583	extractedFrom	2022-03-08 18:28:57.27817
2730	2710	5584	extractedFrom	2022-03-08 18:28:57.585736
2731	2710	5584	extractedFrom	2022-03-08 18:28:57.662476
2732	1869	5585	extractedFrom	2022-03-08 18:28:57.852103
2733	1869	5585	extractedFrom	2022-03-08 18:28:57.988943
2734	3656	5586	extractedFrom	2022-03-08 18:28:58.093929
2735	3656	5586	extractedFrom	2022-03-08 18:28:58.154822
2736	2831	5587	extractedFrom	2022-03-08 18:28:58.351938
2737	2831	5588	extractedFrom	2022-03-08 18:28:58.476839
2738	2831	5588	extractedFrom	2022-03-08 18:28:58.52952
2739	3607	5589	extractedFrom	2022-03-08 18:28:58.840326
2740	3607	5590	extractedFrom	2022-03-08 18:28:58.963258
2741	3607	5591	extractedFrom	2022-03-08 18:28:59.063467
2742	3607	5592	extractedFrom	2022-03-08 18:28:59.216951
2743	3607	5592	extractedFrom	2022-03-08 18:28:59.333654
2744	3547	5593	extractedFrom	2022-03-08 18:28:59.457447
2745	3547	5593	extractedFrom	2022-03-08 18:28:59.519904
2746	1679	5594	extractedFrom	2022-03-08 18:28:59.708249
2747	1679	5594	extractedFrom	2022-03-08 18:28:59.779438
2748	2419	5595	extractedFrom	2022-03-08 18:28:59.889925
2749	2419	5596	extractedFrom	2022-03-08 18:29:00.089028
2750	2419	5596	extractedFrom	2022-03-08 18:29:00.207781
2751	2690	5597	extractedFrom	2022-03-08 18:29:00.571255
2752	2690	5597	extractedFrom	2022-03-08 18:29:00.69362
2753	3678	5598	extractedFrom	2022-03-08 18:29:00.792473
2754	3678	5598	extractedFrom	2022-03-08 18:29:00.886809
2755	2759	5599	extractedFrom	2022-03-08 18:29:01.27748
2756	2759	5599	extractedFrom	2022-03-08 18:29:01.437781
2757	3561	5600	extractedFrom	2022-03-08 18:29:01.570227
2758	3561	5600	extractedFrom	2022-03-08 18:29:01.6478
2759	2913	5601	extractedFrom	2022-03-08 18:29:01.767066
2760	2913	5601	extractedFrom	2022-03-08 18:29:01.819974
2761	2477	5602	extractedFrom	2022-03-08 18:29:01.942137
2762	2477	5603	extractedFrom	2022-03-08 18:29:02.342937
2763	2477	5603	extractedFrom	2022-03-08 18:29:02.562483
2764	3215	5604	extractedFrom	2022-03-08 18:29:02.80015
2765	3215	5605	extractedFrom	2022-03-08 18:29:02.949613
2766	3215	5606	extractedFrom	2022-03-08 18:29:03.155475
2767	3215	5607	extractedFrom	2022-03-08 18:29:03.319603
2768	3215	5608	extractedFrom	2022-03-08 18:29:03.456857
2769	3215	5609	extractedFrom	2022-03-08 18:29:03.574252
2770	3215	5610	extractedFrom	2022-03-08 18:29:03.862128
2771	3215	5611	extractedFrom	2022-03-08 18:29:04.124258
2772	3215	5612	extractedFrom	2022-03-08 18:29:04.238998
2773	3215	5613	extractedFrom	2022-03-08 18:29:04.356865
2774	3215	5614	extractedFrom	2022-03-08 18:29:04.546315
2775	3215	5615	extractedFrom	2022-03-08 18:29:04.646567
2776	3215	5616	extractedFrom	2022-03-08 18:29:04.807581
2777	3215	5617	extractedFrom	2022-03-08 18:29:04.950708
2778	3215	5617	extractedFrom	2022-03-08 18:29:05.022762
2779	3503	5618	extractedFrom	2022-03-08 18:29:05.165153
2780	3503	5619	extractedFrom	2022-03-08 18:29:05.481983
2781	3503	5619	extractedFrom	2022-03-08 18:29:05.551259
2782	1940	5620	extractedFrom	2022-03-08 18:29:05.729887
2783	1940	5620	extractedFrom	2022-03-08 18:29:05.807222
2784	1785	5621	extractedFrom	2022-03-08 18:29:05.917455
2785	1785	5621	extractedFrom	2022-03-08 18:29:05.99557
2786	3644	5622	extractedFrom	2022-03-08 18:29:06.233035
2787	3644	5622	extractedFrom	2022-03-08 18:29:06.313604
2788	3606	5623	extractedFrom	2022-03-08 18:29:06.424597
2789	3606	5623	extractedFrom	2022-03-08 18:29:06.496336
2790	2911	5624	extractedFrom	2022-03-08 18:29:06.619225
2791	2911	5625	extractedFrom	2022-03-08 18:29:06.844288
2792	2911	5625	extractedFrom	2022-03-08 18:29:06.922469
2793	2091	5626	extractedFrom	2022-03-08 18:29:07.016357
2794	2091	5626	extractedFrom	2022-03-08 18:29:07.078651
2795	2920	5627	extractedFrom	2022-03-08 18:29:07.219836
2796	2920	5628	extractedFrom	2022-03-08 18:29:07.409572
2797	2920	5628	extractedFrom	2022-03-08 18:29:07.620138
2798	2430	5629	extractedFrom	2022-03-08 18:29:07.936118
2799	2430	5630	extractedFrom	2022-03-08 18:29:08.071938
2800	2430	5630	extractedFrom	2022-03-08 18:29:08.136141
2801	2090	5631	extractedFrom	2022-03-08 18:29:08.499541
2802	2090	5631	extractedFrom	2022-03-08 18:29:08.56409
2803	1841	5632	extractedFrom	2022-03-08 18:29:08.651197
2804	1841	5632	extractedFrom	2022-03-08 18:29:08.721844
2805	1738	5633	extractedFrom	2022-03-08 18:29:08.826082
2806	1738	5633	extractedFrom	2022-03-08 18:29:08.882055
2807	1918	5634	extractedFrom	2022-03-08 18:29:08.968161
2808	1918	5634	extractedFrom	2022-03-08 18:29:09.130588
2809	2306	5635	extractedFrom	2022-03-08 18:29:09.472782
2810	2306	5635	extractedFrom	2022-03-08 18:29:09.527716
2811	3353	5636	extractedFrom	2022-03-08 18:29:09.630629
2812	3353	5636	extractedFrom	2022-03-08 18:29:09.789553
2813	3483	5637	extractedFrom	2022-03-08 18:29:09.972095
2814	3483	5638	extractedFrom	2022-03-08 18:29:10.080445
2815	3483	5639	extractedFrom	2022-03-08 18:29:10.171435
2816	3483	5639	extractedFrom	2022-03-08 18:29:10.231227
2817	1891	5640	extractedFrom	2022-03-08 18:29:10.439844
2818	1891	5640	extractedFrom	2022-03-08 18:29:10.500381
2819	1723	5641	extractedFrom	2022-03-08 18:29:10.606842
2820	1723	5642	extractedFrom	2022-03-08 18:29:10.77312
2821	1723	5642	extractedFrom	2022-03-08 18:29:10.817785
2822	2714	5643	extractedFrom	2022-03-08 18:29:11.085225
2823	2714	5644	extractedFrom	2022-03-08 18:29:11.338572
2824	2714	5645	extractedFrom	2022-03-08 18:29:11.559028
2825	2714	5645	extractedFrom	2022-03-08 18:29:11.621849
2826	2944	5646	extractedFrom	2022-03-08 18:29:11.826869
2827	2944	5646	extractedFrom	2022-03-08 18:29:11.923369
2828	2989	5647	extractedFrom	2022-03-08 18:29:12.009967
2829	2989	5647	extractedFrom	2022-03-08 18:29:12.072754
2830	3580	5648	extractedFrom	2022-03-08 18:29:12.227212
2831	3580	5649	extractedFrom	2022-03-08 18:29:12.405187
2832	3580	5649	extractedFrom	2022-03-08 18:29:12.502073
2833	2143	5650	extractedFrom	2022-03-08 18:29:12.810124
2834	2143	5650	extractedFrom	2022-03-08 18:29:12.979786
2835	3073	5651	extractedFrom	2022-03-08 18:29:13.194524
2836	3073	5652	extractedFrom	2022-03-08 18:29:13.366943
2837	3073	5653	extractedFrom	2022-03-08 18:29:13.45923
2838	3073	5653	extractedFrom	2022-03-08 18:29:13.522647
2839	2228	5654	extractedFrom	2022-03-08 18:29:13.635262
2840	2228	5655	extractedFrom	2022-03-08 18:29:13.85946
2841	2228	5655	extractedFrom	2022-03-08 18:29:13.933107
2842	1807	5656	extractedFrom	2022-03-08 18:29:14.088399
2843	1807	5656	extractedFrom	2022-03-08 18:29:14.230153
2844	3313	5657	extractedFrom	2022-03-08 18:29:14.416797
2845	3313	5658	extractedFrom	2022-03-08 18:29:14.506115
2846	3313	5659	extractedFrom	2022-03-08 18:29:14.758501
2847	3313	5660	extractedFrom	2022-03-08 18:29:14.890425
2848	3313	5660	extractedFrom	2022-03-08 18:29:14.943337
2849	1684	5661	extractedFrom	2022-03-08 18:29:15.026427
2850	1684	5661	extractedFrom	2022-03-08 18:29:15.085646
2851	2640	5662	extractedFrom	2022-03-08 18:29:15.23419
2852	2640	5662	extractedFrom	2022-03-08 18:29:15.431439
2853	3181	5663	extractedFrom	2022-03-08 18:29:15.685471
2854	3181	5663	extractedFrom	2022-03-08 18:29:15.754447
2855	3492	5664	extractedFrom	2022-03-08 18:29:15.860056
2856	3492	5665	extractedFrom	2022-03-08 18:29:16.045606
2857	3492	5665	extractedFrom	2022-03-08 18:29:16.114654
2858	1886	5666	extractedFrom	2022-03-08 18:29:16.217688
2859	1886	5667	extractedFrom	2022-03-08 18:29:16.578333
2860	1886	5668	extractedFrom	2022-03-08 18:29:16.766591
2861	1886	5668	extractedFrom	2022-03-08 18:29:16.88645
2862	3059	5669	extractedFrom	2022-03-08 18:29:16.991319
2863	3059	5669	extractedFrom	2022-03-08 18:29:17.047782
2864	2656	5670	extractedFrom	2022-03-08 18:29:17.22267
2865	2656	5671	extractedFrom	2022-03-08 18:29:17.345734
2866	2656	5671	extractedFrom	2022-03-08 18:29:17.398158
2867	2146	5672	extractedFrom	2022-03-08 18:29:17.50441
2868	2146	5673	extractedFrom	2022-03-08 18:29:17.754712
2869	2146	5674	extractedFrom	2022-03-08 18:29:17.913767
2870	2146	5674	extractedFrom	2022-03-08 18:29:18.000354
2871	1832	5675	extractedFrom	2022-03-08 18:29:18.32323
2872	1832	5675	extractedFrom	2022-03-08 18:29:18.419026
2873	3390	5676	extractedFrom	2022-03-08 18:29:18.505248
2874	3390	5677	extractedFrom	2022-03-08 18:29:18.704325
2875	3390	5678	extractedFrom	2022-03-08 18:29:18.780997
2876	3390	5679	extractedFrom	2022-03-08 18:29:18.898068
2877	3390	5680	extractedFrom	2022-03-08 18:29:19.114831
2878	3390	5680	extractedFrom	2022-03-08 18:29:19.177704
2879	3416	5681	extractedFrom	2022-03-08 18:29:19.273376
2880	3416	5682	extractedFrom	2022-03-08 18:29:19.385704
2881	3416	5682	extractedFrom	2022-03-08 18:29:19.466037
2882	2010	5683	extractedFrom	2022-03-08 18:29:19.577495
2883	2010	5683	extractedFrom	2022-03-08 18:29:19.704328
2884	2720	5684	extractedFrom	2022-03-08 18:29:19.859882
2885	2720	5684	extractedFrom	2022-03-08 18:29:19.913038
2886	3542	5685	extractedFrom	2022-03-08 18:29:20.010801
2887	3542	5685	extractedFrom	2022-03-08 18:29:20.311773
2888	3339	5686	extractedFrom	2022-03-08 18:29:20.484043
2889	3339	5686	extractedFrom	2022-03-08 18:29:20.546428
2890	3340	5687	extractedFrom	2022-03-08 18:29:20.65062
2891	3340	5687	extractedFrom	2022-03-08 18:29:20.704144
2892	1878	5688	extractedFrom	2022-03-08 18:29:20.834048
2893	1878	5689	extractedFrom	2022-03-08 18:29:20.986024
2894	1878	5689	extractedFrom	2022-03-08 18:29:21.04536
2895	2973	5690	extractedFrom	2022-03-08 18:29:21.118288
2896	2973	5691	extractedFrom	2022-03-08 18:29:21.4132
2897	2973	5691	extractedFrom	2022-03-08 18:29:21.525787
2898	3195	5692	extractedFrom	2022-03-08 18:29:21.881936
2899	3195	5692	extractedFrom	2022-03-08 18:29:22.012612
2900	2027	5693	extractedFrom	2022-03-08 18:29:22.311105
2901	2027	5693	extractedFrom	2022-03-08 18:29:22.434206
2902	2076	5694	extractedFrom	2022-03-08 18:29:22.528453
2903	2076	5695	extractedFrom	2022-03-08 18:29:22.638763
2904	2076	5696	extractedFrom	2022-03-08 18:29:22.790455
2905	2076	5697	extractedFrom	2022-03-08 18:29:22.913926
2906	2076	5698	extractedFrom	2022-03-08 18:29:23.036044
2907	2076	5699	extractedFrom	2022-03-08 18:29:23.316528
2908	2076	5700	extractedFrom	2022-03-08 18:29:23.424338
2909	2076	5701	extractedFrom	2022-03-08 18:29:23.532654
2910	2076	5702	extractedFrom	2022-03-08 18:29:23.649232
2911	2076	5703	extractedFrom	2022-03-08 18:29:23.892061
2912	2076	5704	extractedFrom	2022-03-08 18:29:23.992445
2913	2076	5705	extractedFrom	2022-03-08 18:29:24.142424
2914	2076	5706	extractedFrom	2022-03-08 18:29:24.459118
2915	2076	5706	extractedFrom	2022-03-08 18:29:24.539049
2916	1790	5707	extractedFrom	2022-03-08 18:29:24.913375
2917	1790	5708	extractedFrom	2022-03-08 18:29:25.072138
2918	1790	5709	extractedFrom	2022-03-08 18:29:25.171469
2919	1790	5710	extractedFrom	2022-03-08 18:29:25.398086
2920	1790	5711	extractedFrom	2022-03-08 18:29:25.548617
2921	1790	5712	extractedFrom	2022-03-08 18:29:26.005655
2922	1790	5713	extractedFrom	2022-03-08 18:29:26.255962
2923	1790	5713	extractedFrom	2022-03-08 18:29:26.310992
2924	2249	5714	extractedFrom	2022-03-08 18:29:26.50913
2925	2249	5714	extractedFrom	2022-03-08 18:29:26.604228
2926	1617	5715	extractedFrom	2022-03-08 18:29:26.693643
2927	1617	5715	extractedFrom	2022-03-08 18:29:26.751802
2928	3498	5716	extractedFrom	2022-03-08 18:29:26.909079
2929	3498	5716	extractedFrom	2022-03-08 18:29:26.978659
2930	3234	5717	extractedFrom	2022-03-08 18:29:27.083796
2931	3234	5717	extractedFrom	2022-03-08 18:29:27.314479
2932	3432	5718	extractedFrom	2022-03-08 18:29:27.443862
2933	3432	5718	extractedFrom	2022-03-08 18:29:27.512783
2934	2185	5719	extractedFrom	2022-03-08 18:29:27.696008
2935	2185	5719	extractedFrom	2022-03-08 18:29:27.768084
2936	2170	5720	extractedFrom	2022-03-08 18:29:28.114263
2937	2170	5721	extractedFrom	2022-03-08 18:29:28.2158
2938	2170	5722	extractedFrom	2022-03-08 18:29:28.315907
2939	2170	5723	extractedFrom	2022-03-08 18:29:28.508707
2940	2170	5723	extractedFrom	2022-03-08 18:29:28.560741
2941	3105	5724	extractedFrom	2022-03-08 18:29:28.650281
2942	3105	5725	extractedFrom	2022-03-08 18:29:28.759309
2943	3105	5725	extractedFrom	2022-03-08 18:29:28.878061
2944	3023	5726	extractedFrom	2022-03-08 18:29:29.070604
2945	3023	5726	extractedFrom	2022-03-08 18:29:29.136891
2946	2370	5727	extractedFrom	2022-03-08 18:29:29.363714
2947	2370	5727	extractedFrom	2022-03-08 18:29:29.442614
2948	2434	5728	extractedFrom	2022-03-08 18:29:29.529799
2949	2434	5729	extractedFrom	2022-03-08 18:29:29.714261
2950	2434	5729	extractedFrom	2022-03-08 18:29:29.766551
2951	1701	5730	extractedFrom	2022-03-08 18:29:29.870704
2952	1701	5730	extractedFrom	2022-03-08 18:29:29.926762
2953	3204	5731	extractedFrom	2022-03-08 18:29:30.029597
2954	3204	5731	extractedFrom	2022-03-08 18:29:30.11213
2955	2077	5732	extractedFrom	2022-03-08 18:29:30.288139
2956	2077	5732	extractedFrom	2022-03-08 18:29:30.589063
2957	1834	5733	extractedFrom	2022-03-08 18:29:30.697094
2958	1834	5733	extractedFrom	2022-03-08 18:29:30.763012
2959	2986	5734	extractedFrom	2022-03-08 18:29:30.898676
2960	2986	5735	extractedFrom	2022-03-08 18:29:30.999684
2961	2986	5736	extractedFrom	2022-03-08 18:29:31.193005
2962	2986	5737	extractedFrom	2022-03-08 18:29:31.465852
2963	2986	5737	extractedFrom	2022-03-08 18:29:31.628116
2964	3342	5738	extractedFrom	2022-03-08 18:29:31.847381
2965	3342	5738	extractedFrom	2022-03-08 18:29:31.935894
2966	2870	5739	extractedFrom	2022-03-08 18:29:32.077318
2967	2870	5739	extractedFrom	2022-03-08 18:29:32.147359
2968	1565	5740	extractedFrom	2022-03-08 18:29:32.347865
2969	1565	5741	extractedFrom	2022-03-08 18:29:32.710599
2970	1565	5742	extractedFrom	2022-03-08 18:29:32.875537
2971	1565	5742	extractedFrom	2022-03-08 18:29:33.021677
2972	3040	5743	extractedFrom	2022-03-08 18:29:33.123787
2973	3040	5744	extractedFrom	2022-03-08 18:29:33.239641
2974	3040	5744	extractedFrom	2022-03-08 18:29:33.309767
2975	3543	5745	extractedFrom	2022-03-08 18:29:33.406943
2976	3543	5745	extractedFrom	2022-03-08 18:29:33.475924
2977	3688	5746	extractedFrom	2022-03-08 18:29:33.795485
2978	3688	5747	extractedFrom	2022-03-08 18:29:33.924795
2979	3688	5747	extractedFrom	2022-03-08 18:29:34.053352
2980	2046	5748	extractedFrom	2022-03-08 18:29:34.325801
2981	2046	5748	extractedFrom	2022-03-08 18:29:34.377248
2982	2718	5749	extractedFrom	2022-03-08 18:29:34.560694
2983	2718	5750	extractedFrom	2022-03-08 18:29:34.675147
2984	2718	5750	extractedFrom	2022-03-08 18:29:34.845717
2985	2484	5751	extractedFrom	2022-03-08 18:29:34.968092
2986	2484	5751	extractedFrom	2022-03-08 18:29:35.185953
2987	2101	5752	extractedFrom	2022-03-08 18:29:35.48723
2988	2101	5752	extractedFrom	2022-03-08 18:29:35.596843
2989	3042	5753	extractedFrom	2022-03-08 18:29:35.702679
2990	3042	5753	extractedFrom	2022-03-08 18:29:35.830298
2991	2473	5754	extractedFrom	2022-03-08 18:29:36.009287
2992	2473	5755	extractedFrom	2022-03-08 18:29:36.205867
2993	2473	5755	extractedFrom	2022-03-08 18:29:36.274955
2994	1776	5756	extractedFrom	2022-03-08 18:29:36.595978
2995	1776	5756	extractedFrom	2022-03-08 18:29:36.665724
2996	2333	5757	extractedFrom	2022-03-08 18:29:36.762946
2997	2333	5758	extractedFrom	2022-03-08 18:29:36.89627
2998	2333	5759	extractedFrom	2022-03-08 18:29:37.247814
2999	2333	5759	extractedFrom	2022-03-08 18:29:37.300625
3000	2610	5760	extractedFrom	2022-03-08 18:29:37.533373
3001	2610	5761	extractedFrom	2022-03-08 18:29:37.650077
3002	2610	5761	extractedFrom	2022-03-08 18:29:37.727802
3003	3392	5762	extractedFrom	2022-03-08 18:29:37.95404
3004	3392	5763	extractedFrom	2022-03-08 18:29:38.215202
3005	3392	5764	extractedFrom	2022-03-08 18:29:38.5421
3006	3392	5765	extractedFrom	2022-03-08 18:29:38.741616
3007	3392	5766	extractedFrom	2022-03-08 18:29:38.898231
3008	3392	5766	extractedFrom	2022-03-08 18:29:39.004927
3009	1597	5767	extractedFrom	2022-03-08 18:29:39.164314
3010	1597	5767	extractedFrom	2022-03-08 18:29:39.260853
3011	2271	5768	extractedFrom	2022-03-08 18:29:39.41081
3012	2271	5769	extractedFrom	2022-03-08 18:29:39.530428
3013	2271	5769	extractedFrom	2022-03-08 18:29:39.589268
3014	1903	5770	extractedFrom	2022-03-08 18:29:39.890208
3015	1903	5771	extractedFrom	2022-03-08 18:29:40.220838
3016	1903	5771	extractedFrom	2022-03-08 18:29:40.365309
3017	2454	5772	extractedFrom	2022-03-08 18:29:40.466297
3018	2454	5772	extractedFrom	2022-03-08 18:29:40.547599
3019	1877	5773	extractedFrom	2022-03-08 18:29:40.640393
3020	1877	5774	extractedFrom	2022-03-08 18:29:40.906096
3021	1877	5775	extractedFrom	2022-03-08 18:29:41.007501
3022	1877	5775	extractedFrom	2022-03-08 18:29:41.06788
3023	1876	5776	extractedFrom	2022-03-08 18:29:41.172663
3024	1876	5777	extractedFrom	2022-03-08 18:29:41.344502
3025	1876	5778	extractedFrom	2022-03-08 18:29:41.455994
3026	1876	5778	extractedFrom	2022-03-08 18:29:41.542746
3027	3309	5779	extractedFrom	2022-03-08 18:29:41.958668
3028	3309	5780	extractedFrom	2022-03-08 18:29:42.063251
3029	3309	5781	extractedFrom	2022-03-08 18:29:42.4175
3030	3309	5782	extractedFrom	2022-03-08 18:29:42.53899
3031	3309	5783	extractedFrom	2022-03-08 18:29:42.782899
3032	3309	5783	extractedFrom	2022-03-08 18:29:42.845278
3033	3652	5784	extractedFrom	2022-03-08 18:29:42.976523
3034	3652	5784	extractedFrom	2022-03-08 18:29:43.06609
3035	3299	5785	extractedFrom	2022-03-08 18:29:43.329436
3036	3299	5785	extractedFrom	2022-03-08 18:29:43.425829
3037	2507	5786	extractedFrom	2022-03-08 18:29:43.53538
3038	2507	5787	extractedFrom	2022-03-08 18:29:43.808155
3039	2507	5788	extractedFrom	2022-03-08 18:29:43.931943
3040	2507	5789	extractedFrom	2022-03-08 18:29:44.064647
3041	2507	5790	extractedFrom	2022-03-08 18:29:44.249457
3042	2507	5791	extractedFrom	2022-03-08 18:29:44.623159
3043	2507	5792	extractedFrom	2022-03-08 18:29:44.732268
3044	2507	5793	extractedFrom	2022-03-08 18:29:44.950632
3045	2507	5794	extractedFrom	2022-03-08 18:29:45.14827
3046	2507	5795	extractedFrom	2022-03-08 18:29:45.778879
3047	2507	5795	extractedFrom	2022-03-08 18:29:45.976976
3048	1846	5796	extractedFrom	2022-03-08 18:29:46.298391
3049	1846	5797	extractedFrom	2022-03-08 18:29:46.414684
3050	1846	5797	extractedFrom	2022-03-08 18:29:46.484716
3051	3140	5798	extractedFrom	2022-03-08 18:29:46.590617
3052	3140	5799	extractedFrom	2022-03-08 18:29:46.736197
3053	3140	5800	extractedFrom	2022-03-08 18:29:46.83622
3054	3140	5801	extractedFrom	2022-03-08 18:29:46.944402
3055	3140	5802	extractedFrom	2022-03-08 18:29:47.069467
3056	3140	5803	extractedFrom	2022-03-08 18:29:47.183947
3057	3140	5804	extractedFrom	2022-03-08 18:29:47.379753
3058	3140	5805	extractedFrom	2022-03-08 18:29:47.602398
3059	3140	5806	extractedFrom	2022-03-08 18:29:47.70409
3060	3140	5807	extractedFrom	2022-03-08 18:29:47.882887
3061	3140	5807	extractedFrom	2022-03-08 18:29:47.976891
3062	2924	5808	extractedFrom	2022-03-08 18:29:48.38564
3063	2924	5808	extractedFrom	2022-03-08 18:29:48.521353
3064	2686	5809	extractedFrom	2022-03-08 18:29:48.619178
3065	2686	5809	extractedFrom	2022-03-08 18:29:48.789528
3066	3248	5810	extractedFrom	2022-03-08 18:29:48.921863
3067	3248	5810	extractedFrom	2022-03-08 18:29:49.000604
3068	2658	5811	extractedFrom	2022-03-08 18:29:49.091976
3069	2658	5812	extractedFrom	2022-03-08 18:29:49.362662
3070	2658	5813	extractedFrom	2022-03-08 18:29:49.510433
3071	2658	5814	extractedFrom	2022-03-08 18:29:49.799754
3072	2658	5815	extractedFrom	2022-03-08 18:29:49.974835
3073	2658	5816	extractedFrom	2022-03-08 18:29:50.474807
3074	2658	5816	extractedFrom	2022-03-08 18:29:50.532431
3075	2339	5817	extractedFrom	2022-03-08 18:29:50.756069
3076	2339	5818	extractedFrom	2022-03-08 18:29:50.89063
3077	2339	5819	extractedFrom	2022-03-08 18:29:51.115366
3078	2339	5819	extractedFrom	2022-03-08 18:29:51.167875
3079	3165	5820	extractedFrom	2022-03-08 18:29:51.273267
3080	3165	5821	extractedFrom	2022-03-08 18:29:51.639588
3081	3165	5821	extractedFrom	2022-03-08 18:29:51.695814
3082	3222	5822	extractedFrom	2022-03-08 18:29:51.807042
3083	3222	5823	extractedFrom	2022-03-08 18:29:52.133887
3084	3222	5823	extractedFrom	2022-03-08 18:29:52.233191
3085	2381	5824	extractedFrom	2022-03-08 18:29:52.621387
3086	2381	5825	extractedFrom	2022-03-08 18:29:52.872154
3087	2381	5826	extractedFrom	2022-03-08 18:29:52.974035
3088	2381	5827	extractedFrom	2022-03-08 18:29:53.114859
3089	2381	5828	extractedFrom	2022-03-08 18:29:53.459845
3090	2381	5829	extractedFrom	2022-03-08 18:29:53.65166
3091	2381	5829	extractedFrom	2022-03-08 18:29:53.74166
3092	2266	5830	extractedFrom	2022-03-08 18:29:53.843825
3093	2266	5831	extractedFrom	2022-03-08 18:29:53.927303
3094	2266	5832	extractedFrom	2022-03-08 18:29:54.027395
3095	2266	5833	extractedFrom	2022-03-08 18:29:54.135309
3096	2266	5834	extractedFrom	2022-03-08 18:29:54.252226
3097	2266	5835	extractedFrom	2022-03-08 18:29:54.368892
3098	2266	5836	extractedFrom	2022-03-08 18:29:54.66958
3099	2266	5837	extractedFrom	2022-03-08 18:29:54.812968
3100	2266	5838	extractedFrom	2022-03-08 18:29:55.028156
3101	2266	5839	extractedFrom	2022-03-08 18:29:55.123223
3102	2266	5840	extractedFrom	2022-03-08 18:29:55.250063
3103	2266	5841	extractedFrom	2022-03-08 18:29:55.399314
3104	2266	5842	extractedFrom	2022-03-08 18:29:55.499037
3105	2266	5843	extractedFrom	2022-03-08 18:29:55.814285
3106	2266	5844	extractedFrom	2022-03-08 18:29:55.917732
3107	2266	5845	extractedFrom	2022-03-08 18:29:56.135261
3108	2266	5846	extractedFrom	2022-03-08 18:29:56.226916
3109	2266	5847	extractedFrom	2022-03-08 18:29:56.3999
3110	2266	5848	extractedFrom	2022-03-08 18:29:56.485403
3111	2266	5849	extractedFrom	2022-03-08 18:29:56.577
3112	2266	5850	extractedFrom	2022-03-08 18:29:56.668976
3113	2266	5851	extractedFrom	2022-03-08 18:29:56.789034
3114	2266	5852	extractedFrom	2022-03-08 18:29:56.926617
3115	2266	5853	extractedFrom	2022-03-08 18:29:57.043162
3116	2266	5854	extractedFrom	2022-03-08 18:29:57.243361
3117	2266	5855	extractedFrom	2022-03-08 18:29:57.376881
3118	2266	5856	extractedFrom	2022-03-08 18:29:57.512376
3119	2266	5857	extractedFrom	2022-03-08 18:29:57.886247
3120	2266	5857	extractedFrom	2022-03-08 18:29:57.956878
3121	3038	5858	extractedFrom	2022-03-08 18:29:58.056353
3122	3038	5859	extractedFrom	2022-03-08 18:29:58.195316
3123	3038	5859	extractedFrom	2022-03-08 18:29:58.272906
3124	2240	5860	extractedFrom	2022-03-08 18:29:58.370168
3125	2240	5860	extractedFrom	2022-03-08 18:29:58.423396
3126	3648	5861	extractedFrom	2022-03-08 18:29:58.519863
3127	3648	5861	extractedFrom	2022-03-08 18:29:58.65326
3128	1972	5862	extractedFrom	2022-03-08 18:29:58.796345
3129	1972	5863	extractedFrom	2022-03-08 18:29:58.906179
3130	1972	5863	extractedFrom	2022-03-08 18:29:59.036602
3131	1700	5864	extractedFrom	2022-03-08 18:29:59.593575
3132	1700	5864	extractedFrom	2022-03-08 18:29:59.672841
3133	3124	5865	extractedFrom	2022-03-08 18:29:59.844314
3134	3124	5866	extractedFrom	2022-03-08 18:29:59.952964
3135	3124	5866	extractedFrom	2022-03-08 18:30:00.014926
3136	2566	5867	extractedFrom	2022-03-08 18:30:00.25401
3137	2566	5867	extractedFrom	2022-03-08 18:30:00.346945
3138	1645	5868	extractedFrom	2022-03-08 18:30:00.482299
3139	1645	5868	extractedFrom	2022-03-08 18:30:00.628392
3140	2959	5869	extractedFrom	2022-03-08 18:30:00.914956
3141	2959	5869	extractedFrom	2022-03-08 18:30:01.037475
3142	3261	5870	extractedFrom	2022-03-08 18:30:01.161822
3143	3261	5870	extractedFrom	2022-03-08 18:30:01.215029
3144	1795	5871	extractedFrom	2022-03-08 18:30:01.342994
3145	1795	5871	extractedFrom	2022-03-08 18:30:01.52958
3146	1571	5872	extractedFrom	2022-03-08 18:30:01.67738
3147	1571	5872	extractedFrom	2022-03-08 18:30:01.754807
3148	3668	5873	extractedFrom	2022-03-08 18:30:01.852519
3149	3668	5873	extractedFrom	2022-03-08 18:30:01.905654
3150	1599	5874	extractedFrom	2022-03-08 18:30:02.108293
3151	1599	5874	extractedFrom	2022-03-08 18:30:02.200974
3152	3235	5875	extractedFrom	2022-03-08 18:30:02.286751
3153	3235	5875	extractedFrom	2022-03-08 18:30:02.404016
3154	2273	5876	extractedFrom	2022-03-08 18:30:02.533171
3155	2273	5877	extractedFrom	2022-03-08 18:30:02.955351
3156	2273	5878	extractedFrom	2022-03-08 18:30:03.080504
3157	2273	5878	extractedFrom	2022-03-08 18:30:03.141457
3158	3150	5879	extractedFrom	2022-03-08 18:30:03.402305
3159	3150	5880	extractedFrom	2022-03-08 18:30:03.553123
3160	3150	5881	extractedFrom	2022-03-08 18:30:03.682841
3161	3150	5881	extractedFrom	2022-03-08 18:30:03.842642
3162	2928	5882	extractedFrom	2022-03-08 18:30:04.16858
3163	2928	5882	extractedFrom	2022-03-08 18:30:04.326062
3164	2562	5883	extractedFrom	2022-03-08 18:30:04.476982
3165	2562	5883	extractedFrom	2022-03-08 18:30:04.565908
3166	2019	5884	extractedFrom	2022-03-08 18:30:04.649156
3167	2019	5884	extractedFrom	2022-03-08 18:30:04.719505
3168	3028	5885	extractedFrom	2022-03-08 18:30:04.825107
3169	3028	5886	extractedFrom	2022-03-08 18:30:05.172164
3170	3028	5887	extractedFrom	2022-03-08 18:30:05.410775
3171	3028	5888	extractedFrom	2022-03-08 18:30:05.589602
3172	3028	5889	extractedFrom	2022-03-08 18:30:05.698089
3173	3028	5889	extractedFrom	2022-03-08 18:30:05.784718
3174	1867	5890	extractedFrom	2022-03-08 18:30:05.923583
3175	1867	5891	extractedFrom	2022-03-08 18:30:06.188411
3176	1867	5891	extractedFrom	2022-03-08 18:30:06.273889
3177	1694	5892	extractedFrom	2022-03-08 18:30:06.408095
3178	1694	5892	extractedFrom	2022-03-08 18:30:06.483326
3179	1983	5893	extractedFrom	2022-03-08 18:30:06.630851
3180	1983	5894	extractedFrom	2022-03-08 18:30:06.738839
3181	1983	5895	extractedFrom	2022-03-08 18:30:06.894531
3182	1983	5896	extractedFrom	2022-03-08 18:30:07.058798
3183	1983	5896	extractedFrom	2022-03-08 18:30:07.146396
3184	3479	5897	extractedFrom	2022-03-08 18:30:07.462554
3185	3479	5898	extractedFrom	2022-03-08 18:30:07.610129
3186	3479	5898	extractedFrom	2022-03-08 18:30:07.687772
3187	3582	5899	extractedFrom	2022-03-08 18:30:07.828694
3188	3582	5899	extractedFrom	2022-03-08 18:30:07.897406
3189	3477	5900	extractedFrom	2022-03-08 18:30:08.012152
3190	3477	5901	extractedFrom	2022-03-08 18:30:08.216968
3191	3477	5901	extractedFrom	2022-03-08 18:30:08.353199
3192	3251	5902	extractedFrom	2022-03-08 18:30:08.562023
3193	3251	5902	extractedFrom	2022-03-08 18:30:08.637404
3194	3149	5903	extractedFrom	2022-03-08 18:30:08.825306
3195	3149	5904	extractedFrom	2022-03-08 18:30:08.975104
3196	3149	5904	extractedFrom	2022-03-08 18:30:09.053811
3197	1971	5905	extractedFrom	2022-03-08 18:30:09.143586
3198	1971	5906	extractedFrom	2022-03-08 18:30:09.360541
3199	1971	5907	extractedFrom	2022-03-08 18:30:09.892614
3200	1971	5908	extractedFrom	2022-03-08 18:30:10.240417
3201	1971	5908	extractedFrom	2022-03-08 18:30:10.376482
3202	3021	5909	extractedFrom	2022-03-08 18:30:10.551618
3203	3021	5910	extractedFrom	2022-03-08 18:30:10.900196
3204	3021	5910	extractedFrom	2022-03-08 18:30:10.953723
3205	3489	5911	extractedFrom	2022-03-08 18:30:11.110903
3206	3489	5912	extractedFrom	2022-03-08 18:30:11.252313
3207	3489	5913	extractedFrom	2022-03-08 18:30:11.471147
3208	3489	5913	extractedFrom	2022-03-08 18:30:11.54161
3209	3581	5914	extractedFrom	2022-03-08 18:30:11.727638
3210	3581	5915	extractedFrom	2022-03-08 18:30:11.919864
3211	3581	5915	extractedFrom	2022-03-08 18:30:11.972951
3212	3252	5916	extractedFrom	2022-03-08 18:30:12.097246
3213	3252	5917	extractedFrom	2022-03-08 18:30:12.312841
3214	3252	5918	extractedFrom	2022-03-08 18:30:12.457638
3215	3252	5919	extractedFrom	2022-03-08 18:30:12.641911
3216	3252	5920	extractedFrom	2022-03-08 18:30:12.750393
3217	3252	5921	extractedFrom	2022-03-08 18:30:13.175644
3218	3252	5921	extractedFrom	2022-03-08 18:30:13.259643
3219	3641	5922	extractedFrom	2022-03-08 18:30:13.622735
3220	3641	5922	extractedFrom	2022-03-08 18:30:13.799601
3221	2854	5923	extractedFrom	2022-03-08 18:30:13.925819
3222	2854	5923	extractedFrom	2022-03-08 18:30:14.020635
3223	1937	5924	extractedFrom	2022-03-08 18:30:14.158026
3224	1937	5925	extractedFrom	2022-03-08 18:30:14.323668
3225	1937	5925	extractedFrom	2022-03-08 18:30:14.537945
3226	2172	5926	extractedFrom	2022-03-08 18:30:14.648184
3227	2172	5926	extractedFrom	2022-03-08 18:30:14.784068
3228	1624	5927	extractedFrom	2022-03-08 18:30:15.182578
3229	1624	5927	extractedFrom	2022-03-08 18:30:15.254094
3230	2351	5928	extractedFrom	2022-03-08 18:30:15.37658
3231	2351	5928	extractedFrom	2022-03-08 18:30:15.466712
3232	3029	5929	extractedFrom	2022-03-08 18:30:15.594111
3233	3029	5930	extractedFrom	2022-03-08 18:30:15.696411
3234	3029	5931	extractedFrom	2022-03-08 18:30:15.819038
3235	3029	5932	extractedFrom	2022-03-08 18:30:15.977823
3236	3029	5932	extractedFrom	2022-03-08 18:30:16.034231
3237	2051	5933	extractedFrom	2022-03-08 18:30:16.123212
3238	2051	5934	extractedFrom	2022-03-08 18:30:16.231695
3239	2051	5935	extractedFrom	2022-03-08 18:30:16.449319
3240	2051	5936	extractedFrom	2022-03-08 18:30:16.566849
3241	2051	5936	extractedFrom	2022-03-08 18:30:16.672468
3242	2478	5937	extractedFrom	2022-03-08 18:30:16.826857
3243	2478	5938	extractedFrom	2022-03-08 18:30:17.075396
3244	2478	5939	extractedFrom	2022-03-08 18:30:17.216565
3245	2478	5939	extractedFrom	2022-03-08 18:30:17.622234
3246	1697	5940	extractedFrom	2022-03-08 18:30:17.827124
3247	1697	5941	extractedFrom	2022-03-08 18:30:17.943905
3248	1697	5942	extractedFrom	2022-03-08 18:30:18.054553
3249	1697	5942	extractedFrom	2022-03-08 18:30:18.107615
3250	1594	5943	extractedFrom	2022-03-08 18:30:18.204783
3251	1594	5943	extractedFrom	2022-03-08 18:30:18.257367
3252	3068	5944	extractedFrom	2022-03-08 18:30:18.440754
3253	3068	5944	extractedFrom	2022-03-08 18:30:18.59493
3254	3661	5945	extractedFrom	2022-03-08 18:30:18.790426
3255	3661	5946	extractedFrom	2022-03-08 18:30:18.992178
3256	3661	5946	extractedFrom	2022-03-08 18:30:19.058995
3257	1885	5947	extractedFrom	2022-03-08 18:30:19.198117
3258	1885	5947	extractedFrom	2022-03-08 18:30:19.367048
3259	2276	5948	extractedFrom	2022-03-08 18:30:19.482333
3260	2276	5949	extractedFrom	2022-03-08 18:30:19.607494
3261	2276	5950	extractedFrom	2022-03-08 18:30:19.909643
3262	2276	5951	extractedFrom	2022-03-08 18:30:20.006069
3263	2276	5951	extractedFrom	2022-03-08 18:30:20.165748
3264	2307	5952	extractedFrom	2022-03-08 18:30:20.265171
3265	2307	5952	extractedFrom	2022-03-08 18:30:20.384795
3266	3206	5953	extractedFrom	2022-03-08 18:30:20.549778
3267	3206	5954	extractedFrom	2022-03-08 18:30:20.915442
3268	3206	5954	extractedFrom	2022-03-08 18:30:21.001492
3269	2120	5955	extractedFrom	2022-03-08 18:30:21.391956
3270	2120	5955	extractedFrom	2022-03-08 18:30:21.454245
3271	2346	5956	extractedFrom	2022-03-08 18:30:21.702562
3272	2346	5957	extractedFrom	2022-03-08 18:30:21.819563
3273	2346	5958	extractedFrom	2022-03-08 18:30:22.021169
3274	2346	5959	extractedFrom	2022-03-08 18:30:22.237944
3275	2346	5960	extractedFrom	2022-03-08 18:30:22.397465
3276	2346	5961	extractedFrom	2022-03-08 18:30:22.521731
3277	2346	5961	extractedFrom	2022-03-08 18:30:22.624596
3278	2820	5962	extractedFrom	2022-03-08 18:30:22.743529
3279	2820	5963	extractedFrom	2022-03-08 18:30:22.918286
3280	2820	5964	extractedFrom	2022-03-08 18:30:23.027387
3281	2820	5965	extractedFrom	2022-03-08 18:30:23.127376
3282	2820	5966	extractedFrom	2022-03-08 18:30:23.344605
3283	2820	5967	extractedFrom	2022-03-08 18:30:23.546508
3284	2820	5968	extractedFrom	2022-03-08 18:30:23.746277
3285	2820	5968	extractedFrom	2022-03-08 18:30:23.818876
3286	2086	5969	extractedFrom	2022-03-08 18:30:23.985548
3287	2086	5970	extractedFrom	2022-03-08 18:30:24.110316
3288	2086	5971	extractedFrom	2022-03-08 18:30:24.301276
3289	2086	5972	extractedFrom	2022-03-08 18:30:24.400696
3290	2086	5973	extractedFrom	2022-03-08 18:30:24.512113
3291	2086	5974	extractedFrom	2022-03-08 18:30:24.758651
3292	2086	5974	extractedFrom	2022-03-08 18:30:25.021744
3293	2609	5975	extractedFrom	2022-03-08 18:30:25.158573
3294	2609	5976	extractedFrom	2022-03-08 18:30:25.317798
3295	2609	5976	extractedFrom	2022-03-08 18:30:25.435751
3296	3237	5977	extractedFrom	2022-03-08 18:30:25.619496
3297	3237	5977	extractedFrom	2022-03-08 18:30:25.693814
3298	1912	5978	extractedFrom	2022-03-08 18:30:25.833548
3299	1912	5978	extractedFrom	2022-03-08 18:30:26.012597
3300	2472	5979	extractedFrom	2022-03-08 18:30:26.160289
3301	2472	5979	extractedFrom	2022-03-08 18:30:26.336806
3302	2350	5980	extractedFrom	2022-03-08 18:30:26.508045
3303	2350	5980	extractedFrom	2022-03-08 18:30:26.620323
3304	3164	5981	extractedFrom	2022-03-08 18:30:26.778014
3305	3164	5982	extractedFrom	2022-03-08 18:30:26.934281
3306	3164	5983	extractedFrom	2022-03-08 18:30:27.069882
3307	3164	5984	extractedFrom	2022-03-08 18:30:27.212157
3308	3164	5984	extractedFrom	2022-03-08 18:30:27.428712
3309	2805	5985	extractedFrom	2022-03-08 18:30:27.561245
3310	2805	5986	extractedFrom	2022-03-08 18:30:27.838762
3311	2805	5986	extractedFrom	2022-03-08 18:30:27.959063
3312	2160	5987	extractedFrom	2022-03-08 18:30:28.053376
3313	2160	5988	extractedFrom	2022-03-08 18:30:28.17912
3314	2160	5988	extractedFrom	2022-03-08 18:30:28.248318
3315	2517	5989	extractedFrom	2022-03-08 18:30:28.646465
3316	2517	5989	extractedFrom	2022-03-08 18:30:28.778134
3317	3201	5990	extractedFrom	2022-03-08 18:30:28.964953
3318	3201	5991	extractedFrom	2022-03-08 18:30:29.055178
3319	3201	5992	extractedFrom	2022-03-08 18:30:29.383586
3320	3201	5993	extractedFrom	2022-03-08 18:30:29.742031
3321	3201	5994	extractedFrom	2022-03-08 18:30:29.833825
3322	3201	5995	extractedFrom	2022-03-08 18:30:29.985059
3323	3201	5996	extractedFrom	2022-03-08 18:30:30.154895
3324	3201	5997	extractedFrom	2022-03-08 18:30:30.268094
3325	3201	5998	extractedFrom	2022-03-08 18:30:30.420543
3326	3201	5998	extractedFrom	2022-03-08 18:30:30.518163
3327	3033	5999	extractedFrom	2022-03-08 18:30:30.686222
3328	3033	5999	extractedFrom	2022-03-08 18:30:30.754215
3329	2814	6000	extractedFrom	2022-03-08 18:30:30.84701
3330	2814	6000	extractedFrom	2022-03-08 18:30:30.955407
3331	3381	6001	extractedFrom	2022-03-08 18:30:31.106106
3332	3381	6002	extractedFrom	2022-03-08 18:30:31.460034
3333	3381	6003	extractedFrom	2022-03-08 18:30:31.631808
3334	3381	6003	extractedFrom	2022-03-08 18:30:31.740134
3335	2688	6004	extractedFrom	2022-03-08 18:30:32.004295
3336	2688	6004	extractedFrom	2022-03-08 18:30:32.097424
3337	2022	6005	extractedFrom	2022-03-08 18:30:32.227855
3338	2022	6005	extractedFrom	2022-03-08 18:30:32.317037
3339	2218	6006	extractedFrom	2022-03-08 18:30:32.726199
3340	2218	6006	extractedFrom	2022-03-08 18:30:32.804142
3341	1975	6007	extractedFrom	2022-03-08 18:30:33.02764
3342	1975	6008	extractedFrom	2022-03-08 18:30:33.218821
3343	1975	6009	extractedFrom	2022-03-08 18:30:34.012915
3344	1975	6009	extractedFrom	2022-03-08 18:30:34.078379
3345	2501	6010	extractedFrom	2022-03-08 18:30:34.502324
3346	2501	6011	extractedFrom	2022-03-08 18:30:34.619323
3347	2501	6012	extractedFrom	2022-03-08 18:30:34.76123
3348	2501	6013	extractedFrom	2022-03-08 18:30:34.899339
3349	2501	6014	extractedFrom	2022-03-08 18:30:35.358234
3350	2501	6015	extractedFrom	2022-03-08 18:30:35.60831
3351	2501	6016	extractedFrom	2022-03-08 18:30:35.933251
3352	2501	6017	extractedFrom	2022-03-08 18:30:36.048558
3353	2501	6018	extractedFrom	2022-03-08 18:30:36.157951
3354	2501	6019	extractedFrom	2022-03-08 18:30:36.345483
3355	2501	6020	extractedFrom	2022-03-08 18:30:36.44535
3356	2501	6021	extractedFrom	2022-03-08 18:30:36.639373
3357	2501	6022	extractedFrom	2022-03-08 18:30:36.771371
3358	2501	6022	extractedFrom	2022-03-08 18:30:36.840961
3359	1936	6023	extractedFrom	2022-03-08 18:30:36.981239
3360	1936	6023	extractedFrom	2022-03-08 18:30:37.049944
3361	2598	6024	extractedFrom	2022-03-08 18:30:37.197604
3362	2598	6025	extractedFrom	2022-03-08 18:30:37.501666
3363	2598	6026	extractedFrom	2022-03-08 18:30:37.809691
3364	2598	6026	extractedFrom	2022-03-08 18:30:37.860482
3365	3093	6027	extractedFrom	2022-03-08 18:30:38.114427
3366	3093	6027	extractedFrom	2022-03-08 18:30:38.183881
3367	1649	6028	extractedFrom	2022-03-08 18:30:38.274541
3368	1649	6028	extractedFrom	2022-03-08 18:30:38.329325
3369	3107	6029	extractedFrom	2022-03-08 18:30:38.562356
3370	3107	6030	extractedFrom	2022-03-08 18:30:38.692029
3371	3107	6031	extractedFrom	2022-03-08 18:30:38.799716
3372	3107	6032	extractedFrom	2022-03-08 18:30:39.049963
3373	3107	6032	extractedFrom	2022-03-08 18:30:39.11202
3374	2001	6033	extractedFrom	2022-03-08 18:30:39.21913
3375	2001	6033	extractedFrom	2022-03-08 18:30:39.292785
3376	2542	6034	extractedFrom	2022-03-08 18:30:39.379648
3377	2542	6035	extractedFrom	2022-03-08 18:30:39.496392
3378	2542	6036	extractedFrom	2022-03-08 18:30:39.78756
3379	2542	6037	extractedFrom	2022-03-08 18:30:40.007895
3380	2542	6038	extractedFrom	2022-03-08 18:30:40.127131
3381	2542	6038	extractedFrom	2022-03-08 18:30:40.212184
3382	2009	6039	extractedFrom	2022-03-08 18:30:40.563591
3383	2009	6039	extractedFrom	2022-03-08 18:30:40.684663
3384	3585	6040	extractedFrom	2022-03-08 18:30:40.814009
3385	3585	6040	extractedFrom	2022-03-08 18:30:40.894886
3386	1951	6041	extractedFrom	2022-03-08 18:30:41.246545
3387	1951	6041	extractedFrom	2022-03-08 18:30:41.402537
3388	3183	6042	extractedFrom	2022-03-08 18:30:41.663185
3389	3183	6043	extractedFrom	2022-03-08 18:30:41.778607
3390	3183	6044	extractedFrom	2022-03-08 18:30:41.973768
3391	3183	6045	extractedFrom	2022-03-08 18:30:42.121972
3392	3183	6046	extractedFrom	2022-03-08 18:30:42.322059
3393	3183	6046	extractedFrom	2022-03-08 18:30:42.390982
3394	2770	6047	extractedFrom	2022-03-08 18:30:42.547645
3395	2770	6048	extractedFrom	2022-03-08 18:30:42.779238
3396	2770	6048	extractedFrom	2022-03-08 18:30:42.840342
3397	3197	6049	extractedFrom	2022-03-08 18:30:42.942846
3398	3197	6050	extractedFrom	2022-03-08 18:30:43.191825
3399	3197	6051	extractedFrom	2022-03-08 18:30:43.296501
3400	3197	6052	extractedFrom	2022-03-08 18:30:43.392612
3401	3197	6053	extractedFrom	2022-03-08 18:30:43.584476
3402	3197	6054	extractedFrom	2022-03-08 18:30:43.716461
3403	3197	6055	extractedFrom	2022-03-08 18:30:43.86245
3404	3197	6056	extractedFrom	2022-03-08 18:30:44.051129
3405	3197	6056	extractedFrom	2022-03-08 18:30:44.246171
3406	2479	6057	extractedFrom	2022-03-08 18:30:44.364178
3407	2479	6057	extractedFrom	2022-03-08 18:30:44.442325
3408	3143	6058	extractedFrom	2022-03-08 18:30:44.801018
3409	3143	6058	extractedFrom	2022-03-08 18:30:45.043637
3410	2181	6059	extractedFrom	2022-03-08 18:30:45.202215
3411	2181	6059	extractedFrom	2022-03-08 18:30:45.330433
3412	2811	6060	extractedFrom	2022-03-08 18:30:45.453464
3413	2811	6060	extractedFrom	2022-03-08 18:30:45.573374
3414	3591	6061	extractedFrom	2022-03-08 18:30:45.678992
3415	3591	6061	extractedFrom	2022-03-08 18:30:45.76555
3416	2923	6062	extractedFrom	2022-03-08 18:30:45.912874
3417	2923	6062	extractedFrom	2022-03-08 18:30:45.990999
3418	1787	6063	extractedFrom	2022-03-08 18:30:46.088608
3419	1787	6063	extractedFrom	2022-03-08 18:30:46.154368
3420	1855	6064	extractedFrom	2022-03-08 18:30:46.462219
3421	1855	6064	extractedFrom	2022-03-08 18:30:46.615199
3422	2700	6065	extractedFrom	2022-03-08 18:30:46.728603
3423	2700	6065	extractedFrom	2022-03-08 18:30:46.933822
3424	1944	6066	extractedFrom	2022-03-08 18:30:47.054495
3425	1944	6067	extractedFrom	2022-03-08 18:30:47.30469
3426	1944	6068	extractedFrom	2022-03-08 18:30:47.426465
3427	1944	6068	extractedFrom	2022-03-08 18:30:47.56527
3428	3154	6069	extractedFrom	2022-03-08 18:30:47.690024
3429	3154	6070	extractedFrom	2022-03-08 18:30:47.814925
3430	3154	6070	extractedFrom	2022-03-08 18:30:47.903692
3431	3505	6071	extractedFrom	2022-03-08 18:30:48.070152
3432	3505	6072	extractedFrom	2022-03-08 18:30:48.2343
3433	3505	6072	extractedFrom	2022-03-08 18:30:48.296727
3434	2862	6073	extractedFrom	2022-03-08 18:30:48.41311
3435	2862	6073	extractedFrom	2022-03-08 18:30:48.465359
3436	2382	6074	extractedFrom	2022-03-08 18:30:48.739597
3437	2382	6075	extractedFrom	2022-03-08 18:30:48.872589
3438	2382	6075	extractedFrom	2022-03-08 18:30:48.950808
3439	3272	6076	extractedFrom	2022-03-08 18:30:49.104521
3440	3272	6076	extractedFrom	2022-03-08 18:30:49.168433
3441	1702	6077	extractedFrom	2022-03-08 18:30:49.26579
3442	1702	6078	extractedFrom	2022-03-08 18:30:49.415897
3443	1702	6078	extractedFrom	2022-03-08 18:30:49.567466
3444	2819	6079	extractedFrom	2022-03-08 18:30:49.867725
3445	2819	6079	extractedFrom	2022-03-08 18:30:49.943399
3446	1842	6080	extractedFrom	2022-03-08 18:30:50.347705
3447	1842	6081	extractedFrom	2022-03-08 18:30:50.572523
3448	1842	6082	extractedFrom	2022-03-08 18:30:50.68182
3449	1842	6082	extractedFrom	2022-03-08 18:30:50.923554
3450	2683	6083	extractedFrom	2022-03-08 18:30:51.127737
3451	2683	6083	extractedFrom	2022-03-08 18:30:51.223203
3452	2254	6084	extractedFrom	2022-03-08 18:30:51.312691
3453	2254	6084	extractedFrom	2022-03-08 18:30:51.583614
3454	1926	6085	extractedFrom	2022-03-08 18:30:51.822098
3455	1926	6086	extractedFrom	2022-03-08 18:30:51.958057
3456	1926	6087	extractedFrom	2022-03-08 18:30:52.190424
3457	1926	6088	extractedFrom	2022-03-08 18:30:52.355177
3458	1926	6089	extractedFrom	2022-03-08 18:30:52.496414
3459	1926	6089	extractedFrom	2022-03-08 18:30:52.688883
3460	1640	6090	extractedFrom	2022-03-08 18:30:52.858352
3461	1640	6090	extractedFrom	2022-03-08 18:30:52.944728
3462	3597	6091	extractedFrom	2022-03-08 18:30:53.138725
3463	3597	6091	extractedFrom	2022-03-08 18:30:53.199659
3464	3657	6092	extractedFrom	2022-03-08 18:30:53.296989
3465	3657	6092	extractedFrom	2022-03-08 18:30:53.602131
3466	2978	6093	extractedFrom	2022-03-08 18:30:53.753015
3467	2978	6093	extractedFrom	2022-03-08 18:30:54.050108
3468	2994	6094	extractedFrom	2022-03-08 18:30:54.253731
3469	2994	6095	extractedFrom	2022-03-08 18:30:54.446509
3470	2994	6096	extractedFrom	2022-03-08 18:30:54.596209
3471	2994	6097	extractedFrom	2022-03-08 18:30:54.721195
3472	2994	6097	extractedFrom	2022-03-08 18:30:54.776668
3473	1601	6098	extractedFrom	2022-03-08 18:30:55.04812
3474	1601	6098	extractedFrom	2022-03-08 18:30:55.136605
3475	3610	6099	extractedFrom	2022-03-08 18:30:55.267524
3476	3610	6099	extractedFrom	2022-03-08 18:30:55.335824
3477	3103	6100	extractedFrom	2022-03-08 18:30:55.650607
3478	3103	6100	extractedFrom	2022-03-08 18:30:55.750111
3479	3623	6101	extractedFrom	2022-03-08 18:30:55.867598
3480	3623	6102	extractedFrom	2022-03-08 18:30:55.967425
3481	3623	6102	extractedFrom	2022-03-08 18:30:56.05661
3482	3408	6103	extractedFrom	2022-03-08 18:30:56.2414
3483	3408	6104	extractedFrom	2022-03-08 18:30:56.357913
3484	3408	6104	extractedFrom	2022-03-08 18:30:56.446907
3485	1901	6105	extractedFrom	2022-03-08 18:30:56.652485
3486	1901	6106	extractedFrom	2022-03-08 18:30:56.959658
3487	1901	6106	extractedFrom	2022-03-08 18:30:57.016903
3488	3128	6107	extractedFrom	2022-03-08 18:30:57.454032
3489	3128	6108	extractedFrom	2022-03-08 18:30:57.574665
3490	3128	6108	extractedFrom	2022-03-08 18:30:57.658746
3491	3310	6109	extractedFrom	2022-03-08 18:30:58.137442
3492	3310	6109	extractedFrom	2022-03-08 18:30:58.321104
3493	3495	6110	extractedFrom	2022-03-08 18:30:58.530394
3494	3495	6111	extractedFrom	2022-03-08 18:30:58.994477
3495	3495	6111	extractedFrom	2022-03-08 18:30:59.074777
3496	3126	6112	extractedFrom	2022-03-08 18:30:59.219781
3497	3126	6112	extractedFrom	2022-03-08 18:30:59.308307
3498	1847	6113	extractedFrom	2022-03-08 18:30:59.518068
3499	1847	6113	extractedFrom	2022-03-08 18:30:59.620326
3500	2168	6114	extractedFrom	2022-03-08 18:30:59.717874
3501	2168	6114	extractedFrom	2022-03-08 18:30:59.799864
3502	2668	6115	extractedFrom	2022-03-08 18:31:00.247574
3503	2668	6115	extractedFrom	2022-03-08 18:31:00.318557
3504	2132	6116	extractedFrom	2022-03-08 18:31:00.414088
3505	2132	6116	extractedFrom	2022-03-08 18:31:00.484899
3506	3551	6117	extractedFrom	2022-03-08 18:31:00.629514
3507	3551	6118	extractedFrom	2022-03-08 18:31:00.755653
3508	3551	6118	extractedFrom	2022-03-08 18:31:00.826981
3509	2619	6119	extractedFrom	2022-03-08 18:31:00.940002
3510	2619	6119	extractedFrom	2022-03-08 18:31:00.998654
3511	3007	6120	extractedFrom	2022-03-08 18:31:01.087498
3512	3007	6120	extractedFrom	2022-03-08 18:31:01.140977
3513	2438	6121	extractedFrom	2022-03-08 18:31:01.472622
3514	2438	6122	extractedFrom	2022-03-08 18:31:01.60936
3515	2438	6123	extractedFrom	2022-03-08 18:31:01.739713
3516	2438	6123	extractedFrom	2022-03-08 18:31:01.805083
3517	2230	6124	extractedFrom	2022-03-08 18:31:01.91533
3518	2230	6125	extractedFrom	2022-03-08 18:31:02.037317
3519	2230	6126	extractedFrom	2022-03-08 18:31:02.188508
3520	2230	6126	extractedFrom	2022-03-08 18:31:02.252537
3521	3176	6127	extractedFrom	2022-03-08 18:31:02.404804
3522	3176	6127	extractedFrom	2022-03-08 18:31:02.732019
3523	3593	6128	extractedFrom	2022-03-08 18:31:02.831273
3524	3593	6129	extractedFrom	2022-03-08 18:31:02.973012
3525	3593	6129	extractedFrom	2022-03-08 18:31:03.108343
3526	2835	6130	extractedFrom	2022-03-08 18:31:03.241364
3527	2835	6130	extractedFrom	2022-03-08 18:31:03.326929
3528	2281	6131	extractedFrom	2022-03-08 18:31:03.551007
3529	2281	6131	extractedFrom	2022-03-08 18:31:03.607494
3530	1959	6132	extractedFrom	2022-03-08 18:31:03.938952
3531	1959	6133	extractedFrom	2022-03-08 18:31:04.057557
3532	1959	6134	extractedFrom	2022-03-08 18:31:04.289396
3533	1959	6135	extractedFrom	2022-03-08 18:31:04.5012
3534	1959	6135	extractedFrom	2022-03-08 18:31:04.552496
3535	3382	6136	extractedFrom	2022-03-08 18:31:04.748267
3536	3382	6137	extractedFrom	2022-03-08 18:31:05.013046
3537	3382	6137	extractedFrom	2022-03-08 18:31:05.226945
3538	2931	6138	extractedFrom	2022-03-08 18:31:05.379628
3539	2931	6138	extractedFrom	2022-03-08 18:31:05.472099
3540	2444	6139	extractedFrom	2022-03-08 18:31:05.803716
3541	2444	6140	extractedFrom	2022-03-08 18:31:05.933564
3542	2444	6141	extractedFrom	2022-03-08 18:31:06.167325
3543	2444	6142	extractedFrom	2022-03-08 18:31:06.309062
3544	2444	6143	extractedFrom	2022-03-08 18:31:06.409194
3545	2444	6144	extractedFrom	2022-03-08 18:31:06.509316
3546	2444	6144	extractedFrom	2022-03-08 18:31:06.680522
3547	3301	6145	extractedFrom	2022-03-08 18:31:06.803262
3548	3301	6145	extractedFrom	2022-03-08 18:31:06.888629
3549	3632	6146	extractedFrom	2022-03-08 18:31:06.977471
3550	3632	6147	extractedFrom	2022-03-08 18:31:07.086462
3551	3632	6147	extractedFrom	2022-03-08 18:31:07.138794
3552	2308	6148	extractedFrom	2022-03-08 18:31:07.245231
3553	2308	6149	extractedFrom	2022-03-08 18:31:07.335014
3554	2308	6150	extractedFrom	2022-03-08 18:31:07.520037
3555	2308	6150	extractedFrom	2022-03-08 18:31:07.572297
3556	3289	6151	extractedFrom	2022-03-08 18:31:07.686749
3557	3289	6151	extractedFrom	2022-03-08 18:31:07.73971
3558	2647	6152	extractedFrom	2022-03-08 18:31:07.819811
3559	2647	6152	extractedFrom	2022-03-08 18:31:07.872579
3560	3296	6153	extractedFrom	2022-03-08 18:31:08.145635
3561	3296	6153	extractedFrom	2022-03-08 18:31:08.198069
3562	3177	6154	extractedFrom	2022-03-08 18:31:08.31192
3563	3177	6155	extractedFrom	2022-03-08 18:31:08.617075
3564	3177	6155	extractedFrom	2022-03-08 18:31:08.675274
3565	1631	6156	extractedFrom	2022-03-08 18:31:08.820762
3566	1631	6156	extractedFrom	2022-03-08 18:31:09.17932
3567	1933	6157	extractedFrom	2022-03-08 18:31:09.36882
3568	1933	6157	extractedFrom	2022-03-08 18:31:09.430575
3569	1719	6158	extractedFrom	2022-03-08 18:31:09.536304
3570	1719	6158	extractedFrom	2022-03-08 18:31:09.589386
3571	1615	6159	extractedFrom	2022-03-08 18:31:09.690788
3572	1615	6159	extractedFrom	2022-03-08 18:31:09.858173
3573	3326	6160	extractedFrom	2022-03-08 18:31:09.99728
3574	3326	6160	extractedFrom	2022-03-08 18:31:10.167582
3575	2106	6161	extractedFrom	2022-03-08 18:31:10.459062
3576	2106	6161	extractedFrom	2022-03-08 18:31:10.667101
3577	3435	6162	extractedFrom	2022-03-08 18:31:10.894557
3578	3435	6162	extractedFrom	2022-03-08 18:31:10.97273
3579	3025	6163	extractedFrom	2022-03-08 18:31:11.078208
3580	3025	6163	extractedFrom	2022-03-08 18:31:11.165984
3581	1995	6164	extractedFrom	2022-03-08 18:31:11.311934
3582	1995	6164	extractedFrom	2022-03-08 18:31:11.405636
3583	2269	6165	extractedFrom	2022-03-08 18:31:11.50307
3584	2269	6166	extractedFrom	2022-03-08 18:31:11.67826
3585	2269	6166	extractedFrom	2022-03-08 18:31:11.74701
3586	3445	6167	extractedFrom	2022-03-08 18:31:11.841792
3587	3445	6167	extractedFrom	2022-03-08 18:31:12.035816
3588	2378	6168	extractedFrom	2022-03-08 18:31:12.396685
3589	2378	6168	extractedFrom	2022-03-08 18:31:12.732027
3590	3572	6169	extractedFrom	2022-03-08 18:31:12.972603
3591	3572	6169	extractedFrom	2022-03-08 18:31:13.050042
3592	2623	6170	extractedFrom	2022-03-08 18:31:13.370316
3593	2623	6170	extractedFrom	2022-03-08 18:31:13.455409
3594	2368	6171	extractedFrom	2022-03-08 18:31:13.595577
3595	2368	6171	extractedFrom	2022-03-08 18:31:13.67259
3596	3638	6172	extractedFrom	2022-03-08 18:31:13.769612
3597	3638	6172	extractedFrom	2022-03-08 18:31:13.964896
3598	3511	6173	extractedFrom	2022-03-08 18:31:14.053958
3599	3511	6173	extractedFrom	2022-03-08 18:31:14.131287
3600	3366	6174	extractedFrom	2022-03-08 18:31:14.330624
3601	3366	6175	extractedFrom	2022-03-08 18:31:14.4894
3602	3366	6175	extractedFrom	2022-03-08 18:31:14.665529
3603	3226	6176	extractedFrom	2022-03-08 18:31:15.066978
3604	3226	6176	extractedFrom	2022-03-08 18:31:15.152052
3605	2746	6177	extractedFrom	2022-03-08 18:31:15.271832
3606	2746	6177	extractedFrom	2022-03-08 18:31:15.350109
3607	1546	6178	extractedFrom	2022-03-08 18:31:15.481017
3608	1546	6178	extractedFrom	2022-03-08 18:31:15.542407
3609	1865	6179	extractedFrom	2022-03-08 18:31:15.672642
3610	1865	6179	extractedFrom	2022-03-08 18:31:15.800406
3611	3066	6180	extractedFrom	2022-03-08 18:31:15.90632
3612	3066	6181	extractedFrom	2022-03-08 18:31:16.081648
3613	3066	6181	extractedFrom	2022-03-08 18:31:16.159619
3614	2400	6182	extractedFrom	2022-03-08 18:31:16.26581
3615	2400	6182	extractedFrom	2022-03-08 18:31:16.34281
3616	3004	6183	extractedFrom	2022-03-08 18:31:16.434073
3617	3004	6183	extractedFrom	2022-03-08 18:31:16.496353
3618	1715	6184	extractedFrom	2022-03-08 18:31:16.600809
3619	1715	6184	extractedFrom	2022-03-08 18:31:16.651627
3620	3336	6185	extractedFrom	2022-03-08 18:31:16.838214
3621	3336	6186	extractedFrom	2022-03-08 18:31:17.142395
3622	3336	6186	extractedFrom	2022-03-08 18:31:17.366703
3623	3587	6187	extractedFrom	2022-03-08 18:31:17.483014
3624	3587	6187	extractedFrom	2022-03-08 18:31:17.566139
3625	1980	6188	extractedFrom	2022-03-08 18:31:17.928737
3626	1980	6189	extractedFrom	2022-03-08 18:31:18.200795
3627	1980	6189	extractedFrom	2022-03-08 18:31:18.492224
3628	2171	6190	extractedFrom	2022-03-08 18:31:18.870439
3629	2171	6191	extractedFrom	2022-03-08 18:31:18.988917
3630	2171	6191	extractedFrom	2022-03-08 18:31:19.042046
3631	2435	6192	extractedFrom	2022-03-08 18:31:19.153697
3632	2435	6192	extractedFrom	2022-03-08 18:31:19.207021
3633	1887	6193	extractedFrom	2022-03-08 18:31:19.312656
3634	1887	6193	extractedFrom	2022-03-08 18:31:19.365522
3635	3184	6194	extractedFrom	2022-03-08 18:31:19.860165
3636	3184	6195	extractedFrom	2022-03-08 18:31:19.984463
3637	3184	6195	extractedFrom	2022-03-08 18:31:20.048527
3638	1628	6196	extractedFrom	2022-03-08 18:31:20.152355
3639	1628	6196	extractedFrom	2022-03-08 18:31:20.209143
3640	2116	6197	extractedFrom	2022-03-08 18:31:20.646916
3641	2116	6197	extractedFrom	2022-03-08 18:31:20.722017
3642	3010	6198	extractedFrom	2022-03-08 18:31:20.942356
3643	3010	6199	extractedFrom	2022-03-08 18:31:21.097035
3644	3010	6200	extractedFrom	2022-03-08 18:31:21.209339
3645	3010	6201	extractedFrom	2022-03-08 18:31:21.338785
3646	3010	6202	extractedFrom	2022-03-08 18:31:21.439427
3647	3010	6203	extractedFrom	2022-03-08 18:31:21.601383
3648	3010	6204	extractedFrom	2022-03-08 18:31:21.738786
3649	3010	6205	extractedFrom	2022-03-08 18:31:21.856275
3650	3010	6205	extractedFrom	2022-03-08 18:31:21.955231
3651	1843	6206	extractedFrom	2022-03-08 18:31:22.065632
3652	1843	6207	extractedFrom	2022-03-08 18:31:22.183028
3653	1843	6207	extractedFrom	2022-03-08 18:31:22.416614
3654	2205	6208	extractedFrom	2022-03-08 18:31:22.582697
3655	2205	6209	extractedFrom	2022-03-08 18:31:22.725739
3656	2205	6209	extractedFrom	2022-03-08 18:31:22.820437
3657	1733	6210	extractedFrom	2022-03-08 18:31:22.934031
3658	1733	6210	extractedFrom	2022-03-08 18:31:22.977494
3659	2088	6211	extractedFrom	2022-03-08 18:31:23.102462
3660	2088	6212	extractedFrom	2022-03-08 18:31:23.257936
3661	2088	6213	extractedFrom	2022-03-08 18:31:23.502901
3662	2088	6214	extractedFrom	2022-03-08 18:31:23.669603
3663	2088	6215	extractedFrom	2022-03-08 18:31:23.795295
3664	2088	6215	extractedFrom	2022-03-08 18:31:23.864149
3665	2696	6216	extractedFrom	2022-03-08 18:31:23.980493
3666	2696	6216	extractedFrom	2022-03-08 18:31:24.057692
3667	2499	6217	extractedFrom	2022-03-08 18:31:24.39568
3668	2499	6218	extractedFrom	2022-03-08 18:31:24.62875
3669	2499	6219	extractedFrom	2022-03-08 18:31:24.828376
3670	2499	6219	extractedFrom	2022-03-08 18:31:24.926785
3671	3663	6220	extractedFrom	2022-03-08 18:31:25.034716
3672	3663	6220	extractedFrom	2022-03-08 18:31:25.104868
3673	1822	6221	extractedFrom	2022-03-08 18:31:25.325366
3674	1822	6222	extractedFrom	2022-03-08 18:31:25.417116
3675	1822	6222	extractedFrom	2022-03-08 18:31:25.518735
3676	2198	6223	extractedFrom	2022-03-08 18:31:25.846702
3677	2198	6224	extractedFrom	2022-03-08 18:31:25.975612
3678	2198	6225	extractedFrom	2022-03-08 18:31:26.124987
3679	2198	6225	extractedFrom	2022-03-08 18:31:26.215539
3680	2637	6226	extractedFrom	2022-03-08 18:31:26.493142
3681	2637	6227	extractedFrom	2022-03-08 18:31:26.676014
3682	2637	6227	extractedFrom	2022-03-08 18:31:26.726066
3683	2443	6228	extractedFrom	2022-03-08 18:31:26.929864
3684	2443	6228	extractedFrom	2022-03-08 18:31:26.999696
3685	2976	6229	extractedFrom	2022-03-08 18:31:27.122171
3686	2976	6229	extractedFrom	2022-03-08 18:31:27.174971
3687	2809	6230	extractedFrom	2022-03-08 18:31:27.474254
3688	2809	6230	extractedFrom	2022-03-08 18:31:27.647088
3689	2035	6231	extractedFrom	2022-03-08 18:31:27.753629
3690	2035	6231	extractedFrom	2022-03-08 18:31:27.842781
3691	1610	6232	extractedFrom	2022-03-08 18:31:28.037229
3692	1610	6233	extractedFrom	2022-03-08 18:31:28.128852
3693	1610	6234	extractedFrom	2022-03-08 18:31:28.278987
3694	1610	6235	extractedFrom	2022-03-08 18:31:28.446581
3695	1610	6236	extractedFrom	2022-03-08 18:31:28.556199
3696	1610	6237	extractedFrom	2022-03-08 18:31:28.672584
3697	1610	6238	extractedFrom	2022-03-08 18:31:28.840935
3698	1610	6238	extractedFrom	2022-03-08 18:31:28.967809
3699	3288	6239	extractedFrom	2022-03-08 18:31:29.09851
3700	3288	6239	extractedFrom	2022-03-08 18:31:29.176179
3701	1708	6240	extractedFrom	2022-03-08 18:31:29.365592
3702	1708	6241	extractedFrom	2022-03-08 18:31:29.591057
3703	1708	6242	extractedFrom	2022-03-08 18:31:29.850081
3704	1708	6243	extractedFrom	2022-03-08 18:31:29.963543
3705	1708	6243	extractedFrom	2022-03-08 18:31:30.274904
3706	2318	6244	extractedFrom	2022-03-08 18:31:30.493066
3707	2318	6244	extractedFrom	2022-03-08 18:31:30.547057
3708	2649	6245	extractedFrom	2022-03-08 18:31:30.896463
3709	2649	6246	extractedFrom	2022-03-08 18:31:31.016281
3710	2649	6246	extractedFrom	2022-03-08 18:31:31.230167
3711	3603	6247	extractedFrom	2022-03-08 18:31:31.336758
3712	3603	6248	extractedFrom	2022-03-08 18:31:31.436516
3713	3603	6249	extractedFrom	2022-03-08 18:31:31.578859
3714	3603	6250	extractedFrom	2022-03-08 18:31:31.778586
3715	3603	6250	extractedFrom	2022-03-08 18:31:31.882998
3716	2630	6251	extractedFrom	2022-03-08 18:31:32.005573
3717	2630	6252	extractedFrom	2022-03-08 18:31:32.34773
3718	2630	6252	extractedFrom	2022-03-08 18:31:32.508181
3719	2215	6253	extractedFrom	2022-03-08 18:31:32.721361
3720	2215	6254	extractedFrom	2022-03-08 18:31:32.862859
3721	2215	6254	extractedFrom	2022-03-08 18:31:32.9582
3722	2204	6255	extractedFrom	2022-03-08 18:31:33.087749
3723	2204	6256	extractedFrom	2022-03-08 18:31:33.485521
3724	2204	6256	extractedFrom	2022-03-08 18:31:33.671634
3725	2071	6257	extractedFrom	2022-03-08 18:31:33.790067
3726	2071	6257	extractedFrom	2022-03-08 18:31:33.867301
3727	2398	6258	extractedFrom	2022-03-08 18:31:33.960802
3728	2398	6258	extractedFrom	2022-03-08 18:31:34.025669
3729	1542	6259	extractedFrom	2022-03-08 18:31:34.240151
3730	1542	6259	extractedFrom	2022-03-08 18:31:34.308139
3731	2012	6260	extractedFrom	2022-03-08 18:31:34.396793
3732	2012	6260	extractedFrom	2022-03-08 18:31:34.465389
3733	3685	6261	extractedFrom	2022-03-08 18:31:34.627849
3734	3685	6262	extractedFrom	2022-03-08 18:31:34.822803
3735	3685	6262	extractedFrom	2022-03-08 18:31:35.11756
3736	1946	6263	extractedFrom	2022-03-08 18:31:35.244507
3737	1946	6264	extractedFrom	2022-03-08 18:31:35.443478
3738	1946	6265	extractedFrom	2022-03-08 18:31:35.601124
3739	1946	6266	extractedFrom	2022-03-08 18:31:35.727293
3740	1946	6266	extractedFrom	2022-03-08 18:31:35.782915
3741	1554	6267	extractedFrom	2022-03-08 18:31:35.879173
3742	1554	6268	extractedFrom	2022-03-08 18:31:36.012007
3743	1554	6268	extractedFrom	2022-03-08 18:31:36.075325
3744	2432	6269	extractedFrom	2022-03-08 18:31:36.195136
3745	2432	6269	extractedFrom	2022-03-08 18:31:36.373269
3746	3005	6270	extractedFrom	2022-03-08 18:31:36.496182
3747	3005	6270	extractedFrom	2022-03-08 18:31:36.552436
3748	3549	6271	extractedFrom	2022-03-08 18:31:36.645889
3749	3549	6271	extractedFrom	2022-03-08 18:31:36.702442
3750	3265	6272	extractedFrom	2022-03-08 18:31:36.923997
3751	3265	6273	extractedFrom	2022-03-08 18:31:37.178727
3752	3265	6274	extractedFrom	2022-03-08 18:31:37.278814
3753	3265	6275	extractedFrom	2022-03-08 18:31:37.395301
3754	3265	6276	extractedFrom	2022-03-08 18:31:37.504845
3755	3265	6277	extractedFrom	2022-03-08 18:31:37.678834
3756	3265	6278	extractedFrom	2022-03-08 18:31:37.93757
3757	3265	6278	extractedFrom	2022-03-08 18:31:38.099391
3758	3003	6279	extractedFrom	2022-03-08 18:31:38.339569
3759	3003	6280	extractedFrom	2022-03-08 18:31:38.456283
3760	3003	6280	extractedFrom	2022-03-08 18:31:38.50956
3761	2855	6281	extractedFrom	2022-03-08 18:31:38.980685
3762	2855	6282	extractedFrom	2022-03-08 18:31:39.125106
3763	2855	6283	extractedFrom	2022-03-08 18:31:39.216405
3764	2855	6283	extractedFrom	2022-03-08 18:31:39.269839
3765	2796	6284	extractedFrom	2022-03-08 18:31:39.476842
3766	2796	6285	extractedFrom	2022-03-08 18:31:39.593968
3767	2796	6286	extractedFrom	2022-03-08 18:31:39.69297
3768	2796	6287	extractedFrom	2022-03-08 18:31:39.87664
3769	2796	6288	extractedFrom	2022-03-08 18:31:40.006886
3770	2796	6288	extractedFrom	2022-03-08 18:31:40.112876
3771	2766	6289	extractedFrom	2022-03-08 18:31:40.369051
3772	2766	6289	extractedFrom	2022-03-08 18:31:40.420928
3773	2962	6290	extractedFrom	2022-03-08 18:31:40.516168
3774	2962	6290	extractedFrom	2022-03-08 18:31:40.57239
3775	2641	6291	extractedFrom	2022-03-08 18:31:40.816413
3776	2641	6291	extractedFrom	2022-03-08 18:31:40.887803
3777	3646	6292	extractedFrom	2022-03-08 18:31:41.003823
3778	3646	6292	extractedFrom	2022-03-08 18:31:41.059987
3779	3112	6293	extractedFrom	2022-03-08 18:31:41.289375
3780	3112	6293	extractedFrom	2022-03-08 18:31:41.348539
3781	2129	6294	extractedFrom	2022-03-08 18:31:41.447847
3782	2129	6295	extractedFrom	2022-03-08 18:31:41.689703
3783	2129	6295	extractedFrom	2022-03-08 18:31:41.748727
3784	2407	6296	extractedFrom	2022-03-08 18:31:42.012207
3785	2407	6296	extractedFrom	2022-03-08 18:31:42.152598
3786	2897	6297	extractedFrom	2022-03-08 18:31:42.347085
3787	2897	6298	extractedFrom	2022-03-08 18:31:42.477689
3788	2897	6298	extractedFrom	2022-03-08 18:31:42.530381
3789	3659	6299	extractedFrom	2022-03-08 18:31:42.754328
3790	3659	6299	extractedFrom	2022-03-08 18:31:42.824639
3791	1969	6300	extractedFrom	2022-03-08 18:31:42.912929
3792	1969	6300	extractedFrom	2022-03-08 18:31:42.966292
3793	2342	6301	extractedFrom	2022-03-08 18:31:43.10522
3794	2342	6302	extractedFrom	2022-03-08 18:31:43.289958
3795	2342	6302	extractedFrom	2022-03-08 18:31:43.421211
3796	3214	6303	extractedFrom	2022-03-08 18:31:43.723557
3797	3214	6304	extractedFrom	2022-03-08 18:31:43.912738
3798	3214	6304	extractedFrom	2022-03-08 18:31:44.246708
3799	1641	6305	extractedFrom	2022-03-08 18:31:44.407714
3800	1641	6305	extractedFrom	2022-03-08 18:31:44.513509
3801	1872	6306	extractedFrom	2022-03-08 18:31:44.652177
3802	1872	6306	extractedFrom	2022-03-08 18:31:44.721685
3803	2861	6307	extractedFrom	2022-03-08 18:31:44.860873
3804	2861	6307	extractedFrom	2022-03-08 18:31:45.176268
3805	2201	6308	extractedFrom	2022-03-08 18:31:45.401901
3806	2201	6308	extractedFrom	2022-03-08 18:31:45.591522
3807	3346	6309	extractedFrom	2022-03-08 18:31:45.76951
3808	3346	6309	extractedFrom	2022-03-08 18:31:45.864099
3809	2072	6310	extractedFrom	2022-03-08 18:31:46.00378
3810	2072	6310	extractedFrom	2022-03-08 18:31:46.067759
3811	3328	6311	extractedFrom	2022-03-08 18:31:46.171556
3812	3328	6311	extractedFrom	2022-03-08 18:31:46.222626
3813	3455	6312	extractedFrom	2022-03-08 18:31:46.437342
3814	3455	6313	extractedFrom	2022-03-08 18:31:46.547056
3815	3455	6313	extractedFrom	2022-03-08 18:31:46.600311
3816	1686	6314	extractedFrom	2022-03-08 18:31:46.712376
3817	1686	6314	extractedFrom	2022-03-08 18:31:46.92817
3818	2632	6315	extractedFrom	2022-03-08 18:31:47.126785
3819	2632	6316	extractedFrom	2022-03-08 18:31:47.435288
3820	2632	6317	extractedFrom	2022-03-08 18:31:47.642371
3821	2632	6318	extractedFrom	2022-03-08 18:31:47.775031
3822	2632	6319	extractedFrom	2022-03-08 18:31:48.076477
3823	2632	6320	extractedFrom	2022-03-08 18:31:48.19337
3824	2632	6320	extractedFrom	2022-03-08 18:31:48.263075
3825	2233	6321	extractedFrom	2022-03-08 18:31:48.353677
3826	2233	6321	extractedFrom	2022-03-08 18:31:48.415045
3827	2040	6322	extractedFrom	2022-03-08 18:31:48.503896
3828	2040	6322	extractedFrom	2022-03-08 18:31:48.556366
3829	3171	6323	extractedFrom	2022-03-08 18:31:48.664344
3830	3171	6323	extractedFrom	2022-03-08 18:31:48.72945
3831	2987	6324	extractedFrom	2022-03-08 18:31:48.893908
3832	2987	6324	extractedFrom	2022-03-08 18:31:48.970329
3833	2531	6325	extractedFrom	2022-03-08 18:31:49.13804
3834	2531	6326	extractedFrom	2022-03-08 18:31:49.343351
3835	2531	6326	extractedFrom	2022-03-08 18:31:49.430514
3836	1849	6327	extractedFrom	2022-03-08 18:31:49.58089
3837	1849	6328	extractedFrom	2022-03-08 18:31:49.768754
3838	1849	6329	extractedFrom	2022-03-08 18:31:49.944978
3839	1849	6330	extractedFrom	2022-03-08 18:31:50.158843
3840	1849	6330	extractedFrom	2022-03-08 18:31:50.422917
3841	3139	6331	extractedFrom	2022-03-08 18:31:50.514978
3842	3139	6331	extractedFrom	2022-03-08 18:31:50.576067
3843	3012	6332	extractedFrom	2022-03-08 18:31:50.664749
3844	3012	6333	extractedFrom	2022-03-08 18:31:50.864928
3845	3012	6334	extractedFrom	2022-03-08 18:31:50.972469
3846	3012	6334	extractedFrom	2022-03-08 18:31:51.042188
3847	3327	6335	extractedFrom	2022-03-08 18:31:51.113761
3848	3327	6335	extractedFrom	2022-03-08 18:31:51.210745
3849	2971	6336	extractedFrom	2022-03-08 18:31:51.604272
3850	2971	6337	extractedFrom	2022-03-08 18:31:51.807379
3851	2971	6338	extractedFrom	2022-03-08 18:31:51.96576
3852	2971	6338	extractedFrom	2022-03-08 18:31:52.039746
3853	1584	6339	extractedFrom	2022-03-08 18:31:52.184096
3854	1584	6340	extractedFrom	2022-03-08 18:31:52.287096
3855	1584	6341	extractedFrom	2022-03-08 18:31:52.395337
3856	1584	6341	extractedFrom	2022-03-08 18:31:52.519433
3857	1871	6342	extractedFrom	2022-03-08 18:31:52.6548
3858	1871	6343	extractedFrom	2022-03-08 18:31:52.782431
3859	1871	6343	extractedFrom	2022-03-08 18:31:52.847583
3860	2243	6344	extractedFrom	2022-03-08 18:31:53.018895
3861	2243	6344	extractedFrom	2022-03-08 18:31:53.093464
3862	3030	6345	extractedFrom	2022-03-08 18:31:53.22057
3863	3030	6345	extractedFrom	2022-03-08 18:31:53.276755
3864	2415	6346	extractedFrom	2022-03-08 18:31:53.388829
3865	2415	6347	extractedFrom	2022-03-08 18:31:53.488934
3866	2415	6347	extractedFrom	2022-03-08 18:31:53.542253
3867	2791	6348	extractedFrom	2022-03-08 18:31:53.942841
3868	2791	6349	extractedFrom	2022-03-08 18:31:54.164359
3869	2791	6349	extractedFrom	2022-03-08 18:31:54.253314
3870	3218	6350	extractedFrom	2022-03-08 18:31:54.389876
3871	3218	6351	extractedFrom	2022-03-08 18:31:54.515494
3872	3218	6351	extractedFrom	2022-03-08 18:31:54.602913
3873	2843	6352	extractedFrom	2022-03-08 18:31:54.857435
3874	2843	6352	extractedFrom	2022-03-08 18:31:54.911932
3875	1579	6353	extractedFrom	2022-03-08 18:31:55.115168
3876	1579	6353	extractedFrom	2022-03-08 18:31:55.188951
3877	2603	6354	extractedFrom	2022-03-08 18:31:55.614355
3878	2603	6354	extractedFrom	2022-03-08 18:31:55.673692
3879	2602	6355	extractedFrom	2022-03-08 18:31:55.797035
3880	2602	6355	extractedFrom	2022-03-08 18:31:56.024422
3881	2340	6356	extractedFrom	2022-03-08 18:31:56.203623
3882	2340	6356	extractedFrom	2022-03-08 18:31:56.267297
3883	2713	6357	extractedFrom	2022-03-08 18:31:56.42048
3884	2713	6357	extractedFrom	2022-03-08 18:31:56.52379
3885	2678	6358	extractedFrom	2022-03-08 18:31:56.662297
3886	2678	6358	extractedFrom	2022-03-08 18:31:56.753461
3887	2850	6359	extractedFrom	2022-03-08 18:31:56.980571
3888	2850	6360	extractedFrom	2022-03-08 18:31:57.165362
3889	2850	6360	extractedFrom	2022-03-08 18:31:57.238095
3890	2453	6361	extractedFrom	2022-03-08 18:31:57.331664
3891	2453	6361	extractedFrom	2022-03-08 18:31:57.393953
3892	1813	6362	extractedFrom	2022-03-08 18:31:57.874028
3893	1813	6362	extractedFrom	2022-03-08 18:31:57.98542
3894	3473	6363	extractedFrom	2022-03-08 18:31:58.166202
3895	3473	6363	extractedFrom	2022-03-08 18:31:58.244246
3896	2882	6364	extractedFrom	2022-03-08 18:31:58.501088
3897	2882	6364	extractedFrom	2022-03-08 18:31:58.572878
3898	2004	6365	extractedFrom	2022-03-08 18:31:58.693079
3899	2004	6366	extractedFrom	2022-03-08 18:31:58.792832
3900	2004	6367	extractedFrom	2022-03-08 18:31:58.892942
3901	2004	6368	extractedFrom	2022-03-08 18:31:59.147108
3902	2004	6368	extractedFrom	2022-03-08 18:31:59.219837
3903	2810	6369	extractedFrom	2022-03-08 18:31:59.61178
3904	2810	6369	extractedFrom	2022-03-08 18:31:59.832434
3905	1954	6370	extractedFrom	2022-03-08 18:31:59.955622
3906	1954	6371	extractedFrom	2022-03-08 18:32:00.186944
3907	1954	6371	extractedFrom	2022-03-08 18:32:00.246504
3908	2988	6372	extractedFrom	2022-03-08 18:32:01.585177
3909	2988	6372	extractedFrom	2022-03-08 18:32:01.643374
3910	2496	6373	extractedFrom	2022-03-08 18:32:01.805401
3911	2496	6374	extractedFrom	2022-03-08 18:32:01.905397
3912	2496	6374	extractedFrom	2022-03-08 18:32:01.963711
3913	2328	6375	extractedFrom	2022-03-08 18:32:02.078625
3914	2328	6376	extractedFrom	2022-03-08 18:32:02.321352
3915	2328	6377	extractedFrom	2022-03-08 18:32:02.484684
3916	2328	6378	extractedFrom	2022-03-08 18:32:02.620524
3917	2328	6379	extractedFrom	2022-03-08 18:32:02.726635
3918	2328	6380	extractedFrom	2022-03-08 18:32:02.843499
3919	2328	6381	extractedFrom	2022-03-08 18:32:03.02937
3920	2328	6381	extractedFrom	2022-03-08 18:32:03.239998
3921	3147	6382	extractedFrom	2022-03-08 18:32:03.556983
3922	3147	6383	extractedFrom	2022-03-08 18:32:03.896815
3923	3147	6383	extractedFrom	2022-03-08 18:32:04.114
3924	2866	6384	extractedFrom	2022-03-08 18:32:04.232429
3925	2866	6384	extractedFrom	2022-03-08 18:32:04.285889
3926	3078	6385	extractedFrom	2022-03-08 18:32:04.575344
3927	3078	6386	extractedFrom	2022-03-08 18:32:04.733733
3928	3078	6386	extractedFrom	2022-03-08 18:32:04.922771
3929	2832	6387	extractedFrom	2022-03-08 18:32:05.070085
3930	2832	6388	extractedFrom	2022-03-08 18:32:05.168959
3931	2832	6388	extractedFrom	2022-03-08 18:32:05.247177
3932	2797	6389	extractedFrom	2022-03-08 18:32:05.800525
3933	2797	6389	extractedFrom	2022-03-08 18:32:05.982124
3934	3454	6390	extractedFrom	2022-03-08 18:32:06.195241
3935	3454	6391	extractedFrom	2022-03-08 18:32:06.366992
3936	3454	6391	extractedFrom	2022-03-08 18:32:06.420487
3937	3529	6392	extractedFrom	2022-03-08 18:32:06.552086
3938	3529	6392	extractedFrom	2022-03-08 18:32:06.607134
3939	1667	6393	extractedFrom	2022-03-08 18:32:06.852508
3940	1667	6393	extractedFrom	2022-03-08 18:32:06.922674
3941	2353	6394	extractedFrom	2022-03-08 18:32:07.115356
3942	2353	6394	extractedFrom	2022-03-08 18:32:07.262452
3943	2559	6395	extractedFrom	2022-03-08 18:32:07.416876
3944	2559	6395	extractedFrom	2022-03-08 18:32:07.475268
3945	2268	6396	extractedFrom	2022-03-08 18:32:07.603211
3946	2268	6396	extractedFrom	2022-03-08 18:32:07.748146
3947	2847	6397	extractedFrom	2022-03-08 18:32:07.837256
3948	2847	6397	extractedFrom	2022-03-08 18:32:07.89023
3949	3566	6398	extractedFrom	2022-03-08 18:32:07.970695
3950	3566	6398	extractedFrom	2022-03-08 18:32:08.04011
3951	2324	6399	extractedFrom	2022-03-08 18:32:08.221411
3952	2324	6400	extractedFrom	2022-03-08 18:32:08.430939
3953	2324	6400	extractedFrom	2022-03-08 18:32:08.483603
3954	3053	6401	extractedFrom	2022-03-08 18:32:08.757303
3955	3053	6402	extractedFrom	2022-03-08 18:32:08.917865
3956	3053	6403	extractedFrom	2022-03-08 18:32:09.092956
3957	3053	6403	extractedFrom	2022-03-08 18:32:09.154249
3958	2429	6404	extractedFrom	2022-03-08 18:32:09.340024
3959	2429	6405	extractedFrom	2022-03-08 18:32:09.446826
3960	2429	6406	extractedFrom	2022-03-08 18:32:09.545126
3961	2429	6407	extractedFrom	2022-03-08 18:32:09.939159
3962	2429	6408	extractedFrom	2022-03-08 18:32:10.107579
3963	2429	6408	extractedFrom	2022-03-08 18:32:10.185134
3964	2299	6409	extractedFrom	2022-03-08 18:32:10.282767
3965	2299	6410	extractedFrom	2022-03-08 18:32:10.424761
3966	2299	6410	extractedFrom	2022-03-08 18:32:10.50264
3967	2991	6411	extractedFrom	2022-03-08 18:32:10.765813
3968	2991	6411	extractedFrom	2022-03-08 18:32:10.82878
3969	2731	6412	extractedFrom	2022-03-08 18:32:10.936895
3970	2731	6412	extractedFrom	2022-03-08 18:32:11.145561
3971	3291	6413	extractedFrom	2022-03-08 18:32:11.254872
3972	3291	6414	extractedFrom	2022-03-08 18:32:11.496688
3973	3291	6415	extractedFrom	2022-03-08 18:32:11.834229
3974	3291	6415	extractedFrom	2022-03-08 18:32:12.011366
3975	2917	6416	extractedFrom	2022-03-08 18:32:12.308175
3976	2917	6417	extractedFrom	2022-03-08 18:32:12.451923
3977	2917	6418	extractedFrom	2022-03-08 18:32:12.572678
3978	2917	6419	extractedFrom	2022-03-08 18:32:12.75575
3979	2917	6420	extractedFrom	2022-03-08 18:32:12.876152
3980	2917	6421	extractedFrom	2022-03-08 18:32:13.213617
3981	2917	6422	extractedFrom	2022-03-08 18:32:13.329708
3982	2917	6422	extractedFrom	2022-03-08 18:32:13.413699
3983	3341	6423	extractedFrom	2022-03-08 18:32:13.54755
3984	3341	6423	extractedFrom	2022-03-08 18:32:13.655204
3985	2362	6424	extractedFrom	2022-03-08 18:32:13.782158
3986	2362	6424	extractedFrom	2022-03-08 18:32:13.834125
3987	2553	6425	extractedFrom	2022-03-08 18:32:13.934246
3988	2553	6426	extractedFrom	2022-03-08 18:32:14.39395
3989	2553	6426	extractedFrom	2022-03-08 18:32:14.540898
3990	3286	6427	extractedFrom	2022-03-08 18:32:14.919869
3991	3286	6428	extractedFrom	2022-03-08 18:32:15.03472
3992	3286	6429	extractedFrom	2022-03-08 18:32:15.464024
3993	3286	6430	extractedFrom	2022-03-08 18:32:15.715832
3994	3286	6430	extractedFrom	2022-03-08 18:32:15.798654
3995	2156	6431	extractedFrom	2022-03-08 18:32:16.054047
3996	2156	6431	extractedFrom	2022-03-08 18:32:16.285873
3997	2859	6432	extractedFrom	2022-03-08 18:32:16.456375
3998	2859	6432	extractedFrom	2022-03-08 18:32:16.532797
3999	3119	6433	extractedFrom	2022-03-08 18:32:16.656577
4000	3119	6433	extractedFrom	2022-03-08 18:32:16.844418
4001	3617	6434	extractedFrom	2022-03-08 18:32:16.955528
4002	3617	6434	extractedFrom	2022-03-08 18:32:17.029869
4003	2889	6435	extractedFrom	2022-03-08 18:32:17.24633
4004	2889	6436	extractedFrom	2022-03-08 18:32:17.388038
4005	2889	6436	extractedFrom	2022-03-08 18:32:17.448571
4006	3634	6437	extractedFrom	2022-03-08 18:32:17.528829
4007	3634	6437	extractedFrom	2022-03-08 18:32:17.735896
4008	2719	6438	extractedFrom	2022-03-08 18:32:18.076277
4009	2719	6438	extractedFrom	2022-03-08 18:32:18.298749
4010	3458	6439	extractedFrom	2022-03-08 18:32:18.430461
4011	3458	6439	extractedFrom	2022-03-08 18:32:18.695116
4012	3443	6440	extractedFrom	2022-03-08 18:32:18.883791
4013	3443	6441	extractedFrom	2022-03-08 18:32:19.18973
4014	3443	6441	extractedFrom	2022-03-08 18:32:19.253807
4015	1722	6442	extractedFrom	2022-03-08 18:32:19.396123
4016	1722	6442	extractedFrom	2022-03-08 18:32:19.475737
4017	2577	6443	extractedFrom	2022-03-08 18:32:19.707224
4018	2577	6444	extractedFrom	2022-03-08 18:32:19.913682
4019	2577	6444	extractedFrom	2022-03-08 18:32:19.996814
4020	1706	6445	extractedFrom	2022-03-08 18:32:20.121351
4021	1706	6445	extractedFrom	2022-03-08 18:32:20.284313
4022	2021	6446	extractedFrom	2022-03-08 18:32:20.421354
4023	2021	6447	extractedFrom	2022-03-08 18:32:20.538052
4024	2021	6448	extractedFrom	2022-03-08 18:32:20.87042
4025	2021	6448	extractedFrom	2022-03-08 18:32:20.944291
4026	2341	6449	extractedFrom	2022-03-08 18:32:21.122238
4027	2341	6449	extractedFrom	2022-03-08 18:32:21.202241
4028	2627	6450	extractedFrom	2022-03-08 18:32:21.311723
4029	2627	6450	extractedFrom	2022-03-08 18:32:21.410999
4030	3276	6451	extractedFrom	2022-03-08 18:32:21.537849
4031	3276	6451	extractedFrom	2022-03-08 18:32:21.640212
4032	1914	6452	extractedFrom	2022-03-08 18:32:21.74252
4033	1914	6453	extractedFrom	2022-03-08 18:32:21.880429
4034	1914	6454	extractedFrom	2022-03-08 18:32:21.99702
4035	1914	6454	extractedFrom	2022-03-08 18:32:22.263704
4036	3268	6455	extractedFrom	2022-03-08 18:32:22.485517
4037	3268	6455	extractedFrom	2022-03-08 18:32:22.543958
4038	2015	6456	extractedFrom	2022-03-08 18:32:22.967744
4039	2015	6456	extractedFrom	2022-03-08 18:32:23.037661
4040	2221	6457	extractedFrom	2022-03-08 18:32:23.15131
4041	2221	6458	extractedFrom	2022-03-08 18:32:23.240901
4042	2221	6459	extractedFrom	2022-03-08 18:32:23.350359
4043	2221	6459	extractedFrom	2022-03-08 18:32:23.419909
4044	3677	6460	extractedFrom	2022-03-08 18:32:23.768053
4045	3677	6460	extractedFrom	2022-03-08 18:32:23.887831
4046	1627	6461	extractedFrom	2022-03-08 18:32:24.005388
4047	1627	6461	extractedFrom	2022-03-08 18:32:24.150365
4048	1751	6462	extractedFrom	2022-03-08 18:32:24.272505
4049	1751	6462	extractedFrom	2022-03-08 18:32:24.33338
4050	2990	6463	extractedFrom	2022-03-08 18:32:24.430394
4051	2990	6463	extractedFrom	2022-03-08 18:32:24.483008
4052	1816	6464	extractedFrom	2022-03-08 18:32:24.573776
4053	1816	6465	extractedFrom	2022-03-08 18:32:24.691386
4054	1816	6465	extractedFrom	2022-03-08 18:32:24.745278
4055	2680	6466	extractedFrom	2022-03-08 18:32:24.850697
4056	2680	6467	extractedFrom	2022-03-08 18:32:24.965422
4057	2680	6467	extractedFrom	2022-03-08 18:32:25.026903
4058	2379	6468	extractedFrom	2022-03-08 18:32:25.123636
4059	2379	6468	extractedFrom	2022-03-08 18:32:25.23607
4060	3387	6469	extractedFrom	2022-03-08 18:32:25.415385
4061	3387	6469	extractedFrom	2022-03-08 18:32:25.496027
4062	2234	6470	extractedFrom	2022-03-08 18:32:25.648533
4063	2234	6470	extractedFrom	2022-03-08 18:32:25.708938
4064	2297	6471	extractedFrom	2022-03-08 18:32:25.806499
4065	2297	6472	extractedFrom	2022-03-08 18:32:25.89808
4066	2297	6472	extractedFrom	2022-03-08 18:32:26.057123
4067	2858	6473	extractedFrom	2022-03-08 18:32:26.309358
4068	2858	6473	extractedFrom	2022-03-08 18:32:26.361154
4069	3178	6474	extractedFrom	2022-03-08 18:32:26.450709
4070	3178	6474	extractedFrom	2022-03-08 18:32:26.520244
4071	2629	6475	extractedFrom	2022-03-08 18:32:26.649945
4072	2629	6476	extractedFrom	2022-03-08 18:32:26.884639
4073	2629	6476	extractedFrom	2022-03-08 18:32:26.959806
4074	2067	6477	extractedFrom	2022-03-08 18:32:27.064464
4075	2067	6477	extractedFrom	2022-03-08 18:32:27.119254
4076	3405	6478	extractedFrom	2022-03-08 18:32:27.236144
4077	3405	6478	extractedFrom	2022-03-08 18:32:27.3136
4078	3450	6479	extractedFrom	2022-03-08 18:32:27.466534
4079	3450	6479	extractedFrom	2022-03-08 18:32:27.554892
4080	2220	6480	extractedFrom	2022-03-08 18:32:27.702293
4081	2220	6480	extractedFrom	2022-03-08 18:32:27.777561
4082	2869	6481	extractedFrom	2022-03-08 18:32:28.17059
4083	2869	6482	extractedFrom	2022-03-08 18:32:28.251027
4084	2869	6482	extractedFrom	2022-03-08 18:32:28.320555
4085	2840	6483	extractedFrom	2022-03-08 18:32:28.425836
4086	2840	6483	extractedFrom	2022-03-08 18:32:28.496212
4087	3434	6484	extractedFrom	2022-03-08 18:32:28.849102
4088	3434	6484	extractedFrom	2022-03-08 18:32:28.945722
4089	3548	6485	extractedFrom	2022-03-08 18:32:29.296358
4090	3548	6485	extractedFrom	2022-03-08 18:32:29.44444
4091	2751	6486	extractedFrom	2022-03-08 18:32:29.538774
4092	2751	6486	extractedFrom	2022-03-08 18:32:29.582771
4093	1573	6487	extractedFrom	2022-03-08 18:32:29.680333
4094	1573	6487	extractedFrom	2022-03-08 18:32:29.826981
4095	3002	6488	extractedFrom	2022-03-08 18:32:29.956274
4096	3002	6489	extractedFrom	2022-03-08 18:32:30.106238
4097	3002	6489	extractedFrom	2022-03-08 18:32:30.167905
4098	3080	6490	extractedFrom	2022-03-08 18:32:30.298098
4099	3080	6490	extractedFrom	2022-03-08 18:32:30.376725
4100	2036	6491	extractedFrom	2022-03-08 18:32:30.482728
4101	2036	6491	extractedFrom	2022-03-08 18:32:30.552848
4102	2732	6492	extractedFrom	2022-03-08 18:32:30.65129
4103	2732	6492	extractedFrom	2022-03-08 18:32:30.863288
4104	3199	6493	extractedFrom	2022-03-08 18:32:30.94767
4105	3199	6493	extractedFrom	2022-03-08 18:32:30.999997
4106	2979	6494	extractedFrom	2022-03-08 18:32:31.24327
4107	2979	6495	extractedFrom	2022-03-08 18:32:31.541838
4108	2979	6496	extractedFrom	2022-03-08 18:32:31.641279
4109	2979	6496	extractedFrom	2022-03-08 18:32:31.89131
4110	2786	6497	extractedFrom	2022-03-08 18:32:32.200721
4111	2786	6497	extractedFrom	2022-03-08 18:32:32.253297
4112	1812	6498	extractedFrom	2022-03-08 18:32:32.342025
4113	1812	6499	extractedFrom	2022-03-08 18:32:32.442312
4114	1812	6499	extractedFrom	2022-03-08 18:32:32.528271
4115	2588	6500	extractedFrom	2022-03-08 18:32:32.877114
4116	2588	6501	extractedFrom	2022-03-08 18:32:33.067689
4117	2588	6501	extractedFrom	2022-03-08 18:32:33.176987
4118	2100	6502	extractedFrom	2022-03-08 18:32:33.26573
4119	2100	6502	extractedFrom	2022-03-08 18:32:33.335835
4120	2787	6503	extractedFrom	2022-03-08 18:32:33.558358
4121	2787	6503	extractedFrom	2022-03-08 18:32:33.62808
4122	2945	6504	extractedFrom	2022-03-08 18:32:33.742309
4123	2945	6504	extractedFrom	2022-03-08 18:32:33.811325
4124	1935	6505	extractedFrom	2022-03-08 18:32:33.924525
4125	1935	6505	extractedFrom	2022-03-08 18:32:34.028754
4126	1771	6506	extractedFrom	2022-03-08 18:32:34.151277
4127	1771	6506	extractedFrom	2022-03-08 18:32:34.288207
4128	3555	6507	extractedFrom	2022-03-08 18:32:34.427361
4129	3555	6508	extractedFrom	2022-03-08 18:32:34.580411
4130	3555	6508	extractedFrom	2022-03-08 18:32:34.81311
4131	1653	6509	extractedFrom	2022-03-08 18:32:35.09575
4132	1653	6510	extractedFrom	2022-03-08 18:32:35.385232
4133	1653	6510	extractedFrom	2022-03-08 18:32:35.46248
4134	2223	6511	extractedFrom	2022-03-08 18:32:35.7595
4135	2223	6511	extractedFrom	2022-03-08 18:32:35.841052
4136	3305	6512	extractedFrom	2022-03-08 18:32:36.017917
4137	3305	6513	extractedFrom	2022-03-08 18:32:36.117575
4138	3305	6513	extractedFrom	2022-03-08 18:32:36.180052
4139	3487	6514	extractedFrom	2022-03-08 18:32:36.378698
4140	3487	6515	extractedFrom	2022-03-08 18:32:36.752765
4141	3487	6515	extractedFrom	2022-03-08 18:32:36.824805
4142	3354	6516	extractedFrom	2022-03-08 18:32:37.012279
4143	3354	6516	extractedFrom	2022-03-08 18:32:37.092109
4144	3290	6517	extractedFrom	2022-03-08 18:32:37.279745
4145	3290	6517	extractedFrom	2022-03-08 18:32:37.333668
4146	1561	6518	extractedFrom	2022-03-08 18:32:37.487534
4147	1561	6518	extractedFrom	2022-03-08 18:32:37.555406
4148	3417	6519	extractedFrom	2022-03-08 18:32:37.738438
4149	3417	6519	extractedFrom	2022-03-08 18:32:37.851839
4150	1993	6520	extractedFrom	2022-03-08 18:32:38.046513
4151	1993	6520	extractedFrom	2022-03-08 18:32:38.20747
4152	2755	6521	extractedFrom	2022-03-08 18:32:38.370116
4153	2755	6521	extractedFrom	2022-03-08 18:32:38.507127
4154	3578	6522	extractedFrom	2022-03-08 18:32:38.727647
4155	3578	6523	extractedFrom	2022-03-08 18:32:38.838391
4156	3578	6523	extractedFrom	2022-03-08 18:32:38.889603
4157	1784	6524	extractedFrom	2022-03-08 18:32:39.062586
4158	1784	6524	extractedFrom	2022-03-08 18:32:39.114923
4159	3599	6525	extractedFrom	2022-03-08 18:32:39.202553
4160	3599	6525	extractedFrom	2022-03-08 18:32:39.265906
4161	3020	6526	extractedFrom	2022-03-08 18:32:39.439782
4162	3020	6526	extractedFrom	2022-03-08 18:32:39.52894
4163	2981	6527	extractedFrom	2022-03-08 18:32:39.720301
4164	2981	6528	extractedFrom	2022-03-08 18:32:39.916591
4165	2981	6528	extractedFrom	2022-03-08 18:32:39.985746
4166	1994	6529	extractedFrom	2022-03-08 18:32:40.091345
4167	1994	6529	extractedFrom	2022-03-08 18:32:40.180976
4168	1651	6530	extractedFrom	2022-03-08 18:32:40.28343
4169	1651	6530	extractedFrom	2022-03-08 18:32:40.433822
4170	1580	6531	extractedFrom	2022-03-08 18:32:40.541979
4171	1580	6532	extractedFrom	2022-03-08 18:32:40.758714
4172	1580	6532	extractedFrom	2022-03-08 18:32:40.835625
4173	3419	6533	extractedFrom	2022-03-08 18:32:40.923715
4174	3419	6533	extractedFrom	2022-03-08 18:32:40.987113
4175	3640	6534	extractedFrom	2022-03-08 18:32:41.3995
4176	3640	6534	extractedFrom	2022-03-08 18:32:41.553376
4177	3635	6535	extractedFrom	2022-03-08 18:32:41.766835
4178	3635	6535	extractedFrom	2022-03-08 18:32:41.887098
4179	1831	6536	extractedFrom	2022-03-08 18:32:42.348297
4180	1831	6537	extractedFrom	2022-03-08 18:32:42.708768
4181	1831	6537	extractedFrom	2022-03-08 18:32:42.855966
4182	2764	6538	extractedFrom	2022-03-08 18:32:43.162948
4183	2764	6538	extractedFrom	2022-03-08 18:32:43.434931
4184	2605	6539	extractedFrom	2022-03-08 18:32:43.815257
4185	2605	6539	extractedFrom	2022-03-08 18:32:43.965189
4186	2902	6540	extractedFrom	2022-03-08 18:32:44.16389
4187	2902	6541	extractedFrom	2022-03-08 18:32:44.245235
4188	2902	6542	extractedFrom	2022-03-08 18:32:44.52294
4189	2902	6542	extractedFrom	2022-03-08 18:32:44.635298
4190	2816	6543	extractedFrom	2022-03-08 18:32:44.951506
4191	2816	6544	extractedFrom	2022-03-08 18:32:45.391507
4192	2816	6544	extractedFrom	2022-03-08 18:32:45.469544
4193	2582	6545	extractedFrom	2022-03-08 18:32:45.676667
4194	2582	6545	extractedFrom	2022-03-08 18:32:45.76879
4195	3675	6546	extractedFrom	2022-03-08 18:32:46.067258
4196	3675	6546	extractedFrom	2022-03-08 18:32:46.1459
4197	2257	6547	extractedFrom	2022-03-08 18:32:46.363411
4198	2257	6548	extractedFrom	2022-03-08 18:32:46.644746
4199	2257	6548	extractedFrom	2022-03-08 18:32:46.773222
4200	3172	6549	extractedFrom	2022-03-08 18:32:47.285697
4201	3172	6549	extractedFrom	2022-03-08 18:32:47.339815
4202	2092	6550	extractedFrom	2022-03-08 18:32:47.705432
4203	2092	6551	extractedFrom	2022-03-08 18:32:47.900055
4204	2092	6552	extractedFrom	2022-03-08 18:32:48.029426
4205	2092	6553	extractedFrom	2022-03-08 18:32:48.171056
4206	2092	6554	extractedFrom	2022-03-08 18:32:48.330213
4207	2092	6555	extractedFrom	2022-03-08 18:32:48.530153
4208	2092	6555	extractedFrom	2022-03-08 18:32:48.602257
4209	2868	6556	extractedFrom	2022-03-08 18:32:49.187643
4210	2868	6556	extractedFrom	2022-03-08 18:32:49.26276
4211	3385	6557	extractedFrom	2022-03-08 18:32:49.454901
4212	3385	6557	extractedFrom	2022-03-08 18:32:49.54423
4213	1902	6558	extractedFrom	2022-03-08 18:32:49.672579
4214	1902	6559	extractedFrom	2022-03-08 18:32:49.836919
4215	1902	6560	extractedFrom	2022-03-08 18:32:50.223331
4216	1902	6560	extractedFrom	2022-03-08 18:32:50.292803
4217	2354	6561	extractedFrom	2022-03-08 18:32:50.421978
4218	2354	6561	extractedFrom	2022-03-08 18:32:50.480667
4219	1777	6562	extractedFrom	2022-03-08 18:32:50.873358
4220	1777	6562	extractedFrom	2022-03-08 18:32:51.097874
4221	3013	6563	extractedFrom	2022-03-08 18:32:51.289889
4222	3013	6564	extractedFrom	2022-03-08 18:32:51.481068
4223	3013	6564	extractedFrom	2022-03-08 18:32:51.564994
4224	2891	6565	extractedFrom	2022-03-08 18:32:51.755813
4225	2891	6565	extractedFrom	2022-03-08 18:32:51.897571
4226	3449	6566	extractedFrom	2022-03-08 18:32:52.116243
4227	3449	6566	extractedFrom	2022-03-08 18:32:52.194674
4228	1895	6567	extractedFrom	2022-03-08 18:32:52.567273
4229	1895	6567	extractedFrom	2022-03-08 18:32:52.647883
4230	2723	6568	extractedFrom	2022-03-08 18:32:53.002653
4231	2723	6569	extractedFrom	2022-03-08 18:32:53.531795
4232	2723	6569	extractedFrom	2022-03-08 18:32:53.61753
4233	1989	6570	extractedFrom	2022-03-08 18:32:53.788911
4234	1989	6570	extractedFrom	2022-03-08 18:32:53.912545
4235	2414	6571	extractedFrom	2022-03-08 18:32:54.3027
4236	2414	6572	extractedFrom	2022-03-08 18:32:54.515005
4237	2414	6572	extractedFrom	2022-03-08 18:32:54.63083
4238	3081	6573	extractedFrom	2022-03-08 18:32:54.767368
4239	3081	6574	extractedFrom	2022-03-08 18:32:54.898108
4240	3081	6574	extractedFrom	2022-03-08 18:32:54.975075
4241	3132	6575	extractedFrom	2022-03-08 18:32:55.114887
4242	3132	6576	extractedFrom	2022-03-08 18:32:55.321377
4243	3132	6577	extractedFrom	2022-03-08 18:32:55.533962
4244	3132	6578	extractedFrom	2022-03-08 18:32:55.718703
4245	3132	6579	extractedFrom	2022-03-08 18:32:55.835792
4246	3132	6580	extractedFrom	2022-03-08 18:32:56.027814
4247	3132	6581	extractedFrom	2022-03-08 18:32:56.219363
4248	3132	6582	extractedFrom	2022-03-08 18:32:56.384754
4249	3132	6582	extractedFrom	2022-03-08 18:32:56.473281
4250	3425	6583	extractedFrom	2022-03-08 18:32:56.593285
4251	3425	6583	extractedFrom	2022-03-08 18:32:56.681927
4252	2892	6584	extractedFrom	2022-03-08 18:32:56.80203
4253	2892	6584	extractedFrom	2022-03-08 18:32:56.951762
4254	2907	6585	extractedFrom	2022-03-08 18:32:57.117017
4255	2907	6586	extractedFrom	2022-03-08 18:32:57.249865
4256	2907	6586	extractedFrom	2022-03-08 18:32:57.324607
4257	2551	6587	extractedFrom	2022-03-08 18:32:57.494057
4258	2551	6588	extractedFrom	2022-03-08 18:32:57.784983
4259	2551	6588	extractedFrom	2022-03-08 18:32:57.861114
4260	2528	6589	extractedFrom	2022-03-08 18:32:58.046527
4261	2528	6590	extractedFrom	2022-03-08 18:32:58.163463
4262	2528	6590	extractedFrom	2022-03-08 18:32:58.367498
4263	2865	6591	extractedFrom	2022-03-08 18:32:58.497144
4264	2865	6591	extractedFrom	2022-03-08 18:32:58.645222
4265	2604	6592	extractedFrom	2022-03-08 18:32:58.836013
4266	2604	6592	extractedFrom	2022-03-08 18:32:58.936173
4267	1976	6593	extractedFrom	2022-03-08 18:32:59.029241
4268	1976	6593	extractedFrom	2022-03-08 18:32:59.119837
4269	1854	6594	extractedFrom	2022-03-08 18:32:59.318349
4270	1854	6594	extractedFrom	2022-03-08 18:32:59.471714
4271	1548	6595	extractedFrom	2022-03-08 18:32:59.620028
4272	1548	6596	extractedFrom	2022-03-08 18:32:59.721484
4273	1548	6596	extractedFrom	2022-03-08 18:32:59.835613
4274	2825	6597	extractedFrom	2022-03-08 18:33:00.075609
4275	2825	6597	extractedFrom	2022-03-08 18:33:00.147314
4276	2304	6598	extractedFrom	2022-03-08 18:33:00.356572
4277	2304	6598	extractedFrom	2022-03-08 18:33:00.425696
4278	1782	6599	extractedFrom	2022-03-08 18:33:00.591518
4279	1782	6599	extractedFrom	2022-03-08 18:33:00.771431
4280	2345	6600	extractedFrom	2022-03-08 18:33:00.914776
4281	2345	6600	extractedFrom	2022-03-08 18:33:01.031656
4282	3255	6601	extractedFrom	2022-03-08 18:33:01.183072
4283	3255	6601	extractedFrom	2022-03-08 18:33:01.253434
4284	3393	6602	extractedFrom	2022-03-08 18:33:01.462853
4285	3393	6602	extractedFrom	2022-03-08 18:33:01.581916
4286	2666	6603	extractedFrom	2022-03-08 18:33:01.708327
4287	2666	6603	extractedFrom	2022-03-08 18:33:01.865601
4288	3334	6604	extractedFrom	2022-03-08 18:33:02.033779
4289	3334	6605	extractedFrom	2022-03-08 18:33:02.196298
4290	3334	6605	extractedFrom	2022-03-08 18:33:02.254706
4291	2940	6606	extractedFrom	2022-03-08 18:33:02.403896
4292	2940	6606	extractedFrom	2022-03-08 18:33:02.475793
4293	3065	6607	extractedFrom	2022-03-08 18:33:02.670427
4294	3065	6608	extractedFrom	2022-03-08 18:33:02.944456
4295	3065	6608	extractedFrom	2022-03-08 18:33:03.047632
4296	3085	6609	extractedFrom	2022-03-08 18:33:03.28435
4297	3085	6609	extractedFrom	2022-03-08 18:33:03.370902
4298	2403	6610	extractedFrom	2022-03-08 18:33:03.475892
4299	2403	6610	extractedFrom	2022-03-08 18:33:03.553569
4300	1620	6611	extractedFrom	2022-03-08 18:33:03.720182
4301	1620	6611	extractedFrom	2022-03-08 18:33:03.832356
4302	2238	6612	extractedFrom	2022-03-08 18:33:03.930588
4303	2238	6612	extractedFrom	2022-03-08 18:33:04.207481
4304	3485	6613	extractedFrom	2022-03-08 18:33:04.373692
4305	3485	6614	extractedFrom	2022-03-08 18:33:04.575904
4306	3485	6614	extractedFrom	2022-03-08 18:33:04.755223
4307	2123	6615	extractedFrom	2022-03-08 18:33:05.266585
4308	2123	6616	extractedFrom	2022-03-08 18:33:05.581415
4309	2123	6617	extractedFrom	2022-03-08 18:33:05.811105
4310	2123	6618	extractedFrom	2022-03-08 18:33:06.131333
4311	2123	6618	extractedFrom	2022-03-08 18:33:06.242196
4312	1726	6619	extractedFrom	2022-03-08 18:33:06.415012
4313	1726	6620	extractedFrom	2022-03-08 18:33:06.646429
4314	1726	6621	extractedFrom	2022-03-08 18:33:06.769509
4315	1726	6622	extractedFrom	2022-03-08 18:33:06.878238
4316	1726	6622	extractedFrom	2022-03-08 18:33:07.151038
4317	2998	6623	extractedFrom	2022-03-08 18:33:07.288747
4318	2998	6623	extractedFrom	2022-03-08 18:33:07.366026
4319	1703	6624	extractedFrom	2022-03-08 18:33:07.672389
4320	1703	6625	extractedFrom	2022-03-08 18:33:07.900181
4321	1703	6625	extractedFrom	2022-03-08 18:33:07.975653
4322	3348	6626	extractedFrom	2022-03-08 18:33:08.128526
4323	3348	6626	extractedFrom	2022-03-08 18:33:08.252613
4324	2848	6627	extractedFrom	2022-03-08 18:33:08.538583
4325	2848	6628	extractedFrom	2022-03-08 18:33:08.690851
4326	2848	6629	extractedFrom	2022-03-08 18:33:08.789575
4327	2848	6630	extractedFrom	2022-03-08 18:33:09.065011
4328	2848	6631	extractedFrom	2022-03-08 18:33:09.483747
4329	2848	6632	extractedFrom	2022-03-08 18:33:10.042458
4330	2848	6633	extractedFrom	2022-03-08 18:33:10.293142
4331	2848	6633	extractedFrom	2022-03-08 18:33:10.383724
4332	1838	6634	extractedFrom	2022-03-08 18:33:10.508063
4333	1838	6635	extractedFrom	2022-03-08 18:33:10.654697
4334	1838	6636	extractedFrom	2022-03-08 18:33:10.966732
4335	1838	6636	extractedFrom	2022-03-08 18:33:11.070651
4336	1821	6637	extractedFrom	2022-03-08 18:33:11.418199
4337	1821	6638	extractedFrom	2022-03-08 18:33:11.686595
4338	1821	6638	extractedFrom	2022-03-08 18:33:11.773843
4339	2313	6639	extractedFrom	2022-03-08 18:33:11.991266
4340	2313	6639	extractedFrom	2022-03-08 18:33:12.083917
4341	2642	6640	extractedFrom	2022-03-08 18:33:12.263113
4342	2642	6640	extractedFrom	2022-03-08 18:33:12.337846
4343	3055	6641	extractedFrom	2022-03-08 18:33:12.54261
4344	3055	6641	extractedFrom	2022-03-08 18:33:12.613371
4345	2280	6642	extractedFrom	2022-03-08 18:33:12.862643
4346	2280	6642	extractedFrom	2022-03-08 18:33:13.142895
4347	3294	6643	extractedFrom	2022-03-08 18:33:13.355157
4348	3294	6643	extractedFrom	2022-03-08 18:33:13.498775
4349	2563	6644	extractedFrom	2022-03-08 18:33:13.714639
4350	2563	6644	extractedFrom	2022-03-08 18:33:13.805562
4351	2134	6645	extractedFrom	2022-03-08 18:33:14.10022
4352	2134	6645	extractedFrom	2022-03-08 18:33:14.179283
4353	3315	6646	extractedFrom	2022-03-08 18:33:14.409624
4354	3315	6647	extractedFrom	2022-03-08 18:33:14.686779
4355	3315	6647	extractedFrom	2022-03-08 18:33:14.7664
4356	2863	6648	extractedFrom	2022-03-08 18:33:14.991651
4357	2863	6648	extractedFrom	2022-03-08 18:33:15.056491
4358	3127	6649	extractedFrom	2022-03-08 18:33:15.311503
4359	3127	6649	extractedFrom	2022-03-08 18:33:15.532615
4360	3205	6650	extractedFrom	2022-03-08 18:33:15.70018
4361	3205	6650	extractedFrom	2022-03-08 18:33:15.887798
4362	2396	6651	extractedFrom	2022-03-08 18:33:16.041652
4363	2396	6651	extractedFrom	2022-03-08 18:33:16.179231
4364	2993	6652	extractedFrom	2022-03-08 18:33:16.301222
4365	2993	6652	extractedFrom	2022-03-08 18:33:16.354936
4366	1766	6653	extractedFrom	2022-03-08 18:33:16.485551
4367	1766	6653	extractedFrom	2022-03-08 18:33:16.598229
4368	3378	6654	extractedFrom	2022-03-08 18:33:16.819639
4369	3378	6654	extractedFrom	2022-03-08 18:33:16.899974
4370	3209	6655	extractedFrom	2022-03-08 18:33:17.102321
4371	3209	6656	extractedFrom	2022-03-08 18:33:17.468651
4372	3209	6657	extractedFrom	2022-03-08 18:33:17.581587
4373	3209	6657	extractedFrom	2022-03-08 18:33:17.666077
4374	2783	6658	extractedFrom	2022-03-08 18:33:17.840559
4375	2783	6659	extractedFrom	2022-03-08 18:33:18.333342
4376	2783	6659	extractedFrom	2022-03-08 18:33:18.467784
4377	2655	6660	extractedFrom	2022-03-08 18:33:18.683644
4378	2655	6660	extractedFrom	2022-03-08 18:33:18.799487
4379	3338	6661	extractedFrom	2022-03-08 18:33:18.997776
4380	3338	6661	extractedFrom	2022-03-08 18:33:19.162784
4381	2212	6662	extractedFrom	2022-03-08 18:33:19.700716
4382	2212	6662	extractedFrom	2022-03-08 18:33:19.788003
4383	2910	6663	extractedFrom	2022-03-08 18:33:20.116835
4384	2910	6664	extractedFrom	2022-03-08 18:33:20.491254
4385	2910	6665	extractedFrom	2022-03-08 18:33:21.023421
4386	2910	6665	extractedFrom	2022-03-08 18:33:21.140627
4387	1656	6666	extractedFrom	2022-03-08 18:33:21.377432
4388	1656	6666	extractedFrom	2022-03-08 18:33:21.457559
4389	3130	6667	extractedFrom	2022-03-08 18:33:21.750862
4390	3130	6667	extractedFrom	2022-03-08 18:33:21.831079
4391	3160	6668	extractedFrom	2022-03-08 18:33:22.077232
4392	3160	6669	extractedFrom	2022-03-08 18:33:22.25212
4393	3160	6670	extractedFrom	2022-03-08 18:33:22.555227
4394	3160	6671	extractedFrom	2022-03-08 18:33:22.723212
4395	3160	6672	extractedFrom	2022-03-08 18:33:22.941238
4396	3160	6673	extractedFrom	2022-03-08 18:33:23.208458
4397	3160	6674	extractedFrom	2022-03-08 18:33:23.485065
4398	3160	6674	extractedFrom	2022-03-08 18:33:23.698428
4399	3671	6675	extractedFrom	2022-03-08 18:33:23.976921
4400	3671	6675	extractedFrom	2022-03-08 18:33:24.078764
4401	2355	6676	extractedFrom	2022-03-08 18:33:24.404294
4402	2355	6676	extractedFrom	2022-03-08 18:33:24.521389
4403	1680	6677	extractedFrom	2022-03-08 18:33:24.837449
4404	1680	6677	extractedFrom	2022-03-08 18:33:24.965717
4405	3345	6678	extractedFrom	2022-03-08 18:33:25.470829
4406	3345	6678	extractedFrom	2022-03-08 18:33:25.697366
4407	2041	6679	extractedFrom	2022-03-08 18:33:25.990995
4408	2041	6680	extractedFrom	2022-03-08 18:33:26.260749
4409	2041	6680	extractedFrom	2022-03-08 18:33:26.348009
4410	2291	6681	extractedFrom	2022-03-08 18:33:26.533633
4411	2291	6681	extractedFrom	2022-03-08 18:33:26.818097
4412	2634	6682	extractedFrom	2022-03-08 18:33:27.145755
4413	2634	6682	extractedFrom	2022-03-08 18:33:27.23803
4414	2074	6683	extractedFrom	2022-03-08 18:33:27.613298
4415	2074	6684	extractedFrom	2022-03-08 18:33:27.802982
4416	2074	6684	extractedFrom	2022-03-08 18:33:27.966251
4417	2440	6685	extractedFrom	2022-03-08 18:33:28.324837
4418	2440	6685	extractedFrom	2022-03-08 18:33:28.460471
4419	2293	6686	extractedFrom	2022-03-08 18:33:28.821728
4420	2293	6686	extractedFrom	2022-03-08 18:33:29.040769
4421	3079	6687	extractedFrom	2022-03-08 18:33:29.420628
4422	3079	6687	extractedFrom	2022-03-08 18:33:29.89587
4423	2511	6688	extractedFrom	2022-03-08 18:33:30.305097
4424	2511	6689	extractedFrom	2022-03-08 18:33:30.633729
4425	2511	6689	extractedFrom	2022-03-08 18:33:30.752499
4426	1970	6690	extractedFrom	2022-03-08 18:33:31.380511
4427	1970	6690	extractedFrom	2022-03-08 18:33:31.729722
4428	1570	6691	extractedFrom	2022-03-08 18:33:32.045978
4429	1570	6692	extractedFrom	2022-03-08 18:33:32.498325
4430	1570	6692	extractedFrom	2022-03-08 18:33:32.64979
4431	2707	6693	extractedFrom	2022-03-08 18:33:33.041818
4432	2707	6694	extractedFrom	2022-03-08 18:33:33.325549
4433	2707	6694	extractedFrom	2022-03-08 18:33:33.5468
4434	3564	6695	extractedFrom	2022-03-08 18:33:33.717839
4435	3564	6696	extractedFrom	2022-03-08 18:33:34.169731
4436	3564	6696	extractedFrom	2022-03-08 18:33:34.324148
4437	1608	6697	extractedFrom	2022-03-08 18:33:34.470503
4438	1608	6697	extractedFrom	2022-03-08 18:33:34.549197
4439	2555	6698	extractedFrom	2022-03-08 18:33:35.053625
4440	2555	6698	extractedFrom	2022-03-08 18:33:35.130477
4441	2055	6699	extractedFrom	2022-03-08 18:33:35.432413
4442	2055	6699	extractedFrom	2022-03-08 18:33:35.616117
4443	2024	6700	extractedFrom	2022-03-08 18:33:36.087435
4444	2024	6700	extractedFrom	2022-03-08 18:33:36.27402
4445	1967	6701	extractedFrom	2022-03-08 18:33:36.509779
4446	1967	6702	extractedFrom	2022-03-08 18:33:36.743526
4447	1967	6702	extractedFrom	2022-03-08 18:33:36.937209
4448	2226	6703	extractedFrom	2022-03-08 18:33:37.262983
4449	2226	6703	extractedFrom	2022-03-08 18:33:37.331638
4450	3690	6704	extractedFrom	2022-03-08 18:33:37.520888
4451	3690	6704	extractedFrom	2022-03-08 18:33:37.616087
4452	3550	6705	extractedFrom	2022-03-08 18:33:37.721014
4453	3550	6705	extractedFrom	2022-03-08 18:33:37.904161
4454	1857	6706	extractedFrom	2022-03-08 18:33:38.075562
4455	1857	6706	extractedFrom	2022-03-08 18:33:38.163901
4456	3281	6707	extractedFrom	2022-03-08 18:33:38.482252
4457	3281	6707	extractedFrom	2022-03-08 18:33:38.734442
4458	3070	6708	extractedFrom	2022-03-08 18:33:39.055015
4459	3070	6708	extractedFrom	2022-03-08 18:33:39.223647
4460	2586	6709	extractedFrom	2022-03-08 18:33:39.714461
4461	2586	6709	extractedFrom	2022-03-08 18:33:40.2379
4462	3163	6710	extractedFrom	2022-03-08 18:33:40.495535
4463	3163	6710	extractedFrom	2022-03-08 18:33:40.571535
4464	1587	6711	extractedFrom	2022-03-08 18:33:40.783905
4465	1587	6711	extractedFrom	2022-03-08 18:33:40.933563
4466	1823	6712	extractedFrom	2022-03-08 18:33:41.268229
4467	1823	6713	extractedFrom	2022-03-08 18:33:41.572451
4468	1823	6714	extractedFrom	2022-03-08 18:33:41.7435
4469	1823	6714	extractedFrom	2022-03-08 18:33:42.051042
4470	3604	6715	extractedFrom	2022-03-08 18:33:42.459801
4471	3604	6715	extractedFrom	2022-03-08 18:33:42.647717
4472	1949	6716	extractedFrom	2022-03-08 18:33:43.359182
4473	1949	6716	extractedFrom	2022-03-08 18:33:43.491943
4474	3397	6717	extractedFrom	2022-03-08 18:33:43.762719
4475	3397	6717	extractedFrom	2022-03-08 18:33:43.85291
4476	1666	6718	extractedFrom	2022-03-08 18:33:43.992578
4477	1666	6718	extractedFrom	2022-03-08 18:33:44.117639
4478	2575	6719	extractedFrom	2022-03-08 18:33:44.365608
4479	2575	6719	extractedFrom	2022-03-08 18:33:44.504466
4480	2600	6720	extractedFrom	2022-03-08 18:33:44.797413
4481	2600	6721	extractedFrom	2022-03-08 18:33:45.016453
4482	2600	6721	extractedFrom	2022-03-08 18:33:45.205564
4483	2334	6722	extractedFrom	2022-03-08 18:33:45.345812
4484	2334	6723	extractedFrom	2022-03-08 18:33:45.558746
4485	2334	6724	extractedFrom	2022-03-08 18:33:45.715842
4486	2334	6725	extractedFrom	2022-03-08 18:33:45.908074
4487	2334	6725	extractedFrom	2022-03-08 18:33:46.017567
4488	2126	6726	extractedFrom	2022-03-08 18:33:46.263063
4489	2126	6727	extractedFrom	2022-03-08 18:33:46.807511
4490	2126	6728	extractedFrom	2022-03-08 18:33:46.982849
4491	2126	6728	extractedFrom	2022-03-08 18:33:47.055199
4492	2285	6729	extractedFrom	2022-03-08 18:33:47.473454
4493	2285	6729	extractedFrom	2022-03-08 18:33:47.593664
4494	3180	6730	extractedFrom	2022-03-08 18:33:48.17225
4495	3180	6730	extractedFrom	2022-03-08 18:33:48.269205
4496	2744	6731	extractedFrom	2022-03-08 18:33:48.743129
4497	2744	6732	extractedFrom	2022-03-08 18:33:49.122434
4498	2744	6732	extractedFrom	2022-03-08 18:33:49.347769
4499	2164	6733	extractedFrom	2022-03-08 18:33:49.907155
4500	2164	6733	extractedFrom	2022-03-08 18:33:50.000972
4501	3247	6734	extractedFrom	2022-03-08 18:33:50.285709
4502	3247	6735	extractedFrom	2022-03-08 18:33:50.442014
4503	3247	6736	extractedFrom	2022-03-08 18:33:50.731146
4504	3247	6736	extractedFrom	2022-03-08 18:33:51.064133
4505	2806	6737	extractedFrom	2022-03-08 18:33:51.330668
4506	2806	6738	extractedFrom	2022-03-08 18:33:51.734407
4507	2806	6738	extractedFrom	2022-03-08 18:33:51.860327
4508	2548	6739	extractedFrom	2022-03-08 18:33:52.078031
4509	2548	6740	extractedFrom	2022-03-08 18:33:52.275545
4510	2548	6740	extractedFrom	2022-03-08 18:33:52.348211
4511	2513	6741	extractedFrom	2022-03-08 18:33:52.749409
4512	2513	6742	extractedFrom	2022-03-08 18:33:53.027006
4513	2513	6743	extractedFrom	2022-03-08 18:33:53.413166
4514	2513	6743	extractedFrom	2022-03-08 18:33:53.541742
4515	2191	6744	extractedFrom	2022-03-08 18:33:53.999048
4516	2191	6744	extractedFrom	2022-03-08 18:33:54.304653
4517	3428	6745	extractedFrom	2022-03-08 18:33:54.437607
4518	3428	6745	extractedFrom	2022-03-08 18:33:54.554422
4519	2043	6746	extractedFrom	2022-03-08 18:33:54.762516
4520	2043	6747	extractedFrom	2022-03-08 18:33:55.066544
4521	2043	6747	extractedFrom	2022-03-08 18:33:55.250249
4522	3609	6748	extractedFrom	2022-03-08 18:33:55.682647
4523	3609	6749	extractedFrom	2022-03-08 18:33:56.006384
4524	3609	6749	extractedFrom	2022-03-08 18:33:56.115639
4525	1596	6750	extractedFrom	2022-03-08 18:33:56.484462
4526	1596	6750	extractedFrom	2022-03-08 18:33:56.598346
4527	1673	6751	extractedFrom	2022-03-08 18:33:56.874201
4528	1673	6751	extractedFrom	2022-03-08 18:33:57.007796
4529	3100	6752	extractedFrom	2022-03-08 18:33:57.180029
4530	3100	6752	extractedFrom	2022-03-08 18:33:57.29083
4531	2140	6753	extractedFrom	2022-03-08 18:33:57.509114
4532	2140	6753	extractedFrom	2022-03-08 18:33:57.714609
4533	3371	6754	extractedFrom	2022-03-08 18:33:57.920057
4534	3371	6754	extractedFrom	2022-03-08 18:33:58.022791
4535	3400	6755	extractedFrom	2022-03-08 18:33:58.439887
4536	3400	6755	extractedFrom	2022-03-08 18:33:58.547303
4537	2125	6756	extractedFrom	2022-03-08 18:33:58.870415
4538	2125	6757	extractedFrom	2022-03-08 18:33:59.135445
4539	2125	6757	extractedFrom	2022-03-08 18:33:59.231185
4540	2849	6758	extractedFrom	2022-03-08 18:33:59.615443
4541	2849	6758	extractedFrom	2022-03-08 18:33:59.786302
4542	2935	6759	extractedFrom	2022-03-08 18:34:00.010946
4543	2935	6760	extractedFrom	2022-03-08 18:34:00.128465
4544	2935	6760	extractedFrom	2022-03-08 18:34:00.226507
4545	1657	6761	extractedFrom	2022-03-08 18:34:00.537279
4546	1657	6761	extractedFrom	2022-03-08 18:34:00.66964
4547	3207	6762	extractedFrom	2022-03-08 18:34:00.922551
4548	3207	6762	extractedFrom	2022-03-08 18:34:01.137335
4549	2980	6763	extractedFrom	2022-03-08 18:34:01.39729
4550	2980	6764	extractedFrom	2022-03-08 18:34:01.598319
4551	2980	6764	extractedFrom	2022-03-08 18:34:01.691998
4552	1819	6765	extractedFrom	2022-03-08 18:34:01.921511
4553	1819	6765	extractedFrom	2022-03-08 18:34:02.080853
4554	1544	6766	extractedFrom	2022-03-08 18:34:02.347391
4555	1544	6767	extractedFrom	2022-03-08 18:34:02.663198
4556	1544	6768	extractedFrom	2022-03-08 18:34:02.893557
4557	1544	6769	extractedFrom	2022-03-08 18:34:03.204025
4558	1544	6769	extractedFrom	2022-03-08 18:34:03.280806
4559	3246	6770	extractedFrom	2022-03-08 18:34:03.634883
4560	3246	6770	extractedFrom	2022-03-08 18:34:03.763217
4561	2265	6771	extractedFrom	2022-03-08 18:34:03.872473
4562	2265	6772	extractedFrom	2022-03-08 18:34:03.994091
4563	2265	6772	extractedFrom	2022-03-08 18:34:04.251241
4564	3655	6773	extractedFrom	2022-03-08 18:34:04.82623
4565	3655	6773	extractedFrom	2022-03-08 18:34:05.065209
4566	2064	6774	extractedFrom	2022-03-08 18:34:05.318864
4567	2064	6774	extractedFrom	2022-03-08 18:34:05.419899
4568	1541	6775	extractedFrom	2022-03-08 18:34:05.748007
4569	1541	6776	extractedFrom	2022-03-08 18:34:06.005495
4570	1541	6777	extractedFrom	2022-03-08 18:34:06.319448
4571	1541	6778	extractedFrom	2022-03-08 18:34:06.504965
4573	1541	6780	extractedFrom	2022-03-08 18:34:06.94471
4574	1541	6781	extractedFrom	2022-03-08 18:34:07.478515
4575	1541	6782	extractedFrom	2022-03-08 18:34:07.766751
4576	1541	6783	extractedFrom	2022-03-08 18:34:07.980502
4577	1541	6784	extractedFrom	2022-03-08 18:34:08.231094
4578	1541	6785	extractedFrom	2022-03-08 18:34:08.622355
4579	1541	6786	extractedFrom	2022-03-08 18:34:08.898197
4580	1541	6786	extractedFrom	2022-03-08 18:34:09.006706
4581	2977	6787	extractedFrom	2022-03-08 18:34:09.36571
4582	2977	6787	extractedFrom	2022-03-08 18:34:09.446961
4583	3158	6788	extractedFrom	2022-03-08 18:34:09.946354
4584	3158	6789	extractedFrom	2022-03-08 18:34:10.5835
4585	3158	6789	extractedFrom	2022-03-08 18:34:10.767461
4586	3019	6790	extractedFrom	2022-03-08 18:34:11.138563
4587	3019	6790	extractedFrom	2022-03-08 18:34:11.238716
4588	2958	6791	extractedFrom	2022-03-08 18:34:11.632875
4589	2958	6792	extractedFrom	2022-03-08 18:34:12.05885
4590	2958	6792	extractedFrom	2022-03-08 18:34:12.155826
4591	3223	6793	extractedFrom	2022-03-08 18:34:12.41828
4592	3223	6794	extractedFrom	2022-03-08 18:34:12.573977
4593	3223	6794	extractedFrom	2022-03-08 18:34:12.71961
4594	1543	6795	extractedFrom	2022-03-08 18:34:13.156641
4595	1543	6796	extractedFrom	2022-03-08 18:34:13.392179
4596	1543	6796	extractedFrom	2022-03-08 18:34:13.48721
4597	1828	6797	extractedFrom	2022-03-08 18:34:13.652925
4598	1828	6797	extractedFrom	2022-03-08 18:34:13.843103
4599	3027	6798	extractedFrom	2022-03-08 18:34:14.117552
4600	3027	6799	extractedFrom	2022-03-08 18:34:14.411025
4601	3027	6800	extractedFrom	2022-03-08 18:34:14.664588
4602	3027	6801	extractedFrom	2022-03-08 18:34:14.964753
4603	3027	6802	extractedFrom	2022-03-08 18:34:15.347725
4604	3027	6803	extractedFrom	2022-03-08 18:34:15.577449
4605	3027	6804	extractedFrom	2022-03-08 18:34:15.786955
4606	3027	6804	extractedFrom	2022-03-08 18:34:16.0022
4607	2955	6805	extractedFrom	2022-03-08 18:34:16.644585
4608	2955	6805	extractedFrom	2022-03-08 18:34:16.752775
4609	2247	6806	extractedFrom	2022-03-08 18:34:17.111318
4610	2247	6806	extractedFrom	2022-03-08 18:34:17.219007
4611	1557	6807	extractedFrom	2022-03-08 18:34:17.454538
4612	1557	6807	extractedFrom	2022-03-08 18:34:17.543335
4613	2286	6808	extractedFrom	2022-03-08 18:34:17.938731
4614	2286	6808	extractedFrom	2022-03-08 18:34:18.161442
4615	2073	6809	extractedFrom	2022-03-08 18:34:18.393914
4616	2073	6810	extractedFrom	2022-03-08 18:34:18.901448
4617	2073	6810	extractedFrom	2022-03-08 18:34:19.094501
4618	3363	6811	extractedFrom	2022-03-08 18:34:19.234919
4619	3363	6811	extractedFrom	2022-03-08 18:34:19.359829
4620	3306	6812	extractedFrom	2022-03-08 18:34:19.76035
4621	3306	6812	extractedFrom	2022-03-08 18:34:19.971734
4622	1925	6813	extractedFrom	2022-03-08 18:34:20.296134
4623	1925	6813	extractedFrom	2022-03-08 18:34:20.446679
4624	3402	6814	extractedFrom	2022-03-08 18:34:20.767547
4625	3402	6814	extractedFrom	2022-03-08 18:34:20.865332
4626	2538	6815	extractedFrom	2022-03-08 18:34:21.291285
4627	2538	6816	extractedFrom	2022-03-08 18:34:21.489002
4628	2538	6816	extractedFrom	2022-03-08 18:34:21.574543
4629	2697	6817	extractedFrom	2022-03-08 18:34:21.789225
4630	2697	6817	extractedFrom	2022-03-08 18:34:21.936975
4631	3468	6818	extractedFrom	2022-03-08 18:34:22.253917
4632	3468	6818	extractedFrom	2022-03-08 18:34:22.624947
4633	3303	6819	extractedFrom	2022-03-08 18:34:22.789671
4634	3303	6819	extractedFrom	2022-03-08 18:34:22.860425
4635	2752	6820	extractedFrom	2022-03-08 18:34:23.072934
4636	2752	6820	extractedFrom	2022-03-08 18:34:23.182627
4637	2270	6821	extractedFrom	2022-03-08 18:34:23.32119
4638	2270	6821	extractedFrom	2022-03-08 18:34:23.406915
4639	1796	6822	extractedFrom	2022-03-08 18:34:23.640516
4640	1796	6822	extractedFrom	2022-03-08 18:34:23.827997
4641	2061	6823	extractedFrom	2022-03-08 18:34:24.379863
4642	2061	6824	extractedFrom	2022-03-08 18:34:24.683784
4643	2061	6824	extractedFrom	2022-03-08 18:34:24.765652
4644	3230	6825	extractedFrom	2022-03-08 18:34:24.908664
4645	3230	6826	extractedFrom	2022-03-08 18:34:25.050904
4646	3230	6827	extractedFrom	2022-03-08 18:34:25.296643
4647	3230	6827	extractedFrom	2022-03-08 18:34:25.423447
4648	3335	6828	extractedFrom	2022-03-08 18:34:25.700227
4649	3335	6829	extractedFrom	2022-03-08 18:34:26.007461
4650	3335	6829	extractedFrom	2022-03-08 18:34:26.10284
4651	2348	6830	extractedFrom	2022-03-08 18:34:26.268226
4652	2348	6831	extractedFrom	2022-03-08 18:34:26.443311
4653	2348	6831	extractedFrom	2022-03-08 18:34:26.682359
4654	1999	6832	extractedFrom	2022-03-08 18:34:26.939613
4655	1999	6833	extractedFrom	2022-03-08 18:34:27.163454
4656	1999	6833	extractedFrom	2022-03-08 18:34:27.415266
4657	2856	6834	extractedFrom	2022-03-08 18:34:27.666062
4658	2856	6835	extractedFrom	2022-03-08 18:34:27.873776
4659	2856	6835	extractedFrom	2022-03-08 18:34:28.013435
4660	1642	6836	extractedFrom	2022-03-08 18:34:28.153007
4661	1642	6836	extractedFrom	2022-03-08 18:34:28.230368
4662	2319	6837	extractedFrom	2022-03-08 18:34:28.532993
4663	2319	6837	extractedFrom	2022-03-08 18:34:28.626027
4664	2232	6838	extractedFrom	2022-03-08 18:34:29.221755
4665	2232	6839	extractedFrom	2022-03-08 18:34:29.599929
4666	2232	6839	extractedFrom	2022-03-08 18:34:29.698631
4667	2084	6840	extractedFrom	2022-03-08 18:34:29.948382
4668	2084	6841	extractedFrom	2022-03-08 18:34:30.52397
4669	2084	6842	extractedFrom	2022-03-08 18:34:30.815266
4670	2084	6843	extractedFrom	2022-03-08 18:34:31.070836
4671	2084	6844	extractedFrom	2022-03-08 18:34:31.331026
4672	2084	6845	extractedFrom	2022-03-08 18:34:31.517239
4673	2084	6846	extractedFrom	2022-03-08 18:34:31.808622
4674	2084	6846	extractedFrom	2022-03-08 18:34:31.910369
4675	2529	6847	extractedFrom	2022-03-08 18:34:32.066488
4676	2529	6847	extractedFrom	2022-03-08 18:34:32.28154
4677	2846	6848	extractedFrom	2022-03-08 18:34:34.506246
4678	2846	6849	extractedFrom	2022-03-08 18:34:34.805531
4679	2846	6849	extractedFrom	2022-03-08 18:34:34.919515
4680	1992	6850	extractedFrom	2022-03-08 18:34:35.36702
4681	1992	6851	extractedFrom	2022-03-08 18:34:35.695724
4682	1992	6852	extractedFrom	2022-03-08 18:34:35.876258
4683	1992	6853	extractedFrom	2022-03-08 18:34:36.070964
4684	1992	6854	extractedFrom	2022-03-08 18:34:36.26567
4685	1992	6855	extractedFrom	2022-03-08 18:34:36.444851
4686	1992	6856	extractedFrom	2022-03-08 18:34:36.737971
4687	1992	6856	extractedFrom	2022-03-08 18:34:36.860146
4688	1875	6857	extractedFrom	2022-03-08 18:34:37.246576
4689	1875	6858	extractedFrom	2022-03-08 18:34:37.458616
4690	1875	6859	extractedFrom	2022-03-08 18:34:37.712802
4691	1875	6859	extractedFrom	2022-03-08 18:34:37.868042
4692	2765	6860	extractedFrom	2022-03-08 18:34:38.073221
4693	2765	6860	extractedFrom	2022-03-08 18:34:38.187369
4694	2096	6861	extractedFrom	2022-03-08 18:34:38.553247
4695	2096	6862	extractedFrom	2022-03-08 18:34:39.560673
4696	2096	6863	extractedFrom	2022-03-08 18:34:39.88203
4697	2096	6864	extractedFrom	2022-03-08 18:34:40.230119
4698	2096	6865	extractedFrom	2022-03-08 18:34:40.523568
4699	2096	6866	extractedFrom	2022-03-08 18:34:40.755288
4700	2096	6867	extractedFrom	2022-03-08 18:34:41.004715
4701	2096	6868	extractedFrom	2022-03-08 18:34:41.370171
4702	2096	6868	extractedFrom	2022-03-08 18:34:41.443661
4703	2277	6869	extractedFrom	2022-03-08 18:34:41.632027
4704	2277	6869	extractedFrom	2022-03-08 18:34:41.83163
4705	2298	6870	extractedFrom	2022-03-08 18:34:42.00312
4706	2298	6871	extractedFrom	2022-03-08 18:34:42.209622
4707	2298	6872	extractedFrom	2022-03-08 18:34:42.646084
4708	2298	6873	extractedFrom	2022-03-08 18:34:42.807886
4709	2298	6873	extractedFrom	2022-03-08 18:34:42.882162
4710	2560	6874	extractedFrom	2022-03-08 18:34:43.054512
4711	2560	6875	extractedFrom	2022-03-08 18:34:43.205654
4712	2560	6875	extractedFrom	2022-03-08 18:34:43.375174
4713	3538	6876	extractedFrom	2022-03-08 18:34:43.803701
4714	3538	6877	extractedFrom	2022-03-08 18:34:44.076825
4715	3538	6878	extractedFrom	2022-03-08 18:34:44.560501
4716	3538	6879	extractedFrom	2022-03-08 18:34:44.767696
4717	3538	6879	extractedFrom	2022-03-08 18:34:44.873645
4718	3331	6880	extractedFrom	2022-03-08 18:34:45.207932
4719	3331	6880	extractedFrom	2022-03-08 18:34:45.332402
4720	1888	6881	extractedFrom	2022-03-08 18:34:45.486904
4721	1888	6882	extractedFrom	2022-03-08 18:34:45.64557
4722	1888	6883	extractedFrom	2022-03-08 18:34:45.803457
4723	1888	6883	extractedFrom	2022-03-08 18:34:45.95506
4724	1797	6884	extractedFrom	2022-03-08 18:34:46.220987
4725	1797	6884	extractedFrom	2022-03-08 18:34:46.413623
4726	3274	6885	extractedFrom	2022-03-08 18:34:46.780627
4727	3274	6885	extractedFrom	2022-03-08 18:34:46.85536
4728	2474	6886	extractedFrom	2022-03-08 18:34:47.059756
4729	2474	6886	extractedFrom	2022-03-08 18:34:47.245552
4730	3134	6887	extractedFrom	2022-03-08 18:34:47.656943
4731	3134	6887	extractedFrom	2022-03-08 18:34:47.970135
4732	2957	6888	extractedFrom	2022-03-08 18:34:48.331648
4733	2957	6889	extractedFrom	2022-03-08 18:34:48.639385
4734	2957	6890	extractedFrom	2022-03-08 18:34:48.805285
4735	2957	6891	extractedFrom	2022-03-08 18:34:49.222739
4736	2957	6891	extractedFrom	2022-03-08 18:34:49.46947
4737	2867	6892	extractedFrom	2022-03-08 18:34:49.744373
4738	2867	6892	extractedFrom	2022-03-08 18:34:49.827652
4739	3279	6893	extractedFrom	2022-03-08 18:34:50.142757
4740	3279	6894	extractedFrom	2022-03-08 18:34:50.299041
4741	3279	6894	extractedFrom	2022-03-08 18:34:50.426994
4742	1981	6895	extractedFrom	2022-03-08 18:34:50.663316
4743	1981	6895	extractedFrom	2022-03-08 18:34:50.843651
4744	2661	6896	extractedFrom	2022-03-08 18:34:51.018193
4745	2661	6896	extractedFrom	2022-03-08 18:34:51.089048
4746	3024	6897	extractedFrom	2022-03-08 18:34:51.356607
4747	3024	6897	extractedFrom	2022-03-08 18:34:51.443612
4748	2303	6898	extractedFrom	2022-03-08 18:34:51.755674
4749	2303	6899	extractedFrom	2022-03-08 18:34:51.944135
4750	2303	6900	extractedFrom	2022-03-08 18:34:52.153838
4751	2303	6900	extractedFrom	2022-03-08 18:34:52.228482
4752	3389	6901	extractedFrom	2022-03-08 18:34:52.411287
4753	3389	6902	extractedFrom	2022-03-08 18:34:52.53831
4754	3389	6902	extractedFrom	2022-03-08 18:34:52.637452
4755	3045	6903	extractedFrom	2022-03-08 18:34:52.806893
4756	3045	6904	extractedFrom	2022-03-08 18:34:52.972721
4757	3045	6905	extractedFrom	2022-03-08 18:34:53.102311
4758	3045	6905	extractedFrom	2022-03-08 18:34:53.216097
4759	1563	6906	extractedFrom	2022-03-08 18:34:53.78465
4760	1563	6907	extractedFrom	2022-03-08 18:34:54.130334
4761	1563	6908	extractedFrom	2022-03-08 18:34:54.346541
4762	1563	6908	extractedFrom	2022-03-08 18:34:54.465807
4763	2739	6909	extractedFrom	2022-03-08 18:34:54.659635
4764	2739	6910	extractedFrom	2022-03-08 18:34:54.935528
4765	2739	6910	extractedFrom	2022-03-08 18:34:55.023535
4766	1619	6911	extractedFrom	2022-03-08 18:34:55.503949
4767	1619	6911	extractedFrom	2022-03-08 18:34:55.620289
4768	3469	6912	extractedFrom	2022-03-08 18:34:55.830579
4769	3469	6912	extractedFrom	2022-03-08 18:34:56.115287
4770	1769	6913	extractedFrom	2022-03-08 18:34:56.286959
4771	1769	6914	extractedFrom	2022-03-08 18:34:56.589799
4772	1769	6915	extractedFrom	2022-03-08 18:34:56.768892
4773	1769	6916	extractedFrom	2022-03-08 18:34:57.016236
4774	1769	6917	extractedFrom	2022-03-08 18:34:57.37276
4775	1769	6918	extractedFrom	2022-03-08 18:34:57.591884
4776	1769	6919	extractedFrom	2022-03-08 18:34:57.76022
4777	1769	6920	extractedFrom	2022-03-08 18:34:58.005255
4778	1769	6921	extractedFrom	2022-03-08 18:34:58.202955
4779	1769	6922	extractedFrom	2022-03-08 18:34:58.370354
4780	1769	6923	extractedFrom	2022-03-08 18:34:58.603284
4781	1769	6924	extractedFrom	2022-03-08 18:34:58.881208
4782	1769	6924	extractedFrom	2022-03-08 18:34:59.087688
4783	2150	6925	extractedFrom	2022-03-08 18:34:59.439638
4784	2150	6926	extractedFrom	2022-03-08 18:34:59.700774
4785	2150	6927	extractedFrom	2022-03-08 18:35:00.192919
4786	2150	6928	extractedFrom	2022-03-08 18:35:00.457956
4787	2150	6929	extractedFrom	2022-03-08 18:35:00.735904
4788	2150	6930	extractedFrom	2022-03-08 18:35:01.126068
4789	2150	6931	extractedFrom	2022-03-08 18:35:01.58603
4790	2150	6932	extractedFrom	2022-03-08 18:35:01.84006
4791	2150	6932	extractedFrom	2022-03-08 18:35:02.002549
4792	1830	6933	extractedFrom	2022-03-08 18:35:02.258512
4793	1830	6934	extractedFrom	2022-03-08 18:35:02.513474
4794	1830	6935	extractedFrom	2022-03-08 18:35:02.914731
4795	1830	6935	extractedFrom	2022-03-08 18:35:03.147578
4796	2896	6936	extractedFrom	2022-03-08 18:35:03.403023
4797	2896	6936	extractedFrom	2022-03-08 18:35:03.614776
4798	3670	6937	extractedFrom	2022-03-08 18:35:03.84872
4799	3670	6937	extractedFrom	2022-03-08 18:35:04.039009
4800	3596	6938	extractedFrom	2022-03-08 18:35:04.681919
4801	3596	6939	extractedFrom	2022-03-08 18:35:04.909158
4802	3596	6940	extractedFrom	2022-03-08 18:35:05.331498
4803	3596	6941	extractedFrom	2022-03-08 18:35:05.696481
4804	3596	6942	extractedFrom	2022-03-08 18:35:06.090199
4805	3596	6943	extractedFrom	2022-03-08 18:35:06.498274
4806	3596	6944	extractedFrom	2022-03-08 18:35:06.796898
4807	3596	6945	extractedFrom	2022-03-08 18:35:07.170289
4808	3596	6945	extractedFrom	2022-03-08 18:35:07.38244
4809	2569	6946	extractedFrom	2022-03-08 18:35:07.677189
4810	2569	6947	extractedFrom	2022-03-08 18:35:07.895583
4811	2569	6947	extractedFrom	2022-03-08 18:35:08.077938
4812	1765	6948	extractedFrom	2022-03-08 18:35:08.526025
4813	1765	6949	extractedFrom	2022-03-08 18:35:08.811016
4814	1765	6949	extractedFrom	2022-03-08 18:35:08.914189
4815	1929	6950	extractedFrom	2022-03-08 18:35:09.294457
4816	1929	6950	extractedFrom	2022-03-08 18:35:09.377462
4817	2248	6951	extractedFrom	2022-03-08 18:35:09.846909
4818	2248	6951	extractedFrom	2022-03-08 18:35:09.935981
4819	1737	6952	extractedFrom	2022-03-08 18:35:10.668781
4820	1737	6953	extractedFrom	2022-03-08 18:35:10.994381
4821	1737	6953	extractedFrom	2022-03-08 18:35:11.057297
4822	2034	6954	extractedFrom	2022-03-08 18:35:11.254212
4823	2034	6954	extractedFrom	2022-03-08 18:35:11.410231
4824	2463	6955	extractedFrom	2022-03-08 18:35:11.611238
4825	2463	6956	extractedFrom	2022-03-08 18:35:11.893727
4826	2463	6957	extractedFrom	2022-03-08 18:35:12.288229
4827	2463	6958	extractedFrom	2022-03-08 18:35:12.458618
4828	2463	6959	extractedFrom	2022-03-08 18:35:12.717087
4829	2463	6959	extractedFrom	2022-03-08 18:35:12.823572
4830	2570	6960	extractedFrom	2022-03-08 18:35:13.254319
4831	2570	6961	extractedFrom	2022-03-08 18:35:13.597137
4832	2570	6961	extractedFrom	2022-03-08 18:35:13.876567
4833	1894	6962	extractedFrom	2022-03-08 18:35:14.092449
4834	1894	6963	extractedFrom	2022-03-08 18:35:14.270389
4835	1894	6964	extractedFrom	2022-03-08 18:35:14.607521
4836	1894	6965	extractedFrom	2022-03-08 18:35:14.802406
4837	1894	6966	extractedFrom	2022-03-08 18:35:14.941393
4838	1894	6967	extractedFrom	2022-03-08 18:35:15.331917
4839	1894	6968	extractedFrom	2022-03-08 18:35:15.498835
4840	1894	6968	extractedFrom	2022-03-08 18:35:15.588675
4841	2515	6969	extractedFrom	2022-03-08 18:35:15.847175
4842	2515	6970	extractedFrom	2022-03-08 18:35:16.289724
4843	2515	6971	extractedFrom	2022-03-08 18:35:16.652148
4844	2515	6972	extractedFrom	2022-03-08 18:35:16.920958
4845	2515	6972	extractedFrom	2022-03-08 18:35:17.119683
4846	2667	6973	extractedFrom	2022-03-08 18:35:17.373182
4847	2667	6974	extractedFrom	2022-03-08 18:35:17.8083
4848	2667	6975	extractedFrom	2022-03-08 18:35:18.043524
4849	2667	6976	extractedFrom	2022-03-08 18:35:18.367322
4850	2667	6977	extractedFrom	2022-03-08 18:35:18.580637
4851	2667	6978	extractedFrom	2022-03-08 18:35:18.992251
4852	2667	6979	extractedFrom	2022-03-08 18:35:19.449061
4853	2667	6980	extractedFrom	2022-03-08 18:35:19.696505
4854	2667	6980	extractedFrom	2022-03-08 18:35:19.82197
4855	2894	6981	extractedFrom	2022-03-08 18:35:20.12011
4856	2894	6982	extractedFrom	2022-03-08 18:35:20.571964
4857	2894	6982	extractedFrom	2022-03-08 18:35:20.857345
4858	3314	6983	extractedFrom	2022-03-08 18:35:21.126252
4859	3314	6984	extractedFrom	2022-03-08 18:35:21.46423
4860	3314	6985	extractedFrom	2022-03-08 18:35:21.714776
4861	3314	6986	extractedFrom	2022-03-08 18:35:21.954124
4862	3314	6987	extractedFrom	2022-03-08 18:35:22.23253
4863	3314	6988	extractedFrom	2022-03-08 18:35:22.496164
4864	3314	6988	extractedFrom	2022-03-08 18:35:22.606922
4865	3031	6989	extractedFrom	2022-03-08 18:35:22.805329
4866	3031	6989	extractedFrom	2022-03-08 18:35:22.90566
4867	3554	6990	extractedFrom	2022-03-08 18:35:23.016097
4868	3554	6990	extractedFrom	2022-03-08 18:35:23.280915
4869	2662	6991	extractedFrom	2022-03-08 18:35:23.522667
4870	2662	6991	extractedFrom	2022-03-08 18:35:23.649088
4871	1941	6992	extractedFrom	2022-03-08 18:35:23.864499
4872	1941	6993	extractedFrom	2022-03-08 18:35:24.039765
4873	1941	6994	extractedFrom	2022-03-08 18:35:24.186747
4874	1941	6994	extractedFrom	2022-03-08 18:35:24.474104
4875	2394	6995	extractedFrom	2022-03-08 18:35:24.800012
4876	2394	6995	extractedFrom	2022-03-08 18:35:24.924611
4877	3167	6996	extractedFrom	2022-03-08 18:35:25.337814
4878	3167	6996	extractedFrom	2022-03-08 18:35:25.477756
4879	1668	6997	extractedFrom	2022-03-08 18:35:25.78729
4880	1668	6997	extractedFrom	2022-03-08 18:35:25.876195
4881	2321	6998	extractedFrom	2022-03-08 18:35:26.13593
4882	2321	6999	extractedFrom	2022-03-08 18:35:26.363498
4883	2321	6999	extractedFrom	2022-03-08 18:35:26.43582
4884	1858	7000	extractedFrom	2022-03-08 18:35:26.871683
4885	1858	7000	extractedFrom	2022-03-08 18:35:26.98236
4886	1729	7001	extractedFrom	2022-03-08 18:35:27.250544
4887	1729	7002	extractedFrom	2022-03-08 18:35:27.45812
4888	1729	7002	extractedFrom	2022-03-08 18:35:27.532326
4889	2028	7003	extractedFrom	2022-03-08 18:35:27.648497
4890	2028	7003	extractedFrom	2022-03-08 18:35:27.702137
4891	2606	7004	extractedFrom	2022-03-08 18:35:27.958035
4892	2606	7005	extractedFrom	2022-03-08 18:35:28.142116
4893	2606	7005	extractedFrom	2022-03-08 18:35:28.327218
4894	1826	7006	extractedFrom	2022-03-08 18:35:28.598474
4895	1826	7007	extractedFrom	2022-03-08 18:35:28.783303
4896	1826	7007	extractedFrom	2022-03-08 18:35:28.861772
4897	2750	7008	extractedFrom	2022-03-08 18:35:29.017155
4898	2750	7008	extractedFrom	2022-03-08 18:35:29.154512
4899	3442	7009	extractedFrom	2022-03-08 18:35:29.437121
4900	3442	7010	extractedFrom	2022-03-08 18:35:29.606075
4901	3442	7010	extractedFrom	2022-03-08 18:35:29.715102
4902	2139	7011	extractedFrom	2022-03-08 18:35:29.938417
4903	2139	7012	extractedFrom	2022-03-08 18:35:30.198027
4904	2139	7013	extractedFrom	2022-03-08 18:35:30.483099
4905	2139	7013	extractedFrom	2022-03-08 18:35:30.600639
4906	1864	7014	extractedFrom	2022-03-08 18:35:30.780798
4907	1864	7015	extractedFrom	2022-03-08 18:35:31.104524
4908	1864	7015	extractedFrom	2022-03-08 18:35:31.198926
4909	3579	7016	extractedFrom	2022-03-08 18:35:31.499553
4910	3579	7016	extractedFrom	2022-03-08 18:35:31.651855
4911	1665	7017	extractedFrom	2022-03-08 18:35:31.771719
4912	1665	7018	extractedFrom	2022-03-08 18:35:31.901925
4913	1665	7019	extractedFrom	2022-03-08 18:35:32.062884
4914	1665	7020	extractedFrom	2022-03-08 18:35:32.212265
4915	1665	7020	extractedFrom	2022-03-08 18:35:32.311533
4916	3584	7021	extractedFrom	2022-03-08 18:35:32.491456
4917	3584	7021	extractedFrom	2022-03-08 18:35:32.582126
4918	3135	7022	extractedFrom	2022-03-08 18:35:33.128539
4919	3135	7022	extractedFrom	2022-03-08 18:35:33.28106
4920	1626	7023	extractedFrom	2022-03-08 18:35:33.492547
4921	1626	7023	extractedFrom	2022-03-08 18:35:33.657613
4922	3546	7024	extractedFrom	2022-03-08 18:35:33.830847
4923	3546	7024	extractedFrom	2022-03-08 18:35:33.961555
4924	1714	7025	extractedFrom	2022-03-08 18:35:34.135017
4925	1714	7025	extractedFrom	2022-03-08 18:35:34.410758
4926	2258	7026	extractedFrom	2022-03-08 18:35:34.706215
4927	2258	7027	extractedFrom	2022-03-08 18:35:34.867596
4928	2258	7028	extractedFrom	2022-03-08 18:35:35.084077
4929	2258	7029	extractedFrom	2022-03-08 18:35:35.312911
4930	2258	7029	extractedFrom	2022-03-08 18:35:35.426172
4931	1566	7030	extractedFrom	2022-03-08 18:35:35.865972
4932	1566	7031	extractedFrom	2022-03-08 18:35:36.086244
4933	1566	7032	extractedFrom	2022-03-08 18:35:36.22097
4934	1566	7032	extractedFrom	2022-03-08 18:35:36.342433
4935	2157	7033	extractedFrom	2022-03-08 18:35:36.523667
4936	2157	7033	extractedFrom	2022-03-08 18:35:36.604295
4937	3347	7034	extractedFrom	2022-03-08 18:35:36.724485
4938	3347	7034	extractedFrom	2022-03-08 18:35:36.809738
4939	1892	7035	extractedFrom	2022-03-08 18:35:37.021102
4940	1892	7036	extractedFrom	2022-03-08 18:35:37.177297
4941	1892	7036	extractedFrom	2022-03-08 18:35:37.256248
4942	3643	7037	extractedFrom	2022-03-08 18:35:37.38262
4943	3643	7038	extractedFrom	2022-03-08 18:35:37.615454
4944	3643	7039	extractedFrom	2022-03-08 18:35:37.864226
4945	3643	7039	extractedFrom	2022-03-08 18:35:37.952791
4946	3465	7040	extractedFrom	2022-03-08 18:35:38.164148
4947	3465	7041	extractedFrom	2022-03-08 18:35:40.955294
4948	3465	7042	extractedFrom	2022-03-08 18:35:41.759062
4949	3465	7043	extractedFrom	2022-03-08 18:35:42.112746
4950	3465	7044	extractedFrom	2022-03-08 18:35:42.389116
4951	3465	7044	extractedFrom	2022-03-08 18:35:42.465198
4952	3398	7045	extractedFrom	2022-03-08 18:35:42.629411
4953	3398	7045	extractedFrom	2022-03-08 18:35:42.705196
4954	1586	7046	extractedFrom	2022-03-08 18:35:42.874749
4955	1586	7047	extractedFrom	2022-03-08 18:35:43.110605
4956	1586	7047	extractedFrom	2022-03-08 18:35:43.280376
4957	2681	7048	extractedFrom	2022-03-08 18:35:43.544621
4958	2681	7048	extractedFrom	2022-03-08 18:35:43.795865
4959	3586	7049	extractedFrom	2022-03-08 18:35:43.988399
4960	3586	7049	extractedFrom	2022-03-08 18:35:44.125844
4961	2013	7050	extractedFrom	2022-03-08 18:35:45.189742
4962	2013	7050	extractedFrom	2022-03-08 18:35:45.294404
4963	2984	7051	extractedFrom	2022-03-08 18:35:45.683343
4964	2984	7052	extractedFrom	2022-03-08 18:35:45.959426
4965	2984	7052	extractedFrom	2022-03-08 18:35:46.033002
4966	3312	7053	extractedFrom	2022-03-08 18:35:46.253531
4967	3312	7054	extractedFrom	2022-03-08 18:35:46.514869
4968	3312	7055	extractedFrom	2022-03-08 18:35:46.653594
4969	3312	7056	extractedFrom	2022-03-08 18:35:46.812527
4970	3312	7057	extractedFrom	2022-03-08 18:35:46.947908
4971	3312	7057	extractedFrom	2022-03-08 18:35:47.257644
4972	3537	7058	extractedFrom	2022-03-08 18:35:48.481871
4973	3537	7059	extractedFrom	2022-03-08 18:35:48.669293
4974	3537	7060	extractedFrom	2022-03-08 18:35:48.860374
4975	3537	7061	extractedFrom	2022-03-08 18:35:49.107183
4976	3537	7062	extractedFrom	2022-03-08 18:35:49.523722
4977	3537	7062	extractedFrom	2022-03-08 18:35:49.590535
4978	1948	7063	extractedFrom	2022-03-08 18:35:49.871896
4979	1948	7064	extractedFrom	2022-03-08 18:35:50.512653
4980	1948	7065	extractedFrom	2022-03-08 18:35:51.356588
4981	1948	7065	extractedFrom	2022-03-08 18:35:51.423988
4982	3504	7066	extractedFrom	2022-03-08 18:35:51.573153
4983	3504	7067	extractedFrom	2022-03-08 18:35:51.905651
4984	3504	7068	extractedFrom	2022-03-08 18:35:52.149361
4985	3504	7068	extractedFrom	2022-03-08 18:35:52.315888
4986	2147	7069	extractedFrom	2022-03-08 18:35:52.583278
4987	2147	7070	extractedFrom	2022-03-08 18:35:52.880089
4988	2147	7071	extractedFrom	2022-03-08 18:35:53.373849
4989	2147	7072	extractedFrom	2022-03-08 18:35:53.778967
4990	2147	7073	extractedFrom	2022-03-08 18:35:54.182035
4991	2147	7073	extractedFrom	2022-03-08 18:35:54.268358
4992	3221	7074	extractedFrom	2022-03-08 18:35:54.425446
4993	3221	7075	extractedFrom	2022-03-08 18:35:54.849327
4994	3221	7075	extractedFrom	2022-03-08 18:35:55.101081
4995	2188	7076	extractedFrom	2022-03-08 18:35:55.428604
4996	2188	7077	extractedFrom	2022-03-08 18:35:55.756774
4997	2188	7077	extractedFrom	2022-03-08 18:35:55.913661
4998	1643	7078	extractedFrom	2022-03-08 18:35:56.290502
4999	1643	7078	extractedFrom	2022-03-08 18:35:56.454532
5000	3611	7079	extractedFrom	2022-03-08 18:35:57.249592
5001	3611	7079	extractedFrom	2022-03-08 18:35:57.537627
5002	2758	7080	extractedFrom	2022-03-08 18:35:57.726165
5003	2758	7080	extractedFrom	2022-03-08 18:35:57.821275
5004	3311	7081	extractedFrom	2022-03-08 18:35:58.058039
5005	3311	7082	extractedFrom	2022-03-08 18:35:58.551073
5006	3311	7083	extractedFrom	2022-03-08 18:35:58.698806
5007	3311	7084	extractedFrom	2022-03-08 18:35:58.903006
5008	3311	7084	extractedFrom	2022-03-08 18:35:59.118536
5009	2174	7085	extractedFrom	2022-03-08 18:35:59.390988
5010	2174	7085	extractedFrom	2022-03-08 18:35:59.467824
5011	2433	7086	extractedFrom	2022-03-08 18:35:59.683237
5012	2433	7087	extractedFrom	2022-03-08 18:35:59.851786
5013	2433	7088	extractedFrom	2022-03-08 18:36:00.017123
5014	2433	7088	extractedFrom	2022-03-08 18:36:00.155931
5015	2063	7089	extractedFrom	2022-03-08 18:36:00.453177
5016	2063	7089	extractedFrom	2022-03-08 18:36:00.584807
5017	1721	7090	extractedFrom	2022-03-08 18:36:01.114912
5018	1721	7091	extractedFrom	2022-03-08 18:36:01.278398
5019	1721	7092	extractedFrom	2022-03-08 18:36:01.571665
5020	1721	7093	extractedFrom	2022-03-08 18:36:01.853295
5021	1721	7094	extractedFrom	2022-03-08 18:36:02.083486
5022	1721	7095	extractedFrom	2022-03-08 18:36:02.306829
5023	1721	7096	extractedFrom	2022-03-08 18:36:02.674029
5024	1721	7097	extractedFrom	2022-03-08 18:36:02.80504
5025	1721	7097	extractedFrom	2022-03-08 18:36:02.892289
5026	2626	7098	extractedFrom	2022-03-08 18:36:03.102144
5027	2626	7098	extractedFrom	2022-03-08 18:36:03.381304
5028	2873	7099	extractedFrom	2022-03-08 18:36:03.600572
5029	2873	7100	extractedFrom	2022-03-08 18:36:03.798822
5030	2873	7100	extractedFrom	2022-03-08 18:36:04.166736
5031	1683	7101	extractedFrom	2022-03-08 18:36:04.43302
5032	1683	7101	extractedFrom	2022-03-08 18:36:04.510923
5033	2183	7102	extractedFrom	2022-03-08 18:36:04.850439
5034	2183	7102	extractedFrom	2022-03-08 18:36:05.072403
5035	3275	7103	extractedFrom	2022-03-08 18:36:05.262388
5036	3275	7104	extractedFrom	2022-03-08 18:36:05.404181
5037	3275	7105	extractedFrom	2022-03-08 18:36:05.606462
5038	3275	7106	extractedFrom	2022-03-08 18:36:05.91184
5039	3275	7106	extractedFrom	2022-03-08 18:36:06.111934
5040	3125	7107	extractedFrom	2022-03-08 18:36:06.327888
5041	3125	7108	extractedFrom	2022-03-08 18:36:06.547985
5042	3125	7108	extractedFrom	2022-03-08 18:36:06.648877
5043	2734	7109	extractedFrom	2022-03-08 18:36:06.814319
5044	2734	7110	extractedFrom	2022-03-08 18:36:07.157224
5045	2734	7110	extractedFrom	2022-03-08 18:36:07.322573
5046	2503	7111	extractedFrom	2022-03-08 18:36:07.810441
5047	2503	7111	extractedFrom	2022-03-08 18:36:07.996939
5048	3194	7112	extractedFrom	2022-03-08 18:36:08.514392
5049	3194	7113	extractedFrom	2022-03-08 18:36:08.778523
5050	3194	7114	extractedFrom	2022-03-08 18:36:09.15676
5051	3194	7114	extractedFrom	2022-03-08 18:36:09.272229
5052	3297	7115	extractedFrom	2022-03-08 18:36:09.445061
5053	3297	7115	extractedFrom	2022-03-08 18:36:09.568417
5054	3356	7116	extractedFrom	2022-03-08 18:36:09.728492
5055	3356	7116	extractedFrom	2022-03-08 18:36:09.841353
5056	1758	7117	extractedFrom	2022-03-08 18:36:10.02768
5057	1758	7117	extractedFrom	2022-03-08 18:36:10.195948
5058	1763	7118	extractedFrom	2022-03-08 18:36:10.407451
5059	1763	7118	extractedFrom	2022-03-08 18:36:10.552212
5060	3573	7119	extractedFrom	2022-03-08 18:36:11.007058
5061	3573	7120	extractedFrom	2022-03-08 18:36:11.31057
5062	3573	7121	extractedFrom	2022-03-08 18:36:11.551347
5063	3573	7122	extractedFrom	2022-03-08 18:36:11.758606
5064	3573	7123	extractedFrom	2022-03-08 18:36:12.126184
5065	3573	7123	extractedFrom	2022-03-08 18:36:12.254868
5066	2417	7124	extractedFrom	2022-03-08 18:36:12.422972
5067	2417	7125	extractedFrom	2022-03-08 18:36:12.851059
5068	2417	7125	extractedFrom	2022-03-08 18:36:12.930836
5069	2006	7126	extractedFrom	2022-03-08 18:36:13.263005
5070	2006	7126	extractedFrom	2022-03-08 18:36:13.531363
5071	2545	7127	extractedFrom	2022-03-08 18:36:13.711467
5072	2545	7128	extractedFrom	2022-03-08 18:36:14.079994
5073	2545	7129	extractedFrom	2022-03-08 18:36:14.338016
5074	2545	7130	extractedFrom	2022-03-08 18:36:14.551287
5075	2545	7131	extractedFrom	2022-03-08 18:36:14.767863
5076	2545	7132	extractedFrom	2022-03-08 18:36:14.99657
5077	2545	7133	extractedFrom	2022-03-08 18:36:15.340316
5078	2545	7134	extractedFrom	2022-03-08 18:36:15.612239
5079	2545	7134	extractedFrom	2022-03-08 18:36:15.791938
5080	3439	7135	extractedFrom	2022-03-08 18:36:15.950936
5081	3439	7135	extractedFrom	2022-03-08 18:36:16.07704
5082	3162	7136	extractedFrom	2022-03-08 18:36:16.269547
5083	3162	7136	extractedFrom	2022-03-08 18:36:16.485412
5084	2068	7137	extractedFrom	2022-03-08 18:36:16.924414
5085	2068	7137	extractedFrom	2022-03-08 18:36:16.999866
5086	3407	7138	extractedFrom	2022-03-08 18:36:17.231192
5087	3407	7139	extractedFrom	2022-03-08 18:36:17.537592
5088	3407	7140	extractedFrom	2022-03-08 18:36:17.693683
5089	3407	7141	extractedFrom	2022-03-08 18:36:18.002466
5090	3407	7142	extractedFrom	2022-03-08 18:36:18.471328
5091	3407	7143	extractedFrom	2022-03-08 18:36:18.992133
5092	3407	7143	extractedFrom	2022-03-08 18:36:19.118163
5093	3459	7144	extractedFrom	2022-03-08 18:36:19.349978
5094	3459	7144	extractedFrom	2022-03-08 18:36:19.515468
5095	2326	7145	extractedFrom	2022-03-08 18:36:19.775079
5096	2326	7146	extractedFrom	2022-03-08 18:36:19.984242
5097	2326	7146	extractedFrom	2022-03-08 18:36:20.116602
5098	2860	7147	extractedFrom	2022-03-08 18:36:20.303299
5099	2860	7148	extractedFrom	2022-03-08 18:36:20.577649
5100	2860	7148	extractedFrom	2022-03-08 18:36:20.6635
5101	2523	7149	extractedFrom	2022-03-08 18:36:20.780546
5102	2523	7149	extractedFrom	2022-03-08 18:36:20.876542
5103	2002	7150	extractedFrom	2022-03-08 18:36:21.102898
5104	2002	7151	extractedFrom	2022-03-08 18:36:21.270498
5105	2002	7151	extractedFrom	2022-03-08 18:36:21.370693
5106	2465	7152	extractedFrom	2022-03-08 18:36:21.581187
5107	2465	7152	extractedFrom	2022-03-08 18:36:21.690521
5108	3108	7153	extractedFrom	2022-03-08 18:36:21.829408
5109	3108	7153	extractedFrom	2022-03-08 18:36:22.008924
5110	3228	7154	extractedFrom	2022-03-08 18:36:22.382801
5111	3228	7154	extractedFrom	2022-03-08 18:36:22.457493
5112	3441	7155	extractedFrom	2022-03-08 18:36:22.747954
5113	3441	7155	extractedFrom	2022-03-08 18:36:22.816355
5114	2837	7156	extractedFrom	2022-03-08 18:36:22.947738
5115	2837	7157	extractedFrom	2022-03-08 18:36:23.40462
5116	2837	7157	extractedFrom	2022-03-08 18:36:23.581421
5117	1660	7158	extractedFrom	2022-03-08 18:36:23.828135
5118	1660	7158	extractedFrom	2022-03-08 18:36:23.914623
5119	3391	7159	extractedFrom	2022-03-08 18:36:24.272801
5120	3391	7160	extractedFrom	2022-03-08 18:36:24.39786
5121	3391	7160	extractedFrom	2022-03-08 18:36:24.473055
5122	2250	7161	extractedFrom	2022-03-08 18:36:24.69953
5123	2250	7161	extractedFrom	2022-03-08 18:36:24.884851
5124	3679	7162	extractedFrom	2022-03-08 18:36:25.072284
5125	3679	7162	extractedFrom	2022-03-08 18:36:25.204764
5126	3026	7163	extractedFrom	2022-03-08 18:36:25.394736
5127	3026	7163	extractedFrom	2022-03-08 18:36:25.501663
5128	2948	7164	extractedFrom	2022-03-08 18:36:25.812861
5129	2948	7164	extractedFrom	2022-03-08 18:36:25.94155
5130	2049	7165	extractedFrom	2022-03-08 18:36:26.132928
5131	2049	7166	extractedFrom	2022-03-08 18:36:26.431154
5132	2049	7166	extractedFrom	2022-03-08 18:36:26.503752
5133	2788	7167	extractedFrom	2022-03-08 18:36:26.736367
5134	2788	7168	extractedFrom	2022-03-08 18:36:27.431193
5135	2788	7169	extractedFrom	2022-03-08 18:36:27.799952
5136	2788	7170	extractedFrom	2022-03-08 18:36:27.971717
5137	2788	7171	extractedFrom	2022-03-08 18:36:28.134252
5138	2788	7171	extractedFrom	2022-03-08 18:36:28.203622
5139	2482	7172	extractedFrom	2022-03-08 18:36:28.439791
5140	2482	7173	extractedFrom	2022-03-08 18:36:28.775346
5141	2482	7173	extractedFrom	2022-03-08 18:36:28.945514
5142	2565	7174	extractedFrom	2022-03-08 18:36:29.251139
5143	2565	7174	extractedFrom	2022-03-08 18:36:29.321215
5144	3384	7175	extractedFrom	2022-03-08 18:36:29.544551
5145	3384	7175	extractedFrom	2022-03-08 18:36:29.657506
5146	2664	7176	extractedFrom	2022-03-08 18:36:29.878548
5147	2664	7176	extractedFrom	2022-03-08 18:36:30.067717
5148	2211	7177	extractedFrom	2022-03-08 18:36:30.361614
5149	2211	7177	extractedFrom	2022-03-08 18:36:30.465454
5150	2462	7178	extractedFrom	2022-03-08 18:36:30.736304
5151	2462	7179	extractedFrom	2022-03-08 18:36:31.039669
5152	2462	7180	extractedFrom	2022-03-08 18:36:31.342287
5153	2462	7181	extractedFrom	2022-03-08 18:36:31.851765
5154	2462	7182	extractedFrom	2022-03-08 18:36:32.26604
5155	2462	7183	extractedFrom	2022-03-08 18:36:32.925097
5156	2462	7184	extractedFrom	2022-03-08 18:36:33.195873
5157	2462	7185	extractedFrom	2022-03-08 18:36:33.699641
5158	2462	7186	extractedFrom	2022-03-08 18:36:34.404426
5159	2462	7187	extractedFrom	2022-03-08 18:36:34.908555
5160	2462	7187	extractedFrom	2022-03-08 18:36:35.171853
5161	2753	7188	extractedFrom	2022-03-08 18:36:35.386112
5162	2753	7188	extractedFrom	2022-03-08 18:36:35.505702
5163	2607	7189	extractedFrom	2022-03-08 18:36:35.90738
5164	2607	7189	extractedFrom	2022-03-08 18:36:36.104918
5165	3664	7190	extractedFrom	2022-03-08 18:36:36.757305
5166	3664	7190	extractedFrom	2022-03-08 18:36:37.08287
5167	2645	7191	extractedFrom	2022-03-08 18:36:37.396622
5168	2645	7191	extractedFrom	2022-03-08 18:36:37.597614
5169	3129	7192	extractedFrom	2022-03-08 18:36:37.974703
5170	3129	7193	extractedFrom	2022-03-08 18:36:38.455684
5171	3129	7193	extractedFrom	2022-03-08 18:36:38.69948
5172	2366	7194	extractedFrom	2022-03-08 18:36:39.072468
5173	2366	7195	extractedFrom	2022-03-08 18:36:39.455329
5174	2366	7195	extractedFrom	2022-03-08 18:36:39.755559
5175	2361	7196	extractedFrom	2022-03-08 18:36:40.426248
5176	2361	7196	extractedFrom	2022-03-08 18:36:40.760642
5177	3571	7197	extractedFrom	2022-03-08 18:36:41.182665
5178	3571	7198	extractedFrom	2022-03-08 18:36:41.565551
5179	3571	7198	extractedFrom	2022-03-08 18:36:41.934476
5180	3260	7199	extractedFrom	2022-03-08 18:36:42.331747
5181	3260	7200	extractedFrom	2022-03-08 18:36:42.825586
5182	3260	7200	extractedFrom	2022-03-08 18:36:43.335809
5183	2729	7201	extractedFrom	2022-03-08 18:36:43.752839
5184	2729	7201	extractedFrom	2022-03-08 18:36:43.927748
5185	2393	7202	extractedFrom	2022-03-08 18:36:44.392368
5186	2393	7203	extractedFrom	2022-03-08 18:36:44.92545
5187	2393	7203	extractedFrom	2022-03-08 18:36:45.070078
5188	2359	7204	extractedFrom	2022-03-08 18:36:45.724518
5189	2359	7204	extractedFrom	2022-03-08 18:36:45.872416
5190	3536	7205	extractedFrom	2022-03-08 18:36:46.133942
5191	3536	7205	extractedFrom	2022-03-08 18:36:46.375621
5192	2309	7206	extractedFrom	2022-03-08 18:36:46.64405
5193	2309	7206	extractedFrom	2022-03-08 18:36:46.746908
5194	3615	7207	extractedFrom	2022-03-08 18:36:47.133695
5195	3615	7207	extractedFrom	2022-03-08 18:36:47.241477
5196	1578	7208	extractedFrom	2022-03-08 18:36:47.566566
5197	1578	7208	extractedFrom	2022-03-08 18:36:47.8007
5198	3541	7209	extractedFrom	2022-03-08 18:36:48.23117
5199	3541	7209	extractedFrom	2022-03-08 18:36:48.514493
5200	3629	7210	extractedFrom	2022-03-08 18:36:48.829902
5201	3629	7210	extractedFrom	2022-03-08 18:36:49.01108
5202	3330	7211	extractedFrom	2022-03-08 18:36:49.401056
5203	3330	7211	extractedFrom	2022-03-08 18:36:49.515099
5204	3142	7212	extractedFrom	2022-03-08 18:36:50.111528
5205	3142	7212	extractedFrom	2022-03-08 18:36:50.365949
5206	3493	7213	extractedFrom	2022-03-08 18:36:50.812173
5207	3493	7214	extractedFrom	2022-03-08 18:36:51.390843
5208	3493	7214	extractedFrom	2022-03-08 18:36:51.586524
5209	3520	7215	extractedFrom	2022-03-08 18:36:51.871161
5210	3520	7215	extractedFrom	2022-03-08 18:36:52.06553
5211	3011	7216	extractedFrom	2022-03-08 18:36:52.392343
5212	3011	7216	extractedFrom	2022-03-08 18:36:52.885132
5213	1709	7217	extractedFrom	2022-03-08 18:36:53.330578
5214	1709	7217	extractedFrom	2022-03-08 18:36:53.587977
5215	2412	7218	extractedFrom	2022-03-08 18:36:53.925172
5216	2412	7218	extractedFrom	2022-03-08 18:36:54.067984
5217	3048	7219	extractedFrom	2022-03-08 18:36:54.358364
5218	3048	7219	extractedFrom	2022-03-08 18:36:54.560541
5219	3227	7220	extractedFrom	2022-03-08 18:36:54.83001
5220	3227	7220	extractedFrom	2022-03-08 18:36:55.344407
5221	2526	7221	extractedFrom	2022-03-08 18:36:55.960615
5222	2526	7221	extractedFrom	2022-03-08 18:36:56.137815
5223	3138	7222	extractedFrom	2022-03-08 18:36:56.645763
5224	3138	7222	extractedFrom	2022-03-08 18:36:56.937332
5225	3034	7223	extractedFrom	2022-03-08 18:36:57.191826
5226	3034	7223	extractedFrom	2022-03-08 18:36:57.409018
5227	2466	7224	extractedFrom	2022-03-08 18:36:57.683141
5228	2466	7225	extractedFrom	2022-03-08 18:36:58.229185
5229	2466	7226	extractedFrom	2022-03-08 18:36:58.685349
5230	2466	7226	extractedFrom	2022-03-08 18:36:58.885859
5231	1964	7227	extractedFrom	2022-03-08 18:36:59.241111
5232	1964	7228	extractedFrom	2022-03-08 18:36:59.366847
5233	1964	7228	extractedFrom	2022-03-08 18:36:59.600088
5234	3263	7229	extractedFrom	2022-03-08 18:37:00.162551
5235	3263	7230	extractedFrom	2022-03-08 18:37:00.578351
5236	3263	7230	extractedFrom	2022-03-08 18:37:00.716142
5237	2032	7231	extractedFrom	2022-03-08 18:37:01.161873
5238	2032	7231	extractedFrom	2022-03-08 18:37:01.850799
5239	2014	7232	extractedFrom	2022-03-08 18:37:02.248149
5240	2014	7232	extractedFrom	2022-03-08 18:37:02.410965
5241	1802	7233	extractedFrom	2022-03-08 18:37:02.630837
5242	1802	7233	extractedFrom	2022-03-08 18:37:02.959165
5243	3091	7234	extractedFrom	2022-03-08 18:37:03.253699
5244	3091	7235	extractedFrom	2022-03-08 18:37:03.645645
5245	3091	7235	extractedFrom	2022-03-08 18:37:03.730518
5246	2030	7236	extractedFrom	2022-03-08 18:37:04.346917
5247	2030	7236	extractedFrom	2022-03-08 18:37:04.538058
5248	2445	7237	extractedFrom	2022-03-08 18:37:04.796143
5249	2445	7237	extractedFrom	2022-03-08 18:37:04.990169
5250	3406	7238	extractedFrom	2022-03-08 18:37:05.637049
5251	3406	7239	extractedFrom	2022-03-08 18:37:06.057161
5252	3406	7239	extractedFrom	2022-03-08 18:37:06.316812
5253	2300	7240	extractedFrom	2022-03-08 18:37:06.918014
5254	2300	7240	extractedFrom	2022-03-08 18:37:07.068924
5255	2037	7241	extractedFrom	2022-03-08 18:37:07.430096
5256	2037	7241	extractedFrom	2022-03-08 18:37:07.593908
5257	2229	7242	extractedFrom	2022-03-08 18:37:07.94444
5258	2229	7242	extractedFrom	2022-03-08 18:37:08.227251
5259	3592	7243	extractedFrom	2022-03-08 18:37:09.055806
5260	3592	7243	extractedFrom	2022-03-08 18:37:09.444484
5261	2703	7244	extractedFrom	2022-03-08 18:37:10.051273
5262	2703	7244	extractedFrom	2022-03-08 18:37:10.858288
5263	2749	7245	extractedFrom	2022-03-08 18:37:11.661754
5264	2749	7245	extractedFrom	2022-03-08 18:37:11.86653
5265	2364	7246	extractedFrom	2022-03-08 18:37:12.083935
5266	2364	7246	extractedFrom	2022-03-08 18:37:12.284303
5267	1974	7247	extractedFrom	2022-03-08 18:37:12.623098
5268	1974	7247	extractedFrom	2022-03-08 18:37:12.761729
5269	2018	7248	extractedFrom	2022-03-08 18:37:12.944457
5270	2018	7249	extractedFrom	2022-03-08 18:37:13.154844
5271	2018	7249	extractedFrom	2022-03-08 18:37:13.453824
5272	2682	7250	extractedFrom	2022-03-08 18:37:13.671045
5273	2682	7250	extractedFrom	2022-03-08 18:37:13.777455
5274	2492	7251	extractedFrom	2022-03-08 18:37:14.221826
5275	2492	7251	extractedFrom	2022-03-08 18:37:14.295266
5276	3082	7252	extractedFrom	2022-03-08 18:37:14.477874
5277	3082	7253	extractedFrom	2022-03-08 18:37:14.652774
5278	3082	7253	extractedFrom	2022-03-08 18:37:14.749906
5279	3689	7254	extractedFrom	2022-03-08 18:37:14.868336
5280	3689	7254	extractedFrom	2022-03-08 18:37:15.037357
5281	3322	7255	extractedFrom	2022-03-08 18:37:15.234463
5282	3322	7256	extractedFrom	2022-03-08 18:37:15.423793
5283	3322	7256	extractedFrom	2022-03-08 18:37:15.561036
5284	3500	7257	extractedFrom	2022-03-08 18:37:16.075716
5285	3500	7257	extractedFrom	2022-03-08 18:37:16.17627
5286	3131	7258	extractedFrom	2022-03-08 18:37:16.360507
5287	3131	7258	extractedFrom	2022-03-08 18:37:16.45772
5288	3463	7259	extractedFrom	2022-03-08 18:37:16.729835
5289	3463	7259	extractedFrom	2022-03-08 18:37:16.820805
5290	3169	7260	extractedFrom	2022-03-08 18:37:17.120474
5291	3169	7260	extractedFrom	2022-03-08 18:37:17.204282
5292	3137	7261	extractedFrom	2022-03-08 18:37:17.349485
5293	3137	7261	extractedFrom	2022-03-08 18:37:17.425005
5294	2584	7262	extractedFrom	2022-03-08 18:37:17.580505
5295	2584	7262	extractedFrom	2022-03-08 18:37:17.682239
5296	2878	7263	extractedFrom	2022-03-08 18:37:17.98312
5297	2878	7263	extractedFrom	2022-03-08 18:37:18.182866
5298	2807	7264	extractedFrom	2022-03-08 18:37:18.509638
5299	2807	7264	extractedFrom	2022-03-08 18:37:18.595486
5300	1678	7265	extractedFrom	2022-03-08 18:37:18.746193
5301	1678	7265	extractedFrom	2022-03-08 18:37:18.895775
5302	2011	7266	extractedFrom	2022-03-08 18:37:19.103085
5303	2011	7266	extractedFrom	2022-03-08 18:37:19.168815
5304	1893	7267	extractedFrom	2022-03-08 18:37:19.487425
5305	1893	7267	extractedFrom	2022-03-08 18:37:19.559153
5306	1575	7268	extractedFrom	2022-03-08 18:37:20.108439
5307	1575	7269	extractedFrom	2022-03-08 18:37:20.248936
5308	1575	7269	extractedFrom	2022-03-08 18:37:20.313924
5309	2659	7270	extractedFrom	2022-03-08 18:37:20.49231
5310	2659	7270	extractedFrom	2022-03-08 18:37:20.669478
5311	2633	7271	extractedFrom	2022-03-08 18:37:20.845066
5312	2633	7272	extractedFrom	2022-03-08 18:37:21.090222
5313	2633	7272	extractedFrom	2022-03-08 18:37:21.268598
5314	3516	7273	extractedFrom	2022-03-08 18:37:21.768284
5315	3516	7273	extractedFrom	2022-03-08 18:37:21.942111
5316	2008	7274	extractedFrom	2022-03-08 18:37:22.472703
5317	2008	7274	extractedFrom	2022-03-08 18:37:22.88166
5318	3525	7275	extractedFrom	2022-03-08 18:37:23.114228
5319	3525	7275	extractedFrom	2022-03-08 18:37:23.233523
5320	3285	7276	extractedFrom	2022-03-08 18:37:23.492065
5321	3285	7276	extractedFrom	2022-03-08 18:37:23.626954
5322	1817	7277	extractedFrom	2022-03-08 18:37:23.966754
5323	1817	7277	extractedFrom	2022-03-08 18:37:24.331486
5324	2080	7278	extractedFrom	2022-03-08 18:37:24.709203
5325	2080	7279	extractedFrom	2022-03-08 18:37:24.87324
5326	2080	7280	extractedFrom	2022-03-08 18:37:25.179846
5327	2080	7281	extractedFrom	2022-03-08 18:37:25.398524
5328	2080	7282	extractedFrom	2022-03-08 18:37:25.643913
5329	2080	7283	extractedFrom	2022-03-08 18:37:25.906061
5330	2080	7284	extractedFrom	2022-03-08 18:37:26.363317
5331	2080	7285	extractedFrom	2022-03-08 18:37:26.700535
5332	2080	7286	extractedFrom	2022-03-08 18:37:26.830658
5333	2080	7286	extractedFrom	2022-03-08 18:37:27.037128
5334	2017	7287	extractedFrom	2022-03-08 18:37:27.287156
5335	2017	7287	extractedFrom	2022-03-08 18:37:27.372785
5336	1775	7288	extractedFrom	2022-03-08 18:37:27.518259
5337	1775	7288	extractedFrom	2022-03-08 18:37:27.602526
5338	1966	7289	extractedFrom	2022-03-08 18:37:28.043944
5339	1966	7290	extractedFrom	2022-03-08 18:37:28.303048
5340	1966	7290	extractedFrom	2022-03-08 18:37:28.494358
5341	3006	7291	extractedFrom	2022-03-08 18:37:28.652397
5342	3006	7291	extractedFrom	2022-03-08 18:37:29.098094
5343	2699	7292	extractedFrom	2022-03-08 18:37:29.317808
5344	2699	7292	extractedFrom	2022-03-08 18:37:29.732931
5345	1613	7293	extractedFrom	2022-03-08 18:37:30.05688
5346	1613	7293	extractedFrom	2022-03-08 18:37:30.258555
5347	1654	7294	extractedFrom	2022-03-08 18:37:30.470632
5348	1654	7294	extractedFrom	2022-03-08 18:37:30.549982
5349	3510	7295	extractedFrom	2022-03-08 18:37:31.260781
5350	3510	7296	extractedFrom	2022-03-08 18:37:31.451937
5351	3510	7296	extractedFrom	2022-03-08 18:37:31.543226
5352	2960	7297	extractedFrom	2022-03-08 18:37:31.78185
5353	2960	7297	extractedFrom	2022-03-08 18:37:31.90278
5354	1724	7298	extractedFrom	2022-03-08 18:37:32.112072
5355	1724	7299	extractedFrom	2022-03-08 18:37:32.338055
5356	1724	7300	extractedFrom	2022-03-08 18:37:32.521861
5357	1724	7301	extractedFrom	2022-03-08 18:37:32.889011
5358	1724	7302	extractedFrom	2022-03-08 18:37:33.172342
5359	1724	7302	extractedFrom	2022-03-08 18:37:33.29607
5360	1549	7303	extractedFrom	2022-03-08 18:37:33.527023
5361	1549	7303	extractedFrom	2022-03-08 18:37:33.630731
5362	2397	7304	extractedFrom	2022-03-08 18:37:34.032809
5363	2397	7305	extractedFrom	2022-03-08 18:37:34.430064
5364	2397	7306	extractedFrom	2022-03-08 18:37:34.629767
5365	2397	7306	extractedFrom	2022-03-08 18:37:34.752427
5366	2999	7307	extractedFrom	2022-03-08 18:37:34.946621
5367	2999	7307	extractedFrom	2022-03-08 18:37:35.117069
5368	2441	7308	extractedFrom	2022-03-08 18:37:35.284999
5369	2441	7308	extractedFrom	2022-03-08 18:37:35.618185
5370	3556	7309	extractedFrom	2022-03-08 18:37:35.844816
5371	3556	7309	extractedFrom	2022-03-08 18:37:35.978171
5372	3396	7310	extractedFrom	2022-03-08 18:37:36.395109
5373	3396	7310	extractedFrom	2022-03-08 18:37:36.548902
5374	1788	7311	extractedFrom	2022-03-08 18:37:36.749645
5375	1788	7311	extractedFrom	2022-03-08 18:37:37.051056
5376	3168	7312	extractedFrom	2022-03-08 18:37:37.233218
5377	3168	7313	extractedFrom	2022-03-08 18:37:37.68026
5378	3168	7314	extractedFrom	2022-03-08 18:37:38.00644
5379	3168	7314	extractedFrom	2022-03-08 18:37:38.212433
5380	1932	7315	extractedFrom	2022-03-08 18:37:38.451252
5381	1932	7315	extractedFrom	2022-03-08 18:37:38.6713
5382	2005	7316	extractedFrom	2022-03-08 18:37:38.863595
5383	2005	7317	extractedFrom	2022-03-08 18:37:39.080378
5384	2005	7317	extractedFrom	2022-03-08 18:37:39.345391
5385	2118	7318	extractedFrom	2022-03-08 18:37:39.589281
5386	2118	7318	extractedFrom	2022-03-08 18:37:39.668623
5387	2372	7319	extractedFrom	2022-03-08 18:37:39.839119
5388	2372	7320	extractedFrom	2022-03-08 18:37:40.1589
5389	2372	7320	extractedFrom	2022-03-08 18:37:40.240121
5390	2899	7321	extractedFrom	2022-03-08 18:37:40.507975
5391	2899	7322	extractedFrom	2022-03-08 18:37:40.689649
5392	2899	7322	extractedFrom	2022-03-08 18:37:40.874093
5393	2329	7323	extractedFrom	2022-03-08 18:37:41.0143
5394	2329	7323	extractedFrom	2022-03-08 18:37:41.19835
5395	2525	7324	extractedFrom	2022-03-08 18:37:41.374113
5396	2525	7324	extractedFrom	2022-03-08 18:37:41.441082
5397	1562	7325	extractedFrom	2022-03-08 18:37:41.713059
5398	1562	7325	extractedFrom	2022-03-08 18:37:41.829025
5399	2081	7326	extractedFrom	2022-03-08 18:37:42.153172
5400	2081	7326	extractedFrom	2022-03-08 18:37:42.250461
5401	2556	7327	extractedFrom	2022-03-08 18:37:42.467031
5402	2556	7328	extractedFrom	2022-03-08 18:37:42.665007
5403	2556	7328	extractedFrom	2022-03-08 18:37:42.739096
5404	1637	7329	extractedFrom	2022-03-08 18:37:42.868215
5405	1637	7329	extractedFrom	2022-03-08 18:37:42.995177
5406	3456	7330	extractedFrom	2022-03-08 18:37:43.19632
5407	3456	7331	extractedFrom	2022-03-08 18:37:43.312125
5408	3456	7332	extractedFrom	2022-03-08 18:37:43.629109
5409	3456	7333	extractedFrom	2022-03-08 18:37:44.006549
5410	3456	7334	extractedFrom	2022-03-08 18:37:44.159363
5411	3456	7335	extractedFrom	2022-03-08 18:37:44.453519
5412	3456	7336	extractedFrom	2022-03-08 18:37:44.969834
5413	3456	7336	extractedFrom	2022-03-08 18:37:45.136967
5414	2502	7337	extractedFrom	2022-03-08 18:37:45.522308
5415	2502	7337	extractedFrom	2022-03-08 18:37:45.601974
5416	2942	7338	extractedFrom	2022-03-08 18:37:45.740158
5417	2942	7338	extractedFrom	2022-03-08 18:37:45.818458
5418	1545	7339	extractedFrom	2022-03-08 18:37:46.05939
5419	1545	7339	extractedFrom	2022-03-08 18:37:46.136502
5420	1965	7340	extractedFrom	2022-03-08 18:37:46.417273
5421	1965	7341	extractedFrom	2022-03-08 18:37:46.579165
5422	1965	7341	extractedFrom	2022-03-08 18:37:46.755102
5423	2007	7342	extractedFrom	2022-03-08 18:37:46.883629
5424	2007	7342	extractedFrom	2022-03-08 18:37:47.088107
5425	2985	7343	extractedFrom	2022-03-08 18:37:47.262847
5426	2985	7344	extractedFrom	2022-03-08 18:37:47.544219
5427	2985	7344	extractedFrom	2022-03-08 18:37:47.671321
5428	2780	7345	extractedFrom	2022-03-08 18:37:47.876855
5429	2780	7345	extractedFrom	2022-03-08 18:37:47.985017
5430	2246	7346	extractedFrom	2022-03-08 18:37:48.447461
5431	2246	7346	extractedFrom	2022-03-08 18:37:48.551254
5432	2782	7347	extractedFrom	2022-03-08 18:37:48.862334
5433	2782	7347	extractedFrom	2022-03-08 18:37:48.93282
5434	3329	7348	extractedFrom	2022-03-08 18:37:49.123424
5435	3329	7348	extractedFrom	2022-03-08 18:37:49.265597
5436	2651	7349	extractedFrom	2022-03-08 18:37:49.51112
5437	2651	7350	extractedFrom	2022-03-08 18:37:49.809001
5438	2651	7350	extractedFrom	2022-03-08 18:37:49.9473
5439	1805	7351	extractedFrom	2022-03-08 18:37:50.124251
5440	1805	7351	extractedFrom	2022-03-08 18:37:50.196627
5441	2336	7352	extractedFrom	2022-03-08 18:37:50.377609
5442	2336	7352	extractedFrom	2022-03-08 18:37:50.425302
5443	1991	7353	extractedFrom	2022-03-08 18:37:50.647923
5444	1991	7354	extractedFrom	2022-03-08 18:37:51.089337
5445	1991	7354	extractedFrom	2022-03-08 18:37:51.20462
5446	2510	7355	extractedFrom	2022-03-08 18:37:51.666288
5447	2510	7356	extractedFrom	2022-03-08 18:37:51.784575
5448	2510	7357	extractedFrom	2022-03-08 18:37:52.007183
5449	2510	7357	extractedFrom	2022-03-08 18:37:52.108003
5450	2296	7358	extractedFrom	2022-03-08 18:37:52.349677
5451	2296	7359	extractedFrom	2022-03-08 18:37:52.580473
5452	2296	7359	extractedFrom	2022-03-08 18:37:52.75627
5453	3645	7360	extractedFrom	2022-03-08 18:37:53.116106
5454	3645	7360	extractedFrom	2022-03-08 18:37:53.322796
5455	3430	7361	extractedFrom	2022-03-08 18:37:53.484282
5456	3430	7362	extractedFrom	2022-03-08 18:37:53.823945
5457	3430	7363	extractedFrom	2022-03-08 18:37:53.986518
5458	3430	7363	extractedFrom	2022-03-08 18:37:54.061837
5459	2031	7364	extractedFrom	2022-03-08 18:37:54.221755
5460	2031	7365	extractedFrom	2022-03-08 18:37:54.433252
5461	2031	7365	extractedFrom	2022-03-08 18:37:54.781522
5462	3332	7366	extractedFrom	2022-03-08 18:37:55.198218
5463	3332	7366	extractedFrom	2022-03-08 18:37:55.331649
5464	3526	7367	extractedFrom	2022-03-08 18:37:55.492615
5465	3526	7367	extractedFrom	2022-03-08 18:37:55.608923
5466	2567	7368	extractedFrom	2022-03-08 18:37:55.724606
5467	2567	7368	extractedFrom	2022-03-08 18:37:55.800063
5468	1635	7369	extractedFrom	2022-03-08 18:37:56.108866
5469	1635	7369	extractedFrom	2022-03-08 18:37:56.365196
5470	3649	7370	extractedFrom	2022-03-08 18:37:56.82952
5471	3649	7370	extractedFrom	2022-03-08 18:37:56.954127
5472	3681	7371	extractedFrom	2022-03-08 18:37:57.226213
5473	3681	7371	extractedFrom	2022-03-08 18:37:57.347915
5474	2544	7372	extractedFrom	2022-03-08 18:37:57.579377
5475	2544	7372	extractedFrom	2022-03-08 18:37:57.665754
5476	3212	7373	extractedFrom	2022-03-08 18:37:58.145392
5477	3212	7373	extractedFrom	2022-03-08 18:37:58.294184
5478	2527	7374	extractedFrom	2022-03-08 18:37:58.634784
5479	2527	7374	extractedFrom	2022-03-08 18:37:58.853908
5480	2210	7375	extractedFrom	2022-03-08 18:37:59.154674
5481	2210	7375	extractedFrom	2022-03-08 18:37:59.250913
5482	3098	7376	extractedFrom	2022-03-08 18:37:59.557014
5483	3098	7376	extractedFrom	2022-03-08 18:37:59.685803
5484	2245	7377	extractedFrom	2022-03-08 18:38:00.226988
5485	2245	7377	extractedFrom	2022-03-08 18:38:00.547949
5486	3464	7378	extractedFrom	2022-03-08 18:38:00.705925
5487	3464	7378	extractedFrom	2022-03-08 18:38:00.780594
5488	3054	7379	extractedFrom	2022-03-08 18:38:01.065424
5489	3054	7379	extractedFrom	2022-03-08 18:38:01.226211
5490	3097	7380	extractedFrom	2022-03-08 18:38:01.483723
5491	3097	7380	extractedFrom	2022-03-08 18:38:01.561813
5492	3052	7381	extractedFrom	2022-03-08 18:38:01.702926
5493	3052	7381	extractedFrom	2022-03-08 18:38:01.79882
5494	2922	7382	extractedFrom	2022-03-08 18:38:02.22686
5495	2922	7383	extractedFrom	2022-03-08 18:38:02.623609
5496	2922	7383	extractedFrom	2022-03-08 18:38:02.756678
5497	1770	7384	extractedFrom	2022-03-08 18:38:02.975598
5498	1770	7384	extractedFrom	2022-03-08 18:38:03.058728
5499	1868	7385	extractedFrom	2022-03-08 18:38:03.346168
5500	1868	7385	extractedFrom	2022-03-08 18:38:03.507359
5501	2491	7386	extractedFrom	2022-03-08 18:38:03.937012
5502	2491	7386	extractedFrom	2022-03-08 18:38:04.074154
5503	2871	7387	extractedFrom	2022-03-08 18:38:04.348267
5504	2871	7388	extractedFrom	2022-03-08 18:38:04.844602
5505	2871	7389	extractedFrom	2022-03-08 18:38:05.289488
5506	2871	7390	extractedFrom	2022-03-08 18:38:05.733587
5507	2871	7391	extractedFrom	2022-03-08 18:38:06.036357
5508	2871	7391	extractedFrom	2022-03-08 18:38:06.135039
5509	1824	7392	extractedFrom	2022-03-08 18:38:06.510869
5510	1824	7393	extractedFrom	2022-03-08 18:38:06.622504
5511	1824	7393	extractedFrom	2022-03-08 18:38:06.704506
5512	2187	7394	extractedFrom	2022-03-08 18:38:06.976687
5513	2187	7395	extractedFrom	2022-03-08 18:38:07.320809
5514	2187	7396	extractedFrom	2022-03-08 18:38:07.548774
5515	2187	7396	extractedFrom	2022-03-08 18:38:07.769694
5516	2399	7397	extractedFrom	2022-03-08 18:38:07.890533
5517	2399	7398	extractedFrom	2022-03-08 18:38:08.103672
5518	2399	7398	extractedFrom	2022-03-08 18:38:08.440722
5519	3032	7399	extractedFrom	2022-03-08 18:38:08.788641
5520	3032	7400	extractedFrom	2022-03-08 18:38:09.199608
5521	3032	7400	extractedFrom	2022-03-08 18:38:09.331404
5522	3478	7401	extractedFrom	2022-03-08 18:38:09.571208
5523	3478	7401	extractedFrom	2022-03-08 18:38:09.682573
5524	2039	7402	extractedFrom	2022-03-08 18:38:09.845577
5525	2039	7402	extractedFrom	2022-03-08 18:38:09.953799
5526	3630	7403	extractedFrom	2022-03-08 18:38:10.211218
5527	3630	7403	extractedFrom	2022-03-08 18:38:10.301737
5528	3462	7404	extractedFrom	2022-03-08 18:38:10.719974
5529	3462	7405	extractedFrom	2022-03-08 18:38:10.860262
5530	3462	7406	extractedFrom	2022-03-08 18:38:11.119535
5531	3462	7407	extractedFrom	2022-03-08 18:38:11.446118
5532	3462	7407	extractedFrom	2022-03-08 18:38:11.518648
5533	2727	7408	extractedFrom	2022-03-08 18:38:11.760838
5534	2727	7409	extractedFrom	2022-03-08 18:38:12.143517
5535	2727	7409	extractedFrom	2022-03-08 18:38:12.320554
5536	3116	7410	extractedFrom	2022-03-08 18:38:12.494219
5537	3116	7410	extractedFrom	2022-03-08 18:38:12.67794
5538	2410	7411	extractedFrom	2022-03-08 18:38:12.961344
5539	2410	7411	extractedFrom	2022-03-08 18:38:13.05959
5540	1688	7412	extractedFrom	2022-03-08 18:38:13.438828
5541	1688	7412	extractedFrom	2022-03-08 18:38:13.634351
5542	2872	7413	extractedFrom	2022-03-08 18:38:14.034533
5543	2872	7413	extractedFrom	2022-03-08 18:38:14.122141
5544	2431	7414	extractedFrom	2022-03-08 18:38:14.479716
5545	2431	7414	extractedFrom	2022-03-08 18:38:14.553255
5546	2331	7415	extractedFrom	2022-03-08 18:38:14.741662
5547	2331	7415	extractedFrom	2022-03-08 18:38:14.829106
5548	2617	7416	extractedFrom	2022-03-08 18:38:14.971929
5549	2617	7416	extractedFrom	2022-03-08 18:38:15.155406
5550	2103	7417	extractedFrom	2022-03-08 18:38:15.288705
5551	2103	7417	extractedFrom	2022-03-08 18:38:15.365719
5552	1710	7418	extractedFrom	2022-03-08 18:38:15.582069
5553	1710	7418	extractedFrom	2022-03-08 18:38:15.740537
5554	2182	7419	extractedFrom	2022-03-08 18:38:16.023176
5555	2182	7419	extractedFrom	2022-03-08 18:38:16.196359
5556	2982	7420	extractedFrom	2022-03-08 18:38:16.500243
5557	2982	7421	extractedFrom	2022-03-08 18:38:16.818547
5558	2982	7421	extractedFrom	2022-03-08 18:38:16.941595
5559	2803	7422	extractedFrom	2022-03-08 18:38:17.172561
5560	2803	7423	extractedFrom	2022-03-08 18:38:17.414587
5561	2803	7423	extractedFrom	2022-03-08 18:38:17.551522
5562	2631	7424	extractedFrom	2022-03-08 18:38:17.812592
5563	2631	7424	extractedFrom	2022-03-08 18:38:17.915859
5564	2446	7425	extractedFrom	2022-03-08 18:38:18.345109
5565	2446	7425	extractedFrom	2022-03-08 18:38:18.432604
5566	1600	7426	extractedFrom	2022-03-08 18:38:18.692708
5567	1600	7427	extractedFrom	2022-03-08 18:38:18.916145
5568	1600	7428	extractedFrom	2022-03-08 18:38:19.162412
5569	1600	7428	extractedFrom	2022-03-08 18:38:19.299945
5570	1741	7429	extractedFrom	2022-03-08 18:38:19.714543
5571	1741	7430	extractedFrom	2022-03-08 18:38:20.03522
5572	1741	7430	extractedFrom	2022-03-08 18:38:20.133224
5573	3009	7431	extractedFrom	2022-03-08 18:38:20.424112
5574	3009	7431	extractedFrom	2022-03-08 18:38:20.518047
5575	2721	7432	extractedFrom	2022-03-08 18:38:20.707855
5576	2721	7432	extractedFrom	2022-03-08 18:38:20.916408
5577	1704	7433	extractedFrom	2022-03-08 18:38:21.226105
5578	1704	7433	extractedFrom	2022-03-08 18:38:21.358889
5579	3133	7434	extractedFrom	2022-03-08 18:38:21.577629
5580	3133	7434	extractedFrom	2022-03-08 18:38:21.777867
5581	3203	7435	extractedFrom	2022-03-08 18:38:22.112718
5582	3203	7435	extractedFrom	2022-03-08 18:38:22.348783
5583	2137	7436	extractedFrom	2022-03-08 18:38:22.695812
5584	2137	7436	extractedFrom	2022-03-08 18:38:22.847877
5585	2161	7437	extractedFrom	2022-03-08 18:38:23.06844
5586	2161	7438	extractedFrom	2022-03-08 18:38:23.42853
5587	2161	7439	extractedFrom	2022-03-08 18:38:23.627492
5588	2161	7440	extractedFrom	2022-03-08 18:38:23.866365
5589	2161	7441	extractedFrom	2022-03-08 18:38:24.054242
5590	2161	7441	extractedFrom	2022-03-08 18:38:24.27508
5591	2494	7442	extractedFrom	2022-03-08 18:38:24.434048
5592	2494	7443	extractedFrom	2022-03-08 18:38:24.598932
5593	2494	7444	extractedFrom	2022-03-08 18:38:24.740704
5594	2494	7445	extractedFrom	2022-03-08 18:38:24.944733
5595	2494	7446	extractedFrom	2022-03-08 18:38:25.163309
5596	2494	7447	extractedFrom	2022-03-08 18:38:25.413635
5597	2494	7448	extractedFrom	2022-03-08 18:38:25.862085
5598	2494	7448	extractedFrom	2022-03-08 18:38:25.966568
5599	2798	7449	extractedFrom	2022-03-08 18:38:26.204295
5600	2798	7450	extractedFrom	2022-03-08 18:38:26.389463
5601	2798	7450	extractedFrom	2022-03-08 18:38:26.4814
5602	3074	7451	extractedFrom	2022-03-08 18:38:26.751167
5603	3074	7451	extractedFrom	2022-03-08 18:38:26.881298
5604	2549	7452	extractedFrom	2022-03-08 18:38:27.286328
5605	2549	7453	extractedFrom	2022-03-08 18:38:27.602251
5606	2549	7454	extractedFrom	2022-03-08 18:38:27.907202
5607	2549	7455	extractedFrom	2022-03-08 18:38:28.200745
5608	2549	7455	extractedFrom	2022-03-08 18:38:28.339889
5609	2136	7456	extractedFrom	2022-03-08 18:38:28.811828
5610	2136	7457	extractedFrom	2022-03-08 18:38:29.072558
5611	2136	7457	extractedFrom	2022-03-08 18:38:29.167773
5612	1990	7458	extractedFrom	2022-03-08 18:38:29.469092
5613	1990	7458	extractedFrom	2022-03-08 18:38:29.621023
5614	3665	7459	extractedFrom	2022-03-08 18:38:29.859916
5615	3665	7459	extractedFrom	2022-03-08 18:38:30.011034
5616	2311	7460	extractedFrom	2022-03-08 18:38:30.446802
5617	2311	7460	extractedFrom	2022-03-08 18:38:30.529613
5618	1942	7461	extractedFrom	2022-03-08 18:38:30.678833
5619	1942	7461	extractedFrom	2022-03-08 18:38:30.774146
5620	1772	7462	extractedFrom	2022-03-08 18:38:31.016709
5621	1772	7463	extractedFrom	2022-03-08 18:38:31.193854
5622	1772	7463	extractedFrom	2022-03-08 18:38:31.333333
5623	1574	7464	extractedFrom	2022-03-08 18:38:31.522631
5624	1574	7464	extractedFrom	2022-03-08 18:38:31.606789
5625	2595	7465	extractedFrom	2022-03-08 18:38:31.840951
5626	2595	7465	extractedFrom	2022-03-08 18:38:31.918124
5627	2585	7466	extractedFrom	2022-03-08 18:38:32.045187
5628	2585	7466	extractedFrom	2022-03-08 18:38:32.142998
5629	2371	7467	extractedFrom	2022-03-08 18:38:32.293829
5630	2371	7467	extractedFrom	2022-03-08 18:38:32.433198
5631	3658	7468	extractedFrom	2022-03-08 18:38:32.80171
5632	3658	7468	extractedFrom	2022-03-08 18:38:32.918621
5633	2426	7469	extractedFrom	2022-03-08 18:38:33.12876
5634	2426	7469	extractedFrom	2022-03-08 18:38:33.260795
5635	2689	7470	extractedFrom	2022-03-08 18:38:33.463619
5636	2689	7470	extractedFrom	2022-03-08 18:38:33.785224
5637	2536	7471	extractedFrom	2022-03-08 18:38:33.98831
5638	2536	7471	extractedFrom	2022-03-08 18:38:34.100552
5639	2048	7472	extractedFrom	2022-03-08 18:38:34.527104
5640	2048	7473	extractedFrom	2022-03-08 18:38:34.732676
5641	2048	7474	extractedFrom	2022-03-08 18:38:34.96454
5642	2048	7474	extractedFrom	2022-03-08 18:38:35.071612
5643	2599	7475	extractedFrom	2022-03-08 18:38:35.411391
5644	2599	7476	extractedFrom	2022-03-08 18:38:35.69084
5645	2599	7476	extractedFrom	2022-03-08 18:38:35.795982
5646	3351	7477	extractedFrom	2022-03-08 18:38:35.935536
5647	3351	7477	extractedFrom	2022-03-08 18:38:36.048906
5648	1804	7478	extractedFrom	2022-03-08 18:38:36.606303
5649	1804	7479	extractedFrom	2022-03-08 18:38:36.791937
5650	1804	7479	extractedFrom	2022-03-08 18:38:36.866708
5651	2702	7480	extractedFrom	2022-03-08 18:38:37.007517
5652	2702	7480	extractedFrom	2022-03-08 18:38:37.11336
5653	2675	7481	extractedFrom	2022-03-08 18:38:37.30767
5654	2675	7481	extractedFrom	2022-03-08 18:38:37.398159
5655	1890	7482	extractedFrom	2022-03-08 18:38:37.551089
5656	1890	7483	extractedFrom	2022-03-08 18:38:37.811132
5657	1890	7484	extractedFrom	2022-03-08 18:38:37.960239
5658	1890	7484	extractedFrom	2022-03-08 18:38:38.066983
5659	3060	7485	extractedFrom	2022-03-08 18:38:38.546698
5660	3060	7485	extractedFrom	2022-03-08 18:38:38.684609
5661	1985	7486	extractedFrom	2022-03-08 18:38:38.807884
5662	1985	7486	extractedFrom	2022-03-08 18:38:38.880126
5663	3367	7487	extractedFrom	2022-03-08 18:38:39.129613
5664	3367	7487	extractedFrom	2022-03-08 18:38:39.268884
5665	2305	7488	extractedFrom	2022-03-08 18:38:39.478239
5666	2305	7489	extractedFrom	2022-03-08 18:38:39.694821
5667	2305	7489	extractedFrom	2022-03-08 18:38:39.832851
5668	3099	7490	extractedFrom	2022-03-08 18:38:40.207144
5669	3099	7490	extractedFrom	2022-03-08 18:38:40.332594
5670	2442	7491	extractedFrom	2022-03-08 18:38:40.519048
5671	2442	7491	extractedFrom	2022-03-08 18:38:40.629428
5672	2219	7492	extractedFrom	2022-03-08 18:38:40.930768
5673	2219	7493	extractedFrom	2022-03-08 18:38:41.439534
5674	2219	7494	extractedFrom	2022-03-08 18:38:41.624331
5675	2219	7495	extractedFrom	2022-03-08 18:38:41.75235
5676	2219	7495	extractedFrom	2022-03-08 18:38:41.853619
5677	2608	7496	extractedFrom	2022-03-08 18:38:42.112
5678	2608	7497	extractedFrom	2022-03-08 18:38:42.25067
5679	2608	7498	extractedFrom	2022-03-08 18:38:42.633967
5680	2608	7499	extractedFrom	2022-03-08 18:38:42.938818
5681	2608	7500	extractedFrom	2022-03-08 18:38:43.20079
5682	2608	7501	extractedFrom	2022-03-08 18:38:43.739131
5683	2608	7501	extractedFrom	2022-03-08 18:38:43.901254
5684	3576	7502	extractedFrom	2022-03-08 18:38:44.044081
5685	3576	7503	extractedFrom	2022-03-08 18:38:44.178643
5686	3576	7503	extractedFrom	2022-03-08 18:38:44.259211
5687	2618	7504	extractedFrom	2022-03-08 18:38:44.500996
5688	2618	7504	extractedFrom	2022-03-08 18:38:44.589133
5689	2213	7505	extractedFrom	2022-03-08 18:38:44.767411
5690	2213	7506	extractedFrom	2022-03-08 18:38:45.255367
5691	2213	7506	extractedFrom	2022-03-08 18:38:45.349749
5692	1757	7507	extractedFrom	2022-03-08 18:38:45.623415
5693	1757	7507	extractedFrom	2022-03-08 18:38:45.741683
5694	2025	7508	extractedFrom	2022-03-08 18:38:45.886131
5695	2025	7508	extractedFrom	2022-03-08 18:38:45.970527
5696	2593	7509	extractedFrom	2022-03-08 18:38:46.186275
5697	2593	7509	extractedFrom	2022-03-08 18:38:46.341795
5698	2876	7510	extractedFrom	2022-03-08 18:38:46.730023
5699	2876	7511	extractedFrom	2022-03-08 18:38:47.338933
5700	2876	7511	extractedFrom	2022-03-08 18:38:47.764497
5701	2970	7512	extractedFrom	2022-03-08 18:38:48.270658
5702	2970	7512	extractedFrom	2022-03-08 18:38:48.513382
5703	3565	7513	extractedFrom	2022-03-08 18:38:49.377005
5704	3565	7513	extractedFrom	2022-03-08 18:38:49.523704
5705	2521	7514	extractedFrom	2022-03-08 18:38:50.084517
5706	2521	7514	extractedFrom	2022-03-08 18:38:50.322369
5707	2131	7515	extractedFrom	2022-03-08 18:38:50.643165
5708	2131	7515	extractedFrom	2022-03-08 18:38:50.795938
5709	2519	7516	extractedFrom	2022-03-08 18:38:51.128671
5710	2519	7516	extractedFrom	2022-03-08 18:38:51.31538
5711	1727	7517	extractedFrom	2022-03-08 18:38:51.655919
5712	1727	7517	extractedFrom	2022-03-08 18:38:51.77257
5713	2673	7518	extractedFrom	2022-03-08 18:38:52.259381
5714	2673	7518	extractedFrom	2022-03-08 18:38:52.477543
5715	1861	7519	extractedFrom	2022-03-08 18:38:53.008388
5716	1861	7520	extractedFrom	2022-03-08 18:38:53.398543
5717	1861	7521	extractedFrom	2022-03-08 18:38:53.679535
5718	1861	7521	extractedFrom	2022-03-08 18:38:53.808241
5719	2918	7522	extractedFrom	2022-03-08 18:38:54.135391
5720	2918	7522	extractedFrom	2022-03-08 18:38:54.248842
5721	2206	7523	extractedFrom	2022-03-08 18:38:54.663504
5722	2206	7523	extractedFrom	2022-03-08 18:38:54.807356
5723	3369	7524	extractedFrom	2022-03-08 18:38:55.235312
5724	3369	7524	extractedFrom	2022-03-08 18:38:55.57523
5725	2469	7525	extractedFrom	2022-03-08 18:38:55.995428
5726	2469	7526	extractedFrom	2022-03-08 18:38:56.318789
5727	2469	7527	extractedFrom	2022-03-08 18:38:56.596624
5728	2469	7527	extractedFrom	2022-03-08 18:38:56.856302
5729	2643	7528	extractedFrom	2022-03-08 18:38:57.143627
5730	2643	7528	extractedFrom	2022-03-08 18:38:57.324215
5731	1923	7529	extractedFrom	2022-03-08 18:38:57.823231
5732	1923	7529	extractedFrom	2022-03-08 18:38:57.882881
5733	1859	7530	extractedFrom	2022-03-08 18:38:58.188574
5734	1859	7530	extractedFrom	2022-03-08 18:38:58.357138
5735	2674	7531	extractedFrom	2022-03-08 18:38:58.601618
5736	2674	7532	extractedFrom	2022-03-08 18:38:59.039824
5737	2674	7532	extractedFrom	2022-03-08 18:38:59.392344
5738	3102	7533	extractedFrom	2022-03-08 18:39:00.049412
5739	3102	7534	extractedFrom	2022-03-08 18:39:00.293209
5740	3102	7535	extractedFrom	2022-03-08 18:39:00.727071
5741	3102	7536	extractedFrom	2022-03-08 18:39:01.328002
5742	3102	7536	extractedFrom	2022-03-08 18:39:01.409434
5743	2520	7537	extractedFrom	2022-03-08 18:39:01.669484
5744	2520	7538	extractedFrom	2022-03-08 18:39:01.824095
5745	2520	7539	extractedFrom	2022-03-08 18:39:02.059664
5746	2520	7539	extractedFrom	2022-03-08 18:39:02.290693
5747	3660	7540	extractedFrom	2022-03-08 18:39:02.784916
5748	3660	7540	extractedFrom	2022-03-08 18:39:02.861629
5749	2543	7541	extractedFrom	2022-03-08 18:39:03.108316
5750	2543	7542	extractedFrom	2022-03-08 18:39:03.261752
5751	2543	7542	extractedFrom	2022-03-08 18:39:03.570071
5752	2756	7543	extractedFrom	2022-03-08 18:39:03.879289
5753	2756	7544	extractedFrom	2022-03-08 18:39:04.071355
5754	2756	7545	extractedFrom	2022-03-08 18:39:04.277422
5755	2756	7546	extractedFrom	2022-03-08 18:39:04.862828
5756	2756	7547	extractedFrom	2022-03-08 18:39:05.326417
5757	2756	7548	extractedFrom	2022-03-08 18:39:05.907236
5758	2756	7549	extractedFrom	2022-03-08 18:39:06.464076
5759	2756	7549	extractedFrom	2022-03-08 18:39:06.572837
5760	2421	7550	extractedFrom	2022-03-08 18:39:06.875461
5761	2421	7551	extractedFrom	2022-03-08 18:39:07.166361
5762	2421	7552	extractedFrom	2022-03-08 18:39:07.381316
5763	2421	7553	extractedFrom	2022-03-08 18:39:07.743807
5764	2421	7553	extractedFrom	2022-03-08 18:39:07.904204
5765	3220	7554	extractedFrom	2022-03-08 18:39:08.181244
5766	3220	7555	extractedFrom	2022-03-08 18:39:08.451884
5767	3220	7555	extractedFrom	2022-03-08 18:39:08.591337
5768	1845	7556	extractedFrom	2022-03-08 18:39:08.885071
5769	1845	7556	extractedFrom	2022-03-08 18:39:08.99351
5770	2804	7557	extractedFrom	2022-03-08 18:39:09.255752
5771	2804	7558	extractedFrom	2022-03-08 18:39:09.388829
5772	2804	7558	extractedFrom	2022-03-08 18:39:09.458232
5773	2323	7559	extractedFrom	2022-03-08 18:39:09.609347
5774	2323	7560	extractedFrom	2022-03-08 18:39:09.907101
5775	2323	7561	extractedFrom	2022-03-08 18:39:10.121853
5776	2323	7562	extractedFrom	2022-03-08 18:39:10.498319
5777	2323	7562	extractedFrom	2022-03-08 18:39:10.688127
5778	3506	7563	extractedFrom	2022-03-08 18:39:10.87055
5779	3506	7564	extractedFrom	2022-03-08 18:39:11.016886
5780	3506	7564	extractedFrom	2022-03-08 18:39:11.111491
5781	2650	7565	extractedFrom	2022-03-08 18:39:11.290606
5782	2650	7566	extractedFrom	2022-03-08 18:39:11.550646
5783	2650	7566	extractedFrom	2022-03-08 18:39:11.626985
5784	2932	7567	extractedFrom	2022-03-08 18:39:11.908577
5785	2932	7567	extractedFrom	2022-03-08 18:39:12.366108
5786	3320	7568	extractedFrom	2022-03-08 18:39:12.561298
5787	3320	7569	extractedFrom	2022-03-08 18:39:12.802361
5788	3320	7569	extractedFrom	2022-03-08 18:39:12.879526
5789	2480	7570	extractedFrom	2022-03-08 18:39:13.217749
5790	2480	7571	extractedFrom	2022-03-08 18:39:13.597081
5791	2480	7572	extractedFrom	2022-03-08 18:39:14.145293
5792	2480	7573	extractedFrom	2022-03-08 18:39:14.361834
5793	2480	7574	extractedFrom	2022-03-08 18:39:14.682752
5794	2480	7575	extractedFrom	2022-03-08 18:39:14.837819
5795	2480	7576	extractedFrom	2022-03-08 18:39:14.978034
5796	2480	7577	extractedFrom	2022-03-08 18:39:15.329007
5797	2480	7577	extractedFrom	2022-03-08 18:39:15.408617
5798	2391	7578	extractedFrom	2022-03-08 18:39:15.701918
5799	2391	7578	extractedFrom	2022-03-08 18:39:15.800068
5800	2857	7579	extractedFrom	2022-03-08 18:39:16.065778
5801	2857	7580	extractedFrom	2022-03-08 18:39:16.236751
5802	2857	7581	extractedFrom	2022-03-08 18:39:16.399387
5803	2857	7582	extractedFrom	2022-03-08 18:39:16.804135
5804	2857	7583	extractedFrom	2022-03-08 18:39:16.949873
5805	2857	7584	extractedFrom	2022-03-08 18:39:17.206328
5806	2857	7585	extractedFrom	2022-03-08 18:39:17.558935
5807	2857	7586	extractedFrom	2022-03-08 18:39:17.837198
5808	2857	7587	extractedFrom	2022-03-08 18:39:18.017777
5809	2857	7588	extractedFrom	2022-03-08 18:39:18.15561
5810	2857	7588	extractedFrom	2022-03-08 18:39:18.26147
5811	2389	7589	extractedFrom	2022-03-08 18:39:18.440867
5812	2389	7589	extractedFrom	2022-03-08 18:39:18.536841
5813	3307	7590	extractedFrom	2022-03-08 18:39:18.785781
5814	3307	7591	extractedFrom	2022-03-08 18:39:18.941659
5815	3307	7592	extractedFrom	2022-03-08 18:39:19.109476
5816	3307	7593	extractedFrom	2022-03-08 18:39:19.364014
5817	3307	7594	extractedFrom	2022-03-08 18:39:19.720754
5818	3307	7595	extractedFrom	2022-03-08 18:39:20.247691
5819	3307	7596	extractedFrom	2022-03-08 18:39:20.577224
5820	3307	7596	extractedFrom	2022-03-08 18:39:20.656733
5821	1761	7597	extractedFrom	2022-03-08 18:39:20.833351
5822	1761	7597	extractedFrom	2022-03-08 18:39:20.915076
5823	1800	7598	extractedFrom	2022-03-08 18:39:21.046418
5824	1800	7598	extractedFrom	2022-03-08 18:39:21.11649
5825	1677	7599	extractedFrom	2022-03-08 18:39:21.310515
5826	1677	7599	extractedFrom	2022-03-08 18:39:21.38407
5827	3302	7600	extractedFrom	2022-03-08 18:39:21.736053
5828	3302	7601	extractedFrom	2022-03-08 18:39:21.998268
5829	3302	7601	extractedFrom	2022-03-08 18:39:22.093301
5830	2522	7602	extractedFrom	2022-03-08 18:39:22.290757
5831	2522	7602	extractedFrom	2022-03-08 18:39:22.502323
5832	3436	7603	extractedFrom	2022-03-08 18:39:22.670118
5833	3436	7604	extractedFrom	2022-03-08 18:39:23.173044
5834	3436	7605	extractedFrom	2022-03-08 18:39:23.530476
5835	3436	7605	extractedFrom	2022-03-08 18:39:23.604213
5836	3666	7606	extractedFrom	2022-03-08 18:39:23.746198
5837	3666	7606	extractedFrom	2022-03-08 18:39:23.8213
5838	3211	7607	extractedFrom	2022-03-08 18:39:24.06998
5839	3211	7607	extractedFrom	2022-03-08 18:39:24.153486
5840	2541	7608	extractedFrom	2022-03-08 18:39:24.461162
5841	2541	7608	extractedFrom	2022-03-08 18:39:24.750703
5842	3514	7609	extractedFrom	2022-03-08 18:39:25.102156
5843	3514	7610	extractedFrom	2022-03-08 18:39:25.21965
5844	3514	7610	extractedFrom	2022-03-08 18:39:25.356062
5845	2738	7611	extractedFrom	2022-03-08 18:39:25.596248
5846	2738	7612	extractedFrom	2022-03-08 18:39:25.786425
5847	2738	7613	extractedFrom	2022-03-08 18:39:26.243282
5848	2738	7613	extractedFrom	2022-03-08 18:39:26.367651
5849	1743	7614	extractedFrom	2022-03-08 18:39:26.630267
5850	1743	7614	extractedFrom	2022-03-08 18:39:26.793154
5851	1699	7615	extractedFrom	2022-03-08 18:39:26.962938
5852	1699	7615	extractedFrom	2022-03-08 18:39:27.097048
5853	3491	7616	extractedFrom	2022-03-08 18:39:27.260464
5854	3491	7617	extractedFrom	2022-03-08 18:39:27.464062
5855	3491	7617	extractedFrom	2022-03-08 18:39:27.711921
5856	3264	7618	extractedFrom	2022-03-08 18:39:27.991753
5857	3264	7619	extractedFrom	2022-03-08 18:39:28.17869
5858	3264	7620	extractedFrom	2022-03-08 18:39:28.418929
5859	3264	7621	extractedFrom	2022-03-08 18:39:28.756311
5860	3264	7622	extractedFrom	2022-03-08 18:39:29.071454
5861	3264	7622	extractedFrom	2022-03-08 18:39:29.191314
5862	1917	7623	extractedFrom	2022-03-08 18:39:29.765891
5863	1917	7624	extractedFrom	2022-03-08 18:39:30.340853
5864	1917	7625	extractedFrom	2022-03-08 18:39:30.665286
5865	1917	7625	extractedFrom	2022-03-08 18:39:30.930436
5866	2912	7626	extractedFrom	2022-03-08 18:39:31.087875
5867	2912	7626	extractedFrom	2022-03-08 18:39:31.181488
5868	3308	7627	extractedFrom	2022-03-08 18:39:31.403715
5869	3308	7628	extractedFrom	2022-03-08 18:39:31.586259
5870	3308	7629	extractedFrom	2022-03-08 18:39:31.942947
5871	3308	7630	extractedFrom	2022-03-08 18:39:32.358233
5872	3308	7630	extractedFrom	2022-03-08 18:39:32.615767
5873	1647	7631	extractedFrom	2022-03-08 18:39:33.208092
5874	1647	7632	extractedFrom	2022-03-08 18:39:33.401341
5875	1647	7632	extractedFrom	2022-03-08 18:39:33.539199
5876	2312	7633	extractedFrom	2022-03-08 18:39:33.691866
5877	2312	7634	extractedFrom	2022-03-08 18:39:33.947001
5878	2312	7634	extractedFrom	2022-03-08 18:39:34.263936
5879	2097	7635	extractedFrom	2022-03-08 18:39:34.466079
5880	2097	7636	extractedFrom	2022-03-08 18:39:34.725429
5881	2097	7637	extractedFrom	2022-03-08 18:39:34.901608
5882	2097	7638	extractedFrom	2022-03-08 18:39:35.349261
5883	2097	7638	extractedFrom	2022-03-08 18:39:35.602797
5884	1922	7639	extractedFrom	2022-03-08 18:39:35.846497
5885	1922	7640	extractedFrom	2022-03-08 18:39:36.285475
5886	1922	7640	extractedFrom	2022-03-08 18:39:36.426901
5887	3394	7641	extractedFrom	2022-03-08 18:39:36.913764
5888	3394	7641	extractedFrom	2022-03-08 18:39:36.968245
5889	3539	7642	extractedFrom	2022-03-08 18:39:37.178873
5890	3539	7642	extractedFrom	2022-03-08 18:39:37.362742
5891	2029	7643	extractedFrom	2022-03-08 18:39:37.565832
5892	2029	7643	extractedFrom	2022-03-08 18:39:37.779018
5893	1884	7644	extractedFrom	2022-03-08 18:39:38.227835
5894	1884	7644	extractedFrom	2022-03-08 18:39:38.368917
5895	1663	7645	extractedFrom	2022-03-08 18:39:38.720396
5896	1663	7645	extractedFrom	2022-03-08 18:39:38.898654
5897	2695	7646	extractedFrom	2022-03-08 18:39:39.218391
5898	2695	7646	extractedFrom	2022-03-08 18:39:39.321271
5899	3633	7647	extractedFrom	2022-03-08 18:39:39.644919
5900	3633	7648	extractedFrom	2022-03-08 18:39:39.772347
5901	3633	7649	extractedFrom	2022-03-08 18:39:40.069194
5902	3633	7650	extractedFrom	2022-03-08 18:39:40.292501
5903	3633	7650	extractedFrom	2022-03-08 18:39:40.387774
5904	3182	7651	extractedFrom	2022-03-08 18:39:40.569359
5905	3182	7652	extractedFrom	2022-03-08 18:39:40.738614
5906	3182	7653	extractedFrom	2022-03-08 18:39:41.102601
5907	3182	7653	extractedFrom	2022-03-08 18:39:41.260094
5908	2838	7654	extractedFrom	2022-03-08 18:39:41.693922
5909	2838	7655	extractedFrom	2022-03-08 18:39:41.915066
5910	2838	7656	extractedFrom	2022-03-08 18:39:42.284638
5911	2838	7656	extractedFrom	2022-03-08 18:39:42.767546
5912	3304	7657	extractedFrom	2022-03-08 18:39:43.153461
5913	3304	7658	extractedFrom	2022-03-08 18:39:43.370169
5914	3304	7659	extractedFrom	2022-03-08 18:39:43.541545
5915	3304	7660	extractedFrom	2022-03-08 18:39:43.669651
5916	3304	7661	extractedFrom	2022-03-08 18:39:44.043881
5917	3304	7662	extractedFrom	2022-03-08 18:39:44.186071
5918	3304	7663	extractedFrom	2022-03-08 18:39:44.454085
5919	3304	7664	extractedFrom	2022-03-08 18:39:44.845125
5920	3304	7665	extractedFrom	2022-03-08 18:39:45.100135
5921	3304	7665	extractedFrom	2022-03-08 18:39:45.186486
5922	3496	7666	extractedFrom	2022-03-08 18:39:45.557968
5923	3496	7667	extractedFrom	2022-03-08 18:39:45.907695
5924	3496	7668	extractedFrom	2022-03-08 18:39:46.358632
5925	3496	7669	extractedFrom	2022-03-08 18:39:46.517629
5926	3496	7669	extractedFrom	2022-03-08 18:39:46.657691
5927	2653	7670	extractedFrom	2022-03-08 18:39:46.842553
5928	2653	7671	extractedFrom	2022-03-08 18:39:47.152194
5929	2653	7672	extractedFrom	2022-03-08 18:39:47.473788
5930	2653	7673	extractedFrom	2022-03-08 18:39:47.867602
5931	2653	7674	extractedFrom	2022-03-08 18:39:48.161039
5932	2653	7675	extractedFrom	2022-03-08 18:39:48.326723
5933	2653	7676	extractedFrom	2022-03-08 18:39:48.590798
5934	2653	7676	extractedFrom	2022-03-08 18:39:48.865866
5935	2817	7677	extractedFrom	2022-03-08 18:39:49.156707
5936	2817	7678	extractedFrom	2022-03-08 18:39:49.420993
5937	2817	7678	extractedFrom	2022-03-08 18:39:49.590391
5938	3051	7679	extractedFrom	2022-03-08 18:39:49.826379
5939	3051	7679	extractedFrom	2022-03-08 18:39:49.918658
5940	2427	7680	extractedFrom	2022-03-08 18:39:50.068461
5941	2427	7681	extractedFrom	2022-03-08 18:39:50.303268
5942	2427	7682	extractedFrom	2022-03-08 18:39:50.576403
5943	2427	7682	extractedFrom	2022-03-08 18:39:50.719567
5944	3552	7683	extractedFrom	2022-03-08 18:39:51.084266
5945	3552	7684	extractedFrom	2022-03-08 18:39:51.24567
5946	3552	7684	extractedFrom	2022-03-08 18:39:51.398148
5947	2775	7685	extractedFrom	2022-03-08 18:39:51.542924
5948	2775	7686	extractedFrom	2022-03-08 18:39:51.719183
5949	2775	7687	extractedFrom	2022-03-08 18:39:52.203739
5950	2775	7687	extractedFrom	2022-03-08 18:39:52.349289
5951	3411	7688	extractedFrom	2022-03-08 18:39:52.846484
5952	3411	7688	extractedFrom	2022-03-08 18:39:53.055681
5953	3242	7689	extractedFrom	2022-03-08 18:39:53.325117
5954	3242	7690	extractedFrom	2022-03-08 18:39:53.673682
5955	3242	7691	extractedFrom	2022-03-08 18:39:54.010436
5956	3242	7692	extractedFrom	2022-03-08 18:39:54.268916
5957	3242	7693	extractedFrom	2022-03-08 18:39:54.437276
5958	3242	7694	extractedFrom	2022-03-08 18:39:54.727913
5959	3242	7694	extractedFrom	2022-03-08 18:39:54.850283
5960	1808	7695	extractedFrom	2022-03-08 18:39:55.297932
5961	1808	7696	extractedFrom	2022-03-08 18:39:55.560618
5962	1808	7697	extractedFrom	2022-03-08 18:39:55.759268
5963	1808	7697	extractedFrom	2022-03-08 18:39:55.933875
5964	3515	7698	extractedFrom	2022-03-08 18:39:56.246715
5965	3515	7699	extractedFrom	2022-03-08 18:39:56.588364
5966	3515	7699	extractedFrom	2022-03-08 18:39:56.686679
5967	3631	7700	extractedFrom	2022-03-08 18:39:56.920151
5968	3631	7701	extractedFrom	2022-03-08 18:39:57.188902
5969	3631	7701	extractedFrom	2022-03-08 18:39:57.309803
5970	2209	7702	extractedFrom	2022-03-08 18:39:57.623059
5971	2209	7703	extractedFrom	2022-03-08 18:39:57.817769
5972	2209	7704	extractedFrom	2022-03-08 18:39:58.061922
5973	2209	7705	extractedFrom	2022-03-08 18:39:58.394141
5974	2209	7706	extractedFrom	2022-03-08 18:39:58.530578
5975	2209	7706	extractedFrom	2022-03-08 18:39:58.651171
5976	2085	7707	extractedFrom	2022-03-08 18:39:59.023436
5977	2085	7707	extractedFrom	2022-03-08 18:39:59.307946
5978	2735	7708	extractedFrom	2022-03-08 18:39:59.444622
5979	2735	7708	extractedFrom	2022-03-08 18:39:59.650112
5980	2337	7709	extractedFrom	2022-03-08 18:39:59.947074
5981	2337	7710	extractedFrom	2022-03-08 18:40:00.216362
5982	2337	7710	extractedFrom	2022-03-08 18:40:00.332131
5983	3219	7711	extractedFrom	2022-03-08 18:40:00.578451
5984	3219	7711	extractedFrom	2022-03-08 18:40:00.861935
5985	3512	7712	extractedFrom	2022-03-08 18:40:01.030772
5986	3512	7713	extractedFrom	2022-03-08 18:40:01.295779
5987	3512	7714	extractedFrom	2022-03-08 18:40:01.597219
5988	3512	7715	extractedFrom	2022-03-08 18:40:01.77607
5989	3512	7716	extractedFrom	2022-03-08 18:40:02.023175
5990	3512	7716	extractedFrom	2022-03-08 18:40:02.101824
5991	2789	7717	extractedFrom	2022-03-08 18:40:02.647152
5992	2789	7718	extractedFrom	2022-03-08 18:40:02.958646
5993	2789	7719	extractedFrom	2022-03-08 18:40:03.187018
5994	2789	7720	extractedFrom	2022-03-08 18:40:03.380977
5995	2789	7721	extractedFrom	2022-03-08 18:40:03.606094
5996	2789	7722	extractedFrom	2022-03-08 18:40:04.110086
5997	2789	7723	extractedFrom	2022-03-08 18:40:04.564364
5998	2789	7723	extractedFrom	2022-03-08 18:40:04.675024
5999	2975	7724	extractedFrom	2022-03-08 18:40:04.875841
6000	2975	7724	extractedFrom	2022-03-08 18:40:05.00479
6001	1711	7725	extractedFrom	2022-03-08 18:40:05.414358
6002	1711	7725	extractedFrom	2022-03-08 18:40:05.89018
6003	2195	7726	extractedFrom	2022-03-08 18:40:06.146251
6004	2195	7727	extractedFrom	2022-03-08 18:40:06.508131
6005	2195	7728	extractedFrom	2022-03-08 18:40:06.750857
6006	2195	7728	extractedFrom	2022-03-08 18:40:06.992703
6007	2099	7729	extractedFrom	2022-03-08 18:40:07.195432
6008	2099	7729	extractedFrom	2022-03-08 18:40:07.29636
6009	1659	7730	extractedFrom	2022-03-08 18:40:07.537898
6010	1659	7730	extractedFrom	2022-03-08 18:40:07.907103
6011	3540	7731	extractedFrom	2022-03-08 18:40:08.188749
6012	3540	7732	extractedFrom	2022-03-08 18:40:08.660742
6013	3540	7733	extractedFrom	2022-03-08 18:40:09.144132
6014	3540	7734	extractedFrom	2022-03-08 18:40:09.330753
6015	3540	7734	extractedFrom	2022-03-08 18:40:09.552375
6016	2547	7735	extractedFrom	2022-03-08 18:40:09.678899
6017	2547	7736	extractedFrom	2022-03-08 18:40:10.227344
6018	2547	7737	extractedFrom	2022-03-08 18:40:10.515679
6019	2547	7738	extractedFrom	2022-03-08 18:40:10.804289
6020	2547	7738	extractedFrom	2022-03-08 18:40:11.141412
6021	2530	7739	extractedFrom	2022-03-08 18:40:11.519197
6022	2530	7739	extractedFrom	2022-03-08 18:40:11.60249
6023	2278	7740	extractedFrom	2022-03-08 18:40:11.79803
6024	2278	7741	extractedFrom	2022-03-08 18:40:12.296655
6025	2278	7741	extractedFrom	2022-03-08 18:40:12.348625
6026	2057	7742	extractedFrom	2022-03-08 18:40:12.571735
6027	2057	7742	extractedFrom	2022-03-08 18:40:12.836303
6028	2490	7743	extractedFrom	2022-03-08 18:40:13.011095
6029	2490	7743	extractedFrom	2022-03-08 18:40:13.174021
6030	2208	7744	extractedFrom	2022-03-08 18:40:13.34314
6031	2208	7745	extractedFrom	2022-03-08 18:40:13.578363
6032	2208	7746	extractedFrom	2022-03-08 18:40:13.975316
6033	2208	7746	extractedFrom	2022-03-08 18:40:14.141164
6034	2795	7747	extractedFrom	2022-03-08 18:40:14.338488
6035	2795	7748	extractedFrom	2022-03-08 18:40:14.505766
6036	2795	7749	extractedFrom	2022-03-08 18:40:14.659412
6037	2795	7750	extractedFrom	2022-03-08 18:40:15.005054
6038	2795	7751	extractedFrom	2022-03-08 18:40:15.193712
6039	2795	7752	extractedFrom	2022-03-08 18:40:15.46534
6040	2795	7753	extractedFrom	2022-03-08 18:40:15.815008
6041	2795	7753	extractedFrom	2022-03-08 18:40:15.900247
6042	2552	7754	extractedFrom	2022-03-08 18:40:16.086425
6043	2552	7755	extractedFrom	2022-03-08 18:40:16.288331
6044	2552	7756	extractedFrom	2022-03-08 18:40:16.448591
6045	2552	7757	extractedFrom	2022-03-08 18:40:16.67009
6046	2552	7758	extractedFrom	2022-03-08 18:40:16.845225
6047	2552	7759	extractedFrom	2022-03-08 18:40:17.068217
6048	2552	7760	extractedFrom	2022-03-08 18:40:17.324679
6049	2552	7760	extractedFrom	2022-03-08 18:40:17.464522
6050	1760	7761	extractedFrom	2022-03-08 18:40:17.803213
6051	1760	7762	extractedFrom	2022-03-08 18:40:18.139544
6052	1760	7762	extractedFrom	2022-03-08 18:40:18.358038
6053	2038	7763	extractedFrom	2022-03-08 18:40:18.520068
6054	2038	7763	extractedFrom	2022-03-08 18:40:18.648659
6055	3271	7764	extractedFrom	2022-03-08 18:40:18.880595
6056	3271	7765	extractedFrom	2022-03-08 18:40:19.15137
6057	3271	7766	extractedFrom	2022-03-08 18:40:19.391674
6058	3271	7766	extractedFrom	2022-03-08 18:40:19.562133
6059	2169	7767	extractedFrom	2022-03-08 18:40:19.734647
6060	2169	7768	extractedFrom	2022-03-08 18:40:19.911529
6061	2169	7769	extractedFrom	2022-03-08 18:40:20.007644
6062	2169	7769	extractedFrom	2022-03-08 18:40:20.086218
6063	2652	7770	extractedFrom	2022-03-08 18:40:20.472147
6064	2652	7771	extractedFrom	2022-03-08 18:40:20.743895
6065	2652	7771	extractedFrom	2022-03-08 18:40:20.946081
6066	3372	7772	extractedFrom	2022-03-08 18:40:21.32255
6067	3372	7772	extractedFrom	2022-03-08 18:40:21.483627
6068	1595	7773	extractedFrom	2022-03-08 18:40:21.784139
6069	1595	7773	extractedFrom	2022-03-08 18:40:21.911844
6070	3191	7774	extractedFrom	2022-03-08 18:40:22.238915
6071	3191	7774	extractedFrom	2022-03-08 18:40:22.337673
6072	3612	7775	extractedFrom	2022-03-08 18:40:22.531981
6073	3612	7775	extractedFrom	2022-03-08 18:40:22.909638
6074	3545	7776	extractedFrom	2022-03-08 18:40:23.137084
6075	3545	7776	extractedFrom	2022-03-08 18:40:23.384704
6076	2179	7777	extractedFrom	2022-03-08 18:40:23.606452
6077	2179	7777	extractedFrom	2022-03-08 18:40:23.723974
6078	3359	7778	extractedFrom	2022-03-08 18:40:24.161795
6079	3359	7778	extractedFrom	2022-03-08 18:40:24.304769
6080	1690	7779	extractedFrom	2022-03-08 18:40:24.549822
6081	1690	7779	extractedFrom	2022-03-08 18:40:24.672279
6082	3198	7780	extractedFrom	2022-03-08 18:40:24.91341
6083	3198	7780	extractedFrom	2022-03-08 18:40:24.996349
6084	2493	7781	extractedFrom	2022-03-08 18:40:25.200855
6085	2493	7781	extractedFrom	2022-03-08 18:40:25.304566
6086	1852	7782	extractedFrom	2022-03-08 18:40:25.62751
6087	1852	7782	extractedFrom	2022-03-08 18:40:25.714229
6088	2452	7783	extractedFrom	2022-03-08 18:40:25.884231
6089	2452	7783	extractedFrom	2022-03-08 18:40:26.054942
6090	1900	7784	extractedFrom	2022-03-08 18:40:26.235619
6091	1900	7785	extractedFrom	2022-03-08 18:40:26.529575
6092	1900	7786	extractedFrom	2022-03-08 18:40:26.788186
6093	1900	7786	extractedFrom	2022-03-08 18:40:27.121982
6094	3590	7787	extractedFrom	2022-03-08 18:40:27.466695
6095	3590	7788	extractedFrom	2022-03-08 18:40:27.663439
6096	3590	7788	extractedFrom	2022-03-08 18:40:27.735772
6097	3041	7789	extractedFrom	2022-03-08 18:40:27.987899
6098	3041	7789	extractedFrom	2022-03-08 18:40:28.106747
6099	1674	7790	extractedFrom	2022-03-08 18:40:28.360758
6100	1674	7790	extractedFrom	2022-03-08 18:40:28.488627
6101	2813	7791	extractedFrom	2022-03-08 18:40:28.972092
6102	2813	7791	extractedFrom	2022-03-08 18:40:29.164174
6103	1820	7792	extractedFrom	2022-03-08 18:40:29.338233
6104	1820	7792	extractedFrom	2022-03-08 18:40:29.45661
6105	2217	7793	extractedFrom	2022-03-08 18:40:29.633452
6106	2217	7793	extractedFrom	2022-03-08 18:40:29.733002
6107	3559	7794	extractedFrom	2022-03-08 18:40:29.99818
6108	3559	7794	extractedFrom	2022-03-08 18:40:30.095995
6109	2413	7795	extractedFrom	2022-03-08 18:40:30.438061
6110	2413	7796	extractedFrom	2022-03-08 18:40:30.64138
6111	2413	7796	extractedFrom	2022-03-08 18:40:30.709182
6112	1728	7797	extractedFrom	2022-03-08 18:40:30.940579
6113	1728	7797	extractedFrom	2022-03-08 18:40:31.015725
6114	2180	7798	extractedFrom	2022-03-08 18:40:31.147398
6115	2180	7799	extractedFrom	2022-03-08 18:40:31.343633
6116	2180	7800	extractedFrom	2022-03-08 18:40:31.596871
6117	2180	7800	extractedFrom	2022-03-08 18:40:31.692067
6118	3256	7801	extractedFrom	2022-03-08 18:40:32.224604
6119	3256	7802	extractedFrom	2022-03-08 18:40:32.501045
6120	3256	7803	extractedFrom	2022-03-08 18:40:32.787141
6121	3256	7804	extractedFrom	2022-03-08 18:40:32.968393
6122	3256	7804	extractedFrom	2022-03-08 18:40:33.083702
6123	2377	7805	extractedFrom	2022-03-08 18:40:33.215348
6124	2377	7805	extractedFrom	2022-03-08 18:40:33.306734
6125	2284	7806	extractedFrom	2022-03-08 18:40:33.588386
6126	2284	7806	extractedFrom	2022-03-08 18:40:33.692428
6127	3148	7807	extractedFrom	2022-03-08 18:40:33.94314
6128	3148	7807	extractedFrom	2022-03-08 18:40:34.028187
6129	2616	7808	extractedFrom	2022-03-08 18:40:34.355996
6130	2616	7808	extractedFrom	2022-03-08 18:40:34.451406
6131	2885	7809	extractedFrom	2022-03-08 18:40:34.705788
6132	2885	7810	extractedFrom	2022-03-08 18:40:34.987539
6133	2885	7810	extractedFrom	2022-03-08 18:40:35.137827
6134	1748	7811	extractedFrom	2022-03-08 18:40:35.611912
6135	1748	7812	extractedFrom	2022-03-08 18:40:36.197931
6136	1748	7812	extractedFrom	2022-03-08 18:40:36.390479
6137	3273	7813	extractedFrom	2022-03-08 18:40:36.550752
6138	3273	7814	extractedFrom	2022-03-08 18:40:36.696861
6139	3273	7815	extractedFrom	2022-03-08 18:40:37.021632
6140	3273	7815	extractedFrom	2022-03-08 18:40:37.134093
6141	3120	7816	extractedFrom	2022-03-08 18:40:37.405712
6142	3120	7816	extractedFrom	2022-03-08 18:40:37.564236
6143	3667	7817	extractedFrom	2022-03-08 18:40:37.841449
6144	3667	7817	extractedFrom	2022-03-08 18:40:38.070298
6145	2760	7818	extractedFrom	2022-03-08 18:40:38.271656
6146	2760	7818	extractedFrom	2022-03-08 18:40:38.397874
6147	2094	7819	extractedFrom	2022-03-08 18:40:38.570668
6148	2094	7819	extractedFrom	2022-03-08 18:40:38.619035
6149	1844	7820	extractedFrom	2022-03-08 18:40:38.809734
6150	1844	7820	extractedFrom	2022-03-08 18:40:38.958256
6151	1987	7821	extractedFrom	2022-03-08 18:40:39.141565
6152	1987	7822	extractedFrom	2022-03-08 18:40:39.568673
6153	1987	7822	extractedFrom	2022-03-08 18:40:39.672532
6154	1588	7823	extractedFrom	2022-03-08 18:40:39.935882
6155	1588	7823	extractedFrom	2022-03-08 18:40:40.007759
6156	2054	7824	extractedFrom	2022-03-08 18:40:40.409739
6157	2054	7825	extractedFrom	2022-03-08 18:40:40.766148
6158	2054	7826	extractedFrom	2022-03-08 18:40:40.912502
6159	2054	7827	extractedFrom	2022-03-08 18:40:41.084722
6160	2054	7827	extractedFrom	2022-03-08 18:40:41.18469
6161	2698	7828	extractedFrom	2022-03-08 18:40:41.309867
6162	2698	7828	extractedFrom	2022-03-08 18:40:41.432497
6163	1607	7829	extractedFrom	2022-03-08 18:40:41.709047
6164	1607	7829	extractedFrom	2022-03-08 18:40:41.864827
6165	1866	7830	extractedFrom	2022-03-08 18:40:42.223113
6166	1866	7831	extractedFrom	2022-03-08 18:40:42.499092
6167	1866	7832	extractedFrom	2022-03-08 18:40:42.655272
6168	1866	7833	extractedFrom	2022-03-08 18:40:43.009194
6169	1866	7834	extractedFrom	2022-03-08 18:40:43.428301
6170	1866	7835	extractedFrom	2022-03-08 18:40:43.605941
6171	1866	7836	extractedFrom	2022-03-08 18:40:43.815351
6172	1866	7837	extractedFrom	2022-03-08 18:40:44.289027
6173	1866	7838	extractedFrom	2022-03-08 18:40:44.4412
6174	1866	7839	extractedFrom	2022-03-08 18:40:44.640981
6175	1866	7839	extractedFrom	2022-03-08 18:40:44.735693
6176	2448	7840	extractedFrom	2022-03-08 18:40:44.894688
6177	2448	7841	extractedFrom	2022-03-08 18:40:45.155078
6178	2448	7842	extractedFrom	2022-03-08 18:40:45.319588
6179	2448	7843	extractedFrom	2022-03-08 18:40:45.526129
6180	2448	7844	extractedFrom	2022-03-08 18:40:45.681246
6181	2448	7845	extractedFrom	2022-03-08 18:40:46.015022
6182	2448	7846	extractedFrom	2022-03-08 18:40:46.43198
6183	2448	7846	extractedFrom	2022-03-08 18:40:46.646353
6184	1752	7847	extractedFrom	2022-03-08 18:40:46.820181
6185	1752	7848	extractedFrom	2022-03-08 18:40:46.957372
6186	1752	7849	extractedFrom	2022-03-08 18:40:47.182118
6187	1752	7849	extractedFrom	2022-03-08 18:40:47.31988
6188	1896	7850	extractedFrom	2022-03-08 18:40:47.483857
6189	1896	7851	extractedFrom	2022-03-08 18:40:47.787316
6190	1896	7852	extractedFrom	2022-03-08 18:40:48.080705
6191	1896	7852	extractedFrom	2022-03-08 18:40:48.450215
6192	2406	7853	extractedFrom	2022-03-08 18:40:48.71309
6193	2406	7854	extractedFrom	2022-03-08 18:40:48.975999
6194	2406	7855	extractedFrom	2022-03-08 18:40:49.175735
6195	2406	7856	extractedFrom	2022-03-08 18:40:49.686208
6196	2406	7857	extractedFrom	2022-03-08 18:40:49.821749
6197	2406	7857	extractedFrom	2022-03-08 18:40:49.915058
6198	2726	7858	extractedFrom	2022-03-08 18:40:50.168232
6199	2726	7859	extractedFrom	2022-03-08 18:40:50.37698
6200	2726	7860	extractedFrom	2022-03-08 18:40:50.648796
6201	2726	7860	extractedFrom	2022-03-08 18:40:50.721817
6202	3316	7861	extractedFrom	2022-03-08 18:40:51.031384
6203	3316	7862	extractedFrom	2022-03-08 18:40:51.192353
6204	3316	7862	extractedFrom	2022-03-08 18:40:51.427961
6205	2320	7863	extractedFrom	2022-03-08 18:40:51.612182
6206	2320	7864	extractedFrom	2022-03-08 18:40:51.774264
6207	2320	7864	extractedFrom	2022-03-08 18:40:51.875582
6208	2149	7865	extractedFrom	2022-03-08 18:40:52.233722
6209	2149	7866	extractedFrom	2022-03-08 18:40:52.36602
6210	2149	7866	extractedFrom	2022-03-08 18:40:52.482624
6211	2050	7867	extractedFrom	2022-03-08 18:40:52.652966
6212	2050	7867	extractedFrom	2022-03-08 18:40:52.739281
6213	2395	7868	extractedFrom	2022-03-08 18:40:52.915617
6214	2395	7868	extractedFrom	2022-03-08 18:40:52.991268
6215	3001	7869	extractedFrom	2022-03-08 18:40:53.193715
6216	3001	7870	extractedFrom	2022-03-08 18:40:53.586795
6217	3001	7871	extractedFrom	2022-03-08 18:40:53.734187
6218	3001	7872	extractedFrom	2022-03-08 18:40:54.235426
6219	3001	7872	extractedFrom	2022-03-08 18:40:54.437678
6220	1740	7873	extractedFrom	2022-03-08 18:40:54.631428
6221	1740	7874	extractedFrom	2022-03-08 18:40:54.913926
6222	1740	7874	extractedFrom	2022-03-08 18:40:54.997693
6223	1629	7875	extractedFrom	2022-03-08 18:40:55.226799
6224	1629	7875	extractedFrom	2022-03-08 18:40:55.310592
6225	2411	7876	extractedFrom	2022-03-08 18:40:55.436659
6226	2411	7877	extractedFrom	2022-03-08 18:40:55.772376
6227	2411	7878	extractedFrom	2022-03-08 18:40:55.928154
6228	2411	7879	extractedFrom	2022-03-08 18:40:56.081948
6229	2411	7880	extractedFrom	2022-03-08 18:40:56.287122
6230	2411	7880	extractedFrom	2022-03-08 18:40:56.628415
6231	3562	7881	extractedFrom	2022-03-08 18:40:56.833811
6232	3562	7881	extractedFrom	2022-03-08 18:40:57.046379
6233	2166	7882	extractedFrom	2022-03-08 18:40:57.351653
6234	2166	7883	extractedFrom	2022-03-08 18:40:57.533124
6235	2166	7884	extractedFrom	2022-03-08 18:40:57.818873
6236	2166	7885	extractedFrom	2022-03-08 18:40:58.029123
6237	2166	7886	extractedFrom	2022-03-08 18:40:58.163725
6238	2166	7887	extractedFrom	2022-03-08 18:40:58.301546
6239	2166	7888	extractedFrom	2022-03-08 18:40:58.568499
6240	2166	7889	extractedFrom	2022-03-08 18:40:58.994912
6241	2166	7890	extractedFrom	2022-03-08 18:40:59.216797
6242	2166	7890	extractedFrom	2022-03-08 18:40:59.314776
6243	3282	7891	extractedFrom	2022-03-08 18:40:59.516589
6244	3282	7891	extractedFrom	2022-03-08 18:40:59.706349
6245	3239	7892	extractedFrom	2022-03-08 18:40:59.874748
6246	3239	7892	extractedFrom	2022-03-08 18:40:59.927435
6247	3560	7893	extractedFrom	2022-03-08 18:41:00.347571
6248	3560	7893	extractedFrom	2022-03-08 18:41:00.433722
6249	3188	7894	extractedFrom	2022-03-08 18:41:00.767857
6250	3188	7895	extractedFrom	2022-03-08 18:41:00.963581
6251	3188	7895	extractedFrom	2022-03-08 18:41:01.061007
6252	1661	7896	extractedFrom	2022-03-08 18:41:01.224296
6253	1661	7896	extractedFrom	2022-03-08 18:41:01.383373
6254	2177	7897	extractedFrom	2022-03-08 18:41:01.741905
6255	2177	7898	extractedFrom	2022-03-08 18:41:01.978328
6256	2177	7898	extractedFrom	2022-03-08 18:41:02.149026
6257	3071	7899	extractedFrom	2022-03-08 18:41:02.439111
6258	3071	7900	extractedFrom	2022-03-08 18:41:02.682219
6259	3071	7901	extractedFrom	2022-03-08 18:41:02.877788
6260	3071	7901	extractedFrom	2022-03-08 18:41:03.008508
6261	2423	7902	extractedFrom	2022-03-08 18:41:03.196422
6262	2423	7903	extractedFrom	2022-03-08 18:41:03.350261
6263	2423	7903	extractedFrom	2022-03-08 18:41:03.432254
6264	1585	7904	extractedFrom	2022-03-08 18:41:03.596136
6265	1585	7904	extractedFrom	2022-03-08 18:41:03.760773
6266	3115	7905	extractedFrom	2022-03-08 18:41:04.245015
6267	3115	7905	extractedFrom	2022-03-08 18:41:04.351979
6268	2741	7906	extractedFrom	2022-03-08 18:41:04.612369
6269	2741	7907	extractedFrom	2022-03-08 18:41:04.775533
6270	2741	7907	extractedFrom	2022-03-08 18:41:04.918756
6271	1860	7908	extractedFrom	2022-03-08 18:41:05.243417
6272	1860	7909	extractedFrom	2022-03-08 18:41:05.874341
6273	1860	7909	extractedFrom	2022-03-08 18:41:06.066913
6274	3249	7910	extractedFrom	2022-03-08 18:41:06.323237
6275	3249	7910	extractedFrom	2022-03-08 18:41:06.448284
6276	1614	7911	extractedFrom	2022-03-08 18:41:06.599734
6277	1614	7911	extractedFrom	2022-03-08 18:41:06.75657
6278	1943	7912	extractedFrom	2022-03-08 18:41:07.02713
6279	1943	7912	extractedFrom	2022-03-08 18:41:07.188829
6280	2093	7913	extractedFrom	2022-03-08 18:41:07.528069
6281	2093	7913	extractedFrom	2022-03-08 18:41:07.662718
6282	2757	7914	extractedFrom	2022-03-08 18:41:07.922069
6283	2757	7914	extractedFrom	2022-03-08 18:41:08.017691
6284	3472	7915	extractedFrom	2022-03-08 18:41:08.267006
6285	3472	7916	extractedFrom	2022-03-08 18:41:08.651632
6286	3472	7917	extractedFrom	2022-03-08 18:41:08.946626
6287	3472	7917	extractedFrom	2022-03-08 18:41:09.06996
6288	2769	7918	extractedFrom	2022-03-08 18:41:09.328604
6289	2769	7919	extractedFrom	2022-03-08 18:41:09.51288
6290	2769	7920	extractedFrom	2022-03-08 18:41:09.662472
6291	2769	7920	extractedFrom	2022-03-08 18:41:09.742577
6292	3245	7921	extractedFrom	2022-03-08 18:41:10.433038
6293	3245	7922	extractedFrom	2022-03-08 18:41:10.599999
6294	3245	7922	extractedFrom	2022-03-08 18:41:10.713805
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, user_id, "timestamp", category, value, description) FROM stdin;
1	\N	2022-03-08 18:19:42.052375	community	citsci	(Citizen Science) A tag for the activities of citizen science, volunteer monitoring, and other forms of organized research in which members of the public engage in the process of scientific investigations:  asking questions, collecting data, and/or interpreting results.
2	\N	2022-03-08 18:19:42.136374	community	TrombottoGeocryology	Trombotto, D., P. Wainstein & L. Arenson, 2014, Guía Terminológica de la Geocriología Sudamericana / Terminological Guide of the South American Geocryology, 1a ed. 128 pp. [Link]
3	\N	2022-03-08 18:19:42.224942	community	missing	A tag for terms related to missing metadata values.
4	\N	2022-03-08 18:19:42.304225	community	EU-ADAPT	EU Climate-ADAPT (The European Climate Adaptation Platform), no date, Glossary, Available from: http://climate-adapt.eea.europa.eu/glossary, Last accessed [26/01/2016
5	\N	2022-03-08 18:19:42.350046	community	UC_San_Diego	A tag that groups terms used in data model work by the University of California San Diego Library
6	\N	2022-03-08 18:19:42.37437	community	IPCC2013	IPCC, 2013: Annex III: Glossary [Planton, S. (ed.)]. In: Climate Change 2013: The Physical Science Basis. Contribution of Working Group I to the Fifth Assessment Report of the Intergovernmental Panel on Climate Change [Stocker, T.F., D. Qin, G.-K. Plattner, M. Tignor, S.K. Allen, J. Boschung, A. Nauels, Y. Xia, V. Bex and P.M. Midgley (eds.)]. Cambridge University Press, Cambridge, United Kingdom and New York, NY, USA. [PDF]
7	\N	2022-03-08 18:19:42.390798	community	UKAntarcticTerms	UK Antarctic Place-names Committee, no date, Generic terms, Available from: http://apc.antarctica.ac.uk/proposals/generic-terms/, Last accessed [26/01/2016].
9	\N	2022-03-08 18:19:42.43314	community	UC_Santa_Barbara	A tag that groups terms used in data model work by the University of California Santa Barbara  Library
10	\N	2022-03-08 18:19:42.455302	community	AustraliaBoM	Terms defined in:\r\n\r\nAustralian Government, Bureau of Meteorology, 2016, Glossary, Available from http://www.bom.gov.au/lam/glossary/, Last accessed [26/01/2016]
11	\N	2022-03-08 18:19:42.485253	community	NOAA-NWS	NOAA (National Oceanic and Atmospheric Administration), 2009, National Weather Service Glossary, Available from: http://w1.weather.gov/glossary/, Last accessed [26/01/2016].
12	\N	2022-03-08 18:19:42.498823	community	DesignSafeExperiment	A hashtag that groups terms used in experimental projects in the Design Safe Ci. \r\n
13	\N	2022-03-08 18:19:42.517129	community	DigitalRocksPortal	A data portal for fast storage and retrieval, sharing, organization and analysis of images of varied porous microstructures. https://www.digitalrocksportal.org/
14	\N	2022-03-08 18:19:42.53219	community	DesignSafeHybrid	A tag that groups terms used in research that combines experiment and #{t: simulation | h1330} in the Design Safe Ci project.
15	\N	2022-03-08 18:19:42.554673	community	PhysicalGeography	Pidwirny M., 2014, PhysicalGeography.net - Glossary of Terms [online], Available at: http://www.physicalgeography.net/glossary.html. [Accessed 07/02/2017].
16	\N	2022-03-08 18:19:42.571333	community	ECCCanada	Environment and Climate Change Canada, 2014, Weather and Meteorology - Glossary, Available from: https://www.ec.gc.ca/meteo-weather/default.asp, Last accessed [26/01/2016].
17	\N	2022-03-08 18:19:42.588187	community	datacite	A tag that denotes terms that relate to the #{k: DataCIte metadata schema | http://schema.datacite.org/ }.
18	\N	2022-03-08 18:19:42.604752	community	University_of_California	
19	\N	2022-03-08 18:19:42.621468	community	computer	A device which helps computation faster
20	\N	2022-03-08 18:19:42.638238	community	WMOMeteoterm	WMO, METEOTERM is available at https://www.wmo.int/pages/prog/lsp/meteoterm_wmo_en.html, Last accessed [26/01/2016].
21	\N	2022-03-08 18:19:42.654674	community	USGSGlaciers	Molnia, B.F., 2004, Glossary of Glacier Terminology. USGS Open-File Report 2004-1216. Available from: http://pubs.usgs.gov/of/2004/1216/a/a.html, last accessed [25/01/2016]. See also http://vulcan.wr.usgs.gov/Glossary/Glaciers/glacier_terminology.html.
22	\N	2022-03-08 18:19:42.671605	community	SPRI	Armstrong T., Roberts B., Swithinbank C., 1966, Illustrated Glossary of Snow and Ice, Scott Polar Research Institute, Special Publication No. 4.
23	\N	2022-03-08 18:19:42.692178	community	Swisseduc	Alean J., Hambrey M., 2015, Photoglossary, Glaciers online [online], Available at: http://www.swisseduc.ch/glaciers/glossary/ [Accessed 07/12/2016].
24	\N	2022-03-08 18:19:42.707474	community	DesignSafeWave	A hashtag that groups terms used in wave research projects in the Design Safe Ci. 
25	\N	2022-03-08 18:19:42.724255	community	NSIDCCryosphere	NSIDC, The National Snow and Ice Data Center glossary is available at https://nsidc.org/cryosphere/glossary, Last accessed [26/01/2016].
26	\N	2022-03-08 18:19:42.741156	community	StructModelArchive	This hashtag groups terms used to describe structural models that are archived in DesignSafe-Ci, and can be reused by others in simulations.
27	\N	2022-03-08 18:19:42.758025	community	IPAPermafrost	van Everdingen, Robert, ed., 2005 (1998 revised May 2005). Multi-language glossary of permafrost and related ground-ice terms. Boulder, CO: National Snow and Ice Data Center/World Data Center for Glaciology. [PDF] This glossary is sponsored by the International Permafrost Association. It is a revised version of Harris et al. (1988) and is available in multiple languages at NSIDC.
28	\N	2022-03-08 18:19:42.778245	community	Bushuyev	Terms defined in:\r\n\r\nBushuyev, A.V., 2004, Sea Ice Nomenclature (draft). JCOMM ETSI 2nd session, 15-17 April 2004, Hamburg, doc.2.5.1(1). [PDF, see Annex VI and Annex VII]. Also Bushuyev, A. V., 1970, Sea Ice Nomenclature, Version 1.0 , WMO. [PDF]
29	\N	2022-03-08 18:19:42.794764	community	WMOHydrology	UNESCO-WMO, 2012, International Glossary of Hydrology, 3rd edition, WMO-No. 385. [Link]
30	\N	2022-03-08 18:19:42.816068	community	GCW	Terms from the World Meteorological Organization, Global Cryosphere Watch glossary which is available at http://globalcryospherewatch.org. Last accessed June 8, 2017.\r\n\r\nThis project is partly funded by NSF - Award ACI 1443085.
31	\N	2022-03-08 18:19:42.832341	community	refdatab	(Reference Database) stores data bout references or citations such as reports, books, magazines and journal articles.
32	\N	2022-03-08 18:19:42.849286	community	IPCC2014	IPCC, 2014: Annex II: Glossary [Agard, J., Schipper, E. L. F., (ed.)]. In: Climate Change 2014: Impacts, Adaptation, and Vulnerability. Contribution of Working Group II to the Fifth Assessment Report of the Intergovernmental Panel on Climate Change [Birkmann, J., Campos, M., Dubeux, C., Nojiri, Y., Olsson, L., Osman-Elasha, B., Pelling, M., Prather, M. J., Rivera-Ferre M. G., Ruppel, O. C., Sallenger, A., Smith, K. R., St. Clair, A. L.,]. Cambridge University Press, Cambridge, United Kingdom and New York, NY, USA. [Link]
33	\N	2022-03-08 18:19:42.866938	community	IHPGlacierMassBalance	Cogley, J. G., R. Hock, L. A. Rasmussen, A. A. Arendt, A. Bauder, R. J. Braithwaite, P. Jansson, G. Kaser, M. Möller, L. Nicholson and M. Zemp, 2011, Glossary of Glacier Mass Balance and Related Terms, IHP-VII Technical Documents in Hydrology No. 86, IACS Contribution No. 2, UNESCO-IHP, Paris. [PDF] [Link]
34	\N	2022-03-08 18:19:42.88255	community	CanadaNCA	Canada National Climate Archive (Government of Canada), 2015, Glossary, Available from: http://climate.weather.gc.ca/glossary_e.html, Last accessed [26/01/2016].
35	\N	2022-03-08 18:19:42.911667	community	DesignSafeSim	A tag that groups terms used in #{t: simulation | h1330} research in the Design Safe Ci project. 
36	\N	2022-03-08 18:19:42.950018	community	ASPECT2012	Terms defined in:\r\n\r\nASPECT (Antarctic Sea Ice Processes and Climate), 2012, Glossary and Image Library, Available from: http://aspect.antarctica.gov.au/home/glossary-and-image-library, Last accessed [26/01/2016].
37	\N	2022-03-08 18:19:43.005638	community	DesignSafeWind	A hashtag to group terms that describe datasets derived from wind experiments in the Design Safe Ci project https://www.designsafe-ci.org.
38	\N	2022-03-08 18:19:43.060457	community	NOAAHydrology	NOAA (National Oceanic and Atmospheric Administration), no date, Glossary of Hydrologic Terms, Available from: http://www.nws.noaa.gov/om/hod/SHManual/SHMan014_glossary.htm, Last accessed [26/01/2016].
39	\N	2022-03-08 18:19:43.109625	community	DesignSafe	A hashtag to group terms used to describe datasets in the Design Safe Ci project #{k: https://www.designsafe-ci.org | https://www.designsafe-ci.org }, a cloud-based environment for research in natural hazards engineering.
40	\N	2022-03-08 18:19:43.1776	community	WMOSeaIce	WMO, 2014, Sea Ice Nomenclature, Volume I (Terminology), edition 1970-2014, WMO Publication No. 259, 121 pp. [PDF]
41	\N	2022-03-08 18:19:43.237373	community	IACSSnow	Fierz, C., Armstrong, R.L., Durand, Y., Etchevers, P., Greene, E., McClung, D.M., Nishimura, K., Satyawali, P.K. and Sokratov, S.A. 2009. The International Classification for Seasonal Snow on the Ground. IHP-VII Technical Documents in Hydrology No 83, IACS Contribution No 1, UNESCO-IHP, Paris. [PDF] [Link]
42	\N	2022-03-08 18:19:43.286283	community	DesignSafeMobileShaker	A hashtag that groups terms used in mobile shaker research projects in the Design Safe Ci.
43	\N	2022-03-08 18:19:43.391989	community	persistence	A tag for persistence policy and commitment statements. 
44	\N	2022-03-08 18:19:43.431173	community	GLIMSGlacier	Rau F., Mauz F., Vogt S., Khalsa S. J. S., Raup B., 2005, GLIMS Regional Center 'Antarctic Peninsula', Illustrated GLIMS Glacier Classification Manual, Glacier Classification Guidance for the GLIMS Glacier Inventory, [online], Available at: https://www.glims.org/MapsAndDocs/assets/GLIMS_Glacier-Classification-Manual_V1_2005-02-10.pdf [Accessed 21/02/2017].
8	\N	2022-03-08 18:19:42.409591	community	AMSglossary	Terms defined in:\r\nAmerican Meteorological Society, 2015. Glossary of Meteorology [online], Available at: http://glossary.ametsoc.org/wiki/Main_Page. [Accessed 27/01/2017].
\.


--
-- Data for Name: term_sets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.term_sets (set_id, term_id) FROM stdin;
\.


--
-- Data for Name: term_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.term_tags (tag_id, term_id) FROM stdin;
30	3779
29	3779
30	3780
40	3780
30	3781
16	3781
30	3782
25	3782
30	3783
27	3783
30	3784
15	3784
30	3785
25	3785
30	3786
30	3787
30	3788
33	3788
30	3789
15	3789
30	3790
30	3791
23	3791
30	3792
15	3792
30	3793
33	3793
30	3794
29	3794
30	3795
8	3795
30	3796
15	3796
30	3797
25	3797
30	3798
27	3798
30	3799
10	3799
30	3800
8	3800
30	3801
15	3801
30	3802
8	3802
30	3803
25	3803
30	3804
23	3804
30	3805
22	3805
30	3806
25	3806
30	3807
30	3808
41	3808
30	3809
33	3809
30	3810
20	3810
30	3811
23	3811
30	3812
8	3812
30	3813
15	3813
30	3814
22	3814
30	3815
29	3815
30	3816
25	3816
30	3817
11	3817
30	3818
20	3818
30	3819
33	3819
30	3820
29	3820
30	3821
8	3821
30	3822
22	3822
30	3823
44	3823
30	3824
28	3824
30	3825
28	3825
30	3826
40	3826
30	3827
16	3827
30	3828
20	3828
30	3829
38	3829
30	3830
11	3830
30	3831
8	3831
30	3832
33	3832
30	3833
25	3833
30	3834
33	3834
30	3835
23	3835
30	3836
15	3836
30	3837
8	3837
30	3838
15	3838
30	3839
25	3839
30	3840
27	3840
30	3841
25	3841
30	3842
41	3842
30	3843
20	3843
30	3844
29	3844
30	3845
2	3845
30	3846
8	3846
30	3847
25	3847
30	3848
30	3849
36	3849
30	3850
40	3850
30	3851
28	3851
30	3852
11	3852
30	3853
16	3853
30	3854
29	3854
30	3855
23	3855
30	3856
8	3856
30	3857
15	3857
30	3858
22	3858
30	3859
25	3859
30	3860
16	3860
30	3861
40	3861
30	3862
28	3862
30	3863
8	3863
30	3864
22	3864
30	3865
8	3865
30	3866
25	3866
30	3867
6	3867
30	3868
28	3868
30	3869
40	3869
30	3870
16	3870
30	3871
33	3871
30	3872
8	3872
30	3873
15	3873
30	3874
20	3874
30	3875
11	3875
30	3876
8	3876
30	3877
8	3877
30	3878
23	3878
30	3879
8	3879
30	3880
8	3880
30	3881
29	3881
30	3882
25	3882
30	3883
33	3883
30	3884
2	3884
30	3885
23	3885
30	3886
22	3886
30	3887
25	3887
30	3888
8	3888
30	3889
15	3889
30	3890
33	3890
30	3891
27	3891
30	3892
2	3892
30	3893
15	3893
30	3894
8	3894
30	3895
30	3896
25	3896
30	3897
23	3897
30	3898
25	3898
30	3899
40	3899
30	3900
28	3900
30	3901
16	3901
30	3902
22	3902
30	3903
34	3903
30	3904
25	3904
30	3905
11	3905
30	3906
33	3906
30	3907
16	3907
30	3908
22	3908
30	3909
33	3909
30	3910
25	3910
30	3911
27	3911
30	3912
15	3912
30	3913
25	3913
30	3914
27	3914
30	3915
2	3915
30	3916
8	3916
30	3917
33	3917
30	3918
23	3918
30	3919
8	3919
30	3920
25	3920
30	3921
30	3922
23	3922
30	3923
27	3923
30	3924
20	3924
30	3925
8	3925
30	3926
25	3926
30	3927
33	3927
30	3928
2	3928
30	3929
23	3929
30	3930
22	3930
30	3931
33	3931
30	3932
27	3932
30	3933
2	3933
30	3934
16	3934
30	3935
40	3935
30	3936
16	3936
30	3937
25	3937
30	3938
27	3938
30	3939
33	3939
30	3940
33	3940
30	3941
8	3941
30	3942
29	3942
30	3943
8	3943
30	3944
7	3944
30	3945
15	3945
30	3946
33	3946
30	3947
2	3947
30	3948
20	3948
30	3949
8	3949
30	3950
15	3950
30	3951
33	3951
30	3952
8	3952
30	3953
25	3953
30	3954
28	3954
30	3955
40	3955
30	3956
8	3956
30	3957
22	3957
30	3958
8	3958
30	3959
25	3959
30	3960
27	3960
30	3961
2	3961
30	3962
33	3962
30	3963
30	3964
11	3964
30	3965
20	3965
30	3966
8	3966
30	3967
8	3967
30	3968
20	3968
30	3969
25	3969
30	3970
29	3970
30	3971
8	3971
30	3972
8	3972
30	3973
8	3973
30	3974
15	3974
30	3975
38	3975
30	3976
36	3976
30	3977
28	3977
30	3978
40	3978
30	3979
11	3979
30	3980
16	3980
30	3981
33	3981
30	3982
33	3982
30	3983
30	3984
6	3984
30	3985
8	3985
30	3986
22	3986
30	3987
29	3987
30	3988
23	3988
30	3989
25	3989
30	3990
41	3990
30	3991
29	3991
30	3992
8	3992
30	3993
22	3993
30	3994
8	3994
30	3995
15	3995
30	3996
33	3996
30	3997
25	3997
30	3998
36	3998
30	3999
16	3999
30	4000
40	4000
30	4001
29	4001
30	4002
22	4002
30	4003
25	4003
30	4004
27	4004
30	4005
2	4005
30	4006
33	4006
30	4007
33	4007
30	4008
8	4008
30	4009
8	4009
30	4010
25	4010
30	4011
40	4011
30	4012
28	4012
30	4013
16	4013
30	4014
8	4014
30	4015
22	4015
30	4016
30	4017
25	4017
30	4018
15	4018
30	4019
41	4019
30	4020
8	4020
30	4021
20	4021
30	4022
8	4022
30	4023
15	4023
30	4024
25	4024
30	4025
36	4025
30	4026
28	4026
30	4027
40	4027
30	4028
16	4028
30	4029
8	4029
30	4030
22	4030
30	4031
33	4031
30	4032
8	4032
30	4033
25	4033
30	4034
33	4034
30	4035
44	4035
30	4036
33	4036
30	4037
23	4037
30	4038
20	4038
30	4039
8	4039
30	4040
25	4040
30	4041
33	4041
30	4042
30	4043
32	4043
30	4044
7	4044
30	4045
29	4045
30	4046
2	4046
30	4047
23	4047
30	4048
15	4048
30	4049
22	4049
30	4050
23	4050
30	4051
25	4051
30	4052
40	4052
30	4053
28	4053
30	4054
16	4054
30	4055
22	4055
30	4056
25	4056
30	4057
30	4058
33	4058
30	4059
32	4059
30	4060
7	4060
30	4061
29	4061
30	4062
23	4062
30	4063
8	4063
30	4064
15	4064
30	4065
22	4065
30	4066
44	4066
30	4067
8	4067
30	4068
8	4068
30	4069
25	4069
30	4070
23	4070
30	4071
38	4071
30	4072
28	4072
30	4073
28	4073
30	4074
11	4074
30	4075
40	4075
30	4076
16	4076
30	4077
8	4077
30	4078
15	4078
30	4079
25	4079
30	4080
27	4080
30	4081
2	4081
30	4082
8	4082
30	4083
15	4083
30	4084
25	4084
30	4085
30	4086
15	4086
30	4087
23	4087
30	4088
8	4088
30	4089
20	4089
30	4090
11	4090
30	4091
6	4091
30	4092
29	4092
30	4093
23	4093
30	4094
8	4094
30	4095
15	4095
30	4096
25	4096
30	4097
33	4097
30	4098
23	4098
30	4099
30	4100
25	4100
30	4101
40	4101
30	4102
28	4102
30	4103
16	4103
30	4104
22	4104
30	4105
11	4105
30	4106
16	4106
30	4107
8	4107
30	4108
33	4108
30	4109
20	4109
30	4110
8	4110
30	4111
33	4111
30	4112
33	4112
30	4113
8	4113
30	4114
25	4114
30	4115
11	4115
30	4116
27	4116
30	4117
2	4117
30	4118
8	4118
30	4119
15	4119
30	4120
23	4120
30	4121
40	4121
30	4122
28	4122
30	4123
16	4123
30	4124
25	4124
30	4125
44	4125
30	4126
8	4126
30	4127
20	4127
30	4128
25	4128
30	4129
30	4130
23	4130
30	4131
15	4131
30	4132
25	4132
30	4133
23	4133
30	4134
23	4134
30	4135
30	4136
25	4136
30	4137
40	4137
30	4138
16	4138
30	4139
23	4139
30	4140
22	4140
30	4141
8	4141
30	4142
32	4142
30	4143
25	4143
30	4144
27	4144
30	4145
20	4145
30	4146
33	4146
30	4147
25	4147
30	4148
27	4148
30	4149
25	4149
30	4150
27	4150
30	4151
30	4152
25	4152
30	4153
33	4153
30	4154
7	4154
30	4155
8	4155
30	4156
22	4156
30	4157
33	4157
30	4158
33	4158
30	4159
8	4159
30	4160
8	4160
30	4161
8	4161
30	4162
16	4162
30	4163
25	4163
30	4164
27	4164
30	4165
33	4165
30	4166
8	4166
30	4167
20	4167
30	4168
8	4168
30	4169
33	4169
30	4170
8	4170
30	4171
29	4171
30	4172
11	4172
30	4173
8	4173
30	4174
8	4174
30	4175
25	4175
30	4176
7	4176
30	4177
15	4177
30	4178
25	4178
30	4179
27	4179
30	4180
28	4180
30	4181
25	4181
30	4182
27	4182
30	4183
8	4183
30	4184
33	4184
30	4185
33	4185
30	4186
25	4186
30	4187
27	4187
30	4188
2	4188
30	4189
8	4189
30	4190
8	4190
30	4191
8	4191
30	4192
40	4192
30	4193
28	4193
30	4194
16	4194
30	4195
15	4195
30	4196
33	4196
30	4197
25	4197
30	4198
20	4198
30	4199
33	4199
30	4200
38	4200
30	4201
33	4201
30	4202
33	4202
30	4203
11	4203
30	4204
8	4204
30	4205
20	4205
30	4206
25	4206
30	4207
27	4207
30	4208
2	4208
30	4209
27	4209
30	4210
25	4210
30	4211
27	4211
30	4212
25	4212
30	4213
27	4213
30	4214
20	4214
30	4215
8	4215
30	4216
27	4216
30	4217
33	4217
30	4218
16	4218
30	4219
33	4219
30	4220
25	4220
30	4221
27	4221
30	4222
33	4222
30	4223
29	4223
30	4224
25	4224
30	4225
27	4225
30	4226
8	4226
30	4227
6	4227
30	4228
23	4228
30	4229
30	4230
29	4230
30	4231
23	4231
30	4232
25	4232
30	4233
22	4233
30	4234
44	4234
30	4235
8	4235
30	4236
8	4236
30	4237
25	4237
30	4238
27	4238
30	4239
2	4239
30	4240
41	4240
30	4241
8	4241
30	4242
30	4243
15	4243
30	4244
8	4244
30	4245
33	4245
30	4246
8	4246
30	4247
15	4247
30	4248
2	4248
30	4249
8	4249
30	4250
25	4250
30	4251
27	4251
30	4252
33	4252
30	4253
33	4253
30	4254
25	4254
30	4255
27	4255
30	4256
8	4256
30	4257
20	4257
30	4258
8	4258
30	4259
27	4259
30	4260
30	4261
25	4261
30	4262
8	4262
30	4263
30	4264
41	4264
30	4265
25	4265
30	4266
8	4266
30	4267
33	4267
30	4268
38	4268
30	4269
11	4269
30	4270
25	4270
30	4271
27	4271
30	4272
25	4272
30	4273
27	4273
30	4274
2	4274
30	4275
8	4275
30	4276
15	4276
30	4277
11	4277
30	4278
8	4278
30	4279
33	4279
30	4280
8	4280
30	4281
25	4281
30	4282
27	4282
30	4283
20	4283
30	4284
8	4284
30	4285
16	4285
30	4286
25	4286
30	4287
16	4287
30	4288
20	4288
30	4289
38	4289
30	4290
11	4290
30	4291
30	4292
27	4292
30	4293
23	4293
30	4294
8	4294
30	4295
41	4295
30	4296
8	4296
30	4297
25	4297
30	4298
20	4298
30	4299
8	4299
30	4300
25	4300
30	4301
27	4301
30	4302
8	4302
30	4303
6	4303
30	4304
8	4304
30	4305
38	4305
30	4306
38	4306
30	4307
8	4307
30	4308
25	4308
30	4309
33	4309
30	4310
20	4310
30	4311
8	4311
30	4312
25	4312
30	4313
41	4313
30	4314
44	4314
30	4315
25	4315
30	4316
22	4316
30	4317
33	4317
30	4318
8	4318
30	4319
25	4319
30	4320
33	4320
30	4321
15	4321
30	4322
25	4322
30	4323
16	4323
30	4324
25	4324
30	4325
27	4325
30	4326
40	4326
30	4327
8	4327
30	4328
8	4328
30	4329
27	4329
30	4330
40	4330
30	4331
16	4331
30	4332
40	4332
30	4333
8	4333
30	4334
25	4334
30	4335
25	4335
30	4336
7	4336
30	4337
22	4337
30	4338
8	4338
30	4339
8	4339
30	4340
23	4340
30	4341
25	4341
30	4342
27	4342
30	4343
33	4343
30	4344
25	4344
30	4345
27	4345
30	4346
25	4346
30	4347
8	4347
30	4348
33	4348
30	4349
28	4349
30	4350
16	4350
30	4351
8	4351
30	4352
15	4352
30	4353
8	4353
30	4354
25	4354
30	4355
20	4355
30	4356
8	4356
30	4357
33	4357
30	4358
25	4358
30	4359
27	4359
30	4360
7	4360
30	4361
8	4361
30	4362
15	4362
30	4363
8	4363
30	4364
15	4364
30	4365
8	4365
30	4366
25	4366
30	4367
27	4367
30	4368
25	4368
30	4369
27	4369
30	4370
16	4370
30	4371
25	4371
30	4372
8	4372
30	4373
25	4373
30	4374
16	4374
30	4375
16	4375
30	4376
25	4376
30	4377
33	4377
30	4378
41	4378
30	4379
23	4379
30	4380
8	4380
30	4381
25	4381
30	4382
41	4382
30	4383
25	4383
30	4384
27	4384
30	4385
41	4385
30	4386
15	4386
30	4387
8	4387
30	4388
8	4388
30	4389
8	4389
30	4390
15	4390
30	4391
33	4391
30	4392
23	4392
30	4393
25	4393
30	4394
30	4395
30	4396
33	4396
30	4397
29	4397
30	4398
23	4398
30	4399
8	4399
30	4400
15	4400
30	4401
6	4401
30	4402
30	4403
23	4403
30	4404
33	4404
30	4405
25	4405
30	4406
27	4406
30	4407
16	4407
30	4408
8	4408
30	4409
25	4409
30	4410
27	4410
30	4411
23	4411
30	4412
8	4412
30	4413
38	4413
30	4414
25	4414
30	4415
25	4415
30	4416
27	4416
30	4417
28	4417
30	4418
25	4418
30	4419
27	4419
30	4420
11	4420
30	4421
25	4421
30	4422
25	4422
30	4423
33	4423
30	4424
8	4424
30	4425
15	4425
30	4426
25	4426
30	4427
8	4427
30	4428
22	4428
30	4429
33	4429
30	4430
11	4430
30	4431
8	4431
30	4432
34	4432
30	4433
25	4433
30	4434
11	4434
30	4435
16	4435
30	4436
33	4436
30	4437
29	4437
30	4438
8	4438
30	4439
15	4439
30	4440
22	4440
30	4441
20	4441
30	4442
8	4442
30	4443
27	4443
30	4444
29	4444
30	4445
23	4445
30	4446
8	4446
30	4447
8	4447
30	4448
32	4448
30	4449
44	4449
30	4450
25	4450
30	4451
27	4451
30	4452
30	4453
8	4453
30	4454
15	4454
30	4455
25	4455
30	4456
27	4456
30	4457
2	4457
30	4458
44	4458
30	4459
30	4460
38	4460
30	4461
25	4461
30	4462
40	4462
30	4463
16	4463
30	4464
28	4464
30	4465
8	4465
30	4466
22	4466
30	4467
25	4467
30	4468
27	4468
30	4469
15	4469
30	4470
33	4470
30	4471
11	4471
30	4472
20	4472
30	4473
8	4473
30	4474
15	4474
30	4475
30	4476
6	4476
30	4477
25	4477
30	4478
27	4478
30	4479
33	4479
30	4480
20	4480
30	4481
8	4481
30	4482
25	4482
30	4483
27	4483
30	4484
2	4484
30	4485
33	4485
30	4486
33	4486
30	4487
41	4487
30	4488
23	4488
30	4489
40	4489
30	4490
8	4490
30	4491
8	4491
30	4492
36	4492
30	4493
28	4493
30	4494
16	4494
30	4495
40	4495
30	4496
25	4496
30	4497
27	4497
30	4498
25	4498
30	4499
20	4499
30	4500
25	4500
30	4501
11	4501
30	4502
29	4502
30	4503
8	4503
30	4504
22	4504
30	4505
16	4505
30	4506
8	4506
30	4507
27	4507
30	4508
8	4508
30	4509
25	4509
30	4510
27	4510
30	4511
38	4511
30	4512
11	4512
30	4513
20	4513
30	4514
29	4514
30	4515
8	4515
30	4516
8	4516
30	4517
33	4517
30	4518
8	4518
30	4519
8	4519
30	4520
25	4520
30	4521
27	4521
30	4522
25	4522
30	4523
27	4523
30	4524
2	4524
30	4525
38	4525
30	4526
11	4526
30	4527
25	4527
30	4528
27	4528
30	4529
25	4529
30	4530
30	4531
33	4531
30	4532
33	4532
30	4533
25	4533
30	4534
8	4534
30	4535
6	4535
30	4536
8	4536
30	4537
29	4537
30	4538
25	4538
30	4539
30	4540
33	4540
30	4541
23	4541
30	4542
8	4542
30	4543
33	4543
30	4544
32	4544
30	4545
8	4545
30	4546
30	4547
38	4547
30	4548
25	4548
30	4549
40	4549
30	4550
28	4550
30	4551
16	4551
30	4552
29	4552
30	4553
8	4553
30	4554
22	4554
30	4555
16	4555
30	4556
2	4556
30	4557
8	4557
30	4558
33	4558
30	4559
8	4559
30	4560
44	4560
30	4561
8	4561
30	4562
33	4562
30	4563
6	4563
30	4564
7	4564
30	4565
15	4565
30	4566
25	4566
30	4567
27	4567
30	4568
2	4568
30	4569
8	4569
30	4570
15	4570
30	4571
25	4571
30	4572
16	4572
30	4573
8	4573
30	4574
11	4574
30	4575
8	4575
30	4576
15	4576
30	4577
8	4577
30	4578
33	4578
30	4579
7	4579
30	4580
38	4580
30	4581
25	4581
30	4582
28	4582
30	4583
40	4583
30	4584
16	4584
30	4585
8	4585
30	4586
22	4586
30	4587
33	4587
30	4588
15	4588
30	4589
23	4589
30	4590
20	4590
30	4591
25	4591
30	4592
22	4592
30	4593
29	4593
30	4594
16	4594
30	4595
38	4595
30	4596
25	4596
30	4597
11	4597
30	4598
40	4598
30	4599
16	4599
30	4600
38	4600
30	4601
11	4601
30	4602
8	4602
30	4603
25	4603
30	4604
27	4604
30	4605
33	4605
30	4606
30	4607
23	4607
30	4608
15	4608
30	4609
33	4609
30	4610
25	4610
30	4611
30	4612
15	4612
30	4613
25	4613
30	4614
27	4614
30	4615
25	4615
30	4616
33	4616
30	4617
25	4617
30	4618
8	4618
30	4619
20	4619
30	4620
25	4620
30	4621
27	4621
30	4622
2	4622
30	4623
8	4623
30	4624
25	4624
30	4625
27	4625
30	4626
8	4626
30	4627
27	4627
30	4628
25	4628
30	4629
27	4629
30	4630
27	4630
30	4631
28	4631
30	4632
25	4632
30	4633
6	4633
30	4634
27	4634
30	4635
2	4635
30	4636
8	4636
30	4637
15	4637
30	4638
25	4638
30	4639
33	4639
30	4640
15	4640
30	4641
16	4641
30	4642
25	4642
30	4643
27	4643
30	4644
2	4644
30	4645
8	4645
30	4646
15	4646
30	4647
25	4647
30	4648
25	4648
30	4649
8	4649
30	4650
25	4650
30	4651
15	4651
30	4652
36	4652
30	4653
25	4653
30	4654
27	4654
30	4655
2	4655
30	4656
7	4656
30	4657
41	4657
30	4658
41	4658
30	4659
38	4659
30	4660
25	4660
30	4661
28	4661
30	4662
25	4662
30	4663
25	4663
30	4664
27	4664
30	4665
2	4665
30	4666
25	4666
30	4667
27	4667
30	4668
27	4668
30	4669
25	4669
30	4670
27	4670
30	4671
25	4671
30	4672
27	4672
30	4673
2	4673
30	4674
25	4674
30	4675
40	4675
30	4676
28	4676
30	4677
16	4677
30	4678
22	4678
30	4679
11	4679
30	4680
33	4680
30	4681
15	4681
30	4682
29	4682
30	4683
20	4683
30	4684
25	4684
30	4685
27	4685
30	4686
25	4686
30	4687
33	4687
30	4688
25	4688
30	4689
27	4689
30	4690
30	4691
44	4691
30	4692
8	4692
30	4693
25	4693
30	4694
2	4694
30	4695
8	4695
30	4696
8	4696
30	4697
20	4697
30	4698
33	4698
30	4699
33	4699
30	4700
28	4700
30	4701
25	4701
30	4702
30	4703
15	4703
30	4704
33	4704
30	4705
30	4706
8	4706
30	4707
8	4707
30	4708
25	4708
30	4709
27	4709
30	4710
27	4710
30	4711
16	4711
30	4712
15	4712
30	4713
40	4713
30	4714
16	4714
30	4715
7	4715
30	4716
25	4716
30	4717
29	4717
30	4718
8	4718
30	4719
23	4719
30	4720
25	4720
30	4721
27	4721
30	4722
27	4722
30	4723
2	4723
30	4724
38	4724
30	4725
40	4725
30	4726
11	4726
30	4727
16	4727
30	4728
8	4728
30	4729
6	4729
30	4730
8	4730
30	4731
25	4731
30	4732
8	4732
30	4733
8	4733
30	4734
33	4734
30	4735
8	4735
30	4736
25	4736
30	4737
30	4738
15	4738
30	4739
25	4739
30	4740
25	4740
30	4741
16	4741
30	4742
40	4742
30	4743
22	4743
30	4744
23	4744
30	4745
8	4745
30	4746
8	4746
30	4747
38	4747
30	4748
11	4748
30	4749
25	4749
30	4750
27	4750
30	4751
25	4751
30	4752
27	4752
30	4753
2	4753
30	4754
38	4754
30	4755
11	4755
30	4756
25	4756
30	4757
11	4757
30	4758
25	4758
30	4759
27	4759
30	4760
25	4760
30	4761
38	4761
30	4762
25	4762
30	4763
40	4763
30	4764
23	4764
30	4765
25	4765
30	4766
8	4766
30	4767
25	4767
30	4768
33	4768
30	4769
33	4769
30	4770
34	4770
30	4771
25	4771
30	4772
8	4772
30	4773
33	4773
30	4774
25	4774
30	4775
27	4775
30	4776
2	4776
30	4777
25	4777
30	4778
11	4778
30	4779
32	4779
30	4780
29	4780
30	4781
27	4781
30	4782
2	4782
30	4783
8	4783
30	4784
15	4784
30	4785
20	4785
30	4786
8	4786
30	4787
16	4787
30	4788
25	4788
30	4789
27	4789
30	4790
25	4790
30	4791
29	4791
30	4792
8	4792
30	4793
15	4793
30	4794
44	4794
30	4795
33	4795
30	4796
25	4796
30	4797
40	4797
30	4798
28	4798
30	4799
16	4799
30	4800
8	4800
30	4801
22	4801
30	4802
25	4802
30	4803
27	4803
30	4804
25	4804
30	4805
22	4805
30	4806
8	4806
30	4807
30	4808
25	4808
30	4809
7	4809
30	4810
23	4810
30	4811
15	4811
30	4812
8	4812
30	4813
41	4813
30	4814
20	4814
30	4815
8	4815
30	4816
33	4816
30	4817
23	4817
30	4818
38	4818
30	4819
11	4819
30	4820
20	4820
30	4821
29	4821
30	4822
8	4822
30	4823
25	4823
30	4824
29	4824
30	4825
8	4825
30	4826
22	4826
30	4827
29	4827
30	4828
15	4828
30	4829
33	4829
30	4830
11	4830
30	4831
8	4831
30	4832
15	4832
30	4833
8	4833
30	4834
25	4834
30	4835
27	4835
30	4836
20	4836
30	4837
25	4837
30	4838
27	4838
30	4839
2	4839
30	4840
8	4840
30	4841
8	4841
30	4842
25	4842
30	4843
8	4843
30	4844
30	4845
25	4845
30	4846
27	4846
30	4847
8	4847
30	4848
33	4848
30	4849
8	4849
30	4850
25	4850
30	4851
27	4851
30	4852
2	4852
30	4853
27	4853
30	4854
8	4854
30	4855
27	4855
30	4856
8	4856
30	4857
15	4857
30	4858
8	4858
30	4859
11	4859
30	4860
25	4860
30	4861
27	4861
30	4862
34	4862
30	4863
25	4863
30	4864
11	4864
30	4865
16	4865
30	4866
8	4866
30	4867
22	4867
30	4868
8	4868
30	4869
25	4869
30	4870
27	4870
30	4871
25	4871
30	4872
33	4872
30	4873
41	4873
30	4874
8	4874
30	4875
15	4875
30	4876
22	4876
30	4877
27	4877
30	4878
2	4878
30	4879
44	4879
30	4880
30	4881
23	4881
30	4882
8	4882
30	4883
25	4883
30	4884
27	4884
30	4885
33	4885
30	4886
41	4886
30	4887
25	4887
30	4888
16	4888
30	4889
8	4889
30	4890
22	4890
30	4891
25	4891
30	4892
41	4892
30	4893
22	4893
30	4894
38	4894
30	4895
40	4895
30	4896
23	4896
30	4897
8	4897
30	4898
8	4898
30	4899
27	4899
30	4900
27	4900
30	4901
2	4901
30	4902
15	4902
30	4903
25	4903
30	4904
41	4904
30	4905
29	4905
30	4906
8	4906
30	4907
41	4907
30	4908
25	4908
30	4909
25	4909
30	4910
27	4910
30	4911
2	4911
30	4912
11	4912
30	4913
25	4913
30	4914
25	4914
30	4915
27	4915
30	4916
2	4916
30	4917
33	4917
30	4918
11	4918
30	4919
38	4919
30	4920
25	4920
30	4921
33	4921
30	4922
38	4922
30	4923
27	4923
30	4924
7	4924
30	4925
27	4925
30	4926
25	4926
30	4927
22	4927
30	4928
25	4928
30	4929
40	4929
30	4930
16	4930
30	4931
7	4931
30	4932
23	4932
30	4933
8	4933
30	4934
22	4934
30	4935
8	4935
30	4936
41	4936
30	4937
25	4937
30	4938
40	4938
30	4939
16	4939
30	4940
22	4940
30	4941
40	4941
30	4942
28	4942
30	4943
8	4943
30	4944
16	4944
30	4945
40	4945
30	4946
28	4946
30	4947
25	4947
30	4948
27	4948
30	4949
2	4949
30	4950
15	4950
30	4951
33	4951
30	4952
15	4952
30	4953
33	4953
30	4954
27	4954
30	4955
15	4955
30	4956
25	4956
30	4957
27	4957
30	4958
2	4958
30	4959
8	4959
30	4960
25	4960
30	4961
23	4961
30	4962
40	4962
30	4963
28	4963
30	4964
16	4964
30	4965
8	4965
30	4966
33	4966
30	4967
23	4967
30	4968
8	4968
30	4969
33	4969
30	4970
8	4970
30	4971
33	4971
30	4972
38	4972
30	4973
11	4973
30	4974
28	4974
30	4975
40	4975
30	4976
7	4976
30	4977
8	4977
30	4978
22	4978
30	4979
28	4979
30	4980
16	4980
30	4981
8	4981
30	4982
33	4982
30	4983
11	4983
30	4984
20	4984
30	4985
8	4985
30	4986
33	4986
30	4987
33	4987
30	4988
33	4988
30	4989
6	4989
30	4990
8	4990
30	4991
30	4992
25	4992
30	4993
27	4993
30	4994
2	4994
30	4995
15	4995
30	4996
33	4996
30	4997
40	4997
30	4998
25	4998
30	4999
27	4999
30	5000
2	5000
30	5001
25	5001
30	5002
8	5002
30	5003
15	5003
30	5004
8	5004
30	5005
25	5005
30	5006
41	5006
30	5007
33	5007
30	5008
2	5008
30	5009
8	5009
30	5010
7	5010
30	5011
33	5011
30	5012
6	5012
30	5013
34	5013
30	5014
25	5014
30	5015
11	5015
30	5016
10	5016
30	5017
29	5017
30	5018
8	5018
30	5019
15	5019
30	5020
22	5020
30	5021
33	5021
30	5022
25	5022
30	5023
27	5023
30	5024
25	5024
30	5025
27	5025
30	5026
2	5026
30	5027
30	5028
33	5028
30	5029
40	5029
30	5030
16	5030
30	5031
8	5031
30	5032
25	5032
30	5033
22	5033
30	5034
25	5034
30	5035
20	5035
30	5036
8	5036
30	5037
22	5037
30	5038
25	5038
30	5039
6	5039
30	5040
27	5040
30	5041
2	5041
30	5042
8	5042
30	5043
15	5043
30	5044
8	5044
30	5045
33	5045
30	5046
33	5046
30	5047
20	5047
30	5048
11	5048
30	5049
8	5049
30	5050
11	5050
30	5051
8	5051
30	5052
20	5052
30	5053
33	5053
30	5054
8	5054
30	5055
15	5055
30	5056
8	5056
30	5057
33	5057
30	5058
38	5058
30	5059
11	5059
30	5060
40	5060
30	5061
28	5061
30	5062
16	5062
30	5063
25	5063
30	5064
33	5064
30	5065
8	5065
30	5066
27	5066
30	5067
8	5067
30	5068
23	5068
30	5069
2	5069
30	5070
8	5070
30	5071
25	5071
30	5072
33	5072
30	5073
2	5073
30	5074
30	5075
30	5076
33	5076
30	5077
23	5077
30	5078
8	5078
30	5079
25	5079
30	5080
30	5081
33	5081
30	5082
40	5082
30	5083
30	5084
28	5084
30	5085
16	5085
30	5086
23	5086
30	5087
8	5087
30	5088
22	5088
30	5089
25	5089
30	5090
33	5090
30	5091
33	5091
30	5092
8	5092
30	5093
41	5093
30	5094
25	5094
30	5095
33	5095
30	5096
7	5096
30	5097
22	5097
30	5098
33	5098
30	5099
20	5099
30	5100
23	5100
30	5101
2	5101
30	5102
25	5102
30	5103
33	5103
30	5104
6	5104
30	5105
23	5105
30	5106
8	5106
30	5107
22	5107
30	5108
44	5108
30	5109
30	5110
8	5110
30	5111
25	5111
30	5112
20	5112
30	5113
29	5113
30	5114
8	5114
30	5115
7	5115
30	5116
25	5116
30	5117
27	5117
30	5118
25	5118
30	5119
27	5119
30	5120
25	5120
30	5121
27	5121
30	5122
2	5122
30	5123
25	5123
30	5124
22	5124
30	5125
8	5125
30	5126
36	5126
30	5127
23	5127
30	5128
8	5128
30	5129
38	5129
30	5130
40	5130
30	5131
28	5131
30	5132
16	5132
30	5133
8	5133
30	5134
22	5134
30	5135
29	5135
30	5136
8	5136
30	5137
15	5137
30	5138
25	5138
30	5139
27	5139
30	5140
2	5140
30	5141
25	5141
30	5142
27	5142
30	5143
25	5143
30	5144
8	5144
30	5145
22	5145
30	5146
15	5146
30	5147
38	5147
30	5148
33	5148
30	5149
20	5149
30	5150
8	5150
30	5151
38	5151
30	5152
25	5152
30	5153
33	5153
30	5154
30	5155
30	5156
41	5156
30	5157
11	5157
30	5158
20	5158
30	5159
16	5159
30	5160
29	5160
30	5161
23	5161
30	5162
8	5162
30	5163
15	5163
30	5164
22	5164
30	5165
30	5166
25	5166
30	5167
36	5167
30	5168
40	5168
30	5169
28	5169
30	5170
16	5170
30	5171
8	5171
30	5172
22	5172
30	5173
11	5173
30	5174
10	5174
30	5175
8	5175
30	5176
25	5176
30	5177
28	5177
30	5178
40	5178
30	5179
22	5179
30	5180
8	5180
30	5181
25	5181
30	5182
30	5183
33	5183
30	5184
7	5184
30	5185
23	5185
30	5186
22	5186
30	5187
8	5187
30	5188
33	5188
30	5189
25	5189
30	5190
27	5190
30	5191
2	5191
30	5192
23	5192
30	5193
8	5193
30	5194
34	5194
30	5195
33	5195
30	5196
20	5196
30	5197
10	5197
30	5198
29	5198
30	5199
8	5199
30	5200
15	5200
30	5201
38	5201
30	5202
25	5202
30	5203
36	5203
30	5204
40	5204
30	5205
28	5205
30	5206
11	5206
30	5207
16	5207
30	5208
29	5208
30	5209
22	5209
30	5210
25	5210
30	5211
27	5211
30	5212
25	5212
30	5213
27	5213
30	5214
2	5214
30	5215
25	5215
30	5216
33	5216
30	5217
25	5217
30	5218
27	5218
30	5219
2	5219
30	5220
25	5220
30	5221
28	5221
30	5222
40	5222
30	5223
16	5223
30	5224
29	5224
30	5225
8	5225
30	5226
22	5226
30	5227
8	5227
30	5228
30	5229
15	5229
30	5230
25	5230
30	5231
27	5231
30	5232
8	5232
30	5233
25	5233
30	5234
27	5234
30	5235
2	5235
30	5236
25	5236
30	5237
27	5237
30	5238
38	5238
30	5239
41	5239
30	5240
11	5240
30	5241
33	5241
30	5242
20	5242
30	5243
33	5243
30	5244
25	5244
30	5245
38	5245
30	5246
25	5246
30	5247
41	5247
30	5248
11	5248
30	5249
29	5249
30	5250
8	5250
30	5251
8	5251
30	5252
25	5252
30	5253
16	5253
30	5254
40	5254
30	5255
7	5255
30	5256
8	5256
30	5257
22	5257
30	5258
8	5258
30	5259
25	5259
30	5260
23	5260
30	5261
25	5261
30	5262
27	5262
30	5263
2	5263
30	5264
15	5264
30	5265
33	5265
30	5266
2	5266
30	5267
30	5268
23	5268
30	5269
15	5269
30	5270
8	5270
30	5271
8	5271
30	5272
15	5272
30	5273
30	5274
25	5274
30	5275
33	5275
30	5276
27	5276
30	5277
2	5277
30	5278
23	5278
30	5279
44	5279
30	5280
16	5280
30	5281
20	5281
30	5282
8	5282
30	5283
33	5283
30	5284
6	5284
30	5285
41	5285
30	5286
10	5286
30	5287
20	5287
30	5288
8	5288
30	5289
25	5289
30	5290
27	5290
30	5291
15	5291
30	5292
44	5292
30	5293
23	5293
30	5294
33	5294
30	5295
25	5295
30	5296
27	5296
30	5297
20	5297
30	5298
38	5298
30	5299
29	5299
30	5300
8	5300
30	5301
7	5301
30	5302
40	5302
30	5303
16	5303
30	5304
30	5305
25	5305
30	5306
33	5306
30	5307
23	5307
30	5308
8	5308
30	5309
15	5309
30	5310
22	5310
30	5311
8	5311
30	5312
25	5312
30	5313
30	5314
30	5315
23	5315
30	5316
15	5316
30	5317
27	5317
30	5318
15	5318
30	5319
16	5319
30	5320
2	5320
30	5321
33	5321
30	5322
25	5322
30	5323
27	5323
30	5324
25	5324
30	5325
27	5325
30	5326
33	5326
30	5327
33	5327
30	5328
25	5328
30	5329
16	5329
30	5330
8	5330
30	5331
2	5331
30	5332
15	5332
30	5333
20	5333
30	5334
11	5334
30	5335
25	5335
30	5336
15	5336
30	5337
8	5337
30	5338
15	5338
30	5339
28	5339
30	5340
40	5340
30	5341
16	5341
30	5342
40	5342
30	5343
16	5343
30	5344
22	5344
30	5345
33	5345
30	5346
29	5346
30	5347
8	5347
30	5348
38	5348
30	5349
11	5349
30	5350
29	5350
30	5351
33	5351
30	5352
25	5352
30	5353
29	5353
30	5354
44	5354
30	5355
6	5355
30	5356
25	5356
30	5357
27	5357
30	5358
33	5358
30	5359
8	5359
30	5360
33	5360
30	5361
23	5361
30	5362
41	5362
30	5363
33	5363
30	5364
8	5364
30	5365
20	5365
30	5366
8	5366
30	5367
25	5367
30	5368
30	5369
38	5369
30	5370
8	5370
30	5371
25	5371
30	5372
27	5372
30	5373
20	5373
30	5374
25	5374
30	5375
16	5375
30	5376
10	5376
30	5377
8	5377
30	5378
15	5378
30	5379
27	5379
30	5380
2	5380
30	5381
8	5381
30	5382
20	5382
30	5383
38	5383
30	5384
11	5384
30	5385
29	5385
30	5386
8	5386
30	5387
27	5387
30	5388
20	5388
30	5389
8	5389
30	5390
44	5390
30	5391
33	5391
30	5392
8	5392
30	5393
40	5393
30	5394
28	5394
30	5395
16	5395
30	5396
34	5396
30	5397
20	5397
30	5398
29	5398
30	5399
8	5399
30	5400
38	5400
30	5401
11	5401
30	5402
8	5402
30	5403
20	5403
30	5404
30	5405
6	5405
30	5406
25	5406
30	5407
34	5407
30	5408
41	5408
30	5409
33	5409
30	5410
25	5410
30	5411
29	5411
30	5412
27	5412
30	5413
2	5413
30	5414
8	5414
30	5415
15	5415
30	5416
22	5416
30	5417
33	5417
30	5418
40	5418
30	5419
16	5419
30	5420
22	5420
30	5421
29	5421
30	5422
8	5422
30	5423
23	5423
30	5424
25	5424
30	5425
27	5425
30	5426
25	5426
30	5427
27	5427
30	5428
2	5428
30	5429
33	5429
30	5430
25	5430
30	5431
27	5431
30	5432
29	5432
30	5433
20	5433
30	5434
8	5434
30	5435
15	5435
30	5436
8	5436
30	5437
22	5437
30	5438
8	5438
30	5439
2	5439
30	5440
25	5440
30	5441
36	5441
30	5442
28	5442
30	5443
40	5443
30	5444
16	5444
30	5445
22	5445
30	5446
8	5446
30	5447
33	5447
30	5448
20	5448
30	5449
8	5449
30	5450
8	5450
30	5451
25	5451
30	5452
27	5452
30	5453
8	5453
30	5454
33	5454
30	5455
30	5456
29	5456
30	5457
23	5457
30	5458
30	5459
25	5459
30	5460
27	5460
30	5461
33	5461
30	5462
25	5462
30	5463
27	5463
30	5464
20	5464
30	5465
8	5465
30	5466
27	5466
30	5467
2	5467
30	5468
25	5468
30	5469
27	5469
30	5470
2	5470
30	5471
38	5471
30	5472
11	5472
30	5473
8	5473
30	5474
15	5474
30	5475
34	5475
30	5476
25	5476
30	5477
30	5478
33	5478
30	5479
23	5479
30	5480
15	5480
30	5481
22	5481
30	5482
25	5482
30	5483
27	5483
30	5484
2	5484
30	5485
25	5485
30	5486
33	5486
30	5487
40	5487
30	5488
16	5488
30	5489
22	5489
30	5490
25	5490
30	5491
27	5491
30	5492
8	5492
30	5493
36	5493
30	5494
29	5494
30	5495
8	5495
30	5496
25	5496
30	5497
27	5497
30	5498
23	5498
30	5499
8	5499
30	5500
20	5500
30	5501
33	5501
30	5502
2	5502
30	5503
29	5503
30	5504
7	5504
30	5505
25	5505
30	5506
27	5506
30	5507
25	5507
30	5508
27	5508
30	5509
25	5509
30	5510
8	5510
30	5511
6	5511
30	5512
8	5512
30	5513
23	5513
30	5514
38	5514
30	5515
11	5515
30	5516
25	5516
30	5517
27	5517
30	5518
2	5518
30	5519
8	5519
30	5520
25	5520
30	5521
8	5521
30	5522
25	5522
30	5523
27	5523
30	5524
33	5524
30	5525
25	5525
30	5526
41	5526
30	5527
30	5528
30	5529
33	5529
30	5530
25	5530
30	5531
27	5531
30	5532
8	5532
30	5533
33	5533
30	5534
27	5534
30	5535
2	5535
30	5536
33	5536
30	5537
33	5537
30	5538
8	5538
30	5539
8	5539
30	5540
29	5540
30	5541
8	5541
30	5542
8	5542
30	5543
8	5543
30	5544
25	5544
30	5545
27	5545
30	5546
2	5546
30	5547
8	5547
30	5548
7	5548
30	5549
23	5549
30	5550
25	5550
30	5551
27	5551
30	5552
16	5552
30	5553
41	5553
30	5554
25	5554
30	5555
27	5555
30	5556
38	5556
30	5557
25	5557
30	5558
36	5558
30	5559
28	5559
30	5560
40	5560
30	5561
11	5561
30	5562
16	5562
30	5563
29	5563
30	5564
8	5564
30	5565
22	5565
30	5566
25	5566
30	5567
33	5567
30	5568
8	5568
30	5569
44	5569
30	5570
25	5570
30	5571
33	5571
30	5572
20	5572
30	5573
29	5573
30	5574
8	5574
30	5575
15	5575
30	5576
22	5576
30	5577
25	5577
30	5578
20	5578
30	5579
8	5579
30	5580
22	5580
30	5581
2	5581
30	5582
33	5582
30	5583
25	5583
30	5584
27	5584
30	5585
23	5585
30	5586
33	5586
30	5587
25	5587
30	5588
27	5588
30	5589
25	5589
30	5590
28	5590
30	5591
40	5591
30	5592
22	5592
30	5593
33	5593
30	5594
8	5594
30	5595
38	5595
30	5596
11	5596
30	5597
33	5597
30	5598
33	5598
30	5599
25	5599
30	5600
33	5600
30	5601
20	5601
30	5602
40	5602
30	5603
28	5603
30	5604
34	5604
30	5605
25	5605
30	5606
33	5606
30	5607
11	5607
30	5608
41	5608
30	5609
16	5609
30	5610
20	5610
30	5611
10	5611
30	5612
29	5612
30	5613
27	5613
30	5614
2	5614
30	5615
8	5615
30	5616
15	5616
30	5617
22	5617
30	5618
25	5618
30	5619
27	5619
30	5620
8	5620
30	5621
28	5621
30	5622
33	5622
30	5623
16	5623
30	5624
25	5624
30	5625
27	5625
30	5626
44	5626
30	5627
25	5627
30	5628
27	5628
30	5629
25	5629
30	5630
22	5630
30	5631
44	5631
30	5632
38	5632
30	5633
8	5633
30	5634
8	5634
30	5635
44	5635
30	5636
7	5636
30	5637
16	5637
30	5638
40	5638
30	5639
28	5639
30	5640
8	5640
30	5641
28	5641
30	5642
16	5642
30	5643
25	5643
30	5644
27	5644
30	5645
2	5645
30	5646
8	5646
30	5647
33	5647
30	5648
25	5648
30	5649
27	5649
30	5650
25	5650
30	5651
25	5651
30	5652
27	5652
30	5653
2	5653
30	5654
25	5654
30	5655
30	5656
33	5656
30	5657
29	5657
30	5658
8	5658
30	5659
38	5659
30	5660
11	5660
30	5661
8	5661
30	5662
33	5662
30	5663
16	5663
30	5664
25	5664
30	5665
27	5665
30	5666
25	5666
30	5667
27	5667
30	5668
8	5668
30	5669
29	5669
30	5670
25	5670
30	5671
27	5671
30	5672
25	5672
30	5673
27	5673
30	5674
2	5674
30	5675
23	5675
30	5676
23	5676
30	5677
41	5677
30	5678
30	5679
30	5680
15	5680
30	5681
25	5681
30	5682
27	5682
30	5683
25	5683
30	5684
27	5684
30	5685
23	5685
30	5686
15	5686
30	5687
8	5687
30	5688
25	5688
30	5689
27	5689
30	5690
20	5690
30	5691
8	5691
30	5692
8	5692
30	5693
27	5693
30	5694
38	5694
30	5695
30	5696
11	5696
30	5697
25	5697
30	5698
33	5698
30	5699
40	5699
30	5700
16	5700
30	5701
41	5701
30	5702
30	5703
29	5703
30	5704
23	5704
30	5705
8	5705
30	5706
15	5706
30	5707
25	5707
30	5708
30	5709
30	5710
7	5710
30	5711
23	5711
30	5712
15	5712
30	5713
44	5713
30	5714
8	5714
30	5715
33	5715
30	5716
25	5716
30	5717
6	5717
30	5718
33	5718
30	5719
8	5719
30	5720
25	5720
30	5721
27	5721
30	5722
8	5722
30	5723
2	5723
30	5724
25	5724
30	5725
27	5725
30	5726
20	5726
30	5727
8	5727
30	5728
20	5728
30	5729
8	5729
30	5730
33	5730
30	5731
8	5731
30	5732
33	5732
30	5733
33	5733
30	5734
25	5734
30	5735
27	5735
30	5736
2	5736
30	5737
15	5737
30	5738
33	5738
30	5739
15	5739
30	5740
2	5740
30	5741
25	5741
30	5742
27	5742
30	5743
33	5743
30	5744
7	5744
30	5745
33	5745
30	5746
33	5746
30	5747
28	5747
30	5748
41	5748
30	5749
40	5749
30	5750
16	5750
30	5751
8	5751
30	5752
33	5752
30	5753
8	5753
30	5754
8	5754
30	5755
20	5755
30	5756
15	5756
30	5757
36	5757
30	5758
16	5758
30	5759
28	5759
30	5760
23	5760
30	5761
15	5761
30	5762
25	5762
30	5763
28	5763
30	5764
40	5764
30	5765
16	5765
30	5766
22	5766
30	5767
8	5767
30	5768
25	5768
30	5769
30	5770
41	5770
30	5771
8	5771
30	5772
28	5772
30	5773
25	5773
30	5774
27	5774
30	5775
2	5775
30	5776
25	5776
30	5777
27	5777
30	5778
2	5778
30	5779
25	5779
30	5780
11	5780
30	5781
41	5781
30	5782
20	5782
30	5783
8	5783
30	5784
8	5784
30	5785
8	5785
30	5786
25	5786
30	5787
33	5787
30	5788
40	5788
30	5789
16	5789
30	5790
7	5790
30	5791
6	5791
30	5792
23	5792
30	5793
8	5793
30	5794
22	5794
30	5795
44	5795
30	5796
8	5796
30	5797
15	5797
30	5798
25	5798
30	5799
11	5799
30	5800
40	5800
30	5801
33	5801
30	5802
28	5802
30	5803
16	5803
30	5804
6	5804
30	5805
23	5805
30	5806
8	5806
30	5807
22	5807
30	5808
16	5808
30	5809
33	5809
30	5810
8	5810
30	5811
25	5811
30	5812
40	5812
30	5813
28	5813
30	5814
16	5814
30	5815
8	5815
30	5816
22	5816
30	5817
15	5817
30	5818
30	5819
25	5819
30	5820
25	5820
30	5821
27	5821
30	5822
20	5822
30	5823
8	5823
30	5824
11	5824
30	5825
25	5825
30	5826
29	5826
30	5827
8	5827
30	5828
22	5828
30	5829
41	5829
30	5830
34	5830
30	5831
25	5831
30	5832
33	5832
30	5833
11	5833
30	5834
41	5834
30	5835
16	5835
30	5836
20	5836
30	5837
10	5837
30	5838
29	5838
30	5839
27	5839
30	5840
2	5840
30	5841
8	5841
30	5842
15	5842
30	5843
22	5843
30	5844
34	5844
30	5845
25	5845
30	5846
33	5846
30	5847
11	5847
30	5848
41	5848
30	5849
16	5849
30	5850
20	5850
30	5851
10	5851
30	5852
29	5852
30	5853
27	5853
30	5854
2	5854
30	5855
8	5855
30	5856
15	5856
30	5857
22	5857
30	5858
33	5858
30	5859
8	5859
30	5860
20	5860
30	5861
23	5861
30	5862
25	5862
30	5863
27	5863
30	5864
33	5864
30	5865
25	5865
30	5866
27	5866
30	5867
33	5867
30	5868
8	5868
30	5869
8	5869
30	5870
41	5870
30	5871
33	5871
30	5872
33	5872
30	5873
8	5873
30	5874
8	5874
30	5875
29	5875
30	5876
38	5876
30	5877
11	5877
30	5878
29	5878
30	5879
25	5879
30	5880
27	5880
30	5881
2	5881
30	5882
8	5882
30	5883
32	5883
30	5884
8	5884
30	5885
25	5885
30	5886
36	5886
30	5887
40	5887
30	5888
16	5888
30	5889
22	5889
30	5890
25	5890
30	5891
8	5891
30	5892
8	5892
30	5893
40	5893
30	5894
28	5894
30	5895
16	5895
30	5896
8	5896
30	5897
25	5897
30	5898
27	5898
30	5899
8	5899
30	5900
29	5900
30	5901
8	5901
30	5902
8	5902
30	5903
25	5903
30	5904
27	5904
30	5905
25	5905
30	5906
27	5906
30	5907
2	5907
30	5908
15	5908
30	5909
20	5909
30	5910
8	5910
30	5911
25	5911
30	5912
27	5912
30	5913
2	5913
30	5914
25	5914
30	5915
27	5915
30	5916
34	5916
30	5917
25	5917
30	5918
16	5918
30	5919
11	5919
30	5920
20	5920
30	5921
8	5921
30	5922
8	5922
30	5923
2	5923
30	5924
33	5924
30	5925
30	5926
8	5926
30	5927
8	5927
30	5928
8	5928
30	5929
33	5929
30	5930
10	5930
30	5931
8	5931
30	5932
15	5932
30	5933
41	5933
30	5934
4	5934
30	5935
29	5935
30	5936
15	5936
30	5937
28	5937
30	5938
40	5938
30	5939
16	5939
30	5940
25	5940
30	5941
27	5941
30	5942
8	5942
30	5943
8	5943
30	5944
33	5944
30	5945
23	5945
30	5946
8	5946
30	5947
2	5947
30	5948
25	5948
30	5949
29	5949
30	5950
8	5950
30	5951
22	5951
30	5952
8	5952
30	5953
25	5953
30	5954
33	5954
30	5955
2	5955
30	5956
25	5956
30	5957
28	5957
30	5958
16	5958
30	5959
40	5959
30	5960
8	5960
30	5961
22	5961
30	5962
33	5962
30	5963
30	5964
8	5964
30	5965
22	5965
30	5966
25	5966
30	5967
30	5968
23	5968
30	5969
25	5969
30	5970
30	5971
23	5971
30	5972
8	5972
30	5973
15	5973
30	5974
7	5974
30	5975
30	5976
15	5976
30	5977
8	5977
30	5978
23	5978
30	5979
8	5979
30	5980
8	5980
30	5981
25	5981
30	5982
27	5982
30	5983
2	5983
30	5984
15	5984
30	5985
25	5985
30	5986
27	5986
30	5987
25	5987
30	5988
27	5988
30	5989
25	5989
30	5990
25	5990
30	5991
36	5991
30	5992
16	5992
30	5993
33	5993
30	5994
40	5994
30	5995
28	5995
30	5996
29	5996
30	5997
8	5997
30	5998
22	5998
30	5999
34	5999
30	6000
8	6000
30	6001
25	6001
30	6002
7	6002
30	6003
22	6003
30	6004
15	6004
30	6005
25	6005
30	6006
27	6006
30	6007
40	6007
30	6008
16	6008
30	6009
28	6009
30	6010
30	6011
25	6011
30	6012
40	6012
30	6013
28	6013
30	6014
33	6014
30	6015
16	6015
30	6016
32	6016
30	6017
7	6017
30	6018
23	6018
30	6019
8	6019
30	6020
15	6020
30	6021
22	6021
30	6022
44	6022
30	6023
33	6023
30	6024
25	6024
30	6025
27	6025
30	6026
2	6026
30	6027
23	6027
30	6028
8	6028
30	6029
30	6030
30	6031
23	6031
30	6032
15	6032
30	6033
8	6033
30	6034
25	6034
30	6035
40	6035
30	6036
28	6036
30	6037
16	6037
30	6038
22	6038
30	6039
16	6039
30	6040
25	6040
30	6041
27	6041
30	6042
25	6042
30	6043
28	6043
30	6044
40	6044
30	6045
16	6045
30	6046
22	6046
30	6047
25	6047
30	6048
27	6048
30	6049
25	6049
30	6050
11	6050
30	6051
20	6051
30	6052
10	6052
30	6053
29	6053
30	6054
8	6054
30	6055
15	6055
30	6056
22	6056
30	6057
25	6057
30	6058
25	6058
30	6059
25	6059
30	6060
15	6060
30	6061
8	6061
30	6062
7	6062
30	6063
8	6063
30	6064
15	6064
30	6065
33	6065
30	6066
25	6066
30	6067
33	6067
30	6068
8	6068
30	6069
25	6069
30	6070
27	6070
30	6071
25	6071
30	6072
27	6072
30	6073
7	6073
30	6074
30	6075
15	6075
30	6076
8	6076
30	6077
25	6077
30	6078
27	6078
30	6079
23	6079
30	6080
25	6080
30	6081
40	6081
30	6082
22	6082
30	6083
25	6083
30	6084
30	6085
38	6085
30	6086
40	6086
30	6087
28	6087
30	6088
16	6088
30	6089
8	6089
30	6090
27	6090
30	6091
15	6091
30	6092
8	6092
30	6093
25	6093
30	6094
25	6094
30	6095
29	6095
30	6096
8	6096
30	6097
22	6097
30	6098
15	6098
30	6099
33	6099
30	6100
11	6100
30	6101
29	6101
30	6102
8	6102
30	6103
25	6103
30	6104
27	6104
30	6105
25	6105
30	6106
27	6106
30	6107
27	6107
30	6108
15	6108
30	6109
29	6109
30	6110
25	6110
30	6111
27	6111
30	6112
41	6112
30	6113
44	6113
30	6114
8	6114
30	6115
8	6115
30	6116
33	6116
30	6117
25	6117
30	6118
27	6118
30	6119
33	6119
30	6120
7	6120
30	6121
28	6121
30	6122
29	6122
30	6123
8	6123
30	6124
30	6125
8	6125
30	6126
15	6126
30	6127
8	6127
30	6128
25	6128
30	6129
27	6129
30	6130
15	6130
30	6131
33	6131
30	6132
25	6132
30	6133
11	6133
30	6134
33	6134
30	6135
41	6135
30	6136
40	6136
30	6137
16	6137
30	6138
8	6138
30	6139
28	6139
30	6140
30	6141
40	6141
30	6142
16	6142
30	6143
8	6143
30	6144
15	6144
30	6145
25	6145
30	6146
40	6146
30	6147
16	6147
30	6148
23	6148
30	6149
25	6149
30	6150
33	6150
30	6151
33	6151
30	6152
25	6152
30	6153
16	6153
30	6154
11	6154
30	6155
8	6155
30	6156
8	6156
30	6157
25	6157
30	6158
8	6158
30	6159
33	6159
30	6160
27	6160
30	6161
16	6161
30	6162
8	6162
30	6163
38	6163
30	6164
8	6164
30	6165
40	6165
30	6166
28	6166
30	6167
41	6167
30	6168
38	6168
30	6169
7	6169
30	6170
25	6170
30	6171
7	6171
30	6172
8	6172
30	6173
25	6173
30	6174
25	6174
30	6175
27	6175
30	6176
8	6176
30	6177
33	6177
30	6178
23	6178
30	6179
7	6179
30	6180
33	6180
30	6181
33	6181
30	6182
33	6182
30	6183
33	6183
30	6184
38	6184
30	6185
25	6185
30	6186
27	6186
30	6187
8	6187
30	6188
33	6188
30	6189
30	6190
25	6190
30	6191
27	6191
30	6192
8	6192
30	6193
20	6193
30	6194
40	6194
30	6195
16	6195
30	6196
8	6196
30	6197
7	6197
30	6198
38	6198
30	6199
25	6199
30	6200
28	6200
30	6201
40	6201
30	6202
11	6202
30	6203
16	6203
30	6204
29	6204
30	6205
22	6205
30	6206
40	6206
30	6207
16	6207
30	6208
25	6208
30	6209
27	6209
30	6210
27	6210
30	6211
25	6211
30	6212
28	6212
30	6213
40	6213
30	6214
16	6214
30	6215
22	6215
30	6216
33	6216
30	6217
25	6217
30	6218
27	6218
30	6219
2	6219
30	6220
8	6220
30	6221
40	6221
30	6222
16	6222
30	6223
25	6223
30	6224
27	6224
30	6225
15	6225
30	6226
40	6226
30	6227
16	6227
30	6228
8	6228
30	6229
8	6229
30	6230
44	6230
30	6231
33	6231
30	6232
38	6232
30	6233
25	6233
30	6234
16	6234
30	6235
40	6235
30	6236
29	6236
30	6237
8	6237
30	6238
22	6238
30	6239
25	6239
30	6240
25	6240
30	6241
23	6241
30	6242
8	6242
30	6243
15	6243
30	6244
41	6244
30	6245
25	6245
30	6246
27	6246
30	6247
25	6247
30	6248
28	6248
30	6249
40	6249
30	6250
22	6250
30	6251
20	6251
30	6252
8	6252
30	6253
29	6253
30	6254
8	6254
30	6255
25	6255
30	6256
27	6256
30	6257
33	6257
30	6258
30	6259
8	6259
30	6260
33	6260
30	6261
6	6261
30	6262
8	6262
30	6263
20	6263
30	6264
25	6264
30	6265
8	6265
30	6266
22	6266
30	6267
20	6267
30	6268
41	6268
30	6269
8	6269
30	6270
2	6270
30	6271
33	6271
30	6272
34	6272
30	6273
25	6273
30	6274
11	6274
30	6275
16	6275
30	6276
20	6276
30	6277
8	6277
30	6278
15	6278
30	6279
25	6279
30	6280
8	6280
30	6281
25	6281
30	6282
27	6282
30	6283
15	6283
30	6284
25	6284
30	6285
40	6285
30	6286
28	6286
30	6287
16	6287
30	6288
22	6288
30	6289
7	6289
30	6290
15	6290
30	6291
8	6291
30	6292
33	6292
30	6293
8	6293
30	6294
38	6294
30	6295
11	6295
30	6296
23	6296
30	6297
25	6297
30	6298
27	6298
30	6299
8	6299
30	6300
30	6301
40	6301
30	6302
16	6302
30	6303
23	6303
30	6304
15	6304
30	6305
11	6305
30	6306
8	6306
30	6307
41	6307
30	6308
27	6308
30	6309
25	6309
30	6310
22	6310
30	6311
27	6311
30	6312
25	6312
30	6313
27	6313
30	6314
33	6314
30	6315
25	6315
30	6316
40	6316
30	6317
16	6317
30	6318
29	6318
30	6319
8	6319
30	6320
22	6320
30	6321
25	6321
30	6322
23	6322
30	6323
11	6323
30	6324
27	6324
30	6325
23	6325
30	6326
30	6327
15	6327
30	6328
25	6328
30	6329
27	6329
30	6330
2	6330
30	6331
16	6331
30	6332
25	6332
30	6333
30	6334
23	6334
30	6335
27	6335
30	6336
15	6336
30	6337
8	6337
30	6338
20	6338
30	6339
25	6339
30	6340
27	6340
30	6341
2	6341
30	6342
25	6342
30	6343
27	6343
30	6344
23	6344
30	6345
8	6345
30	6346
28	6346
30	6347
40	6347
30	6348
40	6348
30	6349
16	6349
30	6350
38	6350
30	6351
11	6351
30	6352
15	6352
30	6353
28	6353
30	6354
15	6354
30	6355
8	6355
30	6356
33	6356
30	6357
16	6357
30	6358
27	6358
30	6359
4	6359
30	6360
8	6360
30	6361
29	6361
30	6362
33	6362
30	6363
23	6363
30	6364
25	6364
30	6365
25	6365
30	6366
27	6366
30	6367
2	6367
30	6368
8	6368
30	6369
8	6369
30	6370
25	6370
30	6371
27	6371
30	6372
33	6372
30	6373
33	6373
30	6374
7	6374
30	6375
25	6375
30	6376
36	6376
30	6377
28	6377
30	6378
40	6378
30	6379
16	6379
30	6380
8	6380
30	6381
22	6381
30	6382
16	6382
30	6383
20	6383
30	6384
27	6384
30	6385
25	6385
30	6386
27	6386
30	6387
25	6387
30	6388
27	6388
30	6389
8	6389
30	6390
25	6390
30	6391
27	6391
30	6392
33	6392
30	6393
27	6393
30	6394
8	6394
30	6395
8	6395
30	6396
23	6396
30	6397
23	6397
30	6398
32	6398
30	6399
27	6399
30	6400
2	6400
30	6401
25	6401
30	6402
40	6402
30	6403
16	6403
30	6404
28	6404
30	6405
16	6405
30	6406
40	6406
30	6407
29	6407
30	6408
8	6408
30	6409
25	6409
30	6410
23	6410
30	6411
8	6411
30	6412
33	6412
30	6413
40	6413
30	6414
28	6414
30	6415
16	6415
30	6416
25	6416
30	6417
30	6418
33	6418
30	6419
23	6419
30	6420
8	6420
30	6421
15	6421
30	6422
22	6422
30	6423
27	6423
30	6424
7	6424
30	6425
25	6425
30	6426
27	6426
30	6427
38	6427
30	6428
38	6428
30	6429
25	6429
30	6430
11	6430
30	6431
15	6431
30	6432
2	6432
30	6433
33	6433
30	6434
33	6434
30	6435
33	6435
30	6436
41	6436
30	6437
33	6437
30	6438
16	6438
30	6439
8	6439
30	6440
25	6440
30	6441
8	6441
30	6442
30	6443
20	6443
30	6444
8	6444
30	6445
6	6445
30	6446
40	6446
30	6447
28	6447
30	6448
16	6448
30	6449
44	6449
30	6450
8	6450
30	6451
16	6451
30	6452
40	6452
30	6453
28	6453
30	6454
16	6454
30	6455
41	6455
30	6456
27	6456
30	6457
25	6457
30	6458
27	6458
30	6459
2	6459
30	6460
33	6460
30	6461
15	6461
30	6462
23	6462
30	6463
33	6463
30	6464
25	6464
30	6465
27	6465
30	6466
25	6466
30	6467
27	6467
30	6468
33	6468
30	6469
41	6469
30	6470
30	6471
25	6471
30	6472
23	6472
30	6473
2	6473
30	6474
33	6474
30	6475
11	6475
30	6476
8	6476
30	6477
16	6477
30	6478
23	6478
30	6479
33	6479
30	6480
15	6480
30	6481
25	6481
30	6482
22	6482
30	6483
7	6483
30	6484
23	6484
30	6485
2	6485
30	6486
16	6486
30	6487
28	6487
30	6488
15	6488
30	6489
33	6489
30	6490
33	6490
30	6491
33	6491
30	6492
33	6492
30	6493
8	6493
30	6494
25	6494
30	6495
27	6495
30	6496
2	6496
30	6497
33	6497
30	6498
33	6498
30	6499
23	6499
30	6500
44	6500
30	6501
33	6501
30	6502
33	6502
30	6503
8	6503
30	6504
8	6504
30	6505
30	6506
33	6506
30	6507
25	6507
30	6508
27	6508
30	6509
11	6509
30	6510
16	6510
30	6511
16	6511
30	6512
25	6512
30	6513
8	6513
30	6514
25	6514
30	6515
27	6515
30	6516
15	6516
30	6517
8	6517
30	6518
27	6518
30	6519
8	6519
30	6520
8	6520
30	6521
7	6521
30	6522
25	6522
30	6523
27	6523
30	6524
7	6524
30	6525
8	6525
30	6526
20	6526
30	6527
25	6527
30	6528
27	6528
30	6529
16	6529
30	6530
8	6530
30	6531
40	6531
30	6532
16	6532
30	6533
33	6533
30	6534
8	6534
30	6535
8	6535
30	6536
40	6536
30	6537
16	6537
30	6538
7	6538
30	6539
16	6539
30	6540
25	6540
30	6541
27	6541
30	6542
2	6542
30	6543
20	6543
30	6544
8	6544
30	6545
33	6545
30	6546
8	6546
30	6547
25	6547
30	6548
30	6549
8	6549
30	6550
25	6550
30	6551
28	6551
30	6552
40	6552
30	6553
16	6553
30	6554
8	6554
30	6555
22	6555
30	6556
33	6556
30	6557
2	6557
30	6558
25	6558
30	6559
27	6559
30	6560
2	6560
30	6561
25	6561
30	6562
8	6562
30	6563
11	6563
30	6564
8	6564
30	6565
30	6566
23	6566
30	6567
15	6567
30	6568
30	6569
23	6569
30	6570
25	6570
30	6571
38	6571
30	6572
11	6572
30	6573
25	6573
30	6574
27	6574
30	6575
41	6575
30	6576
25	6576
30	6577
33	6577
30	6578
16	6578
30	6579
40	6579
30	6580
8	6580
30	6581
22	6581
30	6582
20	6582
30	6583
7	6583
30	6584
8	6584
30	6585
25	6585
30	6586
27	6586
30	6587
25	6587
30	6588
27	6588
30	6589
25	6589
30	6590
27	6590
30	6591
8	6591
30	6592
15	6592
30	6593
33	6593
30	6594
23	6594
30	6595
25	6595
30	6596
30	6597
25	6597
30	6598
33	6598
30	6599
25	6599
30	6600
44	6600
30	6601
41	6601
30	6602
28	6602
30	6603
11	6603
30	6604
25	6604
30	6605
27	6605
30	6606
7	6606
30	6607
25	6607
30	6608
33	6608
30	6609
25	6609
30	6610
8	6610
30	6611
8	6611
30	6612
29	6612
30	6613
25	6613
30	6614
27	6614
30	6615
38	6615
30	6616
40	6616
30	6617
11	6617
30	6618
16	6618
30	6619
25	6619
30	6620
40	6620
30	6621
16	6621
30	6622
22	6622
30	6623
20	6623
30	6624
25	6624
30	6625
27	6625
30	6626
8	6626
30	6627
25	6627
30	6628
36	6628
30	6629
28	6629
30	6630
40	6630
30	6631
23	6631
30	6632
8	6632
30	6633
22	6633
30	6634
25	6634
30	6635
27	6635
30	6636
2	6636
30	6637
28	6637
30	6638
40	6638
30	6639
8	6639
30	6640
32	6640
30	6641
8	6641
30	6642
33	6642
30	6643
20	6643
30	6644
8	6644
30	6645
8	6645
30	6646
29	6646
30	6647
8	6647
30	6648
7	6648
30	6649
8	6649
30	6650
33	6650
30	6651
20	6651
30	6652
8	6652
30	6653
8	6653
30	6654
29	6654
30	6655
28	6655
30	6656
40	6656
30	6657
16	6657
30	6658
33	6658
30	6659
33	6659
30	6660
15	6660
30	6661
15	6661
30	6662
41	6662
30	6663
25	6663
30	6664
27	6664
30	6665
2	6665
30	6666
8	6666
30	6667
23	6667
30	6668
25	6668
30	6669
36	6669
30	6670
40	6670
30	6671
28	6671
30	6672
16	6672
30	6673
8	6673
30	6674
22	6674
30	6675
8	6675
30	6676
44	6676
30	6677
8	6677
30	6678
7	6678
30	6679
25	6679
30	6680
27	6680
30	6681
33	6681
30	6682
33	6682
30	6683
25	6683
30	6684
8	6684
30	6685
33	6685
30	6686
23	6686
30	6687
33	6687
30	6688
38	6688
30	6689
11	6689
30	6690
33	6690
30	6691
25	6691
30	6692
27	6692
30	6693
11	6693
30	6694
7	6694
30	6695
25	6695
30	6696
27	6696
30	6697
8	6697
30	6698
20	6698
30	6699
30	6700
2	6700
30	6701
25	6701
30	6702
23	6702
30	6703
25	6703
30	6704
15	6704
30	6705
33	6705
30	6706
23	6706
30	6707
23	6707
30	6708
27	6708
30	6709
20	6709
30	6710
23	6710
30	6711
38	6711
30	6712
28	6712
30	6713
40	6713
30	6714
16	6714
30	6715
16	6715
30	6716
15	6716
30	6717
8	6717
30	6718
25	6718
30	6719
33	6719
30	6720
29	6720
30	6721
8	6721
30	6722
25	6722
30	6723
36	6723
30	6724
16	6724
30	6725
28	6725
30	6726
25	6726
30	6727
27	6727
30	6728
2	6728
30	6729
23	6729
30	6730
20	6730
30	6731
25	6731
30	6732
27	6732
30	6733
29	6733
30	6734
25	6734
30	6735
20	6735
30	6736
8	6736
30	6737
25	6737
30	6738
27	6738
30	6739
8	6739
30	6740
15	6740
30	6741
25	6741
30	6742
27	6742
30	6743
2	6743
30	6744
8	6744
30	6745
29	6745
30	6746
25	6746
30	6747
27	6747
30	6748
40	6748
30	6749
16	6749
30	6750
20	6750
30	6751
8	6751
30	6752
29	6752
30	6753
38	6753
30	6754
16	6754
30	6755
8	6755
30	6756
25	6756
30	6757
27	6757
30	6758
15	6758
30	6759
8	6759
30	6760
15	6760
30	6761
8	6761
30	6762
41	6762
30	6763
25	6763
30	6764
27	6764
30	6765
33	6765
30	6766
25	6766
30	6767
30	6768
33	6768
30	6769
8	6769
30	6770
11	6770
30	6771
33	6771
30	6772
8	6772
30	6773
8	6773
30	6774
25	6774
30	6775
38	6775
30	6776
25	6776
30	6777
33	6777
30	6778
30	6780
41	6780
30	6781
11	6781
30	6782
20	6782
30	6783
16	6783
30	6784
29	6784
30	6785
23	6785
30	6786
8	6786
30	6787
25	6787
30	6788
25	6788
30	6789
27	6789
30	6790
33	6790
30	6791
8	6791
30	6792
15	6792
30	6793
8	6793
30	6794
20	6794
30	6795
27	6795
30	6796
2	6796
30	6797
28	6797
30	6798
25	6798
30	6799
16	6799
30	6800
40	6800
30	6801
28	6801
30	6802
29	6802
30	6803
8	6803
30	6804
22	6804
30	6805
20	6805
30	6806
29	6806
30	6807
33	6807
30	6808
29	6808
30	6809
16	6809
30	6810
40	6810
30	6811
8	6811
30	6812
8	6812
30	6813
27	6813
30	6814
23	6814
30	6815
25	6815
30	6816
27	6816
30	6817
27	6817
30	6818
27	6818
30	6819
8	6819
30	6820
25	6820
30	6821
20	6821
30	6822
33	6822
30	6823
25	6823
30	6824
27	6824
30	6825
38	6825
30	6826
25	6826
30	6827
11	6827
30	6828
25	6828
30	6829
27	6829
30	6830
7	6830
30	6831
29	6831
30	6832
38	6832
30	6833
11	6833
30	6834
25	6834
30	6835
27	6835
30	6836
8	6836
30	6837
41	6837
30	6838
20	6838
30	6839
8	6839
30	6840
25	6840
30	6841
36	6841
30	6842
28	6842
30	6843
40	6843
30	6844
16	6844
30	6845
8	6845
30	6846
22	6846
30	6847
8	6847
30	6848
8	6848
30	6849
15	6849
30	6850
20	6850
30	6851
25	6851
30	6852
11	6852
30	6853
33	6853
30	6854
16	6854
30	6855
8	6855
30	6856
22	6856
30	6857
25	6857
30	6858
27	6858
30	6859
2	6859
30	6860
8	6860
30	6861
38	6861
30	6862
25	6862
30	6863
36	6863
30	6864
28	6864
30	6865
40	6865
30	6866
16	6866
30	6867
8	6867
30	6868
22	6868
30	6869
25	6869
30	6870
25	6870
30	6871
30	6872
33	6872
30	6873
23	6873
30	6874
25	6874
30	6875
27	6875
30	6876
25	6876
30	6877
33	6877
30	6878
30	6879
23	6879
30	6880
33	6880
30	6881
25	6881
30	6882
27	6882
30	6883
2	6883
30	6884
33	6884
30	6885
34	6885
30	6886
8	6886
30	6887
33	6887
30	6888
25	6888
30	6889
33	6889
30	6890
30	6891
8	6891
30	6892
27	6892
30	6893
38	6893
30	6894
11	6894
30	6895
25	6895
30	6896
8	6896
30	6897
8	6897
30	6898
25	6898
30	6899
11	6899
30	6900
8	6900
30	6901
16	6901
30	6902
41	6902
30	6903
23	6903
30	6904
15	6904
30	6905
30	6906
25	6906
30	6907
27	6907
30	6908
2	6908
30	6909
33	6909
30	6910
15	6910
30	6911
33	6911
30	6912
33	6912
30	6913
16	6913
30	6914
40	6914
30	6915
33	6915
30	6916
25	6916
30	6917
30	6918
6	6918
30	6919
29	6919
30	6920
23	6920
30	6921
8	6921
30	6922
15	6922
30	6923
22	6923
30	6924
44	6924
30	6925
20	6925
30	6926
25	6926
30	6927
41	6927
30	6928
33	6928
30	6929
29	6929
30	6930
27	6930
30	6931
2	6931
30	6932
8	6932
30	6933
16	6933
30	6934
40	6934
30	6935
28	6935
30	6936
2	6936
30	6937
33	6937
30	6938
25	6938
30	6939
30	6940
33	6940
30	6941
29	6941
30	6942
23	6942
30	6943
8	6943
30	6944
22	6944
30	6945
44	6945
30	6946
33	6946
30	6947
8	6947
30	6948
27	6948
30	6949
2	6949
30	6950
27	6950
30	6951
30	6952
33	6952
30	6953
8	6953
30	6954
4	6954
30	6955
25	6955
30	6956
40	6956
30	6957
16	6957
30	6958
8	6958
30	6959
22	6959
30	6960
25	6960
30	6961
22	6961
30	6962
25	6962
30	6963
32	6963
30	6964
4	6964
30	6965
29	6965
30	6966
27	6966
30	6967
2	6967
30	6968
8	6968
30	6969
25	6969
30	6970
27	6970
30	6971
2	6971
30	6972
15	6972
30	6973
25	6973
30	6974
20	6974
30	6975
23	6975
30	6976
8	6976
30	6977
15	6977
30	6978
33	6978
30	6979
6	6979
30	6980
30	6981
20	6981
30	6982
8	6982
30	6983
29	6983
30	6984
38	6984
30	6985
25	6985
30	6986
41	6986
30	6987
11	6987
30	6988
8	6988
30	6989
8	6989
30	6990
33	6990
30	6991
8	6991
30	6992
41	6992
30	6993
33	6993
30	6994
15	6994
30	6995
33	6995
30	6996
25	6996
30	6997
2	6997
30	6998
25	6998
30	6999
27	6999
30	7000
44	7000
30	7001
20	7001
30	7002
8	7002
30	7003
33	7003
30	7004
11	7004
30	7005
8	7005
30	7006
44	7006
30	7007
44	7007
30	7008
25	7008
30	7009
25	7009
30	7010
27	7010
30	7011
25	7011
30	7012
27	7012
30	7013
2	7013
30	7014
30	7015
23	7015
30	7016
30	7017
25	7017
30	7018
30	7019
15	7019
30	7020
23	7020
30	7021
8	7021
30	7022
8	7022
30	7023
8	7023
30	7024
7	7024
30	7025
27	7025
30	7026
25	7026
30	7027
23	7027
30	7028
8	7028
30	7029
15	7029
30	7030
2	7030
30	7031
25	7031
30	7032
27	7032
30	7033
8	7033
30	7034
8	7034
30	7035
25	7035
30	7036
27	7036
30	7037
20	7037
30	7038
29	7038
30	7039
8	7039
30	7040
33	7040
30	7041
30	7042
23	7042
30	7043
8	7043
30	7044
15	7044
30	7045
8	7045
30	7046
27	7046
30	7047
2	7047
30	7048
8	7048
30	7049
23	7049
30	7050
38	7050
30	7051
33	7051
30	7052
23	7052
30	7053
29	7053
30	7054
25	7054
30	7055
27	7055
30	7056
2	7056
30	7057
8	7057
30	7058
25	7058
30	7059
28	7059
30	7060
40	7060
30	7061
8	7061
30	7062
22	7062
30	7063
25	7063
30	7064
27	7064
30	7065
2	7065
30	7066
25	7066
30	7067
27	7067
30	7068
2	7068
30	7069
25	7069
30	7070
20	7070
30	7071
27	7071
30	7072
8	7072
30	7073
2	7073
30	7074
25	7074
30	7075
22	7075
30	7076
25	7076
30	7077
27	7077
30	7078
8	7078
30	7079
33	7079
30	7080
44	7080
30	7081
29	7081
30	7082
33	7082
30	7083
41	7083
30	7084
27	7084
30	7085
8	7085
30	7086
34	7086
30	7087
20	7087
30	7088
11	7088
30	7089
33	7089
30	7090
25	7090
30	7091
40	7091
30	7092
28	7092
30	7093
11	7093
30	7094
16	7094
30	7095
23	7095
30	7096
8	7096
30	7097
22	7097
30	7098
27	7098
30	7099
25	7099
30	7100
27	7100
30	7101
33	7101
30	7102
8	7102
30	7103
34	7103
30	7104
25	7104
30	7105
16	7105
30	7106
11	7106
30	7107
25	7107
30	7108
27	7108
30	7109
33	7109
30	7110
15	7110
30	7111
23	7111
30	7112
25	7112
30	7113
41	7113
30	7114
8	7114
30	7115
25	7115
30	7116
30	7117
25	7117
30	7118
8	7118
30	7119
25	7119
30	7120
32	7120
30	7121
27	7121
30	7122
8	7122
30	7123
15	7123
30	7124
8	7124
30	7125
29	7125
30	7126
33	7126
30	7127
7	7127
30	7128
25	7128
30	7129
30	7130
33	7130
30	7131
23	7131
30	7132
8	7132
30	7133
22	7133
30	7134
30	7135
8	7135
30	7136
25	7136
30	7137
40	7137
30	7138
25	7138
30	7139
33	7139
30	7140
16	7140
30	7141
41	7141
30	7142
20	7142
30	7143
15	7143
30	7144
8	7144
30	7145
40	7145
30	7146
8	7146
30	7147
25	7147
30	7148
27	7148
30	7149
8	7149
30	7150
25	7150
30	7151
27	7151
30	7152
29	7152
30	7153
23	7153
30	7154
8	7154
30	7155
33	7155
30	7156
8	7156
30	7157
15	7157
30	7158
28	7158
30	7159
25	7159
30	7160
27	7160
30	7161
20	7161
30	7162
25	7162
30	7163
25	7163
30	7164
20	7164
30	7165
25	7165
30	7166
33	7166
30	7167
25	7167
30	7168
41	7168
30	7169
33	7169
30	7170
15	7170
30	7171
8	7171
30	7172
33	7172
30	7173
8	7173
30	7174
33	7174
30	7175
15	7175
30	7176
16	7176
30	7177
2	7177
30	7178
20	7178
30	7179
38	7179
30	7180
25	7180
30	7181
40	7181
30	7182
11	7182
30	7183
16	7183
30	7184
29	7184
30	7185
8	7185
30	7186
15	7186
30	7187
22	7187
30	7188
41	7188
30	7189
8	7189
30	7190
8	7190
30	7191
27	7191
30	7192
25	7192
30	7193
27	7193
30	7194
25	7194
30	7195
27	7195
30	7196
8	7196
30	7197
33	7197
30	7198
20	7198
30	7199
20	7199
30	7200
15	7200
30	7201
16	7201
30	7202
25	7202
30	7203
27	7203
30	7204
8	7204
30	7205
8	7205
30	7206
15	7206
30	7207
27	7207
30	7208
20	7208
30	7209
15	7209
30	7210
25	7210
30	7211
27	7211
30	7212
25	7212
30	7213
25	7213
30	7214
27	7214
30	7215
16	7215
30	7216
8	7216
30	7217
27	7217
30	7218
33	7218
30	7219
8	7219
30	7220
33	7220
30	7221
25	7221
30	7222
16	7222
30	7223
20	7223
30	7224
25	7224
30	7225
27	7225
30	7226
15	7226
30	7227
40	7227
30	7228
16	7228
30	7229
11	7229
30	7230
20	7230
30	7231
33	7231
30	7232
27	7232
30	7233
27	7233
30	7234
16	7234
30	7235
40	7235
30	7236
23	7236
30	7237
25	7237
30	7238
25	7238
30	7239
27	7239
30	7240
25	7240
30	7241
33	7241
30	7242
8	7242
30	7243
7	7243
30	7244
33	7244
30	7245
16	7245
30	7246
33	7246
30	7247
30	7248
25	7248
30	7249
27	7249
30	7250
25	7250
30	7251
29	7251
30	7252
25	7252
30	7253
27	7253
30	7254
15	7254
30	7255
25	7255
30	7256
27	7256
30	7257
27	7257
30	7258
8	7258
30	7259
8	7259
30	7260
30	7261
7	7261
30	7262
25	7262
30	7263
41	7263
30	7264
8	7264
30	7265
8	7265
30	7266
38	7266
30	7267
15	7267
30	7268
27	7268
30	7269
8	7269
30	7270
33	7270
30	7271
25	7271
30	7272
27	7272
30	7273
8	7273
30	7274
33	7274
30	7275
16	7275
30	7276
41	7276
30	7277
38	7277
30	7278
38	7278
30	7279
30	7280
30	7281
25	7281
30	7282
11	7282
30	7283
33	7283
30	7284
29	7284
30	7285
8	7285
30	7286
22	7286
30	7287
15	7287
30	7288
8	7288
30	7289
25	7289
30	7290
27	7290
30	7291
23	7291
30	7292
33	7292
30	7293
33	7293
30	7294
8	7294
30	7295
25	7295
30	7296
27	7296
30	7297
25	7297
30	7298
25	7298
30	7299
16	7299
30	7300
40	7300
30	7301
28	7301
30	7302
22	7302
30	7303
33	7303
30	7304
20	7304
30	7305
4	7305
30	7306
29	7306
30	7307
20	7307
30	7308
25	7308
30	7309
7	7309
30	7310
8	7310
30	7311
15	7311
30	7312
25	7312
30	7313
33	7313
30	7314
8	7314
30	7315
27	7315
30	7316
20	7316
30	7317
8	7317
30	7318
25	7318
30	7319
25	7319
30	7320
27	7320
30	7321
25	7321
30	7322
27	7322
30	7323
8	7323
30	7324
33	7324
30	7325
27	7325
30	7326
25	7326
30	7327
20	7327
30	7328
8	7328
30	7329
8	7329
30	7330
25	7330
30	7331
40	7331
30	7332
28	7332
30	7333
22	7333
30	7334
16	7334
30	7335
23	7335
30	7336
8	7336
30	7337
44	7337
30	7338
27	7338
30	7339
23	7339
30	7340
25	7340
30	7341
27	7341
30	7342
33	7342
30	7343
25	7343
30	7344
27	7344
30	7345
8	7345
30	7346
29	7346
30	7347
33	7347
30	7348
27	7348
30	7349
25	7349
30	7350
27	7350
30	7351
44	7351
30	7352
23	7352
30	7353
38	7353
30	7354
11	7354
30	7355
7	7355
30	7356
23	7356
30	7357
8	7357
30	7358
25	7358
30	7359
30	7360
33	7360
30	7361
33	7361
30	7362
23	7362
30	7363
8	7363
30	7364
25	7364
30	7365
23	7365
30	7366
33	7366
30	7367
16	7367
30	7368
33	7368
30	7369
22	7369
30	7370
8	7370
30	7371
16	7371
30	7372
8	7372
30	7373
41	7373
30	7374
30	7375
8	7375
30	7376
8	7376
30	7377
15	7377
30	7378
25	7378
30	7379
25	7379
30	7380
8	7380
30	7381
41	7381
30	7382
25	7382
30	7383
27	7383
30	7384
33	7384
30	7385
33	7385
30	7386
29	7386
30	7387
25	7387
30	7388
27	7388
30	7389
2	7389
30	7390
8	7390
30	7391
15	7391
30	7392
29	7392
30	7393
8	7393
30	7394
25	7394
30	7395
27	7395
30	7396
2	7396
30	7397
25	7397
30	7398
27	7398
30	7399
33	7399
30	7400
10	7400
30	7401
27	7401
30	7402
23	7402
30	7403
8	7403
30	7404
25	7404
30	7405
30	7406
23	7406
30	7407
15	7407
30	7408
40	7408
30	7409
16	7409
30	7410
8	7410
30	7411
8	7411
30	7412
33	7412
30	7413
7	7413
30	7414
8	7414
30	7415
8	7415
30	7416
8	7416
30	7417
23	7417
30	7418
29	7418
30	7419
8	7419
30	7420
25	7420
30	7421
27	7421
30	7422
25	7422
30	7423
27	7423
30	7424
11	7424
30	7425
8	7425
30	7426
25	7426
30	7427
8	7427
30	7428
15	7428
30	7429
8	7429
30	7430
15	7430
30	7431
32	7431
30	7432
27	7432
30	7433
23	7433
30	7434
8	7434
30	7435
29	7435
30	7436
8	7436
30	7437
25	7437
30	7438
40	7438
30	7439
16	7439
30	7440
8	7440
30	7441
22	7441
30	7442
25	7442
30	7443
28	7443
30	7444
40	7444
30	7445
16	7445
30	7446
29	7446
30	7447
8	7447
30	7448
22	7448
30	7449
2	7449
30	7450
15	7450
30	7451
2	7451
30	7452
7	7452
30	7453
25	7453
30	7454
16	7454
30	7455
22	7455
30	7456
27	7456
30	7457
2	7457
30	7458
28	7458
30	7459
33	7459
30	7460
33	7460
30	7461
15	7461
30	7462
30	7463
25	7463
30	7464
27	7464
30	7465
8	7465
30	7466
33	7466
30	7467
8	7467
30	7468
8	7468
30	7469
25	7469
30	7470
8	7470
30	7471
33	7471
30	7472
25	7472
30	7473
27	7473
30	7474
2	7474
30	7475
25	7475
30	7476
27	7476
30	7477
8	7477
30	7478
25	7478
30	7479
27	7479
30	7480
33	7480
30	7481
23	7481
30	7482
25	7482
30	7483
27	7483
30	7484
2	7484
30	7485
33	7485
30	7486
28	7486
30	7487
33	7487
30	7488
25	7488
30	7489
33	7489
30	7490
8	7490
30	7491
15	7491
30	7492
25	7492
30	7493
27	7493
30	7494
2	7494
30	7495
15	7495
30	7496
38	7496
30	7497
25	7497
30	7498
11	7498
30	7499
30	7500
30	7501
23	7501
30	7502
25	7502
30	7503
27	7503
30	7504
16	7504
30	7505
25	7505
30	7506
33	7506
30	7507
6	7507
30	7508
27	7508
30	7509
7	7509
30	7510
25	7510
30	7511
27	7511
30	7512
8	7512
30	7513
23	7513
30	7514
25	7514
30	7515
29	7515
30	7516
6	7516
30	7517
8	7517
30	7518
8	7518
30	7519
25	7519
30	7520
27	7520
30	7521
2	7521
30	7522
7	7522
30	7523
8	7523
30	7524
33	7524
30	7525
40	7525
30	7526
28	7526
30	7527
16	7527
30	7528
8	7528
30	7529
33	7529
30	7530
33	7530
30	7531
25	7531
30	7532
27	7532
30	7533
25	7533
30	7534
40	7534
30	7535
16	7535
30	7536
22	7536
30	7537
25	7537
30	7538
27	7538
30	7539
2	7539
30	7540
8	7540
30	7541
25	7541
30	7542
22	7542
30	7543
25	7543
30	7544
30	7545
7	7545
30	7546
2	7546
30	7547
8	7547
30	7548
15	7548
30	7549
22	7549
30	7550
25	7550
30	7551
40	7551
30	7552
16	7552
30	7553
22	7553
30	7554
8	7554
30	7555
20	7555
30	7556
15	7556
30	7557
25	7557
30	7558
27	7558
30	7559
25	7559
30	7560
11	7560
30	7561
8	7561
30	7562
15	7562
30	7563
25	7563
30	7564
27	7564
30	7565
25	7565
30	7566
27	7566
30	7567
7	7567
30	7568
34	7568
30	7569
20	7569
30	7570
25	7570
30	7571
22	7571
30	7572
34	7572
30	7573
11	7573
30	7574
16	7574
30	7575
20	7575
30	7576
8	7576
30	7577
15	7577
30	7578
27	7578
30	7579
38	7579
30	7580
25	7580
30	7581
36	7581
30	7582
11	7582
30	7583
40	7583
30	7584
28	7584
30	7585
16	7585
30	7586
29	7586
30	7587
8	7587
30	7588
22	7588
30	7589
25	7589
30	7590
29	7590
30	7591
25	7591
30	7592
33	7592
30	7593
33	7593
30	7594
41	7594
30	7595
20	7595
30	7596
8	7596
30	7597
8	7597
30	7598
16	7598
30	7599
8	7599
30	7600
11	7600
30	7601
27	7601
30	7602
16	7602
30	7603
25	7603
30	7604
27	7604
30	7605
2	7605
30	7606
8	7606
30	7607
16	7607
30	7608
16	7608
30	7609
25	7609
30	7610
27	7610
30	7611
41	7611
30	7612
33	7612
30	7613
8	7613
30	7614
25	7614
30	7615
8	7615
30	7616
25	7616
30	7617
27	7617
30	7618
25	7618
30	7619
41	7619
30	7620
29	7620
30	7621
8	7621
30	7622
22	7622
30	7623
25	7623
30	7624
8	7624
30	7625
22	7625
30	7626
25	7626
30	7627
33	7627
30	7628
7	7628
30	7629
8	7629
30	7630
15	7630
30	7631
20	7631
30	7632
8	7632
30	7633
29	7633
30	7634
8	7634
30	7635
40	7635
30	7636
28	7636
30	7637
16	7637
30	7638
8	7638
30	7639
27	7639
30	7640
15	7640
30	7641
33	7641
30	7642
33	7642
30	7643
33	7643
30	7644
2	7644
30	7645
33	7645
30	7646
33	7646
30	7647
40	7647
30	7648
16	7648
30	7649
8	7649
30	7650
22	7650
30	7651
38	7651
30	7652
29	7652
30	7653
8	7653
30	7654
33	7654
30	7655
33	7655
30	7656
8	7656
30	7657
29	7657
30	7658
25	7658
30	7659
41	7659
30	7660
40	7660
30	7661
16	7661
30	7662
20	7662
30	7663
27	7663
30	7664
8	7664
30	7665
22	7665
30	7666
8	7666
30	7667
25	7667
30	7668
27	7668
30	7669
2	7669
30	7670
25	7670
30	7671
36	7671
30	7672
28	7672
30	7673
40	7673
30	7674
16	7674
30	7675
8	7675
30	7676
22	7676
30	7677
20	7677
30	7678
8	7678
30	7679
33	7679
30	7680
25	7680
30	7681
27	7681
30	7682
2	7682
30	7683
25	7683
30	7684
27	7684
30	7685
25	7685
30	7686
27	7686
30	7687
2	7687
30	7688
33	7688
30	7689
34	7689
30	7690
38	7690
30	7691
25	7691
30	7692
33	7692
30	7693
11	7693
30	7694
29	7694
30	7695
7	7695
30	7696
23	7696
30	7697
15	7697
30	7698
25	7698
30	7699
27	7699
30	7700
25	7700
30	7701
8	7701
30	7702
25	7702
30	7703
6	7703
30	7704
27	7704
30	7705
2	7705
30	7706
8	7706
30	7707
33	7707
30	7708
33	7708
30	7709
8	7709
30	7710
15	7710
30	7711
41	7711
30	7712
25	7712
30	7713
6	7713
30	7714
27	7714
30	7715
2	7715
30	7716
15	7716
30	7717
25	7717
30	7718
40	7718
30	7719
36	7719
30	7720
28	7720
30	7721
16	7721
30	7722
29	7722
30	7723
22	7723
30	7724
8	7724
30	7725
28	7725
30	7726
25	7726
30	7727
27	7727
30	7728
2	7728
30	7729
25	7729
30	7730
8	7730
30	7731
30	7732
30	7733
23	7733
30	7734
15	7734
30	7735
25	7735
30	7736
40	7736
30	7737
16	7737
30	7738
22	7738
30	7739
8	7739
30	7740
30	7741
8	7741
30	7742
44	7742
30	7743
30	7744
25	7744
30	7745
27	7745
30	7746
2	7746
30	7747
25	7747
30	7748
28	7748
30	7749
40	7749
30	7750
16	7750
30	7751
8	7751
30	7752
22	7752
30	7753
36	7753
30	7754
25	7754
30	7755
11	7755
30	7756
20	7756
30	7757
27	7757
30	7758
2	7758
30	7759
8	7759
30	7760
22	7760
30	7761
25	7761
30	7762
27	7762
30	7763
23	7763
30	7764
29	7764
30	7765
8	7765
30	7766
20	7766
30	7767
25	7767
30	7768
27	7768
30	7769
8	7769
30	7770
25	7770
30	7771
27	7771
30	7772
8	7772
30	7773
8	7773
30	7774
8	7774
30	7775
27	7775
30	7776
44	7776
30	7777
8	7777
30	7778
28	7778
30	7779
33	7779
30	7780
25	7780
30	7781
8	7781
30	7782
38	7782
30	7783
8	7783
30	7784
25	7784
30	7785
27	7785
30	7786
2	7786
30	7787
25	7787
30	7788
27	7788
30	7789
6	7789
30	7790
8	7790
30	7791
8	7791
30	7792
16	7792
30	7793
2	7793
30	7794
33	7794
30	7795
27	7795
30	7796
2	7796
30	7797
8	7797
30	7798
25	7798
30	7799
27	7799
30	7800
2	7800
30	7801
25	7801
30	7802
8	7802
30	7803
15	7803
30	7804
22	7804
30	7805
28	7805
30	7806
33	7806
30	7807
25	7807
30	7808
15	7808
30	7809
38	7809
30	7810
11	7810
30	7811
23	7811
30	7812
30	7813
11	7813
30	7814
20	7814
30	7815
8	7815
30	7816
8	7816
30	7817
28	7817
30	7818
23	7818
30	7819
33	7819
30	7820
27	7820
30	7821
25	7821
30	7822
8	7822
30	7823
38	7823
30	7824
30	7825
25	7825
30	7826
23	7826
30	7827
15	7827
30	7828
33	7828
30	7829
8	7829
30	7830
25	7830
30	7831
30	7832
33	7832
30	7833
7	7833
30	7834
29	7834
30	7835
23	7835
30	7836
8	7836
30	7837
15	7837
30	7838
22	7838
30	7839
30	7840
34	7840
30	7841
20	7841
30	7842
25	7842
30	7843
11	7843
30	7844
8	7844
30	7845
15	7845
30	7846
22	7846
30	7847
38	7847
30	7848
20	7848
30	7849
11	7849
30	7850
25	7850
30	7851
27	7851
30	7852
2	7852
30	7853
25	7853
30	7854
23	7854
30	7855
8	7855
30	7856
22	7856
30	7857
44	7857
30	7858
40	7858
30	7859
28	7859
30	7860
16	7860
30	7861
33	7861
30	7862
27	7862
30	7863
29	7863
30	7864
8	7864
30	7865
20	7865
30	7866
8	7866
30	7867
33	7867
30	7868
33	7868
30	7869
25	7869
30	7870
8	7870
30	7871
25	7871
30	7872
27	7872
30	7873
38	7873
30	7874
11	7874
30	7875
8	7875
30	7876
25	7876
30	7877
40	7877
30	7878
16	7878
30	7879
8	7879
30	7880
22	7880
30	7881
2	7881
30	7882
34	7882
30	7883
25	7883
30	7884
11	7884
30	7885
16	7885
30	7886
10	7886
30	7887
29	7887
30	7888
27	7888
30	7889
8	7889
30	7890
15	7890
30	7891
38	7891
30	7892
20	7892
30	7893
33	7893
30	7894
8	7894
30	7895
15	7895
30	7896
33	7896
30	7897
25	7897
30	7898
28	7898
30	7899
25	7899
30	7900
27	7900
30	7901
2	7901
30	7902
25	7902
30	7903
30	7904
8	7904
30	7905
28	7905
30	7906
33	7906
30	7907
33	7907
30	7908
25	7908
30	7909
15	7909
30	7910
8	7910
30	7911
33	7911
30	7912
15	7912
30	7913
33	7913
30	7914
44	7914
30	7915
30	7916
30	7917
15	7917
30	7918
25	7918
30	7919
27	7919
30	7920
2	7920
30	7921
20	7921
30	7922
8	7922
43	1159
12	3691
42	3691
12	1335
43	1175
12	1351
35	1372
12	1229
35	1229
43	1502
43	1174
12	1403
24	1403
12	1332
12	3721
42	3721
1	1112
12	1404
24	1404
12	1409
24	1409
14	1331
3	3761
12	1405
24	1405
1	1131
12	1334
43	1495
43	1152
12	1367
43	1509
35	1369
12	3704
42	3704
12	3707
42	3707
43	1003
39	1462
35	1349
12	1400
24	1400
43	1510
1	1108
12	1194
35	1370
12	1266
12	1363
12	1362
35	1307
26	1307
43	1491
43	1168
13	1471
35	1305
26	1305
35	1324
26	1324
12	1353
43	1163
43	1149
1	1111
43	1160
1	1110
1	1125
35	1246
12	3731
12	1418
39	1465
3	3765
43	1004
35	1314
26	1314
12	1237
12	1244
3	3770
3	3766
1	1107
35	1325
26	1325
12	3719
39	1461
12	1407
24	1407
39	1186
12	1186
35	1252
12	3697
42	3697
35	1316
26	1316
12	1368
12	3732
12	1223
12	1220
43	1180
35	1379
3	3764
12	3696
42	3696
43	1503
43	1486
12	1264
35	1264
1	1104
1	1119
1	1105
39	1255
12	1338
1	1120
35	1318
26	1318
12	3708
35	1315
26	1315
12	1347
3	3772
43	1505
12	1199
43	1499
14	1329
43	1513
12	1227
12	1380
12	1236
12	1222
12	1346
3	3763
39	1245
12	1245
35	1245
43	1492
35	1257
12	1257
12	3710
12	1235
35	1263
12	1263
1	1114
39	1226
43	1501
35	1271
12	1377
35	1377
31	1373
12	1215
43	1485
12	1344
13	1473
43	1158
12	3698
42	3698
12	1366
12	3729
35	1326
26	1326
1	1124
12	1209
43	1511
35	1256
12	1256
12	3702
12	3716
42	3716
35	1319
26	1319
39	1468
1	1101
39	1475
12	3736
12	1258
35	1258
12	1413
24	1413
39	3692
12	3692
12	3720
42	3720
17	1391
17	1390
35	1317
26	1317
12	1268
12	3705
43	1498
39	1469
1	1126
12	3738
42	3738
43	1157
12	3734
43	1172
12	3701
12	3723
42	3723
12	1410
24	1410
19	1443
12	3711
1	1128
1	1123
12	3728
12	1261
43	1179
43	1504
35	1251
43	1171
12	1239
12	1210
24	1210
12	1336
5	1387
9	1387
18	1387
35	1269
12	1269
39	1203
35	1250
1	1118
12	1262
12	3693
42	3693
12	1200
12	1350
12	1189
12	1470
24	1470
12	1354
12	1211
5	1385
9	1385
18	1385
17	1389
43	1508
12	1242
43	1489
14	1330
43	1173
43	1146
35	1312
26	1312
39	1483
39	1476
35	1311
26	1311
12	1406
24	1406
12	1355
12	1243
43	1154
12	3715
43	1507
12	3737
42	3737
12	1217
1	1121
12	1224
12	1232
35	1274
12	1274
39	1274
12	3699
42	3699
12	1272
35	1272
39	1272
43	1494
43	1153
12	1231
39	1196
1	1117
35	1304
26	1304
35	1247
12	3724
42	3724
43	1493
12	1364
12	3735
43	1177
12	1241
43	1170
39	1460
1	1122
35	1327
26	1327
39	1482
1	1129
43	1395
1	1103
12	1340
3	3768
12	1365
12	1339
12	1357
12	1358
35	1356
12	1341
12	3703
12	1361
12	1233
12	3722
12	3730
39	1467
39	1466
43	1150
35	1248
12	1270
1	1116
3	3769
35	1309
26	1309
14	3777
12	1219
19	1445
12	3695
42	3695
43	1497
43	1487
12	3726
1	1005
39	1273
12	1230
12	3709
12	3700
42	3700
12	1414
24	1414
1	1102
12	3712
12	1408
24	1408
1	1130
5	1384
9	1384
18	1384
12	3706
42	3706
35	1322
26	1322
12	1402
24	1402
35	1267
12	1267
35	1308
26	1308
35	1249
1	1109
12	3727
3	3771
12	3694
42	3694
12	1345
12	3713
42	3713
12	1412
24	1412
39	1201
12	3733
12	1238
43	1488
35	1320
26	1320
1	1127
39	3773
12	1411
24	1411
14	1416
35	1306
26	1306
12	1333
17	1393
43	1155
17	1388
39	1202
12	1202
12	1360
43	1166
17	1392
43	1496
43	1506
12	1228
12	3725
42	3725
12	1352
1	1113
12	1216
12	1378
12	3717
1	1115
3	3767
12	1348
39	1265
12	1265
12	1337
12	3718
42	3718
35	1310
26	1310
5	1381
9	1381
18	1381
12	1399
24	1399
43	1500
12	1221
43	1490
12	1359
1	1106
39	1481
12	1193
39	1464
43	1176
12	1376
35	1376
12	1208
12	1342
14	3778
43	1512
12	1240
39	1477
12	1397
24	1397
39	1463
12	3714
42	3714
43	1016
28	4074
33	5084
40	5084
11	5703
25	5703
33	5703
40	5703
16	5703
41	5703
8	5968
22	5968
25	5968
38	6429
33	7594
33	7656
8	7872
25	7872
21	2053
21	1555
21	1577
21	3109
21	2500
21	2422
21	1996
21	1920
21	3583
21	2534
21	3570
21	2620
21	2692
21	1696
21	2121
21	3300
21	2601
21	2357
21	2236
21	1984
21	2253
21	4057
21	3075
21	2242
21	2383
21	2614
21	2933
21	1556
21	2290
21	1592
21	2781
21	2648
21	3046
21	3111
21	3448
21	3121
21	3426
21	2228
21	2076
21	2339
21	2820
21	2609
21	2501
21	2254
21	2230
21	2444
21	1980
21	2398
21	1722
21	2234
21	1935
21	2257
21	2055
21	3790
21	2957
21	1769
21	2248
21	2667
21	1864
21	1665
21	2545
21	1974
21	3169
21	2296
21	2527
21	3807
21	1772
21	2278
21	2490
21	1748
21	3788
21	3474
21	3786
21	2540
21	3848
21	1786
21	3895
21	2115
21	3921
21	3963
21	2047
21	3983
21	4016
21	4042
21	4085
21	2763
21	4099
21	2358
21	4129
21	4135
21	4151
21	4229
21	2938
21	4242
21	4260
21	4263
21	2925
21	4291
21	4394
21	4402
21	4452
21	4459
21	4475
21	3084
21	4530
21	4539
21	4546
21	4606
21	4611
21	4690
21	4702
21	3569
21	4705
21	2722
21	4737
21	4807
21	2628
21	4844
21	4880
21	3600
21	4991
21	5027
21	5074
21	2283
21	5080
21	5076
21	5109
21	5154
21	5165
21	2818
21	5182
21	2251
21	5228
21	2844
21	5267
21	3110
21	5273
21	1791
21	5304
21	5313
21	5368
21	5404
21	5458
21	5455
21	1720
21	5477
21	5527
21	5655
21	3390
21	5678
21	5695
21	1790
21	5708
21	2271
21	5769
21	5818
21	5925
21	1937
21	5963
21	2086
21	5970
21	5975
21	6010
21	3107
21	6029
21	2382
21	6074
21	6084
21	6124
21	6140
21	6189
21	6258
21	1969
21	6300
21	2531
21	6326
21	3012
21	6333
21	6417
21	2917
21	6442
21	6470
21	6505
21	6548
21	2891
21	6565
21	2723
21	6568
21	1548
21	6596
21	6699
21	1544
21	6767
21	1541
21	6778
21	2298
21	6871
21	3538
21	6878
21	6890
21	3045
21	6905
21	6939
21	6917
21	3596
21	6951
21	6980
21	7014
21	3579
21	7016
21	7018
21	3465
21	7041
21	3356
21	7116
21	7129
21	7247
21	7260
21	2080
21	7279
21	7359
21	7374
21	3462
21	7405
21	7462
21	2608
21	7499
21	2756
21	7544
21	3540
21	7731
21	7740
21	7743
21	7812
21	2054
21	7824
21	1866
21	7831
21	7903
21	2423
21	3472
21	7915
21	7917
21	4396
21	5156
21	5315
21	5680
21	5710
21	6031
21	6780
21	7281
21	7501
21	7733
21	5084
21	5968
21	5703
37	1291
37	1295
37	1296
37	1278
37	1301
37	1277
37	1287
37	1276
37	1283
37	1300
37	1298
37	1286
37	1284
37	1294
37	1288
37	1275
37	1292
37	1293
37	1285
37	1289
37	1303
37	1281
37	1279
37	1280
37	1297
30	2933
\.


--
-- Data for Name: terms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.terms (id, ark_id, shoulder, naan, owner_id, created, modified, term_string, definition, examples, concept_id, status, class, definition_html, examples_html) FROM stdin;
3415	3523	h	99152	1129	2017-06-06 19:46:39.254342	2022-03-08 18:21:31.818979	Subsea permafrost	Permafrost occurring beneath the sea bottom. #{g: xqNSIDCCryosphere | h1635}\n\nPermafrost occurring beneath the sea bottom #{g: xqIPAPermafrost | h1630}\n\nForm of permafrost that exists beneath the sea in ocean sediments. #{g: xqPhysicalGeography | h1636}\n\n#{g: xqGCW | h1619}		h3523	archived	vernacular	\N	\N
1306	1388	h	99152	1097	2016-05-11 16:23:25.208099	2022-06-13 19:18:57.319553	building_foundation	element of a building structure which connects it to the ground, and transfers [load](https://n2t.net/99152/h1352) from the structure to the ground.  	fixed based model, spread-footing with foundation springs, piles with p-y springs 	h1388	published	vernacular	<p>element of a building structure which connects it to the ground, and transfers <a href="https://n2t.net/99152/h1352" rel="nofollow">load</a> from the structure to the ground.  </p>	\N
1604	1711	h	99152	1129	2017-06-06 17:41:18.736116	2022-03-08 18:21:35.054156	Altitude	The vertical distance of a point above a datum. The vertical datum is usually an estimate of mean sea level. Older measurements were often determined in a local coordinate system and were not tied to a global reference frame. Some were made not with surveying instruments but with barometers, in reliance on the decrease of atmospheric pressure with altitude. It is now usual to measure altitude or elevation using the Global Positioning System or an equivalent global navigation satellite system. Altitude and elevation are synonyms in common usage, although altitude is less ambiguous. The unqualified word 'elevation' can also refer, for example, to the act of elevating or to angular distance above a horizontal plane. #{g: xqIHPGlacierMassBalance | h1629}\n\nVertical distance of a level, a point or an object considered as a point, measured from mean sea level. (TR) #{g: xqWMOHydrology | h1642}\n\nA measure (or condition) of height, especially of great height, as a mountain top or aircraft flight level. In meteorology, altitude is used almost exclusively with respect to the height of an airborne object above the earth's surface, above a constant-pressure surface, or above mean sea level. The measurement of altitude is accomplished by altimeters in aeronautics, and the entire study is called altimetry. #{g: xqAMSglossary | h1620}\n\nVertical distance above sea-level. #{g: xqPhysicalGeography | h1636}\n\n#{g: xqGCW | h1619}		h1711	archived	vernacular	\N	\N
3159	3267	h	99152	1129	2017-06-06 19:36:49.070972	2022-03-08 18:21:35.799628	Seasonally-active permafrost	The uppermost layer of the permafrost which undergoes seasonal phase changes due to the lowered thawing temperature and freezing-point depression of its pore water. #{g: xqNSIDCCryosphere | h1635}\n\nThe uppermost layer of the permafrost which undergoes seasonal phase changes due to the lowered thawing temperature and freezing-point depression of its pore water #{g: xqIPAPermafrost | h1630}\n\n#{g: xqGCW | h1619}		h3267	archived	vernacular	\N	\N
2053	2160	h	99152	1129	2017-06-06 18:00:01.592476	2022-04-08 15:43:45.005288	Erratic	A rock of unspecified shape and size, transported a significant distance from its origin by a glacier or iceberg and deposited by melting of the ice. Erratics range from pebble-size to larger than a house and usually are of a different composition that the bedrock or sediment on which they are deposited. \n\nA boulder or large block of bedrock that is being, or has been, transported away from its source by a glacier. #{g: xqSwisseduc | h1638}\n\nA large rock boulder that has been transported by glaciers away from its origin and deposited in a region of dissimilar rock. #{g: xqPhysicalGeography | h1636}\n\n#{g: xqGCW | h1619}		h2160	archived	vernacular	\N	\N
3753	3870	h	99152	1007	2018-01-21 02:37:54.010656	2022-06-13 18:55:28.936714	video	A [metatype](https://n2t.net/99152/h3865) with core element mappings: creator = dublinkernel:who = dublincore:creator = datacite:creator; title = dublinkernel:what = dublincore:title = datacite:title; size = dublinkernel:size = dublincore:format = datacite:size	Often accompanies objects consisting of visual information made of moving images, optionally with sound.	h3870	published	vernacular	<p>A <a href="https://n2t.net/99152/h3865" rel="nofollow">metatype</a> with core element mappings: creator = dublinkernel:who = dublincore:creator = datacite:creator; title = dublinkernel:what = dublincore:title = datacite:title; size = dublinkernel:size = dublincore:format = datacite:size</p>	\N
\.


--
-- Data for Name: termsets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.termsets (id, source, description, created, updated, user_id, name) FROM stdin;
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
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, authority, auth_id, last_name, first_name, email, orcid, reputation, enotify, super_user, last_message_read_time) FROM stdin;
1	google	102013834453375233974	Smith	John	j.smith@example.com	\N	30	f	t	2022-07-25 19:06:57.247934
\.


--
-- Data for Name: votes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.votes (user_id, term_id, vote) FROM stdin;
1	6781	1
1	7829	1
1	6782	1
1	7426	1
1	1541	-1
1	6777	-1
1	1208	1
1	5373	1
1	4827	-1
1	7923	1
1164	7923	1
\.


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 1, false);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messages_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 33, true);


--
-- Name: relationships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.relationships_id_seq', 6294, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_id_seq', 44, true);


--
-- Name: terms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.terms_id_seq', 7923, true);


--
-- Name: termsets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.termsets_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1164, true);


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
-- Name: ix_term___ts_vector__; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_term___ts_vector__ ON public.terms USING gin (__ts_vector__);


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

