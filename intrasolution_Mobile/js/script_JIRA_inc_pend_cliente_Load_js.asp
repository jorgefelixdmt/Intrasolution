<%@ Language=VBScript %>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->

<%
 
' ******************************************************************************************************************************************************
' Nombre: script_INC_indice_LTI_CORP_chart_v2_Load_js.asp
' Fecha Creacion: 15/05/2020
' Autor: Valky Salinas
' Descripci?n: ASP que genera json para grafico de indicador de TRIFR.
' Usado por: Graficos de Indicadores de Eventos.
' 
' ******************************************************************************************************************************************************
' RESUMEN DE CAMBIOS
' Fecha(dd-mm-aaaa)         Autor                      Comentarios      
' --------------------      ---------------------      -----------------------------------------------------------------------------------------------
'
' ******************************************************************************************************************************************************
' 
'

%>

<%
    Response.ContentType = "application/json"
    Response.Expires = -1
    Response.CacheControl = "Private"
    Response.AddHeader "PRAGMA", "NO-CACHE"
	Response.AddHeader "Content-Type", "text/javascript;charset=UTF-8"
	Response.CharSet = "UTF-8"
    
    wEmpresa = Request("Empresa")
	wId_Unidad = Request("Id_Unidad")
	wId_Usuario = Request("Id_Usuario")
    wAnno = Request("Anno")    
    wCodigo = Request("Codigo")
	wUltAnno = Request("UltAnno")  
	
	inicio = Request("inicio")
	fin = Request("fin")

    wCliente = Request("Cliente")
	
	'** Crea los dataset como una cadena de valores separados con coma
    '************* DATA DEL GRAFICO *******************
        strSQL = "[pr_pry_jira_inc_pend_cliente] " & wCliente & ",'" & inicio & "','" & fin & "'"
		'response.write strSQL
		'response.end
		Set oRs = Server.CreateObject("ADODB.recordset")
		oRs.Open strSQL, oConn
		contador = 0
		
 		wCategorias = """categorias"": ["
		wSeries = """series"": ["
        wConfig= "{"
		
		NL = chr(13) & chr(10)

		contadorV = 0 
		
		If Not oRs.Eof Then
			For Each fld In oRs.Fields 
				If contadorV > 0 Then
					wCategorias = wCategorias & """" & fld.name & ""","
				End If
				contadorV = contadorV + 1
			Next
		End If
		
		contador = 0
		
		Do While Not oRs.Eof
		
			wData = ""
			contadorV = 0
		
			For Each fld In oRs.Fields 
				If contadorV > 0 Then
					value = "0"
					If Not IsNull(fld.value) Then
						value = fld.value
					End If
				
					wData = wData & value & ","
				End If
				contadorV = contadorV + 1
			Next
			
			If contadorV > 0 Then
				wData = Left(wData,len(wData)-1)
			End If
			
			wSeries = wSeries & "{""name"" : """ & Server.HTMLEncode(oRs("estado_tarea")) & """," & NL
			wSeries = wSeries & """data"" : [" & wData & "]}," & NL
			
			contador = contador + 1
			oRs.MoveNext
		Loop
		
		If contador > 0 Then
			wCategorias = Left(wCategorias,len(wCategorias)-1)
			wSeries = Left(wSeries,len(wSeries)-3)
		End If
		
		wCategorias = wCategorias & "]," & NL
		wSeries = wSeries & "]" & NL
		
		
		wConfig = wConfig & wCategorias & wSeries & "}"
		

	Response.Write(wConfig)
	
%>


