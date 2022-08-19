<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="../Includes/f_ValidaURL.asp" -->
<%
    Server.ScriptTimeout = 360
    
  wEmpresa = Session("Empresa")
	wId_Unidad = Session("Id_Unidad")
	wId_Usuario = Session("Id_Usuario")
  wAnno = Session("Anno") 
  wCodigo = Session("Codigo")
  
  inicio = Session("inicio")
  fin = Session("fin")
    
	
	wSQL = "SELECT fb_cliente_id, nombre FROM fb_cliente WHERE is_deleted = 0"
	
	Set wRsCliente = Server.CreateObject("ADODB.recordset")
    wRsCliente.CursorLocation = 3
    wRsCliente.CursorType = 2
    wRsCliente.Open wSQL, oConn,1,1
	
%>
<!-- CUADRO TRABAJADORES -->

	<!-- top tiles -->
		
	<div class="panel-body" style="overflow-y:hidden;">
		<div class="table-responsive">
			<table id="<%=wCodigo%>" class="table table-striped table-bordered wrap" >
				<thead>
					<tr>
						<th>Nº</th>
						<th>Proyecto</th>
						<th style="width:100px">Descripción Pase</th>
						<th>Código JIRA</th>
						<th>Fecha</th>
						<th>Estado</th>
						<th>Días</th>
					</tr>
				</thead>
				<tbody id="<%=wCodigo%>_tbody_table">
                </tbody>
			</table>
		</div>
	</div>
		   		
		

<%
	wRsCliente.Close
    Set wRsCliente = Nothing 
  %>
  
<script>

table_<%=wCodigo%> = $('#<%=wCodigo%>').DataTable( {
        scrollY:        "210px",
        scrollX:        true,
        scrollCollapse: true,
        paging:         false,  /*paginacion*/
        fixedColumns:   true,
		"bFilter": false,  /*filtro buscar */
     	"ordering": false, /*ordenar decendente  */
		"language": idioma_espanol, /*recupera la variable*/
		dom: 'Bfrtip',
        buttons: [
				{
					extend: "copy",
					className: "btn btn-primary btn-xs",
					titleAttr: 'Copiar',
					text: 'Copiar',
					init: function(api, node, config) {
					   $(node).removeClass('dt-button buttons-copy buttons-html5')
					}	
				},
				{
					extend: "csv",
					className: "btn btn-info btn-xs",
					titleAttr: 'csv',
					text: 'csv',
					init: function(api, node, config) {
					   $(node).removeClass('dt-button buttons-copy buttons-html5')
					}	
				},
				{
					extend: "excel",
					className: "btn btn-warning btn-xs",
					titleAttr: 'Excel',
					text: 'Excel',
					init: function(api, node, config) {
					   $(node).removeClass('dt-button buttons-copy buttons-html5')
					}	
				},
				{
					extend: "pdf",
					className: "btn btn-danger btn-xs",
					titleAttr: 'PDF',
					text: 'PDF',
					init: function(api, node, config) {
					   $(node).removeClass('dt-button buttons-copy buttons-html5')
					}	
				}, 
				/*{
					extend: "print",
					className: "btn btn-success btn-xs",
					titleAttr: 'Imprimir',
					text: 'Imprimir',
					init: function(api, node, config) {
					   $(node).removeClass('dt-button buttons-copy buttons-html5')
					}	
				}*/
		
         
        ],
		
		
	columnDefs: [
            { width: '1%', targets: 0 }
        ],
        fixedColumns: true
		
		
		
		
		
		
		
		
		
    } );

$(document).ready(function() {
	
    update_<%=wCodigo%>();
	
} );

function update_<%=wCodigo%>() {
	var cadena_filtros = "";
	
	var filters = document.getElementsByClassName("side-bar-filter")
	
	for(var i = 0; i < filters.length; i++) {
		cadena_filtros = "&" + filters[i].id + "=" + filters[i].value;
	}
	
	table_<%=wCodigo%>.destroy();
    
    var req = new XMLHttpRequest();
    req.open('GET', `js/script_PA_pend_tabla_data_js.asp?Anio=<%=wAnno%>&Unidad=<%=wId_Unidad%>&inicio=<%=inicio%>&fin=<%=fin%>&Empresa=<%=wEmpresa%>${cadena_filtros}`, false); 
    req.send(null);
    data = JSON.parse(req.responseText)
    tabla = $("#<%=wCodigo%>_tbody_table")
    tabla.empty()
	
	for(let i = 0;i<data.length;i++){
		tabla.append(`<tr>
								<td>${i+1}</td>
                                <td>${data[i].proyecto}</td>
                                <td>${data[i].descripcion}</td>
								<td>${data[i].codigo_jira}</td>
								<td>${data[i].fecha}</td>
								<td>${data[i].estado}</td>
								<td>${data[i].dias}</td>
                            </tr>`)
	}
	
	table_<%=wCodigo%> = $('#<%=wCodigo%>').DataTable( {
        scrollY:        "300px",
        scrollX:        true,
        scrollCollapse: true,
        paging:         true,  /*paginacion*/
        fixedColumns:   true,
		"bFilter": false,  /*filtro buscar */
     	"ordering": false, /*ordenar decendente  */
		"language": idioma_espanol, /*recupera la variable*/
		dom: 'Bfrtip',
        buttons: [
		
         
        ],
		
		
	columnDefs: [
            { width: '1%', targets: 0 }
        ],
        fixedColumns: true
		
		
		
		
		
		
		
		
		
    } );
	
}
</script>
  
