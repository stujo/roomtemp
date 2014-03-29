# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  highColor = 'FFCCCC'
  midColor = 'EEDDEE'
  lowColor = 'DDEEFF'
  maxScore = 100

  pollInterval = 10000


  rainbow = new Rainbow()
  rainbow.setNumberRange(0, maxScore)
  rainbow.setSpectrum(lowColor, midColor, highColor);

  colorSpace = (score) ->
    '#' + rainbow.colourAt(score)

  $(".room_thumbnail").on( "init.roomtemp", ( event, newTemperature ) ->
    thumb = $(event.target)
    if newTemperature != null
      thumb.data('temperature',newTemperature)
    temperature = Math.abs(thumb.data('temperature'))
    output = colorSpace(temperature)
    thumb.css('background-color', output)
    thumb.find('.room_tagline').text(temperature)
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
      newTemp = data[thumb.data('room-id')]
      if newTemp and newTemp != thumb.data('temperature')
        thumb.data 'temperature', newTemp
        thumb.trigger 'init.roomtemp'
    )

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


