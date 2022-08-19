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
    wTipo =  2 '-- EFLUENTE
            
	wSQL = "pr_ws_incidencia_vigencia " & wId_Usuario

    Set wRsIncidencias = Server.CreateObject("ADODB.recordset")
    wRsIncidencias.CursorLocation = 3
    wRsIncidencias.CursorType = 2
    
    wRsIncidencias.Open wSQL, oConn,1,1

        
%>

<!-- TAREAS PENDIENTES -->

        
    <div class="panel-body" style="width:100%">
	 <div class="table-responsive">
	<table id="<%=wCodigo%>" class="table table-striped table-bordered wrap">
        <thead>
            <tr>
                <th>N°</th>
                <th>Código</th>
                <th>Color</th>
                <th>Incidente</th>
                <th>Fecha</th>
            </tr>
        </thead>
        <tbody>
            <%  i = 1
            Do While Not wRsIncidencias.Eof%>
                    <tr>
        	            <td class="text-center"><%=i%></th>
			            <td><%=wRsIncidencias("codigo")%></td>
                         <td><%=wRsIncidencias("color")%></td>
						<td><%=wRsIncidencias("titulo")%></td>
			            <td class="text-center"><%=wRsIncidencias("fecha")%></td>
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
 