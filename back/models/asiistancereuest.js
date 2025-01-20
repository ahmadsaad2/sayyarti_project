import Sequelize from 'sequelize';

export default function (sequelize, DataTypes) {
  return sequelize.define('assistance_requests', {
    id: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true,
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'users', // Reference to the users table
        key: 'id',
      },
    },
    service_type: {
      type: DataTypes.STRING(50),
      allowNull: false, // Jump Start, Tire Problem, Towing, Fuel Delivery
    },
    request_date: {
      type: DataTypes.DATE,
      allowNull: false, // Date and time of the request
    },

    // Vehicle Details
    vehicle_make_model: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    vehicle_type: {
      type: DataTypes.STRING(50),
      allowNull: false, // Car, SUV, Truck, Motorcycle
    },
    battery_type: {
      type: DataTypes.STRING(50),
      allowNull: true, // Optional for Jump Start and Fuel Delivery
    },
    license_plate: {
      type: DataTypes.STRING(20),
      allowNull: true, // Optional for Towing Services
    },
    vehicle_condition: {
      type: DataTypes.STRING(50),
      allowNull: true, // Optional for Towing Services
    },

    // Problem Description
    issue_description: {
      type: DataTypes.TEXT,
      allowNull: true, // Optional for Jump Start and Tire Problem
    },
    additional_notes: {
      type: DataTypes.TEXT,
      allowNull: true, // Optional for Jump Start and Tire Problem
    },

    // Location Details
    current_location_address: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    nearest_landmark: {
      type: DataTypes.TEXT,
      allowNull: true, // Optional
    },
    latitude: {
      type: DataTypes.DOUBLE,
      allowNull: true, // Optional
    },
    longitude: {
      type: DataTypes.DOUBLE,
      allowNull: true, // Optional
    },

    // Assistance Options
    immediate_assistance: {
      type: DataTypes.BOOLEAN,
      allowNull: false, // True for immediate, false for scheduled
    },
    scheduled_time: {
      type: DataTypes.DATE,
      allowNull: true, // Optional for scheduled assistance
    },
    requested_service: {
      type: DataTypes.STRING(100),
      allowNull: true, // Optional for Tire Problem and Towing Services
    },
    towing_type: {
      type: DataTypes.STRING(50),
      allowNull: true, // Optional for Towing Services
    },
    preferred_drop_off_point: {
      type: DataTypes.STRING(100),
      allowNull: true, // Optional for Towing Services
    },

    // Fuel Delivery Specific Fields
    fuel_type: {
      type: DataTypes.STRING(50),
      allowNull: true, // Optional for Fuel Delivery
    },
    fuel_quantity: {
      type: DataTypes.DOUBLE,
      allowNull: true, // Optional for Fuel Delivery
    },
    total_price: {
      type: DataTypes.DOUBLE,
      allowNull: true, // Optional for Fuel Delivery
    },

    // Contact Information
    customer_name: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    phone_number: {
      type: DataTypes.STRING(20),
      allowNull: false,
    },
    alternative_contact: {
      type: DataTypes.STRING(20),
      allowNull: true, // Optional
    },
  }, {
    sequelize,
    tableName: 'assistance_requests',
    timestamps: true, // Adds createdAt and updatedAt fields
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
        name: 'user_id',
        using: 'BTREE',
        fields: [
          { name: 'user_id' },
        ],
      },
    ],
  });
}