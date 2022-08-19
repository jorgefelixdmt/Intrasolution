module.exports = function(sequelize, DataTypes) {
  var Tarea = sequelize.define('tarea', {
    kbn_tarea_id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
    kbn_columna_id: { type: DataTypes.INTEGER},
    nombre: DataTypes.STRING,
    descripcion: DataTypes.STRING,
    color: DataTypes.STRING,
    orden: DataTypes.INTEGER,
    tipo_tarea: DataTypes.STRING,
    fecha_inicio: DataTypes.STRING,
    fecha_final: DataTypes.STRING,
    fb_empleado_id: DataTypes.STRING,
    created_by: DataTypes.INTEGER,
    updated_by: DataTypes.INTEGER,
    owner_id: DataTypes.INTEGER,
    is_deleted: DataTypes.INTEGER,
  },{
    timestamps: true,
    createdAt: 'created',
    updatedAt: 'updated',
    deletedAt: false,
    paranoid: false,
    tableName: 'kbn_tarea'
  });

  return Tarea;
}
// references: { model: list,  key: 'kbn_list_id'}
