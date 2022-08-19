/*Chart.defaults.global.tooltips.custom = function (tooltip) {
  // console.log(tooltip);
  // Tooltip Element
  var tooltipEl = document.getElementById('chartjs-tooltip');

  // Hide if no tooltip
  if (tooltip.opacity === 0) {
    tooltipEl.style.opacity = 0;
    return;
  }

  // Set caret Position
  tooltipEl.classList.remove('above', 'below', 'no-transform');
  if (tooltip.yAlign) {
    tooltipEl.classList.add(tooltip.yAlign);
  } else {
    tooltipEl.classList.add('no-transform');
  }

  function getBody(bodyItem) {
    return bodyItem.lines;
  }

  // Set Text
  if (tooltip.body) {
    var titleLines = tooltip.title || [];
    var bodyLines = tooltip.body.map(getBody);

    var innerHtml = '<thead>';

    titleLines.forEach(function (title) {
      innerHtml += '<tr><th>' + title + '</th></tr>';
    });

    innerHtml += '</thead><tbody>';

    bodyLines.forEach(function (body, i) {
      var colors = tooltip.labelColors[i];
      var style = 'background:' + colors.backgroundColor;
      style += '; border: 1px solid white;';
      var span = '<span class="chartjs-tooltip-key" style="' + style + '"></span>';
      innerHtml += '<tr><td>' + span + '<font size=3>' + body + '</font></td></tr>';
    });

    innerHtml += '</tbody>';
    var tableRoot = tooltipEl.querySelector('table');
    tableRoot.innerHTML = innerHtml;
  }

  var position = this._chart.canvas.getBoundingClientRect();
  // Display, position, and set styles for font
  tooltipEl.style.opacity = 1;
  tooltipEl.style.left = event.clientX + document.body.scrollLeft + 'px';
  tooltipEl.style.top = event.clientY + document.body.scrollTop + 12 + 'px';
  tooltipEl.style.fontFamily = tooltip._fontFamily;
  tooltipEl.style.fontSize = tooltip.fontSize;
  tooltipEl.style.fontStyle = tooltip._fontStyle;
  tooltipEl.style.padding = tooltip.yPadding + 'px ' + tooltip.xPadding + 'px';
};
*/

//var URL_APP = muestra_agua_autoridad.dataset.url;
//var User = muestra_agua_autoridad.dataset.user;
//var Empresa = muestra_agua_autoridad.dataset.empresa;
//var Password = muestra_agua_autoridad.dataset.pass;


//Colores para el relleno de los gráficos (RGBA)

var Colors = [ 
"rgba(105, 105, 105, 0.6)",
"rgba(58, 175, 250, 0.6)",
"rgba(221, 48, 43, 0.6)",
"rgba(131, 204, 31, 0.6)", 
"rgba(255, 129, 40, 0.6)", 
"rgba(159, 94, 239, 0.6)",
"rgba(41, 94, 192, 0.6)", 
"rgba(246, 232, 25, 0.6)", 
"rgba(147, 89, 85, 0.6)"]; 


//Colores para los bordes de los gráficos (RGBA)
var BorderColors = [  
"rgba(105, 105, 105, 1)",
"rgba(58, 175, 250, 1)", 
"rgba(221, 48, 43, 1)", 
"rgba(131, 204, 31, 1)", 
"rgba(255, 129, 40, 1)", 
"rgba(159, 94, 239, 1)",
"rgba(41, 94, 192, 1)", 
"rgba(246, 232, 25, 1)", 
"rgba(147, 89, 85, 1)"]; 

var allCharts = {};
var tooltipTile = {};

//Función para odernar los datos
 function sortProperties(obj) {
            var sortable = [];
            for (var key in obj) {
                if (obj.hasOwnProperty(key)) {
                    sortable.push([key, obj[key]]);
                }
            }
            return sortable; // array in format [ [ key1, val1 ], [ key2, val2 ], ... ]
        }
function sortObjects(objects) {
    var newObject = {};
    var arrS = [];
    arrS = sortProperties(objects);
    var sortedArray = arrS[0][1].sort(function(a,b){
      return (a.Unidad - b.Unidad)
    })
    newObject = objects;
  /*for (var i = 0; i < sortedArray.length; i++) {
        var key = sortedArray[i][0];
        var value = sortedArray[i][1];

        newObject[key] = value;

    }*/

    return newObject;

}

//Función encargada de descargar el canvas como imagen
function downloadCanvas(link, canvasId, filename) {
    link.href = document.getElementById(canvasId).toDataURL();
    link.download = filename;
}

window.onload = function(){
graficaMuestraAguaAutoridad();
graficaMuestraAguaCumplimiento();
graficaAguaExcedeLimite();
graficaResiduoGenerado();
graficaEvaluacionesTipo();
graficaIncidentesEstado();
graficaHallazgosEstado();
graficaNoConformidadEstado();
graficaPlanAccionEstado();
cuadrosInfo();
}

//Función para la generación de todas las gráficas cuando se cambia el año
function graficaPorAnno(){
graficaMuestraAguaAutoridad();
graficaMuestraAguaCumplimiento();
graficaAguaExcedeLimite();
graficaResiduoGenerado();
graficaEvaluacionesTipo();
graficaIncidentesEstado();
graficaHallazgosEstado();
graficaNoConformidadEstado();
graficaPlanAccionEstado();
cuadrosInfo();
}
//Apartado para completar la data de los cuadros de información
function cuadrosInfo(){
  var muestra_agua_autoridad = document.getElementById("muestra_agua_autoridad");
  var anno = document.getElementById("Anno").value;
  var uea = muestra_agua_autoridad.dataset.uea;
  var URL_APP = muestra_agua_autoridad.dataset.url;
  var Password = muestra_agua_autoridad.dataset.pass;
  var User = muestra_agua_autoridad.dataset.user;
  var Empresa = muestra_agua_autoridad.dataset.empresa;
  var fb_empleado_id = muestra_agua_autoridad.dataset.empleado;

  //Datos para el cuadro en incidentes
  $.ajax({
    url: URL_APP + '/ws/null/pr_home_inca_mis_incidentes',
    type: 'post',
    crossDomain: true,
    async: true,
    headers: {
      userLogin: User + '@' + Empresa,  
      userPassword: Password,
      systemRoot: 'eco2biz',
    },
    data: {
      anno: anno,
      usuario: fb_empleado_id,
      uea: uea,
    },
  }).done(function (data) {
    if (!data.data[0].fecha) {
      document.getElementById('fecha_mis_incidentes').innerHTML = "Reportados (Último)";
      document.getElementById('mis_incidentes').innerHTML = 0;
    }else{
      document.getElementById('fecha_mis_incidentes').innerHTML = "Reportados (Último " + data.data[0].fecha + " )";
      document.getElementById('mis_incidentes').innerHTML = data.data[0].incidentes;
    }
  });

  //Datos para los cuadros de Acciones
  $.ajax({
    url: URL_APP + '/ws/null/pr_home_planes_de_accion_asignados',
    type: 'post',
    crossDomain: true,
    async: true,
    headers: {
      userLogin: User + '@' + Empresa,  
      userPassword: Password,
      systemRoot: 'eco2biz',
    },
    data: {
      anno: anno,
      fb_empleado_id: fb_empleado_id,
      uea: uea,
    },
  }).done(function (data) {
      document.getElementById('mis_planes').innerHTML = data.data[0].planes;
      document.getElementById('mis_planes_vencidos').innerHTML = "Asignados (" +  data.data[0].plan_vencido + " Vencidos)";
      document.getElementById('mis_planes_pendientes').innerHTML = data.data[0].plan_pendiente;
  });

  //Datos para el cuadro de Desempeño Ambiental
  $.ajax({
    url: URL_APP + '/ws/null/pr_home_kpi_desempeno',
    type: 'post',
    crossDomain: true,
    async: true,
    headers: {
      userLogin: User + '@' + Empresa,  
      userPassword: Password,
      systemRoot: 'eco2biz',
    },
    data: {
      anno: anno,
      fb_empleado_id: fb_empleado_id,
      uea: uea,
    },
  }).done(function (data) {
      if (!data.data[0].desempeno) {
      document.getElementById('cuadro_desempeno').innerHTML = "--";
      document.getElementById('fecha_desempeno').innerHTML = "Última Actualización --";
    }else{
      document.getElementById('cuadro_desempeno').innerHTML = data.data[0].desempeno + "%";
      document.getElementById('fecha_desempeno').innerHTML = "Última Actualización " + data.data[0].Mes + " " + data.data[0].Anno;
    }
  });

  //Datos para la tabla de desempeño ambiental por gerencia al mes
  $.ajax({
    url: URL_APP + '/ws/null/pr_home_kpi_desempeno_ambiental_mensual',
    type: 'post',
    crossDomain: true,
    async: true,
    headers: {
      userLogin: User + '@' + Empresa,  
      userPassword: Password,
      systemRoot: 'eco2biz',
    },
    data: {
      anno: anno,
      uea: uea,
    },
  }).done(function (data) {
    $("#body_tabla").empty();
    var gereEnero = "";
    var gereFebrero = "";
    var gereMarzo = "";
    var gereAbril = "";
    var gereMayo = "";
    var gereJunio = "";
    var gereJulio = "";
    var gereAgosto = "";
    var gereSeptiembre = "";
    var gereOctubre = "";
    var gereNoviembre = "";
    var gereDiciembre = "";

      data.data.forEach(function (name, index) {
        if(!name.Enero){
         gereEnero = '<td></td>'
        } else if(name.Enero > 85){
          gereEnero ='<td><i class="fa fa-circle text-success"></i></td>'
        } else{
          gereEnero ='<td><i class="fa fa-circle text-danger"></i></td>'
        }
        if(!name.Febrero){
         gereFebrero = '<td></td>'
        } else if(name.Febrero > 85){
          gereFebrero ='<td><i class="fa fa-circle text-success"></i></td>'
        } else{
          gereFebrero ='<td><i class="fa fa-circle text-danger"></i></td>'
        }
        if(!name.Marzo){
         gereMarzo = '<td></td>'
        } else if(name.Marzo > 85){
          gereMarzo ='<td><i class="fa fa-circle text-success"></i></td>'
        } else{
          gereMarzo ='<td><i class="fa fa-circle text-danger"></i></td>'
        }
        if(!name.Abril){
         gereAbril = '<td></td>'
        } else if(name.Abril > 85){
          gereAbril ='<td><i class="fa fa-circle text-success"></i></td>'
        } else{
          gereAbril ='<td><i class="fa fa-circle text-danger"></i></td>'
        }
        if(!name.Mayo){
         gereMayo = '<td></td>'
        } else if(name.Mayo > 85){
          gereMayo ='<td><i class="fa fa-circle text-success"></i></td>'
        } else{
          gereMayo ='<td><i class="fa fa-circle text-danger"></i></td>'
        }
        if(!name.Junio){
         gereJunio = '<td></td>'
        } else if(name.Junio > 85){
          gereJunio ='<td><i class="fa fa-circle text-success"></i></td>'
        } else{
          gereJunio ='<td><i class="fa fa-circle text-danger"></i></td>'
        }
        if(!name.Julio){
         gereJulio = '<td></td>'
        } else if(name.Julio > 85){
          gereJulio ='<td><i class="fa fa-circle text-success"></i></td>'
        } else{
          gereJulio ='<td><i class="fa fa-circle text-danger"></i></td>'
        }
        if(!name.Agosto){
         gereAgosto = '<td></td>'
        } else if(name.Agosto > 85){
          gereAgosto ='<td><i class="fa fa-circle text-success"></i></td>'
        } else{
          gereAgosto ='<td><i class="fa fa-circle text-danger"></i></td>'
        }
        if(!name.Septiembre){
         gereSeptiembre = '<td></td>'
        } else if(name.Septiembre > 85){
          gereSeptiembre ='<td><i class="fa fa-circle text-success"></i></td>'
        } else{
          gereSeptiembre ='<td><i class="fa fa-circle text-danger"></i></td>'
        }
        if(!name.Octubre){
         gereOctubre = '<td></td>'
        } else if(name.Octubre > 85){
          gereOctubre ='<td><i class="fa fa-circle text-success"></i></td>'
        } else{
          gereOctubre ='<td><i class="fa fa-circle text-danger"></i></td>'
        }
        if(!name.Noviembre){
         gereNoviembre = '<td></td>'
        } else if(name.Noviembre > 85){
          gereNoviembre ='<td><i class="fa fa-circle text-success"></i></td>'
        } else{
          gereNoviembre ='<td><i class="fa fa-circle text-danger"></i></td>'
        }
        if(!name.Diciembre){
         gereDiciembre = '<td></td>'
        } else if(name.Diciembre > 85){
          gereDiciembre ='<td><i class="fa fa-circle text-success"></i></td>'
        } else{
          gereDiciembre ='<td><i class="fa fa-circle text-danger"></i></td>'
        }
      $('#tabla_desempeno_ambiental > tbody:last-child').append(
      '<tr>'+
        '<td>' + name.item + '</td>'+
        '<td class="txt-rojo">'+ name.gerencia+'</td>'+ 
         gereEnero + gereFebrero + gereMarzo + gereAbril + gereMayo + gereJunio + gereJulio + gereAgosto + gereSeptiembre + gereOctubre + gereNoviembre + gereDiciembre +
      '</tr>');
    });
  });

}
//Función para la generación de la gráfica Muestras de Agua por Autoridad
function graficaMuestraAguaAutoridad(){

  var muestra_agua_autoridad = document.getElementById("muestra_agua_autoridad");
  var anno = document.getElementById("Anno").value;
  var uea = muestra_agua_autoridad.dataset.uea;
  var URL_APP = muestra_agua_autoridad.dataset.url;
  var Password = muestra_agua_autoridad.dataset.pass;
  var User = muestra_agua_autoridad.dataset.user;
  var Empresa = muestra_agua_autoridad.dataset.empresa;
  var bodyData = {
        anno
      };
  if (allCharts["MuestraAguaAutoridadBar"]) {
      allCharts["MuestraAguaAutoridadBar"].clear();
      allCharts["MuestraAguaAutoridadBar"].destroy();
  }
  generaGraficasStored("MuestraAguaAutoridadBar",'pr_graf_ma_muestras_autoridad',bodyData,URL_APP,User,Password,Empresa, '', muestra_agua_autoridad, 'bar', 'bottom', true);

}

//Función para la generación de la gráfica Muestras de Agua por Cumplimiento
function graficaMuestraAguaCumplimiento(){

  var muestra_agua_cumplimiento = document.getElementById("muestra_agua_cumplimiento");
  var anno = document.getElementById("Anno").value;
  var uea = muestra_agua_cumplimiento.dataset.uea;
  var URL_APP = muestra_agua_cumplimiento.dataset.url;
  var Password = muestra_agua_cumplimiento.dataset.pass;
  var User = muestra_agua_cumplimiento.dataset.user;
  var Empresa = muestra_agua_cumplimiento.dataset.empresa;
  var bodyData = {
        anno
      };
  if (allCharts["MuestraAguaCumplimientoBar"]) {
      allCharts["MuestraAguaCumplimientoBar"].clear();
      allCharts["MuestraAguaCumplimientoBar"].destroy();
  }
  generaGraficasStored("MuestraAguaCumplimientoBar",'pr_graf_ma_muestras_cumplimiento',bodyData,URL_APP,User,Password,Empresa, '', muestra_agua_cumplimiento, 'bar', 'bottom', true);

}

//Función para la generación de la gráfica Parámetros de Agua que Exceden Límites
function graficaAguaExcedeLimite(){

  var agua_excede = document.getElementById("agua_excede");
  var anno = document.getElementById("Anno").value;
  var uea = agua_excede.dataset.uea;
  var URL_APP = agua_excede.dataset.url;
  var Password = agua_excede.dataset.pass;
  var User = agua_excede.dataset.user;
  var Empresa = agua_excede.dataset.empresa;
  var bodyData = {
        anno
      };
  if (allCharts["AguaExcedePie"]) {
      allCharts["AguaExcedePie"].clear();
      allCharts["AguaExcedePie"].destroy();
  }
  generaGraficasStored("AguaExcedePie",'pr_graf_ma_parametros_cumplmiento',bodyData,URL_APP,User,Password,Empresa, '', agua_excede, 'pie', 'bottom', false);

}

//Función para la generación de la gráfica Residuos Generados
function graficaResiduoGenerado(){

  var residuo_generado = document.getElementById("residuo_generado");
  var anno = document.getElementById("Anno").value;
  var uea = residuo_generado.dataset.uea;
  var URL_APP = residuo_generado.dataset.url;
  var Password = residuo_generado.dataset.pass;
  var User = residuo_generado.dataset.user;
  var Empresa = residuo_generado.dataset.empresa;
  var bodyData = {
        anno
      };
  if (allCharts["ResiduoGeneradoBar"]) {
      allCharts["ResiduoGeneradoBar"].clear();
      allCharts["ResiduoGeneradoBar"].destroy();
  }
  generaGraficasStored("ResiduoGeneradoBar",'pr_graf_rs_residuos_generados',bodyData,URL_APP,User,Password,Empresa, '', residuo_generado, 'bar', 'bottom', true);

}

//Función para la generación de la gráfica Evaluaciones Por Tipo
function graficaEvaluacionesTipo(){

  var evaluaciones_tipo = document.getElementById("evaluaciones_tipo");
  var anno = document.getElementById("Anno").value;
  var uea = evaluaciones_tipo.dataset.uea;
  var URL_APP = evaluaciones_tipo.dataset.url;
  var Password = evaluaciones_tipo.dataset.pass;
  var User = evaluaciones_tipo.dataset.user;
  var Empresa = evaluaciones_tipo.dataset.empresa;
  var bodyData = {
        anno
      };
  if (allCharts["EvaluacionesTipoBar"]) {
      allCharts["EvaluacionesTipoBar"].clear();
      allCharts["EvaluacionesTipoBar"].destroy();
  }
  generaGraficasStored("EvaluacionesTipoBar",'pr_graf_eva_evaluaciones_por_tipo',bodyData,URL_APP,User,Password,Empresa, '', evaluaciones_tipo, 'bar', 'bottom', true);

}

//Función para la generación de la gráfica Incidentes Por Estado
function graficaIncidentesEstado(){

  var incidentes_estado = document.getElementById("incidentes_estado");
  var anno = document.getElementById("Anno").value;
  var uea = incidentes_estado.dataset.uea;
  var URL_APP = incidentes_estado.dataset.url;
  var Password = incidentes_estado.dataset.pass;
  var User = incidentes_estado.dataset.user;
  var Empresa = incidentes_estado.dataset.empresa;
  var bodyData = {
        anno
      };
  if (allCharts["IncidentesEstadoBar"]) {
      allCharts["IncidentesEstadoBar"].clear();
      allCharts["IncidentesEstadoBar"].destroy();
  }
  generaGraficasStored("IncidentesEstadoBar",'pr_graf_inc_incidentes_estado',bodyData,URL_APP,User,Password,Empresa, '', incidentes_estado, 'bar', 'bottom', true);

}

//Función para la generación de la gráfica Hallazgos Por Estado
function graficaHallazgosEstado(){

  var hallazgos_estado = document.getElementById("hallazgos_estado");
  var anno = document.getElementById("Anno").value;
  var uea = hallazgos_estado.dataset.uea;
  var URL_APP = hallazgos_estado.dataset.url;
  var Password = hallazgos_estado.dataset.pass;
  var User = hallazgos_estado.dataset.user;
  var Empresa = hallazgos_estado.dataset.empresa;
  var bodyData = {
        anno
      };
  if (allCharts["HallazgosEstadoBar"]) {
      allCharts["HallazgosEstadoBar"].clear();
      allCharts["HallazgosEstadoBar"].destroy();
  }
  generaGraficasStored("HallazgosEstadoBar",'pr_graf_eva_hallazgos_estado',bodyData,URL_APP,User,Password,Empresa, '', hallazgos_estado, 'bar', 'bottom', true);

}

//Función para la generación de la gráfica No Conformidades Por Estado
function graficaNoConformidadEstado(){

  var conformidades_estado = document.getElementById("conformidades_estado");
  var anno = document.getElementById("Anno").value;
  var uea = conformidades_estado.dataset.uea;
  var URL_APP = conformidades_estado.dataset.url;
  var Password = conformidades_estado.dataset.pass;
  var User = conformidades_estado.dataset.user;
  var Empresa = conformidades_estado.dataset.empresa;
  var bodyData = {
        anno
      };
  if (allCharts["NoConformidadEstadoBar"]) {
      allCharts["NoConformidadEstadoBar"].clear();
      allCharts["NoConformidadEstadoBar"].destroy();
  }
  generaGraficasStored("NoConformidadEstadoBar",'pr_graf_eva_no_conformidad_estado',bodyData,URL_APP,User,Password,Empresa, '', conformidades_estado, 'bar', 'bottom', true);

}

//Función para la generación de la gráfica Planes de Acción por Estado
function graficaPlanAccionEstado(){

  var planes_estado = document.getElementById("planes_estado");
  var anno = document.getElementById("Anno").value;
  var uea = planes_estado.dataset.uea;
  var URL_APP = planes_estado.dataset.url;
  var Password = planes_estado.dataset.pass;
  var User = planes_estado.dataset.user;
  var Empresa = planes_estado.dataset.empresa;
  var bodyData = {
        anno
      };
  if (allCharts["PlanAccionEstadoBar"]) {
      allCharts["PlanAccionEstadoBar"].clear();
      allCharts["PlanAccionEstadoBar"].destroy();
  }
  generaGraficasStored("PlanAccionEstadoBar",'pr_graf_sac_acciones_estado',bodyData,URL_APP,User,Password,Empresa, '', planes_estado, 'bar', 'bottom', true);

}

//Función para la generación de gráficas mediante storedProcedure
function generaGraficasStored(ChartName, stored,bodyData, Url, User, Pass, Empresa, title, canvasName, chartType, lPosition, isStacked){
  $.ajax({ 
    url: Url + '/ws/null/' + stored,
    type: 'post',
    crossDomain: true,
    async: true,
    headers: {
      userLogin: User + '@' + Empresa,
      userPassword: Pass,
      systemRoot: 'eco2biz',
    },
    data: bodyData,
  })
  .done(function(data) {
    var data1 = {
    labels: [],
    datasets: []
    };
    var NewDataset = {};
    if (data.data.length>0) {
      var Unidad = "";  
      var Unidades = [];
      var Nombre = "";
      var Nombres = [];
      var Tipos = [];
      var Tipo = "";
      var i = 2;
      var j = 0;
      var xAxesGridLines = true;
      var yAxesGridLines = true;
      var xAxesLabel = true;
      var yAxesLabel = true;
      var Legend = true;
      var ColorPeligro = ""
      var BorderPeligro = ""
      var Legend = ""
      var newLabel = {};
      data.data.forEach(function (control, index) {
        Object.keys(control).forEach(function(name,index){
          if(name == "Nombre"){
            Nombre = control[name]
            Nombres.push(Nombre)
            return;
          }
          if(name == "Unidad"){
            Unidad = control[name]
            Unidades.push(Unidad)
            newLabel[Unidad] = [Unidad]            
          }else if(Tipos.includes(name)){
            dat = control[name]
            if(!dat){dat = 0} else{dat = parseInt(dat)}
            NewDataset[name].data.push(dat)
          }else{
            dat = control[name]
            if(!dat){dat = 0} else{dat = parseInt(dat)}
            Tipo = name
          if(Tipo == 'No_Peligroso'){
              Legend = "No Peligroso"
              ColorPeligro = Colors[1]
              BorderPeligro = BorderColors[1]
            }else if (Tipo == 'Peligroso'){
              Legend = 'Peligroso'
              ColorPeligro = Colors[2]
              BorderPeligro = BorderColors[2]
            }else{
              Legend = Tipo
              ColorPeligro = Colors[i]
              BorderPeligro = BorderColors[i]
            }
            Tipos.push(Tipo)
            NewDataset[Tipo] = 
            {
            label : Legend,
            backgroundColor: ColorPeligro, 
            borderColor: BorderPeligro,
            borderWidth: 1,
            data: [dat]
            };  
          }
          i++;
        })
      });

      //Asignar valor a la variable global para el título del ToolTip
      Unidades.forEach(function(unidad, index)
      {
        tooltipTile[unidad] = Nombres[index];
      });

      Unidades.forEach(function(unidad, index)
      {
        data1.labels.push(unidad);
      });

      Tipos.forEach(function(tipo, index)
      {
        data1.datasets.push(NewDataset[tipo]);
      });
      if(Tipos[0] == Unidades[0]){
        Legend = false;
      }
      if(chartType == 'pie' || chartType == 'doughnut'){
        var bgc = [];
        var bc = [];
        for (j = 0; j < data1.labels.length; j++) {
          bgc.push(Colors[j]);
          bc.push(BorderColors[j]);
        }
        data1.datasets[0].backgroundColor = bgc;
        data1.datasets[0].borderColor = bc;
        xAxesGridLines = false;
        yAxesGridLines = false;
        xAxesLabel = false;
        yAxesLabel = false;
      }
      else{
        xAxesLabel = true;
        yAxesLabel = true;
        xAxesGridLines = false;
        yAxesGridLines = true;
      };
    }
      allCharts[ChartName] = new Chart(canvasName, {
          type: chartType,
          data: data1,
          options: {
            responsive: true,
            mantainAspectRatio:true,
            pieceLabel: {
            render: 'percentage',
            fontSize: 10,
            fontStyle: 'bold',
            fontColor: '#000000',
            /*function (data) {
            var rgb = (data.dataset.backgroundColor[data.index]);
            var threshold = 140;
            var luminance = 0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b;
            return luminance > threshold ? 'black' : 'white';
    },*/
            fontFamily: '"Arial", Monaco, monospace',
            precision: 2
  },
            title: {
              display: true,
              text: title,
            },
            legend: {
              display: Legend,
              position: lPosition,
              labels:{
                fontSize:10,
              },
            },
            scales: {
               xAxes: [{
                stacked: isStacked,
                display: xAxesLabel,
                barThickness : 50,
                gridLines:{
                  display: xAxesGridLines,
                },                
                ticks:{
                  autoSkip:false,
                  fontSize : 10,
                },
            }],
              yAxes: [{
                stacked:isStacked,
                display:yAxesLabel,
                gridLines:{
                  display: yAxesGridLines,
                },
              }],
            },  
            tooltips: {
              enabled: true,
          }
          }
        });
    });
}

//Función para la generación de la gráfica por Mes
function generaGraficasMesResiduo(ChartName, stored, bodyData, Url, User, Pass, Empresa, title, canvasName, chartType, lPosition, isStacked){
  $.ajax({ 
    url: Url + '/ws/null/' + stored,
    type: 'post',
    crossDomain: true,
    async: true,
    headers: {
      userLogin: User + '@' + Empresa,
      userPassword: Pass,
      systemRoot: 'eco2biz',
    },
    data:bodyData,
  })
  .done(function(data) {
    var data1 = {
    labels: [],
    datasets: []
    };
    var NewDataset = {};
    var sortObj = {};
    sortObj = sortObjects(data);
    data = sortObj;
    if (data.data.length>0) {
      var Mes = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
      var Unidad = "";  
      var Unidades = [];
      var Nombre = "";
      var Nombres = [];
      var Tipos = [];
      var Tipo = "";
      var i = 0;
      var j = 0;
      var ColorPeligro = "";
      var Legend = "";
      var newLabel = {};
      data.data.forEach(function (control, index) {
        Object.keys(control).forEach(function(name,index){
          if(name == "Nombre"){
            Nombre = control[name]
            Nombres.push(Nombre)
            return;
          }
          if(name == "Unidad"){
            Unidad = control[name]
            Unidades.push(Unidad)
            newLabel[Unidad] = [Unidad]            
          }else if(Tipos.includes(name)){
            dat = control[name]
            if(!dat){dat = 0} else{dat = parseFloat(dat/1000).toFixed(2)}
            NewDataset[name].data.push(dat)
          }else{
            dat = control[name]
            if(!dat){dat = 0} else{dat = parseFloat(dat/1000).toFixed(2)}
            Tipo = name
            if(Tipo == "0"){
              Legend = "No Peligroso"
              ColorPeligro = Colors[1]
            }else{
              Legend = "Peligroso"
              ColorPeligro = Colors[2]
            }
            Tipos.push(Tipo)
            NewDataset[Tipo] = 
            {
            label : Legend,
            backgroundColor: ColorPeligro, 
            borderColor: ColorPeligro,
            borderWidth: 1,
            data: [dat]
            };
          }
          i++;
        })
      });

      /*Asignar valor a la variable global para el título del ToolTip
      Unidades.forEach(function(unidad, index)
      {
        tooltipTile[unidad] = Nombres[index];
      });
      */
        Mes.forEach(function(mes,index)
        {
          data1.labels.push(mes);
          switch(mes){
            case "Enero":
            if(!Unidades.includes(1)){
              if(NewDataset["0"] !== undefined){
                NewDataset["0"].data.splice(0,0,0);  
              }
              if(NewDataset["1"] !== undefined){
               NewDataset["1"].data.splice(0,0,0); 
              }
              break;
            }else{
              break;
            }
            case "Febrero":
            if(!Unidades.includes(2)){
              if(NewDataset["0"] !== undefined){
              NewDataset["0"].data.splice(1,0,0);
              }
              if(NewDataset["1"] !== undefined){
              NewDataset["1"].data.splice(1,0,0);
              }
              break;
            }else{
              break;
            }
            case "Marzo":
            if(!Unidades.includes(3)){
              if(NewDataset["0"] !== undefined){
              NewDataset["0"].data.splice(2,0,0);
            }
            if(NewDataset["1"] !== undefined){
              NewDataset["1"].data.splice(2,0,0);
            }
              break;
            }else{
              break;
            }
            case "Abril":
            if(!Unidades.includes(4)){
              if(NewDataset["0"] !== undefined){
              NewDataset["0"].data.splice(3,0,0);
            }
              if(NewDataset["1"] !== undefined){
                NewDataset["1"].data.splice(3,0,0);
              }
              break;
            }else{
              break;
            }
            case "Mayo":
            if(!Unidades.includes(5)){
              if(NewDataset["0"] !== undefined){
                NewDataset["0"].data.splice(4,0,0);
              }
              if(NewDataset["1"] !== undefined){
                NewDataset["1"].data.splice(4,0,0);
              }
              break;
            }else{
              break;
            }
            case "Junio":
            if(!Unidades.includes(6)){
              if(NewDataset["0"] !== undefined){
                NewDataset["0"].data.splice(5,0,0);
              }
              if(NewDataset["1"] !== undefined){
                NewDataset["1"].data.splice(5,0,0);
              }
              break;
            }else{
              break;
            }
            case "Julio":
            if(!Unidades.includes(7)){
              if(NewDataset["0"] !== undefined){
                NewDataset["0"].data.splice(6,0,0);
              }
              if(NewDataset["1"] !== undefined){
                NewDataset["1"].data.splice(6,0,0);
              }
              break;
            }else{
              break;
            }
            case "Agosto":
            if(!Unidades.includes(8)){
              if(NewDataset["0"] !== undefined){
                NewDataset["0"].data.splice(7,0,0);
              }
              if(NewDataset["1"] !== undefined){
                NewDataset["1"].data.splice(7,0,0);
              }
              break;
            }else{
              break;
            }
            case "Septiembre":
            if(!Unidades.includes(9)){
              if(NewDataset["0"] !== undefined){
                NewDataset["0"].data.splice(8,0,0);
              }
              if(NewDataset["1"] !== undefined){
                NewDataset["1"].data.splice(8,0,0);
              }
              break;
            }else{
              break;
            }
            case "Octubre":
            if(!Unidades.includes(10)){
              if(NewDataset["0"] !== undefined){
                NewDataset["0"].data.splice(9,0,0);
              }
              if(NewDataset["1"] !== undefined){
                NewDataset["1"].data.splice(9,0,0);
              }
              break;
            }else{
              break;
            }
            case "Noviembre":
            if(!Unidades.includes(11)){
              if(NewDataset["0"] !== undefined){
                NewDataset["0"].data.splice(10,0,0);
              }
              if(NewDataset["1"] !== undefined){
                NewDataset["1"].data.splice(10,0,0);
              }
              break;
            }else{
              break;
            }
            case "Diciembre":
            if(!Unidades.includes(12)){
              if(NewDataset["0"] !== undefined){
                NewDataset["0"].data.splice(11,0,0);
              }
              if(NewDataset["1"] !== undefined){
                NewDataset["1"].data.splice(11,0,0);
              }
              break;
            }else{
              break;
            }                            
          }
        });

      Tipos.forEach(function(tipo, index)
      {
        data1.datasets.push(NewDataset[tipo]);
      });
      if(chartType == 'pie'){
        var bgc = [];
        var bc = [];
        for (j = 0; j < data1.labels.length; j++) {
          bgc.push(Colors[j]);
          bc.push(BorderColors[j]);
        }
        data1.datasets[0].backgroundColor = bgc;
        data1.datasets[0].borderColor = bc;
      };
    }
      allCharts[ChartName] = new Chart(canvasName, {
          type: chartType,
          data: data1,
          options: {
            responsive: true,
            mantainAspectRatio:false,
            title: {
              display: true,
              text: title,
            },
            legend: {
              display: true,
              position: lPosition,
              labels:{
                fontSize:15,
              },
            },
            scales: {
               xAxes: [{
                stacked: isStacked,
                gridLines:{
                  display:false,
                },
                ticks:{
                  fontSize: 12,
                  autoSkip: false,
                }
            }],
              yAxes: [{
                stacked:isStacked,
                gridLines:{
                  display:true,
                },
              }]
            },  
            tooltips: {
          enabled: true,
          mode: 'nearest',
          intersect: true,
          }
          }
        });
    });
}



