SHELL:=/bin/bash
BASE_DIR=`pwd`
SRC_DIR=${BASE_DIR}/src
STATIC_DIR=${BASE_DIR}/static
JS_DIR=${STATIC_DIR}/js
CSS_DIR=${STATIC_DIR}/css

all: build

build:
	# Compile Coffeescript
	coffee --output ${JS_DIR} --compile app.coffee ${SRC_DIR}/loader.coffee
	coffee --join ${JS_DIR}/bookmarklet.js --compile ${SRC_DIR}/subtlepatterns.coffee \
													 ${SRC_DIR}/element_selector.coffee \
													 ${SRC_DIR}/overlay.coffee

	cat ${JS_DIR}/jquery.min.js ${JS_DIR}/bookmarklet.js ${JS_DIR}/loader.js | jsmin > ${JS_DIR}/all.js
	cat ${JS_DIR}/jquery.min.js ${JS_DIR}/bookmarklet.js ${JS_DIR}/app.js | jsmin > ${JS_DIR}/app.min.js

	# Compile Less
	lessc ${SRC_DIR}/bookmarklet.less ${CSS_DIR}/bookmarklet.css

	# Compile website css if it's around
	if [ -f app.less ]; then lessc app.less ${CSS_DIR}/app.css; fi

	# Combine bookmarklet css
	cat ${CSS_DIR}/hint.min.css > ${CSS_DIR}/all.css
	cat ${CSS_DIR}/bookmarklet.css >> ${CSS_DIR}/all.css
