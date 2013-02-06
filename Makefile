SHELL:=/bin/bash
BASE_DIR=`pwd`
STATIC_DIR=${BASE_DIR}/static
JS_DIR=${STATIC_DIR}/js

all: static_files

static_files:
	echo "Building static assets"
	for file in "${JS_DIR}/jquery.min.js" \
				"${JS_DIR}/subtlepatterns.js" \
				"${JS_DIR}/bookmarklet.js"; do \
			cat $$file; echo; \
	done | jsmin > "${JS_DIR}/all.js"

