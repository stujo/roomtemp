# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
(->
  highColor = 'FFCCCC'
  midColor = 'EEDDEE'
  lowColor = 'DDEEFF'
  maxScore = 100

  rainbow = new Rainbow()
  rainbow.setNumberRange(0, maxScore)
  rainbow.setSpectrum(lowColor, midColor, highColor);

  colorSpace = (score) ->
    '#' + rainbow.colourAt(score)

  #Export colorSpace service
  window.RoomTemp = window.RoomTemp || {}
  window.RoomTemp.colorSpace = colorSpace
)()

$ ->
  colorSpace = window.RoomTemp?.colorSpace || (score)-> '#FFFFFF'

  $(".room_thumbnail").on( "init.roomtemp", ( event, newTemperature ) ->
    thumb = $(event.target)
    if newTemperature != null
      thumb.data('temperature',newTemperature)
    temperature =  Math.abs(thumb.data('temperature'))
    votes = thumb.data('votes')
    if votes > 0
      output = colorSpace(temperature)
      thumb.css('background-color', output)
      thumb.find('.room_tagline').text(temperature.toFixed(0))
      thumb.parent().find('.room-current-temperature').first().text("#{temperature.toFixed(0)} Degrees")
      thumb.parent().find('.room-current-votes').first().text("#{votes} Current Voter#{if votes > 1 then 's' else ''}")
    else
      thumb.css('background-color', '#EEEEEE')
      thumb.find('.room_tagline').text('Empty')
      thumb.parent().find('.room-current-temperature').first().text("Room is Empty")
      thumb.parent().find('.room-current-votes').first().text("0 Voters")
  )

  homeRooms = $('#home-rooms')
  homeRooms.on('click','.room_thumbnail', (event) ->
    document.location.href = $(this).data('url') if $(this).data('url')
  )

  $('.room_thumbnail').trigger('init.roomtemp')

  updateTemperatures = (data) ->
    console.log data
    $('.room_thumbnail').each( (i,tn) ->
      thumb = $(tn)
      newTempStatus = data[thumb.data('room-id')]
      if newTempStatus
        thumb.data 'votes', newTempStatus[0]
        thumb.data 'temperature', newTempStatus[1]
        thumb.trigger 'init.roomtemp'
    )
  pollInterval = 10000

  pollForUpdates = () ->
    roomIds = []
    $(".room_thumbnail").each((i,j) ->
      roomIds.push $(j).data('room-id')
    )
    roomIds = roomIds.sort()
    if roomIds && roomIds.length > 0
      $.ajax {
        type: "POST"
        url: "/temperatures"
        data: {
          ids: roomIds
        }
        success: (data) ->
          updateTemperatures data
          setTimeout pollForUpdates, pollInterval
        dataType: 'json'
      }

  setTimeout pollForUpdates, pollInterval

  $('form.room-form-ajax-on-radio-change').on('click', 'input[type=radio]', (event)->
    form = $(event.target).closest("form")
    form.append('<input type="hidden" name="roomtemp_suppress_messages" value="1"/>')
    form.submit()
  )

  $('.roomtemp_plot.current_votes').data('plot-complete-callback', (item,data,options) ->
    unless data and data.length > 0
      item.parent().find('.room-current-vote-count').first().text("No Current Votes")
    else
      cvCount = 0
      $.each(data,(i,a)->
        cvCount+= a['data']
      )
      item.parent().find('.room-current-vote-count').first().text("#{cvCount} Current Vote#{if cvCount > 1 then 's' else ''}")
  )


  $('.roomtemp_plot.room_history').data('plot-complete-callback', (item,data,options) ->
    unless data and data.length > 0 and data[0].length >0
      item.parent().find('.room-total-vote-count').first().text("No Vote History")
    else
      cvCount = data[0].length
      item.parent().find('.room-total-vote-count').first().text("#{cvCount} Total Vote#{if cvCount > 1 then 's' else ''} in the last hour")
  )
