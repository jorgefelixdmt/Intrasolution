
function onLoadParameterSelect(Empresa,UEA,punto_monitoreo,elemento) {
  var json = "NewParameterSelect.asp?Empresa="+Empresa+"&UEA="+UEA+"&Elemento="+elemento+"&PuntoMonitoreo="+punto_monitoreo;
  $("#parametro option").remove();
  $("#parametro").append('<option value="'+0+'" selected>Cargando...</option>');
    $.get(json,function(data) {
      $("#parametro option").remove();
      $.each(data.parameters, function( i, val ) {
        $("#parametro").append('<option value="'+val.id+'">'+val.nombre+'</option>');
        if (i===0) {
          onLoadNormaSelect(Empresa,UEA,val.id,punto_monitoreo,elemento);
        }
      });
    }).fail(function () {
      alert("No hay Parametros para este punto.");
    });

}

function onLoadNormaSelect(Empresa,UEA,parametro,punto_monitoreo,elemento) {
  var json = "NewNormaSelect.asp?Empresa="+Empresa+"&UEA="+UEA+"&Parametro="+parametro;
  $("#norma option").remove();
  $("#norma").append('<option value="'+0+'" selected>Cargando...</option>');
    $.get(json,function(data) {
      $("#norma option").remove();
      $("#norma").append('<option value="0">*Seleccione una norma de la lista*</option>');
      onLoadChart(Empresa,UEA,punto_monitoreo,elemento);
      $.each(data.normas, function( i, val ) {
        $("#norma").append('<option value="'+val.id+'">'+val.nombre+'</option>');
      });
    }).fail(function () {
      onLoadChart(Empresa,UEA,punto_monitoreo,elemento);
      $("#norma option").remove();
      $("#norma").append('<option value="0">No hay normas para este parametro.</option>');

    });

}
function onLoadChart(Empresa,UEA,punto_monitoreo,elemento) {
  var fecha_inicial= $("#date_init").val();
  var fecha_final= $("#date_final").val();
    var xml = "DataGenChartXml_Mapa.asp?Empresa="+Empresa+"&NormaLegal="+$("#norma").val()+"&PuntoMonitoreo="+punto_monitoreo+"&Parametro=" + $("#parametro").val() + "&Elemento=" + elemento + "&UEA="+UEA;
    // console.log(xml);
    $.get(xml,function(data) {
      console.log(data.firstElementChild);
      if (data==="") {
        alert("No hay datos para los valores seleccionados.");
        $("#chartContainer").hide();
        $("#fcexpDiv").hide();
      }else{
        $("#chartContainer").show();
        $("#fcexpDiv").show();
        myChart.setXMLData(data);


      }    
    }).fail(function () {
      $("#chartContainer").hide();
      $("#fcexpDiv").hide();
      alert("No hay datos para los valores seleccionados.");
    });

}


function onLoadNewChartType(tipo) {
  $("#chartContainer").updateFusionCharts({"swfUrl": "FusionCharts_XT/"+tipo});
}
