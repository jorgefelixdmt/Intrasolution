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
	
	inicio = Request("inicio")
	fin = Request("fin")
	
%>



		var chart_<%=wCodigo%>, options_<%=wCodigo%>,config_<%=wCodigo%>=[]
		
		function load_<%=wCodigo%>(){
			var cadena_filtros = "";
	
			var filters = document.getElementsByClassName("side-bar-filter")
			
			for(var i = 0; i < filters.length; i++) {
				cadena_filtros = "&" + filters[i].id + "=" + filters[i].value;
			}

			$.ajax({
				url: "js/script_JIRA_inc_pend_cliente_Load_js.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wId_Unidad%>&Id_Usuario=<%=wId_Usuario%>&inicio=<%=inicio%>&fin=<%=fin%>" + cadena_filtros,
				type: "POST",
				dataType: "json",
				success:function(jdata){
					cantidad = jdata.series.length
					
					for (var i = 0; i<cantidad;i++){
						if (typeof jdata.series[i].name == 'string' || jdata.series[i].name instanceof String) {
						  jdata.series[i].name=jdata.series[i].name.split('&#225;').join('á');
						  jdata.series[i].name=jdata.series[i].name.split("&#233;").join('é');
						  jdata.series[i].name=jdata.series[i].name.split("&#237;").join('í');
						  jdata.series[i].name=jdata.series[i].name.split("&#205;").join('Í');
						  jdata.series[i].name=jdata.series[i].name.split("&#243;").join('ó');
						  jdata.series[i].name=jdata.series[i].name.split("&#250;").join('ú');
						  jdata.series[i].name=jdata.series[i].name.split("&#218;").join('Ú');
						  jdata.series[i].name=jdata.series[i].name.split("&#241;").join('ñ');
						  jdata.series[i].name=jdata.series[i].name.split("&#209;").join('Ñ');
					  }
					}
				
				
					config_<%=wCodigo%>.xAxis.categories = jdata.categorias;
					config_<%=wCodigo%>.series = jdata.series;
					
					chart_<%=wCodigo%> = new Highcharts.Chart(config_<%=wCodigo%>);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					console.log(jqXHR);
					console.log(textStatus);
					console.log(errorThrown);
				},
			});
			
			datos_<%=wCodigo%>();
		}
		
		function datos_<%=wCodigo%>(){
			var width = document.getElementById("div_<%=wCodigo%>").offsetWidth;

			config_<%=wCodigo%> =  {
										chart: {
											renderTo: 'canvas_<%=wCodigo%>',
											type: 'column'
										},
										title: {
											text: 'Incidencias Pendientes por Proyecto'
										},
										subtitle: {
											text: ''
										},
										xAxis: {
											categories: [],
										},
										yAxis: {
												min: 0,
												allowDecimals: false,
												title: {
														text: '# Incidencias'
												},
												stackLabels: {
														enabled: false,
														style: {
																fontWeight: 'bold',
																color: ( // theme
																		Highcharts.defaultOptions.title.style &&
																		Highcharts.defaultOptions.title.style.color
																) || 'gray'
														}
												}
										},
										tooltip: {
												valueDecimals: 0
										},
										legend: {
											floating: false,
											verticalAlign: 'top',
											backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
											borderColor: '#CCC'
										},

										plotOptions: {
												column: {
														stacking: 'normal',
														dataLabels: {
																enabled: false,
																color: 'gray',
																formatter: function () {
																	return (this.y!=0) ? Highcharts.numberFormat(this.y,0) : "";
																}
														}
												}
										},
										series: []
									}

		}

		function update_<%=wCodigo%>(){
			var cadena_filtros = "";
	
			var filters = document.getElementsByClassName("side-bar-filter")
			
			for(var i = 0; i < filters.length; i++) {
				cadena_filtros = "&" + filters[i].id + "=" + filters[i].value;
			}
	
			
			$.ajax({
				url: "js/script_JIRA_inc_pend_cliente_Load_js.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wId_Unidad%>&Id_Usuario=<%=wId_Usuario%>&inicio=<%=inicio%>&fin=<%=fin%>" + cadena_filtros,
				type: "POST",
				dataType: "json",
				success:function(jdata){
					datos_<%=wCodigo%>()
					
					cantidad = jdata.series.length
					
					for (var i = 0; i<cantidad;i++){
						if (typeof jdata.series[i].name == 'string' || jdata.series[i].name instanceof String) {
						  jdata.series[i].name=jdata.series[i].name.split('&#225;').join('á');
						  jdata.series[i].name=jdata.series[i].name.split("&#233;").join('é');
						  jdata.series[i].name=jdata.series[i].name.split("&#237;").join('í');
						  jdata.series[i].name=jdata.series[i].name.split("&#205;").join('Í');
						  jdata.series[i].name=jdata.series[i].name.split("&#243;").join('ó');
						  jdata.series[i].name=jdata.series[i].name.split("&#250;").join('ú');
						  jdata.series[i].name=jdata.series[i].name.split("&#218;").join('Ú');
						  jdata.series[i].name=jdata.series[i].name.split("&#241;").join('ñ');
						  jdata.series[i].name=jdata.series[i].name.split("&#209;").join('Ñ');
					  }
					}
					
					config_<%=wCodigo%>.xAxis.categories = jdata.categorias;
					config_<%=wCodigo%>.series = jdata.series;
					
					chart_<%=wCodigo%>.destroy();
					chart_<%=wCodigo%> = new Highcharts.Chart(config_<%=wCodigo%>);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					console.log(jqXHR);
					console.log(textStatus);
					console.log(errorThrown);
				},
			});
		}
		
		function resize_<%=wCodigo%>(){
			var width = document.getElementById("div_<%=wCodigo%>").offsetWidth;
		}
		