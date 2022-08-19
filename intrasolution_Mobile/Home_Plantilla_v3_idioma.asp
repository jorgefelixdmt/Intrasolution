
<%@ Language=VBScript %>
<!--#Include File="Includes/FuncionIdioma.asp"-->
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<!-- #INCLUDE FILE="../Includes/f_ValidaURL.asp" -->


<%
 
' ******************************************************************************************************************************************************
' Nombre: Home_Plantilla.asp
' Fecha Creación: ---
' Autor: Manuel Perez
' Descripción: ASP que genera el home principal.
' Usado por: Home Principal, módulo de Residuos, módulo de Verificación Ambiental, módulo de indicadores.
' 
' ******************************************************************************************************************************************************
' RESUMEN DE CAMBIOS
' Fecha(aaaa-mm-dd)         Autor                      Comentarios      
' --------------------      ---------------------      -----------------------------------------------------------------------------------------------
' 22/07/2019                Valky Salinas              Se agregó una función javascript para que Highcharts pinte y-axis plotlines sin error.
'
' 10/09/2019                Enrique Huaman             Se cambio el icono de bookmark por tag
'
' 31/12/2019                Valky Salinas              Se agregó el campo Estado como campo oculto del formulario
'
' 02/01/2020                Valky Salinas              Se agregó sidebar de sedes para sede corporativa.
'
' 03/01/2020                Valky Salinas              Ahora se busca la sede corporativo en base al código y no al ID.
'
' 07/01/2020                Valky Salinas              Se agregó búsqueda de sedes en corporativo en base a un SP personalizado.
'                                                      Los ID de las sedes en corporativo se guardan al refrescar la página.
'
' 15/04/2020                Valky Salinas              Si el Estado es vacío o NULL, es 0 por defecto.
'
' ******************************************************************************************************************************************************
' 
'

%>


<%
' Colores Cabeceras
'.panel-danger  > ROJO 
'.panel-info    > AZUL MARINO
'.panel-inverse > NEGRO
'.panel-primary > AZUL
'.panel-success > VERDE  
'.panel-warning > MOSTAZA

    Server.ScriptTimeout = 360
  	Response.ContentType = "text/html"
	Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
	Response.AddHeader "Set-Cookie", "SameSite=None; Secur; path=/; HttpOnly"
	Response.CodePage = 65001
	Response.CharSet = "UTF-8"

    wEmpresa = Request("Empresa")
    Estado = Request("Estado")
    wId_Unidad = Request("Id_Unidad")
	  wId_Usuario = Request("Id_Usuario")
	  datepicker = Request("datepicker")
	  busqueda = Request("busqueda")
    wAnno = Request("Anno")
    fechas = split(datepicker," - ")
	
    if busqueda = "" then
       busqueda = "anio"
    end if

    
    wId_Home = Request("Id_home")
    
	wMes = Request("Mes")
	  
	wId_Sedes = Request("Id_Sedes")
	
	If Estado = "" OR IsNull(Estado) Then
		Estado = 0
	End If
	
	
	wCliente = Request("Cliente")
	
	'Consulta de las credenciales del usuario'
	Set wRsUser = Server.CreateObject("ADODB.recordset")
	wSQL = "SELECT "
	wSQL = wSQL + " USER_LOGIN, "
	wSQL = wSQL + " PASSWORD,"
	wSQL = wSQL + " fb_empleado_id"
	wSQL = wSQL + " FROM SC_USER "
	wSQL = wSQL + " Where SC_USER_ID = " & wId_Usuario
	wRsUser.Open wSQL, oConn
	wUser = wRsUser("USER_LOGIN")
	wPass = wRsUser("PASSWORD")
	wEmpleado = wRsUser("fb_empleado_id")
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

'Lista de A�os'
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
    if busqueda = "anio" then
      fechas = array("01/01/" & wAnno ,"31/12/"& wAnno)
    end if

'Selecciona los Portlets del Home
    strSQL = "pr_HOME_RecuperaPortles '" & wId_Home & "'" 
    Set oRsPortlet = Server.CreateObject("ADODB.Recordset")
    oRsPortlet.Open strSQL, oConn
    if oRsPortlet.eof then
        wError = "1"
        Response.Write "<span align=center ><b>No hay Portlets definidos para esta pagina</b></span>"
        Response.end
    end if 
	
	
' ID Home Corporativo
	strSQL = "SELECT fb_uea_pe_id " 
	strSQL = strSQL & "FROM fb_uea_pe " 
	strSQL = strSQL & "WHERE codigo LIKE (SELECT VALUE FROM PM_PARAMETER WHERE CODE LIKE 'COD_CORP')" 
    Set oRsCorp = Server.CreateObject("ADODB.Recordset")
    oRsCorp.Open strSQL, oConn
    if oRsCorp.eof then
        wIdCorp = 0
	else
		wIdCorp = clng(oRsCorp("fb_uea_pe_id"))
    end if 
	
	UEA_Aux = clng(wId_Unidad)
	
	If wIdCorp = UEA_Aux then
		If wId_Sedes = "" then
			wId_Unidad = "0"
		Else
			wId_Unidad = wId_Sedes
		End If
	end if
	
	
	Mensaje = Application("MessageManager").Item("anno")
  response.write "Hola"  & " " & Mensaje
  'response.end

 %>

<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="es-co">
<!--<![endif]-->

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">	


<style>
.loader {
    position: fixed;
    left: 0px;
    top: 0px;
    width: 100%;
    height: 100%;
    z-index: 9999;
    background: url('images/pageLoader.gif') 50% 50% no-repeat rgb(249,249,249);
    opacity: 1;
}
</style>


<link href="assets/plugins/sidebar/style3.css" rel="stylesheet" />




  <link href="assets/plugins/jquery-ui/themes/base/minified/jquery-ui.min.css" rel="stylesheet" />
	<link href="assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
	<link href="assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
	<!-- link href="assets/css/animate.min.css" rel="stylesheet" />   -->
	<link href="assets/css/style.min.css" rel="stylesheet" />   <!-- Estilos propios de la Pagina -->
	<link href="assets/css/style-responsive.min.css" rel="stylesheet" />
	<link href="css/jquery.mCustomScrollbar.css" rel="stylesheet" />
	
	<link href="css/bootstrap-toggle.min.css" rel="stylesheet" />
  <link href="assets/plugins/lightpick/lightpick.css" rel="stylesheet" />
  <link href="assets/plugins/switcher/checkbox.min.css" rel="stylesheet" />
  
	
	<link href="http://ionicons.com/css/ionicons.min.css?v=2.0.1" rel="stylesheet" />
	<link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" />
	<link href="https://www.jqueryscript.net/demo/Classic-Growl-like-Notification-Plugin-For-jQuery-Gritter/css/jquery.gritter.css" rel="stylesheet" />
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAkKC2qMimEQ05wpOg3b0-lMr9cK9hpmYo&v=3&ext=.js"></script>
  <script src="js/markerclusterer.js"></script>	

	
<!--    <script src="assets/plugins/jquery/jquery-1.9.1.min.js"></script> -->
<!--    <script src="assets/plugins/jquery/jquery-migrate-1.1.0.min.js"></script> -->
  <script src="js/jquery-1.12.4.min.js"></script>
<!--	<script src="js/jquery-3.1.1.min.js"></script> -->
  <script src="assets/plugins/jquery-ui/ui/minified/jquery-ui.min.js"></script>
  <script src="assets/plugins/jquery-cookie/jquery.cookie.js"></script>
  <script src="assets/plugins/bootstrap/js/bootstrap.min.js"></script>    
  <script src="assets/plugins/chart-js/Chart.bundle.min.js"></script>
<!--    <script src="js/jquery.mCustomScrollbar.concat.min.js"></script> -->
	
	<script src="../HighCharts_6_7/highcharts.js"></script>
	<script src="../HighCharts_6_7/modules/no-data-to-display.js"></script>
	<script src="../HighCharts_6_7/modules/exporting.js"></script>
<script src="../HighCharts_6_7/js/modules/pareto.js"></script>
    <script  src="js/wait_indicator.js"></script>
    
    <script  src="js/bootstrap-toggle.min.js"></script>
	
	<!--<script src="js/modal.js"></script>-->
<!-------------------------------------------------------------------------------->
<script src="assets/plugins/lightpick/moment.min.js"></script>
<script src="assets/plugins/lightpick/lightpick.js"></script>
<script src="https://www.jqueryscript.net/demo/Classic-Growl-like-Notification-Plugin-For-jQuery-Gritter/js/jquery.gritter.js"></script>

<!-------------------------------------------------------------------------------->


<link href="../data-table2/css/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="../data-table2/css/fixedColumns.bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="../data-table2/css/buttons.dataTables.min.css" rel="stylesheet" type="text/css" />


<!--
    <script src="assets/js/Chart.PieceLabel.js"></script>
    <script src="assets/plugins/flot/jquery.flot.min.js"></script>
    <script src="assets/plugins/flot/jquery.flot.time.min.js"></script>
    <script src="assets/plugins/flot/jquery.flot.resize.min.js"></script>
    <script src="assets/plugins/flot/jquery.flot.pie.min.js"></script>
    <script src="assets/plugins/sparkline/jquery.sparkline.js"></script>
    <script src="assets/plugins/jquery-jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="assets/plugins/jquery-jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <script src="assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
-->

<script src="../data-table2/js/jquery.dataTables.min.js"></script>
	<script src="../data-table2/js/dataTables.bootstrap.min.js"></script>            
    <script src="../data-table2/js/dataTables.fixedColumns.min.js"></script>
	
    <script src="../data-table2/js/dataTables.buttons.min.js"></script>
    <script src="../data-table2/js//buttons.flash.min.js"></script>
    <script src="../data-table2/js/jszip.min.js"></script>
    <script src="../data-table2/js/pdfmake.min.js"></script>
    <script src="../data-table2/js/vfs_fonts.js"></script>
    <script src="../data-table2/js/buttons.html5.min.js"></script>
    <script src="../data-table2/js/buttons.print.min.js"></script>

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

// Configuración data table
/*inicio Lenguage español */
		var idioma_espanol ={
			"sProcessing":     "Procesando...",
			"sLengthMenu":     "Mostrar _MENU_ registros",
			"sZeroRecords":    "No se encontraron resultados",
			"sEmptyTable":     "Ningún dato disponible en esta tabla",
			"sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
			"sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
			"sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
			"sInfoPostFix":    "",
			"sSearch":         "Buscar:",
			"sUrl":            "",
			"sInfoThousands":  ",",
			"sLoadingRecords": "Cargando...",
			"oPaginate": {
				"sFirst":    "Primero",
				"sLast":     "Último",
				"sNext":     "Siguiente",
				"sPrevious": "Anterior"
			},
			"oAria": {
				"sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
				"sSortDescending": ": Activar para ordenar la columna de manera descendente"
			}
		}
		/*fin Lenguage español */

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
                Response.write "<script type='text/javascript' src='./js/" & file_js & wConector & "Empresa=" & wEmpresa & "&Id_Unidad=" & wId_Unidad & "&Id_Usuario=" & wId_Usuario  & "&Anno=" & wAnno &  "&Codigo=" & oRsPortlet("codigo") & "&inicio=" & fechas(0) & "&fin=" & fechas(1) &"'></script>" & NL
			end if
			if oRsPortlet("file_CSS") <> "" then
                Response.write "<link href='css/" & oRsPortlet("file_CSS") & "' rel='stylesheet' />" & NL
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
			noData: 'No hay datos para mostrar',
			decimalPoint: '.',
			thousandsSep: ','
		}
	});
	
	// Times New Roman
	Highcharts.setOptions({
		chart: {
			style: {
				fontFamily: 'Times New Roman',
				fontSize: '14px'
			}
		}
    });
	
	// issue is fixed since Highcharts v6.1.1.
	Highcharts.wrap(Highcharts.Axis.prototype, 'getPlotLinePath', function(proceed) {
		var path = proceed.apply(this, Array.prototype.slice.call(arguments, 1));
		if (path) {
			path.flat = false;
		}
		return path;
	});
	
	// Configuracion de Colores
	Highcharts.setOptions({
		colors: ['rgb(75, 192, 192)','rgb(255, 159, 64)','rgb(47, 200, 30)','rgb(255, 99, 132)','rgb(54, 162, 235)','rgb(153, 102, 255)','rgb(201, 203, 207)']
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

 #tbody_table tr td{
     vertical-align: middle;
 }
 
.label-side-bar {
  color: white;
  padding: 8px;
  padding-left: 20px;
}

</style>

<script>
    function ActualizaFormulario()  {
        document.body.style.cursor = 'wait';
		
        document.getElementById("frm_Home").submit();
    }
	
	function reloadPage() {
		var sedes = getSedes()
		
		var url = "<%="\Home_plantilla_v2.asp?Id_Home=" & wId_Home & "&Id_Usuario=" & wId_Usuario & "&Id_Unidad=" & UEA_Aux & "&Empresa=" & wEmpresa & "&Estado=" & Estado & "&anno=" & wAnno & "&datepicker=" & datepicker & "&busqueda=" & busqueda & "&Id_Sedes=" %>" + sedes
	    window.location = url;
	}
</script>

</head>

<body> 

<div class="loader"></div>

<div class="wrapper">
<nav id="sidebar">
  <div id="dismiss">
      <i class="glyphicon glyphicon-arrow-left"></i>
  </div>
 <%If wIdCorp = UEA_Aux then%>
  <div class="sidebar-header">
      <h3>Lista de Sedes</h3>
  </div>
  
  
  <button type="button" class="btn btn-info navbar-btn" onClick="reloadPage()">
	  <i class="glyphicon glyphicon-align-left"></i>
	  <span>Cargar</span>
  </button>
 

  <ul class="list-unstyled components">
              <% NL = chr(13) & chr(10)
					  strSQL = "SELECT stored_procedure_sedes"
					  strSQL = strSQL & " FROM fb_home"
					  strSQL = strSQL & " WHERE fb_home_id = " & wId_Home & " AND is_deleted = 0"
						
					  Set wRsSP = Server.CreateObject("ADODB.recordset")
					  wRsSP.Open strSQL, oConn
					  wS_P = wRsSP("stored_procedure_sedes") & " '" & fechas(0) & "','" & fechas(1) & "'"
					  
					  wRsSP.Close
					  
                      Set wS = Server.CreateObject("ADODB.recordset")
                      wS.Open wS_P, oConn

                      Do While Not wS.Eof
							color = "rojo"
							
							If wId_Unidad = "0" Then
								color = "verde"
							Else
								For Each i In Split(wId_Sedes,"-")
									If cdbl(i) = cdbl(wS("fb_uea_pe_id")) Then
									   color = "verde"
									End If
								Next
							End If
														
                            Response.write " <li><div  class='row vertical'><div class='col-xs-9'><label for='switch_"& wS("fb_uea_pe_id") &"'>"& wS("nombre") &"</label></div><div class='col-xs-2'><label class='el-switch el-switch-green ' ><input id='switch_"& wS("fb_uea_pe_id") & "' value='" & wS("fb_uea_pe_id") & "' onclick='estadoSede("""& wS("fb_uea_pe_id") &"""," & wS("fb_uea_pe_id") & ")' type='checkbox'  name='switch'><span class='el-switch-style " & color &"' id='boton_"& wS("fb_uea_pe_id") &"'></span></label></div></div></li>" & NL
                            wS.MoveNext
              Loop
              %>
  </ul>
 <%Else%>
  <div class="sidebar-header">
      <h3>Filtros</h3>
   </div>
   
   <%
		wSQLC = "SELECT fb_cliente_id, nombre FROM fb_cliente WHERE is_deleted = 0"
		Set wRsCliente = Server.CreateObject("ADODB.recordset")
		wRsCliente.CursorLocation = 3
		wRsCliente.CursorType = 2
		wRsCliente.Open wSQLC, oConn,1,1
		
		If IsNull(wCliente) OR wCliente = "" then
			wCliente = 0
		End If
   %>
   
	<br>
		<div class="row">
						<div class="form-group col-md-12">
                            <form class="form-horizontal ">
								 <div class="form-group">
                                    <label class="col-md-4 label-side-bar">Cliente:</label>
                                    <div class="col-md-8">
                                        <%
											'Render them in drop down box Residuo
											Response.write "<select name='Cliente' id='Cliente' class='form-control side-bar-filter'>"
											if cdbl(wCliente) = 0 then
												Response.Write "<option value='0' selected> TODOS </option>"
											else
												Response.Write "<option value='0'> TODOS </option>"
											end if
											While not wRsCliente.EOF
												if cdbl(wCliente) = cdbl(wRsCliente("fb_cliente_id")) then
													Response.Write "<option value='" & wRsCliente("fb_cliente_id") & "' selected>" & wRsCliente("nombre") & " </option>"
												else
													Response.Write "<option value='" & wRsCliente("fb_cliente_id") & "'>" & wRsCliente("nombre") & " </option>"
												end if
												wRsCliente.MoveNext()
											Wend
											Response.write "</select>"
										%>
                                    </div>
                                </div>
                            </form>
                        </div>
		</div>
   
   <button type="button" class="btn btn-info navbar-btn" onClick="update_portlets()">
	  <i class="glyphicon glyphicon-align-left"></i>
	  <span>Filtrar</span>
  </button>

   <ul class="list-unstyled components">
              <% NL = chr(13) & chr(10)
                			wHP_P = "SELECT p.codigo,p.titulo"
                      wHP_P = wHP_P & " FROM fb_portlet p "
                      wHP_P = wHP_P & " inner  join fb_home_portlet hp on p.fb_portlet_id = hp.fb_portlet_id "
                      wHP_P = wHP_P & " WHERE hp.fb_home_id = '" & wId_Home & "'and hp.is_deleted = 0 and p.is_deleted = 0"
                      
                      Set wRHP = Server.CreateObject("ADODB.recordset")
                      wRHP.Open wHP_P, oConn

                      Do While Not wRHP.Eof
                                Response.write " <li><div  class='row vertical'><div class='col-xs-9'><label for='switch_"& wRHP("codigo") &"'>"& wRHP("titulo") &"</label></div><div class='col-xs-2'><label class='el-switch el-switch-green ' ><input id='switch_"& wRHP("codigo") &"' onclick='estado("""& wRHP("codigo") &""")' type='checkbox'  name='switch'><span class='el-switch-style verde' id='boton_"& wRHP("codigo") &"'></span></label></div></div></li>" & NL
                            wRHP.MoveNext
              Loop
              %>
   </ul>
 <%End If%>
</nav>

<div id="content">
<div style=" width: 100%;">     	
    <div class="panel panel-info" id="cabecera-anio">
              <div class="panel-heading" >
                <form id="frm_Home" class="form-horizontal" method="post" action="Home_Plantilla_v3.asp">
                    <input type="hidden" name="Empresa" value="<%=wEmpresa%>" />
                    <input type="hidden" name="Id_Unidad" value="<%=UEA_Aux%>" />
                    <input type="hidden" name="Id_Usuario" value="<%=wId_Usuario%>" />
                    <input type="hidden" name="Id_Home" value="<%=wId_Home%>" />
					<input type="hidden" name="Estado" value="<%=Estado%>" />
					<input type="hidden" name="Id_Sedes" value="<%=wId_Sedes%>" />

                  <div class="form-group row ">


                  <div class="col-xs-4" id="opc-rango">
                      <label for="opt1" class="radio col-xs-1">
                        <input type="radio" value="rango" <% if busqueda="rango" then Response.write("checked") end if%>  name="busqueda" id="opt1" class="hidden" onclick="validarData()"/>
                        <span class="label"></span>
                      </label>
                      <label class="control-label text-left text-white col-xs-1" style="padding: 8px 0">Rango:</label>
                      <div class="col-xs-8">
                        <input type="text" id="datepicker" name="datepicker" class="form-control form-control-sm"/>
                      </div>
                  </div>



                  
           

                    <div class="col-xs-4">
                      <label for="opt2" class="radio col-xs-1">
                        <input type="radio" name="busqueda" value="anio" id="opt2" class="hidden" onclick="validarData()" <% if busqueda="anio" then Response.write("checked") end if%>/>
                        <span class="label"></span>
                      </label>
                      <label class="control-label text-left text-white col-xs-1" style="padding: 8px 0" for="Anno">A&ntilde;o:&nbsp; <%=tIdioma("anno",1)%></label>

                      <div class="col-xs-4">
                        <%
                            'Render them in drop down box A�o
                            Response.write "<select name='Anno' id='Anno' class='form-control' onchange='validarData()'>"
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
                


				<div class="navbar-header">
						<button type="button" id="sidebarCollapse" class="btn btn-info navbar-btn">
							<i class="glyphicon glyphicon-align-left"></i>
							<%If wIdCorp = UEA_Aux then%>
							 <span>Lista de Sedes</span>
							<%Else%>
							 <span>Filtros</span>
							<%End If%>
						</button>
						

				  </div>



				  <script type="text/javascript">
                 function validarData() {
                        busqueda = $('input:radio[name=busqueda]:checked').val()
                        rango = document.getElementById('datepicker').value
						
                      //Valida que la fecha se halla puesto inicio y fin
                        if (rango.length < 23 && busqueda == 'rango') {
                          $.gritter.add({
                            title: 'Error en fechas',
                            text: 'El formato del rango debe ser DD/MM/AAAA - DD/MM/AAAA',
                            sticky: false,
                            time: '3000'
                          });
                          return false;
                        }
						
						var hidden = document.createElement("input");
						hidden.type = "hidden";
						hidden.name = "Cliente";
						hidden.value = document.getElementById("Cliente").value;
						var f = document.getElementById("frm_Home");
						f.appendChild(hidden);
						
                        document.getElementById("frm_Home").submit();
				  };
                  $(document).ready(function()
                    {
                    
                      var start = "<%=fechas(0)%>"
                      var fin = "<%=fechas(1)%>"
                      
                      if (start == "anio"){
                        start = moment().startOf('month').add(7, 'day')
                        fin = moment().startOf('month').add(7, 'day')
                      }
                      var picker = new Lightpick({
                        field: document.getElementById('datepicker'),
                        singleDate: false,
                        onClose:function(){
                             validarData()
                          },
                        startDate: start,
                        endDate: fin,
                        onSelect: function(start, end){
                            var str = '';
                            str += start ? start.format('Do MMMM YYYY') + ' to ' : '';
                            str += end ? end.format('Do MMMM YYYY') : '...';
                        }
                    });

                    });

                </script>
                  </div>
              </form>
            </div>
      </div>
   
		<!-- end #header -->

    	<!-- begin #page-container -->
	<div id="page-container" >

		<!-- begin #content -->
		<div id=""> 
 		
<!-- INICIO PANEL CUADROS  -->
<%
  wFila = 0
  oRsPortlet.MoveFirst
  Do While Not oRsPortlet.Eof
    if oRsPortlet("Orden_Fila") <> wFila then
        if wFila <> 0 then Response.write "</div>"
        Response.write "<div class=''>"
        wFila = oRsPortlet("Orden_Fila")
    end if

    Select Case  oRsPortlet("ancho") 
        Case 3 
            wclass = "col-lg-3 col-md-3 col-sm-6 col-xs-12 menu_" & oRsPortlet("codigo")
        Case 4 
            wclass =  "col-lg-4 col-md-4 col-sm-6 col-xs-12 menu_" & oRsPortlet("codigo")
        Case 6 
            wclass = "col-lg-6 col-md-6 col-sm-6 col-xs-12 menu_" & oRsPortlet("codigo")
        Case 8 
            wclass = "col-lg-8 col-md-8 col-sm-6 col-xs-12 menu_" & oRsPortlet("codigo")
        Case 10 
            wclass = "col-lg-10 col-md-10 col-sm-12 col-xs-12 menu_" & oRsPortlet("codigo")
        Case 12 
            wclass = "col-lg-12 col-md-12 menu_" & oRsPortlet("codigo")
        Case Else
            wclass = "menu_" & oRsPortlet("codigo") & " col-md-" & oRsPortlet("ancho") 
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
            <button type="button" class="btn-icon btn-circle btn btn-info btn-sm" data-toggle="modal" onclick="" data-target="#Modal_<%=oRsPortlet("codigo")%>"><i class="fa fa-question fa-xs"></i> </button>

			<%If UCASE(oRsPortlet("tipo")) = "TABLE" then %>
                <button type="button" class="btn-icon btn-circle btn btn-warning btn-sm" onclick="tableToExcel('<%=oRsPortlet("codigo")%>', '<%=oRsPortlet("titulo")%>')" ><i class="fa fa-download fa-xs"></i> </button>
			<%End If%>
			<%If UCASE(oRsPortlet("tipo")) = "DYN_HCHART" then %>
                <button type="button" class="btn-icon btn-circle btn btn-warning btn-sm" onclick="formulario('formularios_<%=oRsPortlet("codigo")%>')" ><i class="fa fa-filter fa-xs"></i> </button>
			<%End If%>
			
			<%If ((UCASE(oRsPortlet("tipo")) = "HCHART") or (UCASE(oRsPortlet("tipo")) = "DYN_HCHART")) then %>
                <button type="button" class="btn-icon btn-circle btn btn-warning btn-sm" onclick="toggle('canvas_<%=oRsPortlet("codigo")%>')" ><i class="fa fa-tag fa-xs"></i> </button>
			<%End If%>
        </div>
        <h4 class="panel-title"><%=oRsPortlet("titulo")%></h4>
        </div>
    <%End if%>

       <%if UCASE(oRsPortlet("tipo")) = "HCHART"  then %>
		<div class="xcontenido full-width-box" data-mcs-theme="dark-thick" style="height:  <%=oRsPortlet("altura")%>;" >
            <%
              Session("Empresa") = wEmpresa
              Session("Id_Unidad") = wId_Unidad
              Session("Id_Usuario") = wId_Usuario
              Session("Anno") = wAnno
              Session("ultAnno") = wUltAnno
              Session("Codigo") = oRsPortlet("codigo")
              Session("inicio")=fechas(0)
              Session("fin")=fechas(1)
              Session("busqueda") = busqueda
              %>
            <div id="canvas_<%=oRsPortlet("codigo")%>" style="height:100%; width:100%;"></div> <!-- mache -->
		</div>
       <%End if%>
	   
	   <%if UCASE(oRsPortlet("tipo")) = "CHART"  then %>
		<div class="contenido full-width-box" data-mcs-theme="dark-thick" style="height: <%=oRsPortlet("altura")%>" >
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
	   <%if UCASE(oRsPortlet("tipo")) = "DATATABLE" then %>
		<div class="contenido" data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >
	   <%
            Session("Empresa") = wEmpresa
            Session("Id_Unidad") = wId_Unidad
            Session("Id_Usuario") = wId_Usuario
            Session("Anno") = wAnno
			Session("Mes") = wMes
			Session("Codigo") = oRsPortlet("codigo")
			Session("ultAnno") = wUltAnno
			Session("inicio")=fechas(0)
			Session("fin")=fechas(1)
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
                            <div data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>">
		
                                <div class="contenido-dyn">
                                <%
                                    Session("Empresa") = wEmpresa
                                    Session("Id_Unidad") = wId_Unidad
                                    Session("Id_Usuario") = wId_Usuario
                                    Session("Anno") = wAnno
                                    Session("ultAnno") = wUltAnno
                                    Session("Codigo") = oRsPortlet("codigo")
                                    Session("inicio")=fechas(0)
                                    Session("fin")=fechas(1)
                                    Session("busqueda") = busqueda
                                    
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
	
</div>
</div>
</div>
<div class="overlay"></div>
    <script src="assets/js/apps.min.js"></script>
        <!-- jQuery Custom Scroller CDN -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>

        <script type="text/javascript">
            $(document).ready(function () {
                 $(".loader").fadeOut("slow");


                $("#sidebar").mCustomScrollbar({
                    theme: "minimal"
                });
				
                $('#dismiss, .overlay').on('click', function () {
                    $('#sidebar').removeClass('active');
                    $('.overlay').fadeOut();
                });

                $('#sidebarCollapse').on('click', function () {
                    $('#sidebar').addClass('active');
                    $('.overlay').fadeIn();
                    $('.collapse.in').toggleClass('in');
                    $('a[aria-expanded=true]').attr('aria-expanded', 'false');
                });
				
            });
        </script>
	<!-- ================== END PAGE LEVEL JS ================== -->
	
	
	<script type="text/javascript">
	
	var tableToExcel = (function() {
		  var uri = 'data:application/vnd.ms-excel;base64,'
			, template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--><meta http-equiv="content-type" content="text/plain; charset=UTF-8"/></head><body><table>{table}</table></body></html>'
			, base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) }
			, format = function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
		  return function(table, name) {
			if (!table.nodeType) table = document.getElementById(table)
			//var tab = $(table).DataTable();
			//var header =  $(table).DataTable().table().header();
			//console.log(header);
			//console.log(table.innerHTML);
			//var ctx = {worksheet: name || 'Worksheet', table: header};
			var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML.replace(/<\s*a[^>]*>/gi,'')}
			var link = document.createElement("a");
			link.download = name + ".xls";
			link.href = uri + base64(format(template, ctx));
			link.click();
		  }
		})()
	</script>
		
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
function formulario(canvasid){
    var chartDom = document.getElementById(canvasid);
    var prueba = chartDom.classList.contains("ocultar_formulario")
    if (prueba) {
      chartDom.classList.replace('ocultar_formulario','mostrar_formulario')
    }else{
      chartDom.classList.replace('mostrar_formulario','ocultar_formulario')
    }

        

}

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

$(window).resize(function () {
    if ($('.modal.in').length != 0) {
        setModalMaxHeight($('.modal.in'));
    }
	<% 
		oRsPortlet.MoveFirst
		Do While Not oRsPortlet.Eof
		 If UCASE(oRsPortlet("Tipo"))="DYN_HCHART" then
	%>
		resize_<%=oRsPortlet("codigo")%>();
	<% 	
		  End If
			oRsPortlet.MoveNext
		Loop
	%>
	
	/* 
	var chartDom = document.getElementById('canvas_FIS_SUP_HAL_EST');
	var chart = Highcharts.charts[Highcharts.attr(chartDom, 'data-highcharts-chart')]

    console.log(chart.containerWidth / 30);

    chart.subtitle.update({
      style: {
        fontSize: Math.round(chart.containerWidth / 30) + "px"
      }
    });
	*/
});		
	/*
	(function($){
        $(window).on("load",function(){
            $(".content").mCustomScrollbar();
        });
    })(jQuery);
	
  */
  
	</script>
  <script>
  function estado(est){
    if ($( "#boton_"+est ).hasClass('verde')){
        $( "#boton_"+est ).removeClass('verde')
        $( "#boton_"+est ).addClass('rojo')
        $( ".menu_"+est ).addClass('hidden')
    }else{
        $( "#boton_"+est ).removeClass('rojo')
        $( "#boton_"+est ).addClass('verde')
        $( ".menu_"+est ).removeClass('hidden')
    }
  }
  
  function estadoSede(est,id){
	if ($( "#boton_"+est ).hasClass('verde')){
        $( "#boton_"+est ).removeClass('verde')
        $( "#boton_"+est ).addClass('rojo')
    }else{
        $( "#boton_"+est ).removeClass('rojo')
        $( "#boton_"+est ).addClass('verde')
    }
	//var chk = document.getElementById("switch_"+est)
    //chk.value = chk.checked ? id : 0;
  }
  
  function getSedes(){
	var sedes = ""
	
	var inputs = document.querySelectorAll("[id^=switch_][type='checkbox']")
	var switches = document.querySelectorAll("[id^=boton_]")
	
	for(var i = 0; i < inputs.length; i++) {
		if(switches[i].classList.contains('verde')){
			sedes = sedes + "-" + inputs[i].value
		}
	}
	
	if (sedes == ""){
		sedes = "0"
	}
	else{
		sedes = sedes.substr(1);
	}
	
	return sedes
  }
  
  function update_portlets(){
	<%
	  wHP_P2 = "SELECT p.codigo,p.titulo"
	  wHP_P2 = wHP_P2 & " FROM fb_portlet p "
	  wHP_P2 = wHP_P2 & " inner  join fb_home_portlet hp on p.fb_portlet_id = hp.fb_portlet_id "
	  wHP_P2 = wHP_P2 & " WHERE hp.fb_home_id = '" & wId_Home & "'and hp.is_deleted = 0 and p.is_deleted = 0"
	  
	  Set wRHP2 = Server.CreateObject("ADODB.recordset")
	  wRHP2.Open wHP_P2, oConn

	  Do While Not wRHP2.Eof
		Response.write "update_"& wRHP2("codigo") & "();" & NL
		wRHP2.MoveNext
	  Loop
	%>
  }

    //var picker = new Lightpick({ field: document.getElementById('datepicker') });
</script>
<style>
#precarga {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #fff;
  z-index: 9999;
}

.ocultar_formulario{
  max-height: 0px;
  display: flow-root;
  transition: max-height 0.2s ease-out;

}
.mostrar_formulario{
    max-height: 300px;
    display: flow-root;
    transition: max-height 0.2s ease-in;

}
.ocultar_portlet{
  max-height: 0px;
  display: flow-root;
  transition: max-height 0.2s ease-out;

}
.mostrar_portlet{
    max-height: 600px;
    display: flow-root;
    transition: max-height 0.2s ease-in;

}
@-webkit-keyframes slide-down {
      0% { opacity: 0; }   
    100% { opacity: 1; }
}
@-moz-keyframes down {
      0% { opacity: 1; }
      100% { opacity: 0; }   
    
}

body {
  font-family: "Roboto", sans-serif;
}
.radio {
  position: relative;
  cursor: pointer;
  line-height: 20px;
  font-size: 14px;
  margin: 15px;
  width: 27px;
  padding: 6px !important;
}
.radio .label {
  position: relative;
  padding: 7px;
  display: block;
  float: left;
  margin-right: 10px;
  width: 20px;
  height: 20px;
  border: 2px solid #c8ccd4;
  border-radius: 100%;
  -webkit-tap-highlight-color: transparent;
}
.radio .label:after {
  content: '';
  position: absolute;
  top: 3px;
  left: 3px;
  width: 10px;
  height: 10px;
  border-radius: 100%;
  background: #ffcd56;
  transform: scale(0);
  transition: all 0.2s ease;
  opacity: 0.08;
  pointer-events: none;
}
.radio:hover .label:after {
  transform: scale(3.6);
}
input[type="radio"]:checked + .label {
  border-color: #ff9f40;
}
input[type="radio"]:checked + .label:after {
  transform: scale(1);
  transition: all 0.2s cubic-bezier(0.35, 0.9, 0.4, 0.9);
  opacity: 1;
}
.cntr {
  
  top: calc(50% - 10px);
  left: 0;
  width: 100%;
  text-align: center;
}
.hidden {
  display: none;
}
.credit {
  position: fixed;
  right: 20px;
  bottom: 20px;
  transition: all 0.2s ease;
  -webkit-user-select: none;
  user-select: none;
  opacity: 0.6;
}
.credit img {
  width: 72px;
}
.credit:hover {
  transform: scale(0.95);
}
.p-15, .wrapper{

}
#sidebarCollapse{
  position: absolute;
  right: 25px;
  top: 1px;
  background: #91979c;
  border-color: #666b6d;
}



.panel-body{
  padding: 0px !important;
}

.vertical{
  display: flex;
  align-items: center;
  border-bottom: 0.5px solid #4a4a4a

}
#sidebar ul .vertical:hover {
    color: #ffffff;
    background: #2d7d7d;
}
#sidebar ul .vertical:hover label,#sidebar ul .vertical:hover {
    color: #ffffff;
    background: #2d7d7d;
}

#sidebar ul li a.activado{
    background: #036f01 !important;
    margin-right: 10px;
    text-align: center;
    color: white;
}

#sidebar ul li a.desactivado{
    background: #ab2823 !important;
    margin-right: 10px;
    text-align: center;
    color: white;
}
#sidebar ul.components{
  border-bottom:0px;
}
#sidebar ul li span{
  position: absolute;
}



.rojo{
  background: #a59897 !important
}
.verde{
  background: #25bf2b !important;
}
#cabecera-anio{
  margin-left: 15px;
  margin-right: 15px;
}
#content{
  padding: 0px;

}
#sidebar ul li label{
  font-size: 11px;
  font-weight: 100;
}




label.menu-open-button {
    z-index: 932;
    -webkit-transition-timing-function: cubic-bezier(.175,.885,.32,1.275);
    transition-timing-function: cubic-bezier(.175,.885,.32,1.275);
    -webkit-transition-duration: .4s;
    transition-duration: .4s;
    cursor: pointer;
    margin: 0;
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-align: center;
    -ms-flex-align: center;
    align-items: center;
    -webkit-box-pack: center;
    -ms-flex-pack: center;
    justify-content: center;
}
.menu-item, .menu-open-button {
    font-size: 16px;
}
.menu-item, .menu-open-button {
    background: #886ab5;
    border-radius: 50%;
    width: 45px;
    height: 45px;
    position: absolute!important;
    padding: 0;
    right: 0;
    bottom: 0;
    color: #fff!important;
    text-align: center;
    line-height: 45px;
    -webkit-transform: translate3d(0,0,0);
    transform: translate3d(0,0,0);
    -webkit-transition: -webkit-transform ease-out .2s;
    transition: -webkit-transform ease-out .2s;
    transition: transform ease-out .2s;
    transition: transform ease-out .2s, -webkit-transform ease-out .2s;
    -webkit-box-shadow: 0 1px 10px rgba(0,0,0,.05), 0 1px 2px rgba(0,0,0,.1);
    box-shadow: 0 1px 10px rgba(0,0,0,.05), 0 1px 2px rgba(0,0,0,.1);
}
[role=button], a, area, button, input, label, select, summary, textarea {
    -ms-touch-action: manipulation;
    touch-action: manipulation;
}
.waves-effect {
    position: relative;
    cursor: pointer;
    display: inline-block;
    overflow: hidden;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    -webkit-tap-highlight-color: transparent;
}
.menu-item, .menu-open-button {
    background: #886ab5;
    border-radius: 50%;
    width: 45px;
    height: 45px;
    position: absolute!important;
    padding: 0;
    right: 0;
    bottom: 0;
    color: #fff!important;
    text-align: center;
    line-height: 45px;
    -webkit-transform: translate3d(0,0,0);
    transform: translate3d(0,0,0);
    -webkit-transition: -webkit-transform ease-out .2s;
    transition: -webkit-transform ease-out .2s;
    transition: transform ease-out .2s;
    transition: transform ease-out .2s, -webkit-transform ease-out .2s;
    -webkit-box-shadow: 0 1px 10px rgba(0,0,0,.05), 0 1px 2px rgba(0,0,0,.1);
    box-shadow: 0 1px 10px rgba(0,0,0,.05), 0 1px 2px rgba(0,0,0,.1);
}
.btn {
    display: inline-block;
    font-weight: 400;
    color: #212529;
    text-align: center;
    vertical-align: middle;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    background-color: transparent;
    border: 1px solid transparent;
    padding: .5rem 1.125rem;
    line-height: 1.47;
    border-radius: 4px;
    -webkit-transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,-webkit-box-shadow .15s ease-in-out;
    transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,-webkit-box-shadow .15s ease-in-out;
    transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out;
    transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out,-webkit-box-shadow .15s ease-in-out;
}
.shortcut-menu {
    position: fixed;
    right: 1.5rem;
    bottom: 4.3125rem;
    z-index: 931;
}
#menu_open {
    background-color: initial;
    cursor: default;
    -webkit-appearance: checkbox;
    box-sizing: border-box;
    margin: 3px 3px 3px 4px;
    padding: initial;
    border: initial;
}

input {
    -webkit-writing-mode: horizontal-tb !important;
    text-rendering: auto;
    color: initial;
    letter-spacing: normal;
    word-spacing: normal;
    text-transform: none;
    text-indent: 0px;
    text-shadow: none;
    display: inline-block;
    text-align: start;
    -webkit-appearance: textfield;
    background-color: white;
    -webkit-rtl-ordering: logical;
    cursor: text;
    margin: 0em;
    font: 400 13.3333px Arial;
    padding: 1px 0px;
    border-width: 2px;
    border-style: inset;
    border-color: initial;
    border-image: initial;
}


</style>
<%  
if Estado = 1 then 
wURLHome = "\Home_plantilla.asp?Id_Home=1&"  & "Id_Usuario=" & wId_Usuario & "&Id_Unidad=" & UEA_Aux & "&Empresa=" & wEmpresa
%>
<nav class="shortcut-menu d-none d-sm-block">
    
    <a  class="menu-open-button "  onClick="window.location='<%=wURLHome %>';">
        <span class="fa fa-times"></span>
    </a>
    
  </nav>
<%  end if %>
</body>

</html>

