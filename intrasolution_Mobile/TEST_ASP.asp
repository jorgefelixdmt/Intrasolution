<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<%
    Server.ScriptTimeout = 360
    
  wEmpresa = Session("Empresa")
	wId_Unidad = Session("Id_Unidad")
	wId_Usuario = Session("Id_Usuario")
  wAnno = Session("Anno") 
  wCodigo = Session("Codigo")
  
 
  Set wRs = Server.CreateObject("ADODB.recordset")

    strSQL = "select top 1 summary from jiraissue"
	wRs.Open strSQL, oConnJ
	
	response.write(wRs("summary"))

%>