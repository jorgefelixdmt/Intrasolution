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

	wComboIndicadores = Request("Indicador")
	
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

'Lista de Años'
	strSQL = "SELECT stored_procedure_anhos"
	strSQL = strSQL & " FROM fb_home"
	strSQL = strSQL & " WHERE fb_home_id = " & wId_Home & " AND is_deleted = 0"
	
	Set wRsSP = Server.CreateObject("ADODB.recordset")
	wRsSP.Open strSQL, oConn
	wSP = wRsSP("stored_procedure_anhos")
	
	wRsSP.Close

	strSQL = wSP & " " & wId_Unidad
	
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
	
	
	' Lista de Estado de Indicadores
	Set wRsIndicadores = Server.CreateObject("ADODB.recordset")
	wSQL = " SELECT ind_indicador_id,nombre,orden"
	wSQL = wSQL + " FROM ind_indicador"
	wSQL = wSQL + " WHERE is_deleted = 0"
	wSQL = wSQL + " UNION"
	wSQL = wSQL + " select 0,'TODOS',99999"
		wSQL = wSQL + " ORDER BY orden ASC"
	
	wRsIndicadores.Open wSQL, oConn
	
	If wComboIndicadores = "" Then
		wComboIndicadores = wRsIndicadores("ind_indicador_id")
	End If

'Selecciona los Portlets del Home
    strSQL = "pr_HOME_RecuperaPortles '" & wId_Home & "'" 
    Set oRsPortlet = Server.CreateObject("ADODB.Recordset")
    oRsPortlet.Open strSQL, oConn
    if oRsPortlet.eof then
        wError = "1"
        Response.Write "<span align=center ><b>No hay Portlets definidos para esta pagina</b></span>"
        Response.end
    end if 
	
	
	' Lista de Estado de Indicadores
	Set wRsIndicadores = Server.CreateObject("ADODB.recordset")
	wSQL = " SELECT ind_indicador_id,nombre,orden"
	wSQL = wSQL + " FROM ind_indicador"
	wSQL = wSQL + " WHERE is_deleted = 0"
	wSQL = wSQL + " UNION"
	wSQL = wSQL + " select 0,'TODOS',99999"
		wSQL = wSQL + " ORDER BY orden ASC"
	
	wRsIndicadores.Open wSQL, oConn
	
	If wComboIndicadores = "" Then
		wComboIndicadores = wRsIndicadores("ind_indicador_id")
	End If
	
  
%>

<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<head>
	<meta charset="utf-8" />
	<title>eco2biz</title>
	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
	<link rel="icon" href="assets/img/favicon.ico" type="image/x-icon">
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
	<link href="assets/plugins/jquery-jvectormap/jquery-jvectormap.css" rel="stylesheet" />
	<link href="assets/plugins/bootstrap-datepicker/css/bootstrap-datepicker.css" rel="stylesheet" />
	<!-- ================== END PAGE LEVEL STYLE ================== -->
	
	<script src="js/jquery-1.12.4.min.js"></script>
	
	<script src="../HighCharts_6_7/highcharts.js"></script>
	<script src="../HighCharts_6_7/modules/no-data-to-display.js"></script>
	<script src="../HighCharts_6_7/modules/exporting.js"></script>
	<script src="../HighCharts_6_7/js/modules/pareto.js"></script>
    <script  src="js/wait_indicator.js"></script> 
	
    <script src="assets/plugins/chart-js/Chart.bundle.min.js"></script>
    
    <script  src="js/bootstrap-toggle.min.js"></script>
	
	<script src="js/modal.js"></script>
	
	<script>
	//Colores para el relleno de los graficos
	const Colors = [
	  "rgba(223, 78, 78, 0.4)",
	  "rgba(223, 167, 78, 0.4)",
	  "rgba(177, 223, 78, 0.4)",
	  "rgba(98, 223, 78, 0.4)",
	  "rgba(78, 223, 158, 0.4)",
	  "rgba(86, 78, 223, 0.4)",
	  "rgba(174, 78, 223, 0.4)",
	  "rgba(223, 78, 223, 0.4)",
	  "rgba(223, 78, 8, 0.4)",
	  "rgba(223, 167, 78, 0.4)",
	  "rgba(177, 223, 78, 0.4)",
	  "rgba(98, 223, 78, 0.4)",
	  "rgba(78, 223, 158, 0.4)",
	  "rgba(86, 78, 223, 0.4)",
	  "rgba(174, 78, 223, 0.4)",
	  "rgba(223, 78, 223, 0.4)"];

	//Colores para los bordes de los graficos
	const BorderColors = [
		"rgba(223, 78, 78, 1)",
		"rgba(223, 167, 78, 1)",
		"rgba(177, 223, 78, 1)",
		"rgba(98, 223, 78, 1)",
		"rgba(78, 223, 158, 1)",
		"rgba(86, 78, 223, 1)",
		"rgba(174, 78, 223, 1)",
		"rgba(223, 78, 223, 1)",
		"rgba(223, 78, 78, 1)",
		"rgba(223, 167, 78, 1)",
		"rgba(177, 223, 78, 1)",
		"rgba(98, 223, 78, 1)",
		"rgba(78, 223, 158, 1)",
		"rgba(86, 78, 223, 1)",
		"rgba(174, 78, 223, 1)",
		"rgba(223, 78, 223, 1)"];

	window.chartColors = {
			red: 'rgb(255, 99, 132)',
			orange: 'rgb(255, 159, 64)',
			yellow: 'rgb(255, 205, 86)',
			green: 'rgb(75, 192, 192)',
			blue: 'rgb(54, 162, 235)',
			purple: 'rgb(153, 102, 255)',
			grey: 'rgb(201, 203, 207)'
		};


	Chart.pluginService.register({
	  beforeDraw: function (chart) {
		if (chart.config.options.elements.center) {
		  //Get ctx from string
		  var ctx = chart.chart.ctx;

		  //Get options from the center object in options
		  var centerConfig = chart.config.options.elements.center;
		  var fontStyle = centerConfig.fontStyle || 'Arial';
		  var txt = centerConfig.text;
		  var color = centerConfig.color || '#000';
		  var sidePadding = centerConfig.sidePadding || 20;
		  var sidePaddingCalculated = (sidePadding/100) * (chart.innerRadius * 2)
		  //Start with a base font of 30px
		  ctx.font = "30px " + fontStyle;

		  //Get the width of the string and also the width of the element minus 10 to give it 5px side padding
		  var stringWidth = ctx.measureText(txt).width;
		  var elementWidth = (chart.innerRadius * 2) - sidePaddingCalculated;

		  // Find out how much the font can grow in width.
		  var widthRatio = elementWidth / stringWidth;
		  var newFontSize = Math.floor(30 * widthRatio);
		  var elementHeight = (chart.innerRadius * 2);

		  // Pick a new font size so it will not be larger than the height of label.
		  var fontSizeToUse = Math.min(newFontSize, elementHeight);

		  //Set font settings to draw it correctly.
		  ctx.textAlign = 'center';
		  ctx.textBaseline = 'middle';
		  var centerX = ((chart.chartArea.left + chart.chartArea.right) / 2);
		  var centerY = ((chart.chartArea.top + chart.chartArea.bottom) / 2);
		  ctx.font = fontSizeToUse+"px " + fontStyle;
		  ctx.fillStyle = color;

		  //Draw text in center
		  ctx.fillText(txt, centerX, centerY);
		}
	  }
	});

</script>

<% NL = chr(13) & chr(10)
       oRsPortlet.MoveFirst
       Do While Not oRsPortlet.Eof
			file_js = oRsPortlet("file_js")  
		    'file_js = Replace(file_js,"[UEA]",wId_Unidad)  
		    'file_js = Replace(file_js,"[EMPRESA]",wEmpresa)  
		    'file_js = Replace(file_js,"[USUARIO]",wId_Usuario) 
			if oRsPortlet("file_js") <> "" then
                if instr(file_js,"?") > 0 then wConector = "&" else wConector = "?"
                Response.write "<script type='text/javascript' src='./js/" & file_js & wConector & "Empresa=" & wEmpresa & "&Id_Unidad=" & wId_Unidad & "&Id_Usuario=" & wId_Usuario  & "&Anno=" & wAnno  & "&Indicador=" & wComboIndicadores &  "&Codigo=" & oRsPortlet("codigo") & "&UltAnno=" & wUltAnno & "&tipografico=" & wTipoGrafico &"'></script>" & NL
			end if
            oRsPortlet.MoveNext
        Loop
        %>
 

    
    <script>
    window.onload = function() {
        <%  oRsPortlet.MoveFirst
            Do While Not oRsPortlet.Eof%>     
               <%If UCASE(oRsPortlet("Tipo"))="HCHART" then%>        
				   var ctx_<%=oRsPortlet("codigo")%> = document.getElementById('canvas_<%=oRsPortlet("codigo")%>');
				   var chart_<%=oRsPortlet("codigo")%> = new Highcharts.Chart(ctx_<%=oRsPortlet("codigo")%>, config_<%=oRsPortlet("codigo")%>);
               <%End If%>
			   <%If UCASE(oRsPortlet("Tipo"))="CHART" then%>        
				   var ctx_<%=oRsPortlet("codigo")%> = document.getElementById('canvas_<%=oRsPortlet("codigo")%>').getContext('2d');
				   var chart_<%=oRsPortlet("codigo")%> = new Chart(ctx_<%=oRsPortlet("codigo")%>, config_<%=oRsPortlet("codigo")%>);
               <%End If%> 
               <%If UCASE(oRsPortlet("Tipo"))="MAP" then%>        
				   init();
               <%End If%> 
			   <%If UCASE(oRsPortlet("Tipo"))="HHYBRID" then%>        
				   var ctx_<%=oRsPortlet("codigo")%> = document.getElementById('canvas_<%=oRsPortlet("codigo")%>');
				   var chart_<%=oRsPortlet("codigo")%> = new Highcharts.Chart(ctx_<%=oRsPortlet("codigo")%>, config_<%=oRsPortlet("codigo")%>);
               <%End If%>
			   <%If UCASE(oRsPortlet("Tipo"))="HYBRID" then%>        
				   var ctx_<%=oRsPortlet("codigo")%> = document.getElementById('canvas_<%=oRsPortlet("codigo")%>').getContext('2d');
				   var chart_<%=oRsPortlet("codigo")%> = new Chart(ctx_<%=oRsPortlet("codigo")%>, config_<%=oRsPortlet("codigo")%>);
               <%End If%>
			   <%If UCASE(oRsPortlet("Tipo"))="DYN_HCHART" then%>        
				   load_<%=oRsPortlet("codigo")%>()
               <%End If%>
          <%If UCASE(oRsPortlet("Tipo"))="CALENDAR" then%>        
				   load_<%=oRsPortlet("codigo")%>()
          <%End If%>
          <%If UCASE(oRsPortlet("Tipo"))="Y-CALENDAR" then%>        
				   load_<%=oRsPortlet("codigo")%>()
          <%End If%>
          <%If UCASE(oRsPortlet("Tipo"))="C-HUMANO" then%>        
				   load_<%=oRsPortlet("codigo")%>()
          <%End If%>

	   <%      oRsPortlet.MoveNext 
            Loop
        %>

		};
	
	// Sin datos
	Highcharts.setOptions({
		lang: {
			noData: 'No hay datos para mostrar'
		}
	});
	
	// Configuracion de Colores
	Highcharts.setOptions({
		colors: ['rgb(75, 192, 192)','rgb(255, 159, 64)','rgb(255, 205, 86)','rgb(255, 99, 132)','rgb(54, 162, 235)','rgb(153, 102, 255)','rgb(201, 203, 207)']
	});
	
	// Quitar link
	Highcharts.setOptions({
		credits: {
			enabled: false
		},
	});
	
    //Funcion encargada de descargar el canvas como imagen
    function downloadCanvas(link, canvasId, filename) {
        link.href = document.getElementById(canvasId).toDataURL();
        link.download = filename;
    }  
        
    $(function () {
      $('[data-toggle="tooltip"]').tooltip()
    })
                 

 </script>
 
 <style>

#chartjs-tooltip {
  max-width: 300px;
  z-index: 999;
  opacity: 1;
  position: absolute;
  background: rgba(0, 0, 0, .7);
  color: white;
  border-radius: 3px;
  -webkit-transition: all .1s ease;
  transition: all .1s ease;
  pointer-events: none;
  -webkit-transform: translate(-50%, 0);
  transform: translate(-50%, 0);
}

.chartjs-tooltip-key {
  display: inline-block;
  width: 10px;
  height: 10px;
  margin-right: 10px;

}

.contenido
{
  display: flex;
 justify-content:center; 
  margin-top: 5px;
  margin-bottom: 5px;
  margin-right: 5px;
  margin-left: 5px;
  overflow-y: auto;
  overflow-x: hidden;
}

.contenido-left
{
  display: flex;
  justify-content:left; 
  margin-top: 0px;
  margin-bottom: 5px;
  margin-right: 5px;
  margin-left: 5px;
  overflow-y: auto;
  overflow-x: hidden;
}

.contenido-abs
{
  position : absolute;
  width: 100%;
  display: flex;
  justify-content:left; 
  margin-top: 10px;
  margin-bottom: 5px;
  margin-right: 5px;
  margin-left: 5px;
  overflow-y: auto;
  overflow-x: hidden;
}

.contenido-dyn
{
  justify-content:center;
  float:left;
  height: auto;
  width:95%; 
  margin-top: 5px;
  margin-bottom: 5px;
  margin-right: 5px;
  margin-left: 5px;
  overflow-y: hidden;
  overflow-x: hidden;
  padding-top:10px
}

</style>

<script>
    function ActualizaFormulario() {
        document.body.style.cursor = 'wait';
        document.getElementById("frm_Home").submit();
    }
</script>
	
	
</head>



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
					<a href=""><img src="assets/img/logo2.png" alt=""></a>
					<span class="navbar-logo"></span> </a>
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
				<li class=""><a href="indicadores.asp?Empresa=<%=wEmpresa%>&Id_Usuario=<%=wId_Usuario%>"><i class="fa fa-file-o"></i> <span>Indicadores</span></a></li>
				<li class="active"><a href="#"><i class="fa fa-bar-chart"></i> <span>Gráficos</span></a></li>
				
	
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

			
			
			<!-- inicio cab -->
			       
			        <!-- begin panel -->
                    <div class="panel panel-inverse bg" style="background-color:#3b93ab" data-sortable-id="table-basic-5">
                        <div class="panel-body">
                            
							<form id="frm_Home" method="post" action="index.asp">
								<input type="hidden" name="Empresa" value="<%=wEmpresa%>" />
								<input type="hidden" name="Id_Usuario" value="<%=wId_Usuario%>" />
								<input type="hidden" name="Id_Home" value="<%=wId_Home%>" />
							
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
									
									<div class="col-md-12">
												   <div class="form-group">
												<label for="exampleFormControlSelect1" class="text-white">Indicador :</label>
												<%
													'RCombo de autoridad
													Response.write "<select name='Indicador' id='Indicador' class='form-control' onchange='ActualizaFormulario()'>"
													While not wRsIndicadores.EOF
														' Esta validación sirve para que el valor seleccionado del combo se quede estático
														' CDBL convierte varchar a numeric
														If cdbl(wComboIndicadores) = cdbl(wRsIndicadores("ind_indicador_id")) Then
															wselected = "selected"
														Else
															wselected = ""
														End If
													
														Response.Write "<option value='" & wRsIndicadores("ind_indicador_id") & "' " & wselected & "> " & wRsIndicadores("nombre") & "</option>"
															
														wRsIndicadores.MoveNext()
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
			    <!-- end col-6 -->
			
			<!-- fin -->
			
			
			 <!-- begin col-4 -->
                    <div id="page-container" >

		<!-- begin #content -->
		<div id="content"> 
 		
<!-- INICIO PANEL CUADROS  -->
<%
  wFila = 0
  oRsPortlet.MoveFirst
  Do While Not oRsPortlet.Eof
    if oRsPortlet("Orden_Fila") <> wFila then
        if wFila <> 0 then Response.write "</div>"
        Response.write "<div class='row'>"
        wFila = oRsPortlet("Orden_Fila")
    end if

    Select Case  oRsPortlet("ancho") 
        Case 3 
            wclass = "col-lg-3 col-md-3 col-sm-6 col-xs-12"
        Case 4 
            wclass =  "col-lg-4 col-md-4 col-sm-6 col-xs-12"
        Case 6 
            wclass = "col-lg-6 col-md-6 col-sm-6 col-xs-12"
        Case 8 
            wclass = "col-lg-8 col-md-8 col-sm-6 col-xs-12"
        Case 10 
            wclass = "col-lg-10 col-md-10 col-sm-12 col-xs-12"
        Case 12 
            wclass = "col-lg-12 col-md-12"
        Case Else
            wclass = "col-md-" & oRsPortlet("ancho") 
    End Select
%>
    

    <div class="<%=wClass%>">
      <div class="panel panel-<%=oRsPortlet("color")%>">

    <%If oRsPortlet("flag_header") = 1 then%>
	
		<%
			
			wSQLH = "SELECT descripcion, titulo"
			wSQLH = wSQLH & " FROM fb_portlet"
			wSQLH = wSQLH & " WHERE codigo = '" & oRsPortlet("codigo") & "' AND is_deleted = 0"
			
			Set wRsH = Server.CreateObject("ADODB.recordset")
			wRsH.Open wSQLH, oConn
			
			'** Obtiene la descripci�n del portlet
			wNombre = wRsH("titulo")
			wContenido = ""
			If not isnull(wRsH("descripcion")) Then
				wContenido = wRsH("descripcion")
				wContenido = Replace(wContenido,chr(10),"</br>")
			End if
			
			wRsH.Close
		%>
	
		<!-- Modal -->
				 <div class="container">
				  <div class="modal fade" id="Modal_<%=oRsPortlet("codigo")%>" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
					<div class="modal-dialog modal-lg">
					  <div class="modal-content">
						<div class="modal-header">
						  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						  <h4 class="modal-title text-danger" id="myLargeModalLabel"><b><%=wNombre%></b></h4>
						</div>
						<div class="modal-body">
						  <h6><p><%=wContenido%></p></h6>
						  
						</div>
						<div class="modal-footer">
						  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						</div>
					  </div>
					  <!-- /.modal-content -->
					</div>
					<!-- /.modal-dialog -->
				  </div> 
				  <!-- /.modal --> 
				</div>
	
	
        <div class="panel-heading">
        <div class="panel-heading-btn">
            <%if oRsPortlet("flag_expand") = "1" then %>
            <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-<%=oRsPortlet("color")%>" data-click="panel-expand"><i class="fa fa-expand"></i></a>
            <%End If%>
            <%if oRsPortlet("flag_reload") = "1" then %>
            <a href="javascript:;" class="btn btn-xs btn-icon btn-circle btn-<%=oRsPortlet("color")%>" data-click="panel-reload"><i class="fa fa-repeat"></i></a>
            <%End If%>
            <%if oRsPortlet("flag_download") = "1" then %>
            <a id="download" style="color:white" class="btn btn-icon btn-circle btn-download" onclick="downloadCanvas(this,'canvas_<%=oRsPortlet("codigo")%>','<%=oRsPortlet("codigo")%>.png')"><i class="fa fa-download"></i></a>
            <%End If%>

            <button type="button" class="btn-icon btn-circle btn btn-info btn-sm" data-toggle="modal" data-target="#Modal_<%=oRsPortlet("codigo")%>"><i class="fa fa-question fa-xs"></i> </button>
			
			<%If UCASE(oRsPortlet("tipo")) = "TABLE" then %>
                <button type="button" class="btn-icon btn-circle btn btn-warning btn-sm" onclick="tableToExcel('<%=oRsPortlet("codigo")%>', '<%=oRsPortlet("titulo")%>')" ><i class="fa fa-download fa-xs"></i> </button>
			<%End If%>
			
			<%If ((UCASE(oRsPortlet("tipo")) = "HCHART") or (UCASE(oRsPortlet("tipo")) = "DYN_HCHART")) then %>
                <button type="button" class="btn-icon btn-circle btn btn-warning btn-sm" onclick="toggle('canvas_<%=oRsPortlet("codigo")%>')" ><i class="fa fa-bookmark fa-xs"></i> </button>
			<%End If%>
        </div>
        <h4 class="panel-title"><%=oRsPortlet("titulo")%></h4>
        </div>
    <%End if%>

       <%if UCASE(oRsPortlet("tipo")) = "HCHART"  then %>
		<div class="contenido" data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >
            <div id="canvas_<%=oRsPortlet("codigo")%>" style="width:100%;height:100%;"></div>
		</div>
       <%End if%>
	   
	   <%if UCASE(oRsPortlet("tipo")) = "CHART"  then %>
		<div class="contenido" data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >
            <canvas id="canvas_<%=oRsPortlet("codigo")%>" style="height:100%"></canvas>
		</div>
       <%End if%>

       <%if UCASE(oRsPortlet("tipo")) = "MAP" then %>
		<div class="contenido" data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >
            <div id="google-map" class="height-full width-full"></div>
		</div>
       <%End if%>
	   
       <%if UCASE(oRsPortlet("tipo")) = "TABLE" then %>
		<div class="contenido" data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >
	   <%
            Session("Empresa") = wEmpresa
            Session("Id_Unidad") = wId_Unidad
            Session("Id_Usuario") = wId_Usuario
            Session("Anno") = wAnno
			Session("Mes") = wMes
			Session("Codigo") = oRsPortlet("codigo")
			Session("ultAnno") = wUltAnno
            wURL = oRsPortlet("file_asp")
            Server.Execute(wURL) 
	   %>
		</div>
       <% End if%>
	   <%if UCASE(oRsPortlet("tipo")) = "HHYBRID"  then %>
		
		<div class="contenido" data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >
			 <div id="canvas_<%=oRsPortlet("codigo")%>" style="float:left;width:50%;height:100%;break-inside:avoid-column;"></div>
		
			<div style="break-inside:avoid-column">
			<%
				Session("Empresa") = wEmpresa
				Session("Id_Unidad") = wId_Unidad
				Session("Id_Usuario") = wId_Usuario
				Session("Anno") = wAnno
				Session("ultAnno") = wUltAnno
				wURL = oRsPortlet("file_asp")
				Server.Execute(wURL) 
			%>
			</div>	
		</div>
       <%End if%>
	   
	   <%if UCASE(oRsPortlet("tipo")) = "HYBRID"  then %>
		<div class="contenido parent" data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >
			<div>
			<%
				Session("Empresa") = wEmpresa
				Session("Id_Unidad") = wId_Unidad
				Session("Id_Usuario") = wId_Usuario
				Session("Anno") = wAnno
				Session("ultAnno") = wUltAnno
				wURL = oRsPortlet("file_asp")
				Server.Execute(wURL) 
			%>
			</div>
      <div class="Chart_Inside" >
			 <canvas id="canvas_<%=oRsPortlet("codigo")%>"></canvas>
			</div>
		</div>
       <%End if%>
	   
	   <%if UCASE(oRsPortlet("tipo")) = "DYN_HCHART"  then %>
        			
						<div id="div_<%=oRsPortlet("codigo")%>" class="panel-body">
                            <div data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >
		
                                <div class="contenido-dyn">
                                <%
                                    Session("Empresa") = wEmpresa
                                    Session("Id_Unidad") = wId_Unidad
                                    Session("Id_Usuario") = wId_Usuario
                                    Session("Anno") = wAnno
                                    Session("ultAnno") = wUltAnno
                                    Session("Codigo") = oRsPortlet("codigo")
                                    wURL = oRsPortlet("file_asp")
                                    Server.Execute(wURL) 
                                %>
                                
                                </div>
                        </div>        
        		    </div>
       <%End if%>
      <%if UCASE(oRsPortlet("tipo")) = "CALENDAR"  then %>
						<div id="div_<%=oRsPortlet("codigo")%>" class="panel-body">
                            <div data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >
		
                                <div class="contenido-dyn">
                                <%
                                    Session("Empresa") = wEmpresa
                                    Session("Id_Unidad") = wId_Unidad
                                    Session("Id_Usuario") = wId_Usuario
                                    Session("Anno") = wAnno
                                    Session("ultAnno") = wUltAnno
                                    Session("Codigo") = oRsPortlet("codigo")
                                    wURL = oRsPortlet("file_asp")
                                    Server.Execute(wURL) 
                                %>
                                
                                </div>
                        </div>        
        		    </div>
       <%End if%>
      <%if UCASE(oRsPortlet("tipo")) = "Y-CALENDAR"  then %>
        
          <div id="div_<%=oRsPortlet("codigo")%>" class="panel-body">
                  <div data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >

                          <div class="contenido-dyn">
                          <%
                              Session("Empresa") = wEmpresa
                              Session("Id_Unidad") = wId_Unidad
                              Session("Id_Usuario") = wId_Usuario
                              Session("Anno") = wAnno
                              Session("ultAnno") = wUltAnno
                              Session("Codigo") = oRsPortlet("codigo")
                              wURL = oRsPortlet("file_asp")
                              Server.Execute(wURL) 
                          %>
                          
                          </div>
                  </div>        
          </div>
       <%End if%>
        <%if UCASE(oRsPortlet("tipo")) = "C-HUMANO"  then %>
        
          <div id="div_<%=oRsPortlet("codigo")%>" class="panel-body">
                  <div data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >

                          <div class="contenido-dyn">
                          <%
                              Session("Empresa") = wEmpresa
                              Session("Id_Unidad") = wId_Unidad
                              Session("Id_Usuario") = wId_Usuario
                              Session("Anno") = wAnno
                              Session("ultAnno") = wUltAnno
                              Session("Codigo") = oRsPortlet("codigo")
                              wURL = oRsPortlet("file_asp")
                              Server.Execute(wURL) 
                          %>
                          
                          </div>
                  </div>        
          </div>
       <%End if%>
      </div>
    </div>
 <%     oRsPortlet.MoveNext
     Loop
     Response.write "</div>"
     %> 
<!-- FIN PANEL CUADROS  -->


	<!-- end content -->		
	</div>		
	<!-- end page container -->
</div>
		        <!-- end col-4 -->
			
			
			
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
	
	<script src="assets/plugins/flot/jquery.flot.min.js"></script>
	<script src="assets/plugins/flot/jquery.flot.time.min.js"></script>
	<script src="assets/plugins/flot/jquery.flot.resize.min.js"></script>
	<script src="assets/plugins/flot/jquery.flot.pie.min.js"></script>
	<script src="assets/plugins/sparkline/jquery.sparkline.js"></script>
	<script src="assets/plugins/jquery-jvectormap/jquery-jvectormap.min.js"></script>
	<script src="assets/plugins/jquery-jvectormap/jquery-jvectormap-world-mill-en.js"></script>
	<script src="assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
	<script src="assets/js/chart-flot.demo.min.js"></script>
	
	<!-- ================== BEGIN PAGE LEVEL JS ================== -->
	<script src="assets/js/apps.min.js"></script>
	<!-- ================== END PAGE LEVEL JS ================== -->

<script>
		$(document).ready(function() {
			App.init();
		});
		
	function toggle(canvasid){
		var chartDom = document.getElementById(canvasid);
		var chart = Highcharts.charts[Highcharts.attr(chartDom, 'data-highcharts-chart')]
		var opt
		for (var i = 0; i < chart.series.length; i++){
			opt = chart.series[i].options;
			opt.dataLabels.enabled = !opt.dataLabels.enabled;
			chart.series[i].update(opt);
		}
	}
	</script>
	
	
	<script type="text/javascript">
		var tableToExcel = (function() {
		  var uri = 'data:application/vnd.ms-excel;base64,'
			, template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--><meta http-equiv="content-type" content="text/plain; charset=UTF-8"/></head><body><table>{table}</table></body></html>'
			, base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) }
			, format = function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
		  return function(table, name) {
			if (!table.nodeType) table = document.getElementById(table)
			var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML.replace(/<\s*a[^>]*>/gi,'')}
			//window.location.href = uri + base64(format(template, ctx))
			var link = document.createElement("a");
			link.download = name + ".xls";
			link.href = uri + base64(format(template, ctx));
			link.click();
		  }
		})()
	</script>
		
	<script>

function setModalMaxHeight(element) {
    this.$element = $(element);
    this.$content = this.$element.find('.modal-content');
    var borderWidth = this.$content.outerHeight() - this.$content.innerHeight();
    var dialogMargin = $(window).width() < 768 ? 20 : 60;
    var contentHeight = $(window).height() - (dialogMargin + borderWidth);
    var headerHeight = this.$element.find('.modal-header').outerHeight() || 0;
    var footerHeight = this.$element.find('.modal-footer').outerHeight() || 0;
    var maxHeight = contentHeight - (headerHeight + footerHeight);

    this.$content.css({
        'overflow': 'hidden'
    });

    this.$element
    .find('.modal-body').css({
        'max-height': maxHeight,
        'overflow-y': 'auto'
    });
}

$('.modal').on('show.bs.modal', function () {
    $(this).show();
    setModalMaxHeight(this);
});

</body>
</html>
