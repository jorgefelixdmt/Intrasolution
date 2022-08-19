var express = require('express');
var tableroRouter = express.Router();

tableroRouter.get('/:id', function(req, res) {
  conexionBd(req.query.empresa);
  var strSql = "select nombre from kbn_tablero where kbn_tablero_id = " + req.params.id + " and is_deleted=0"
  sequelize.query(strSql, { type: sequelize.QueryTypes.SELECT})
  .then(function(tablero) {
      res.json(tablero);
  })
});

module.exports = tableroRouter;
