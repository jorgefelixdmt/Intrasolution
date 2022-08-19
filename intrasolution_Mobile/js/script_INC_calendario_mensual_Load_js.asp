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
	
    
	wSQL = "[pr_graf_inc_calendario] 0,0," & wId_Usuario  
	'wSQL = "[pr_graf_inc_calendario] 0,1,1"

    Set wRs = Server.CreateObject("ADODB.recordset")
    wRs.Open wSQL, oConn
	
	'** Crea los dataset como una cadena de valores separados con coma

	wDataSetUEA = ""
	
	NL = chr(13) & chr(10)
	

	wUnidades = "["
	wCantidades = ""

	Contador = 0

	Do While Not wRs.Eof
	'response.write wRs("id")
	'response.end
		If isNull(wRs("id")) then
			id = ""
		End If
		
		If isNull(wRs("tipo_tarea_id")) Then
			tipo_tarea_id = ""
		End If
		If isNull(wRs("subtipo_tarea_id")) Then
			subtipo_tarea_id = ""
		End If
		
		If isNull(wRs("nombre_id")) Then
			nombre_id = ""
		End If

		wUnidades = wUnidades & "{" 
		'wUnidades = wUnidades & """id"":""" & Server.HTMLEncode(id) & """" & ","
		wUnidades = wUnidades & """codigo"":""" & Server.HTMLEncode(wRs("codigo")) & """" & ","
		wUnidades = wUnidades & """title"":""" & Server.HTMLEncode(wRs("nombre_tipo_tarea")) & """" & ","
		'wUnidades = wUnidades & """tipo_tarea_id"":""" & Server.HTMLEncode(tipo_tarea_id) & """" & ","
		wUnidades = wUnidades & """title"":""" & Server.HTMLEncode(wRs("nombre_subtipo_tarea")) & """" & ","
		wUnidades = wUnidades & """tipo_tarea_id"":""" & Server.HTMLEncode(subtipo_tarea_id) & """" & ","
		wUnidades = wUnidades & """persona"":""" & Server.HTMLEncode(wRs("nombre")) & """" & ","
		'Unidades = wUnidades & """nombre_id"":""" & Server.HTMLEncode(nombre_id) & """" & ","
		wUnidades = wUnidades & """hora_inicio"":""" & Server.HTMLEncode(wRs("hora_inicio")) & """" & ","
		wUnidades = wUnidades & """hora_fin"":""" & Server.HTMLEncode(wRs("hora_fin")) & """" & ""
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


