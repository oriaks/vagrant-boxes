TEMPLATES:=$(shell find packer-templates/ -name '*.json' -printf '%f ' | sed 's|\.json||g;')

PACKER_CACHE_DIR:=packer-cache
export PACKER_CACHE_DIR

ifdef ONLY
	ARGS="--only=${ONLY}"
endif

.PHONY: $(TEMPLATES)

all: $(TEMPLATES)

$(TEMPLATES):
	packer build ${ARGS} packer-templates/$@.json

mostlyclean:
	rm -f vagrant-boxes/*

clean: mostlyclean
	rm -f packer-cache/*
