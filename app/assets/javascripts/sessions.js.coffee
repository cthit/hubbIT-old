# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateTimestamps = () ->
    $("time.moment").each (index, tag) ->
        string = "(" + moment($(tag).attr('datetime')).fromNow(true) + ")"
        $(tag).text(string)

$ ->
    setInterval ->
        updateTimestamps()
    , 10000
