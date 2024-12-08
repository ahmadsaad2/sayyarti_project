import Sequelize from 'sequelize';
export default function(sequelize, DataTypes) {
  return sequelize.define('rentalcars', {
    id: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    company_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'companies',
        key: 'id'
      }
    },
    car_make: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    car_model: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    license_plate: {
      type: DataTypes.STRING(50),
      allowNull: false,
      unique: "license_plate"
    },
    rental_price: {
      type: DataTypes.DECIMAL(10,2),
      allowNull: false
    },
    availability_status: {
      type: DataTypes.ENUM('available','rented'),
      allowNull: true,
      defaultValue: "available"
    }
  }, {
    sequelize,
    tableName: 'rentalcars',
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
        name: "license_plate",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "license_plate" },
        ]
      },
      {
        name: "company_id",
        using: "BTREE",
        fields: [
          { name: "company_id" },
        ]
      },
    ]
  });
};
