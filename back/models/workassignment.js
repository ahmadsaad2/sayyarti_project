// workassignment.js
export default function WorkAssignmentModel(sequelize, DataTypes) {
  return sequelize.define(
    'WorkAssignment',
    {
      id: {
        autoIncrement: true,
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
      },
      employee_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: 'employees',
          key: 'id',
        },
      },
      task: {
        type: DataTypes.STRING(255),
        allowNull: false,
      },
      day: {
        type: DataTypes.ENUM(
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday'
        ),
        allowNull: false,
      },
      worked: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
      },
    },
    {
      sequelize,
      tableName: 'work_assignments',
      timestamps: true,
    }
  );
}
