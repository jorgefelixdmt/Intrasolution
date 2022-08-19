<%@ Language=VBScript %>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
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
    wCodigo = Request("Codigo")
    wEmpleado = Request("Id_Empleado")
	
    
	wSQL = "[pr_graf_vea_calendario] 0,0," & wEmpleado  
	
    Set wRs = Server.CreateObject("ADODB.recordset")
    wRs.Open wSQL, oConn
	
	'** Crea los dataset como una cadena de valores separados con coma

	wDataSetUEA = ""
	
	NL = chr(13) & chr(10)
	

	wUnidades = "["
	wCantidades = ""

	Contador = 0

	Do While Not wRs.Eof
		wUnidades = wUnidades & "{" 
		wUnidades = wUnidades & """id"":" & Server.HTMLEncode(wRs("id"))  & ","
		wUnidades = wUnidades & """name"":""" & Server.HTMLEncode(wRs("codigo")) & """" & ","
		wUnidades = wUnidades & """location"":""" & Server.HTMLEncode(wRs("gerencia")) & """" & ","
		wUnidades = wUnidades & """gerencia_id"":""" & Server.HTMLEncode(wRs("gerencia_id")) & """" & ","
		wUnidades = wUnidades & """persona"":""" & Server.HTMLEncode(wRs("nombre")) & """" & ","
		wUnidades = wUnidades & """nombre_id"":""" & Server.HTMLEncode(wRs("nombre_id")) & """" & ","
		wUnidades = wUnidades & """estado"":""" & Server.HTMLEncode(wRs("estado")) & """" & ","
		wUnidades = wUnidades & """estado_id"":""" & Server.HTMLEncode(wRs("estado_id")) & """" & ","
		wUnidades = wUnidades & """fecha"":""" & Server.HTMLEncode(wRs("start")) & """" & ","
		wUnidades = wUnidades & """start"":""" & Server.HTMLEncode(wRs("start")) & """" & ""
		wUnidades = wUnidades & "}," 
		'wCantidades = wCantidades & wRs("Cantidad") & ","
		Contador = Contador + 1 
		wRs.MoveNext 
	Loop


	'Response.Write(wUnidades)
	if Contador > 0 then
		wUnidades = Left(wUnidades,len(wUnidades)-1)
		'wCantidades = Left(wCantidades,len(wCantidades)-1)
	end if
	wUnidades = wUnidades & "]"
	wRs.Close

	'wConfig = "[" & NL

	'wConfig = wConfig & "		{""Categories"": [" & wUnidades & "]}," & NL
	'wConfig = wConfig & "		{""Series"": [{" & NL
	'wConfig = wConfig & "			""name"": ""Cantidades""," & NL
	'wConfig = wConfig & "			""data"": [" & wCantidades & "]" & NL
	'wConfig = wConfig & "		}]}" & NL

	
	'wConfig = wConfig & "]" & NL
	Response.Write(wUnidades)
	
%>


