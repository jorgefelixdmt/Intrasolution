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
            
	wSQL = "pr_pa_tab_pases_pendientes " & wId_Usuario

    Set wRsPases = Server.CreateObject("ADODB.recordset")
    wRsPases.CursorLocation = 3
    wRsPases.CursorType = 2
    wRsPases.Open wSQL, oConn,1,1

        
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
        
        <div class="panel-body" style="overflow-y:hidden;">
	 <div class="table-responsive">
	<table id="<%=wCodigo%>" class="table table-striped table-bordered nowrap" style="width:100%; font-size:12px">
        <thead>
            <tr>
                <th>Item</th>
                <th>Código Jira</th>
                <th style="width:40%">Descripción Pase</th>
                <th>Proyecto</th>
                <th>Fecha</th>
                <th>Estado</th>
                <th>Días</th>
            </tr>
        </thead>
        <tbody>
            <%  i = 1
            Do While Not wRsPases.Eof
            %>
                    <tr>
        	            <td class="text-center"><%=i%></th>
						<td><%=wRsPases("codigo_jira")%></td>
						<td><%=wRsPases("descripcion")%></td>
                        <td><%=wRsPases("proyecto")%></td>
						<td><%=wRsPases("fecha")%></td>
						<td><%=wRsPases("estado")%></td>
						<td><%=wRsPases("dias")%></td>
		            </tr>
          <%  i = i + 1 
              wRsPases.MoveNext
            Loop%>     
        </tbody>
    </table>
 </div>
</div>

<%
   wRsPases.Close
    Set wRsPases = Nothing 
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
        "info": true, /*Muestra cantidad de registros*/
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

            