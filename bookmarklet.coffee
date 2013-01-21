#SITE_URL = "127.0.0.1:8000"
SITE_URL = "raw.github.com/bradjasper/subtle-patterns-bookmarklet/master"

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
                    description: entry.contentSnippet
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
        @setup_categories()
        @setup_events()
        @update()
        
    show: -> @el.show()
    hide: -> @el.hide()
    create: ->
        @el = $("<div>", id: "subtle_overlay")

        $("<div>", "class": "header").html("Subtle Patterns Bookmarklet").appendTo(@el)
        $("<select>", "class": "category").appendTo(@el)
        $("<a>", "href": "#", "class": "previous", "title": "You can also use your left and right arrow keys to switch patterns").html("←").appendTo(@el)
        $("<span>", "class": "index").appendTo(@el)
        $("<a>", "href": "#", "class": "next", "title": "You can also use your left and right arrow keys to switch patterns").html("→").appendTo(@el)
        $("<span>", "class": "title").appendTo(@el)

        $('<div class="bradjasper">by <a href="http://bradjasper.com">Brad Jasper</a></div>').appendTo(@el)
        @el.appendTo("body")

    current_pattern: -> @filtered_patterns()[@curr]
    update: =>
        pattern = @current_pattern()
        patterns = @filtered_patterns()
        $("body").css("background-image", "url('#{pattern.img}')")
        $("body").css("background-repeat", "repeat")
        @el.find(".index").html("#{@curr+1}/#{patterns.length}")
        @el.find(".title").html("<a target='_blank' href='#{pattern.link}' title='#{pattern.description}'>#{pattern.title}</a>")

    filtered_patterns: => (pattern for pattern in @patterns when @category == "all" or @category in pattern.categories)

    setup_categories: ->
        @categories = {}
        @category = "all"
        for pattern in @patterns
            for category in pattern.categories
                if category of @categories
                    @categories[category] += 1
                else
                    @categories[category] = 1

        sortable = ([key, val] for key, val of @categories)
        sortable.sort((b, a) -> a[1] - b[1])

        select = @el.find("select")
        select.append("<option value='all'>All (#{@patterns.length})</option>")
        for [category, count] in sortable
            select.append("<option value='#{category}'>#{category} (#{count})</option>")


    setup_events: ->
        $(document).keydown (e) =>
            switch e.keyCode
                when 37 then @previous()
                when 39 then @next()

        @el.find(".previous").click => @previous()
        @el.find(".next").click => @next()
        @el.find("select").change =>
            @category = @el.find("select").val()
            @curr = 0
            @update()

    next: ->
        if @curr < @filtered_patterns().length-1
            @curr += 1
            @update()

    previous: ->
        if @curr > 0
            @curr -= 1
            @update()
        else
            @curr = @filtered_patterns().length-1


# Kick everything off once jQuery is loaded
load_script "https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js", ->
    load_css "http://#{SITE_URL}/bookmarklet.css"
    load_subtle_patterns (patterns) ->
        new SubtlePatternsOverlay(patterns).setup()
