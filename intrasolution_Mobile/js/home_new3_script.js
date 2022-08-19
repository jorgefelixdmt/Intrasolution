window.onload = function() {
  // var Empresa = document.getElementById("empresa").value;
  // var UEA = document.getElementById("UEA").value;
  // var Anno = document.getElementById("anno").value;
  $("span.pie").peity("pie",{
    fill: ["#17884f", "#bbbbbb"]
  });
  onLoadCharts();
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
  const data1 = {
        labels: ["Pendientes", "Ejecutados"],
        datasets: [{
            data: [12, 18],
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
      }
    }
  });

  const data2 = {
        labels: ["Acc1", "Acc2","Acc3","Acc4"],
        datasets: [{
            data: [12, 18,25,50],
            backgroundColor: backgroundColor["accColor"]
        }]
      };
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
        }
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
