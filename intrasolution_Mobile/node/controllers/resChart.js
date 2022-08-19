var Sequelize = require('sequelize');
var sequelize = new Sequelize('mssql://sa:dominiotech@localhost/eco2biz_COL');
var express = require('express');
var resChartRouter = express.Router();

resChartRouter.get('/',function(req,res){
  const wUEA = req.query.UEA;
  const wAnno = req.query.Anno;

  var contador_res = 0;
  var strSql = "select distinct month(FechaTransporte) as mes, sum(peso_tm) as peso_total,peligrosidad from v_residuosgenerados where year(FechaTransporte)='" + wAnno + "' and fb_uea_pe_id = " + wUEA + " group by Peligrosidad, fechatransporte order by peligrosidad, month(FechaTransporte)"

  sequelize.query(strSql, { type: sequelize.QueryTypes.SELECT})
  .then(function(respuesta) {
      res.setHeader("Access-Control-Allow-Origin", "*");
      res.json(respuesta);
  })
});

module.exports = resChartRouter;
