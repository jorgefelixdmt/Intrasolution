<%@ Language=VBScript %>
<%response.Buffer=false%>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<%
    Server.ScriptTimeout = 360
	wId_Usuario = Request("Id_Usuario")
    wEmpresa = Request("Empresa")
    wId_Unidad = Request("Id_Unidad")

'/* Lista de Años */
    strSQL = ""
    strSQL = strSQL & "Select tarea_nombre, razon_social, fecha_Inicio,Fecha_Final"
    strSQL = strSQL & " from dis_cronograma_diseno cro "
    strSQL = strSQL & " Where cro.fb_uea_pe_id = " & wId_Unidad
    strSQL = strSQL & "      and is_deleted = 0 " 
	Set oRsTareaDiseno = Server.CreateObject("ADODB.Recordset")
    oRsTareaDiseno.Open strSQL, oConn
    if oRsTareaDiseno.eof then      
        wError = "1" 
        response.write  "<span align=center ><b>No hay datos para esta Obra</b></span>"
        response.end
    end if  


 %>

<!doctype html>
<html lang="en-au">
    <head>
        <title>jQuery.Gantt</title>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=Edge;chrome=1" >
        <link rel="stylesheet" href="css/style.css" />
        <link rel="stylesheet" href="http://twitter.github.com/bootstrap/assets/css/bootstrap.css" />
        <link rel="stylesheet" href="http://taitems.github.com/UX-Lab/core/css/prettify.css" />
		<style type="text/css">
			body {
				font-family: Helvetica, Arial, sans-serif;
				font-size: 13px;
				padding: 0 0 50px 0;
			}
			.contain {
				width: 800px;
				margin: 0 auto;
			}
			h1 {
				margin: 40px 0 20px 0;
			}
			h2 {
				font-size: 1.5em;
				padding-bottom: 3px;
				border-bottom: 1px solid #DDD;
				margin-top: 50px;
				margin-bottom: 25px;
			}
			table th:first-child {
				width: 150px;
			}
		</style>
    </head>
    <body>

        <div>
            <h2>Tareas de Diseño</h2>


            <div class="gantt"></div>
      </div>
</body>
	<script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
	<script src="js/jquery.fn.gantt.js"></script>
	<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-tooltip.js"></script>
	<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-popover.js"></script>
	<script src="http://taitems.github.com/UX-Lab/core/js/prettify.js"></script>
    <script>

		$(function() {

			"use strict";

			$(".gantt").gantt({
				source: [
        <% 
            i=0
            Do While Not oRsTareaDiseno.Eof 
                if i>0 then Response.write ","
        %>        
                {
					name: "<%= oRsTareaDiseno("tarea_nombre")%>",
					desc: "",
					values: [{
					    from: "/Date(<%=year(oRsTareaDiseno("Fecha_Inicio"))%>,<%=Month(oRsTareaDiseno("Fecha_Inicio"))%>,<%=Day(oRsTareaDiseno("Fecha_Inicio"))%>)/",
					    to: "/Date(<%=year(oRsTareaDiseno("Fecha_Final"))%>,<%=Month(oRsTareaDiseno("Fecha_Final"))%>,<%=Day(oRsTareaDiseno("Fecha_Final"))%>)/",
						label: "<%= oRsTareaDiseno("razon_social")%>", 
						customClass: "ganttGreen"
					}]
				}
        <%      oRsTareaDiseno.MoveNext
                i = i + 1
            Loop %>],
				navigate: "scroll",
				scale: "months",
				maxScale: "months",
				minScale: "days",
				months: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Set", "Oct", "Nov", "Dic"],
				dow: ["D","L", "M", "M", "J", "V", "S"],
              //  scrollToToday: True,
				itemsPerPage: 10,
				onItemClick: function(data) {
					alert("Item clicked - show some details");
				},
				onAddClick: function(dt, rowId) {
					alert("Empty space clicked - add an item!");
				},
				onRender: function() {
					if (window.console && typeof console.log === "function") {
						console.log("chart rendered");
					}
				}
			});

			$(".gantt").popover({
				selector: ".bar",
				title: "I'm a popover",
				content: "And I'm the content of said popover.",
				trigger: "hover"
			});

			prettyPrint();

		});

    </script>
</html>