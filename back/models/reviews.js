import Sequelize from 'sequelize';


export default function (sequelize, DataTypes) {
    return sequelize.define('reviews', {

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
            model: 'companies',
            key: 'id',
          },
        },
        user_id: {
          type: DataTypes.INTEGER,
          allowNull: false,
          references: {
            model: 'users',
            key: 'id',
          },
        },
        rating: {
          type: DataTypes.INTEGER, // e.g. 1-5 stars
          allowNull: false,
        },
        comment: {
          type: DataTypes.TEXT, // user’s review text
          allowNull: true,
        },
      },
      {
        tableName: 'reviews',
        timestamps: true,
      }
    );

  }
