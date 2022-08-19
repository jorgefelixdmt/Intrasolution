var Sequelize = require('sequelize');
sequelize = new Sequelize('mssql://sa:dominiotech@JULIAN-DMT/Pruebas_Julian');
sequelize
  .authenticate()
  .then(function(err) {
    console.log('Connection has been established successfully.');
  })
  .catch(function (err) {
    console.log('Unable to connect to the database:', err);
  });

var Task = sequelize.define('task', {
  kanban_list_id: Sequelize.INTEGER,
  texto: Sequelize.STRING,
},{
  tableName: 'kanban_task'
});
Task.sync().then(function() {
  return Task.create({
    kanban_list_id: 1,
    texto: "Nuevo1"
  });
}).then(function(jane) {
  console.log("termino");
});
