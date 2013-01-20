SITE_URL = "127.0.0.1:8000"

# Utility functions
delay = (ms, fn) -> setTimeout(fn, ms)

# Dangerous to modify prototype, but it's just crazy these aren't standard
String::beginsWith = (str) -> if @match(new RegExp "^#{str}") then true else false
String::endsWith = (str) -> if @match(new RegExp "#{str}$") then true else false

load_script = (url, callback) ->
    """
    Load a script from a remote URL...with a callback when it's complete
    """
    script = document.createElement("script")
    script.type = "text/javascript"

    if script.readyState
        script.onreadystatechange = ->
            if script.readyState == "loaded" or script.readyState == "complete"
                script.onreadystatechange = null
                callback()

    else
        script.onload = -> callback()

    script.src = url
    document.getElementsByTagName("head")[0].appendChild(script)

load_css = (url) ->
    "Load CSS from a remote URL"

    style = document.createElement("link")
    style.setAttribute("rel", "stylesheet")
    style.setAttribute("type", "text/css")
    style.setAttribute("href", url)

    document.getElementsByTagName("head")[0].appendChild(style)

load_rss = (url, success) ->
    """
    Leverage Google's AJAX API to turn an RSS feed into JSON
    """
    $.ajax
        url: document.location.protocol + '//ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=1000&callback=?&q=' + encodeURIComponent(url)
        dataType: 'json'
        success: (data) ->
            if data.responseStatus is 200
                success(data)
            else
                alert("There was an error loading the RSS feed #{url}")

load_subtle_patterns = (success) ->
    """
    Load patterns from SubtlePatterns via RSS
    """
    load_rss "http://feeds.feedburner.com/SubtlePatterns", (data) ->
        patterns = []
        for entry in data.responseData.feed.entries
            img = $("<div>").html(entry.content).find("img[src$='.png']").attr("src")
            if img
                patterns.push
                    img: img
                    title: entry.title
                    link: entry.link
                    categories: entry.categories[1...]

        success(patterns)

class SubtlePatternsOverlay
    """
    This is the overlay the user see's and uses to control patterns

    This could use Knockout or Backbone, but since it's a bookmarklet we'll keep it light
    """

    constructor: (@patterns) ->
        @curr = 0

    setup: ->
        @create()
        @setup_events()
        @update()
        
    show: -> @el.show()
    hide: -> @el.hide()
    create: ->
        @el = $("<div>", id: "subtle_overlay")
        $("<a>", "href": "#", "class": "previous").html("←").appendTo(@el).click => @previous()
        $("<span>", "class": "index").appendTo(@el)
        $("<a>", "href": "#", "class": "next").html("→").appendTo(@el).click => @next()
        $("<span>", "class": "title").appendTo(@el)
        @el.appendTo("body")

    setup_events: ->
        $(document).keydown (e) =>
            switch e.keyCode
                when 37 then @previous()
                when 39 then @next()

    next: ->
        if @curr < @patterns.length-1
            @curr += 1
            @update()

    previous: ->
        if @curr > 0
            @curr -= 1
            @update()
        else
            @curr = @patterns.length-1

    current_pattern: -> @patterns[@curr]
    update: ->
        pattern = @current_pattern()
        $("body").css("background-image", "url('#{pattern.img}')")
        $("body").css("background-repeat", "repeat")
        @el.find(".index").html("#{@curr+1}/#{@patterns.length}")
        @el.find(".title").html("<a target='_blank' href='#{pattern.link}'>#{pattern.title}</a>")

# Kick everything off once jQuery is loaded
load_script "https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js", ->
    load_css "http://#{SITE_URL}/bookmarklet.css"
    load_subtle_patterns (patterns) ->
        new SubtlePatternsOverlay(patterns).setup()
