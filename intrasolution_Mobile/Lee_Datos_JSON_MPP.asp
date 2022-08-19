<%@ Language=VBScript %>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->

<%
Response.Expires = -3000
Response.Buffer = True
Server.ScriptTimeout=30060
wcodigo_ticket =""

Response.ContentType = "application/json"
Response.Expires = -1
Response.CacheControl = "Private"
Response.AddHeader "PRAGMA", "NO-CACHE"
Response.AddHeader "Content-Type", "text/javascript;charset=UTF-8"
Response.CharSet = "UTF-8"
    
wEmpresa = Request("Empresa")
wId_Unidad = Request("Id_Unidad")
wId_Usuario = Request("Id_Usuario")
wTitulo = Request("titulo")    
wJSON = Request("contenido")

wEmpresa = "intrasolution"



strSQL = "select json from pry_mpp_gantt_chart where pry_mpp_gantt_chart_id = 1" 

Set oRs = Server.CreateObject("ADODB.recordset")
		oRs.Open strSQL, oConn
		
		response.write oRs("json")
  
%>