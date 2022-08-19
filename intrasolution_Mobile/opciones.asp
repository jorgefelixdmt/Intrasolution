<%
wEmpresa = Request("Empresa")
wUEA = Request("Id_Unidad")
wId_Usuario = Request("Id_Usuario")

Dim oConn
'If not already defined, create object

if not isObject(oConn) then
	Dim strConnQuery
	Set oConn = Server.CreateObject("ADODB.Connection")
			strConnQuery = Application(wEmpresa)
	oConn.Open(strConnQuery)
	oConn.CommandTimeout = 60
end if

Set wRsUnidad = Server.CreateObject("ADODB.recordset")
wSQL = "select nombre from fb_uea_pe where fb_uea_pe_id = " & wUEA
wRsUnidad.Open wSQL, oConn
wUnidad = wRsUnidad("nombre")
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Sistema Movil safe2biz</title>
	<meta name="viewport" content="width=device-width, initial-scale=1  maximum-scale=1 user-scalable=no">
	<meta name="mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-touch-fullscreen" content="yes">
	<meta name="HandheldFriendly" content="True">

	<link href="https://fonts.googleapis.com/css?family=Lato:400,700,900" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css?family=Open+Sans:400,400i,600,600i,700,700i" rel="stylesheet">

	<link rel="stylesheet" href="css/materialize.css">
	<link rel="stylesheet" href="font-awesome/css/font-awesome.min.css">
	<link rel="stylesheet" href="css/normalize.css">
	<link rel="stylesheet" href="css/owl.carousel.css">
	<link rel="stylesheet" href="css/owl.theme.css">
	<link rel="stylesheet" href="css/owl.transitions.css">
	<link rel="stylesheet" href="css/magnific-popup.css">
	<link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/style2.css">
    <link rel="stylesheet" href="css/demo.css">
    <link rel="stylesheet" href="css/icono.css">

	<link rel="shortcut icon" href="img/favicon.png">




</head>
<body>

	<!-- navbar top -->
	<div class="navbar-top">
		<!-- site brand	 -->
		<div class="site-brand">
			<a href="login.html"><h1><img src="images/safe2biz.png" alt=""></h1></a>
		</div>
		<!-- end site brand	 -->

		<div class="side-nav-panel-right">
			<a href="#" data-activates="slide-out-right" class="side-nav-right"><i class="fa fa-bars negro"></i></a>
		</div>
	</div>
	<!-- end navbar top -->



  <!-- navbar top -->
	<div class="navbar-top2">
		<!-- site brand	 -->
		<div class="site-brand2">
		<a href="unidades.asp?Id_Usuario=<%=wId_Usuario%>&EMPRESA=<%=wEmpresa%>"><i class="fa fa-arrow-circle-left fa-2x negro" aria-hidden="true"></i></a>
		</div>
		<!-- end site brand	 -->

		<div class="side-nav-panel-right">
			<a href="#" data-activates="slide-out-right" class="side-nav-right"><i class="fa fa-home negro"><%=wUnidad%></i></a>
		</div>
	</div>
	<!-- end navbar top -->






	<!-- side nav right-->
	<div class="side-nav-panel-right">
		<ul id="slide-out-right" class="side-nav side-nav-panel">
			<li><a href="http://intranet.dominiotech.com.pe/safe2biz_ASP//safe2biz_Mobile/safe2biz_MobileCharts.asp?Id_Unidad=<%=wUEA%>&Id_Usuario=<%=wId_Usuario%>&EMPRESA=<%=wEmpresa%>"><i class="fa fa-pie-chart naranjado-text"></i>Dashboard</a></li>
			<li><a href="http://intranet.dominiotech.com.pe/eco2biz_ASP//eco2biz_home/HomeMapa_GoogleMaps_New.asp?Id_Unidad=<%=wUEA%>&Id_Usuario=<%=wId_Usuario%>&EMPRESA=<%=wEmpresa%>"><i class="fa fa-map naranjado-text"></i>Mapa</a></li>

		</ul>
	</div>
	<!-- end side nav right-->

	<!-- team -->
	<div class="pages section">
		<div class="container">
			<div class="pages-head">
				<!--<h2>OPCIONES</h2> -->
			</div>
			<div class="row"></div>
			<div class="row">
				<div class="col s6">
					<div class="xteam"> <a href="http://intranet.dominiotech.com.pe/safe2biz_ASP//safe2biz_Mobile/safe2biz_MobileCharts.asp?Id_Unidad=<%=wUEA%>&Id_Usuario=<%=wId_Usuario%>&EMPRESA=<%=wEmpresa%>"><img src="images/deshboard.png" alt="" width="100" height="100"></a>
						<div class="team-details">
						  <h6>Dashboard</h6>
						</div>
					</div>
				</div>
				<div class="col s6">
					<div class="xteam"><a href="http://intranet.dominiotech.com.pe/safe2biz_ASP//safe2biz_Mobile/safe2biz_MobileMaps.asp?Id_Unidad=<%=wUEA%>&Id_Usuario=<%=wId_Usuario%>&EMPRESA=<%=wEmpresa%>"><img src="images/mapa.png" alt="" width="100" height="100"></a>
						<div class="team-details">
						  <h6>Mapa</h6>
					     </div>
					</div>
				</div>
			</div>
			<div class="row nomar-bottom"></div>
		</div>
	</div>
	<!-- end team -->

	<!-- footer
	<div class="footer">
		<div class="container">
			<div class="about-us-foot">
				<h6><img src="images/safe2biz.png" alt=""></h6>
				<p>Safe2biz©, es la solución de software, en Salud y Seguridad Ocupacional.</p>
			</div>
			<div class="social-media">
				<a href=""><i class="fa fa-facebook azul"></i></a>
				<a href=""><i class="fa fa-twitter azul"></i></a>
				<a href=""><i class="fa fa-google azul"></i></a>
				<a href=""><i class="fa fa-linkedin azul"></i></a>
				<a href=""><i class="fa fa-instagram azul"></i></a>
			</div>
			<div class="copyright">
				<span>© 2017 All Right Reserved</span>
			</div>
		</div>
	</div>
	 end footer -->

	<!-- scripts -->
	<script src="js/jquery.min.js"></script>
	<script src="js/materialize.min.js"></script>
	<script src="js/owl.carousel.min.js"></script>
	<script src="js/jquery.magnific-popup.min.js"></script>
	<script src="js/main.js"></script>

</body>
</html>
