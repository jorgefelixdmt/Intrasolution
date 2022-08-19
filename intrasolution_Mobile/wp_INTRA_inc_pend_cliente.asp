<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="../Includes/f_ValidaURL.asp" -->
<%
    Server.ScriptTimeout = 360
    
  wEmpresa = Session("Empresa")
	wId_Unidad = Session("Id_Unidad")
	wId_Usuario = Session("Id_Usuario")
  wAnno = Session("Anno") 
  wCodigo = Session("Codigo")
    
	
	wSQL = "SELECT fb_cliente_id, nombre FROM fb_cliente WHERE is_deleted = 0"
	
	Set wRsCliente = Server.CreateObject("ADODB.recordset")
    wRsCliente.CursorLocation = 3
    wRsCliente.CursorType = 2
    wRsCliente.Open wSQL, oConn,1,1
	
%>
<!-- CUADRO TRABAJADORES -->

	<!-- top tiles -->
		   		
		<div id="canvas_<%=wCodigo%>"></div>
		

<%
	wRsCliente.Close
    Set wRsCliente = Nothing 
  %>
  
  
