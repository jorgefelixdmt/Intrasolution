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
            
	wSQL = "pr_pry_proy_vigentes " & wId_Usuario

    Set wRsProyectos = Server.CreateObject("ADODB.recordset")
    wRsProyectos.CursorLocation = 3
    wRsProyectos.CursorType = 2
    wRsProyectos.Open wSQL, oConn,1,1

        
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
	<table id="<%=wCodigo%>" class="table table-striped table-bordered no-wrap">
        <thead>
            <tr>
                <th>Item</th>
                <th>Proyecto</th>
                <th>Inicio</th>
                <th>Fin</th>
            </tr>
        </thead>
        <tbody>
            <%  i = 1
            Do While Not wRsProyectos.Eof%>
                    <tr>
        	            <td class="text-center"><%=i%></th>
			            <td><%=wRsProyectos("proyecto")%></td>
						<td><%=wRsProyectos("fecha_ini")%></td>
			            <td><%=wRsProyectos("fecha_fin")%></td>
		            </tr>
          <%  i = i + 1 
              wRsProyectos.MoveNext
            Loop%>     
        </tbody>
    </table>
 </div>
</div>

<%
   wRsProyectos.Close
    Set wRsProyectos = Nothing 
%>	     