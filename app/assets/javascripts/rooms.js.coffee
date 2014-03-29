# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  highColor = 'FFCCCC'
  midColor = 'EEDDEE'
  lowColor = 'DDEEFF'
  maxScore = 100


  rainbow = new Rainbow()
  rainbow.setNumberRange(0, maxScore)
  rainbow.setSpectrum(lowColor, midColor, highColor);


  colorSpace = (score) ->
    '#' + rainbow.colourAt(score)

  init_thumbnail_display = (thumbnail, newTemperature) ->
    thumb = $(thumbnail)
    if newTemperature != null
      thumb.data('temperature',newTemperature)
    temperature = Math.abs(thumb.data('temperature'))
    output = colorSpace(temperature)
    thumb.css('background-color', output)
    thumb.find('.room_tagline').text(temperature)


  homeRooms = $('#home-rooms')
  homeRooms.on('click','.room_thumbnail', (event) ->
    document.location.href = $(this).data('url') if $(this).data('url')
  )
  $('.room_thumbnail').each((i,j) ->
    init_thumbnail_display j
  )