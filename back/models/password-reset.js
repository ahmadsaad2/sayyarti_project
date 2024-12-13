import Sequelize from 'sequelize';

export default function (sequelize, DataTypes) {
  return sequelize.define('passwordReset', {
    id: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true,
    },
    email: {
      type: DataTypes.STRING(255),
      allowNull: false,
      validate: {
        isEmail: true,
      },
    },
    otp: {
      type: DataTypes.STRING(6),
      allowNull: false,
    },
    createdAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: Sequelize.NOW,
    },
  }, {
    sequelize,
    tableName: 'password_resets',
    timestamps: false, 
    indexes: [
      {
        name: 'PRIMARY',
        unique: true,
        using: 'BTREE',
        fields: [
          { name: 'id' },
        ],
      },
      {
        name: 'email_index',
        using: 'BTREE',
        fields: [
          { name: 'email' },
        ],
      },
    ],
  });
};
