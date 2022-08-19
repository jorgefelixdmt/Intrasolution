<%@ Language=VBScript %>

<%
  wEmpresa = Request("Empresa")
  wUser = Request("TxtCodigo")
  wPass = Request("TxtPassword")
  

  temp = Split(wUser,"@")

  wEmpresa = temp(1)

  Arroba = Application(wEmpresa)
 
  IF Arroba = "" THEN
      Response.Redirect("login.asp?Error=2")
  ELSE
      Response.Redirect("validaLogin.asp?Empresa=" & wEmpresa & "&TxtCodigo=" & wUser & "&TxtPassword=" & wPass)
  END IF

%>
