delay = (ms, fn) -> setTimeout(fn, ms)
# Add pattern class names to selector
# This isn't part of the bookmarklet and is only used on
# the website to switch constrast between background and text
add_overlay_classes = (overlay) ->
    classes = ("spb-#{category}" for category in overlay.current_pattern().categories).join(" ")
    overlay.selector.get(0).className += " #{classes}"

# Remove pattern class names from selector
remove_overlay_classes = (overlay) ->
    classes = overlay.selector.attr("class") or ""
    overlay.selector.attr("class", classes.replace(/\s?spb-\w+/g, ""))

if window.SubtlePatternsBookmarklet
    overlay = new SubtlePatternsBookmarklet()
    overlay.setup
        patterns: SUBTLEPATTERNS
        parent: ".bookmarklet_container"
        klass: "homepage"
        default: "Old Mathematics"
        events:
            finished_setup: ->
                $(".bookmarklet_button a").click ->
                    alert("Drag this button to your bookmarks bar")
                    return false

                overlay.el.find(".close_bookmarklet").click ->
                    delay 500, -> overlay.show()

            revert_background: -> remove_overlay_classes(overlay)
            update_selector: ->
              remove_overlay_classes(overlay)
              add_overlay_classes(overlay)
