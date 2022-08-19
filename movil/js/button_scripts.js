<%@ Language=VBScript %>
<%response.Buffer=false%>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<%
    'Selecciona los Portlets del Home
    strSQL = "pr_HOME_RecuperaPortles '" & wId_Home & "'" 
    Set oRsPortlet = Server.CreateObject("ADODB.Recordset")
    oRsPortlet.Open strSQL, oConn

%>


<%  Do While Not wRs.Eof %>
		// the button action
		$('#button_<%=oRsPortlet("codigo")%>').click(function () {
			var chartDom = document.getElementById('canvas_<%=oRsPortlet("codigo")%>');
			var chart = Highcharts.charts[Highcharts.attr(chartDom, 'data-highcharts-chart')]
			var opt = chart.series[0].options;
			opt.dataLabels.enabled = !opt.dataLabels.enabled;
			chart.series[0].update(opt);
		});
<%  	wRs.MoveNext
    Loop %>

