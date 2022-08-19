var express = require('express');
var tareaRouter = express.Router();

tareaRouter.get('/', function(req, res) {
  conexionBd(req.body.empresa);
  Tarea.findAll({
    attributes: ['kbn_columna_id', 'descripcion']
  }).then(function(tareas) {
    res.json(tareas);
  });
});

tareaRouter.post('/', function(req, res) {
  conexionBd(req.body.empresa);
  res.setHeader("Access-Control-Allow-Origin", "*");
  Tarea.create({
    kbn_columna_id: req.body.columna_id,
    nombre: req.body.nombre,
    descripcion: req.body.descripcion,
    color: req.body.color,
    orden: req.body.orden,
    created_by: 1,
    updated_by: 1,
    owner_id: 1,
    is_deleted: 0
  }).then(function(tarea) {
    res.json(tarea);
  }).catch(function (err) {
    console.log(err);
    res.end();
  });
});

tareaRouter.get('/:id', function(req, res) {
  conexionBd(req.body.empresa);
  Tarea.findOne({
    where: {
      kbn_tarea_id: req.params.id
    },
    attributes: ['kbn_columna_id', 'descripcion']
  }).then(function(tarea) {
    res.send(tarea);
  }).catch(function (err) {
    console.log(err);
    res.end();
  });
});

tareaRouter.patch('/:id', function(req, res) {
  conexionBd(req.body.empresa);
  Tarea.update({
    kbn_columna_id: req.body.columna_id,
    nombre: req.body.nombre,
    descripcion: req.body.descripcion,
    color: req.body.color,
    orden: req.body.orden,
  },{
    where: {
      kbn_tarea_id: req.params.id
    }
  }).then(function(complete){
    Tarea.findOne({
      where: {
        kbn_tarea_id: req.params.id
      }
    }).then(function(tarea) {
      // sequelize.close();
      res.json(tarea);
    }).catch(function (err) {
      console.log(err);
      res.end();
    });
  }).catch(function (err) {
    console.log(err);
    res.end();
  });
});
1,2,3,4,5
1,2,3,2,5

tareaRouter.patch('/', function(req, res) {
  conexionBd(req.body.empresa);
  if(req.body.cambio){
    Tarea.update({
      orden: sequelize.literal('orden +1'),
    },{
      where: {
        kbn_columna_id: req.body.newColumnaId,
        orden: {$gte: req.body.newOrden}
      }
    }).then(function(complete){
      Tarea.update({
        orden: sequelize.literal('orden -1'),
      },{
        where: {
          kbn_columna_id: req.body.oldColumnaId,
          orden: {$gte: req.body.oldOrden}
        }
      }).then(function(complete){
        res.json(complete);
      }).catch(function (err) {
        console.log(err);
        res.end();
      });
    }).catch(function (err) {
      console.log(err);
      res.end();
    });
  }else{
    if (req.body.newOrden<req.body.oldOrden ) {
      Tarea.update({
        orden: sequelize.literal('orden +1'),
      },{
        where: {
          kbn_columna_id: req.body.newColumnaId,
          orden: {$between: [req.body.newOrden, req.body.oldOrden-1]}
        }
      }).then(function(complete){
        res.json(complete);
      }).catch(function (err) {
        console.log(err);
        res.end();
      });
    }else if(req.body.newOrden>req.body.oldOrden){
      Tarea.update({
        orden: sequelize.literal('orden -1'),
      },{
        where: {
          kbn_columna_id: req.body.newColumnaId,
          orden: {$between: [req.body.oldOrden+1, req.body.newOrden]}
        }
      }).then(function(complete){
        res.json(complete);
      }).catch(function (err) {
        console.log(err);
        res.end();
      });
    }
  }
});
tareaRouter.delete('/:id', function(req, res) {
  conexionBd(req.body.empresa);
  Tarea.destroy({
    where: {
      kbn_tarea_id: req.params.id
    }
  }).then(function(complete){
    console.log("Complete");
    res.json({done:'done'});
  }).catch(function (err) {
    console.log(err);
    res.end();
  });
});

module.exports = tareaRouter;
