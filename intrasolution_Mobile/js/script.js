$(function() {
  var Accordion = function(el, multiple) {
    this.el = el || {};
    this.multiple = multiple || false;

    var links = this.el.find('.link');
    links.on('click', {el: this.el, multiple: this.multiple}, this.dropdown);
  };

  Accordion.prototype.dropdown = function(e) {
    var $el = e.data.el;
      $this = $(this),
      $next = $this.next();

    $next.slideToggle();
    $this.parent().toggleClass('open');

    if (!e.data.multiple) {
      $el.find('.submenu').not($next).slideUp().parent().removeClass('open');
    }
  };

  var accordion = new Accordion($('#accordion'), false);
  accordion = new Accordion($('#monitoreo'), true);
  accordion = new Accordion($('#residuos'), false);
});

  $( function() {
    $( "#menu_container" ).draggable(
    	{handle: "#drag"});
  } );

  function validarFormatoFecha(campo) {
        var RegExPattern = /^\d{2,4}\-\d{1,2}\-\d{1,2}$/;
        if ((campo.match(RegExPattern)) && (campo!=='')) {
              return existeFecha(campo);
        } else {
              return false;
        }
  }

  function existeFecha(fecha){
        var fechaf = fecha.split("-");
        var year = fechaf[0];
        var month = fechaf[1];
        var day = fechaf[2];
        var date = new Date(year,month,'0');
        if((day-0)>(date.getDate()-0)){
              return false;
        }
        return existeFecha2(fecha);
  }

  function existeFecha2 (fecha) {
          var fechaf = fecha.split("-");
          var y = fechaf[0];
          var m = fechaf[1];
          var d = fechaf[2];
          return m > 0 && m < 13 && y > 0 && y < 32768 && d > 0 && d <= (new Date(y, m, 0)).getDate();
  }
