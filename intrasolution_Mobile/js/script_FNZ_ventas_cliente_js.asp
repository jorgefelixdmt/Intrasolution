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

	
	'**if w_tipo_incidente = "" then w_tipo_incidente = 0
	'**if wAnno = "" then wAnno = 0
	'**if wCantidad = "" then wCantidad = 20
	
    
	wSQL = "pr_fnz_ventas_cliente "  & wAnno
	
	' pr_tipo_incidente_mensual

    Set wRs = Server.CreateObject("ADODB.recordset")
    wRs.Open wSQL, oConn
	
	'** Crea los dataset como una cadena de valores separados con coma
	
	wDataSetCantidad = ""
	wPorcentajeAcumulado = 0  
	
	Dim colors
	colors = Array("lightblue", "#f4a460", "lightgreen", "#FA8072", "#9acd32", "purple", "yellow")
	Contador = 0
	numreg = wRs.RecordCount
	wConfig = "[]"

	if not(wRs.EOF)  then

		'** Crea la serie
		NL = chr(13) & chr(10)

		wConfig = "["
		Do While Not wRs.EOF

			wConfig = wConfig & "[" & NL
			wConfig = wConfig & "'" & wRs.Fields("cliente").value &"',"& NL 
			wConfig = wConfig & wRs.Fields("cantidad").value & NL 
			wConfig = wConfig & "]," & NL

			wRs.MoveNext
		Loop
		wConfig = Left(wConfig,len(wConfig)-3)
		wConfig = wConfig & "]" & NL

	end if
%>

var config_<%=wCodigo%> = {
    chart: {
        styledMode: true
    },
    title: {
        text: 'Ventas por Cliente'
    },
    xAxis: {
        categories: []
    },
	plotOptions: {
        series: {
            dataLabels: {
                enabled: false
            }
        }
    },
	tooltip: {
        pointFormat: '{point.y:.2f}: <b>({point.percentage:.2f}%)</b>'
    },
    yAxis: {
        min: 0,
        title: {
            text: 'Porcentaje'
        },
        stackLabels: {
			
            enabled: true,
            style: {
				
                fontWeight: 'bold',
                color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
            }
        }
    },
    series: [{
        type: 'pie',
        allowPointSelect: true,
        keys: ['name', 'y', 'selected', 'sliced'],
        data: <%=wConfig%>,
        showInLegend: true
    }]
};

