window.onload = function() {
  initMap();
};

function initMap() {
  var mapCanvas = document.getElementById('map-canvas');
  var latitud = Number(mapCanvas.dataset.latitud);
  var longitud = Number(mapCanvas.dataset.longitud);

  var mapOptions = {
    center: new google.maps.LatLng(latitud, longitud),
    zoom: 13,
    mapTypeControl: true,
    mapTypeId: google.maps.MapTypeId.HYBRID,
    mapTypeControlOptions: {
      style: google.maps.MapTypeControlStyle.DEFAULT,
      mapTypeIds: [
        google.maps.MapTypeId.HYBRID,
        google.maps.MapTypeId.SATELLITE,
        google.maps.MapTypeId.ROADMAP,
        google.maps.MapTypeId.TERRAIN]
      },
      zoomControl: true
    };
    map = new google.maps.Map(mapCanvas,mapOptions);
}

function toggleMenu() {
  const menu = document.getElementById('menu');
    if (menu.style.display === 'none') {
        menu.style.display = 'flex';
    } else {
        menu.style.display = 'none';
    }
}

var currentGeojsonObject = {};
function togglePunto(codigo,punto) {
  var mapCanvas = document.getElementById('map-canvas');
  var Empresa = mapCanvas.dataset.empresa;
  var UEA = mapCanvas.dataset.uea;
  var Anno= document.getElementById('anno').value;
  // var geoJson = 'http://localhost:8080/node/mobile/maps?empresa='+Empresa+'&UEA='+UEA+'&codigo='+codigo+'&Anno='+Anno;
  var geoCheckbox = document.getElementById(punto);
  if (geoCheckbox.checked) {
    currentGeojsonObject[codigo] = new google.maps.Data();
    currentGeojsonObject[codigo].loadGeoJson("./js/punto"+codigo+".json");
    currentGeojsonObject[codigo].setMap(map);
    // map.data.addGeoJson(geoJson);

    currentGeojsonObject[codigo].setStyle(function(feature) {
   return {icon:feature.getProperty('icon')};
 });
  }else {
    currentGeojsonObject[codigo].setMap(null);

  }


}
