const { validationResult } = require("express-validator");
const bcrypt = require("bcryptjs");
const db = require("../db/database");

const jwt = require("jsonwebtoken");
const { JWT_SECRET } = process.env;

//user quries

const addUser = (req, res, next) => {
  const { Name, Address, Area_ID, Meter_ID, Account_Status, Phone } = req.body;

  // Validate if all required fields are provided
  if (!Name || !Address || !Area_ID || !Meter_ID || !Account_Status || !Phone) {
    return res.status(400).json({ message: "All fields are required!" });
  }

  const query = `
    INSERT INTO Users (Name, Address, Area_ID, Meter_ID, Account_Status, Phone)
    VALUES (?, ?, ?, ?, ?, ?);
  `;

  db.query(
    query,
    [Name, Address, Area_ID, Meter_ID, Account_Status, Phone],
    (err, result) => {
      if (err) return next(err);

      // Successfully inserted new user
      res
        .status(201)
        .json({ message: "User added successfully", userId: result.insertId });
    }
  );
};
const getUser = (req, res) => {
  res.send("Get user called");
};

//area
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

const getAllAreas = (req, res, next) => {
  const query = `
    SELECT *
    FROM Area
    ORDER BY Location ASC;
  `;

  db.query(query, (err, results) => {
    if (err) return next(err);

    res.json(results);
  });
};

//complain
const getActiveComplaints = (req, res, next) => {
  const query = `
  SELECT *
  FROM Complaint
  WHERE status = 'Pending'
  ORDER BY Submission_Date ASC
`;

  db.query(query, (err, results) => {
    if (err) return next(err);
    res.json(results);
  });
};
const resolveComplaint = (req, res, next) => {
  const complaintId = req.params.id;

  const query = `
    UPDATE Complaint
    SET Status = 'Resolved',
        Resolution_Date = CURRENT_DATE
    WHERE Complaint_ID = ?
  `;

  db.query(query, [complaintId], (err, result) => {
    if (err) return next(err);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Complaint not found" });
    }

    res.json({ message: "Complaint resolved successfully" });
  });
};

//Distribution
const addDistribution = (req, res, next) => {
  const {
    Area_ID,
    Water_Source,
    Distribution_Date,
    Water_Volume,
    Backup_Supply_Status,
    Leak_Detection_Sensor_Status,
  } = req.body;

  // Validate input
  if (
    !Area_ID ||
    !Water_Source ||
    !Distribution_Date ||
    !Water_Volume ||
    !Backup_Supply_Status ||
    !Leak_Detection_Sensor_Status
  ) {
    return res.status(400).json({ message: "All fields are required!" });
  }

  const query = `
    INSERT INTO Distribution (Area_ID, Water_Source, Distribution_Date, Water_Volume, Backup_Supply_Status, Leak_Detection_Sensor_Status)
    VALUES (?, ?, ?, ?, ?, ?);
  `;

  db.query(
    query,
    [
      Area_ID,
      Water_Source,
      Distribution_Date,
      Water_Volume,
      Backup_Supply_Status,
      Leak_Detection_Sensor_Status,
    ],
    (err, result) => {
      if (err) return next(err);

      res.status(201).json({
        message: "Distribution added successfully!",
        Distribution_ID: result.insertId,
      });
    }
  );
};

// view distribution by via area name
const getAllDistributionData = (req, res, next) => {
  const query = `
    SELECT d.Area_ID,a.Location AS Area_Name, d.Water_Source, d.Distribution_Date, 
           d.Water_Volume, d.Backup_Supply_Status, d.Leak_Detection_Sensor_Status
    FROM Distribution d
    JOIN Area a ON d.Area_ID = a.Area_ID
    ORDER BY a.Location;
  `;

  db.query(query, (err, results) => {
    if (err) return next(err);

    res.json(results);
  });
};
//billing
const getUnpaidBillsSorted = (req, res, next) => {
  const query = `
    SELECT *
    FROM Billing
    WHERE Payment_Status = 'Unpaid'
    ORDER BY Total_Amount DESC
  `;

  db.query(query, (err, results) => {
    if (err) return next(err);

    // If no unpaid bills are found
    if (results.length === 0) {
      return res.status(404).json({ message: "No unpaid bills found." });
    }

    // Send the unpaid bills in the response
    res.json(results);
  });
};

const addBilling = (req, res, next) => {
  const {
    Billing_Date,
    Usage_Volume,
    Rate_Per_Unit,
    Total_Amount,
    Payment_Status,
    User_ID,
  } = req.body;

  // Validate input
  if (
    !Billing_Date ||
    !Usage_Volume ||
    !Rate_Per_Unit ||
    !Total_Amount ||
    !Payment_Status ||
    !User_ID
  ) {
    return res.status(400).json({ message: "All fields are required!" });
  }

  const query = `
    INSERT INTO Billing (Billing_Date, Usage_Volume, Rate_Per_Unit, Total_Amount, Payment_Status, User_ID)
    VALUES (?, ?, ?, ?, ?, ?);
  `;

  db.query(
    query,
    [
      Billing_Date,
      Usage_Volume,
      Rate_Per_Unit,
      Total_Amount,
      Payment_Status,
      User_ID,
    ],
    (err, result) => {
      if (err) return next(err);

      res
        .status(201)
        .json({
          message: "Billing record added successfully!",
          Billing_ID: result.insertId,
        });
    }
  );
};
//Monitoring
const getAllMonitoring = (req, res, next) => {
  const query = `SELECT * FROM Monitoring
                  ORDER BY Water_Quality_Status`;

  db.query(query, (err, results) => {
    if (err) return next(err);

    res.json(results);
  });
};
// Update monitoring status and date
const updateMonitoringData_waterQuality = (req, res, next) => {
  const { Monitoring_ID, Water_Quality_Status, Monitoring_Date } = req.body;

  // Validate input
  if (!Monitoring_ID || !Water_Quality_Status || !Monitoring_Date) {
    return res.status(400).json({ message: "All fields are required!" });
  }

  const query = `
    UPDATE Monitoring
    SET Water_Quality_Status = ?, 
        Monitoring_Date = ?
    WHERE Monitoring_ID = ?;
  `;

  db.query(
    query,
    [Water_Quality_Status, Monitoring_Date, Monitoring_ID],
    (err, result) => {
      if (err) return next(err);

      if (result.affectedRows === 0) {
        return res.status(404).json({ message: "Monitoring ID not found!" });
      }

      res
        .status(200)
        .json({ message: "Monitoring data updated successfully!" });
    }
  );
};

const getAreasAboveAvgUsage = (req, res, next) => {
  const query = `
    SELECT Area_ID, AVG(Usage_Volume) AS Average_Usage_Volume
    FROM Monitoring
    GROUP BY Area_ID
    HAVING AVG(Usage_Volume) > (
      SELECT AVG(Usage_Volume) FROM Monitoring
    )
      ORDER BY Average_Usage_Volume DESC
  `;

  db.query(query, (err, results) => {
    if (err) return next(err);

    // If no areas found
    if (results.length === 0) {
      return res
        .status(404)
        .json({ message: "No areas found with above average usage volume." });
    }

    // Send the results in the response
    res.json(results);
  });
};

console.log("all the controllers loaded");
module.exports = {
  addUser,
  getUser,
  getUsersByArea,
  getActiveComplaints,
  resolveComplaint,
  getUnpaidBillsSorted,
  getAreasAboveAvgUsage,
  getAllAreas,
  getAllMonitoring,
  updateMonitoringData_waterQuality,
  getAllDistributionData,
  addDistribution,
  addBilling,
};
