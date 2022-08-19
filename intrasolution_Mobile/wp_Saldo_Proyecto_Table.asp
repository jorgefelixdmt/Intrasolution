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
    wTipo =  2 '-- EFLUENTE
            
	wSQL = "pr_fnz_proyecto_saldo_graf " '& wAnno

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
                <th>Cliente</th>
                <th>Proyecto</th>
                <th>Moneda Factura</th>
                <th>Monto Proyecto US$</th>
                <th>Monto Facturado US$</th>
                <th>Saldo US$</th>
                <th>Estado</th>
            </tr>
        </thead>
        <tbody>
            <%  i = 1
            Do While Not wRsVentas.Eof
                If wRsVentas("saldo_dolares")=0 then valorDol = 0 else valorDol = wRsVentas("saldo_dolares") End If
                If wRsVentas("monto_proyecto_dolares")=0 then valorProy = 0 else valorProy = wRsVentas("monto_proyecto_dolares") End If
                If wRsVentas("monto_facturado_dolares")=0 then valorFact = 0 else valorFact = wRsVentas("monto_facturado_dolares") End If
                %>
                    <tr>
        	            <td class="text-center"><%=i%></th>
						<td><%=wRsVentas("cliente")%></td>
			            <td><%=wRsVentas("proyecto")%></td>
			            <td><%=wRsVentas("moneda")%></td>
			            <td><%=valorProy%></td>
			            <td><%=valorFact%></td>
						<td><%=valorDol%></td>
			            <td><%=wRsVentas("estado")%></td>
		            </tr>
          <%   
            i = i + 1 
              wRsVentas.MoveNext
            Loop%>     
        </tbody>
		<tfoot>
            <tr>
                <th colspan="6">Total:</th>
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
                .column( 6 )
                .data()
                .reduce( function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0 );
 
            // Update footer
            $( api.column( 6 ).footer() ).html(
                'US$ ' + total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
            );
        }
		
    } );
} );
</script>

            