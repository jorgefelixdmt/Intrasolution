function conexion_bd(conexion) {
  global.sequelize = new Sequelize(conexion);
  global.Columna = sequelize.import("./models/columna");
  global.Tarea = sequelize.import("./models/tarea");
  Columna.hasMany(Tarea, {foreignKey: 'kbn_columna_id'});
  Tarea.belongsTo(Columna, {foreignKey: 'kbn_columna_id'});
}

var Conexion = function (empresa) {
  console.log(empresa);
  var empresas = [
    { nombre : 'col_desarrollo',
      conexion: 'mssql://sa:dominiotech@localhost/safe2biz_colombia_desarrollo'
    }
  ];
  for (var i = 0; i < empresas.length; i++) {
    if (empresa === empresas[i].nombre) {
      conexion_bd(empresas[i].conexion);
    }
  }
  var conexionFail = "null";
  return conexionFail;
}
module.exports = Conexion;
