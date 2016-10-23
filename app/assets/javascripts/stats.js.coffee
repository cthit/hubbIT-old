# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$chart = $('#chart')
	chart = $chart[0]

	if chart
		chart.width = window.innerWidth * 0.8


		$.get $chart.data("url"), (data) ->
			counts = [0..23].map (i) -> data[i] || 0


			sum = counts.reduce (a, b) -> a + b
			percentages = counts.map (a) -> parseInt(a / sum * 10000) / 100
			max = Math.max.apply(this, percentages)


			source =
				labels: [0..23]
				datasets: [
					data: percentages
					backgroundColor: '#68d157'
					borderColor: '#2b881c',
					borderWidth: 1
				]
			options =
				legend: false
				maintainAspectRatio: false
				scales:
					yAxes: [
						ticks:
							callback: (value) => (parseInt(value * 100) / 100) + "%"
					]

			new Chart $chart,
				type: 'line'
				data: source
				options: options
