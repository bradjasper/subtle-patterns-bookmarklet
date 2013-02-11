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

	# Compile website css if it's around
	if [ -f app.less ]; then lessc app.less ${CSS_DIR}/app.css; fi

	# Combine bookmarklet css
	cat ${CSS_DIR}/hint.min.css > ${CSS_DIR}/all.css
	cat ${CSS_DIR}/bookmarklet.css >> ${CSS_DIR}/all.css

combine:
	# Build static assets
	cd ${JS_DIR} && cat jquery.min.js subtlepatterns.js bookmarklet.js loader.js | jsmin > all.js
