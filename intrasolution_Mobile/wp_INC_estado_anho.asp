<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="../Includes/f_ValidaURL.asp" -->
<%
    Server.ScriptTimeout = 360
    
  wEmpresa = Session("Empresa")
	wId_Unidad = Session("Id_Unidad")
	wId_Usuario = Session("Id_Usuario")
  wAnno = Session("Anno") 
  wCodigo = Session("Codigo")
    
	
	wSQL = "SELECT DISTINCT YEAR(fecha) anho FROM inc_incidencia WHERE is_deleted = 0"
	
	Set wRsAnho = Server.CreateObject("ADODB.recordset")
	wRsAnho.Open wSQL, oConn
	
%>
<!-- CUADRO TRABAJADORES -->

	<div id="formularios_<%=wCodigo%>" class="ocultar_formulario"> 

                        
                        <div class="form-group col-md-6">
                            <form class="form-horizontal ">
								 <div class="form-group">
                                    <label class="col-md-4 control-label">Año:</label>
                                    <div class="col-md-8">
                                        <%
											'Render them in drop down box Residuo
											Response.write "<select name='Anho_" & wCodigo & "' id='Anho_" & wCodigo & "' class='form-control' onchange='update_" & wCodigo & "()'>"
											Response.Write "<option value='0'>TODOS</option>"
											While not wRsAnho.EOF
												Response.Write "<option value='" & wRsAnho("anho") & "'>" & wRsAnho("anho") & " </option>"
												wRsAnho.MoveNext()
											Wend
											Response.write "</select>"
										%>
                                    </div>
                                </div>
                            </form>
                        </div>
		</div>

	
		   		
		<div id="canvas_<%=wCodigo%>"></div>
		

<%
	wRsAnho.Close
    Set wRsAnho = Nothing 
  %>
  
  
