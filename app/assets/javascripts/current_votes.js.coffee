# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  init_voting_buttons = (roomReport, newScore = null) ->
    if newScore != null
      roomReport.data('current-score', newScore)
    else
      newScore = roomReport.data('current-score')
    roomReport.find('button').each((i,j) ->
      btn = $(this)
      if newScore == null || newScore != btn.data('score')
        btn.removeClass('active')
      else
        btn.addClass('active')
      if window.RoomTemp?.colorSpace != null
        btn.css('background-color', window.RoomTemp.colorSpace(btn.data('score')))
    )

  $('.room_report').on('click','button', (event) ->
    event.preventDefault()
    roomReport = $(@).closest('.room_report')
    score = $(@).data('score')
    roomId = roomReport.data('room-id')
    if isFinite(score) && isFinite(roomId)
      $.get( "/rooms/#{roomId}/report/#{score}", ( data ) ->
        init_voting_buttons(roomReport,data?.score)
      )
  )
  init_voting_buttons($('.room_report'))
