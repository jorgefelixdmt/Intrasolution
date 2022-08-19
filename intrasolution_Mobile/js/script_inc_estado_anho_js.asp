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
			var anho = document.getElementById("Anho_<%=wCodigo%>").value;

			$.ajax({
				url: "js/script_inc_estado_anho_Load_js.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wId_Unidad%>&Id_Usuario=<%=wId_Usuario%>&inicio=<%=inicio%>&fin=<%=fin%>&Anno=" + anho,
				type: "POST",
				dataType: "json",
				success:function(jdata){
					cantidad = jdata.length
					
					for (var i = 0; i<cantidad;i++){
						if (typeof jdata[i].name == 'string' || jdata[i].name instanceof String) {
						  jdata[i].name=jdata[i].name.split('&#225;').join('á');
						  jdata[i].name=jdata[i].name.split("&#233;").join('é');
						  jdata[i].name=jdata[i].name.split("&#237;").join('í');
						  jdata[i].name=jdata[i].name.split("&#205;").join('Í');
						  jdata[i].name=jdata[i].name.split("&#243;").join('ó');
						  jdata[i].name=jdata[i].name.split("&#250;").join('ú');
						  jdata[i].name=jdata[i].name.split("&#218;").join('Ú');
						  jdata[i].name=jdata[i].name.split("&#241;").join('ñ');
						  jdata[i].name=jdata[i].name.split("&#209;").join('Ñ');
					  }
					}
				
					config_<%=wCodigo%>.series[0].data = jdata;
					
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
			config_<%=wCodigo%> =  {
										chart: {
											renderTo: 'canvas_<%=wCodigo%>',
											type: 'pie'
										},
										title: {
											text: 'Incidentes por Año'
										},
										subtitle: {
											text: ''
										},
										tooltip: {
											pointFormat: '{series.name}: <b>{point.y} ({point.percentage:.1f}%)</b>'
										},
										accessibility: {
											point: {
												valueSuffix: '%'
											}
										},
										plotOptions: {
											pie: {
												cursor: 'pointer',
												dataLabels: {
													enabled: false,
													format: '<b>{point.name}</b>: {point.y} ({point.percentage:.1f}%)'
												}
											}
										},
										series: [{
											name: 'Incidentes',
											colorByPoint: true,
											data: []
										}]
									}

		}

		function update_<%=wCodigo%>(){
			var anho = document.getElementById("Anho_<%=wCodigo%>").value;
			
			$.ajax({
				url: "js/script_inc_estado_anho_Load_js.asp?Empresa=<%=wEmpresa%>&Id_Unidad=<%=wId_Unidad%>&Id_Usuario=<%=wId_Usuario%>&inicio=<%=inicio%>&fin=<%=fin%>&Anno=" + anho,
				type: "POST",
				dataType: "json",
				success:function(jdata){
					datos_<%=wCodigo%>()
					
					cantidad = jdata.length
					
					for (var i = 0; i<cantidad;i++){
						if (typeof jdata[i].name == 'string' || jdata[i].name instanceof String) {
						  jdata[i].name=jdata[i].name.split('&#225;').join('á');
						  jdata[i].name=jdata[i].name.split("&#233;").join('é');
						  jdata[i].name=jdata[i].name.split("&#237;").join('í');
						  jdata[i].name=jdata[i].name.split("&#205;").join('Í');
						  jdata[i].name=jdata[i].name.split("&#243;").join('ó');
						  jdata[i].name=jdata[i].name.split("&#250;").join('ú');
						  jdata[i].name=jdata[i].name.split("&#218;").join('Ú');
						  jdata[i].name=jdata[i].name.split("&#241;").join('ñ');
						  jdata[i].name=jdata[i].name.split("&#209;").join('Ñ');
					  }
					}
					
					config_<%=wCodigo%>.series[0].data = jdata;
					
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
		