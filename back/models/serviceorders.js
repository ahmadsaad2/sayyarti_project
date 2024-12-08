import Sequelize from 'sequelize';
export default function(sequelize, DataTypes) {
  return sequelize.define('serviceorders', {
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
    service_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'services',
        key: 'id'
      }
    },
    location: {
      type: DataTypes.TEXT,
      allowNull: false
    },
    order_status: {
      type: DataTypes.ENUM('requested','completed','canceled'),
      allowNull: true,
      defaultValue: "requested"
    },
    price: {
      type: DataTypes.DECIMAL(10,2),
      allowNull: false
    }
  }, {
    sequelize,
    tableName: 'serviceorders',
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
      {
        name: "service_id",
        using: "BTREE",
        fields: [
          { name: "service_id" },
        ]
      },
    ]
  });
};
