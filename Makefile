TEMPLATES:=$(shell find packer-templates/ -name '*.json' -printf '%f ' | sed 's|\.json||g;')

PACKER_CACHE_DIR:=packer-cache
export PACKER_CACHE_DIR

ifdef ONLY
	ARGS="--only=${ONLY}"
endif

.PHONY: $(TEMPLATES)

all: $(TEMPLATES)

$(TEMPLATES):
	$(eval ISO_SOURCE=$(shell awk -F '"' '/"_iso_url"/ {print $$4; exit}' '${CURDIR}/packer-templates/$@.json'))
	$(eval ISO_TARGET=$(shell awk -F '"' '/"iso_url"/ {print $$4; exit}' '${CURDIR}/packer-templates/$@.json'))
	@if [ -n "${ISO_SOURCE}" -a ! -f "${ISO_TARGET}" ]; then \
	  case `echo ${ISO_SOURCE} | awk -F '.' '{print $$NF}'` in \
	    bz2 ) \
	      curl -fLsS "${ISO_SOURCE}" | bunzip2 -c > "${ISO_TARGET}" \
	      ;; \
	    gz ) \
	      curl -fLsS "${ISO_SOURCE}" | gunzip -c > "${ISO_TARGET}" \
	      ;; \
	  esac \
	fi
	packer build ${ARGS} packer-templates/$@.json

clean:
	rm -f ${CURDIR}/vagrant-boxes/*

distclean: clean
	rm -f ${CURDIR}/packer-cache/*
