App.db_rooms ||= {}

subscriptions = {}

window.subscribe_data_point = (consumers, chart_vars, domElementId) ->
  # App.cable.subscriptions.remove(App.db_rooms[[consumers, interval_id]]) if App.db_rooms[[consumers, interval_id]]
    # unless App.db_rooms[[consumers, interval_id, domElementId]]
    App.livecharts ||= []
    App.timer ||= setInterval (() ->
#      console.log "interval1", App.livecharts
      toremove = []
      for k,v of App.livecharts
#        console.log "interval: ", k,v
        chart = v['chart']
#        console.log "The chart is ", chart
        elem = document.getElementById(k)
        if elem == null || !chart
          toremove.push k
        else
#          console.log "The options are ", chart.options
          now = (new Date()).getTime()
          chart.options.scales.xAxes[0].ticks.max = now + v.duration / 5.0
          chart.options.scales.xAxes[0].ticks.min = now - v.duration
          chart.update()
#          ;
#         console.log chart, dom
      for k of toremove
        delete App.livecharts[k]
    ), 10000

    # console.log("Test", subscriptions, domElementId )
    if subscriptions[domElementId]?
      App.cable.subscriptions.remove(subscriptions[domElementId])

    subscriptions[domElementId] = App.cable.subscriptions.create({ channel: "DataPointChannel", consumers: consumers, interval_id: chart_vars['interval_id'] }, received: (data) ->
      # console.log "Just received datapoint", data
      chart = App.livecharts[domElementId].chart if App.livecharts[domElementId]
#      chart = Chart.helpers.where(Chart.instances, (instance) ->
#        instance.canvas.id == domElementId)[0]
      if !chart
#        console.log "The subsciption is ", this
        this.unsubscribe()
        return
      dataset = chart.data.datasets.find((d) -> d.label == data['consumer']['name'])
      last_time = dataset.data.slice(-1)[0].x
      new_time = new Date(data['timestamp'])
      if new_time > last_time
        dataset.data.push({x: new_time, y: data['consumption']})
#        dataset.data.shift()
#        chart.update()
#        console.log "New data is", dataset.data
        datasets_without_aggregate = chart.data.datasets.filter((d) -> d.label != 'aggregate')
#        console.log "datasets_without_aggregate= ", datasets_without_aggregate
        count_elems = datasets_without_aggregate.reduce( ((a, b) -> a + b.data.some( (d) -> d.x.getTime() == new_time.getTime() && d.y != null )) , 0)

        if count_elems == datasets_without_aggregate.length
          aggr_dataset = chart.data.datasets.find((d) -> d.label == 'aggregate')
          if aggr_dataset
            aggr_last_time = aggr_dataset.data.slice(-1)[0].x
            if new_time > last_time
              sum_elems = datasets_without_aggregate.reduce( ((a, b) -> a + b.data.find( (d) -> d.x.getTime() == new_time.getTime()).y) , 0)
              aggr_dataset.data.push({x: new_time, y: sum_elems})
#             aggr_dataset.data.shift()

        chart.update()
      # console.log "We just received data:", data, "The chart is #{chart.canvas.id}", chart.data

    )


#    console.log "connected to channel"



