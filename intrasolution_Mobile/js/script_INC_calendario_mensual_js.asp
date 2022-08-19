<%@ Language=VBScript %>
<%response.Buffer=false%>
<!-- #INCLUDE FILE="../Includes/Connection_inc.asp" -->
<%
    Server.ScriptTimeout = 360
  	Response.ContentType = "text/javascript"
	Response.AddHeader "Content-Type", "text/javascript;charset=UTF-8"
	Response.CodePage = 65001
	Response.CharSet = "UTF-8"
    
    wEmpresa = Request("Empresa")
		wId_Unidad = Request("Id_Unidad")
		wId_Usuario = Request("Id_Usuario")
    wAnno = Request("Anno") 
    wCodigo = Request("Codigo")
	
%>

	var chart_<%=wCodigo%>, options_<%=wCodigo%>,calendar,empleadoColores=[]

	//FUNCION QUE ASIGNA COLORES OSCUROS Y CLAROS A CADA EMPLEADO
	function empleado_<%=wCodigo%>(){
	var empleado=[];
				<%
					Server.ScriptTimeout = 360					
					wSQL = " [pr_graf_inc_calendario_empleado_combo]" & wId_Usuario
					
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
			for (i=0;i<empleado.length;i++){
				if(i % 2 == 0){
					empleadoColores.push({"id":empleado[i].id,"nombre":empleado[i+1].empleado,"ColorDark": ColorDark[num],"ColorHight": ColorHight[num]})
					num ++;
				}				
			}
			
		}


		//FUNCION AGREGAR EVENTOAL CALENDARIO
		function Agregar_<%=wCodigo%>(){
				var tipotarea = document.getElementById("newTipoTarea").value;
				var subtipotarea = document.getElementById("newSubTipoTarea").value;
				var incidente = document.getElementById("newIncidente").value;
				var pase = document.getElementById("newPase").value;
				var observacion = document.getElementById("newObservacion").value;
				var start = document.getElementById("newFechaStart").value;
				var horainicio = document.getElementById("newHoraInicio").value;
				var fin = document.getElementById("newFechaFin").value;
				var horafin = document.getElementById("newHoraFin").value;
			  var data = {};
  			var array = [];

        	$.ajax({
            url: "js/script_INC_calendario_mensual_crud_Load_js.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wId_Unidad%>&Id_Usuario=<%=wId_Usuario%>&wTipoTarea="+tipotarea+"&wSubTipoTarea="+subtipotarea+"&wIncidente="+incidente+"&wPase="+pase+"&wObservacion="+observacion+"&wStart="+start+"&wHoraInicio="+horainicio+"&wFin="+fin+"&wHoraFin="+horafin+"&wType=1&wId=0",
            type: "POST",
						dataType: "json",
						success: function(dataSource) {
							for (var i=0;i<empleadoColores.length;i++){
								if(empleadoColores[i].id == dataSource.nombre_id){
									dataSource["color"]=empleadoColores[i].ColorDark
								}				
							}
							calendar.addEvent(dataSource)
							$('#modalNuevo').modal('toggle');
            },
         });
				 
		}
		//FUNCION EDITAR EVENTO DE CALENDARIO
		function Editar_<%=wCodigo%>(){
				var tipotarea = document.getElementById("EditTipoTarea").value;
				var subtipotarea = document.getElementById("EditSubTipoTarea").value;
				var incidente = document.getElementById("EditIncidente").value;
				var pase = document.getElementById("EditPase").value;
				var observacion = document.getElementById("EditObservacion").value;
				var start = document.getElementById("EditStart").value;
				var horainicio = document.getElementById("EditHoraInicio").value;
				var fin = document.getElementById("EditFin").value;
				var horafin = document.getElementById("EditHoraFin").value;
				var id = document.getElementById("id").value;
			  var data = {};
  			var array = [];

        	$.ajax({
            url: "js/script_INC_calendario_mensual_crud_Load_js.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wId_Unidad%>&Id_Usuario=<%=wId_Usuario%>&wTipoTarea="+tipotarea+"&wSubTipoTarea="+subtipotarea+"&wIncidente="+incidente+"&wPase="+pase+"&wObservacion="+observacion+"&wStart="+start+"&wHoraInicio="+horainicio+"&wFin="+fin+"&wHorafin="+horafin+"&wType=2&wId="+id,
            type: "POST",
						dataType: "json",
						success: function(dataSource) {
						var event = calendar.getEventById(id)
						event.remove()
						for (var i=0;i<empleadoColores.length;i++){
							if(empleadoColores[i].id == dataSource.nombre_id){
								dataSource["color"]=empleadoColores[i].ColorDark
							}				
						}
						calendar.addEvent(dataSource)
						$('#modalEditar').modal('toggle');
            },
         });
		}
	//FUNCION ELIMINAR EVENTO
		function Eliminar_<%=wCodigo%>(){
				var tipotarea = document.getElementById("EditTipotarea").value;
				var subtipotarea = document.getElementById("EditSubTipoTarea").value;
				var incidente = document.getElementById("EditIncidente").value;
				var pase = document.getElementById("EditPase").value;
				var start = document.getElementById("EditStart").value;
				var horainicio = document.getElementById("EditHoraInicio").value;
				var fin = document.getElementById("EditFin").value;
				var horafin = document.getElementById("EditHoraFin").value;
				var id = document.getElementById("id").value;
			  var data = {};
  			var array = [];

        	$.ajax({
            url: "js/script_INC_calendario_mensual_crud_Load_js.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wId_Unidad%>&Id_Usuario=<%=wId_Usuario%>&wTipoTarea="+tipotarea+"&wSubTipoTarea="+subtipotarea+"&wIncidente="+incidente+"&wPase="+pase+"&wObservacion="+observacion+"&wStart="+start+"&wHoraInicio="+horainicio+"&wFin="+fin+"&wHorafin="+horafin+"&wType=3&wId="+id,
            type: "POST",
						dataType: "json",
						success: function(dataSource) {
							var event = calendar.getEventById(id)
							event.remove()
							$('#modalEditar').modal('toggle');
						},
						error: function(jqXHR, textStatus, errorThrown) {
							console.log(jqXHR);
							console.log(textStatus);
							console.log(errorThrown);
						},
         });
		}

//CARGAR LOS EVENTOS EN EL CAENDARIO
function load_<%=wCodigo%>(){
empleado_<%=wCodigo%>();
$.ajax({
				url: "js/script_INC_calendario_mensual_Load_js.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wId_Unidad%>&Id_Usuario=<%=wId_Usuario%>&Id_Empleado=0",
				type: "POST",
				dataType: "json",
				success:function(jdata){
					var calendarEl = document.getElementById('canvas_<%=wCodigo%>');
					for (var i=0;i<jdata.length;i++){
						if (typeof jdata[i].title == 'string' || jdata[i].title instanceof String) {
							  jdata[i].title=jdata[i].title.split('&#225;').join('á');
							  jdata[i].title=jdata[i].title.split("&#233;").join('é');
							  jdata[i].title=jdata[i].title.split("&#237;").join('í');
							  jdata[i].title=jdata[i].title.split("&#205;").join('Í');
							  jdata[i].title=jdata[i].title.split("&#243;").join('ó');
							  jdata[i].title=jdata[i].title.split("&#250;").join('ú');
							  jdata[i].title=jdata[i].title.split("&#241;").join('ñ');
							  jdata[i].title=jdata[i].title.split("&#209;").join('Ñ');
						  }
						for(var j=0;j<empleadoColores.length;j++){
								nombre = jdata[i].nombre_id;
								nombre2 = empleadoColores[j].id
									if(nombre == nombre2){
									
										if(jdata[i].estado_id == 1)
										{
										jdata[i].color = empleadoColores[j].ColorDark;

										}else{
										jdata[i].color = empleadoColores[j].ColorHight;

										}
									}
						}
					}
					
					options_<%=wCodigo%>.events = jdata;
					options_<%=wCodigo%>.eventColor ="rgba(58, 175, 250, 0.6)";

					var calendario = options_<%=wCodigo%>
    			 	calendar = new FullCalendar.Calendar(calendarEl, calendario);
					calendar.render();

				}
				    })
		
				datos_<%=wCodigo%>();
			}

		 function datos_<%=wCodigo%>(){
		 		options_<%=wCodigo%> = {
					monthNames: ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
					monthNamesShort: ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'],
					dayNames: ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'],
					dayNamesShort: ['Dom','Lun','Mar','Mié','Jue','Vie','Sáb'],
					 locale: 'es',
					header: {
						left: 'today prev,next',	
						center: 'title',
						right: 'dayGridMonth,timeGridWeek,listMonth'
					},
					selectable: true,
					selectMirror: true,
					eventLimit: true, 
				
					eventRender: function(info) {
						var tooltip = new Tooltip(info.el, {
							title: info.event.extendedProps.estado,
							template: '<div class="tooltip" role="tooltip"><div class="tooltip-arrow"></div>'+
							'<b>Tarea:</b> '+info.event.title +'<br>'+
							'Responsable: '+info.event.extendedProps.persona	 +'<br>'+
							'Fecha: '+info.event.extendedProps.fecha +'<br>'+
							'<div class="tooltip-inner"></div></div>',
							placement: 'top',
							trigger: 'hover',
							container: 'body'
						});
					},
					plugins: ['interaction', 'dayGrid', 'timeGrid', 'list' ],
					//AGREGAR EVENTO
					dateClick: function(info) {
						document.getElementById("newTipoTarea").options.length = 0;
						document.getElementById("newSubTipoTarea").options.length = 0;
						document.getElementById("newPase").options.length = 0;
						//document.getElementById("newFechaStart").options.length = 0;
						//document.getElementById("newFechaFin").options.length = 0;
						<%
								Server.ScriptTimeout = 360					
							wSQL = " [pr_graf_inc_calendario_tipo_tarea_combo]"
							
							Set wRsTtar = Server.CreateObject("ADODB.recordset")
								wRsTtar.CursorLocation = 3
								wRsTtar.CursorType = 2
								wRsTtar.Open wSQL, oConn,1,1
						
							While not wRsTtar.EOF	
							%>
									var select = document.getElementById("newTipoTarea");
									
									select.options[select.options.length] = new Option( '<% Response.Write wRsTtar("tipo_tarea") %>','<% Response.Write wRsTtar("id") %>');
								<%	wRsTtar.MoveNext()
							Wend
							wRsTtar.Close
							Set wRsTtar = Nothing 
						%>
						<%
								Server.ScriptTimeout = 360					
							wSQL = " [pr_graf_inc_calendario_subtipo_tarea_combo]"
							
							Set wRsTtar = Server.CreateObject("ADODB.recordset")
								wRsTtar.CursorLocation = 3
								wRsTtar.CursorType = 2
								wRsTtar.Open wSQL, oConn,1,1
						
							While not wRsTtar.EOF	
							%>
									var select = document.getElementById("newSubTipoTarea");
									
									select.options[select.options.length] = new Option( '<% Response.Write wRsTtar("subtipo_tarea") %>','<% Response.Write wRsTtar("id") %>');
								<%	wRsTtar.MoveNext()
							Wend
							wRsTtar.Close
							Set wRsTtar = Nothing 
						%>

						<% ' Incidente combo
								Server.ScriptTimeout = 360					
							wSQL = " [pr_graf_inc_calendario_incidencia_combo]" & wId_Usuario
							
							Set wRsTtar = Server.CreateObject("ADODB.recordset")
								wRsTtar.CursorLocation = 3
								wRsTtar.CursorType = 2
								wRsTtar.Open wSQL, oConn,1,1
						
							While not wRsTtar.EOF	
							%>
									var select = document.getElementById("newIncidente");
									
									select.options[select.options.length] = new Option( '<% Response.Write wRsTtar("codigo_ticket") %>','<% Response.Write wRsTtar("id") %>');
								<%	wRsTtar.MoveNext()
							Wend
							wRsTtar.Close
							Set wRsTtar = Nothing 
						%>
						<% ' Pase combo
								Server.ScriptTimeout = 360					
							wSQL = " [pr_graf_inc_calendario_pase_combo]" & wId_Usuario
							
							Set wRsTtar = Server.CreateObject("ADODB.recordset")
								wRsTtar.CursorLocation = 3
								wRsTtar.CursorType = 2
								wRsTtar.Open wSQL, oConn,1,1
						
							While not wRsTtar.EOF	
							%>
									var select = document.getElementById("newPase");
									
									select.options[select.options.length] = new Option( '<% Response.Write wRsTtar("codigo") %>','<% Response.Write wRsTtar("id") %>');
								<%	wRsTtar.MoveNext()
							Wend
							wRsTtar.Close
							Set wRsTtar = Nothing 
						%>

						<%			
							'wSQL = " [pr_graf_inc_calendario_empleado_combo]" & wId_Usuario
							
							'Set wRsGer = Server.CreateObject("ADODB.recordset")
								'wRsGer.CursorLocation = 3
								'wRsGer.CursorType = 2
								'wRsGer.Open wSQL, oConn,1,1
							'While not wRsGer.EOF	
							%>
									//var select = document.getElementById("newResponsable");
									//select.options[select.options.length] = new Option( '<% 'Response.Write wRsGer("empleado") %>','<% 'Response.Write wRsGer("id") %>');
								<%	'wRsGer.MoveNext()
							'Wend
							'wRsGer.Close
							'Set wRsGer = Nothing 
						%>
						var start = moment(info.startStr)
						
						//LLENADO DE LAS FECHAS
						console.log(info.dateStr.substr(0,10))
						document.getElementById("newFechaStart").value = info.dateStr.substr(0,10);

						//ABRIR MODAL
						$('#modalNuevo').modal('show');
					},
					//EDITAR EVENTO
					eventClick: function(info) {
					
					document.getElementById("id").value = info.event.id;
					document.getElementById("codigo").value = info.event.extendedProps.codigo;
					//document.getElementById("newSubTipoTarea").value = info.event.extendedProps.nombre_subtipo_tarea;
					document.getElementById("newTipoTarea").options.length = 0;
					document.getElementById("newSubTipoTarea").options.length = 0;
					document.getElementById("newIncidente").options.length = 0;
					document.getElementById("newPase").options.length = 0;

						<%
								Server.ScriptTimeout = 360					
							wSQL = " [pr_graf_inc_calendario_tipo_tarea_combo]"
							
							Set wRsGer = Server.CreateObject("ADODB.recordset")
								wRsGer.CursorLocation = 3
								wRsGer.CursorType = 2
								wRsGer.Open wSQL, oConn,1,1
						
							While not wRsGer.EOF	
							%>
									var select = document.getElementById("EditTipoTarea");
									select.options[select.options.length] = new Option( '<% Response.Write wRsGer("tipo_tarea") %>','<% Response.Write wRsGer("id") %>');
								
								<%	wRsGer.MoveNext()
							Wend
							wRsGer.Close
							Set wRsGer = Nothing 
						%>
				
									document.getElementById("EditTipoTarea").value = info.event.extendedProps.tipo_tarea_id

						<%
								Server.ScriptTimeout = 360					
							wSQL = " [pr_graf_inc_calendario_subtipo_tarea_combo]"
							
							Set wRsGer = Server.CreateObject("ADODB.recordset")
								wRsGer.CursorLocation = 3
								wRsGer.CursorType = 2
								wRsGer.Open wSQL, oConn,1,1
						
							While not wRsGer.EOF	
							%>
									var select = document.getElementById("EditSubTipoTarea");
									select.options[select.options.length] = new Option( '<% Response.Write wRsGer("Subtipo_tarea") %>','<% Response.Write wRsGer("id") %>');
								
								<%	wRsGer.MoveNext()
							Wend
							wRsGer.Close
							Set wRsGer = Nothing 
						%>
				
									document.getElementById("EditSubTipoTarea").value = info.event.extendedProps.subtipo_tarea_id

						<%			
							wSQL = " [pr_graf_inc_calendario_incidencia_combo]" & wId_Usuario
							
							Set wRsGer = Server.CreateObject("ADODB.recordset")
								wRsGer.CursorLocation = 3
								wRsGer.CursorType = 2
								wRsGer.Open wSQL, oConn,1,1
							While not wRsGer.EOF	
							%>
									var select = document.getElementById("EditIncidente");
									select.options[select.options.length] = new Option( '<% Response.Write wRsGer("codigo_ticket") %>','<% Response.Write wRsGer("id") %>');
								<%	wRsGer.MoveNext()
							Wend
							wRsGer.Close
							Set wRsGer = Nothing 
						%>

						<%			
							wSQL = " [pr_graf_inc_calendario_pase_combo]" & wId_Usuario
							
							Set wRsGer = Server.CreateObject("ADODB.recordset")
								wRsGer.CursorLocation = 3
								wRsGer.CursorType = 2
								wRsGer.Open wSQL, oConn,1,1
							While not wRsGer.EOF	
							%>
									var select = document.getElementById("EditPase");
									select.options[select.options.length] = new Option( '<% Response.Write wRsGer("codigo") %>','<% Response.Write wRsGer("id") %>');
								<%	wRsGer.MoveNext()
							Wend
							wRsGer.Close
							Set wRsGer = Nothing 
						%>

						document.getElementById("EditResponsable").value = info.event.extendedProps.nombre_id;												
						document.getElementById("EditStart").value = info.event.extendedProps.hora_inicio;
						$('#modalEditar').modal('show');


					},
					
					
				}
			}


		 //CARGAR LOS EVENTOS EN EL CAENDARIO CON EL FILLTRO DE EMPLEADO
function update_<%=wCodigo%>(){
		  var empleado = document.getElementById("empleado_<%=wCodigo%>").value;

	empleado_<%=wCodigo%>();
		$.ajax({
						url: "js/script_INC_calendario_mensual_Load_js.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wId_Unidad%>&Id_Usuario=<%=wId_Usuario%>&Id_Empleado="+empleado,
						type: "POST",
						dataType: "json",
						success:function(jdata){
							var calendarEl = document.getElementById('canvas_<%=wCodigo%>');
							
							for (var i=0;i<jdata.length;i++){
								for(var j=0;j<empleadoColores.length;j++){
										nombre = jdata[i].nombre_id;
										nombre2 = empleadoColores[j].id
											if(nombre.localeCompare(nombre2) == 0){
												if(jdata[i].estado_id == 1)
												{
												jdata[i].color = empleadoColores[j].ColorDark;

												}else{
												jdata[i].color = empleadoColores[j].ColorHight;

												}
											}
								}
							}
							options_<%=wCodigo%>.events = jdata;
							options_<%=wCodigo%>.eventColor ="rgba(58, 175, 250, 0.6)";

							var calendario = options_<%=wCodigo%>
							var empleado = document.getElementById("canvas_<%=wCodigo%>").innerHTML='';
							calendar = new FullCalendar.Calendar(calendarEl, calendario);
							calendar.render();

						}
					})
		
				datos_<%=wCodigo%>();
			}