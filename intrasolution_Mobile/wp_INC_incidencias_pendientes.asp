<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="../Includes/f_ValidaURL.asp" -->

<%
 
' ******************************************************************************************************************************************************
' Nombre: wp_Facturas_Pendientes_Table.asp
' Fecha Creación: 05/23/2020
' Autor: Valky Salinas
' Descripción: ASP que genera una tabla de incidencias pendientes.
' Usado por: Home Principal.
' 
' ******************************************************************************************************************************************************
' RESUMEN DE CAMBIOS
' Fecha(dd-mm-aaaa)         Autor                      Comentarios      
' --------------------      ---------------------      -----------------------------------------------------------------------------------------------
'
' ******************************************************************************************************************************************************
' 
'

%>

<%
    Server.ScriptTimeout = 360
    
    wEmpresa = Session("Empresa")
	wId_Unidad = Session("Id_Unidad")
	wId_Usuario = Session("Id_Usuario")
    wAnno = Session("Anno")    
	wCodigo = Session("Codigo")
    wTipoInc = Session("Tipo_Incidencia")
    wAmbito = Session("Ambito")

	if wAnno = "" then wAnno = 0
	
	if cdbl(wAmbito) = 0 then wCodAmb = "A"
	if cdbl(wAmbito) = 1 then wCodAmb = "INT"
	if cdbl(wAmbito) = 2 then wCodAmb = "EXT"
            
	wSQL = "pr_inc_lista_pendientes " & wId_Usuario & "," & wTipoInc & ",'" & wCodAmb & "'"

    Set wRsIncidencias = Server.CreateObject("ADODB.recordset")
    wRsIncidencias.CursorLocation = 3
    wRsIncidencias.CursorType = 2
    wRsIncidencias.Open wSQL, oConn,1,1

        
%>

<!-- TAREAS PENDIENTES -->


<!--
<table id="data-table" class="table table-striped table-condensed table-striped">
        <thead>
		<tr>
			<th class="col-sm-1 text-center">ITEM</th>
			<th class="col-sm-1">CÓDIGO EVENTO</th>
			<th class="col-sm-1">TIPO EVENTO</th>
			<th class="col-sm-1">INSTALACIÓN</th>
			<th class="col-sm-2">LUGAR</th>
			<th class="col-sm-1">FECHA</th>
			<th class="col-sm-1 text-center">VOLUMEN DERRAMADO (bbl)</th>
			<th class="col-sm-1 text-center">VOLUMEN RECUPERADO (bbl)</th>
		</tr>
		</thead>
		<tbody> -->
        
        <div class="panel-body" style="width:100%">
	 <div class="table-responsive">
	<table id="<%=wCodigo%>" class="table table-striped table-bordered wrap">
        <thead>
            <tr>
                <th>Item</th>
                <th>Proyecto</th>
                <th>Incidente</th>
                <th>Fecha</th>
                <th>Estado / Fecha</th>
                <th>Pase</th>
                <th>Estado Pase</th>
            </tr>
        </thead>
        <tbody>
            <%  i = 1
            Do While Not wRsIncidencias.Eof%>
                    <tr>
        	            <td class="text-center"><%=i%></th>
			            <td><%=wRsIncidencias("proyecto")%></td>
						<td><%=wRsIncidencias("incidencia")%></td>
			            <td class="text-center"><%=wRsIncidencias("fecha")%></td>
						<td class="text-center"><%=wRsIncidencias("estado")%></td>
						<td class="text-center"><%=wRsIncidencias("cod_pase")%></td>
			            <td class="text-center"><%=wRsIncidencias("estado_pase")%></td>
		            </tr>
          <%  i = i + 1 
              wRsIncidencias.MoveNext
            Loop%>     
        </tbody>
    </table>
 </div>
</div>

<%
   wRsIncidencias.Close
    Set wRsIncidencias = Nothing 
%>				
 