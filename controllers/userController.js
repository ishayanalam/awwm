const { validationResult } = require("express-validator");
const bcrypt = require("bcryptjs");
const db = require("../db/database");

const jwt = require("jsonwebtoken");
const { JWT_SECRET } = process.env;

// controllers/userController.js
const getUser = (req, res) => {
  res.send("Get user called");
};

module.exports = {
  getUser,
};

console.log("all the controllers loaded");

module.exports = { getUser };
