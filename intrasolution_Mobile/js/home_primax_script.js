Chart.defaults.global.tooltips.custom = function (tooltip) {
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
	  
	  innerHtml += '<tr><td>' + span + '<span class="fon">' + body + '</span></td></tr>';
	   
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
  //tooltipEl.style.fontFamily = tooltip._fontFamily; 
  //tooltipEl.style.fontSize = tooltip.fontSize;
  tooltipEl.style.fontStyle = tooltip._fontStyle;
  tooltipEl.style.padding = tooltip.yPadding + 'px ' + tooltip.xPadding + 'px';
  Chart.defaults.global.defaultFontFamily = "verdana"; 
  Chart.defaults.global.defaultFontSize = 60;
};
var exaChart;
var accChart;
var sacChart;
var charts = {};
window.onload = function () {

  // var Empresa = document.getElementById("empresa").value;
  // var UEA = document.getElementById("UEA").value;
  // var Anno = document.getElementById("anno").value;
  $('span.pie').peity('pie', {
    fill: [
      '#17884f',
      '#bbbbbb',
    ],
  });
  onLoadCharts();
};

var backgroundColor = {
  exaColor: [
    '#3366cc',
    '#ff9900',
    '#81b6e8',
    '#71dce8',
      ],
  sacColor: [
    '#ff9900',
    '#dc3912',
    '#109618',
  ],
  accColor: [
    '#990099',
    '#ff9900',
    '#dc3912',
    '#bbf0d1',
  ],
};



function onLoadCharts() {
  exaChart = document.getElementById('exaChart');
  accChart = document.getElementById('accChart');
  sacChart = document.getElementById('sacChart');

  var container = document.getElementById('container');
  var Empresa = container.dataset.empresa;
  var User = container.dataset.user;
  var Password = container.dataset.pass;
  var URL_APP = container.dataset.urlapp;
  var UEA = Number(container.dataset.uea);
  var Anno = document.getElementById('anno').value;
  $.ajax({
    url: URL_APP + '/ws/null/pr_cap_Estad_Capacitacion_Unidad/',
    type: 'post',
    crossDomain: true,
    async: true,
    headers: {
      userLogin: User + '@' + Empresa,
      userPassword: Password,
      systemRoot: 'safe2biz',
    },
    data: {
      fb_uea_pe_id: UEA,
      Anno: Anno,
    },
  }).done(function (data) {
    document.getElementById('cantCursos').innerHTML = data.data[0].Cantidad_Cursos;
    document.getElementById('cantAsist').innerHTML = data.data[0].Cantidad_Asistentes;
    document.getElementById('cantPersonas').innerHTML = data.data[0].Cantidad_Personas;
    document.getElementById('totalHoras').innerHTML = data.data[0].Total_Horas_Capacitadas;
    if (data.data[0].Cantidad_Personas === 0) {
      document.getElementById('horaProm').innerHTML = 0;
    }else{
      document.getElementById('horaProm').innerHTML = Math.round(data.data[0].Total_Horas_Capacitadas / data.data[0].Cantidad_Personas);
    }
  });

  $.ajax({
    url: URL_APP + '/ws/null/pr_exa_Aptitud_Cantidad/',
    type: 'post',
    crossDomain: true,
    async: true,
    headers: {
      userLogin: User + '@' + Empresa,
      userPassword: Password,
      systemRoot: 'safe2biz',
    },
    data: {
      fb_uea_pe_id: UEA,
      Anno: Anno,
    },
  }).done(function (data) {
    var data1 = {
      labels: [],
      datasets: [{
        data: [],
        backgroundColor: backgroundColor.exaColor,
      },
    ],
    };
    var cantidadExamenes = 0;
    data.data.forEach(function (data, index) {
      data1.labels.push(data.Aptitud);
      data1.datasets[0].data.push(data.Cantidad);
      cantidadExamenes += data.Cantidad;
    });

    document.getElementById('examenes').innerHTML = cantidadExamenes;

    if (charts.exaPieChart !== undefined) {
      charts.exaPieChart.destroy();
    }

    charts.exaPieChart = new Chart(exaChart, {
      type: 'pie',
      data: data1,
      options: {
        responsive: true,
        legend: {
          display: false,
        },
        title: {
          display: true,
          fontSize: 14,
		  fontColor: "black",
		  fontfamily: "arial",
		  bodyFontFamily: "'arial', 'Arial', sans-serif",
          /* fontColor: backgroundColor.exaColor[0], */
          position: 'bottom',
          text: 'Por Aptitud',
        },
        tooltips: {
          enabled: false,
        },
      },
    });

  });

  $.ajax({
    url: URL_APP + '/ws/null/pr_grp_inc_Tipo/',
    type: 'post',
    crossDomain: true,
    async: true,
    headers: {
      userLogin: User + '@' + Empresa,
      userPassword: Password,
      systemRoot: 'safe2biz',
    },
    data: {
      fb_uea_pe_id: UEA,
      Anno: Anno,
    },
  }).done(function (data) {
    var data1 = {
      labels: [],
      datasets: [{
        data: [],
        backgroundColor: backgroundColor.accColor,
      },
    ],
    };
    var cantidadReportes = 0;
    data.data.forEach(function (data, index) {
      data1.labels.push(data.Tipo_Incidente);
      data1.datasets[0].data.push(data.Cantidad);
      cantidadReportes += data.Cantidad;
    });

    document.getElementById('accidentes').innerHTML = cantidadReportes;
    if (charts.accPieChart !== undefined) {
      charts.accPieChart.destroy();
    }
    charts.accPieChart = new Chart(accChart, {
      type: 'pie',
      data: data1,
      options: {
        responsive: true,
        legend: {
          display: false,
        },
        title: {
          display: true,
          fontSize: 14,
		  fontColor: "black",
          //fontColor: backgroundColor.accColor[0], */
		  position: 'bottom',
          text: 'Por Tipo de Accidente',
        },
        tooltips: {
          enabled: false,
        },
      },
    });
  });

  $.ajax({
    url: URL_APP + '/ws/null/pr_cap_Pendiente_Horas_Ley_Corp/',
    type: 'post',
    crossDomain: true,
    async: true,
    headers: {
      userLogin: User + '@' + Empresa,
      userPassword: Password,
      systemRoot: 'safe2biz',
    },
    data: {
      fb_uea_pe_id: UEA,
      Anno: Anno,
      flag_alcance: 1,
    },
  }).done(function (data) {
    document.getElementById('hhCap').innerHTML = data.data[0].Cantidad_HH_Corp;

      var meter = new RGraph.Meter({
        id: 'cvs',
        min: 0,
        max: 100,
        value: data.data[0].Cantidad_HH_Asistidas / data.data[0].Cantidad_HH_Corp * 100,
        options: {
            anglesStart: RGraph.PI,
            anglesEnd: RGraph.TWOPI,
            linewidthSegments: 0,
            textSize: 10,
            strokestyle: 'white',
            segmentRadiusStart: 70,
            valueText: true,
            valueTextUnitsPost: '%',
            border: 0,
            tickmarksSmallNum: 20,
            tickmarksBigNum: 4,
            gutterTop: 0,
            gutterBottom: 10,
            gutterLeft: 0,
            gutterRight: 0,
            labelsSpecific: [['Malo', 5], ['25%', 25], ['50%', 50], ['75%', 75], ['Bueno', 95]],
            adjustable: false,
            tickmarksSmallColor: 'black',
            greenStart: 90,
            greenEnd: 100,
            yellowStart: 75,
            yellowEnd: 90,
            redStart: 0,
            redEnd: 75,
            resizable: false,
            colorsRanges: [
                [0, 75, 'Gradient(#f00:#faa:#c00:#600)'],
                [75, 90, 'Gradient(#ff0:#ffa:#cc0:#330)'],
                [90, 100, 'Gradient(#0f0:#afa:#0c0:#060)'],
            ],
          },
      }).on('beforedraw', function (obj)
    {
        RGraph.clear(obj.canvas, 'white');
      }).draw();
    });

    $.ajax({
      url: URL_APP + '/ws/null/pr_grp_sac_Acciones_Estado/',
      type: 'post',
      crossDomain: true,
      async: true,
      headers: {
        userLogin: User + '@' + Empresa,
        userPassword: Password,
        systemRoot: 'safe2biz',
      },
      data: {
        fb_uea_pe_id: UEA,
        Anno: Anno,
      },
    }).done(function (data) {
      var data1 = {
        labels: [],
        datasets: [{
          data: [],
          backgroundColor: backgroundColor.sacColor,
        },
      ],
      };
      var cantidadAcciones = 0;
      data.data.forEach(function (data, index) {
        data1.labels.push(data.Estado);
        data1.datasets[0].data.push(data.Cantidad);
        cantidadAcciones += data.Cantidad;
      });

      document.getElementById('acciones').innerHTML = cantidadAcciones;
      if (charts.sacPieChart !== undefined) {
        charts.sacPieChart.destroy();
      }
      charts.sacPieChart = new Chart(sacChart, {
        type: 'pie',
        data: data1,
        options: {
          responsive: true,
          legend: {
            display: false,
          },
          title: {
            display: true,
            fontSize: 14,
			fontColor: "black",
			//fontColor: backgroundColor.sacColor[0],
			position: 'bottom',
            text: 'Por Estado',
			  
          },
          tooltips: {
            enabled: false,
          },
        },
      });
    });
}
