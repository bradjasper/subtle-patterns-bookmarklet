# SubtlePatternsBookmarklet
#
# SubtlePatterns is a great website where you can find backgrounds for your website.
# This bookmarklet allows you to preview the backgrounds from SubtlePatterns live on your site
#

##
## Bookmarklet Overlay
##
class SubtlePatternsOverlay
    """
    This is the overlay the user see's and uses to control patterns. This could use
    Knockout or Angular, but since it's a bookmarklet we'll keep it light and old-school with jQuery
    """

    constructor: (@patterns) ->
        @curr = 0

    setup: ->
        """
        Handle initial setup outside of constructor
        """
        @create()
        @setup_categories()
        @setup_events()
        @update()
        
    show: -> @el.show()
    hide: -> @el.hide()

    create: ->
        """
        Create the overlay for the first time
        """

        # Life is too short to generate HTML in Javascript
        @el = $("""
            <div id="subtle_overlay">
                <span class="title">
                    <a href="#" target="_blank" class="name"></a>
                    <a title="Download this pattern" href="#" target="_blank" class="download_pattern">(download)</a>
                </span>
                <div class="controls">
                    <a href="#" class="previous">&#x25C0;</a>
                    <span class="counter">
                        <span class="curr"></span>/<span class="total"></span>
                    </span>
                    <a href="#" class="next">&#x25B6;</a>
                </div>
                <select class="category">
                    <option value="all">All (#{@patterns.length})</option>
                </select>
                <div class="about">
                    <a href="http://subtlepatterns.com/?utm_source=SubtlePatternsBookmarklet&utm_medium=web&utm_campaign=SubtlePatternsBookmarklet" target="_blank">SubtlePatterns</a> bookmarklet by
                    <a href="http://bradjasper.com/?utm_source=SubtlePatternsBookmarklet&utm_medium=web&utm_campaign=SubtlePatternsBookmarklet" target="_blank">Brad Jasper</a>
                </div>
            </div>
        """)

        @el.hide().appendTo("body").slideDown()

    current_pattern: ->
        """
        Return the currently selected pattern
        """
        @category_patterns()[@curr]

    update: =>
        """
        Update the currently selected pattern. This is generally called on first
        initialization and any time a next() or previous() call is made.
        """
        pattern = @current_pattern()

        # TODO: This might be too brittle to work across lots of websites...
        $("body").css("background-image", "url('#{pattern.mirror_image}')")
        $("body").css("background-repeat", "repeat")

        @el.find(".curr").html("#{@curr+1}")
        @el.find(".total").html("#{@category_patterns().length}")

        pattern_link = "#{pattern.link}?utm_source=SubtlePatternsBookmarklet&utm_medium=web&utm_campaign=SubtlePatternsBookmarklet"

        @el.find(".title .name").attr("href", pattern_link).attr("title", pattern.description).html(pattern.title)
        @el.find(".title .download_pattern").attr("href", pattern.download)

    category_patterns: =>
        """
        Return all of the patterns for the active category
        """
        (pattern for pattern in @patterns when @category == "all" or @category in pattern.categories)

    setup_categories: ->
        """
        Build the category <select> box
        """

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
        for [category, count] in sortable
            select.append("<option value='#{category}'>#{category} (#{count})</option>")


    setup_events: ->
        """
        Setup event handlers for all different actions
        """

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
        if @curr < @category_patterns().length-1
            @curr += 1
        else # loop
            @curr = 0
        @update()

    previous: ->
        if @curr > 0
            @curr -= 1
        else # loop
            @curr = @category_patterns().length-1
        @update()

load_css = (url) ->
    "Load CSS from a remote URL"

    style = document.createElement("link")
    style.setAttribute("rel", "stylesheet")
    style.setAttribute("type", "text/css")
    style.setAttribute("href", url)

    document.getElementsByTagName("head")[0].appendChild(style)

if window.SUBTLEPATTERNS
    load_css "http://127.0.0.1:8000/bookmarklet.css?cb=#{Math.random()}"
    #load_css "http://bradjasper.com/subtle-patterns-bookmarklet/bookmarklet.css?cb=#{Math.random()}"
    overlay = new SubtlePatternsOverlay(SUBTLEPATTERNS)
    overlay.setup()
else
    alert("Something went wrong, I can't find the patterns")
