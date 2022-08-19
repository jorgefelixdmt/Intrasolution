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
	w_tipo_evaluacion = Request("tipo_evaluacion")
	w_Cantidad = Request("cantidad")
	wUltAnno = Request("ultAnno")
	
	wIndicador = Request("indicador")
	wTipoGrafico = Request("tipografico")
	
	
	'Obtiene Nobre Autoridad para el Titulo de Grafico
	Set wRsSedeNombre = Server.CreateObject("ADODB.recordset")
	wSQL = " SELECT nombre"
	wSQL = wSQL + " FROM fb_uea_pe"
	wSQL = wSQL & " WHERE fb_uea_pe_id = " & wId_Unidad & " AND is_deleted = 0"
	wRsSedeNombre.Open wSQL, oConn
	
	If wId_Unidad = "0" then
	
		wSedeNombre = "Todas"
	else 
		wSedeNombre = wRsSedeNombre("nombre")
	
	End if
	
	
	if wIndicador = "" then wIndicador = 0
	if wAnno = "" then wAnno = 0
	if wCantidad = "" then wCantidad = 20
	
	If wAnno = "0" then
	
		wAnnoNombre = "Todas"
	else 
		wAnnoNombre = wAnno
	End if
	
	
	If wAnno = "0" then
	
		wAnnoNombreSubTitulo = "  "
	else 
		wAnnoNombreSubTitulo = "  - Periodo : " + wAnno
	End if
	
    wAnnosPrev = 1
	wPel = 1
    
	wSQL = "exec pr_graf_ind_indicador_matriz_v2 " & wId_Unidad & "," & wAnno & "," & wIndicador
	
    Set wRs = Server.CreateObject("ADODB.recordset")
    wRs.Open wSQL, oConn
	
	'** Crea los dataset como una cadena de valores separados con coma
	
	wSedeAct = ""
	wAnhoAct = ""
	wDataSetP = ""
	wDataSetNP = ""
	
	Contador = 0
	wPorcentajeAcumulado = 0
	
	wMesAct = 0
%>


var config_<%=wCodigo%> = {
 	chart: {
        type: 'column'
    },
    title: { 
        text: 'Sede : <%=wSedeNombre%> <%=wAnnoNombreSubTitulo%>'
    },
    xAxis: {
        categories: [
          ' <%=wAnnoNombre%> '+  ' Ene',
         '  <%=wAnnoNombre%> '+  ' Feb',
		 ' <%=wAnnoNombre%> '+ ' Mar',
         ' <%=wAnnoNombre%> '+ ' Abr',
        '  <%=wAnnoNombre%> '+ ' May',
         ' <%=wAnnoNombre%> '+ ' Jun',
        '  <%=wAnnoNombre%> '+ ' Jul',
         ' <%=wAnnoNombre%> '+ ' Ago',
        '  <%=wAnnoNombre%> '+ ' Sep',
        '  <%=wAnnoNombre%> '+ ' Oct',
        '  <%=wAnnoNombre%> '+ ' Nov',
        '  <%=wAnnoNombre%> '+ ' Dic'
        ],
        crosshair: true,
		labels: {
            style: {
                fontSize: '0.7em'
            }
        }
    },
    yAxis: {
        min: 0,
        title: {
            text: 'Cantidad'
        },
        stackLabels: {
            enabled: true,
            style: {
                fontWeight: 'bold',
                color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray',
				width: '200px'
            },
			formatter: function () {
				if (this.total != 0){
					var s = Highcharts.numberFormat(this.total,0)
					return s;
				}
			},
        }
    },
    tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>{point.y:.0f}</b></td></tr>',
        footerFormat: '</table>',
        useHTML: true
    },
    plotOptions: {
        column: {
			stacking: 'normal',
            pointPadding: 0.2,
            borderWidth: 0,
			dataLabels: {
				formatter: function () {
					if (this.y != 0){
						var s = Highcharts.numberFormat(this.y,0)
						return s;
					}
				},
                enabled: true,
				style: {
				  fontSize: '10px',
				  fontWeight: 'Normal'
				}
            }
        }
    },
    series: [
		<% Do While Not wRs.Eof %>
			{
				name: '<%=wRs("Anno_indicador")%>',
				data: [<%if isnull(wRs("Enero")) then%>0<%else%><%=wRs("Enero")%><%end if%>,
					   <%if isnull(wRs("Febrero")) then%>0<%else%><%=wRs("Febrero")%><%end if%>,
					   <%if isnull(wRs("Marzo")) then%>0<%else%><%=wRs("Marzo")%><%end if%>,
					   <%if isnull(wRs("Abril")) then%>0<%else%><%=wRs("Abril")%><%end if%>,
					   <%if isnull(wRs("Mayo")) then%>0<%else%><%=wRs("Mayo")%><%end if%>,
					   <%if isnull(wRs("Junio")) then%>0<%else%><%=wRs("Junio")%><%end if%>,
					   <%if isnull(wRs("Julio")) then%>0<%else%><%=wRs("Julio")%><%end if%>,
					   <%if isnull(wRs("Agosto")) then%>0<%else%><%=wRs("Agosto")%><%end if%>,
					   <%if isnull(wRs("Setiembre")) then%>0<%else%><%=wRs("Setiembre")%><%end if%>,
					   <%if isnull(wRs("Octubre")) then%>0<%else%><%=wRs("Octubre")%><%end if%>,
					   <%if isnull(wRs("Noviembre")) then%>0<%else%><%=wRs("Noviembre")%><%end if%>,
					   <%if isnull(wRs("Diciembre")) then%>0<%else%><%=wRs("Diciembre")%><%end if%>]

			},
		<%
		    wRs.MoveNext
	       Loop
		%>
	]
};

<%    
	wRs.Close    
%>