# Utility functions
delay = (ms, fn) -> setTimeout(fn, ms)
String::beginsWith = (str) -> if @match(new RegExp "^#{str}") then true else false
String::endsWith = (str) -> if @match(new RegExp "#{str}$") then true else false
load_script = (url, callback) ->
    """Load a script from a remote URL...with a callback when it's complete"""
    
    script = document.createElement("script")
    script.type = "text/javascript"

    if script.readyState
        script.onreadystatechange = ->
            if script.readyState == "loaded" or script.readyState == "complete"
                script.onreadystatechange = null
                callback()

    else
        script.onload = ->
            callback()

    script.src = url
    document.getElementsByTagName("head")[0].appendChild(script)

load_rss = (url, success) ->
    $.ajax
        url: document.location.protocol + '//ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=1000&callback=?&q=' + encodeURIComponent(url)
        dataType: 'json'
        success: (data) ->
            if data.responseStatus is 200
                success(data)
            else
                alert("There was an error loading the RSS feed #{url}")


show_patterns = (patterns) ->
    index = 0
    next = ->
        if index < patterns.length-1
            index += 1
            update()

    prev = ->
        if index > 0
            index -= 1
            update()
        else
            index = patterns.length-1

    update = ->
        pattern = patterns[index]
        $("body").css("background-image", "url('#{pattern.img}')")
        $("body").css("background-repeat", "repeat")

        $("#subtlepatterns_bookmarklet").html("SubtlePattern: <a target='_blank' href='#{pattern.link}'>#{pattern.title}</a>")

    setup = ->
        loading = $("<div>", id: "subtlepatterns_bookmarklet").html("Loading...")
        loading.css("z-index", "100")
        loading.css("background", "#fefefe")
        loading.css("position", "fixed")
        loading.css("padding", "10px")
        loading.css("bottom", "0px")
        loading.css("left", "0px")
        loading.appendTo("body")

        $(document).keydown (e) ->
            switch e.keyCode
                when 37 then prev()
                when 39 then next()


    setup()
    update()

main = ->
    subtle_feed = "http://feeds.feedburner.com/SubtlePatterns"
    load_rss subtle_feed, (data) ->
        patterns = []
        for entry in data.responseData.feed.entries
            img = $("<div>").html(entry.content).find("img[src$='.png']").attr("src")
            if img
                patterns.push
                    img: img
                    title: entry.title
                    link: entry.link
                    categories: entry.categories[1...]


        show_patterns(patterns)

# Kick everything off once jQuery is loaded
load_script "https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js", -> main()
