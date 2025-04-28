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
const getAllUserInfo = (req, res, next) => {
  const query = `
    SELECT *
    FROM userandarea
    ORDER BY User_ID ASC;  -- You can change the sorting criteria as per your requirement
  `;

  db.query(query, (err, results) => {
    if (err) return next(err);

    res.json(results); // Return the results as JSON
  });
};

//area
const addArea = (req, res, next) => {
  const { Location, WASA_Zone, Water_Source, Water_Supply_Capacity } = req.body;

  // Validate if all required fields are provided
  if (!Location || !WASA_Zone || !Water_Source || !Water_Supply_Capacity) {
    return res.status(400).json({ message: "All fields are required!" });
  }

  const query = `
    INSERT INTO Area (Location, WASA_Zone, Water_Source, Water_Supply_Capacity)
    VALUES (?, ?, ?, ?);
  `;

  db.query(
    query,
    [Location, WASA_Zone, Water_Source, Water_Supply_Capacity],
    (err, result) => {
      if (err) return next(err);

      // Successfully inserted new area
      res
        .status(201)
        .json({ message: "Area added successfully", areaId: result.insertId });
    }
  );
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

const getComplaintDataById = (req, res, next) => {
  const complaintId = req.params.complaint_id; // Extracting complaint_id from the URL parameter

  const query = `
    SELECT 
      u.User_ID,
      u.Name AS UserName,
      u.Phone,
      c.Issue_Type,
      c.Submission_Date,
      c.Area_ID,
      a.Location AS Area_Name
    FROM Complaint c
    JOIN Users u ON c.User_ID = u.User_ID
    JOIN Area a ON c.Area_ID = a.Area_ID
    WHERE c.Complaint_ID = ?;
  `;

  db.query(query, [complaintId], (err, results) => {
    if (err) return next(err); // If an error occurs, pass it to the next middleware

    if (results.length === 0) {
      return res.status(404).json({ message: "Complaint not found" });
    }

    res.json(results[0]); // Return the first result as there's only one complaint with the given ID
  });
};

const getActiveComplaints = (req, res, next) => {
  const query = `
  SELECT *
  FROM Complaint
  WHERE status = 'Pending'
  ORDER BY Submission_Date DESC
`;

  db.query(query, (err, results) => {
    if (err) return next(err);
    res.json(results);
  });
};
const resolveComplaint = (req, res, next) => {
  const complaintId = req.params.id;
  const { complaintStatus } = req.body; // Get the new status from the request body

  if (!complaintStatus) {
    return res.status(400).json({ message: "Complaint status is required" });
  }

  const query = `
    UPDATE Complaint
    SET Status = ?, 
        Resolution_Date = CURRENT_DATE
    WHERE Complaint_ID = ?
  `;

  db.query(query, [complaintStatus, complaintId], (err, result) => {
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
const updateBillingStatus = (req, res, next) => {
  const { Billing_ID, Payment_Status } = req.body;

  // Validate input data
  if (!Billing_ID || !Payment_Status) {
    return res
      .status(400)
      .json({ message: "Billing ID and Payment Status are required!" });
  }

  // Query to update payment status
  const query = `
    UPDATE Billing
    SET Payment_Status = ?
    WHERE Billing_ID = ?;
  `;

  db.query(query, [Payment_Status, Billing_ID], (err, result) => {
    if (err) return next(err);

    if (result.affectedRows > 0) {
      res.status(200).json({ message: "Payment status updated successfully!" });
    } else {
      res.status(404).json({ message: "Billing record not found!" });
    }
  });
};

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

      res.status(201).json({
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
const addMonitoring = (req, res, next) => {
  const {
    Area_ID,
    Monitoring_Date,
    Usage_Volume,
    Water_Quality_Status,
    Water_Pressure,
  } = req.body;

  // Validate if all required fields are provided
  if (
    !Area_ID ||
    !Monitoring_Date ||
    !Usage_Volume ||
    !Water_Quality_Status ||
    !Water_Pressure
  ) {
    return res.status(400).json({ message: "All fields are required!" });
  }

  const query = `
    INSERT INTO Monitoring (Area_ID, Monitoring_Date, Usage_Volume, Water_Quality_Status, Water_Pressure)
    VALUES (?, ?, ?, ?, ?);
  `;

  db.query(
    query,
    [
      Area_ID,
      Monitoring_Date,
      Usage_Volume,
      Water_Quality_Status,
      Water_Pressure,
    ],
    (err, result) => {
      if (err) return next(err);

      // Successfully inserted new monitoring record
      res.status(201).json({
        message: "Monitoring record added successfully",
        Monitoring_ID: result.insertId,
      });
    }
  );
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

const getAreaMonitoringReport = (req, res, next) => {
  const query = `
    SELECT a.Location, a.Water_Source, m.Water_Quality_Status, m.Water_Pressure 
    FROM Area a 
    JOIN Monitoring m ON a.Area_ID = m.Area_ID 
    ORDER BY m.Monitoring_Date DESC
  `;

  db.query(query, (err, results) => {
    if (err) return next(err);
    res.json(results);
  });
};

// user site

const userSite_fullInfo = (req, res, next) => {
  const userId = req.params.id; // Get user ID from the URL

  const query = `
    SELECT *
    FROM UserFullInfo_View
    WHERE User_ID = ?
  `;

  db.query(query, [userId], (err, results) => {
    if (err) return next(err);

    res.json(results);
  });
};

const userSite_BillInfo = (req, res, next) => {
  const userId = req.params.id; // get user id

  const query = `
    SELECT *
    FROM Billing
    WHERE User_ID = ?
    ORDER BY Billing_Date DESC; 
  `;

  db.query(query, [userId], (err, results) => {
    if (err) return next(err);

    res.json(results);
  });
};

const userSite_submitComplaint = (req, res) => {
  const { userId, issueType } = req.body;

  // Check if userId and issueType are provided
  if (!userId || !issueType) {
    return res.status(400).json({
      message: "User ID and Issue Type are required.",
    });
  }

  const query = `
    INSERT INTO Complaint (User_ID, Area_ID, Issue_Type, Submission_Date, Status)
    SELECT ?, Area_ID, ?, NOW(), 'Pending'
    FROM Users
    WHERE User_ID = ?
  `;

  db.query(query, [userId, issueType, userId], (err, result) => {
    if (err) {
      console.error("Database error:", err); // Log the error for debugging
      return res.status(500).json({
        message: "Failed to submit the complaint. Please try again later.",
        error: err.message, // You can return the error message for debugging, but avoid exposing sensitive info in production.
      });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: "User not found. Unable to submit complaint.",
      });
    }

    res.status(201).json({
      message: "Complaint submitted successfully!",
      complaintId: result.insertId,
    });
  });
};

const userSite_getUserComplaints = (req, res, next) => {
  const userId = req.params.id; // User ID from URL

  const query = `
    SELECT 
      Complaint.Complaint_ID,
      Complaint.Issue_Type,
      Complaint.Submission_Date,
      Complaint.Status,
      Complaint.Resolution_Date,
      Area.Location AS Area_Name
    FROM Complaint
    JOIN Area ON Complaint.Area_ID = Area.Area_ID
    WHERE Complaint.User_ID = ?
    ORDER BY Complaint.Submission_Date DESC;
  `;

  db.query(query, [userId], (err, results) => {
    if (err) return next(err);

    res.json(results);
  });
};

console.log("all the controllers loaded");
module.exports = {
  addUser,

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
  getAreaMonitoringReport,
  addArea,
  addMonitoring,
  updateBillingStatus,
  getComplaintDataById,
  getAllUserInfo,
  userSite_fullInfo,
  userSite_BillInfo,
  userSite_submitComplaint,
  userSite_getUserComplaints,
};
