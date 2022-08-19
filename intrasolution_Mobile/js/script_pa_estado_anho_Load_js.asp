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

    wSQL = "pr_pa_estado_anho " & wId_Usuario & "," & wAnno
	
	Set wRs = Server.CreateObject("ADODB.recordset")
    wRs.Open wSQL, oConn
		
	wConfig = "["
	
	if not(wRs.EOF)  then

		'** Crea la serie
		NL = chr(13) & chr(10)

		contador = 0
		Do While Not wRs.EOF

			wConfig = wConfig & "{" & NL
			wConfig = wConfig & """name"": """ & Server.HTMLEncode(wRs("estado")) &""","& NL 
			wConfig = wConfig & """y"": " & wRs("cantidad") & NL 
			wConfig = wConfig & "}," & NL
			
			contador = contador + 1

			wRs.MoveNext
		Loop
		if contador > 0 then
			wConfig = Left(wConfig,len(wConfig)-3)
		end if

	end if
			
	wConfig = wConfig & "]" & NL
		

	Response.Write(wConfig)
	
%>


