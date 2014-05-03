# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$.get '/stats/hours.json', (data) ->
		counts = []
		for i in [0..23]
			counts.push data[i] || 0
		max = Math.max.apply(null, counts)
		max = 5 if max < 5
		source =
			labels: [0..23]
			datasets: [data: counts, fillColor: '#68d157', strokeColor: '#2b881c']
		new Chart($('#chart')[0].getContext('2d')).Line(source, {barStrokeWidth: 5, scaleOverride: true, scaleStartValue: 0, scaleSteps: max, scaleStepWidth: 1})
