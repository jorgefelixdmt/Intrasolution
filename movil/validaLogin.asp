<%@ Language=VBScript %>
<!-- #INCLUDE FILE="../includes/Connection_inc.asp" -->

<%
  Response.ContentType = "text/plain"
  Response.Expires = -1
  Response.CacheControl = "Private"
  Response.AddHeader "PRAGMA", "NO-CACHE"
  wEmpresa = Request("Empresa")
  wUser = Request("TxtCodigo")
  wPass = Request("TxtPassword")
  
  temp = Split(wUser,"@")
  wUser = temp(0)
  wEmpresa = temp(1)

  Set oRsCompany = Server.CreateObject("ADODB.Recordset")
  strSQL = "SELECT * FROM PM_PARAMETER WHERE VALUE = '" & wEmpresa & "'"
  oRsCompany.Open strSQL, oConn

  str = "No existe la compañia."
  IF Not oRsCompany.Eof THEN
    str = "existe"
    oRsCompany.Close
    oConn.Close 'Cerramos la conexion anterior'

    'Abrimos la conexion con la base de datos de la empresa y buscamos el usuario'
    strConnQuery = Application(wEmpresa)
    oConn.Open(strConnQuery)
    oConn.CommandTimeout = 60

    Set oRsUser = Server.CreateObject("ADODB.Recordset")
    strSQL = "SELECT sc_user_id as owner_id FROM sc_user where user_login = '" & wUser & "' and password = '" & wPass & "' and is_deleted=0"
    oRsUser.Open strSQL, oConn

    IF Not oRsUser.Eof THEN
      owner_id = oRsUser("owner_id")
      str = "Correcto," & owner_id
      Response.Redirect("index.asp?Empresa=" & wEmpresa & "&Id_Usuario=" & owner_id & "&Id_home=19")
    ELSE
      Response.Redirect("login.asp?Error=1")
    END IF
  ELSE 
    Response.write "No esta registrada la Compañia en PM_PARAMETER"
  END IF

%>
