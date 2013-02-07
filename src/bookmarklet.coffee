###
Subtle Patterns Bookmarklet

This is the main bookmarklet overlay the user sees and controls.
###

class SubtlePatternsBookmarklet

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
                        <a href="javascript:void(0)" class="previous"><img src="http://bradjasper.com/subtle-patterns-bookmarklet/static/img/left_arrow.png" /></a>
                        <span class="counter">
                            <span class="curr"></span>/<span class="total"></span>
                        </span>
                        <a href="javascript:void(0)" class="next"><img src="http://bradjasper.com/subtle-patterns-bookmarklet/static/img/right_arrow.png" /></a>
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
                <img class="preload" style="display: none;" />
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
        Update the UI to reflect a change in behavior. This is generally called on first
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

    preload: (index) ->
        image = @category_patterns()[index].mirror_image
        console.log image
        @el.find("img.preload").attr("src", image)
        console.log @el.find("img.preload").attr("src")
        # do it

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

        # Sort categories by most patterns
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
                when 37 then @previous() # left arrow key
                when 39 then @next()     # right arrow key

        @el.find(".previous").click (e) =>
            e.preventDefault()
            @previous()

        @el.find(".next").click (e) =>
            e.preventDefault()
            @next()

        @el.find("select").change =>
            @category = @el.find("select").val()
            @curr = 0
            @update()

    next_index: ->
        if @curr < @category_patterns().length-1
            return @curr + 1
        return 0 # loop

    previous_index: ->
        if @curr > 0
            return @curr - 1
        return @category_patterns().length-1 # loop

    next: ->
        ###
        Switch to the next pattern
        ###
        @curr = @next_index()
        @update()
        @preload(@next_index())

    previous: ->
        ###
        Switch to the previous pattern
        ###
        @curr = @previous_index()
        @update()
        @preload(@previous_index())

# Export the bookmarklet so we can use it from other Coffeescript modules
# Know a better way to do this when combining multiple files? Email me! bjasper@gmail.com
window.SubtlePatternsBookmarklet = SubtlePatternsBookmarklet
