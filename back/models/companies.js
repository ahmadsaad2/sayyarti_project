import Sequelize from 'sequelize';

export default function (sequelize, DataTypes) {
  return sequelize.define(
    'companies',
    {
      id: {
        autoIncrement: true,
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
      },
      name: {
        type: DataTypes.STRING(255),
        allowNull: false,
      },
      address: {
        type: DataTypes.TEXT,
        allowNull: true,
        defaultValue: 'Not provided', // Default value for the address
      },
      contact: {
        type: DataTypes.STRING(50), // Increased the max length for flexibility
        allowNull: true,
      },
      email: {
        type: DataTypes.STRING(255),
        allowNull: false,
        validate: {
          isEmail: true, // Ensures email format is valid
        },
      },
      website: {
        type: DataTypes.STRING(255),
        allowNull: true, // Optional field for the company website
      },
      image: {
        type: DataTypes.STRING(255),
        allowNull: true, // URL to the company's image
      },
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: false, 
        field: 'user_id', // Tells Sequelize this JS property is mapped to the 'user_id' column
        // Ensure user_id is always provided
        references: {
          model: 'users', // Foreign key pointing to the 'users' table
          key: 'id',
        },
        onDelete: 'CASCADE', // Automatically delete the company if the user is deleted
        onUpdate: 'CASCADE', // Update foreign key references on user ID changes
      },
    },
    {
      sequelize,
      tableName: 'companies',
      timestamps: true, // Enable createdAt and updatedAt fields
      indexes: [
        {
          name: 'PRIMARY',
          using: 'BTREE',
          fields: [{ name: 'id' }],
        },
        {
          name: 'user_id',
          using: 'BTREE',
          fields: [{ name: 'user_id' }],
        },
       
      ],
    }
  );
}
