-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION b64enc" to load this file. \quit

CREATE TYPE b64enc;

CREATE FUNCTION b64enc_in(cstring)
RETURNS b64enc
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE FUNCTION b64enc_out(b64enc)
RETURNS cstring
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

/*
CREATE FUNCTION b64enc_recv(internal)
RETURNS b64enc
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE FUNCTION b64enc_send(b64enc)
RETURNS bytea
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

*/

CREATE TYPE b64enc (
        INTERNALLENGTH = 8,
        INPUT = b64enc_in,
        OUTPUT = b64enc_out,
/*
        RECEIVE = b64enc_recv,
        SEND = b64enc_send,
*/
        ALIGNMENT = double,
        PASSEDBYVALUE
);

