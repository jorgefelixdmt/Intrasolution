Chart.defaults.global.tooltips.custom = function(tooltip) {
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

    titleLines.forEach(function(title) {
      innerHtml += '<tr><th>' + title + '</th></tr>';
    });
    innerHtml += '</thead><tbody>';

    bodyLines.forEach(function(body, i) {
      var colors = tooltip.labelColors[i];
      var style = 'background:' + colors.backgroundColor;
      style += '; border: 1px solid white;';
      // style += '; border-width: 2px;';
      var span = '<span class="chartjs-tooltip-key" style="' + style + '"></span>';
      innerHtml += '<tr><td>' + span + body + '</td></tr>';
    });
    innerHtml += '</tbody>';

    var tableRoot = tooltipEl.querySelector('table');
    tableRoot.innerHTML = innerHtml;
  }

  var position = this._chart.canvas.getBoundingClientRect();

  // Display, position, and set styles for font
  tooltipEl.style.opacity = 1;
  // tooltipEl.style.position = flex;
  tooltipEl.style.left = event.clientX + document.body.scrollLeft + "px";
  tooltipEl.style.top = event.clientY + document.body.scrollTop + 12 + "px";
  tooltipEl.style.fontFamily = tooltip._fontFamily;
  tooltipEl.style.fontSize = tooltip.fontSize;
  tooltipEl.style.fontStyle = tooltip._fontStyle;
  tooltipEl.style.padding = tooltip.yPadding + 'px ' + tooltip.xPadding + 'px';
};

window.onload = function() {
  // var Empresa = document.getElementById("empresa").value;
  // var UEA = document.getElementById("UEA").value;
  // var Anno = document.getElementById("anno").value;
  onLoadCharts();
  $("span.pie").peity("pie",{
    fill: ["#17884f", "#bbbbbb"]
  });
};

var backgroundColor = {
  aguaColor : [
    "#403c71",
    "#5763b3",
    "#81b6e8",
    "#71dce8"
  ],
  ruidoColor : [
    "#9d5c32",
    "#b37857",
    "#e8b281"
  ],
  accColor : [
    "#3c7146",
    "#58b377",
    "#81e8ad",
    "#bbf0d1"
  ]
};

function onLoadCharts() {
  const reqChart = document.getElementById("reqChart");
  const accChart = document.getElementById("accChart");
  const comChart = document.getElementById("comChart");
  document.getElementById("requisitos").innerHTML = "...";
  $.ajax({
    url : "http://localhost:8080/node/mobile/charts?empresa='col_desarrollo'",
    type : "get",
    crossDomain : true,
    async: true,
  }).done(function(data) {

    // Requisitos
    document.getElementById("requisitos").innerHTML = data.requisitos[0].NumRequisitos;
    const data1 = {
      labels: ["Pendientes", "Ejecutados"],
      datasets: [{
        data: [data.requisitos[0].NumRequisitos - data.requisitos[0].NumRequisitosEjecutados, data.requisitos[0].NumRequisitosEjecutados],
        backgroundColor: [
          'rgba(255, 211, 112, 1)',
          'rgba(255, 188, 75, 1)'
        ]
      }]
    };
    const reqPieChart = new Chart(reqChart,{
      type: 'pie',
      data: data1,
      options: {
        responsive: true,
        legend: {
          display: true,
          position: 'bottom'
        },
        tooltips: {
          enabled: false,
        }
      }
    });

    //Accidentes
    const data2 = {
      labels: [],
      datasets: [{
        data: [],
        backgroundColor: backgroundColor["accColor"]
      }]
    };
    data.incidentes.forEach(function (data, index) {
      data2.labels.push(data.tipo_reporte_nombre);
      data2.datasets[0].data.push(data.NumIncidentes);
    });
    const accPieChart = new Chart(accChart,{
      type: 'pie',
      data: data2,
      options: {
        responsive: true,
        legend: {
          display: false
        },
        title: {
          display: true,
          fontSize: 12,
          fontColor: backgroundColor["accColor"][0],
          position: 'bottom',
          text: 'Por Tipo de Accidente'
        },
        tooltips: {
          enabled: false,
        }
      }
    });

    //Auditorias
    data.auditorias.forEach(function (data, index) {
      $('#auditorias > tbody:last-child').append(
      '<tr>'+
        '<td><img src="./images/sem-ver.png" alt="ver"></td>'+
        '<td>'+data.TituloAuditoria+'</td>'+
        '<td>'+data.fecha+'</td>'+
        '<td>'+data.NumNoConformidad+'</td>'+
        '<td>'+data.NumHallazgos+'</td>'+
        '<td>50 <span class="pie">5/10</span></td>'+
      '</tr>');
    });
    //Iperc
    data.iperc.forEach(function (data, index) {
      $('#iperc > tbody:last-child').append(
      '<tr>'+
        '<td>'+data.MatrizNombre+'</td>'+
        '<td>'+data.NumPeligros+'</td>'+
        '<td>'+data.NumControles+'</td>'+
        '<td><span class="pie">5/10</span></td>'+
      '</tr>');
    });
    $("span.pie").peity("pie",{
      fill: ["#17884f", "#bbbbbb"]
    });
  });

      const data3 = {
            labels: ["Pendientes", "Ejecutados"],
            datasets: [{
                data: [20, 7],
                backgroundColor: [
                    'rgba(255, 211, 112, 1)',
                    'rgba(255, 188, 75, 1)'
                ]
            }]
        };
      const comPieChart = new Chart(comChart,{
        type: 'pie',
        data: data3,
        options: {
          responsive: true,
          legend: {
            display: true,
            position: 'bottom'
          }
        }
      });

}
