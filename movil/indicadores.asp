<%@ Language=VBScript %>
<!-- #INCLUDE FILE="../includes/Connection_inc.asp" -->

<%
  Server.ScriptTimeout = 360
  	Response.ContentType = "text/html"
	Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
	Response.CodePage = 65001
	Response.CharSet = "UTF-8"

    wEmpresa = Request("Empresa")
    wId_Unidad = Request("Id_Unidad")
	wId_Usuario = Request("Id_Usuario")
    wId_Home = Request("Id_home")
    wAnno = Request("Anno")

	'Consulta de las credenciales del usuario'
	Set wRsUser = Server.CreateObject("ADODB.recordset")
	wSQL = "SELECT "
	wSQL = wSQL + " USER_LOGIN, "
	wSQL = wSQL + " NAME,"
	wSQL = wSQL + " PASSWORD,"
	wSQL = wSQL + " fb_empleado_id"
	wSQL = wSQL + " FROM SC_USER "
	wSQL = wSQL + " Where SC_USER_ID = " & wId_Usuario
	wRsUser.Open wSQL, oConn
	wUser = wRsUser("USER_LOGIN")
	wPass = wRsUser("PASSWORD")
	wEmpleado = wRsUser("fb_empleado_id")
	wUsuario = wRsUser("NAME")
	

		
	wRsUser.Close

	'Consulta de la URL'
	Set wRsURL = Server.CreateObject("ADODB.recordset")
	wSQL = "SELECT "
	wSQL = wSQL + " VALUE"
	wSQL = wSQL + " FROM PM_PARAMETER"
	wSQL = wSQL + " Where CODE like 'URL_APP'"
	wRsURL.Open wSQL, oConn
	wURL_WS = wRsURL("VALUE")
	wRsURL.Close

    
    if wPlantilla = "" then wPlantilla = "DEFAULT"
	
	
	
	'Selecciona las Sedes
    Set oRsSedes = Server.CreateObject("ADODB.recordset")
	wSQL = " SELECT fb_uea_pe_id, nombre"
	wSQL = wSQL + " FROM fb_uea_pe"
	wSQL = wSQL + " WHERE is_deleted = 0"
	wSQL = wSQL + " ORDER BY nombre"
	
    oRsSedes.Open wSQL, oConn
	
    If wId_Unidad = "" Then
		wId_Unidad = oRsSedes("fb_uea_pe_id")
	End If

	'Lista de A�os'

	strSQL = "SELECT DISTINCT"
	strSQL = strSQL & " m.anno"
	strSQL = strSQL & " from ind_matriz_sede_ano msa"
	strSQL = strSQL & " inner join ind_matriz m on m.ind_matriz_id = msa.ind_matriz_id"
	strSQL = strSQL & " inner join ind_indicador i on i.ind_indicador_id = msa.ind_indicador_id "
	strSQL = strSQL & " inner join ind_frecuencia f on f.ind_frecuencia_id = i.ind_frecuencia_id "
	strSQL = strSQL & " inner join ind_matriz_sede_indicador msi on msi.ind_matriz_id = msa.ind_matriz_id and"
	strSQL = strSQL & " msi.fb_uea_pe_id = msa.fb_uea_pe_id and"
	strSQL = strSQL & " msi.ind_indicador_id = msa.ind_indicador_id"
	strSQL = strSQL & " WHERE"
	strSQL = strSQL & " i.is_deleted = 0 AND"
	strSQL = strSQL & " msa.is_deleted = 0 AND"
	strSQL = strSQL & " msa.fb_uea_pe_id = " & wId_Unidad
	strSQL = strSQL & " ORDER BY m.anno desc"
	
    Set oRsAnno = Server.CreateObject("ADODB.Recordset")
    oRsAnno.Open strSQL, oConn
    if oRsAnno.eof then
        wAnno = year(Now())
		wUltAnno = year(Now())
		'wError = "1"
        'Response.Write "<span align=center ><b>No hay Incidentes Ambientales para esta Unidad</b></span>"
        'Response.end
    else
        if wAnno = "" then wAnno = oRsAnno("Anno")
		wUltAnno = oRsAnno("Anno")
    end if 
	
	
	'Lista de Indicadores
	Set oRsIndicadores = Server.CreateObject("ADODB.recordset")
	wSQL = " SELECT DISTINCT"
	wSQL = wSQL + " c.orden as ord_cat,"
	wSQL = wSQL + " i.orden as ord_ind,"
	wSQL = wSQL + " c.nombre as categoria,"
	wSQL = wSQL + " i.ind_indicador_id,"
	wSQL = wSQL + " i.nombre as indicador,"
	wSQL = wSQL + " u.nombre as unidad"
	wSQL = wSQL + " from ind_matriz_sede_ano msa"
	wSQL = wSQL + " inner join ind_matriz m on m.ind_matriz_id = msa.ind_matriz_id"
	wSQL = wSQL + " inner join ind_indicador i on i.ind_indicador_id = msa.ind_indicador_id "
	wSQL = wSQL + " inner join ind_frecuencia f on f.ind_frecuencia_id = i.ind_frecuencia_id "
	wSQL = wSQL + " inner join ind_categoria c on c.ind_categoria_id = i.ind_categoria_id"
	wSQL = wSQL + " inner join ind_unidad_medida u on u.ind_unidad_medida_id = i.ind_unidad_medida_id"
	wSQL = wSQL + " inner join ind_matriz_sede_indicador msi on msi.ind_matriz_id = msa.ind_matriz_id and"
	wSQL = wSQL + " msi.fb_uea_pe_id = msa.fb_uea_pe_id and"
	wSQL = wSQL + " msi.ind_indicador_id = msa.ind_indicador_id	"
	wSQL = wSQL + " WHERE"
	wSQL = wSQL + " i.is_deleted = 0 AND"
	wSQL = wSQL + " msa.is_deleted = 0 AND"
	wSQL = wSQL + " msa.fb_uea_pe_id = " & wId_Unidad & " AND"
	wSQL = wSQL + " m.anno = " & wAnno
	wSQL = wSQL + " ORDER BY c.orden, i.orden"
	
    oRsIndicadores.Open wSQL, oConn
	
	FlagDataInd = 0
	If Not oRsIndicadores.eof Then
		FlagDataInd = 1
	End If

%>

<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<head>
	<meta charset="utf-8" />
	<title>eco2biz | Tablas</title>
	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
	<link rel="icon" href="assets/img/favicon.ico" type="image/x-icon">
	<meta content="" name="description" />
	<meta content="" name="author" />
	
	<!-- ================== BEGIN BASE CSS STYLE ================== -->
	<link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet">
	<link href="assets/plugins/jquery-ui/themes/base/minified/jquery-ui.min.css" rel="stylesheet" />
	<link href="assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
	<link href="assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
	<link href="assets/css/animate.min.css" rel="stylesheet" />
	<link href="assets/css/style.min.css" rel="stylesheet" />
	<link href="assets/css/style-responsive.min.css" rel="stylesheet" />
	<link href="assets/css/theme/default.css" rel="stylesheet" id="theme" />
	<!-- ================== END BASE CSS STYLE ================== -->
	
	<!-- ================== BEGIN BASE JS ================== -->
	<script src="assets/plugins/pace/pace.min.js"></script>
	<!-- ================== END BASE JS ================== -->
	
	<!-- ================== BEGIN BASE JS ================== -->
	<script src="assets/plugins/jquery/jquery-1.9.1.min.js"></script>
	<script src="assets/plugins/jquery/jquery-migrate-1.1.0.min.js"></script>
	<script src="assets/plugins/jquery-ui/ui/minified/jquery-ui.min.js"></script>
	<script src="assets/plugins/bootstrap/js/bootstrap.min.js"></script>
	<!--[if lt IE 9]>
		<script src="assets/crossbrowserjs/html5shiv.js"></script>
		<script src="assets/crossbrowserjs/respond.min.js"></script>
		<script src="assets/crossbrowserjs/excanvas.min.js"></script>
	<![endif]-->
	<script src="assets/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script src="assets/plugins/jquery-cookie/jquery.cookie.js"></script>
	<!-- ================== END BASE JS ================== -->
	
	<!-- ================== BEGIN PAGE LEVEL JS ================== -->
	<script src="assets/js/apps.min.js"></script>
	<!-- ================== END PAGE LEVEL JS ================== -->
	
	<script src="../HighCharts_6_7/highcharts.js"></script>
	<script src="../HighCharts_6_7/modules/no-data-to-display.js"></script>
	<script src="../HighCharts_6_7/modules/exporting.js"></script>
	<script src="../HighCharts_6_7/js/modules/pareto.js"></script>
	<script src="assets/plugins/sparkline/jquery.sparkline.js"></script>
    <script  src="js/wait_indicator.js"></script>
</head>

<script>
    function ActualizaFormulario() {
        document.body.style.cursor = 'wait';
        document.getElementById("frm_Home").submit();
    }
</script>

<body>
	<!-- begin #page-loader -->
	<div id="page-loader" class="fade in"><span class="spinner"></span></div>
	<!-- end #page-loader -->
	
	<!-- begin #page-container -->
	<div id="page-container" class="fade page-sidebar-fixed page-header-fixed">
		<!-- begin #header -->
		<div id="header" class="header navbar navbar-default navbar-fixed-top">
			<!-- begin container-fluid -->
			<div class="container-fluid">
				<!-- begin mobile sidebar expand / collapse button -->
				<div class="navbar-header">
					<a href="index.html" class="xnavbar-brand">
					<a href="index.html"><img src="assets/img/logo2.png" alt=""></a>
					<button type="button" class="navbar-toggle" data-click="sidebar-toggled">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
				</div>
				<!-- end mobile sidebar expand / collapse button -->
				
				<!-- begin header navigation right -->
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown navbar-user">
						<span style="font-size:90%;"><%=wUsuario%></span>
					</li>
				</ul>
				<!-- end header navigation right -->
			</div>
			<!-- end container-fluid -->
		</div>
		<!-- end #header -->
		
		<!-- begin #sidebar -->
		<div id="sidebar" class="sidebar">
			<!-- begin sidebar scrollbar -->
			<div data-scrollbar="true" data-height="100%">
				<!-- begin sidebar user -->
				<ul class="nav">
					
				</ul>
				<!-- end sidebar user -->
				<!-- begin sidebar nav -->
				<ul class="nav">
					<li class="has-sub">
						<a href="#">
						    <b class="xcaret pull-right"></b>
						    <i class="fa fa-copyright"></i>
						    <span>eco2biz</span>
					    </a>
					</li>
				<li class="active"><a href="#"><i class="fa fa-file-o"></i> <span>Indicadores</span></a></li>
				<li class=""><a href="index.asp?Empresa=<%=wEmpresa%>&Id_Usuario=<%=wId_Usuario%>&Id_home=19"><i class="fa fa-bar-chart"></i> <span>Gráficos</span></a></li>
	
			        <!-- begin sidebar minify button -->
					<li><a href="javascript:;" class="sidebar-minify-btn" data-click="sidebar-minify"><i class="fa fa-angle-double-left"></i></a></li>
			        <!-- end sidebar minify button -->
				</ul>
				<!-- end sidebar nav -->
			</div>
			<!-- end sidebar scrollbar -->
		</div>
		<div class="sidebar-bg"></div>
		<!-- end #sidebar -->
		
		<!-- begin #content -->
		<div id="content" class="content">
			<!-- begin breadcrumb -->
			<!-- end breadcrumb -->
			<!-- begin page-header -->
			<h1 class="page-header">Indicadores</h1>
			<!-- end page-header -->
			
			   <div class="panel panel-inverse bg" style="background-color:#3b93ab" data-sortable-id="table-basic-5">
                        <div class="panel-body">
                            
							<form id="frm_Home" method="post" action="indicadores.asp">
								<input type="hidden" name="Empresa" value="<%=wEmpresa%>" />
								<input type="hidden" name="Id_Usuario" value="<%=wId_Usuario%>" />
							
								<div class="row">
									<div class="col-md-6">
											<div class="form-group">
												<label for="exampleFormControlSelect1" class="text-white">Sede :</label>
												<%
													'RCombo de sede
													Response.write "<select name='Id_Unidad' id='Id_Unidad' class='form-control' onchange='ActualizaFormulario()'>"
													While not oRsSedes.EOF
														' Esta validación sirve para que el valor seleccionado del combo se quede estático
														' CDBL convierte varchar a numeric
														If cdbl(wId_Unidad) = cdbl(oRsSedes("fb_uea_pe_id")) Then
															wselected = "selected"
														Else
															wselected = ""
														End If
													
														Response.Write "<option value='" & oRsSedes("fb_uea_pe_id") & "' " & wselected & "> " & oRsSedes("nombre") & "</option>"
															
														oRsSedes.MoveNext()
													Wend
													Response.write "</select>"
												%>
											</div>
											
											
									   
									</div>
									
									<div class="col-md-6">
												   <div class="form-group">
												<label for="exampleFormControlSelect1" class="text-white">Año :</label>
												<%
													'Render them in drop down box A�o
													Response.write "<select name='Anno' id='Anno' class='form-control' onchange='ActualizaFormulario()'>"
													While not oRsAnno.EOF
														if cdbl(wAnno) = cdbl(oRsAnno("Anno")) then
															if cdbl(orsAnno("Anno")) = 0 then
																Response.Write "<option value='" & orsAnno("Anno") & "' selected> TODOS </option>"
															else
																Response.Write "<option value='" & orsAnno("Anno") & "' selected> " & orsAnno("Anno") & "</option>"
															end if
														else
															if cdbl(orsAnno("Anno")) = 0 then
																Response.Write "<option value='" & orsAnno("Anno") & "'> TODOS </option>"
															else
																Response.Write "<option value='" & orsAnno("Anno") & "'>" & orsAnno("Anno") & " </option>"
															end if
														end if
														oRsAnno.MoveNext()
													Wend
													Response.write "</select>"
												%>
											</div>
									</div>
									
								</div>
							</form>
                    </div>
                    <!-- end panel -->

			       
			    </div>
			
			<!-- begin row -->
			<div class="row">
			   
			    <!-- end col-6 -->
			    <!-- begin col-6 -->
			    <div class="col-md-12">
			       
			        <!-- begin panel -->
                    <div class="panel panel-inverse" data-sortable-id="table-basic-5">
                        <div class="panel-heading">
                            <div class="panel-heading-btn">
                                <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-default" data-click="panel-expand"><i class="fa fa-expand"></i></a>
                                <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-success" data-click="panel-reload"><i class="fa fa-repeat"></i></a>
                                <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-warning" data-click="panel-collapse"><i class="fa fa-minus"></i></a>
                            </div>
                            <h4 class="panel-title">Indicadores</h4>
                        </div>
                        <div class="panel-body">
							<table class="table table-bordered">
							  <%
								if FlagDataInd = 1 Then
									oRsIndicadores.MoveFirst
								End If
								If Not oRsIndicadores.Eof Then
								  wIndicadorAct = ""
								  Do While Not oRsIndicadores.Eof
									If wIndicadorAct <> oRsIndicadores("categoria") Then
							  %>
									<colgroup span="2"></colgroup>
									<th colspan=2 style="background-color:#D3D3D3;"><%=oRsIndicadores("categoria")%></th>
							  <%  
								  End If 
							  %>
									<tr>
										<td><a href="monitoreo.asp?Empresa=<%=wEmpresa%>&Id_Usuario=<%=wId_Usuario%>&Id_Unidad=<%=wId_Unidad%>&Indicador=<%=oRsIndicadores("ind_indicador_id")%>&Anno=<%=wAnno%>"><%=oRsIndicadores("indicador")%></a></td>
										<td><div id="sparkline_<%=oRsIndicadores("ind_indicador_id")%>"></div></td>
									</tr>
							  <%
								  
								  wIndicadorAct = oRsIndicadores("categoria")
								  oRsIndicadores.MoveNext
								 Loop
								End If
							  %>
                        </div>
                    </div>
                    <!-- end panel -->
			       
			    </div>
			    <!-- end col-6 -->
			</div>
			<!-- end row -->
			<!-- begin row -->
			
		</div>
		<!-- end #content -->
		
		<!-- begin scroll to top btn -->
		<a href="javascript:;" class="btn btn-icon btn-circle btn-success btn-scroll-to-top fade" data-click="scroll-top"><i class="fa fa-angle-up"></i></a>
		<!-- end scroll to top btn -->
	</div>
	<!-- end page container -->
	
	
	<script>
		$(document).ready(function() {
			App.init();
			
			<% 
				If FlagDataInd = 1 Then
					oRsIndicadores.MoveFirst
				End If
				Do While Not oRsIndicadores.Eof
			%>
			
				$.ajax({
					url: "js/script_IND_indicador_matriz_sparkline_data_js.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wId_Unidad%>&Id_Usuario=<%=wId_Usuario%>&Anno=<%=wAnno%>&Indicador=<%=oRsIndicadores("ind_indicador_id")%>",
					type: "POST",
					dataType: "json",
					success:function(jdata){
						var values = jdata;
						$('#sparkline_<%=oRsIndicadores("ind_indicador_id")%>').sparkline(values, {
							type: "bar",
							tooltipSuffix: " <%=oRsIndicadores("unidad")%>"
						});
					},
					error: function(jqXHR, textStatus, errorThrown) {
						console.log(jqXHR);
						console.log(textStatus);
						console.log(errorThrown);
					},
				});
			
			<%
					oRsIndicadores.MoveNext
				Loop
			%>     
		 
		});
	</script>
</body>
</html>
