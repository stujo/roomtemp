# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#home-rooms').on('click','.room_thumbnail', (event) ->
    document.location.href = $(this).data('url') if $(this).data('url')
  )