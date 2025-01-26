import Sequelize from 'sequelize';
export default function (sequelize, DataTypes) {
    return sequelize.define('brands', {
        id: {
            autoIncrement: true,
            type: DataTypes.INTEGER,
            allowNull: false,
            primaryKey: true
        },
        brand: {
            type: DataTypes.STRING(255),
            allowNull: false,
            unique: true 
        },
        models: {
            type: DataTypes.JSON, 
            allowNull: true 
        }
    }, {
        sequelize,
        tableName: 'brands', 
        timestamps: true, 
        indexes: [
            {
                name: "brand", 
                unique: true,
                using: "BTREE",
                fields: [
                    { name: "brand" }
                ]
            },
            {
                name: "PRIMARY", 
                unique: true,
                using: "BTREE",
                fields: [
                    { name: "id" }
                ]
            }
        ]
    });
}