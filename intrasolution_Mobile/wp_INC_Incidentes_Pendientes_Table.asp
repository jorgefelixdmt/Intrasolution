<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="../Includes/f_ValidaURL.asp" -->

<%
 
' ******************************************************************************************************************************************************
' Nombre: wp_Facturas_Pendientes_Table.asp
' Fecha Creación: 09/11/2020
' Autor: Jorge Felix
' Descripción: ASP que genera una tabla de saldo por proyectos.
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
	
	if cdbl(wAmbito) = 0 then wCodAmb = "A"
	if cdbl(wAmbito) = 1 then wCodAmb = "INT"
	if cdbl(wAmbito) = 2 then wCodAmb = "EXT"
            
	wSQL = "pr_inc_tab_incidentes_pendientes " & wId_Usuario & "," & wTipoInc & ",'" & wCodAmb & "'"

    Set wRsInc = Server.CreateObject("ADODB.recordset")
    wRsInc.CursorLocation = 3
    wRsInc.CursorType = 2
    wRsInc.Open wSQL, oConn,1,1

        
%>
        
        <div class="panel-body" style="overflow-y:hidden;">
	 <div class="table-responsive">
	<table id="<%=wCodigo%>" class="table table-striped table-bordered nowrap" style="width:100%; font-size:12px">
        <thead>
            <tr>
                <th>Item</th>
                <th>Ticket</th>
                <th>Jira</th>
                <th>Incidencia</th>
                <th>Proyecto</th>
                <th>Responsable</th>
                <th>Tipo</th>
                <th>Ámbito</th>
                <th>Estado</th>
                <th>Fecha</th>
                <th>Código Pase</th>
            </tr>
        </thead>
        <tbody>
            <%  i = 1
            Do While Not wRsInc.Eof
            %>
                    <tr>
        	            <td class="text-center"><%=i%></th>
						<td><%=wRsInc("ticket")%></td>
						<td><%=wRsInc("jira")%></td>
						<td><%=wRsInc("incidencia")%></td>
						<td><%=wRsInc("proyecto")%></td>
						<td><%=wRsInc("responsable")%></td>
						<td><%=wRsInc("tipo")%></td>
						<td><%=wRsInc("ambito")%></td>
						<td><%=wRsInc("estado")%></td>
						<td><%=wRsInc("fecha")%></td>
                        <td><%=wRsInc("codigo_pase")%></td>
		            </tr>
          <%  i = i + 1 
              wRsInc.MoveNext
            Loop%>     
        </tbody>
    </table>
 </div>
</div>

<%
   wRsInc.Close
    Set wRsInc = Nothing 
%>				
 	

        
           <script>
$(document).ready(function() {
	
    var table = $('#<%=wCodigo%>').DataTable( {
        scrollY:        "340px",
        scrollX:        true,
        scrollCollapse: true,
        paging:         false,  /*paginacion*/
        fixedColumns:   true,
		"bFilter": true,  /*filtro buscar */
        "info": true,  /*Muestra cantidad de registros*/
     	"ordering": true, /*ordenar decendente  */
		"language": idioma_espanol, /*recupera la variable*/
		dom: 'Bfrtip',
        buttons: [
         
        ],
		
	columnDefs: [
            { width: '1%', targets: 0 }
        ],
        fixedColumns: true
		
	
		
    } );
} );
</script>

            