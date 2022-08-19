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
Response.AddHeader "Access-Control-Allow-Origin", "*"
Response.AddHeader "Access-Control-Allow-Credentials", "true"
Response.AddHeader "Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT"
Response.AddHeader "Access-Control-Allow-Headers", "Authorization, Content-Type, Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers"
'Response.AddHeader "Access-Control-Allow-Headers", "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With"

Response.AddHeader "Content-Type", "text/plain"
Response.CharSet = "UTF-8"
    
wEmpresa = Request("Empresa")
wId_Unidad = Request("Id_Unidad")
wId_Usuario = Request("Id_Usuario")
wTitulo = Request("titulo")    
wJSON = Request("contenido")

strSQL = "insert into pry_mpp_gantt_chart (titulo,json,fb_uea_pe_id,created,created_by,updated,updated_by,owner_id,is_deleted)"
strSQL = strSQL & " values ('" & wTitulo & "','" & wJSON & "',1,GETDATE(),1,GETDATE(),1,1,0)" 

oConn.Execute strSQL
  
%>