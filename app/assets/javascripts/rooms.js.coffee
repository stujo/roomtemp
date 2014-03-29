# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  highColor = 'FFCCCC'
  lowColor = 'CCCCFF'
  maxScore = 100

  splitColor = (hexcolor) ->
    num =  parseInt(hexcolor,16)
    {r: (num >> 16), g: (num >> 8 & 0x00FF), b: (num & 0x0000FF) }

  highRGB = splitColor(highColor)
  lowRGB = splitColor(lowColor)
  centRGB = {
    r: (highRGB.r - lowRGB.r)
    g: (highRGB.g - lowRGB.g)
    b: (highRGB.b - lowRGB.b)
  }

  format2Hex2 = (decimal) ->
    ("00" + decimal.toString(16)).substr(-2)

  colorSpace = (score) ->
    cent = Math.abs(score) / maxScore.toFixed(2)
    outputRGB = {
      r: Math.floor (centRGB.r * cent) + lowRGB.r
      g: Math.floor (centRGB.g * cent) + lowRGB.g
      b: Math.floor (centRGB.b * cent) + lowRGB.b
    }
    '#' +  format2Hex2(outputRGB.r) + format2Hex2(outputRGB.g) + format2Hex2(outputRGB.b);

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