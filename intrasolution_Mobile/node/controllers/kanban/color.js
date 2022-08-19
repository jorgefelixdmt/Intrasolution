var express = require('express');
var colorRouter = express.Router();

colorRouter.get('/:id', function(req, res) {
  conexionBd(req.query.empresa);
  var strSql = "select nombre,color from kbn_tarea_color where kbn_tablero_id = " + req.params.id + " and is_deleted=0 and estado=1"
  sequelize.query(strSql, { type: sequelize.QueryTypes.SELECT})
  .then(function(colores) {
      res.json(colores);
  })
});

module.exports = colorRouter;
