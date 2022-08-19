<%@ Language=VBScript %>
<%response.Buffer=false%>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->

<%
 
' ******************************************************************************************************************************************************
' Nombre: script_Jira_incidencias_mes_anno_js
' Fecha Creación: 05/23/2020
' Autor: 
' Descripción: ASP que configura el gráfico ventas mensual
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
    
	wSQL = "pr_fz_ventas_mensual " & wAnno
	
    Set wRs = Server.CreateObject("ADODB.recordset")
    wRs.Open wSQL, oConn
	
	'** Crea los dataset como una cadena de valores separados con coma
	
	wAnno = ""
	wSeries = ""

	
	Contador = 0
	
	Do While Not wRs.Eof
		If IsNull(wRs("Enero")) then wEnero = 0 else wEnero = wRs("Enero") end if
		If IsNull(wRs("Febrero")) then wFebrero = 0 else wFebrero = wRs("Febrero") end if
		If IsNull(wRs("Marzo")) then wMarzo = 0 else wMarzo = wRs("Marzo") end if
		If IsNull(wRs("Abril")) then wAbril = 0 else wAbril = wRs("Abril") end if
		If IsNull(wRs("Mayo")) then wMayo = 0 else wMayo = wRs("Mayo") end if
		If IsNull(wRs("Junio")) then wJunio = 0 else wJunio = wRs("Junio") end if
		If IsNull(wRs("Julio")) then wJulio = 0 else wJulio = wRs("Julio") end if
		If IsNull(wRs("Agosto")) then wAgosto = 0 else wAgosto = wRs("Agosto") end if
		If IsNull(wRs("Septiembre")) then wSeptiembre = 0 else wSeptiembre = wRs("Septiembre") end if
		If IsNull(wRs("Octubre")) then wOctubre = 0 else wOctubre = wRs("Octubre") end if
		If IsNull(wRs("Noviembre")) then wNoviembre = 0 else wNoviembre = wRs("Noviembre") end if
		If IsNull(wRs("Diciembre")) then wDiciembre = 0 else wDiciembre = wRs("Diciembre") end if
	
		wSeries =wSeries & "{"
		wSeries =wSeries & "name: '" & wRs("Anno") & "',"
		wSeries = wSeries & "data: [" & wEnero & "," & wFebrero & "," & wMarzo & "," & wAbril & "," & wMayo & "," & wJunio & "," & wJulio & "," & wAgosto & "," & wSeptiembre & "," & wOctubre & "," & wNoviembre & "," & wDiciembre & "]"
		wSeries = wSeries & "},"
		Contador = Contador + 1
		wRs.MoveNext
	Loop
%>
var config_<%=wCodigo%> = {
 	chart: {
        type: 'column'
    },
    title: {
        text: 'Ventas Anuales',
		style: {
		  fontSize: '16px'
		}
    },
	subtitle: {
		text: '(monto en miles de US$)',
		style: {
		  fontSize: '11px'
		}
	},
    xAxis: {
        categories: ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
        crosshair: true,
		labels: {
            style: {
                fontSize: '10px'
            }
        }
    },
    yAxis: {
        min: 0,
        title: {
            text: 'Ventas',
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
            '<td style="padding:0"><b>{point.y:.2f}</b></td>',
        footerFormat: '',
        shared: true,
        useHTML: true
    },
    plotOptions: {
        column: {
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