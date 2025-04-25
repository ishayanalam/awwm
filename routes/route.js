const express = require("express");
const router = express.Router();
const controller = require("../controllers/controller.js");

// routes/userRoute.js
router.get("/test", (req, res) => {
  res.json({ message: "User route is working!" });
});

router.get("/users/area/:area_id", controller.getUsersByArea);
router.get("/complaints/active", controller.getActiveComplaints);

module.exports = router;
