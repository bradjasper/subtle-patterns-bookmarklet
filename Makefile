SHELL:=/bin/bash
BASE_DIR=`pwd`
SRC_DIR=${BASE_DIR}/src
STATIC_DIR=${BASE_DIR}/static
JS_DIR=${STATIC_DIR}/js
CSS_DIR=${STATIC_DIR}/css

all: coffeescript less

coffeescript:
	coffee --output ${JS_DIR} --compile app.coffee ${SRC_DIR}/loader.coffee
	coffee --join ${JS_DIR}/bookmarklet.js --compile ${SRC_DIR}/templates.coffee \
													 ${SRC_DIR}/utils.coffee \
													 ${SRC_DIR}/subtlepatterns.coffee \
													 ${SRC_DIR}/element_selector.coffee \
													 ${SRC_DIR}/bookmarklet.coffee

	for bundle in app loader; do \
		cat ${JS_DIR}/jquery.min.js ${JS_DIR}/bookmarklet.js ${JS_DIR}/$$bundle.js \
		| jsmin > ${JS_DIR}/$$bundle.min.js; \
	done

	# all.js is the entry point for our application
	cp ${JS_DIR}/loader.min.js ${JS_DIR}/all.js


less:
	lessc ${SRC_DIR}/bookmarklet.less ${CSS_DIR}/bookmarklet.css

	if [ -f app.less ]; then \
		lessc app.less ${CSS_DIR}/app.css; \
	fi

	cat ${CSS_DIR}/bookmarklet.css > ${CSS_DIR}/all.css
