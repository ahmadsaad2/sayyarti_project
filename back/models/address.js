export default function (sequelize, DataTypes) {
    return sequelize.define('address', {
        id: {
            autoIncrement: true,
            type: DataTypes.INTEGER,
            allowNull: false,
            primaryKey: true
        },
        address: {
            type: DataTypes.TEXT,
            allowNull: false
        },
        lat: {
            type: DataTypes.FLOAT,
            allowNull: true
        },
        lng: {
            type: DataTypes.FLOAT,
            allowNull: true
        },
        is_default: {
            type: DataTypes.BOOLEAN, 
            allowNull: false,
            defaultValue: false
        },
        user_id: {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: 'users',
                key: 'id'
            }
        }
    }, {
        sequelize,
        tableName: 'address',
        timestamps: true,
        indexes: [
            {
                name: "user_id_index",
                using: "BTREE",
                fields: [
                    { name: "user_id" }
                ]
            },
            {
                name: "primary_key",
                unique: true,
                using: "BTREE",
                fields: [
                    { name: "id" }
                ]
            },
            {
                name: "default_address_index",
                using: "BTREE",
                fields: [
                    { name: "is_default" }
                ]
            }
        ]
    });
}