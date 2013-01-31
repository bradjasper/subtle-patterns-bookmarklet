load_css = (url) ->
    "Load CSS from a remote URL"

    style = document.createElement("link")
    style.setAttribute("rel", "stylesheet")
    style.setAttribute("type", "text/css")
    style.setAttribute("href", url)

    document.getElementsByTagName("head")[0].appendChild(style)

# Kick everything off
if window.SUBTLEPATTERNS
    #load_css "http://bradjasper.com/subtle-patterns-bookmarklet/bookmarklet.css?cb=#{Math.random()}"
    load_css "http://127.0.0.1:8000/static/css/bookmarklet.css?cb=#{Math.random()}"
    overlay = new SubtlePatternsBookmarklet(SUBTLEPATTERNS)
    overlay.setup()
else
    alert("Something went wrong, I can't find the patterns")
