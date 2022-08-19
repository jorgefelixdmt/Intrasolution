<%@ Language=VBScript %>
<%response.Buffer=false%>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->

<%
 
' ******************************************************************************************************************************************************
' Nombre: script_Jira_incidencias_mes_anno_js
' Fecha Creación: 05/23/2020
' Autor: 
' Descripción: ASP que configura el gráfico incidentes pendientes por estado
' Usado por: Gráficos de Ventas.
' 
' ******************************************************************************************************************************************************
' RESUMEN DE CAMBIOS
' Fecha(aaaa-mm-dd)         Autor                      Comentarios      
' --------------------      ---------------------      -----------------------------------------------------------------------------------------------
'
' ******************************************************************************************************************************************************
' 
'

%>

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
    
	wSQL = "pr_pa_pendientes_estado " & wId_Usuario
	
    Set wRs = Server.CreateObject("ADODB.recordset")
    wRs.Open wSQL, oConn
	
	'** Crea los dataset como una cadena de valores separados con coma
	
	wProy = ""
	wSeries = ""

	Contador = 0
	
	For Each fld In wRs.Fields 
		If contador > 0 Then
			wProy = wProy & """" & fld.name & ""","
		End If
		contador = contador + 1
	Next
	
	If contador > 0 Then
		wProy = Left(wProy,len(wProy)-1)
	End If
	
	Contador = 0
	
	Do While Not wRs.Eof
		wData = ""
		contadorV = 0
	
		For Each fld In wRs.Fields 
			If contadorV > 0 Then
				wData = wData & fld.value & ","
			End If
			contadorV = contadorV + 1
		Next
		
		If contadorV > 0 Then
			wData = Left(wData,len(wData)-1)
		End If
		
		wSeries = wSeries & "{""name"" : """ & wRs("estado") & """," & NL
		wSeries = wSeries & """data"" : [" & wData & "]}," & NL
		
		contador = contador + 1
		wRs.MoveNext
	Loop
%>
var config_<%=wCodigo%> = {
 	chart: {
        type: 'column'
    },
    title: {
        text: 'Pases Pendientes por Proyecto',
		style: {
		  fontSize: '16px'
		}
    },
    xAxis: {
        categories: [<%=wProy%>],
        crosshair: true,
		labels: {
            style: {
                fontSize: '10px'
            }
        }
    },
    yAxis: {
        min: 0,
		allowDecimals: false,
        title: {
            text: 'Cantidad',
			style: {
			  fontSize: '12px'
			}
        }
    },
	legend: {
      enabled: true
    },
    tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span>',
        pointFormat: '</br><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>{point.y:.0f}</b></td>',
        footerFormat: '',
        shared: true,
        useHTML: true
    },
    plotOptions: {
        column: {
		    stacking: 'normal',
            pointPadding: 0.2,
            borderWidth: 0,
			colorByPoint: false,
			dataLabels: {
				formatter: function () {
					if (this.y != 0){
						var s = Highcharts.numberFormat(this.y,0)
						return s;
					}
				},
                enabled: false,
				style: {
				  fontSize: '10px',
				  fontWeight: 'Normal'
				}
            }
        }
    },
    series:[
			<%=wSeries%>
		]
	
};

<%    
	wRs.Close    
%>