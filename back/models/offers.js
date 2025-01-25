import Sequelize from 'sequelize';

export default function (sequelize, DataTypes) {
    return sequelize.define('offers', {
 id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true,
      },
      company_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: 'companies', // or your actual table name
          key: 'id',
        },
      },
      description: {
        type: DataTypes.STRING(100),
        allowNull: false,
      },
      type: {
        type: DataTypes.ENUM('Percentage', 'Flat'),
        allowNull: false,
      },
      amount: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false,
      },
      minimum_spend: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false,
      },
      start_date: {
        type: DataTypes.DATEONLY, // e.g. 2023-12-01
        allowNull: false,
      },
      end_date: {
        type: DataTypes.DATEONLY, // e.g. 2023-12-31
        allowNull: false,
      },
    },
    {
      tableName: 'offers',
      timestamps: true,
    });

  }
