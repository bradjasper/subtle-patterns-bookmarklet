##
## ElementSelector
##
## A handy tool that lets you hover over DOM items and select them with your
## mouse. This is useful for us so we can allow users to switch the
## default selector from "body" to something else that might be more appropriate
##
class ElementSelector
    constructor: (@events={}) ->

    click: (e) =>
        @events.click(e) if @events.click

    over: (e) =>
        @target = e
        @events.over(e) if @events.over

    out: (e) =>
      @target = e
      @events.out(e) if @events.out

    keyup: (e) => @stop() if e.keyCode == 27  # escape key

    start: =>
        document.addEventListener("click", @click, true)
        document.addEventListener("keyup", @keyup, true)
        document.addEventListener("mouseout", @out, true)
        document.addEventListener("mouseover", @over, true)
        @events.start() if @events.start

    stop: =>
        document.removeEventListener("mouseover", @over, true)
        document.removeEventListener("mouseout", @out, true)
        document.removeEventListener("click", @click, true)
        document.removeEventListener("keyup", @keyup, true)

        # If there's an active target, call the mouseout callback before stopping
        @events.out(@target) if @target and @events.out

        @events.stop() if @events.stop
