
<%@ Language=VBScript %>
<!-- #INCLUDE FILE="../includes/Connection_inc.asp" -->
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
' 14/05/2020                Valky Salinas              Se agregó un nuevo tipo de portlet datatable y se agregaron estilos y librerías para su 
'                                                      funcionamiento correcto.
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
	Response.CodePage = 65001
	Response.CharSet = "UTF-8"

    wEmpresa = Request("Empresa")
    wId_Unidad = Request("Id_Unidad")
	wId_Usuario = Request("Id_Usuario")
    wId_Home = Request("Id_home")
    wAnno = Request("Anno")
	wMes = Request("Mes")
	wTipoInc = Request("Tipo_Incidencia")
	wAmbito = Request("Ambito")
	
	
	if wAmbito = "" then wAmbito = 0
	
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
	
'Lista de Tipos'
	strSQL = "SELECT inc_tipo_incidencia_id, nombre, orden"
	strSQL = strSQL & " FROM inc_tipo_incidencia"
	strSQL = strSQL & " WHERE is_deleted = 0"
	strSQL = strSQL & " UNION"
	strSQL = strSQL & " SELECT 0,'** Todos **',0"
	strSQL = strSQL & " ORDER BY orden ASC"
	
	Set wRsTI = Server.CreateObject("ADODB.recordset")
	wRsTI.Open strSQL, oConn
	
	if wTipoInc = "" then wTipoInc = wRsTI("inc_tipo_incidencia_id")


'Selecciona los Portlets del Home
    strSQL = "pr_HOME_RecuperaPortles '" & wId_Home & "'" 
    Set oRsPortlet = Server.CreateObject("ADODB.Recordset")
    oRsPortlet.Open strSQL, oConn
    if oRsPortlet.eof then
        wError = "1"
        Response.Write "<span align=center ><b>No hay Portlets definidos para esta pagina</b></span>"
        Response.end
    end if 


 %>

<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="es-co">
<!--<![endif]-->

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">	

    <link href="assets/plugins/jquery-ui/themes/base/minified/jquery-ui.min.css" rel="stylesheet" />
	<link href="assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
	<link href="assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
	<!-- link href="assets/css/animate.min.css" rel="stylesheet" />   -->
	<link href="assets/css/style.min.css" rel="stylesheet" />   <!-- Estilos propios de la Pagina -->
	<link href="assets/css/style-responsive.min.css" rel="stylesheet" />
	<link href="css/jquery.mCustomScrollbar.css" rel="stylesheet" />
	
	<link href="css/bootstrap-toggle.min.css" rel="stylesheet" />
	<link href="css/style-modal.css" rel="stylesheet" />
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
	
	<script src="js/modal.js"></script>
	
    <script  src="js/bootstrap-toggle.min.js"></script>
<!-------------------------------------------------------------------------------->


<link href="../data-table2/css/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="../data-table2/css/fixedColumns.bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="../data-table2/css/buttons.dataTables.min.css" rel="stylesheet" type="text/css" />
	
  <link rel="stylesheet" type="text/css" href="./css/material.min.css">
  <link rel="stylesheet" href="./css/style-widgests.css">

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
			"sInfo":           "",//"Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
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
            if oRsPortlet("file_js") <> "" then
                  file_js = oRsPortlet("file_js")  
                  'file_js = Replace(file_js,"[UEA]",wId_Unidad)  
                  'file_js = Replace(file_js,"[EMPRESA]",wEmpresa)  
                  'file_js = Replace(file_js,"[USUARIO]",wId_Usuario)   
                  if instr(file_js,"?") > 0 then wConector = "&" else wConector = "?"
                   
                  Response.write "<script type='text/javascript' src='./js/" & file_js & wConector & "Empresa=" & wEmpresa & "&Id_Unidad=" & wId_Unidad & "&Id_Usuario=" & wId_Usuario  & "&Tipo_Incidencia=" & wTipoInc & "&Ambito=" & wAmbito &  "&Codigo=" & oRsPortlet("codigo") & "'></script>" & NL
            End if
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
			   <%If UCASE(oRsPortlet("Tipo"))="DYN_HCHART" then%>        
				   load_<%=oRsPortlet("codigo")%>()
               <%End If%>
               <%If UCASE(oRsPortlet("Tipo"))="CUSTOM" then%>        
				   load_<%=oRsPortlet("codigo")%>()
               <%End If%>
               <%If UCASE(oRsPortlet("Tipo"))="C-HUMANO" then%>        
				   load_<%=oRsPortlet("codigo")%>()
               <%End If%>
			   <%If UCASE(oRsPortlet("Tipo"))="HYBRID" then%>        
				   var ctx_<%=oRsPortlet("codigo")%> = document.getElementById('canvas_<%=oRsPortlet("codigo")%>').getContext('2d');
				   var chart_<%=oRsPortlet("codigo")%> = new Chart(ctx_<%=oRsPortlet("codigo")%>, config_<%=oRsPortlet("codigo")%>);
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

.ocultar_formulario{
  max-height: 0px;
  display: flow-root;
  transition: max-height 0.2s ease-out;

}

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

table { 
  width: 100%; 
  border-collapse: collapse; 
}

.table2>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th{
    padding: 10px 10px;
}

/* Zebra striping */
tr:nth-of-type(odd) { 
  /*background: #eee; */ 
}
th { 
 /* background: #333;  */
  font-weight: bold;
  text-align:center !important;
  display: table-cell !important;
  vertical-align: middle !important; 
}
td, th { 
  padding: 6px; 
  border: 1px solid #ccc; 
  text-align: left;
  white-space: pre; white-space: pre-line !important;
}

    
</style>

<script>
    function ActualizaFormulario() {
        document.body.style.cursor = 'wait';
        document.getElementById("frm_Home").submit();
    }
</script>

</head>

<body class="animated fadeInLeft delay-5s" style="margin-top:5px;"> 
	<!-- begin #page-loader -->

	<!-- end #page-loader -->

<div style=" width: 100%; padding-left: 1.5%; padding-right: 1.5%;">	
                	
    <div class="panel panel-info">
              <div class="panel-heading" >
                <form id="frm_Home" class="form-horizontal form-inline text-right" method="post" action="Home_Plantilla_DOM.asp">
                    <input type="hidden" name="Empresa" value="<%=wEmpresa%>" />
                    <input type="hidden" name="Id_Unidad" value="<%=wId_Unidad%>" />
                    <input type="hidden" name="Id_Usuario" value="<%=wId_Usuario%>" />
                    <input type="hidden" name="Id_Home" value="<%=wId_Home%>" />
				  
				  <div class="form-group">
                    <label class="control-label text-left text-white col-md-4" for="Tipo_Incidencia">Tipo de Incidente:&nbsp;</label>
                    <div class="col-md-2">
                    <%
                        'Render them in drop down box A�o
                        Response.write "<select name='Tipo_Incidencia' id='Tipo_Incidencia' class='form-control' onchange='ActualizaFormulario()'>"
                        While not wRsTI.EOF
                            if cdbl(wTipoInc) = cdbl(wRsTI("inc_tipo_incidencia_id")) then
                                Response.Write "<option value='" & wRsTI("inc_tipo_incidencia_id") & "' selected> " & wRsTI("nombre") & "</option>"
                            else
                                Response.Write "<option value='" & wRsTI("inc_tipo_incidencia_id") & "'>" & wRsTI("nombre") & " </option>"
                            end if
                            wRsTI.MoveNext()
                        Wend
                        Response.write "</select>"
                    %>
                    </div>
                  </div>
				  
				  <div class="form-group">
                    <label class="control-label text-left text-white col-md-4" for="Ambito">Ámbito del Incidente:&nbsp;</label>
                    <div class="col-md-2">
                        <select name='Ambito' id='Ambito' class='form-control' onchange='ActualizaFormulario()'>
							<option value='0' <%if cdbl(wAmbito) = 0 then Response.Write "selected"%>>** Todos **</option>
							<option value='1' <%if cdbl(wAmbito) = 1 then Response.Write "selected"%>>Interno</option>
							<option value='2' <%if cdbl(wAmbito) = 2 then Response.Write "selected"%>>Externo</option>
                        </select>
                    </div>
                  </div>
              </form>
            </div>
      </div>
   
		<!-- end #header -->

    	<!-- begin #page-container -->
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
			
			'** Crea los dataset como una cadena de valores separados con coma
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
			
			<%If UCASE(oRsPortlet("tipo")) = "DYN_HCHART" then %>
                <button type="button" class="btn-icon btn-circle btn btn-warning btn-sm" onclick="formulario('formularios_<%=oRsPortlet("codigo")%>')" ><i class="fa fa-filter fa-xs"></i> </button>
			<%End If%>
			
			<%If ((UCASE(oRsPortlet("tipo")) = "HCHART") or (UCASE(oRsPortlet("tipo")) = "DYN_HCHART")) then %>
                <button type="button" class="btn-icon btn-circle btn btn-warning btn-sm" onclick="toggle('canvas_<%=oRsPortlet("codigo")%>')" ><i class="fa fa-bookmark fa-xs"></i> </button>
			<%End If%>
            <%If (UCASE(oRsPortlet("tipo")) = "C-HUMANO") then %>
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
	   
	   <%if UCASE(oRsPortlet("tipo")) = "INFOBOX" then %>
	    <div class="info-box-3 ft-white mdl-color--grey-700" style="height:<%=oRsPortlet("altura")%>">
	   <%
            Session("Empresa") = wEmpresa
            Session("Id_Unidad") = wId_Unidad
            Session("Id_Usuario") = wId_Usuario
            Session("Anno") = wAnno
			Session("Mes") = wMes
			Session("Tipo_Incidencia") = wTipoInc
			Session("Ambito") = wAmbito
            wURL = oRsPortlet("file_asp")
            Server.Execute(wURL) 
	   %>
		</div>
       <% End if%>
	   
       <%if UCASE(oRsPortlet("tipo")) = "TABLE" then %>
		<div class="contenido" data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >
	   <%
            Session("Empresa") = wEmpresa
            Session("Id_Unidad") = wId_Unidad
            Session("Id_Usuario") = wId_Usuario
            Session("Anno") = wAnno
			Session("Mes") = wMes
			Session("Tipo_Incidencia") = wTipoInc
			Session("Ambito") = wAmbito
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
			Session("Tipo_Incidencia") = wTipoInc
			Session("Ambito") = wAmbito
            wURL = oRsPortlet("file_asp")
            Server.Execute(wURL) 
	   %>
		</div>
       <% End if%>
	   
        <%if UCASE(oRsPortlet("tipo")) = "CUSTOM" then %>
		<div class="contenido" data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >
	                       <div class="col-lg-12">
                    <%
                        Session("Empresa") = wEmpresa
                        Session("Id_Unidad") = wId_Unidad
                        Session("Id_Usuario") = wId_Usuario
                        Session("Anno") = wAnno
                        Session("ultAnno") = wUltAnno
                        Session("Codigo") = oRsPortlet("codigo")
						Session("Tipo_Incidencia") = wTipoInc
						Session("Ambito") = wAmbito
                        wURL = oRsPortlet("file_asp")
                        Server.Execute(wURL) 
                    %>
                    
                    </div>
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
				wURL = oRsPortlet("file_asp")
				Server.Execute(wURL) 
			%>
			</div>	
		</div>
       <%End if%>
	   
	   <%if UCASE(oRsPortlet("tipo")) = "HYBRID"  then %>
		<div class="contenido parent" data-mcs-theme="dark-thick" style="height:<%=oRsPortlet("altura")%>" >
			<div style="top:0;position:absolute;">
			<%
				Session("Empresa") = wEmpresa
				Session("Id_Unidad") = wId_Unidad
				Session("Id_Usuario") = wId_Usuario
				Session("Anno") = wAnno
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

    <script src="assets/js/apps.min.js"></script>
	<!-- ================== END PAGE LEVEL JS ================== -->
	
	<script>
		$(document).ready(function() {
			
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
});

		
	/*
	(function($){
        $(window).on("load",function(){
            $(".content").mCustomScrollbar();
        });
    })(jQuery);
	
	*/
	</script>
    	
</body>

</html>

