SHELL:=/bin/bash
BASE_DIR=`pwd`
BIN_DIR=${BASE_DIR}/bin
MIRROR_DIR=${BASE_DIR}/subtlepatterns.com
HTML_DIR=${MIRROR_DIR}/html
PATTERNS_DIR=${MIRROR_DIR}/patterns
STATIC_DIR=${BASE_DIR}/static
JS_DIR=${STATIC_DIR}/js
CSS_DIR=${STATIC_DIR}/css
ALLJS="${JS_DIR}/all.js"

mirror_html:
	$(error Warning: This is an expensive operation that hits SubtlePatterns.com. Only do it once––then save it. Remove this warning to continue)
	echo "Mirroring SubtlePatterns.com HTML to ${HTML_DIR}"
	rm -rf ${HTML_DIR}/index.html*
	cd ${HTML_DIR} && wget -w 10 http://subtlepatterns.com/page/{1..35}/

process:
	make process_html
	make process_yaml
	make download_patterns

process_html:
	echo "Converting SubtlePatterns.com HTML into patterns + metedata"
	ls ${HTML_DIR}/index.html* | xargs ${BIN_DIR}/process_html > ${MIRROR_DIR}/subtlepatterns.yaml

process_yaml:
	echo "Converting SubtlePatterns metadata into JavaScript"
	${BIN_DIR}/process_yaml < ${MIRROR_DIR}/subtlepatterns.yaml > ${MIRROR_DIR}/subtlepatterns.js

download_patterns:
	echo "Downloading patterns"
	${BIN_DIR}/extract_patterns < ${MIRROR_DIR}/subtlepatterns.yaml | while read pattern; do \
		filename=`basename "$$pattern"`; \
		if [ ! -f "${PATTERNS_DIR}/$$filename" ]; \
		then \
			echo "Can't find pattern $$filename...downloading"; \
			wget -P "${PATTERNS_DIR}" $$pattern; \
		fi \
	done

static_files:
	echo "Building static assets"
	for file in "${JS_DIR}/jquery.min.js" \
				"${MIRROR_DIR}/subtlepatterns.js" \
				"${JS_DIR}/bookmarklet.js" \
				"${JS_DIR}/loader.js"; do \
			cat $$file; echo; \
	done | jsmin > ${ALLJS}
