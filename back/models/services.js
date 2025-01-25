import Sequelize from 'sequelize';

export default function (sequelize, DataTypes) {
  return sequelize.define(
    'services',
    {
      id: {
        autoIncrement: true,
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
      },
      company_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: 'companies',
          key: 'id',
        },
      },
     
      name: {
        type: DataTypes.STRING(100),
        allowNull: false,
      },
      
      time: {
        type: DataTypes.STRING(50),
        allowNull: false,
      },
      
      service_type: {
        type: DataTypes.STRING(100),
        allowNull: true,
      },
    
      details: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
   
      price: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false,
      },
    },
    {
      sequelize,
      tableName: 'services',
      timestamps: true,
      indexes: [
        {
          name: 'PRIMARY',
          unique: true,
          using: 'BTREE',
          fields: [{ name: 'id' }],
        },
        {
          name: 'company_id',
          using: 'BTREE',
          fields: [{ name: 'company_id' }],
        },
      ],
    }
  );
  
}
