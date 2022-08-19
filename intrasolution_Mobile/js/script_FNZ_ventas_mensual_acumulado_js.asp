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
		wEnero = "null"
		wFebrero = "null"
		wMarzo = "null"
		wAbril = "null"
		wMayo = "null"
		wJunio = "null"
		wJulio = "null"
		wAgosto = "null"
		wSeptiembre = "null"
		wOctubre = "null"
		wNoviembre = "null"
		wDiciembre = "null"
		
		If Not IsNull(wRs("Enero")) then 
			wEnero = cdbl(wRs("Enero")) 
			If Not IsNull(wRs("Febrero")) then 
				wFebrero = cdbl(wRs("Febrero")) + wEnero 
				If Not IsNull(wRs("Marzo")) then 
					wMarzo = cdbl(wRs("Marzo")) + wFebrero 
					If Not IsNull(wRs("Abril")) then 
						wAbril = cdbl(wRs("Abril")) + wMarzo 
						If Not IsNull(wRs("Mayo")) then 
							wMayo = cdbl(wRs("Mayo")) + wAbril 
							If Not IsNull(wRs("Junio")) then 
								wJunio = cdbl(wRs("Junio")) + wMayo 
								If Not IsNull(wRs("Julio")) then 
									wJulio = cdbl(wRs("Julio")) + wJunio 
									If Not IsNull(wRs("Agosto")) then 
										wAgosto = cdbl(wRs("Agosto")) + wJulio 
										If Not IsNull(wRs("Septiembre")) then 
											wSeptiembre = cdbl(wRs("Septiembre")) + wAgosto 
											If Not IsNull(wRs("Octubre")) then 
												wOctubre = cdbl(wRs("Octubre")) + wSeptiembre 
												If Not IsNull(wRs("Noviembre")) then 
													wNoviembre = cdbl(wRs("Noviembre")) + wOctubre 
													If Not IsNull(wRs("Diciembre")) then 
														wDiciembre = cdbl(wRs("Diciembre")) + wNoviembre 
													end if
												end if
											end if
										end if
									end if
								end if
							end if
						end if
					end if
				end if
			end if
		end if
	
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
        type: 'line'
    },
    title: {
        text: 'Ventas Anuales Acumuladas',
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
        line: {
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