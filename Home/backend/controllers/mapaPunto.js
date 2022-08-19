var Sequelize = require('sequelize');
var sequelize = new Sequelize('mssql://sa:dominiotech@localhost/eco2biz_COL');
var express = require('express');
var _ = require('lodash');
var headChartRouter = express.Router();

headChartRouter.get('/',function(req,res){
  const wElemento = req.query.Elemento;
  const wUEA = req.query.UEA;
  const wAnno = req.query.Anno;

  var strSql = "Select distinct "
   + "ma_punto_monitoreo_id as ID, "
   + "elemento, "
   + "punto_monitoreo, "
   + "imagen_google, "
   + "latitud, "
   + "longitud "
   + "from vista_resultado "
   + "Where fb_uea_pe_id = " + wUEA
   + " and latitud <> 0 "
   + " and ma_elemento_id = " + wElemento
   + " and anho = '" + wAnno + "'"
   + " and flag_excede_limites = 1"

  var start_timeR = new Date().getTime();
  sequelize.query(strSql, { type: sequelize.QueryTypes.SELECT})
  .then(function(punto) {
    var request_timeR = new Date().getTime() - start_timeR;
    console.log("Demoró:"+ request_timeR + "ms");
    var respuesta = {
      type : "FeatureCollection",
      features : []
    };
    // {
    //   type : "Feature",
    //   geometry : {
    //     type : "point",
    //     coordinates : [
    //       punto[0].longitud,
    //       punto[0].latitud
    //     ]
    //   },
    //   properties : {
    //     name : punto[0].punto_monitoreo,
    //     title : punto[0].punto_monitoreo,
    //     id : punto[0].ID,
    //     icon : punto[0].elemento,
    //     image : punto[0].imagen_google,
    //   }
    // }

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
          name : data.punto_monitoreo,
          title : data.punto_monitoreo,
          id : data.ID,
          icon : data.elemento,
          imagen : data.imagen_google
        }
      };
      respuesta.features.push(point)
    });
      res.setHeader("Access-Control-Allow-Origin", "*");
      res.json(respuesta);
  })
});

module.exports = headChartRouter;
