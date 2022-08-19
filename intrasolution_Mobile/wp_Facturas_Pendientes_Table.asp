<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="../Includes/f_ValidaURL.asp" -->

<%
 
' ******************************************************************************************************************************************************
' Nombre: wp_Facturas_Pendientes_Table.asp
' Fecha Creación: 05/23/2020
' Autor: Valky Salinas
' Descripción: ASP que genera una tabla de facturas pendientes.
' Usado por: Home Principal.
' 
' ******************************************************************************************************************************************************
' RESUMEN DE CAMBIOS
' Fecha(dd-mm-aaaa)         Autor                      Comentarios      
' --------------------      ---------------------      -----------------------------------------------------------------------------------------------
' 12/11/2021                Valky Salinas              Se formateó la sumatoria a redondeo con 2 decimales.
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
    wTipo =  2 '-- EFLUENTE
            
	wSQL = "pr_fnz_lista_facturas_pendientes " & wAnno

    Set wRsVentas = Server.CreateObject("ADODB.recordset")
    wRsVentas.CursorLocation = 3
    wRsVentas.CursorType = 2
    wRsVentas.Open wSQL, oConn,1,1

        
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
	<table id="<%=wCodigo%>" class="table table-striped table-bordered nowrap" style="width:100%">
        <thead>
            <tr>
                <th>Item</th>
                <th># Factura</th>
                <th>Cliente</th>
                <th>Proyecto</th>
                <th>Fecha</th>
                <th>Glosa</th>
                <th>Moneda Factura</th>
                <th>Monto US$</th>
                <th>Días Atraso</th>
            </tr>
        </thead>
        <tbody>
            <%  i = 1
            Do While Not wRsVentas.Eof%>
                    <tr>
        	            <td class="text-center"><%=i%></th>
						<td><%=wRsVentas("numero_factura")%></td>
						<td><%=wRsVentas("cliente")%></td>
			            <td><%=wRsVentas("proyecto")%></td>
			            <td class="text-center"><%=wRsVentas("fecha")%></td>
			            <td><%=wRsVentas("concepto_factura")%></td>
			            <td><%=wRsVentas("moneda")%></td>
						<td class="text-center"><%=wRsVentas("monto")%></td>
			            <td class="text-center"><%=Round(wRsVentas("dias"),2)%></td>
		            </tr>
          <%  i = i + 1 
              wRsVentas.MoveNext
            Loop%>     
        </tbody>
		<tfoot>
            <tr>
                <th colspan="7">Total:</th>
                <th colspan="2"></th>
            </tr>
        </tfoot>
    </table>
 </div>
</div>

<%
   wRsVentas.Close
    Set wRsVentas = Nothing 
%>				
 	

        
           <script>
$(document).ready(function() {
	
    var table = $('#<%=wCodigo%>').DataTable( {
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
		
         
        ],
		
		
	columnDefs: [
            { width: '1%', targets: 0 }
        ],
        fixedColumns: true,
		
		
		
	"footerCallback": function ( row, data, start, end, display ) {
            var api = this.api(), data;
 
            // Remove the formatting to get integer data for summation
            var intVal = function ( i ) {
                return typeof i === 'string' ?
                    i.replace(/[\$,]/g, '')*1 :
                    typeof i === 'number' ?
                        i : 0;
            };
 
            // Total over all pages
            total = api
                .column( 7 )
                .data()
                .reduce( function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0 );
 
            // Update footer
            $( api.column( 7 ).footer() ).html(
                'US$ ' + (Math.round(total*100)/100).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
            );
        }	
		
		
		
		
		
    } );
} );
</script>

            