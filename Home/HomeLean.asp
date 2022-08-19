﻿<%@ Language=VBScript %>
<%response.Buffer=false%>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<%
   Server.ScriptTimeout = 360
	wId_Usuario = Request("Id_Usuario")
    wEmpresa = Request("Empresa")
    wId_Unidad = Request("Id_Unidad")

 %>

<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="es-co">
<!--<![endif]-->
<head>
	<meta charset="utf-8" />
	<title>Home LEANC</title>
	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
	<meta content="" name="description" />
	<meta content="" name="author" />
	
	<!-- ================== BEGIN BASE CSS STYLE ================== -->
	<link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
	<link href="assets/plugins/jquery-ui/themes/base/minified/jquery-ui.min.css" rel="stylesheet" />
	<link href="assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
	<link href="assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
	<link href="assets/css/animate.min.css" rel="stylesheet" />
	<link href="assets/css/style.min.css" rel="stylesheet" />
	<link href="assets/css/style-responsive.min.css" rel="stylesheet" />
	<link href="assets/css/theme/default.css" rel="stylesheet" id="theme" />
	<!-- ================== END BASE CSS STYLE ================== -->
	
	<!-- ================== BEGIN PAGE LEVEL STYLE ================== -->
	<link href="assets/plugins/jquery-jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" />
	<link href="assets/plugins/bootstrap-datepicker/css/datepicker.css" rel="stylesheet" />
	<link href="assets/plugins/bootstrap-datepicker/css/datepicker3.css" rel="stylesheet" />
    <link href="assets/plugins/gritter/css/jquery.gritter.css" rel="stylesheet" />
	<!-- ================== END PAGE LEVEL STYLE ================== -->

    <!-- ================== GOOGLE MAPS INCLUDE ================== -->
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
	
	<!-- ================== BEGIN BASE JS ================== -->
	<script src="assets/plugins/pace/pace.min.js"></script>
	<!-- ================== END BASE JS ================== -->
</head>
<body>
	<!-- begin #page-loader -->
	<div id="page-loader" class="fade in"><span class="spinner"></span></div>
	<!-- end #page-loader -->
	
	<!-- begin #page-container -->
	<div id="page-container" class="fade page-sidebar-fixed">

		<!-- begin #content -->
		<div id="content" class="content"> 
 
            <!-- <div class="row"> -->
			<!-- begin breadcrumb -->
            <div class="nav navbar-nav navbar-right">
                    <form name="Formulario" class="navbar-form full-width" method="post">
                        <input type="hidden" name="Id_Unidad" value="<%=wUEA%>" />
                        <input type="hidden" name="Empresa" value="<%=wEmpresa%>" />
                        <input type="hidden" name="nivel" value="<%=w_nivel%>" /> 
                        <div class="form-group">
                            <a href="javascript:document.Formulario.submit();" class="btn btn-sm btn-primary" data-toggle="modal">Refrescar</a>
                        </div>
                    </form>
            </div>
			<!-- end breadcrumb -->

			<!-- begin page-header -->
			<h1 class="page-header">DASHBOARD</h1>
			<!-- end page-header -->

           <!-- </div> -->
            			
			<!-- begin row -->
			<div class="row">
				<!-- begin col-3 -->
				<div class="col-md-3 col-sm-6">
					<div class="widget widget-stats bg-green">
						<div class="stats-icon"><i class="fa fa-desktop"></i></div>
						<div class="stats-info">
							<h4>MONTO PRESUPUESTO</h4>
							<p>S/ 3,291,922</p>	
						</div>
						<div class="stats-link">
							<a href="javascript:;">View Detail <i class="fa fa-arrow-circle-o-right"></i></a>
						</div>
					</div>
				</div>
				<!-- end col-3 -->
				<!-- begin col-3 -->
				<div class="col-md-3 col-sm-6">
					<div class="widget widget-stats bg-blue">
						<div class="stats-icon"><i class="fa fa-chain-broken"></i></div>
						<div class="stats-info">
							<h4>MONTO EJECUTADO</h4>
							<p>S/ 591,922</p>	
						</div>
						<div class="stats-link">
							<a href="javascript:;"><!--View Detail <i class="fa fa-arrow-circle-o-right"></i>-->&nbsp;</a>
						</div> 
					</div>
				</div>
				<!-- end col-3 -->
				<!-- begin col-3 -->
				<div class="col-md-3 col-sm-6">
					<div class="widget widget-stats bg-purple">
						<div class="stats-icon"><i class="fa fa-users"></i></div>
						<div class="stats-info">
							<h4>AVANCE A LA FECHA</h4>
							<p>18%</p>	
						</div>
						<div class="stats-link">
							<a href="javascript:;">View Detail <i class="fa fa-arrow-circle-o-right"></i></a>
						</div>
					</div>
				</div>
				<!-- end col-3 -->
				<!-- begin col-3 -->
				<div class="col-md-3 col-sm-6">
					<div class="widget widget-stats bg-red">
						<div class="stats-icon"><i class="fa fa-clock-o"></i></div>
						<div class="stats-info">
							<h4>PERDIDA ACUMULADA</h4>
							<p>S/ 32,800</p>	
						</div>
						<div class="stats-link">
							<a href="javascript:;">View Detail <i class="fa fa-arrow-circle-o-right"></i></a>
						</div>
					</div>
				</div>
				<!-- end col-3 -->
			</div>
			<!-- end row -->
			<!-- begin row -->
			<div class="row">
				<!-- begin col-8 -->
				<div class="col-md-8">
					<div class="panel panel-inverse" data-sortable-id="index-1">
						<div class="panel-heading">
							<div class="panel-heading-btn">
								<a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-default" data-click="panel-expand"><i class="fa fa-expand"></i></a>
								<a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-success" data-click="panel-reload"><i class="fa fa-repeat"></i></a>
								<a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-warning" data-click="panel-collapse"><i class="fa fa-minus"></i></a>
								<a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-danger" data-click="panel-remove"><i class="fa fa-times"></i></a>
							</div>
							<h4 class="panel-title">Porcentaje de Producto Conforme</h4>
						</div>
						<div class="panel-body">
							<div id="interactive-chart" class="height-sm"></div>
						</div>
					</div>
					
<!--				
					<div class="panel panel-inverse" data-sortable-id="index-4">
                        <div class="panel-heading">
                            <div class="panel-heading-btn">
                                <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-default" data-click="panel-expand"><i class="fa fa-expand"></i></a>
                                <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-success" data-click="panel-reload"><i class="fa fa-repeat"></i></a>
                                <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-warning" data-click="panel-collapse"><i class="fa fa-minus"></i></a>
                            </div>
                            <h4 class="panel-title">Quick Post</h4>
                        </div>
                    </div>
 -->                   



				</div>
				<!-- end col-8 -->



				<!-- begin col-4 -->
				<div class="col-md-4">


                    <div class="panel panel-inverse" data-sortable-id="index-6">
                        <div class="panel-heading">
                            <div class="panel-heading-btn">
                                <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-default" data-click="panel-expand"><i class="fa fa-expand"></i></a>
                                <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-success" data-click="panel-reload"><i class="fa fa-repeat"></i></a>
                                <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-warning" data-click="panel-collapse"><i class="fa fa-minus"></i></a>
                                <!-- 	<a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-danger" data-click="panel-remove"><i class="fa fa-times"></i></a> -->
                            </div>
                            <h4 class="panel-title">Causas de No Conformidad</h4>
                        </div>
                        <div class="panel-body">
                            <div id="donut-chart" class="height-sm"></div>
                        </div>
                    </div>


                    <div class="panel panel-inverse" data-sortable-id="index-9">
                        <div class="panel-heading">
                            <div class="panel-heading-btn">
                                <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-default" data-click="panel-expand"><i class="fa fa-expand"></i></a>
                                <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-success" data-click="panel-reload"><i class="fa fa-repeat"></i></a>
                                <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-warning" data-click="panel-collapse"><i class="fa fa-minus"></i></a>
                      <!--          <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-danger" data-click="panel-remove"><i class="fa fa-times"></i></a>-->
                            </div>
                            <h4 class="panel-title">Ubicación de la Obra</h4>
                        </div>
                        <div class="panel-body p-0">
                            <div id="google-map" class="height-sm width-full"></div>
                        </div>

                        <!--<div id="map-default" style="height: 400px; width: 100%"></div>-->

                        <script type="text/javascript">
                            var map;
                            var myLatLng = { lat: -12.0886141, lng: -77.0341498 };

                            function initialize() {
                                
                                var mapDiv = document.getElementById('google-map');
                                    map = new google.maps.Map(mapDiv, {
                                    center: myLatLng,
                                    zoom: 15,
                                    mapTypeId: google.maps.MapTypeId.ROADMAP
                                });

                                var contentString = '<div id="content">' +
                                      '<div id="siteNotice">'+
                                      '</div>'+
                                      '<h1 id="Heading" class="Heading6">OBRA X</h1>'+
                                      '<div id="bodyContent">'+
                                      '<p>' +
                                      'Direccion : Av. Ignacio Merino 2488 <br> ' +
                                      'Propietario : Dominiotech S.A.C. <br> ' +
                                      '</p>'+
                                      '</div>'+
                                      '</div>';

                                var infowindow = new google.maps.InfoWindow({
                                    content: contentString
                                });

                                var marker = new google.maps.Marker({
                                    position: myLatLng,
                                    map: map,
                                    title: 'OBRA'
                                });

                                marker.addListener('click', function () {
                                    infowindow.open(map, marker);
                                });

                                google.maps.event.trigger(map, 'resize');

                                }

                            google.maps.event.addDomListener(window, 'load', initialize);


                       </script>
                   </div>

					
					<div class="panel panel-inverse" data-sortable-id="index-10">
						<div class="panel-heading">
							<div class="panel-heading-btn">
								<a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-default" data-click="panel-expand"><i class="fa fa-expand"></i></a>
								<a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-success" data-click="panel-reload"><i class="fa fa-repeat"></i></a>
								<a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-warning" data-click="panel-collapse"><i class="fa fa-minus"></i></a>
								<a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-danger" data-click="panel-remove"><i class="fa fa-times"></i></a>
							</div>
							<h4 class="panel-title">Calendario de Tareas</h4>
						</div>
						<div class="panel-body">
							<div id="datepicker-inline" class="datepicker-full-width"><div></div></div>
						</div>
					</div>
				</div>
				<!-- end col-4 -->
			</div>
			<!-- end row -->
		</div>
		<!-- end #content -->
		
       
		
		<!-- begin scroll to top btn -->
		<a href="javascript:;" class="btn btn-icon btn-circle btn-success btn-scroll-to-top fade" data-click="scroll-top"><i class="fa fa-angle-up"></i></a>
		<!-- end scroll to top btn -->
	</div>
	<!-- end page container -->
	
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
	<script src="assets/plugins/gritter/js/jquery.gritter.js"></script>
	<script src="assets/plugins/flot/jquery.flot.min.js"></script>
	<script src="assets/plugins/flot/jquery.flot.time.min.js"></script>
	<script src="assets/plugins/flot/jquery.flot.resize.min.js"></script>
	<script src="assets/plugins/flot/jquery.flot.pie.min.js"></script>
	<script src="assets/plugins/sparkline/jquery.sparkline.js"></script>
	<script src="assets/plugins/jquery-jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
	<script src="assets/plugins/jquery-jvectormap/jquery-jvectormap-world-mill-en.js"></script>
	<script src="assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
	<script src="assets/js/dashboard.min.js"></script>
	<script src="assets/js/apps.min.js"></script>
	<!-- ================== END PAGE LEVEL JS ================== -->
	
	<script>
		$(document).ready(function() {
			App.init();
			Dashboard.init();
		});
	</script>
	
</body>

</html>

