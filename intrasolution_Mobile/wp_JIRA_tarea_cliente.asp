<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="../Includes/f_ValidaURL.asp" -->
<%
    Server.ScriptTimeout = 360
    
  wEmpresa = Session("Empresa")
	wId_Unidad = Session("Id_Unidad")
	wId_Usuario = Session("Id_Usuario")
  wAnno = Session("Anno") 
  wCodigo = Session("Codigo")
    
	
	wSQL = "SELECT fb_cliente_id, nombre FROM fb_cliente WHERE is_deleted = 0"
	
	Set wRsCliente = Server.CreateObject("ADODB.recordset")
    wRsCliente.CursorLocation = 3
    wRsCliente.CursorType = 2
    wRsCliente.Open wSQL, oConn,1,1
	
%>
<!-- CUADRO TRABAJADORES -->

	<!-- top tiles -->
	
	
	<div id="formularios_<%=wCodigo%>" class="ocultar_formulario"> 

                        
                        <div class="form-group col-md-6">
                            <form class="form-horizontal ">
								 <div class="form-group">
                                    <label class="col-md-4 control-label">Cliente:</label>
                                    <div class="col-md-8">
                                        <%
											'Render them in drop down box Residuo
											Response.write "<select name='cliente_" & wCodigo & "' id='Cliente_" & wCodigo & "' class='form-control' onchange='update_" & wCodigo & "()'>"
											While not wRsCliente.EOF
												Response.Write "<option value='" & wRsCliente("fb_cliente_id") & "'>" & wRsCliente("nombre") & " </option>"
												wRsCliente.MoveNext()
											Wend
											Response.write "</select>"
										%>
                                    </div>
                                </div>
                            </form>
                        </div>
						
						
						<div class="form-group col-md-6">
                            <form class="form-horizontal ">
								 <div class="form-group">
                                    <label class="col-md-4 control-label">Estado:</label>
                                    <div class="col-md-8">
                                        <select name='estado_<%=wCodigo%>' id='Estado_<%=wCodigo%>' class='form-control input-sm' onchange='update_<%=wCodigo%>()'>
											<option value='1'>ABIERTO</option>
											<option value='3'>EN PROGRESO</option>
											<option value='2'>CERRADO</option>
											<option value='4'>PENDIENTES (ABIERTO + INICIADO)</option>
											<option value='0'>TODOS</option>
										</select>
                                    </div>
                                </div>
                            </form>
                        </div>

		</div>
		
		
		   		
		<div id="canvas_<%=wCodigo%>"></div>
		

<%
	wRsCliente.Close
    Set wRsCliente = Nothing 
  %>
  
  
