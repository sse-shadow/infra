CREATE TABLE public.users
(
    id serial NOT NULL,
    username character varying(40) NOT NULL,
    password_hash character(128) NOT NULL,
    PRIMARY KEY (id, username)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.users
    OWNER to postgres;
COMMENT ON TABLE public.users
    IS 'Main User table, stores all login info';