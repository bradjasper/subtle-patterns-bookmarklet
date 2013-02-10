SHELL:=/bin/bash
BASE_DIR=`pwd`
SRC_DIR=${BASE_DIR}/src
STATIC_DIR=${BASE_DIR}/static
JS_DIR=${STATIC_DIR}/js
CSS_DIR=${STATIC_DIR}/css

all: build combine

build:
	# Compile Coffeescript
	ls *.coffee ${SRC_DIR}/*.coffee | xargs coffee --output ${JS_DIR} --compile;

	# Compile Less
	lessc ${SRC_DIR}/bookmarklet.less ${CSS_DIR}/bookmarklet.css
	if [ -f app.less ]; \
	then \
	  lessc app.less ${CSS_DIR}/app.css; \
	fi

combine:
	# Build static assets
	for file in "${JS_DIR}/jquery.min.js" \
				"${JS_DIR}/subtlepatterns.js" \
				"${JS_DIR}/bookmarklet.js" \
				"${JS_DIR}/loader.js"; do \
			cat $$file; echo; \
	done | jsmin > "${JS_DIR}/all.js"

