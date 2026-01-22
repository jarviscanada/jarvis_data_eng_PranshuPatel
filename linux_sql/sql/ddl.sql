-- ddl.sql
-- Creates tables for host_agent_monitor database
-- Run using:
-- psql -h localhost -U postgres -d host_agent_monitor -f sql/ddl.sql

\c host_agent_monitor

  CREATE TABLE IF NOT EXISTS public.host_info
(
  id               SERIAL PRIMARY KEY,
  hostname         VARCHAR NOT NULL UNIQUE,
  cpu_number       SMALLINT NOT NULL,
  cpu_architecture VARCHAR NOT NULL,
  cpu_model        VARCHAR NOT NULL,
  cpu_mhz          DOUBLE PRECISION NOT NULL,
  l2_cache         INTEGER NOT NULL,
  total_mem        INTEGER,
  "timestamp"      TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.host_usage
(
  "timestamp"    TIMESTAMP NOT NULL,
  host_id        SERIAL NOT NULL,
  memory_free    INTEGER NOT NULL,
  cpu_idle       SMALLINT NOT NULL,
  cpu_kernel     SMALLINT NOT NULL,
  disk_io        INTEGER NOT NULL,
  disk_available INTEGER NOT NULL,
  CONSTRAINT host_usage_host_info_fk
    FOREIGN KEY (host_id) REFERENCES public.host_info(id)
);

