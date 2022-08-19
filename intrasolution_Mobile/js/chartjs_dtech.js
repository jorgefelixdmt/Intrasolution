function generaGraficasSP(ChartName, stored,bodyData, Url, User, Pass, Empresa, titulo, canvasName, chartType, lPosition, isStacked,texto_interno){
 
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
      var Codigo = "";  
      var Codigos = [];
      var Nombre = "";
      var Nombres = [];
      var Tipos = [];
      var Tipo = "";
      var i = 0;
      var j = 0;
      var flaglabel = true;
      var Legend = true;
      var newLabel = {};
      data.data.forEach(function (control, index) {
        Object.keys(control).forEach(function(name,index){
          if(name == "Nombre"){
            Nombre = control[name]
            Nombres.push(Nombre)
            return;
          }
          if(name == "Codigo"){
            Codigo = control[name]
            Codigos.push(Codigo)
            newLabel[Codigo] = [Codigo] 
          }else if(Tipos.includes(name)){
            dat = control[name]
            if(!dat){dat = 0} else{dat = parseInt(dat)}
            NewDataset[name].data.push(dat)
          }else{
            dat = control[name]
            if(!dat){dat = 0} else{dat = parseInt(dat)}
            Tipo = name
            Tipos.push(Tipo)
            NewDataset[Tipo] = 
            {
            label : Tipo,
            backgroundColor: Colors[i], 
            borderColor: BorderColors[i],
            borderWidth: 1,
            data: [dat]
            };  
          }
          i++;
        })
      });

      //Asignar valor a la variable global para el título del ToolTip
      Codigos.forEach(function(Codigo, index)
      {
        tooltipTile[Codigo] = Nombres[index];
      });

      Codigos.forEach(function(Codigo, index)
      {
        data1.labels.push(Codigo);
      });

      Tipos.forEach(function(tipo, index)
      {
        data1.datasets.push(NewDataset[tipo]);
      });
	  
      if(Tipos[0] == Codigos[0]){
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
        flaglabel = false;
      };
      var wcutoutPercentage = 0;
      if(chartType == 'doughnut'){
        wcutoutPercentage = 90
      };

    }
      allCharts[ChartName] = new Chart(canvasName, {
          type: chartType,
          data: data1,
          options: {
            responsive: true,
            mantainAspectRatio:true,
            barValueSpacing: 0,
            cutoutPercentage: wcutoutPercentage,
              elements: {
                  center: {
                    text: texto_interno,
                    color: 'rgba(105, 105, 105, 0.6)',//'#FF6384', // Default is #000000
                    fontStyle: 'Arial', // Default is Arial
                    sidePadding: 20 // Defualt is 20 (as a percentage)
                  }
                },
             plugins: {
              datalabels: {
                color: 'black',
                display: function(context) {
                  return context.dataset.data[context.dataIndex];
                },
                font: {
                  weight: 'bold'
                },
                formatter: Math.round
            }
        },
            title: {
              display: true,
              text: titulo,
            },
            legend: {
              display: Legend,
              position: lPosition,
              labels:{
                fontSize:10,
                boxWidth:12
              },
            },
            scales: {
               xAxes: [{
                stacked: isStacked,
                display: flaglabel,
                barThickness : 25,
                barPercentage: 0.2,
                ticks:{
                  autoSkip:false
                },
            }],
              yAxes: [{
                stacked:isStacked,
                display: flaglabel,
                gridLines:{
                  display:false,
                },
				ticks:{
                  min: 0,
                  stepSize: 2
                },
              }],
            },  
            tooltips: {
              enabled: true,
          }
          }
        });
    });
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
