var express = require('express');
var _ = require('lodash');
var mapsRouter = express.Router();

mapsRouter.get('/',function(req,res){
  conexionBd(req.query.empresa);
  const wUEA = req.query.UEA;
  const wCodigo = req.query.codigo;
  const wAnno = req.query.Anno;
  // var strSql = [];
  if (wCodigo === "1") {

    var strSql= "select latitud,longitud,codigo from inc_informe_final where fb_uea_pe_id = 1 and YEAR(fecha_evento) = 2016";
  }else if (wCodigo === "2") {
    var strSql = "select latitud,longitud,codigo from eva_hallazgo where fb_uea_pe_id = 1 and YEAR(fecha_ocurrencia) = 2016 and eva_tipo_evaluacion_id = 2" //auditoria

  }else if (wCodigo ==="3") {
    var strSql = "select latitud,longitud,codigo from eva_hallazgo where fb_uea_pe_id = 1 and YEAR(fecha_ocurrencia) = 2016 and eva_tipo_evaluacion_id = 3" //inspeccion

  }
  sequelize.query(strSql, { type: sequelize.QueryTypes.SELECT})
  .then(function(punto) {
    var respuesta = {
      type : "FeatureCollection",
      features : []
    };
    _.forEach(punto, function (data) {
      var point = {
        type : "Feature",
        geometry : {
          type : "point",
          coordinates : [
            data.longitud,
            data.latitud
          ]
        },
        properties : {
          name : data.codigo,
          title : data.codigo,
          icon : "./images/punto"+wCodigo+".png"
        }
      };
      respuesta.features.push(point)
    });
      res.setHeader("Access-Control-Allow-Origin", "*");
      res.json(respuesta);
  })
});

module.exports = mapsRouter;
