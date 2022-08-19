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
   'wCodigo = Request("Codigo")
	wIncidente = Request("wIncidente")
	wPase = Request("wPase")
	'if wPase = "Seleccionar..." then
	''	wPase = 0
	'end if
    wTipoTarea = Request("wTipotarea")
	wSubTipoTarea = Request("wSubTipotarea")
	wObservacion = Request("wObservacion")
	wStart = Request("wStart") '& " : " & Request("wHoraInicio")
	wFin = Request("wFin") '& " : " & Request("wHoraFin")
	wType = Request("wType")
    wId = Request("wId")


	wSQL = "[pr_graf_inc_calendario_crud] "& wType &","& wId &","& wTipoTarea &","& wSubTipoTarea &","& wIncidente &",'"& wObservacion &"','"& wStart&"','"& wFin&"',"& wId_Unidad &","& wId_Usuario
    Set wRs = Server.CreateObject("ADODB.recordset")

    wRs.Open wSQL, oConn

	wDataSetUEA = ""
	
	NL = chr(13) & chr(10)
	


	wCantidades = ""

	Contador = 0

	
	wUnidades = wUnidades & "{" 
	if Not wRs.Eof then
		wUnidades = wUnidades & """id"":""" & Server.HTMLEncode(wRs("id")) & """" & ","
		wUnidades = wUnidades & """codigo"":""" & Server.HTMLEncode(wRs("codigo")) & """" & ","
		wUnidades = wUnidades & """title"":""" & Server.HTMLEncode(wRs("nombre_tipo_tarea")) & """" & ","
		wUnidades = wUnidades & """tipo_tarea_id"":""" & Server.HTMLEncode(wRs("tipo_tarea_id")) & """" & ","
		wUnidades = wUnidades & """persona"":""" & Server.HTMLEncode(wRs("nombre")) & """" & ","
		wUnidades = wUnidades & """nombre_id"":""" & Server.HTMLEncode(wRs("nombre_id")) & """" & ","
		wUnidades = wUnidades & """nombre_subtipo_tarea"":""" & Server.HTMLEncode(wRs("nombre_subtipo_tarea")) & """" & ","
		wUnidades = wUnidades & """subtipo_tarea_id"":""" & Server.HTMLEncode(wRs("subtipo_tarea_id")) & """" & ","
		wUnidades = wUnidades & """hora_inicio"":""" & Server.HTMLEncode(wRs("hora_inicio")) & """" & ","
		wUnidades = wUnidades & """hora_fin"":""" & Server.HTMLEncode(wRs("hora_fin")) & """" & ""
		Contador = Contador + 1 
		wRs.MoveNext 
	end if
	wUnidades = wUnidades & "}" 

	wRs.Close
	Response.Write(wUnidades)
	
%>


