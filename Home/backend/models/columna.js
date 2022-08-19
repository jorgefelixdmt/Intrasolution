module.exports = function(sequelize, DataTypes) {
  var Columna = sequelize.define('columna', {
    kbn_columna_id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    kbn_tablero_id: { type: DataTypes.INTEGER},
    nombre: DataTypes.STRING,
    orden: DataTypes.STRING,
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
    tableName: 'kbn_columna'
  });
  return Columna;
}
