# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	chart=$('#chart')
	if chart[0]
		console.dir(window.innerWidth)
		console.dir(chart[0])
		chart[0].width = window.innerWidth * 0.8

		
		$.get chart.data("url"), (data) ->
			counts = [0..23].map (i) -> data[i] || 0


			sum = counts.reduce (a, b) -> a + b
			percentages = counts.map (a) -> parseInt(a / sum * 10000) / 100
			max = Math.max.apply(this, percentages)


			source =
				labels: [0..23]
				datasets: [
					data: percentages
					fillColor: '#68d157'
					strokeColor: '#2b881c'
				]
			options =
				barStrokeWidth: 5
				scaleOverride: true
				scaleStartValue: 0
				scaleSteps: 10
				scaleLabel: "<%=parseInt(value)%>%"
				scaleStepWidth: max/10

			new Chart($('#chart')[0].getContext('2d')).Line(source, options)
