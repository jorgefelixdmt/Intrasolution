var express = require('express');
var chartsRouter = express.Router();

chartsRouter.get('/', function(req, res) {
  conexionBd(req.query.empresa);
  var respuesta = {};
  var contador_res = 0;
  sequelize.query('pr_mob_incidentes @anno=\'2016\';').then(function(response){
    respuesta.incidentes = response[0];
    contador_res +=1;
    if (contador_res===4) {
      res.json(respuesta);
    }
  }).error(function(err){
    res.json(err);
  });
  sequelize.query('pr_mob_requisitos @anno=\'2016\';').then(function(response){
    respuesta.requisitos = response[0];
    contador_res +=1;
    if (contador_res===4) {
      res.json(respuesta);
    }
  }).error(function(err){
    res.json(err);
  });
  sequelize.query('pr_mob_iperc @anno=\'2016\';').then(function(response){
    respuesta.iperc = response[0];
    contador_res +=1;
    if (contador_res===4) {
      res.json(respuesta);
    }
  }).error(function(err){
    res.json(err);
  });
  sequelize.query('pr_mob_auditorias @anno=\'2016\';').then(function(response){
    respuesta.auditorias = response[0];
    contador_res +=1;
    if (contador_res===4) {
      res.json(respuesta);
    }
  }).error(function(err){
    res.json(err);
  });
});

module.exports = chartsRouter;
