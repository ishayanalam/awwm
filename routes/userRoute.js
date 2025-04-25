const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController");

// routes/userRoute.js
router.get("/test", (req, res) => {
  res.json({ message: "User route is working!" });
});

module.exports = router;
