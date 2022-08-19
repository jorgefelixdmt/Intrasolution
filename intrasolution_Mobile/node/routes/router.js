var express = require('express');
var app = module.exports = express();
var bodyParser = require('body-parser');
var tablero = require('../controllers/kanban/tablero');
var tarea = require('../controllers/kanban/tarea');
var columna = require('../controllers/kanban/columna');
var color = require('../controllers/kanban/color');
var charts = require('../controllers/mobile/charts');
var maps = require('../controllers/mobile/maps');
var headChart = require('../controllers/headChart');
var mapaPunto = require('../controllers/mapaPunto');
var resChart = require('../controllers/resChart');

app.use(bodyParser.json());
app.use('/node/kanban/tablero',tablero);
app.use('/node/kanban/tarea',tarea);
app.use('/node/kanban/columna/',columna);
app.use('/node/kanban/color',color);
app.use('/node/mobile/charts',charts);
app.use('/node/mobile/maps',maps);
app.use('/headChart',headChart)
app.use('/mapaPunto',mapaPunto)
app.use('/resChart',resChart)
