###
Subtle Patterns Bookmarklet

This is the main bookmarklet overlay the user sees and controls.
###

class SubtlePatternsBookmarklet

    setup: (kwargs={}) ->
        ###
        Handle initial setup outside of constructor
        ###
        @patterns = kwargs.patterns or []
        @parent = kwargs.parent or "body"
        @selector = $(kwargs.selector or "body")
        @events = kwargs.events or {}
        @original_background = @selector.css("background-image")
        @curr = kwargs.curr or 0
        @klass = kwargs.klass or ""

        @create()
        @setup_categories()
        @setup_events()

        # Setup default pattern (mostly useful as a preview on the website)
        if kwargs.default
            for pattern, i in @patterns
                @curr = i if pattern.title == kwargs.default

        @update()

        if @events.finished_setup
          @events.finished_setup()
        
    show: -> @el.slideDown()
    hide: -> @el.slideUp()

    create: ->
        ###
        Create the bookmarklet for the first time
        ###

        # Grab HTML from other file
        @el = $(template_bookmarklet).addClass(@klass)
        @el.hide().appendTo(@parent)
        @show()

        $(template_body).appendTo("body")


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
        @events.before_update() if @events.before_update

        pattern = @current_pattern()

        @selector.css("background-image", "url('#{pattern.mirror_image}')")
        @selector.css("background-repeat", "repeat")
        @selector.css("background-size", "auto")

        @el.find(".curr").html("#{@curr+1}")
        @el.find(".total").html("#{@category_patterns().length}")

        pattern_link = "#{pattern.link}?utm_source=SubtlePatternsBookmarklet&utm_medium=web&utm_campaign=SubtlePatternsBookmarklet"

        categories = pattern.categories.join('/')
        description = "#{pattern.description} (#{pattern.image_dimensions} - #{pattern.image_size} - #{categories})"
        @el.find(".title .name").attr("href", pattern_link).attr("title", description).html(pattern.title)

        @events.after_update() if @events.after_update

    preload: (index) ->
        image = @category_patterns()[index].mirror_image
        @el.find("img.preload").attr("src", image)

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
        select.append("<option value='all'>All (#{@patterns.length})</option>")
        for [category, count] in sortable
            select.append("<option value='#{category}'>#{category} (#{count})</option>")


    random: =>
        ###
        Pick random background from category
        ###
        @curr = Math.floor(Math.random()*@category_patterns().length)
        @update()

    toggle: =>
        ###
        Toggle the current background on/off
        ###
        if $(@selector).css("background-image") == @original_background
            @update()
        else
            @revert_background()


    toggle_keyboard_shortcuts_dialog: =>
        $("#spb_keyboard_shortcuts").fadeToggle()

    show_keyboard_shortcuts_dialog: =>
        $("#spb_keyboard_shortcuts").fadeIn()

    hide_keyboard_shortcuts_dialog: =>
        $("#spb_keyboard_shortcuts").fadeOut()

    close_settings_menu: =>
        @el.find(".menu .submenu").fadeOut()

    setup_events: ->
        ###
        Setup event handlers for all different actions
        ###

        $(document).keydown (e) =>

            if e.keyCode == 191 and e.shiftKey
                @toggle_keyboard_shortcuts_dialog()
                return

            if e.altKey or e.ctrlKey or e.shiftKey
                return

            switch e.keyCode
                when 27 then @hide_keyboard_shortcuts_dialog() # escape key
                when 37 then @previous() # left arrow key
                when 39 then @next()     # right arrow key
                when 82 then @random()   # "r" key
                when 83 then @start_element_selector()   # "s" key
                when 84 then @toggle()   # "t" key

        @el.find(".menu .menu_icon").click (e) =>
            e.stopPropagation()
            @el.find(".menu .submenu").fadeToggle()

        $("html").click (e) =>
            @close_settings_menu()
            @hide_keyboard_shortcuts_dialog()

        @el.find(".show_keyboard_shortcuts").click (e) =>
            @show_keyboard_shortcuts_dialog()
            @close_settings_menu()
            e.stopPropagation()

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
            
        @el.find(".close_bookmarklet").click (e) =>
            @revert_background()
            @hide()
            delay 500,
                @el.remove()
                $(document).unbind("keydown")

        @el.find(".change_selector").click (e) =>
            e.preventDefault()
            @start_element_selector()


    start_element_selector: ->

        # element selector is already running
        return if @element_selector

        @element_selector = new ElementSelector
            over: (e) =>
                target = $(e.target)

                offset = target.offset()

                $("#spb_element_selector").show().css
                  top: offset.top
                  left: offset.left
                  width: target.outerWidth() - 6
                  height: target.outerHeight() - 6

            out: (e) =>
                target = $(e.target)
                $("#spb_element_selector").hide()

            click: (e) =>
                @element_selector.out(e)
                @element_selector.stop()

                # Only update the selector if they didn't click the cancel change selector link
                if e.target != @el.find(".cancel_change_selector").get(0)
                    @update_selector($(e.target))

            start: =>
              $("#spb_element_selector").show()
              @el.find(".menu").fadeOut =>
                  @el.find(".cancel_change_selector").fadeIn()

            stop: =>
              $("#spb_element_selector").hide()
              @el.find(".cancel_change_selector").fadeOut =>
                  @el.find(".menu").fadeIn()
              @element_selector = null

        @element_selector.start()


    revert_background: =>
            @selector.css("background-image", @original_background)
            @events.revert_background() if @events.revert_background

    update_selector: (selector) =>
            @revert_background()

            @selector = selector
            @original_background = @selector.css("background-image")

            @events.update_selector() if @events.update_selector

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

window.SubtlePatternsBookmarklet = SubtlePatternsBookmarklet
