###
This script is the master controller, it kicks everything off
###

# Load CSS from a remote URL
load_css = (url) ->
    style = document.createElement("link")
    style.setAttribute("rel", "stylesheet")
    style.setAttribute("type", "text/css")
    style.setAttribute("href", url)
    document.getElementsByTagName("head")[0].appendChild(style)

load_css "http://bradjasper.com/subtle-patterns-bookmarklet/static/css/all.css?cb=#{Math.random()}"
#load_css "http://127.0.0.1:8000/subtle-patterns-bookmarklet/static/css/all.css?cb=#{Math.random()}"
overlay = new SubtlePatternsBookmarklet()
overlay.setup(patterns: SUBTLEPATTERNS)
