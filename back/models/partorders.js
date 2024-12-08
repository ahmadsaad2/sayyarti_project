import Sequelize from 'sequelize';
export default function(sequelize, DataTypes) {
  return sequelize.define('partorders', {
    id: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'users',
        key: 'id'
      }
    },
    total_price: {
      type: DataTypes.DECIMAL(10,2),
      allowNull: false
    },
    order_status: {
      type: DataTypes.ENUM('requested','shipped','delivered','canceled'),
      allowNull: true,
      defaultValue: "requested"
    }
  }, {
    sequelize,
    tableName: 'partorders',
    timestamps: true,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "id" },
        ]
      },
      {
        name: "user_id",
        using: "BTREE",
        fields: [
          { name: "user_id" },
        ]
      },
    ]
  });
};
