var express = require('express');
var columnaRouter = express.Router();

columnaRouter.get('/',function(req,res) {
  res.send({lol: 'lol'});

});

columnaRouter.get('/:id', function(req, res) {
  console.log("entré");
  console.log(req.query.empresa);
  conexionBd(req.query.empresa);
  Columna.findAll({
    where: {
      kbn_tablero_id: req.params.id
    },
    attributes: ['kbn_columna_id','nombre','orden'],
    include: [{
      model: Tarea,
    }],
    order: [[Tarea, 'orden','ASC']]
  }).then(function(columna) {
    // sequelize.close();
    res.json(columna);
  });
});

columnaRouter.post('/', function(req, res) {
  conexionBd(req.query.empresa);
  res.setHeader("Access-Control-Allow-Origin", "*");
  console.log(req.body);
  Columna.create({
    kbn_tablero_id: req.body.tablero_id,
    nombre: req.body.nombre,
    orden: req.body.orden,
    created_by: 1,
    updated_by: 1,
    owner_id: 1,
    is_deleted: 0
  }).then(function(columna) {
    res.json(columna);
  }).catch(function (err) {
    console.log(err);
    res.end();
  });

});

columnaRouter.get('/:id/:id1', function(req, res) {
  conexionBd(req.query.empresa);
  Columna.findOne({
    where: {
      kbn_columna_id: req.params.id
    },
    attributes: ['kbn_columna_id', 'nombre']
  }).then(function(columna) {
    res.send({
      columna: columna.nombre
    });
  }).catch(function (err) {
    console.log(err);
    res.end();
  });
});

columnaRouter.patch('/:id', function(req, res) { });
columnaRouter.delete('/:id', function(req, res) { });

module.exports = columnaRouter;
