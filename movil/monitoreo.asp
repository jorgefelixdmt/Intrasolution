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
    wIndicador = Request("Indicador")

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
	
	'Consulta de datos generales
	Set wRsSede = Server.CreateObject("ADODB.recordset")
	wSQL = "SELECT nombre FROM fb_uea_pe WHERE fb_uea_pe_id = " & wId_Unidad
	wRsSede.Open wSQL, oConn
	wSede = wRsSede("nombre")
	wRsSede.Close
	
	Set wRsInd = Server.CreateObject("ADODB.recordset")
	wSQL = "SELECT nombre FROM ind_indicador WHERE ind_indicador_id = " & wIndicador
	wRsInd.Open wSQL, oConn
	wInd = wRsInd("nombre")
	wRsInd.Close
	
	Set wRsCat = Server.CreateObject("ADODB.recordset")
	wSQL = "SELECT c.nombre"
	wSQL = wSQL & " FROM ind_indicador i"
	wSQL = wSQL & " INNER JOIN ind_categoria c ON c.ind_categoria_id = i.ind_categoria_id"
	wSQL = wSQL & " WHERE i.ind_indicador_id = " & wIndicador
	wRsCat.Open wSQL, oConn
	wCat = wRsCat("nombre")
	wRsCat.Close
	
	Set wRsUM = Server.CreateObject("ADODB.recordset")
	wSQL = "SELECT u.nombre"
	wSQL = wSQL & " FROM ind_indicador i"
	wSQL = wSQL & " INNER JOIN ind_unidad_medida u ON u.ind_unidad_medida_id = i.ind_unidad_medida_id"
	wSQL = wSQL & " WHERE i.ind_indicador_id = " & wIndicador
	wRsUM.Open wSQL, oConn
	wUM = wRsUM("nombre")
	wRsUM.Close
	
	
	'Lista de Indicadores
	Set oRsIndicadores = Server.CreateObject("ADODB.recordset")
	wSQL = "pr_graf_ind_indicador_matriz_v2 " & wId_Unidad & "," & wAnno & "," & wIndicador
	
    oRsIndicadores.Open wSQL, oConn
  
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
				<li class="active"><a href="indicadores.asp?Empresa=<%=wEmpresa%>&Id_Usuario=<%=wId_Usuario%>"><i class="fa fa-file-o"></i> <span>Indicadores</span></a></li>
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
			<div class="panel panel-inverse bg" style="background-color:#3b93ab" data-sortable-id="table-basic-5">
                        <div class="panel-body">
                            
							<h5><p class="muted text-white"><%=wSede%> - <%=wAnno%></p></h5>
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
                            <h4 class="panel-title"><%=wCat%></h4>
                        </div>
                        <div class="panel-body p-t-0">
                            <table id="indicadores" class="table table-valign-middle m-b-0">
                                <thead>
                                    <tr>
                                        <th><%=wInd%> (<%=wUM%>)</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
								 <%
								  If Not oRsIndicadores.Eof Then
									If Not IsNull(oRsIndicadores("Enero")) Then wEne = oRsIndicadores("Enero") Else wEne = 0 End If
                                    If Not IsNull(oRsIndicadores("Febrero")) Then wFeb = oRsIndicadores("Febrero") Else wFeb = 0 End If
                                    If Not IsNull(oRsIndicadores("Marzo")) Then wMar = oRsIndicadores("Marzo") Else wMar = 0 End If
                                    If Not IsNull(oRsIndicadores("Abril")) Then wAbr = oRsIndicadores("Abril") Else wAbr = 0 End If
                                    If Not IsNull(oRsIndicadores("Mayo")) Then wMay = oRsIndicadores("Mayo") Else wMay = 0 End If
                                    If Not IsNull(oRsIndicadores("Junio")) Then wJun = oRsIndicadores("Junio") Else wJun = 0 End If
                                    If Not IsNull(oRsIndicadores("Julio")) Then wJul = oRsIndicadores("Julio") Else wJul = 0 End If
                                    If Not IsNull(oRsIndicadores("Agosto")) Then wAgo = oRsIndicadores("Agosto") Else wAgo = 0 End If
                                    If Not IsNull(oRsIndicadores("Setiembre")) Then wSep = oRsIndicadores("Setiembre") Else wSep = 0 End If
                                    If Not IsNull(oRsIndicadores("Octubre")) Then wOct = oRsIndicadores("Octubre") Else wOct = 0 End If
                                    If Not IsNull(oRsIndicadores("Noviembre")) Then wNov = oRsIndicadores("Noviembre") Else wNov = 0 End If
                                    If Not IsNull(oRsIndicadores("Diciembre")) Then wDic = oRsIndicadores("Diciembre") Else wDic = 0 End If
								 %>
                                    <tr>
                                        <td><strong>Enero</strong></td>
                                        <td><%=FormatNumber(wEne)%></td>
                                    </tr>
									<tr>
                                        <td><strong>Febrero</strong></td>
                                        <td><%=FormatNumber(wFeb)%></td>
                                    </tr>
									<tr>
                                        <td><strong>Marzo</strong></td>
                                        <td><%=FormatNumber(wMar)%></td>
                                    </tr>
									<tr>
                                        <td><strong>Abril</strong></td>
                                        <td><%=FormatNumber(wAbr)%></td>
                                    </tr>
									<tr>
                                        <td><strong>Mayo</strong></td>
                                        <td><%=FormatNumber(wMay)%></td>
                                    </tr>
									<tr>
                                        <td><strong>Junio</strong></td>
                                        <td><%=FormatNumber(wJun)%></td>
                                    </tr>
									<tr>
                                        <td><strong>Julio</strong></td>
                                        <td><%=FormatNumber(wJul)%></td>
                                    </tr>
									<tr>
                                        <td><strong>Agosto</strong></td>
                                        <td><%=FormatNumber(wAgo)%></td>
                                    </tr>
									<tr>
                                        <td><strong>Septiembre</strong></td>
                                        <td><%=FormatNumber(wSep)%></td>
                                    </tr>
									<tr>
                                        <td><strong>Octubre</strong></td>
                                        <td><%=FormatNumber(wOct)%></td>
                                    </tr>
									<tr>
                                        <td><strong>Noviembre</strong></td>
                                        <td><%=FormatNumber(wNov)%></td>
                                    </tr>
									<tr>
                                        <td><strong>Diciembre</strong></td>
                                        <td><%=FormatNumber(wDic)%></td>
                                    </tr>
								 <%
								  End If
								 %>
                                </tbody>
                            </table>
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
			
			var groupColumn = 2;
			var table = $('#indicadores').DataTable({
				"columnDefs": [
					{ "visible": false, "targets": groupColumn }
				],
				"order": [[ groupColumn, 'asc' ]],
				"displayLength": 25,
				"drawCallback": function ( settings ) {
					var api = this.api();
					var rows = api.rows( {page:'current'} ).nodes();
					var last=null;
		 
					api.column(groupColumn, {page:'current'} ).data().each( function ( group, i ) {
						if ( last !== group ) {
							$(rows).eq( i ).before(
								'<tr class="group"><td colspan="5">'+group+'</td></tr>'
							);
		 
							last = group;
						}
					} );
				}
			} );
		 
			// Order by the grouping
			$('#indicadores tbody').on( 'click', 'tr.group', function () {
				var currentOrder = table.order()[0];
				if ( currentOrder[0] === groupColumn && currentOrder[1] === 'asc' ) {
					table.order( [ groupColumn, 'desc' ] ).draw();
				}
				else {
					table.order( [ groupColumn, 'asc' ] ).draw();
				}
			} );
		});
	</script>
</body>
</html>
