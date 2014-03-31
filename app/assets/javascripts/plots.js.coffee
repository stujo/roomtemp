$ ->
  plots = $('.roomtemp_plot')

  offset = new Date().getTimezoneOffset()  * 60000;

  colorSpace = window.RoomTemp?.colorSpace || (score)-> '#FFFFFF'

  mapScoreToLabel = (score) ->
    switch score
      when '0' then 'Frozen'
      when '33' then 'Cool'
      when '50' then 'Comfy'
      when '67' then 'Warm'
      when '100' then 'Hot'
      else score

  piesamize = (data) ->
    results = []
    for score, count of data
      results.push { label: mapScoreToLabel(score), data: count, color: colorSpace(score) },
    if results.length <= 0
      null
    else
      results

  flotsamize = (data) ->
    results = []
    for row in data
      rowdata = [Date.parse(row.date) - offset, row.score]
      results.push rowdata
      console.log row.date + " ->" + rowdata
    if results.length <= 0
      null
    else
      [results]

  initPieOptions = (options) ->
    options.series = {
      pie: {
        show: true
        radius: 1
        label: {
          show: true,
          radius: 2/3,
          formatter: (label, series) ->
            '<div style="font-size:8pt;text-align:center;padding:2px;color:white;">'+label+'</div>'
          background: {
            opacity: 0.5,
            color: '#000'
          }
          threshold: 0.2
        }
      }
    } unless options.series

    options.legend = {
        show: false
    } unless options.legend
    options

  initTimeOptions = (options) ->
    options.xaxis = {
      mode: "time"
      title: "Time"
      minTickSize: [5, "minute"]
      min: (new Date().getTime() - offset) - 3600000
      max: (new Date().getTime() - offset)
    } unless options.xaxis
    options.yaxis = {
      min: 0
      max: 100
    } unless options.yaxis
    options.series = {
      points: {
        radius: 3,
        show: true,
        fill: true,
        fillColor: "#058DC7"
      },
      color: "#058DC7"
    } unless options.series
    options

  plotData = (item) ->
    plotter = $(item)
    options = {}
    url = plotter.data('data-url')
    if url
      $.post url,
      (data) ->
        switch plotter.data('graph-format')
          when 'pie'
            options = initPieOptions(options)
            data = piesamize(data)
          else
            options = initTimeOptions(options)
            data = flotsamize(data)
        if data
          $.plot(item, data, options)
          plotter.show()
        callback =  plotter.data('plot-complete-callback')
        if callback
          callback(plotter,data,options)
        refreshIn = plotter.data('graph-refresh-in')
        if refreshIn >= 1000
          setTimeout( ->
            plotData(item)
          , refreshIn
          )

  if plots && plots.length > 0
    plots.each((idx,item) ->
      plotData(item)
    )



