class SubtlePatternsBookmarklet
    ###
    This is the bookmarklet the user see's and uses to control patterns. This could use
    Knockout or Angular, but since it's a bookmarklet we'll keep it light with jQuery
    ###

    constructor: (@patterns) ->
        @curr = 0

    setup: (kwargs={}) ->
        ###
        Handle initial setup outside of constructor
        ###
        @container = kwargs.container or "body"
        @klass = kwargs.klass or ""
        @create()
        @setup_categories()
        @setup_events()

        # Setup default pattern
        if kwargs.default
            for pattern, i in @patterns
                @curr = i if pattern.title == kwargs.default

        @update()

        if kwargs.callback
          kwargs.callback()
        
    show: -> @el.show()
    hide: -> @el.hide()

    create: ->
        ###
        Create the bookmarklet for the first time
        ###

        # Life is too short to generate HTML in Javascript
        @el = $("""
            <div id="subtlepatterns_bookmarklet" class="#{@klass}">
                <div class="wrapper">
                    <span class="title">
                        <a href="#" target="_blank" class="name"></a>
                    </span>
                    <div class="controls">
                        <a href="#" class="previous"><img src="http://bradjasper.com/subtle-patterns-bookmarklet/static/img/left_arrow.png" /></a>
                        <span class="counter">
                            <span class="curr"></span>/<span class="total"></span>
                        </span>
                        <a href="#" class="next"><img src="http://bradjasper.com/subtle-patterns-bookmarklet/static/img/right_arrow.png" /></a>
                        <br /><a href="#" class="random">random</a>
                    </div>
                    <div class="categories">
                        <select class="category">
                            <option value="all">All (#{@patterns.length})</option>
                        </select>
                    </div>
                    <div class="about">
                        <a href="http://subtlepatterns.com/?utm_source=SubtlePatternsBookmarklet&utm_medium=web&utm_campaign=SubtlePatternsBookmarklet" target="_blank">SubtlePatterns</a> bookmarklet by
                        <a href="http://bradjasper.com/?utm_source=SubtlePatternsBookmarklet&utm_medium=web&utm_campaign=SubtlePatternsBookmarklet" target="_blank">Brad Jasper</a>
                    </div>
                </div>
            </div>
        """)

        @el.hide().appendTo(@container).slideDown()

    current_pattern: ->
        ###
        Return the currently selected pattern
        ###
        @category_patterns()[@curr]

    update: =>
        ###
        Update the currently selected pattern. This is generally called on first
        initialization and any time a next() or previous() call is made.
        ###
        pattern = @current_pattern()

        # TODO: This might be too brittle to work across lots of websites...
        $("body").css("background-image", "url('#{pattern.mirror_image}')")
        $("body").css("background-repeat", "repeat")

        @el.find(".curr").html("#{@curr+1}")
        @el.find(".total").html("#{@category_patterns().length}")

        pattern_link = "#{pattern.link}?utm_source=SubtlePatternsBookmarklet&utm_medium=web&utm_campaign=SubtlePatternsBookmarklet"

        description = "#{pattern.description} (#{pattern.categories.join('/')})"
        @el.find(".title .name").attr("href", pattern_link).attr("title", description).html(pattern.title)

        @el.trigger("update")

    category_patterns: =>
        ###
        Return all of the patterns for the active category
        ###
        (pattern for pattern in @patterns when @category == "all" or @category in pattern.categories)

    setup_categories: ->
        ###
        Build the category <select> box
        ###

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
        ###
        Setup event handlers for all different actions
        ###

        $(document).keydown (e) =>
            switch e.keyCode
                when 37 then @previous()
                when 39 then @next()

        @el.find(".previous").click (e) =>
            e.preventDefault()
            @previous()
        @el.find(".next").click (e) =>
            e.preventDefault()
            @next()
        @el.find(".random").click (e) =>
            e.preventDefault()
            @random()
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

    random: ->
        @curr = Math.floor(Math.random() * @category_patterns().length)
        @update()

window.SubtlePatternsBookmarklet = SubtlePatternsBookmarklet
