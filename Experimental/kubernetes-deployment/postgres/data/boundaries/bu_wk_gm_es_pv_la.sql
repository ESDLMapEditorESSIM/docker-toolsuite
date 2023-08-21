-- SEQUENCE: public.bu_wk_gm_es_pv_la_2019_gid_seq

-- DROP SEQUENCE public.bu_wk_gm_es_pv_la_2019_gid_seq;

CREATE SEQUENCE public.bu_wk_gm_es_pv_la_2019_gid_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.bu_wk_gm_es_pv_la_2019_gid_seq
    OWNER TO boundary_service;
	
CREATE TABLE public.bu_wk_gm_es_pv_la_2019
(
    gid integer NOT NULL DEFAULT nextval('bu_wk_gm_es_pv_la_2019_gid_seq'::regclass),
    bu_code character varying(10) COLLATE pg_catalog."default",
    bu_naam character varying(60) COLLATE pg_catalog."default",
	wk_code character varying(8) COLLATE pg_catalog."default",
    wk_naam character varying(60) COLLATE pg_catalog."default",
    gm_code character varying(6) COLLATE pg_catalog."default",
    gm_naam character varying(60) COLLATE pg_catalog."default",
    pv_code character varying(4) COLLATE pg_catalog."default",
    pv_naam character varying(60) COLLATE pg_catalog."default",
    es_code character varying(5) COLLATE pg_catalog."default",
    es_naam character varying(60) COLLATE pg_catalog."default",
    la_code character varying(2) COLLATE pg_catalog."default",
    la_naam character varying(60) COLLATE pg_catalog."default",
    CONSTRAINT bu_wk_gm_es_pv_la_2019_pkey PRIMARY KEY (gid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.bu_wk_gm_es_pv_la_2019
    OWNER to boundary_service;
-- Index: bu_wk_gm_es_pv_la_2019_pv_code_idx

-- DROP INDEX public.bu_wk_gm_es_pv_la_2019_pv_code_idx;

CREATE INDEX bu_wk_gm_es_pv_la_2019_pv_code_idx
    ON public.bu_wk_gm_es_pv_la_2019 USING btree
    (pv_code COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: bu_wk_gm_es_pv_la_2019_res_code_idx

-- DROP INDEX public.bu_wk_gm_es_pv_la_2019_res_code_idx;

CREATE INDEX bu_wk_gm_es_pv_la_2019_es_code_idx
    ON public.bu_wk_gm_es_pv_la_2019 USING btree
    (es_code COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
	
COPY bu_wk_gm_es_pv_la_2019(bu_code,bu_naam,wk_code,wk_naam,gm_code,gm_naam,pv_code,pv_naam,es_code,es_naam,la_code,la_naam) FROM '/data/boundaries/BUWKGMPVESLA.csv' DELIMITER ';' CSV HEADER;
