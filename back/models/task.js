import { Sequelize, DataTypes } from 'sequelize';
export default function(sequelize) {
  return sequelize.define('tasks', {
    id: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    employee_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'employees',
        key: 'id'
      }
    },
    task: {
      type: DataTypes.STRING,
      allowNull: false
    },
    day: {
      type: DataTypes.STRING,
      allowNull: false
    },
    status: {
      type: DataTypes.ENUM('waiting', 'In Progress', 'Complete', 'Declined'),
      allowNull: false
    }
  }, {
    sequelize,
    tableName: 'tasks',
    timestamps: true,
  });
};
