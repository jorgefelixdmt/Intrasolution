<!--#include file="../Includes/constant.inc"-->
<%
dim wCodigo,wPassword,objVerifica,Id_Usu,wPagGrupo,wUsuarioDomain,ObjDB
Dim rsUsuario, wUsuario, oGrupos, rsGrupo, StrNombreGrupo,wusuarioAuth,FechaFin
Dim wErrorUsuarioGenerico

wErrorUsuarioGenerico  = Request("ErrorSQL")

wUsuarioDomain = Request.ServerVariables("LOGON_USER")
wusuarioAuth = Request.ServerVariables("AUTH_USER")
wIP = Request.ServerVariables("REMOTE_ADDR")

postira = instr(wUsuarioDomain,"\") 
if Postira > 0 then 
	wUsuarioNT = mid(wUsuarioDomain,posTira+1)
else
	wUsuarioNY = wUsuarioDomain
end if		

wCodigo = Request("TxtCodigo")
wPassword = Request("TxtPassword")
RegKey = Application("RegEditKey")
'RegKey = RegEditKey

	Set rsUsuario = Server.CreateObject("ADODB.Recordset")
	Set objVerifica = Server.CreateObject("IS_Administrador_BUS.Usuario")

	set cn = Server.CreateObject("ADODB.Connection")

	'set cn = Server.CreateObject("ADODB.Connection")
	'on Error Resume Next
	set rsUsuario = objVerifica.VerifyLoginDB(wCodigo,wPassword)

	if Err.number > 0 then
		If wErrorUsuarioGenerico = "SQL" Then 
			Response.Redirect ("../Error.asp?Error=" & Err.Number & "&ErrDescr=" & Err.description & "&ErrorSQL=" & wErrorUsuarioGenerico)
		Else
			Response.Redirect ("../Error.asp?Error=" & Err.Number & "&ErrDescr=" & Err.description)
		End If
	end if
	set objVerifica = Nothing

	If rsUsuario.BOF and rsUsuario.EOF then
		'No existe el Usuario en la BD de Intrasolution
		rsUsuario.Close
		set rsUsuario = Nothing
		Set objVerifica = Nothing

		Set ObjLogErrorDB = Server.CreateObject("IS_GENERIC_DB.ClsExecute")
		wSQL = "sp_LogError_ins " & "'" & wCodigo & "','" & wPassword & "','" & wIP & "','" & wUsuarioNT & "'"
		x = ObjLogErrorDB.Execute_Inserta(wSQL,RegKey)			
		
		If wErrorUsuarioGenerico = "SQL" Then
			Response.Redirect ("../Error.asp?Error=64000&ErrorSQL=" & wErrorUsuarioGenerico)
		Else
			Response.Redirect ("../Error.asp?Error=64000")
		End If
	Else
		Set rsGrupo = Server.CreateObject("ADODB.Recordset")
		Set oGrupos = Server.CreateObject("IS_Administrador_DB.Seguridad")
		'Set oGrupos = Server.CreateObject("IS_GENERIC_DB.ClsExecute")
		Set rsGrupo = oGrupos.GetGrupo(clng(rsUsuario("id_default")))
		If Not rsGrupo.eof then'And Not rsGrupo.bof Then
			StrNombreGrupo = rsGrupo.fields.item("desc_grupo")
		End If 				
		
		wSQL = "sp_USUARIO_Get_Grupos " & rsUsuario("id_Usu")
		'set rsGrupo = oGrupos.Execute_Consulta(wSQL,RegKey)
		
		
		if rsGrupo.EOF then
		    rsUsuario.Close
		    set rsUsuario = Nothing
		    Set objVerifica = Nothing
		    rsGrupo.Close
		    set rsGrupo = Nothing
		    Set oGrupos = Nothing
			Response.Redirect ("../Error.asp?Error=64004")
			Response.End 
		end if 

		rsGrupo.close
		Set rsGrupo = Nothing
		Set oGrupos = Nothing
		
		Response.Cookies("Usuario")("Codigo") = wCodigo
	
		Response.Cookies("Usuario")("Id") = rsUsuario("id_Usu")
		Response.Cookies("Usuario")("Cod_Interno") = rsUsuario("Cod_Empleado")
		if IsNull(rsUsuario("flag_admin")) then 
			Response.Cookies("Usuario")("Flag_Admin") = "0"
		else
			Response.Cookies("Usuario")("Flag_Admin") = rsUsuario("flag_admin")
		End if	
		Response.Cookies("Usuario")("Nombre") = trim(rsUsuario("Nombre")) & " " & trim(rsUsuario("apellido"))
		'Response.Cookies("Usuario")("Nombre") = trim(rsUsuario("Nombre")) 
		Response.Cookies("Usuario")("Autenticacion") = Session("wFlagAutenticacion")	'AUTENTICACION INTEGRADA WINDOWS
	
		Response.Cookies("Usuario")("TipoIdioma")= Session("wIdiomaDefecto")
		Response.Cookies("Usuario")("Id_Grupo") = rsUsuario("id_default")
		Response.Cookies("Usuario")("Nombre_Grupo") = StrNombreGrupo
		Response.Cookies("Usuario")("Id_Modulo") = 0
		session("FlagLogon")=1
		

		'----------------------------------------------------------------
		'Leer del Registry
		'----------------------------------------------------------------
		Response.Cookies("Usuario")("ServidorExchange") = Session("wServidorMensajeria")
		Response.Cookies("Usuario")("SistemaMensajeria") = Session("wSistemaMensajeria")
	
		'NRP, Variables Cambio de Idioma 
		Response.Cookies("Usuario")("MultiIdioma") = Session("wMultiIdioma")
		Response.Cookies("Usuario")("IdiomaDefecto") = Session("wIdiomaDefecto")  	

		'----------------------------------------------------------------
		sMailBox = ""
		if Not IsNull(rsUsuario("Email")) then sMailBox = rsUsuario("Email")
		Response.Cookies("Usuario")("mailbox") = sMailBox

		'Set rsUsuario=nothing
		Set objVerifica=nothing
		id_Usuario=rsUsuario("id_Usu")
         
		Set ObjDB = Server.CreateObject("IS_GENERIC_DB.ClsExecute")		
		Set wRsLogin = CreateObject("ADODB.RecordSet")	
		wSQL = "sp_UsuarioFechaFin_get " & Id_usuario
		Set wRsLogin = ObjDB.Execute_Consulta(wSQL,RegKey)   
		 permiso = wRsLogin("permiso")		 
        if permiso=0 then        
			'Set ObjDB = Server.CreateObject("IS_GENERIC_DB.ClsExecute")			
			'wSQL = "sp_UsuarioFechaFin_get '" & wCodigo & "','" & wPassword & "'" 
				
			'Set wRsUltimoPass = ObjDB.Execute_Consulta(wSQL,RegKey)	
						
			'if not wRsUltimoPass.eof then
				
				Response.Redirect "Seguridad/Cambiarpassword2.asp" 
			else
			    Response.Redirect "Corporativo/HomeCorporativo.asp"
			End If	
        'Else
		'	Response.Redirect "Corporativo/HomeCorporativo.asp"
		'End if		
		'Response.Redirect "Corporativo/HomeCorporativo.asp"

		'End If	
    		Set rsUsuario=nothing
END IF 
%>