<%@ Language=VBScript %>
<%response.Buffer=false%>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" --> 
 
<% wCodigo = Request("Codigo") %>

<script type='text/javascript'>
	function toggle(){
		var chartDom = document.getElementById('canvas_<%=wCodigo%>');
		var chart = Highcharts.charts[Highcharts.attr(chartDom, 'data-highcharts-chart')]
		var opt = chart.series[0].options;
		opt.dataLabels.enabled = !opt.dataLabels.enabled;
		chart.series[0].update(opt);
	}
</script>
