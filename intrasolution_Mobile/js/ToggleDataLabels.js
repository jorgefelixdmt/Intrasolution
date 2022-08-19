
	function toggle(canvasid){
		var chartDom = document.getElementById(canvasid);
		var chart = Highcharts.charts[Highcharts.attr(chartDom, 'data-highcharts-chart')]
		var opt = chart.series[0].options;
		opt.dataLabels.enabled = !opt.dataLabels.enabled;
		chart.series[0].update(opt);
	}
