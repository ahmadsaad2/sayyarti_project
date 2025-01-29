import Sequelize from 'sequelize';
export default function (sequelize, DataTypes) {
  return sequelize.define(
    'bookings',
    {
      id: {
        autoIncrement: true,
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
      },
      customer_name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      mobile: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      service: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      payment_method: {
        type: DataTypes.ENUM('Cash', 'Visa'),
        allowNull: false,
      },
      status: {
        type: DataTypes.ENUM('Pending', 'Complete', 'Waiting', 'In Processing'),
        allowNull: false,
      },
      company_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: 'companies',
          key: 'id',
        },
      },
      booking_date: {
        type: DataTypes.DATE,
        allowNull: true,
      },
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
    },
    {
      sequelize,
      tableName: 'bookings',
      timestamps: true,
    }
  );
}
