<%@ Language=VBScript %>
<%response.Buffer=false%>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<%
    Server.ScriptTimeout = 360
  	Response.ContentType = "text/javascript"
	Response.AddHeader "Content-Type", "text/javascript;charset=UTF-8"
	Response.CodePage = 65001
	Response.CharSet = "UTF-8"
    
    wEmpresa = Request("Empresa")
	wId_Unidad = Request("Id_Unidad")
	wId_Usuario = Request("Id_Usuario")
    wAnno = Request("Anno")    
    wCodigo = Request("Codigo")
	w_tipo_evaluacion = Request("tipo_evaluacion")
	w_Cantidad = Request("cantidad")
	wUltAnno = Request("ultAnno")
	
	wIndicador = Request("indicador")
	wTipoGrafico = Request("tipografico")
	
	
	'Obtiene Nobre Autoridad para el Titulo de Grafico
	Set wRsSedeNombre = Server.CreateObject("ADODB.recordset")
	wSQL = " SELECT nombre"
	wSQL = wSQL + " FROM fb_uea_pe"
	wSQL = wSQL & " WHERE fb_uea_pe_id = " & wId_Unidad & " AND is_deleted = 0"
	wRsSedeNombre.Open wSQL, oConn
	
	If wId_Unidad = "0" then
	
		wSedeNombre = "Todas"
	else 
		wSedeNombre = wRsSedeNombre("nombre")
	
	End if
	
	
	if wIndicador = "" then wIndicador = 0
	if wAnno = "" then wAnno = 0
	if wCantidad = "" then wCantidad = 20
	
	If wAnno = "0" then
	
		wAnnoNombre = "Todas"
	else 
		wAnnoNombre = wAnno
	End if
	
	
	If wAnno = "0" then
	
		wAnnoNombreSubTitulo = "  "
	else 
		wAnnoNombreSubTitulo = "  - Periodo : " + wAnno
	End if
	
    wAnnosPrev = 1
	wPel = 1
    
	wSQL = "exec pr_graf_ind_indicador_matriz_v2 " & wId_Unidad & "," & wAnno & "," & wIndicador
	
    Set wRs = Server.CreateObject("ADODB.recordset")
    wRs.Open wSQL, oConn
	
	'** Crea los dataset como una cadena de valores separados con coma
	
	wSedeAct = ""
	wAnhoAct = ""
	wDataSetP = ""
	wDataSetNP = ""
	
	Contador = 0
	wPorcentajeAcumulado = 0
	
	wMesAct = 0
	
	wconfig = "["
	
	If Not wRs.Eof Then
		Do While Not wRs.Eof
			if isnull(wRs("Enero")) then wVal = 0 else wVal = wRs("Enero") end if
			wconfig = wconfig & wVal & ","
			
			if isnull(wRs("Febrero")) then wVal = 0 else wVal = wRs("Febrero") end if
			wconfig = wconfig & wVal & ","
			
			if isnull(wRs("Marzo")) then wVal = 0 else wVal = wRs("Marzo") end if
			wconfig = wconfig & wVal & ","
			
			if isnull(wRs("Abril")) then wVal = 0 else wVal = wRs("Abril") end if
			wconfig = wconfig & wVal & ","
			
			if isnull(wRs("Mayo")) then wVal = 0 else wVal = wRs("Mayo") end if
			wconfig = wconfig & wVal & ","
			
			if isnull(wRs("Junio")) then wVal = 0 else wVal = wRs("Junio") end if
			wconfig = wconfig & wVal & ","
			
			if isnull(wRs("Julio")) then wVal = 0 else wVal = wRs("Julio") end if
			wconfig = wconfig & wVal & ","
			
			if isnull(wRs("Agosto")) then wVal = 0 else wVal = wRs("Agosto") end if
			wconfig = wconfig & wVal & ","
			
			if isnull(wRs("Setiembre")) then wVal = 0 else wVal = wRs("Setiembre") end if
			wconfig = wconfig & wVal & ","
			
			if isnull(wRs("Octubre")) then wVal = 0 else wVal = wRs("Octubre") end if
			wconfig = wconfig & wVal & ","
			
			if isnull(wRs("Noviembre")) then wVal = 0 else wVal = wRs("Noviembre") end if
			wconfig = wconfig & wVal & ","
			
			if isnull(wRs("Diciembre")) then wVal = 0 else wVal = wRs("Diciembre") end if
			wconfig = wconfig & wVal & "]"
		
			wRs.MoveNext
		Loop
	End If
	
	wRs.Close 
	
	Response.Write(wconfig)
%>