<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="../Includes/f_ValidaURL.asp" -->
<%
    Server.ScriptTimeout = 360
    
  wEmpresa = Session("Empresa")
	wId_Unidad = Session("Id_Unidad")
	wId_Usuario = Session("Id_Usuario")
  wAnno = Session("Anno") 
  wCodigo = Session("Codigo")
    
	
	wSQL = " pr_graf_inc_calendario_empleado_combo " & wId_Usuario 
	
	Set wRsGer = Server.CreateObject("ADODB.recordset")
    wRsGer.CursorLocation = 3
    wRsGer.CursorType = 2
    wRsGer.Open wSQL, oConn,1,1
	
%>
<!-- CUADRO TRABAJADORES -->

	<!-- top tiles -->
		
		<div class="container">
		   <div class="row">
			  <div class="col-md-8">
				 <form  class="form-horizontal">
					<fieldset>
					   <div class="form-group">
						  <div class="col-md-12">
							 <label class="control-label text-left text-black col-md-2" for="Gerencia_<%=wCodigo%>">Responsable:</label>
							 <div class="input-group">
								<%
									'Render them in drop down box Residuo
									Response.write "<select name='empleado_" & wCodigo & "' id='empleado_" & wCodigo & "' class='form-control' onchange='update_" & wCodigo & "()'>"
									  Response.Write "<option value='0'>--Todos los Responsable-- </option>"
                  While not wRsGer.EOF
										Response.Write "<option value='" & wRsGer("id") & "'>" & wRsGer("empleado") & " </option>"
										wRsGer.MoveNext()
									Wend
									Response.write "</select>"
								%>
							 </div>
						  </div>
					   </div>
					</fieldset>
				 </form>
			  </div>
		   </div>
		</div>
		
		   		
		<div id="canvas_<%=wCodigo%>"></div>
		
<!--Formulario de evento nuevo-->
<div class="modal fade bd-example-modal-lg" id="modalNuevo" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Nuevo evento</h4>
      </div>
      <div class="modal-body">
        <form>
     
        <!--Responsable veriicador -->
          <div class="form-group">
            <label class="my-1 mr-2" for="inlineFormCustomSelectPref">Responsable verificador</label>
            <select class="form-control col-sm-12" id="newResponsable">
              <option  selected>Seleccionar...</option>
            </select>
          </div>
          <!--Fecha del evento-->
          <div class="form-group" id="div-inicio">
            <label for="fechaStart" class="my-1 mr-2">Inicio</label>
            <input type="date" class="form-control col-sm-12" id="newFechaStart">
          </div>
		 
            <button type="button" class="btn btn-danger" data-dismiss="modal">Cerrar</button>
            <button type="button" class="btn btn-primary  bg-success text-white" onclick="Agregar_<%=wCodigo%>()">Guardar</button>
          </div>
        </form>	
      </div>
      
    </div>
  </div>
</div>
<!--Fin modal nuevo-->
<!--Formulario de evento editar-->
<div class="modal fade bd-example-modal-lg" id="modalEditar" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header p-3 mb-2 bg-success text-white">
        <h5 class="modal-title" id="exampleModalLongTitle">Editar Evento</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form>
        <input type="text" class="form-control col-sm-12" id="id" style="display:none">
        <!--Codigo-->
          <div class="form-group" id="div-inicio">
            <label for="codigo" class="my-1 mr-2">Codigo</label>
            <input type="text" class="form-control col-sm-12" id="codigo" disabled>
          </div>
          <!--estado-->
          <div class="form-group" id="div-inicio">
            <label for="codigo" class="my-1 mr-2">Estado</label>
            <input type="text" class="form-control col-sm-12" id="estado" disabled>
          </div>
        <!--gerencia -->
          <div class="form-group">
            <label class="my-1 mr-2" for="inlineFormCustomSelectPref">Gerencia</label>
            <select class="form-control col-sm-12" id="EditGerencia">
              <option selected>Seleccionar...</option>
            </select>
          </div>
        <!--Responsable verificador -->
          <div class="form-group">
            <label class="my-1 mr-2" for="inlineFormCustomSelectPref">Responsable verificador</label>
            <select class="form-control col-sm-12" id="EditResponsable">
              <option selected>Seleccionar...</option>
            </select>
          </div>
          <!--Fecha del evento-->
          <div class="form-group" id="div-inicio">
            <label for="fechaStart" class="my-1 mr-2">Inicio</label>
            <input type="date" class="form-control col-sm-12" id="editStart">
          </div>
		  <br>
            <a class="btn btn-secondary" data-dismiss="modal">Cerrar</a>
            <a class="btn btn-success  bg-success text-white" onclick="Editar_<%=wCodigo%>()">Guardar</a>
            <a type="button" class="btn btn-danger  bg-danger text-white" onclick="Eliminar_<%=wCodigo%>()">Eliminar</a>
          </div>
        </form>
      </div>
      
    </div>
  </div>
</div>
<!--Fin modal editar-->
<!--Fin modal editar-->
	<style>
	.fc-head-container{
		padding: 0px !important;
	}
	.fc-widget-header{
		padding: 3px 0px!important;
	}
	.form-group{
		display: flow-root;
	}
  .fc-day-grid-container{
    overflow: hidden !important;
  }
  .popper, .tooltip{
    background: #3a92ab !important;
  }
  .tooltip-inner{
    width: 100%;
    display: inline-grid;
  }
  #cabecera-anio{
    display:none
  }
  h2::first-letter {
    text-transform: uppercase;
  }
	</style>
<%
	wRsGer.Close
    Set wRsGer = Nothing 
  %>
  
  
