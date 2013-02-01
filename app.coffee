delay = (ms, fn) -> setTimeout(fn, ms)

if window.SUBTLEPATTERNS
    overlay = new SubtlePatternsBookmarklet(SUBTLEPATTERNS)
    overlay.setup
        container: ".bookmarklet_container"
        klass: "homepage"
        default: "Old Mathematics"
        callback: ->
          $(".bookmarklet_button a").click ->
            alert("Drag this button to your bookmarks bar")
            return false

          $("#subtlepatterns_bookmarklet").on "update", ->
            $("body").attr("class", ("spb-#{category}" for category in overlay.current_pattern().categories).join(" "))
