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
      results.push [Date.parse(row.date) - offset, row.score]
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
      minTickSize: [1, "hour"]
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

  if plots && plots.length > 0
    plots.each((idx,item) ->
      plotter = $(item)
      url = plotter.data('data-url')

      options = {}

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
    )



