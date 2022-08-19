<%@ Language=VBScript %>
<%response.Buffer=false%>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<%
    Server.ScriptTimeout = 360
  	Response.ContentType = "text/javascript"
	Response.AddHeader "Content-Type", "text/javascript;charset=UTF-8"
	Response.CodePage = 65001
	Response.CharSet = "UTF-8"
    
    wEmpresa = Session("Empresa")
		wId_Unidad = Session("Id_Unidad")
		wId_Usuario = Session("Id_Usuario")
    wAnno = Session("Anno") 
    wCodigo = Request("Codigo")
%>
	var chart_<%=wCodigo%>, options_<%=wCodigo%>,calendar,empleadoColores=[]

	//FUNCION QUE ASIGNA COLORES OSCUROS Y CLAROS A CADA EMPLEADO
	function empleado_<%=wCodigo%>(){
	var empleado=[];
				<%
					Server.ScriptTimeout = 360					
					wSQL = " [pr_graf_vea_calendario_empleado_combo]"
					
					Set wRsGer = Server.CreateObject("ADODB.recordset")
					wRsGer.CursorLocation = 3
					wRsGer.CursorType = 2
					wRsGer.Open wSQL, oConn,1,1
				
					while not wRsGer.EOF	
						for each x in wRsGer.fields
							%>
							empleado.push({"<% Response.Write(x.name) %>":"<% Response.Write(x.value) %>"});
							<%	
						next
						wRsGer.MoveNext()
					Wend
					wRsGer.Close
					Set wRsGer = Nothing 
				%>
				//Colores claros  (RGBA)
				var ColorHight = [
				"rgba(58, 175, 250, 0.6)",   // Celeste
				"rgba(105, 105, 105, 0.6)",  // Plomo 
				"rgba(239,168,39,0.67)",    // Rojo
				"rgba(131, 204, 31, 0.6)",   // Verde
				"rgba(255, 129, 40, 0.6)",   // Anaranjado
				"rgba(159, 94, 239, 0.6)",   // Morado
				"rgba(41, 94, 192, 0.6)",    // Azul
				"rgba(246, 232, 25, 0.6)",   // Amarillo
				"rgba(147, 89, 85, 0.6)"];   // Marron


				//Colores oscuros (RGBA)
				var ColorDark = [
				"rgba(58, 175, 250, 1)",    // Celeste
				"rgba(105, 105, 105, 1)",   // Plomo
				"rgba(239,168,39,0.86)",     // Rojo
				"rgba(131, 204, 31, 1)",    // Verde
				"rgba(255, 129, 40, 1)",    // Anaranjado
				"rgba(159, 94, 239, 1)",    // Morado
				"rgba(41, 94, 192, 1)",     // Azul
				"rgba(246, 232, 25, 1)",    // Amarillo
				"rgba(147, 89, 85, 1)"];    // Marron
				var num = 0;


			//asignacion de colores claros y oscuros
			for (var i=0;i<empleado.length;i++){
				if(i % 2 == 0){
					empleadoColores.push({"id":empleado[i].id,"nombre":empleado[i+1].empleado,"ColorDark": ColorDark[num],"ColorHight": ColorHight[num]})
					num ++;
				}				
			}
		}

//CARGAR TODOS LOS EVENTO
function load_<%=wCodigo%>()
        {
            var fecha = new Date();
            var anio = fecha.getFullYear();

            $.ajax({ 
            url: "js/script_VEA_calendario_anual_Load_js.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wId_Unidad%>&Id_Usuario=<%=wId_Usuario%>&Id_Empleado=0&anio="+anio,
            type: "POST",
            dataType: "json",
            success: function(dataSource) { 
                    empleado_<%=wCodigo%>();
                    var objs = dataSource;  
                    //agregar el Start date dia, mes, anio
                    for (var i = 0; i < objs.length; i++)
                     {
                        var fecha = objs[i].start;
                        var day = parseInt(fecha.substr(8,9));
                        var month = parseInt(fecha.substr(5,6))-1;
                        var year = parseInt(fecha.substr(0,4));
                        objs[i].startDate = new Date(year, month, day);
                        objs[i].endDate = new Date(year, month, day);
                     };
                    //asignar colores
					for (var i=0;i<objs.length;i++){
						for(var j=0;j<empleadoColores.length;j++){
								nombre = objs[i].persona;
								nombre2 = empleadoColores[j].nombre;
									if(nombre.localeCompare(nombre2) == 0){
										objs[i].color = empleadoColores[j].ColorHight;

									}
						}
                    }



                     cargar_<%=wCodigo%>()
                    chart_<%=wCodigo%>.dataSource = objs;
                     $('#canvas_<%=wCodigo%>').calendar(chart_<%=wCodigo%>)
                     
            } 
         });
        }

      var currentYear = new Date().getFullYear();
      var currentMonth = new Date().getMonth(); 
      var currentDate = new Date().getDate();
      var circleDateTime = new Date(currentYear, currentMonth, currentDate).getTime();
      var yearSave = 0;

function cargar_<%=wCodigo%>(){
                 chart_<%=wCodigo%> = {
                enableContextMenu: true,
                enableRangeSelection: false,
                language:'es',
                startYear:currentYear,
                minDate: new Date(currentYear-10,0,1),
                customDayRenderer: function(element, date) {
                    if(date.getTime() == circleDateTime) {
                        $(element).css('background-color', 'SteelBlue');
                        $(element).css('color', 'white');
                        $(element).css('border-radius', '5px');
                    }
                  },
                 mouseOnDay: function(e) {
                    if(e.events.length > 0) {
                        
                        var content = '';
                        
                        for(var i in e.events) {
                            // Define el texto que aparecera en la 
                            content += '<div class="event-tooltip-content">'
                                            + '<div class="event-Titulo" style="color:' + e.events[i].color + '">' + e.events[i].name + '</div>'
                                            + '<div class="event-Texto">Gerencia: ' + e.events[i].location + '</div>'
                                            + '<div class="event-Texto">Responsable: ' + e.events[i].persona + '</div>'
                                            + '<div class="event-Texto">Fecha: ' + e.events[i].start + '</div>'
                                            + '<div class="badge badge-primary">' + e.events[i].estado + '</div>'
                                        + '</div>';
                        }
            
                        $(e.element).popover({ 
                            trigger: 'manual',
                            container: 'body',
                            html:true,
                            content: content
                        });
                
                        $(e.element).popover('show');
                    }
                },
                mouseOutDay: function(e) {
                    if(e.events.length > 0) {
                        $(e.element).popover('hide');
                    }
                },
                dayContextMenu: function(e) {
                    $(e.element).popover('hide');
                }         
            };
}






function update_<%=wCodigo%>()
        {
            var empleado = document.getElementById("empleado_<%=wCodigo%>").value;
            var fecha = new Date();
            var anio = fecha.getFullYear();

            $.ajax({ 
            url: "js/script_VEA_calendario_anual_Load_js.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wId_Unidad%>&Id_Usuario=<%=wId_Usuario%>&Id_Empleado="+empleado+"&anio="+anio,
            type: "POST",
            dataType: "json",
            success: function(dataSource) { 
                    empleado_<%=wCodigo%>();
                    var objs = dataSource;  
                    //agregar el Start date dia, mes, anio
                    for (var i = 0; i < objs.length; i++)
                     {
                        var fecha = objs[i].start;
                        var day = parseInt(fecha.substr(8,9));
                        var month = parseInt(fecha.substr(5,6))-1;
                        var year = parseInt(fecha.substr(0,4));
                        objs[i].startDate = new Date(year, month, day);
                        objs[i].endDate = new Date(year, month, day);
                     };
                    //asignar colores
					for (var i=0;i<objs.length;i++){
						for(var j=0;j<empleadoColores.length;j++){
								nombre = objs[i].persona;
								nombre2 = empleadoColores[j].nombre;
									if(nombre.localeCompare(nombre2) == 0){
										objs[i].color = empleadoColores[j].ColorHight;

									}
						}
                    }
                     cargar_<%=wCodigo%>()
                    chart_<%=wCodigo%>.dataSource = objs;
                     $('#canvas_<%=wCodigo%>').calendar(chart_<%=wCodigo%>)
                     
            } 
         });
        }