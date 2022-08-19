<%
wEmpresa = Request("Empresa")
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
wSQL = "select fb_uea_pe_id as uea_id, nombre from fb_uea_pe where owner_id = " & wId_Usuario & " and is_deleted=0"
wRsUnidad.Open wSQL, oConn
%>

<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<title>Build - Construction Mobile Template</title>
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
     <link rel="stylesheet" href="css/bootstrap-social.css">
      <link rel="stylesheet" href="css/bootstrap-theme.min.css">



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

	</div>
	<!-- end navbar top -->


	<!-- team -->
	<div class="pages section">
		<div class="container">
			<!--<div class="pages-head">
				<h2>UNIDADES</h2>
			</div> -->
			<div class="row">
				<div class="col s12">
					<div class="pricing">

                  <!-- /.panel-heading -->
                        <div class="panel-body">
                   <ul>
										 <%
										 		Do while Not wRsUnidad.eof
													wUnidad = wRsUnidad("nombre")
													wUEA = wRsUnidad("uea_id")
										 %>
                           <li><a href="opciones.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wUEA%>&Id_Usuario=<%=wId_Usuario%>" class="btn btn-block btn-social btn-bitbucket btn-large">
                              <i class="fa fa-home"></i><%=wUnidad%></a></li>
											<%
												wRsUnidad.MoveNext
												Loop
											%>
                    </ul>

                </div>
               <!-- /.panel-body -->
                </div>
			</div>
	</div>
	<!-- end team -->



	<!-- scripts -->
	<script src="js/jquery.min.js"></script>
	<script src="js/materialize.min.js"></script>
	<script src="js/owl.carousel.min.js"></script>
	<script src="js/jquery.magnific-popup.min.js"></script>
	<script src="js/main.js"></script>

</body>

<!-- Mirrored from ngerri.com/build/build/pricing.html by HTTrack Website Copier/3.x [XR&CO'2014], Wed, 16 Nov 2016 18:34:48 GMT -->
</html>
