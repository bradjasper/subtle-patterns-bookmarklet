SHELL:=/bin/bash
BASE_DIR=`pwd`
SRC_DIR=${BASE_DIR}/src
STATIC_DIR=${BASE_DIR}/static
JS_DIR=${STATIC_DIR}/js
CSS_DIR=${STATIC_DIR}/css

all: coffeescript less

coffeescript:
	coffee --output ${JS_DIR} --compile app.coffee ${SRC_DIR}/loader.coffee
	coffee --join ${JS_DIR}/bookmarklet.js --compile ${SRC_DIR}/overlay.coffee \
													 ${SRC_DIR}/utils.coffee \
													 ${SRC_DIR}/subtlepatterns.coffee \
													 ${SRC_DIR}/element_selector.coffee \
													 ${SRC_DIR}/bookmarklet.coffee

	cat ${JS_DIR}/jquery.min.js ${JS_DIR}/bookmarklet.js ${JS_DIR}/loader.js | jsmin > ${JS_DIR}/all.js
	cat ${JS_DIR}/jquery.min.js ${JS_DIR}/bookmarklet.js ${JS_DIR}/app.js | jsmin > ${JS_DIR}/app.min.js


less:
	lessc ${SRC_DIR}/bookmarklet.less ${CSS_DIR}/bookmarklet.css

	if [ -f app.less ]; then \
		lessc app.less ${CSS_DIR}/app.css; \
	fi

	cat ${CSS_DIR}/bookmarklet.css > ${CSS_DIR}/all.css
