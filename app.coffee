delay = (ms, fn) -> setTimeout(fn, ms)

if window.SUBTLEPATTERNS
    overlay = new SubtlePatternsBookmarklet(SUBTLEPATTERNS)
    overlay.setup
        container: ".bookmarklet_container"
        klass: "homepage"
        default: "Old Mathematics"

    $(".bookmarklet_button a").click ->
        alert("Drag this button to your bookmarks bar")
        return false
