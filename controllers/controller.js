const { validationResult } = require("express-validator");
const bcrypt = require("bcryptjs");
const db = require("../db/database");

const jwt = require("jsonwebtoken");
const { JWT_SECRET } = process.env;

// controllers/userController.js
const getUser = (req, res) => {
  res.send("Get user called");
};

const getUsersByArea = (req, res, next) => {
  const areaId = req.params.area_id;

  const query = `
      SELECT u.User_ID, u.Name, u.Address, u.Meter_ID, u.Account_Status
      FROM Users u
      WHERE u.Area_ID = ?
    `;

  db.query(query, [areaId], (err, results) => {
    if (err) {
      return next(err); // Will be caught by global error handler
    }

    res.json(results);
  });
};

const getActiveComplaints = (req, res, next) => {
  const query = `
    SELECT *
    FROM Complaint
    WHERE status = 'Pending'
  `;

  db.query(query, (err, results) => {
    if (err) return next(err);
    res.json(results);
  });
};
console.log("all the controllers loaded");
module.exports = {
  getUser,
  getUsersByArea,
  getActiveComplaints,
};
