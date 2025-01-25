import Sequelize from 'sequelize';
export default function(sequelize, DataTypes) {
  return sequelize.define('users', {
    id: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    name: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    email: {
      type: DataTypes.STRING(255),
      allowNull: false,
      unique: "email"
    },
    password: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    phone: {
      type: DataTypes.STRING(20),
      allowNull: true
    },
    role: {
      type: DataTypes.ENUM('user','service_provider','admin','company_admin'),
      allowNull: false,
      defaultValue: 'user'
    },
    img_uri: {
      type: DataTypes.TEXT, 
      allowNull: true, 
    },
    trusted: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },
    verify_stat:{
      type: DataTypes.ENUM('verified','pending','unverified'),
      allowNull: false,
      defaultValue: 'unverified'
    },
    fcm_token:{
      type: DataTypes.STRING(255),
      allowNull: true,
    }
  }, {
    sequelize,
    tableName: 'users',
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
        name: "email",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "email" },
        ]
      },
    ]
  });
};
