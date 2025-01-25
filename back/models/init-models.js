import { DataTypes } from "sequelize";
import _cars from "./cars.js";
import _cart from "./cart.js";
import _companies from "./companies.js";
import _employees from "./employees.js";
import _partorders from "./partorders.js";
import _parts from "./parts.js";
import _rentalcars from "./rentalcars.js";
import _rentalorders from "./rentalorders.js";
import _serviceorders from "./serviceorders.js";
import _services from "./services.js";
import _users from "./users.js";
import _passwordreset from "./password-reset.js";
import _address from "./address.js";
import _WorkAssignment from './workassignment.js';
import _offers from './offers.js';
import _reviews from './reviews.js';
import _tasks from './task.js';

export default function initModels(sequelize) {
  const cars = _cars(sequelize, DataTypes);
  const cart = _cart(sequelize, DataTypes);
  const companies = _companies(sequelize, DataTypes);
  const employees = _employees(sequelize, DataTypes);
  const partorders = _partorders(sequelize, DataTypes);
  const parts = _parts(sequelize, DataTypes);
  const rentalcars = _rentalcars(sequelize, DataTypes);
  const rentalorders = _rentalorders(sequelize, DataTypes);
  const serviceorders = _serviceorders(sequelize, DataTypes);
  const services = _services(sequelize, DataTypes);
  const users = _users(sequelize, DataTypes);
  const passwordreset = _passwordreset(sequelize, DataTypes);
  const address = _address(sequelize, DataTypes);
const tasks = _tasks(sequelize, DataTypes);
  const workassignment = _WorkAssignment(sequelize, DataTypes);
  const offers = _offers(sequelize, DataTypes);
  const reviews = _reviews(sequelize, DataTypes);
  employees.belongsTo(companies, { as: "company", foreignKey: "company_id" });
  companies.hasMany(employees, { as: "employees", foreignKey: "company_id" });
  parts.belongsTo(companies, { as: "company", foreignKey: "company_id" });
  companies.hasMany(parts, { as: "parts", foreignKey: "company_id" });
  rentalcars.belongsTo(companies, { as: "company", foreignKey: "company_id" });
  companies.hasMany(rentalcars, { as: "rentalcars", foreignKey: "company_id" });
  services.belongsTo(companies, { as: "company", foreignKey: "company_id" });
  companies.hasMany(services, { as: "services", foreignKey: "company_id" });
  cart.belongsTo(parts, { as: "part", foreignKey: "part_id" });
  parts.hasMany(cart, { as: "carts", foreignKey: "part_id" });
  rentalorders.belongsTo(rentalcars, { as: "car", foreignKey: "car_id" });
  rentalcars.hasMany(rentalorders, { as: "rentalorders", foreignKey: "car_id" });
  serviceorders.belongsTo(services, { as: "service", foreignKey: "service_id" });
  services.hasMany(serviceorders, { as: "serviceorders", foreignKey: "service_id" });
  cars.belongsTo(users, { as: "user", foreignKey: "user_id" });
  users.hasMany(cars, { as: "cars", foreignKey: "user_id" });
  cart.belongsTo(users, { as: "user", foreignKey: "user_id" });
  users.hasMany(cart, { as: "carts", foreignKey: "user_id" });
  employees.belongsTo(users, { as: "user", foreignKey: "user_id" });
  users.hasMany(employees, { as: "employees", foreignKey: "user_id" });
  partorders.belongsTo(users, { as: "user", foreignKey: "user_id" });
  users.hasMany(partorders, { as: "partorders", foreignKey: "user_id" });
  rentalorders.belongsTo(users, { as: "user", foreignKey: "user_id" });
  users.hasMany(rentalorders, { as: "rentalorders", foreignKey: "user_id" });
  serviceorders.belongsTo(users, { as: "user", foreignKey: "user_id" });
  users.hasMany(serviceorders, { as: "serviceorders", foreignKey: "user_id" });
  address.belongsTo(users, { as: "user", foreignKey: "user_id" });
  users.hasMany(address, { as: "addresses", foreignKey: "user_id" });
 
  employees.hasMany(workassignment, {
    foreignKey: 'employee_id',
    as: 'workAssignments',
  });

  workassignment.belongsTo(employees, {
    foreignKey: 'employee_id',
    as: 'employee',
  });

  companies.hasMany(offers, {
    as: 'offers',
    foreignKey: 'company_id',
  });

  offers.belongsTo(companies, {
    as: 'company',
    foreignKey: 'company_id',
  });


  companies.hasMany(reviews, {
    as: 'reviews',
    foreignKey: 'company_id',
  });
  reviews.belongsTo(companies, {
    as: 'company',
    foreignKey: 'company_id',
  });

  users.hasMany(reviews, {
    as: 'reviews',
    foreignKey: 'user_id',
  });
  reviews.belongsTo(users, {
    as: 'user',
    foreignKey: 'user_id',
  });

  
  employees.hasMany(tasks, { foreignKey: 'employee_id', as: 'tasks' });
  tasks.belongsTo(employees, { foreignKey: 'employee_id', as: 'employee' });



  companies.belongsTo(users, { foreignKey: 'user_id' });
  users.hasMany(companies,{ foreignKey: 'user_id' });
  return {
    cars,
    cart,
    companies,
    employees,
    partorders,
    parts,
    rentalcars,
    rentalorders,
    serviceorders,
    services,
    users,
    passwordreset,
    workassignment,
    address,
    offers,
    reviews,
    tasks,
  };
}

