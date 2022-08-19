var Sequelize = require('sequelize');
var sequelize = new Sequelize('mssql://sa:dominiotech@localhost/eco2biz_COL');
var express = require('express');
var headChartRouter = express.Router();

headChartRouter.get('/',function(req,res){
  const wElemento = req.query.Elemento;
  const wUEA = req.query.UEA;
  const wAnno = req.query.Anno;

  var respuesta1 = {};
  var contador_res = 0;
  var strSql = "select distinct count(*) as cantidad "
  + "from vista_toma_muestra where anio = '" + wAnno + "' and "
  + "ma_elemento_id = " + wElemento + " and "
  + "fb_uea_pe_id = " + wUEA
  sequelize.query(strSql, { type: sequelize.QueryTypes.SELECT})
  .then(function(muestras) {
    respuesta1.muestras = muestras[0].cantidad;
    contador_res +=1;
    if (contador_res===7) {
      res.setHeader("Access-Control-Allow-Origin", "*");
      res.json(respuesta1);
    }
  })
  strSql = "SELECT COUNT(DISTINCT parametro) as cantidad FROM vista_resultado WHERE ma_elemento_id = "+ wElemento +" AND (anho = '"+wAnno+"') AND (fb_uea_pe_id = "+wUEA+") AND (latitud <> 0)";
  sequelize.query(strSql, { type: sequelize.QueryTypes.SELECT})
  .then(function(parametros) {
    respuesta1.par_total = parametros[0].cantidad;
    contador_res +=1;
    if (contador_res===7) {
      res.setHeader("Access-Control-Allow-Origin", "*");
      res.json(respuesta1);
    }
  })
  strSql = "select nombre from ma_elemento where ma_elemento_id =" + wElemento
  sequelize.query(strSql, { type: sequelize.QueryTypes.SELECT})
  .then(function(nombre) {
    respuesta1.nombre = nombre[0].nombre;
    contador_res +=1;
    if (contador_res===7) {
      res.setHeader("Access-Control-Allow-Origin", "*");
      res.json(respuesta1);
    }
  })
  strSql = "SELECT COUNT(DISTINCT parametro) as cantidad FROM vista_resultado WHERE ma_elemento_id = "+ wElemento +" AND (anho = '"+wAnno+"') AND (fb_uea_pe_id = "+wUEA+") AND (latitud <> 0) AND flag_excede_limites = 1";
  sequelize.query(strSql, { type: sequelize.QueryTypes.SELECT})
  .then(function(excede) {
    respuesta1.excede = excede[0].cantidad;
    contador_res +=1;
    if (contador_res===7) {
      res.setHeader("Access-Control-Allow-Origin", "*");
      res.json(respuesta1);
    }
  })
  strSql = "select "
  + "count(distinct punto_monitoreo) as cantidad "
  + "from vista_resultado where anho = '" + wAnno + "' and "
  + "ma_elemento_id = " + wElemento + " and "
  + "fb_uea_pe_id = " + wUEA + " and "
  + "latitud <> 0";
  sequelize.query(strSql, { type: sequelize.QueryTypes.SELECT})
  .then(function(estaciones) {
    respuesta1.estaciones = estaciones[0].cantidad;
    contador_res +=1;
    if (contador_res===7) {
      res.setHeader("Access-Control-Allow-Origin", "*");
      res.json(respuesta1);
    }
  })
  strSql = "select distinct autoridad, "
  + "count(*) as cantidad "
  + "from vista_toma_muestra where anio = '" + wAnno + "' and "
  + "ma_elemento_id = " + wElemento + " and "
  + "fb_uea_pe_id = " + wUEA + " group by autoridad"
  sequelize.query(strSql, { type: sequelize.QueryTypes.SELECT})
  .then(function(autoridades) {
    respuesta1.autoridades = autoridades;
    contador_res +=1;
    if (contador_res===7) {
      res.setHeader("Access-Control-Allow-Origin", "*");
      res.json(respuesta1);
    }
  })
  strSql = "select distinct COUNT (*) as cantidad, "
  + "case when (flag_excede_limites = '1') then 'No Cumple' Else 'Cumple' end as cumple "
  + "from vista_toma_muestra "
  + "where anio = '" + wAnno + "' and "
  + "ma_elemento_id = " + wElemento + " and "
  + "fb_uea_pe_id = " + wUEA + " group by case when (flag_excede_limites = '1') then 'No Cumple' Else 'Cumple' end"
  sequelize.query(strSql, { type: sequelize.QueryTypes.SELECT})
  .then(function(cumplimiento) {
    respuesta1.cumplimiento = cumplimiento;
    contador_res +=1;
    if (contador_res===7) {
      res.setHeader("Access-Control-Allow-Origin", "*");
      res.json(respuesta1);
    }
  })
});

module.exports = headChartRouter;
