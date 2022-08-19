<%@ Language=VBScript %>
<%response.Buffer=false%>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<%
    Server.ScriptTimeout = 360
  	Response.ContentType = "text/javascript"
	Response.AddHeader "Content-Type", "text/javascript;charset=UTF-8"
	Response.CodePage = 65001
	Response.CharSet = "UTF-8"
    
    wEmpresa = Request("Empresa")
	wId_Unidad = Request("Id_Unidad")
	wId_Usuario = Request("Id_Usuario")
    wAnno = Request("Anno")    
    wCodigo = Request("Codigo")

	if wAnno = "" then wAnno = 0
	
	'Obtiene datos de grafico
	wSQL = "pr_cv_caso_sospechoso_tendencia_bar "  &  wId_Unidad & "," & wAnno & ",1"
	

    Set wRs = Server.CreateObject("ADODB.recordset")
    wRs.Open wSQL, oConn
	
	
	wRecords = 1
	If wRs.EOF Then
		wRecords = 0
	End If

%>


var config_<%=wCodigo%> = {
    chart: {
        type: 'column',
		alignTicks: false
    },
    title: {
        text: 'Casos Sospechosos'
    },
    xAxis: {
        type           : 'datetime',
		tickInterval   : 24 * 3600 * 1000*30, //one day
		labels         : {
			rotation : 0
		},
		dateTimeLabelFormats: {
           day: '%d %b %Y'    //ex- 01 Jan 2016
        },
		labels: {
            rotation: 45
        }
    },
    yAxis: [
		{
			min: 0,
			allowDecimals: false,
			gridLineColor: 'transparent',
			title: {
				text: 'Cantidad',
				style: {
				  fontSize: '12px',
				  color: Highcharts.getOptions().colors[1]
				}
			},
			labels: {
				format: '{value}',
				style: {
					color: Highcharts.getOptions().colors[1]
				}
			}
		},
		{
			min: 0,
			max: 100,
			gridLineColor: 'transparent',
			title: {
				text: 'Porcentaje (%)',
				style: {
				  fontSize: '12px',
				  color: Highcharts.getOptions().colors[1]
				}
			},
			labels: {
				format: '{value}%',
				style: {
					color: Highcharts.getOptions().colors[1]
				}
			},
			opposite: true
		}
	],
    legend: {
        align: 'center',
        
        verticalAlign: 'bottom',
        
        backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
        borderColor: '#CCC',
        borderWidth: 1,
        shadow: false,
		enabled: false
    },
    tooltip: {
        crosshairs: true,
		shared: true,
		valueDecimals: 2
    },
    plotOptions: {
        column: {
            stacking: 'normal',
            dataLabels: {
                enabled: true,
                color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
				format: "{point.y:.0f}"
            }
        },
		line: {
            stacking: 'normal',
            dataLabels: {
                enabled: true,
                color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
				format: "{point.y:.0f}%"
            }
        }
    },
	exporting: {
		xls: {
			dateFormat: 'dd/mm/YYYY'
		}
	},
    series: [
		{
			name: 'Cantidad',
			type: 'column',
			data: [
			  <% If wRecords > 0 Then 
					wRs.MoveFirst 
				 End If
				 Do while Not wRs.EOF 
				  wDate = Split(wRs("fecha"),"/")
			  %>
				[Date.UTC(<%=wDate(2)%>,<%=(wDate(1) - 1)%>,<%=wDate(0)%>),<%=wRs("Cantidad")%>],
			  <%  wRs.MoveNext
				 Loop 
			  %>
			],
		},
		{
			name: 'Porcentaje',
			yAxis: 1,
			type: 'line',
			data: [
			  <% If wRecords > 0 Then 
					wRs.MoveFirst 
				 End If
				 Do while Not wRs.EOF 
				  wDate = Split(wRs("fecha"),"/")
				  wValor = cdbl(wRs("positivos"))*100/cdbl(wRs("Cantidad"))
			  %>
				[Date.UTC(<%=wDate(2)%>,<%=(wDate(1) - 1)%>,<%=wDate(0)%>),<%=wValor%>],
			  <%  wRs.MoveNext
				 Loop 
			  %>
			],
		}
	]
};

<% wRs.Close %>