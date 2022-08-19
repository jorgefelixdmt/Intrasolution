<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="../Includes/f_ValidaURL.asp" -->

<%
 
' ******************************************************************************************************************************************************
' Nombre: wp_CV_control_diario_covid.asp
' Fecha Creación: ---
' Autor: Valky Salinas
' Descripción: ASP que genera una tabla de control diario de COVID.
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
            
	wSQL = "pr_cv_control_covid_diario_tabla " & wId_Unidad & "," & wAnno

    Set wRsCOVID = Server.CreateObject("ADODB.recordset")
    wRsCOVID.CursorLocation = 3
    wRsCOVID.CursorType = 2
    wRsCOVID.Open wSQL, oConn,1,1

	numCol = 0
        
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
        
        <div class="panel-body" style="width:100%; overflow-y:hidden;">
	 <div>
	<table id="<%=wCodigo%>" class="table-striped table-bordered nowrap" style="width:100%">
        <thead>
            <tr>
				<th rowspan="2"></th>
				
				<th colspan="3">Control Diario COVID</th>
			</tr>
			<tr>
			<% If Not wRsCOVID.Eof Then 
				i = 0
				For Each fld In wRsCOVID.Fields 
				  if i > 0 then
			%>
                <th><%=fld.name%></th>
			<%    
					numCol = numCol + 1
				  end if
				  i = i + 1
				Next 
			%>
                <th>TOTAL</th>
			<% Else %>
                <th>Acceso Libre</th>
                <th>Restringir Acceso</th>
                <th>TOTAL</th>
			<% End If %>
            </tr>
        </thead>
        <tbody>
          <% 
			 Dim TotalC()
			 Redim TotalC(numCol)
			
			 For i = 0 to (numCol - 1) Step 1
				TotalC(i) = 0
			 Next
			 
			 wEmpty = 0
			 If wRsCOVID.Eof Then
				wEmpty = 1
			 End If
			 
			 Do While Not wRsCOVID.Eof
				wTotalF = 0
				wTotalT = 0
				
				j = 0
		  %>
                    <tr>
			            <td><b><%=wRsCOVID("rol")%></b></td>
					 <% 
						For Each fld In wRsCOVID.Fields
						  if j > 0 then
							  wValor = 0
							  if Not(IsNull(fld.value)) then
								wValor = cdbl(fld.value)
							  end if
							  TotalC(j-1) = TotalC(j-1) + wValor
							  wTotalF = wTotalF + wValor
					 %>
						<td class="text-center"><%=wValor%></td>
					 <% 
						  end if
						  j = j + 1
						Next 
					 %>
						<td class="text-center"><%=wTotalF%></td>
		            </tr>
          <%  	wRsCOVID.MoveNext
             Loop 
		  %>
		</tbody>
		<% if wEmpty = 0 then %>
		<tfoot>
					<tr>
						<td><b>TOTAL</b></td>
		  <% 
				For i = 0 to (numCol - 1) Step 1
					wTotalT = wTotalT + TotalC(i)
		  %>
						<td class="text-center"><%=TotalC(i)%></td>
		  <% 	Next %> 
						<td class="text-center"><%=wTotalT%></td>
					</tr>
					
					<tr>
						<td></td>
				    <% For i = 0 to (numCol - 1) Step 1 %>
						<td class="text-center"><%=Round(TotalC(i)*100/wTotalT,1)%>%</td>
				    <% Next %>
						<td></td>
					</tr>
		<% end if %>
        </tfoot>
    </table>
 </div>
</div>

<%
   wRsCOVID.Close
    Set wRsCOVID = Nothing 
%>				
 	

        
           <script>
$(document).ready(function() {
    var table = $('#<%=wCodigo%>').DataTable( {
        scrollY:        "210px",
        scrollX:        true,
        scrollCollapse: true,
        paging:         false,  /*paginacion*/
        fixedColumns:   true,
		"info": false,
		"bFilter": false,  /*filtro buscar */
     	"ordering": false, /*ordenar decendente  */
		"language": idioma_espanol, /*recupera la variable*/
		dom: 'Bfrtip',
        buttons: [
				{
					extend: "copy",
					footer: true,
					className: "btn btn-primary btn-xs",
					titleAttr: 'Copiar',
					text: 'Copiar',
					init: function(api, node, config) {
					   $(node).removeClass('dt-button buttons-copy buttons-html5')
					}	
				},
				{
					extend: "csv",
					footer: true,
					className: "btn btn-info btn-xs",
					titleAttr: 'csv',
					text: 'csv',
					init: function(api, node, config) {
					   $(node).removeClass('dt-button buttons-copy buttons-html5')
					}	
				},
				{
					extend: "excel",
					footer: true,
					className: "btn btn-warning btn-xs",
					titleAttr: 'Excel',
					text: 'Excel',
					init: function(api, node, config) {
					   $(node).removeClass('dt-button buttons-copy buttons-html5')
					}	
				},
				{
					extend: "pdf",
					footer: true,
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
} );
</script>

            