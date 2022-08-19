<!--#INCLUDE FILE="Includes/Connection_inc.asp"-->

<%
   Response.AddHeader "Set-Cookie", "SameSite=None; Secur; path=/; HttpOnly"
   Server.ScriptTimeout = 360
  

       
	wId_Usuario = Request("Id_Usuario")
    wEmpresa = Request("Empresa")
    wId_Unidad = Request("Id_Unidad")    

'/* Obtiene el Codigo del Unidad para identificar si es la Corporativa */
    strSQL = "Select codigo from FB_UEA_PE "
    strSQL = strSQL & " Where fb_uea_pe_id = " & wId_Unidad
	Set osRsUEA = Server.CreateObject("ADODB.Recordset")
    osRsUEA.Open strSQL, oConn
    wCodeUEA = UCASE(osRsUEA("Codigo"))
    
    
'/* Obtiene el Rol del Usuario para la UEA */
    strSQL = "Select r.CODE, r.SC_ROLE_ID, r.fb_home_id"
    strSQL = strSQL & " from SC_USER_ROLE ur "
    strSQL = strSQL & "   inner join SC_ROLE r on r.SC_ROLE_ID = ur.SC_ROLE_ID " 
    strSQL = strSQL & " Where ur.is_deleted=0 and r.is_deleted=0 and ur.COMPANY_ID = " & wId_Unidad
    strSQL = strSQL & "      and ur.sc_user_id = " & wId_Usuario 
	Set oRsUsuario = Server.CreateObject("ADODB.Recordset")
    oRsUsuario.Open strSQL, oConn
    if Not oRsUsuario.Eof then
        wCodeRol = oRsUsuario("Code")
        wfb_home_Id = oRsUsuario("fb_Home_id") 
        if IsNull(wfb_home_id) then wfb_home_Id = 0
    end if    

	if cdbl(wfb_home_Id) = 4 or cdbl(wfb_home_Id) = 5 then
		Response.Redirect "Home_Plantilla.asp?Id_Home=" & wfb_home_Id & "&Id_Usuario=" & wId_Usuario & "&Id_Unidad=" & wId_Unidad & "&Empresa=" & wEmpresa
	else
		if cdbl(wfb_home_Id) = 0 then
			Response.Redirect "Default.asp"
		else
			if cdbl(wfb_home_Id) = 20003 then
				Response.Redirect "Home_Plantilla_DOM.asp?Id_Home=" & wfb_home_Id & "&Id_Usuario=" & wId_Usuario & "&Id_Unidad=" & wId_Unidad & "&Empresa=" & wEmpresa
			else
				if cdbl(wfb_home_Id) = 20001 then
					Response.Redirect "Home_Plantilla_CLI.asp?Id_Home=" & wfb_home_Id & "&Id_Usuario=" & wId_Usuario & "&Id_Unidad=" & wId_Unidad & "&Empresa=" & wEmpresa
				else
					Response.Redirect "Home_Plantilla_v3.asp?Id_Home=" & wfb_home_Id & "&Id_Usuario=" & wId_Usuario & "&Id_Unidad=" & wId_Unidad & "&Empresa=" & wEmpresa
				end if
			end if
		end if
	end if

  %>
 