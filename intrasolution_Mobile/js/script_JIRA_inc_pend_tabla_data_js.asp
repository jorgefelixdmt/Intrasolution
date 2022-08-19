<%@ Language=VBScript %>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->

<%
 
' ******************************************************************************************************************************************************
' Nombre: Home_Estadistico_cuadro.asp
' Fecha Creación: ---
' Autor: Enrique Huaman
' Descripción: ASP para gráficos de derecho de uso.
' Usado por: Módulo Gestión Agua
' 
' ******************************************************************************************************************************************************
' RESUMEN DE CAMBIOS
' Fecha(aaaa-mm-dd)         Autor                      Comentarios      
' --------------------      ---------------------      -----------------------------------------------------------------------------------------------
' 05/12/2019                Valky Salinas              Se cambió la lógica del semáforo.
'
' 15/04/2020                Valky Salinas              Se comentaron las referencias a la tabla ga_target_Ratio.
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
	wId_Unidad = Request("Unidad")
	wId_Estacion = Request("Estacion")
	wId_Resolucion = Request("Resolucion")
	wId_Anio = Request("Anio")
	inicio = Request("inicio")
	fin = Request("fin")
	
	wCliente = Request("CLiente")



    wSQL = "pr_pry_jira_inc_pend_tabla " & wCliente & ",'" & inicio & "','" & fin & "'"
	
	'wSQL2 = "select valor_minimo, valor_maximo, color from ga_target_Ratio where is_deleted = 0"
	'Response.Write(wSQL)
    Set wRs = Server.CreateObject("ADODB.recordset")
    'Set wRs2 = Server.CreateObject("ADODB.recordset")

    wRs.Open wSQL, oConn
	
	NL = chr(13) & chr(10)
	
	Contador = 0

	wConfig = "[" & NL
	if not wRs.EOF then
		Do Until wRs.EOF
			wConfig = wConfig & "{" & NL
			wConfig = wConfig & "	  ""codigo"" : """ & wRs("codigo") & """," & NL
			wConfig = wConfig & "	  ""proyecto"" : """ & wRs("proyecto") & """," & NL
			wConfig = wConfig & "	  ""incidencia"" : ""<a href=\""" & wRs("url") & "\"" target=\""_blank\"">" & wRs("incidencia") & "</a>""," & NL
			wConfig = wConfig & "   ""fecha"" : """ & wRs("fecha") & """," & NL
			wConfig = wConfig & "	  ""prioridad"" : """ & wRs("prioridad") & """," & NL
			wConfig = wConfig & "	  ""dias"" : """ & wRs("dias") & """" & NL
			wConfig = wConfig & "}," & NL
			
			contador = contador +1
			wRs.MoveNext
		Loop
	end if
	if contador > 0 then
		wConfig = Left(wConfig,len(wConfig)-3)
	end if
	wConfig = wConfig & "]"

	

	wRs.Close

	Response.write(wConfig)
	'Response.Write(wConfig)
	
%>


