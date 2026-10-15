--
-- PostgreSQL database dump
--


-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

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
-- Name: equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment (
    equipment_id integer NOT NULL,
    location_id integer NOT NULL,
    type_id integer NOT NULL,
    serial_number character varying(100) NOT NULL,
    manufacturer character varying(50),
    model character varying(100),
    installation_date date NOT NULL,
    last_maintenance date,
    status character varying(20),
    purchase_cost numeric(10,2),
    created_date date DEFAULT CURRENT_DATE,
    CONSTRAINT equipment_status_check CHECK (((status)::text = ANY ((ARRAY['Active'::character varying, 'Maintenance'::character varying, 'Retired'::character varying])::text[])))
);


ALTER TABLE public.equipment OWNER TO postgres;

--
-- Name: equipment_equipment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipment_equipment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipment_equipment_id_seq OWNER TO postgres;

--
-- Name: equipment_equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipment_equipment_id_seq OWNED BY public.equipment.equipment_id;


--
-- Name: equipment_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment_types (
    type_id integer NOT NULL,
    type_name character varying(50) NOT NULL,
    description character varying(200),
    average_cost numeric(10,2)
);


ALTER TABLE public.equipment_types OWNER TO postgres;

--
-- Name: equipment_types_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipment_types_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipment_types_type_id_seq OWNER TO postgres;

--
-- Name: equipment_types_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipment_types_type_id_seq OWNED BY public.equipment_types.type_id;


--
-- Name: incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidents (
    incident_id integer NOT NULL,
    equipment_id integer NOT NULL,
    location_id integer NOT NULL,
    incident_date timestamp without time zone NOT NULL,
    incident_type character varying(50),
    severity character varying(20),
    description text,
    affected_customers integer,
    status character varying(20),
    created_date date DEFAULT CURRENT_DATE,
    CONSTRAINT incidents_incident_type_check CHECK (((incident_type)::text = ANY ((ARRAY['Hardware Failure'::character varying, 'Fiber Cut'::character varying, 'Power Loss'::character varying, 'Software Bug'::character varying, 'Unknown'::character varying])::text[]))),
    CONSTRAINT incidents_severity_check CHECK (((severity)::text = ANY ((ARRAY['Critical'::character varying, 'High'::character varying, 'Medium'::character varying, 'Low'::character varying])::text[]))),
    CONSTRAINT incidents_status_check CHECK (((status)::text = ANY ((ARRAY['Open'::character varying, 'In Progress'::character varying, 'Resolved'::character varying, 'Closed'::character varying])::text[])))
);


ALTER TABLE public.incidents OWNER TO postgres;

--
-- Name: incidents_incident_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incidents_incident_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.incidents_incident_id_seq OWNER TO postgres;

--
-- Name: incidents_incident_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incidents_incident_id_seq OWNED BY public.incidents.incident_id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    location_id integer NOT NULL,
    region_id integer NOT NULL,
    location_name character varying(100) NOT NULL,
    city character varying(50),
    state character varying(50),
    latitude numeric(10,8),
    longitude numeric(11,8),
    population integer,
    created_date date DEFAULT CURRENT_DATE
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- Name: locations_location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.locations_location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locations_location_id_seq OWNER TO postgres;

--
-- Name: locations_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.locations_location_id_seq OWNED BY public.locations.location_id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regions (
    region_id integer NOT NULL,
    region_name character varying(50) NOT NULL,
    description character varying(200),
    created_date date DEFAULT CURRENT_DATE
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- Name: regions_region_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.regions_region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.regions_region_id_seq OWNER TO postgres;

--
-- Name: regions_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.regions_region_id_seq OWNED BY public.regions.region_id;


--
-- Name: repairs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repairs (
    repair_id integer NOT NULL,
    incident_id integer NOT NULL,
    technician_id integer NOT NULL,
    repair_start_time timestamp without time zone NOT NULL,
    repair_end_time timestamp without time zone,
    repair_type character varying(50),
    cost numeric(10,2),
    parts_replaced character varying(500),
    notes text,
    status character varying(20),
    created_date date DEFAULT CURRENT_DATE,
    CONSTRAINT repairs_status_check CHECK (((status)::text = ANY ((ARRAY['In Progress'::character varying, 'Completed'::character varying, 'Failed'::character varying, 'Pending'::character varying])::text[])))
);


ALTER TABLE public.repairs OWNER TO postgres;

--
-- Name: repairs_repair_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.repairs_repair_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.repairs_repair_id_seq OWNER TO postgres;

--
-- Name: repairs_repair_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.repairs_repair_id_seq OWNED BY public.repairs.repair_id;


--
-- Name: technicians; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.technicians (
    technician_id integer NOT NULL,
    region_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100),
    phone character varying(15),
    specialization character varying(100),
    hire_date date NOT NULL,
    status character varying(20),
    created_date date DEFAULT CURRENT_DATE,
    CONSTRAINT technicians_status_check CHECK (((status)::text = ANY ((ARRAY['Active'::character varying, 'Inactive'::character varying, 'On Leave'::character varying])::text[])))
);


ALTER TABLE public.technicians OWNER TO postgres;

--
-- Name: technicians_technician_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.technicians_technician_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.technicians_technician_id_seq OWNER TO postgres;

--
-- Name: technicians_technician_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.technicians_technician_id_seq OWNED BY public.technicians.technician_id;


--
-- Name: equipment equipment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment ALTER COLUMN equipment_id SET DEFAULT nextval('public.equipment_equipment_id_seq'::regclass);


--
-- Name: equipment_types type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_types ALTER COLUMN type_id SET DEFAULT nextval('public.equipment_types_type_id_seq'::regclass);


--
-- Name: incidents incident_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents ALTER COLUMN incident_id SET DEFAULT nextval('public.incidents_incident_id_seq'::regclass);


--
-- Name: locations location_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations ALTER COLUMN location_id SET DEFAULT nextval('public.locations_location_id_seq'::regclass);


--
-- Name: regions region_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions ALTER COLUMN region_id SET DEFAULT nextval('public.regions_region_id_seq'::regclass);


--
-- Name: repairs repair_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repairs ALTER COLUMN repair_id SET DEFAULT nextval('public.repairs_repair_id_seq'::regclass);


--
-- Name: technicians technician_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technicians ALTER COLUMN technician_id SET DEFAULT nextval('public.technicians_technician_id_seq'::regclass);


--
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.equipment VALUES (1, 1, 1, 'A1234-LOC1', 'Cisco', 'Model-X1', '2022-01-15', '2024-08-20', 'Active', 45000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (2, 1, 2, 'A5678-LOC1', 'Juniper', 'Model-X3', '2021-06-10', '2024-07-15', 'Active', 28000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (3, 1, 3, 'A9012-LOC1', 'Arista', 'Model-X2', '2023-03-20', '2024-09-01', 'Active', 14000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (4, 1, 4, 'A3456-LOC1', 'Nokia', 'Model-X5', '2022-11-05', '2024-06-10', 'Maintenance', 4800.00, '2026-10-09');
INSERT INTO public.equipment VALUES (5, 1, 5, 'A7890-LOC1', 'Ericsson', 'Model-X4', '2023-08-15', '2024-08-25', 'Active', 1900.00, '2026-10-09');
INSERT INTO public.equipment VALUES (6, 2, 1, 'B1234-LOC2', 'Cisco', 'Model-X1', '2022-02-10', '2024-08-15', 'Active', 48000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (7, 2, 2, 'B5678-LOC2', 'Juniper', 'Model-X3', '2021-07-20', '2024-07-20', 'Active', 29000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (8, 2, 3, 'B9012-LOC2', 'Arista', 'Model-X2', '2023-04-05', '2024-09-02', 'Active', 15500.00, '2026-10-09');
INSERT INTO public.equipment VALUES (9, 2, 4, 'B3456-LOC2', 'Nokia', 'Model-X5', '2022-12-01', '2024-06-15', 'Active', 5200.00, '2026-10-09');
INSERT INTO public.equipment VALUES (10, 3, 1, 'C1234-LOC3', 'Cisco', 'Model-X1', '2022-03-15', '2024-08-10', 'Active', 46000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (11, 3, 2, 'C5678-LOC3', 'Juniper', 'Model-X3', '2021-08-30', '2024-07-25', 'Active', 30000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (12, 3, 3, 'C9012-LOC3', 'Arista', 'Model-X2', '2023-05-10', '2024-09-05', 'Active', 14500.00, '2026-10-09');
INSERT INTO public.equipment VALUES (13, 4, 1, 'D1234-LOC4', 'Cisco', 'Model-X1', '2022-04-20', '2024-08-05', 'Active', 49000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (14, 4, 2, 'D5678-LOC4', 'Juniper', 'Model-X3', '2021-09-15', '2024-07-30', 'Active', 28500.00, '2026-10-09');
INSERT INTO public.equipment VALUES (15, 4, 3, 'D9012-LOC4', 'Arista', 'Model-X2', '2023-06-25', '2024-09-10', 'Active', 15000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (16, 4, 4, 'D3456-LOC4', 'Nokia', 'Model-X5', '2023-01-10', '2024-06-20', 'Active', 5100.00, '2026-10-09');
INSERT INTO public.equipment VALUES (17, 5, 1, 'E1234-LOC5', 'Cisco', 'Model-X1', '2022-05-10', '2024-08-01', 'Active', 47000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (18, 5, 2, 'E5678-LOC5', 'Juniper', 'Model-X3', '2021-10-20', '2024-08-05', 'Active', 29500.00, '2026-10-09');
INSERT INTO public.equipment VALUES (19, 5, 5, 'E7890-LOC5', 'Ericsson', 'Model-X4', '2023-07-15', '2024-09-01', 'Active', 2100.00, '2026-10-09');
INSERT INTO public.equipment VALUES (20, 6, 1, 'F1234-LOC6', 'Cisco', 'Model-X1', '2022-06-15', '2024-07-25', 'Active', 48500.00, '2026-10-09');
INSERT INTO public.equipment VALUES (21, 6, 3, 'F9012-LOC6', 'Arista', 'Model-X2', '2023-08-30', '2024-09-15', 'Active', 14800.00, '2026-10-09');
INSERT INTO public.equipment VALUES (22, 6, 4, 'F3456-LOC6', 'Nokia', 'Model-X5', '2023-02-20', '2024-06-25', 'Active', 5000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (23, 7, 2, 'G5678-LOC7', 'Juniper', 'Model-X3', '2021-11-10', '2024-08-10', 'Active', 31000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (24, 7, 3, 'G9012-LOC7', 'Arista', 'Model-X2', '2023-09-05', '2024-09-20', 'Active', 15200.00, '2026-10-09');
INSERT INTO public.equipment VALUES (25, 8, 1, 'H1234-LOC8', 'Cisco', 'Model-X1', '2022-07-20', '2024-07-20', 'Active', 50000.00, '2026-10-09');
INSERT INTO public.equipment VALUES (26, 8, 2, 'H5678-LOC8', 'Juniper', 'Model-X3', '2021-12-01', '2024-08-15', 'Active', 30500.00, '2026-10-09');
INSERT INTO public.equipment VALUES (27, 8, 4, 'H3456-LOC8', 'Nokia', 'Model-X5', '2023-03-15', '2024-06-30', 'Maintenance', 4900.00, '2026-10-09');
INSERT INTO public.equipment VALUES (28, 9, 1, 'I1234-LOC9', 'Cisco', 'Model-X1', '2022-08-10', '2024-07-15', 'Active', 46500.00, '2026-10-09');
INSERT INTO public.equipment VALUES (29, 9, 5, 'I7890-LOC9', 'Ericsson', 'Model-X4', '2023-09-20', '2024-09-25', 'Active', 2000.00, '2026-10-09');


--
-- Data for Name: equipment_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.equipment_types VALUES (1, 'Router', 'Core routing device', 50000.00);
INSERT INTO public.equipment_types VALUES (2, 'Switch', 'Network switch', 30000.00);
INSERT INTO public.equipment_types VALUES (3, 'Fiber Node', 'Fiber optic node', 15000.00);
INSERT INTO public.equipment_types VALUES (4, 'Backup Power', 'UPS/battery backup', 5000.00);
INSERT INTO public.equipment_types VALUES (5, 'Splitter', 'Fiber splitter', 2000.00);


--
-- Data for Name: incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.incidents VALUES (1, 1, 1, '2024-01-15 14:30:00', 'Hardware Failure', 'Critical', 'Router main CPU failure', 5000, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (2, 3, 1, '2024-01-20 09:15:00', 'Fiber Cut', 'High', 'Fiber optic line damaged during construction', 3200, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (3, 2, 1, '2024-02-01 11:45:00', 'Power Loss', 'Critical', 'UPS backup failed during power surge', 8000, 'Closed', '2026-10-09');
INSERT INTO public.incidents VALUES (4, 4, 1, '2024-02-05 16:20:00', 'Software Bug', 'Medium', 'Router firmware issue causing packet loss', 1500, 'In Progress', '2026-10-09');
INSERT INTO public.incidents VALUES (5, 1, 1, '2024-02-10 08:30:00', 'Hardware Failure', 'High', 'Port card failure on core router', 4500, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (6, 5, 1, '2024-02-15 13:45:00', 'Fiber Cut', 'Medium', 'Splitter connection issue', 2000, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (7, 2, 1, '2024-02-20 10:15:00', 'Power Loss', 'High', 'Backup power system malfunction', 6500, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (8, 3, 1, '2024-03-01 15:30:00', 'Hardware Failure', 'Critical', 'Fiber node complete failure', 7200, 'Closed', '2026-10-09');
INSERT INTO public.incidents VALUES (9, 1, 1, '2024-03-05 09:45:00', 'Software Bug', 'Low', 'Minor configuration error', 800, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (10, 4, 1, '2024-03-10 14:20:00', 'Unknown', 'Medium', 'Intermittent connectivity issues', 2200, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (11, 6, 2, '2024-01-12 10:30:00', 'Fiber Cut', 'Critical', 'External fiber damage', 4800, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (12, 7, 2, '2024-01-25 12:45:00', 'Power Loss', 'High', 'Partial power outage', 3000, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (13, 8, 2, '2024-02-03 08:15:00', 'Hardware Failure', 'High', 'Switch port malfunction', 2500, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (14, 6, 2, '2024-02-12 16:00:00', 'Software Bug', 'Medium', 'Configuration mismatch', 1200, 'In Progress', '2026-10-09');
INSERT INTO public.incidents VALUES (15, 7, 2, '2024-02-18 11:30:00', 'Fiber Cut', 'High', 'Accidental fiber damage', 3600, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (16, 9, 2, '2024-02-25 09:00:00', 'Power Loss', 'Medium', 'Battery backup depleted', 1800, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (17, 6, 2, '2024-03-02 13:20:00', 'Unknown', 'Low', 'Temporary service interruption', 900, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (18, 8, 2, '2024-03-08 10:45:00', 'Hardware Failure', 'Critical', 'Switch failure requires replacement', 5500, 'Closed', '2026-10-09');
INSERT INTO public.incidents VALUES (19, 7, 2, '2024-03-12 15:15:00', 'Fiber Cut', 'Medium', 'Loose connection resolved', 2100, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (20, 6, 2, '2024-03-18 12:00:00', 'Software Bug', 'Low', 'Minor firmware update', 700, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (21, 10, 3, '2024-01-18 11:00:00', 'Hardware Failure', 'High', 'Router processor overheat', 3400, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (22, 11, 3, '2024-02-02 14:30:00', 'Power Loss', 'Critical', 'Primary power supply failure', 5100, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (23, 12, 3, '2024-02-08 09:45:00', 'Fiber Cut', 'High', 'Construction damage to fiber line', 2800, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (24, 10, 3, '2024-02-14 16:20:00', 'Software Bug', 'Medium', 'OSPF routing protocol issue', 1600, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (25, 11, 3, '2024-02-21 10:30:00', 'Unknown', 'Low', 'Brief network disruption', 500, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (26, 12, 3, '2024-03-01 13:00:00', 'Fiber Cut', 'Medium', 'Splitter calibration issue', 2000, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (27, 10, 3, '2024-03-07 11:45:00', 'Hardware Failure', 'Medium', 'Port interface card failing', 2200, 'In Progress', '2026-10-09');
INSERT INTO public.incidents VALUES (28, 11, 3, '2024-03-14 15:30:00', 'Power Loss', 'High', 'Generator not activated during outage', 4300, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (29, 12, 3, '2024-03-19 09:15:00', 'Software Bug', 'Low', 'SNMP configuration error', 650, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (30, 10, 3, '2024-03-25 14:00:00', 'Unknown', 'Medium', 'Intermittent packet drops', 1900, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (31, 13, 4, '2024-01-20 13:15:00', 'Hardware Failure', 'Critical', 'Core router fatal error', 6200, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (32, 14, 4, '2024-01-28 10:00:00', 'Fiber Cut', 'High', 'Backhoe hit fiber conduit', 4100, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (33, 15, 4, '2024-02-05 15:45:00', 'Power Loss', 'High', 'Extended power outage', 5500, 'Closed', '2026-10-09');
INSERT INTO public.incidents VALUES (34, 16, 4, '2024-02-11 08:30:00', 'Software Bug', 'Medium', 'BGP route filtering error', 1400, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (35, 13, 4, '2024-02-16 12:00:00', 'Fiber Cut', 'Medium', 'Fiber connector detachment', 2300, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (36, 14, 4, '2024-02-22 14:20:00', 'Power Loss', 'Medium', 'UPS battery degradation', 2600, 'In Progress', '2026-10-09');
INSERT INTO public.incidents VALUES (37, 15, 4, '2024-03-01 11:30:00', 'Hardware Failure', 'High', 'Switch fabric error', 3800, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (38, 16, 4, '2024-03-06 09:00:00', 'Unknown', 'Low', 'Network latency spike', 1100, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (39, 13, 4, '2024-03-13 16:15:00', 'Software Bug', 'Medium', 'Queue management overflow', 1800, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (40, 14, 4, '2024-03-20 10:45:00', 'Fiber Cut', 'High', 'Fiber splice point failure', 3700, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (41, 17, 5, '2024-01-22 14:00:00', 'Hardware Failure', 'High', 'Router interface failure', 2900, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (42, 18, 5, '2024-01-30 11:15:00', 'Power Loss', 'Critical', 'Complete power system failure', 4800, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (43, 19, 5, '2024-02-07 09:30:00', 'Fiber Cut', 'Medium', 'Fiber connection loose', 1900, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (44, 17, 5, '2024-02-13 13:45:00', 'Software Bug', 'Low', 'Minor ACL configuration issue', 600, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (45, 18, 5, '2024-02-19 10:20:00', 'Unknown', 'Medium', 'Intermittent service drops', 2100, 'In Progress', '2026-10-09');
INSERT INTO public.incidents VALUES (46, 19, 5, '2024-02-26 15:00:00', 'Fiber Cut', 'High', 'External fiber damage', 3300, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (47, 17, 5, '2024-03-03 12:30:00', 'Hardware Failure', 'Medium', 'Port transceiver failure', 2000, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (48, 18, 5, '2024-03-09 08:45:00', 'Power Loss', 'High', 'Battery backup exhausted', 3900, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (49, 19, 5, '2024-03-16 14:15:00', 'Software Bug', 'Medium', 'Traffic engineering error', 1500, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (50, 17, 5, '2024-03-22 11:00:00', 'Fiber Cut', 'Medium', 'Splitter alignment issue', 2200, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (51, 20, 6, '2024-01-25 10:45:00', 'Fiber Cut', 'High', 'Construction damage', 2600, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (52, 21, 6, '2024-02-02 13:20:00', 'Power Loss', 'High', 'Generator malfunction', 3100, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (53, 22, 6, '2024-02-09 09:00:00', 'Hardware Failure', 'Medium', 'Card slot failure', 1700, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (54, 20, 6, '2024-02-15 14:30:00', 'Software Bug', 'Low', 'Routing update corruption', 800, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (55, 21, 6, '2024-02-21 11:45:00', 'Fiber Cut', 'Medium', 'Fiber micro-bend', 2000, 'In Progress', '2026-10-09');
INSERT INTO public.incidents VALUES (56, 22, 6, '2024-02-28 15:15:00', 'Power Loss', 'Medium', 'Power converter issue', 2400, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (57, 20, 6, '2024-03-05 10:00:00', 'Unknown', 'Low', 'Brief connectivity loss', 900, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (58, 21, 6, '2024-03-11 13:30:00', 'Hardware Failure', 'High', 'Fan assembly failure', 3200, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (59, 22, 6, '2024-03-17 09:45:00', 'Software Bug', 'Medium', 'Memory leak in process', 1300, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (60, 20, 6, '2024-03-23 14:00:00', 'Fiber Cut', 'High', 'Fiber damage from weather', 2900, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (61, 23, 7, '2024-01-28 11:30:00', 'Hardware Failure', 'Critical', 'Switch core failure', 4500, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (62, 24, 7, '2024-02-04 14:15:00', 'Fiber Cut', 'High', 'Underwater cable damage', 3100, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (63, 23, 7, '2024-02-10 10:00:00', 'Power Loss', 'High', 'Battery system depleted', 4000, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (64, 24, 7, '2024-02-16 15:45:00', 'Software Bug', 'Medium', 'BGP flapping issue', 1600, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (65, 23, 7, '2024-02-22 09:20:00', 'Unknown', 'Low', 'Momentary service pause', 700, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (66, 24, 7, '2024-03-02 12:50:00', 'Fiber Cut', 'Medium', 'Connector degradation', 2100, 'In Progress', '2026-10-09');
INSERT INTO public.incidents VALUES (67, 23, 7, '2024-03-08 14:30:00', 'Hardware Failure', 'High', 'Port module failure', 3600, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (68, 24, 7, '2024-03-14 11:00:00', 'Power Loss', 'Medium', 'UPS maintenance shutdown', 2300, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (69, 23, 7, '2024-03-21 13:15:00', 'Software Bug', 'Low', 'Interface description error', 950, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (70, 24, 7, '2024-03-27 10:30:00', 'Fiber Cut', 'High', 'Vandalism damage', 3400, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (71, 25, 8, '2024-02-01 12:00:00', 'Hardware Failure', 'Critical', 'Primary router failure', 7500, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (72, 26, 8, '2024-02-08 10:30:00', 'Power Loss', 'Critical', 'Complete power loss', 8200, 'Closed', '2026-10-09');
INSERT INTO public.incidents VALUES (73, 27, 8, '2024-02-14 14:45:00', 'Fiber Cut', 'High', 'Major fiber break', 4600, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (74, 25, 8, '2024-02-20 09:15:00', 'Software Bug', 'Medium', 'Route redistribution loop', 2000, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (75, 26, 8, '2024-02-26 13:30:00', 'Unknown', 'Medium', 'Intermittent packet loss', 2500, 'In Progress', '2026-10-09');
INSERT INTO public.incidents VALUES (76, 27, 8, '2024-03-04 11:45:00', 'Fiber Cut', 'High', 'Weather-related damage', 4200, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (77, 25, 8, '2024-03-10 15:00:00', 'Hardware Failure', 'High', 'Interface card malfunction', 3900, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (78, 26, 8, '2024-03-16 10:20:00', 'Power Loss', 'High', 'Extended power restoration', 5100, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (79, 27, 8, '2024-03-22 14:15:00', 'Software Bug', 'Low', 'Logging configuration issue', 1200, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (80, 25, 8, '2024-03-28 12:30:00', 'Fiber Cut', 'Medium', 'Loose fiber termination', 2800, 'Resolved', '2026-10-09');
INSERT INTO public.incidents VALUES (81, 1, 1, '2024-04-05 14:30:00', 'Hardware Failure', 'Medium', 'Router thermal issue', 2100, 'Open', '2026-10-09');
INSERT INTO public.incidents VALUES (82, 6, 2, '2024-04-10 10:15:00', 'Fiber Cut', 'High', 'Ongoing fiber monitoring', 3800, 'Open', '2026-10-09');
INSERT INTO public.incidents VALUES (83, 13, 4, '2024-04-15 13:45:00', 'Power Loss', 'Critical', 'Backup system investigation', 5500, 'Open', '2026-10-09');
INSERT INTO public.incidents VALUES (84, 19, 5, '2024-04-18 11:20:00', 'Software Bug', 'Medium', 'Network protocol analysis', 1400, 'Open', '2026-10-09');
INSERT INTO public.incidents VALUES (85, 23, 7, '2024-04-20 15:00:00', 'Unknown', 'High', 'Cause under investigation', 3200, 'Open', '2026-10-09');


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.locations VALUES (1, 1, 'NYC Downtown Hub', 'New York', 'NY', 40.71280000, -74.00600000, 8300000, '2026-10-09');
INSERT INTO public.locations VALUES (2, 1, 'Boston Central', 'Boston', 'MA', 42.36010000, -71.05890000, 700000, '2026-10-09');
INSERT INTO public.locations VALUES (3, 1, 'Philadelphia Hub', 'Philadelphia', 'PA', 39.95260000, -75.16520000, 1600000, '2026-10-09');
INSERT INTO public.locations VALUES (4, 2, 'Chicago Loop', 'Chicago', 'IL', 41.87810000, -87.62980000, 2700000, '2026-10-09');
INSERT INTO public.locations VALUES (5, 2, 'Dallas Downtown', 'Dallas', 'TX', 32.77670000, -96.79700000, 1300000, '2026-10-09');
INSERT INTO public.locations VALUES (6, 2, 'Kansas City Hub', 'Kansas City', 'MO', 39.09970000, -94.57860000, 500000, '2026-10-09');
INSERT INTO public.locations VALUES (7, 3, 'San Francisco Bay', 'San Francisco', 'CA', 37.77490000, -122.41940000, 900000, '2026-10-09');
INSERT INTO public.locations VALUES (8, 3, 'Los Angeles Central', 'Los Angeles', 'CA', 34.05220000, -118.24370000, 4000000, '2026-10-09');
INSERT INTO public.locations VALUES (9, 3, 'Seattle Metro', 'Seattle', 'WA', 47.60620000, -122.33210000, 750000, '2026-10-09');


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.regions VALUES (1, 'Eastern', 'East Coast networks', '2026-10-09');
INSERT INTO public.regions VALUES (2, 'Central', 'Midwest networks', '2026-10-09');
INSERT INTO public.regions VALUES (3, 'Western', 'West Coast networks', '2026-10-09');


--
-- Data for Name: repairs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.repairs VALUES (1, 1, 1, '2024-01-15 14:35:00', '2024-01-15 16:45:00', 'Replacement', 3500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (2, 2, 4, '2024-01-20 09:20:00', '2024-01-20 12:30:00', 'Splice', 2800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (3, 3, 2, '2024-02-01 12:00:00', '2024-02-01 14:15:00', 'Replacement', 4200.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (4, 4, 3, '2024-02-05 16:30:00', '2024-02-05 17:45:00', 'Patch', 800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (5, 5, 6, '2024-02-10 08:45:00', '2024-02-10 11:20:00', 'Replacement', 3100.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (6, 6, 11, '2024-02-15 14:00:00', '2024-02-15 15:30:00', 'Repair', 1200.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (7, 7, 5, '2024-02-20 10:30:00', '2024-02-20 13:00:00', 'Replacement', 2900.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (8, 8, 7, '2024-03-01 15:45:00', '2024-03-01 18:20:00', 'Replacement', 5200.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (9, 9, 2, '2024-03-05 10:00:00', '2024-03-05 10:30:00', 'Patch', 600.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (10, 10, 9, '2024-03-10 14:35:00', '2024-03-10 16:15:00', 'Reboot', 400.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (11, 11, 15, '2024-01-12 10:45:00', '2024-01-12 13:20:00', 'Splice', 2500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (12, 12, 17, '2024-01-25 13:00:00', '2024-01-25 15:30:00', 'Replacement', 3800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (13, 13, 16, '2024-02-03 08:30:00', '2024-02-03 10:45:00', 'Replacement', 2100.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (14, 14, 18, '2024-02-12 16:15:00', '2024-02-12 17:00:00', 'Patch', 700.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (15, 15, 19, '2024-02-18 11:45:00', '2024-02-18 14:15:00', 'Splice', 2000.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (16, 16, 20, '2024-02-25 09:15:00', '2024-02-25 10:30:00', 'Replacement', 1800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (17, 17, 21, '2024-03-02 13:35:00', '2024-03-02 14:30:00', 'Reboot', 500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (18, 18, 22, '2024-03-08 11:00:00', '2024-03-08 13:45:00', 'Replacement', 4500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (19, 19, 23, '2024-03-12 15:30:00', '2024-03-12 16:45:00', 'Repair', 1100.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (20, 20, 24, '2024-03-18 12:15:00', '2024-03-18 13:00:00', 'Patch', 650.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (21, 21, 25, '2024-01-18 11:15:00', '2024-01-18 13:45:00', 'Replacement', 2800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (22, 22, 26, '2024-02-02 14:45:00', '2024-02-02 17:15:00', 'Replacement', 3900.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (23, 23, 27, '2024-02-08 10:00:00', '2024-02-08 12:30:00', 'Splice', 2300.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (24, 24, 28, '2024-02-14 16:35:00', '2024-02-14 17:20:00', 'Patch', 750.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (25, 25, 29, '2024-02-21 10:45:00', '2024-02-21 11:30:00', 'Reboot', 450.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (26, 26, 30, '2024-03-01 13:15:00', '2024-03-01 14:45:00', 'Repair', 1300.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (27, 27, 31, '2024-03-07 12:00:00', '2024-03-07 14:20:00', 'Replacement', 3200.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (28, 28, 32, '2024-03-14 15:45:00', '2024-03-14 17:50:00', 'Replacement', 4100.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (29, 29, 33, '2024-03-19 09:30:00', '2024-03-19 10:15:00', 'Patch', 700.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (30, 30, 34, '2024-03-25 14:15:00', '2024-03-25 15:45:00', 'Reboot', 500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (31, 31, 2, '2024-01-20 13:30:00', '2024-01-20 16:00:00', 'Replacement', 4800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (32, 32, 5, '2024-01-28 10:15:00', '2024-01-28 13:00:00', 'Splice', 3100.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (33, 33, 8, '2024-02-05 16:00:00', '2024-02-05 18:45:00', 'Replacement', 4500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (34, 34, 11, '2024-02-11 08:45:00', '2024-02-11 09:45:00', 'Patch', 800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (35, 35, 14, '2024-02-16 12:15:00', '2024-02-16 13:45:00', 'Splice', 2200.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (36, 36, 17, '2024-02-22 14:35:00', '2024-02-22 15:50:00', 'Replacement', 2100.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (37, 37, 20, '2024-03-01 11:45:00', '2024-03-01 13:15:00', 'Replacement', 3500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (38, 38, 23, '2024-03-06 09:15:00', '2024-03-06 10:30:00', 'Reboot', 450.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (39, 39, 26, '2024-03-13 16:30:00', '2024-03-13 17:50:00', 'Patch', 900.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (40, 40, 29, '2024-03-20 11:00:00', '2024-03-20 13:00:00', 'Splice', 2800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (41, 41, 3, '2024-01-22 14:15:00', '2024-01-22 16:30:00', 'Replacement', 2700.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (42, 42, 6, '2024-01-30 11:30:00', '2024-01-30 14:00:00', 'Replacement', 4200.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (43, 43, 9, '2024-02-07 09:45:00', '2024-02-07 11:15:00', 'Splice', 1900.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (44, 44, 12, '2024-02-13 14:00:00', '2024-02-13 14:45:00', 'Patch', 700.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (45, 45, 15, '2024-02-19 10:35:00', '2024-02-19 12:00:00', 'Reboot', 500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (46, 46, 18, '2024-02-26 15:15:00', '2024-02-26 16:45:00', 'Splice', 2600.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (47, 47, 21, '2024-03-03 12:45:00', '2024-03-03 14:30:00', 'Replacement', 1800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (48, 48, 24, '2024-03-09 09:00:00', '2024-03-09 10:45:00', 'Replacement', 3900.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (49, 49, 27, '2024-03-16 14:30:00', '2024-03-16 15:30:00', 'Patch', 850.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (50, 50, 30, '2024-03-22 11:15:00', '2024-03-22 12:45:00', 'Repair', 1100.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (51, 51, 4, '2024-01-25 11:00:00', '2024-01-25 13:15:00', 'Splice', 2300.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (52, 52, 7, '2024-02-02 13:35:00', '2024-02-02 15:45:00', 'Replacement', 3500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (53, 53, 10, '2024-02-09 09:15:00', '2024-02-09 10:45:00', 'Replacement', 1600.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (54, 54, 13, '2024-02-15 14:45:00', '2024-02-15 15:30:00', 'Patch', 750.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (55, 55, 16, '2024-02-21 12:00:00', '2024-02-21 13:20:00', 'Splice', 1800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (56, 56, 19, '2024-02-28 15:30:00', '2024-02-28 16:50:00', 'Replacement', 2400.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (57, 57, 22, '2024-03-05 10:15:00', '2024-03-05 11:30:00', 'Reboot', 500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (58, 58, 25, '2024-03-11 13:45:00', '2024-03-11 15:30:00', 'Replacement', 3100.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (59, 59, 28, '2024-03-17 10:00:00', '2024-03-17 11:00:00', 'Patch', 800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (60, 60, 31, '2024-03-23 14:15:00', '2024-03-23 15:50:00', 'Splice', 2500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (61, 61, 1, '2024-01-28 11:45:00', '2024-01-28 14:15:00', 'Replacement', 4200.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (62, 62, 5, '2024-02-04 14:30:00', '2024-02-04 16:45:00', 'Splice', 2800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (63, 63, 8, '2024-02-10 10:15:00', '2024-02-10 12:00:00', 'Replacement', 3800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (64, 64, 11, '2024-02-16 16:00:00', '2024-02-16 16:50:00', 'Patch', 700.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (65, 65, 14, '2024-02-22 09:35:00', '2024-02-22 10:30:00', 'Reboot', 500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (66, 66, 17, '2024-03-02 13:05:00', '2024-03-02 14:30:00', 'Splice', 2100.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (67, 67, 20, '2024-03-08 14:45:00', '2024-03-08 16:15:00', 'Replacement', 3400.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (68, 68, 23, '2024-03-14 11:15:00', '2024-03-14 13:00:00', 'Replacement', 2300.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (69, 69, 26, '2024-03-21 13:30:00', '2024-03-21 14:30:00', 'Patch', 900.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (70, 70, 29, '2024-03-27 10:45:00', '2024-03-27 12:15:00', 'Splice', 2600.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (71, 71, 2, '2024-02-01 12:15:00', '2024-02-01 14:45:00', 'Replacement', 5100.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (72, 72, 6, '2024-02-08 10:45:00', '2024-02-08 13:15:00', 'Replacement', 4000.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (73, 73, 9, '2024-02-14 15:00:00', '2024-02-14 17:20:00', 'Splice', 3100.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (74, 74, 12, '2024-02-20 09:30:00', '2024-02-20 10:30:00', 'Patch', 800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (75, 75, 15, '2024-02-26 13:45:00', '2024-02-26 15:15:00', 'Reboot', 500.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (76, 76, 18, '2024-03-04 12:00:00', '2024-03-04 13:30:00', 'Splice', 2400.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (77, 77, 21, '2024-03-10 15:15:00', '2024-03-10 17:00:00', 'Replacement', 3700.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (78, 78, 24, '2024-03-16 10:35:00', '2024-03-16 12:30:00', 'Replacement', 4800.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (79, 79, 27, '2024-03-22 14:30:00', '2024-03-22 15:45:00', 'Patch', 950.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (80, 80, 30, '2024-03-28 12:45:00', '2024-03-28 14:15:00', 'Splice', 2700.00, NULL, NULL, 'Completed', '2026-10-09');
INSERT INTO public.repairs VALUES (81, 81, 3, '2024-04-05 14:45:00', NULL, 'Diagnosis', 500.00, NULL, NULL, 'In Progress', '2026-10-09');
INSERT INTO public.repairs VALUES (82, 82, 12, '2024-04-10 10:30:00', NULL, 'Splicing', 1200.00, NULL, NULL, 'In Progress', '2026-10-09');
INSERT INTO public.repairs VALUES (83, 83, 21, '2024-04-15 14:00:00', NULL, 'Replacement', 3000.00, NULL, NULL, 'In Progress', '2026-10-09');
INSERT INTO public.repairs VALUES (84, 84, 33, '2024-04-18 11:35:00', NULL, 'Analysis', 800.00, NULL, NULL, 'In Progress', '2026-10-09');
INSERT INTO public.repairs VALUES (85, 85, 5, '2024-04-20 15:15:00', NULL, 'Investigation', 1000.00, NULL, NULL, 'In Progress', '2026-10-09');


--
-- Data for Name: technicians; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.technicians VALUES (1, 1, 'John', 'Smith', 'john.smith@telecom.com', '555-1234', 'Fiber Optics', '2020-03-15', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (2, 1, 'Mary', 'Johnson', 'mary.johnson@telecom.com', '555-1235', 'Router Config', '2019-06-20', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (3, 1, 'Bob', 'Brown', 'bob.brown@telecom.com', '555-1236', 'Network Mgmt', '2021-01-10', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (4, 1, 'Alice', 'Davis', 'alice.davis@telecom.com', '555-1237', 'Fiber Splicing', '2022-05-15', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (5, 1, 'Charlie', 'Wilson', 'charlie.wilson@telecom.com', '555-1238', 'Power Systems', '2021-11-20', 'On Leave', '2026-10-09');
INSERT INTO public.technicians VALUES (6, 1, 'Diana', 'Moore', 'diana.moore@telecom.com', '555-1239', 'Software', '2020-08-10', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (7, 1, 'Eve', 'Taylor', 'eve.taylor@telecom.com', '555-1240', 'Fiber Optics', '2019-02-15', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (8, 1, 'Frank', 'Anderson', 'frank.anderson@telecom.com', '555-1241', 'Router Config', '2022-04-20', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (9, 1, 'Grace', 'Thomas', 'grace.thomas@telecom.com', '555-1242', 'Network Mgmt', '2021-07-05', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (10, 1, 'Henry', 'Jackson', 'henry.jackson@telecom.com', '555-1243', 'Fiber Splicing', '2020-09-30', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (11, 1, 'Iris', 'White', 'iris.white@telecom.com', '555-1244', 'Power Systems', '2022-01-15', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (12, 1, 'Jack', 'Harris', 'jack.harris@telecom.com', '555-1245', 'Software', '2019-10-20', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (13, 1, 'Karen', 'Martin', 'karen.martin@telecom.com', '555-1246', 'Fiber Optics', '2021-03-10', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (14, 1, 'Leo', 'Garcia', 'leo.garcia@telecom.com', '555-1247', 'Router Config', '2020-12-05', 'On Leave', '2026-10-09');
INSERT INTO public.technicians VALUES (15, 2, 'Maria', 'Rodriguez', 'maria.rodriguez@telecom.com', '555-2234', 'Fiber Optics', '2021-02-15', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (16, 2, 'Mike', 'Jones', 'mike.jones@telecom.com', '555-2235', 'Router Config', '2020-05-20', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (17, 2, 'Nancy', 'Miller', 'nancy.miller@telecom.com', '555-2236', 'Network Mgmt', '2022-03-10', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (18, 2, 'Oscar', 'Davis', 'oscar.davis@telecom.com', '555-2237', 'Fiber Splicing', '2021-08-15', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (19, 2, 'Patricia', 'Wilson', 'patricia.wilson@telecom.com', '555-2238', 'Power Systems', '2020-11-20', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (20, 2, 'Quinn', 'Moore', 'quinn.moore@telecom.com', '555-2239', 'Software', '2022-06-10', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (21, 2, 'Rachel', 'Taylor', 'rachel.taylor@telecom.com', '555-2240', 'Fiber Optics', '2019-09-15', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (22, 2, 'Steven', 'Anderson', 'steven.anderson@telecom.com', '555-2241', 'Router Config', '2021-04-20', 'On Leave', '2026-10-09');
INSERT INTO public.technicians VALUES (23, 2, 'Tina', 'Thomas', 'tina.thomas@telecom.com', '555-2242', 'Network Mgmt', '2020-12-05', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (24, 2, 'Uma', 'Jackson', 'uma.jackson@telecom.com', '555-2243', 'Fiber Splicing', '2022-02-28', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (25, 2, 'Victor', 'White', 'victor.white@telecom.com', '555-2244', 'Power Systems', '2021-07-15', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (26, 2, 'Wendy', 'Harris', 'wendy.harris@telecom.com', '555-2245', 'Software', '2020-03-20', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (27, 2, 'Xavier', 'Martin', 'xavier.martin@telecom.com', '555-2246', 'Fiber Optics', '2022-05-10', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (28, 2, 'Yara', 'Garcia', 'yara.garcia@telecom.com', '555-2247', 'Router Config', '2021-01-05', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (29, 3, 'Zack', 'Rodriguez', 'zack.rodriguez@telecom.com', '555-3234', 'Fiber Optics', '2020-08-15', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (30, 3, 'Amy', 'Jones', 'amy.jones@telecom.com', '555-3235', 'Router Config', '2019-11-20', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (31, 3, 'Ben', 'Miller', 'ben.miller@telecom.com', '555-3236', 'Network Mgmt', '2021-05-10', 'On Leave', '2026-10-09');
INSERT INTO public.technicians VALUES (32, 3, 'Celia', 'Davis', 'celia.davis@telecom.com', '555-3237', 'Fiber Splicing', '2022-02-15', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (33, 3, 'David', 'Wilson', 'david.wilson@telecom.com', '555-3238', 'Power Systems', '2021-09-20', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (34, 3, 'Ella', 'Moore', 'ella.moore@telecom.com', '555-3239', 'Software', '2020-04-10', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (35, 3, 'Fred', 'Taylor', 'fred.taylor@telecom.com', '555-3240', 'Fiber Optics', '2022-07-15', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (36, 3, 'Gina', 'Anderson', 'gina.anderson@telecom.com', '555-3241', 'Router Config', '2021-06-20', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (37, 3, 'Hugo', 'Thomas', 'hugo.thomas@telecom.com', '555-3242', 'Network Mgmt', '2020-10-05', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (38, 3, 'Ivy', 'Jackson', 'ivy.jackson@telecom.com', '555-3243', 'Fiber Splicing', '2022-04-28', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (39, 3, 'Jake', 'White', 'jake.white@telecom.com', '555-3244', 'Power Systems', '2021-12-15', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (40, 3, 'Keisha', 'Harris', 'keisha.harris@telecom.com', '555-3245', 'Software', '2020-06-20', 'Active', '2026-10-09');
INSERT INTO public.technicians VALUES (41, 3, 'Leon', 'Martin', 'leon.martin@telecom.com', '555-3246', 'Fiber Optics', '2021-10-10', 'Active', '2026-10-09');


--
-- Name: equipment_equipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_equipment_id_seq', 29, true);


--
-- Name: equipment_types_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_types_type_id_seq', 5, true);


--
-- Name: incidents_incident_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incidents_incident_id_seq', 85, true);


--
-- Name: locations_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locations_location_id_seq', 9, true);


--
-- Name: regions_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regions_region_id_seq', 3, true);


--
-- Name: repairs_repair_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.repairs_repair_id_seq', 85, true);


--
-- Name: technicians_technician_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.technicians_technician_id_seq', 41, true);


--
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (equipment_id);


--
-- Name: equipment equipment_serial_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_serial_number_key UNIQUE (serial_number);


--
-- Name: equipment_types equipment_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_types
    ADD CONSTRAINT equipment_types_pkey PRIMARY KEY (type_id);


--
-- Name: equipment_types equipment_types_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_types
    ADD CONSTRAINT equipment_types_type_name_key UNIQUE (type_name);


--
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (incident_id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (location_id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (region_id);


--
-- Name: regions regions_region_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_region_name_key UNIQUE (region_name);


--
-- Name: repairs repairs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repairs
    ADD CONSTRAINT repairs_pkey PRIMARY KEY (repair_id);


--
-- Name: technicians technicians_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technicians
    ADD CONSTRAINT technicians_email_key UNIQUE (email);


--
-- Name: technicians technicians_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technicians
    ADD CONSTRAINT technicians_pkey PRIMARY KEY (technician_id);


--
-- Name: equipment equipment_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(location_id);


--
-- Name: equipment equipment_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.equipment_types(type_id);


--
-- Name: incidents incidents_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES public.equipment(equipment_id);


--
-- Name: incidents incidents_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(location_id);


--
-- Name: locations locations_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(region_id);


--
-- Name: repairs repairs_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repairs
    ADD CONSTRAINT repairs_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(incident_id);


--
-- Name: repairs repairs_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repairs
    ADD CONSTRAINT repairs_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(technician_id);


--
-- Name: technicians technicians_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technicians
    ADD CONSTRAINT technicians_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(region_id);


--
-- PostgreSQL database dump complete
--


