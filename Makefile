EXTENSION    = b64enc
EXTVERSION   = $(shell grep default_version $(EXTENSION).control | sed -e "s/default_version[[:space:]]*=[[:space:]]*'\([^']*\)'/\1/")

DATA         = $(filter-out $(wildcard sql/*--*.sql),$(wildcard sql/*.sql))
DOCS         = $(wildcard doc/*.md)
TESTS        = $(wildcard test/sql/*.sql)
REGRESS      = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test --load-language=plpgsql
MODULE_big      = b64enc
OBJS         =  $(patsubst %.c,%.o,$(wildcard src/*.c))
PG_CONFIG    = pg_config

all: sql/$(EXTENSION)--$(EXTVERSION).sql $(EXTENSION).so

sql/$(EXTENSION)--$(EXTVERSION).sql: sql/$(EXTENSION).sql
	cp $< $@

override b64enc.so: target/release/libb64enc.so
	cp $< $@

target/release/libb64enc_modmagic.a: src/b64enc_modmagic.o
	mkdir -p target/release
	ar crs $@ $<


target/release/libb64enc.so: src/lib.rs Cargo.toml target/release/libb64enc_modmagic.a
	cargo build --release


DATA_built = sql/$(EXTENSION)--$(EXTVERSION).sql
DATA = $(filter-out sql/$(EXTENSION)--$(EXTVERSION).sql, $(wildcard sql/*--*.sql))
EXTRA_CLEAN = sql/$(EXTENSION)--$(EXTVERSION).sql $(wildcard target/release/lib*))

PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
