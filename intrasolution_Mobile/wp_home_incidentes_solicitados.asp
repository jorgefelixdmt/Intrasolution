<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="../Includes/f_ValidaURL.asp" -->
<%
    Server.ScriptTimeout = 360
    
    wEmpresa = Session("Empresa")
	wId_Unidad = Session("Id_Unidad")
	wId_Usuario = Session("Id_Usuario")
    wAnno = Session("Anno")    
    wTipoInc = Session("Tipo_Incidencia")
    wAmbito = Session("Ambito")
    
	
	wSQL = "pr_inc_info_incidentes_solicitados " & wId_Usuario & "," & wTipoInc  
	
	Set wRsHome_Inc = Server.CreateObject("ADODB.recordset")
    wRsHome_Inc.CursorLocation = 3
    wRsHome_Inc.CursorType = 2
    wRsHome_Inc.Open wSQL, oConn,1,1
	
	
	WTotal = wRsHome_Inc("total")
	wInternos = wRsHome_Inc("internos")
	wExternos = wRsHome_Inc("externos")
	
	if cdbl(wRsHome_Inc("cliente_id")) <> 0 then
		WTotal = wExternos
	end if
	
	'wTrabajadores = wRsHome_Trabajadores("total_trabajadores")
	'wHoras = wRsHome_Trabajadores("total_horas")
	'wContratistas = wRsHome_Contratistas("contratistas")
    'wTContratistas = wRsHome_Contratistas("trabajadores_contratistas")  
	
%>
<!-- CUADRO TRABAJADORES -->

		 <!-- top tiles -->
		<div class="info-box-body text-muted">
			  <div class="info-box-subtitle"><%=WTotal%></div>	
			  <div class="txt-white">Pendientes de Atención</div>
			 <% if cdbl(wRsHome_Inc("cliente_id")) = 0 then %>
			  <div class="ft-1 mdl-color-text--grey-300 texto"><%=wInternos%> Incidentes Internos</div>
			  <div class="ft-1 mdl-color-text--grey-300 texto"><%=wExternos%> Incidentes Externos</div>
			 <% end if %>
		</div>
		 
          <!-- /top tiles -->
		
			
		<!--
			<div class="count"><%=wTrabajadores%></div>
			<font size="3px">Trabajadores</font>
			<br>
			<font size="3px"><b><%=wContratistas%></b> Empresas Contratistas</font>
			<br>
			<font size="3px"><b><%=wTContratistas%></b> Trabajadores Contratistas</font>
			<br>
			<font size="3px"><b><%=wHoras%></b> Horas Trabajadas</font>
			
			
          <div class="row tile_count">
            <div class="col-md-12 col-sm-12 col-xs-12 tile_stats_count">
              <span class="count_top"><i class="fa fa-user"></i> Total Users</span>
              <div class="count">2500</div>
              <span class="count_bottom"><i class="red">4% </i> From last Week</span>
            </div>
           
          </div>
		-->
  
  
 <style>
.text-principal {
   line-height: 25px;
   font-size: 9.5vh;
   font-weight: bold;
   color:#5c5f61
}

.label-principal {
   line-height: 30px;
   font-size: 3vh;
   font-weight: bold;
   color:#5c5f61
}

.label-secundario {
   line-height: 10px;
   font-size: 2vh;
   color:#5c5f61
}
</style>
		
	
<%
   wRsHome_Inc.Close
    Set wRsHome_Inc = Nothing 
  %>