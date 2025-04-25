const express = require("express");
const router = express.Router();
const controller = require("../controllers/controller.js");

// routes/userRoute.js
router.get("/test", (req, res) => {
  res.json({ message: "User route is working!" });
});

router.get("/users/area/:area_id", controller.getUsersByArea);
router.get("/complaints/active", controller.getActiveComplaints);
router.put("/complaints/resolve/:id", controller.resolveComplaint);
router.get("/bills/unpaid/sorted", controller.getUnpaidBillsSorted);
router.get("/usage/areas-above-average", controller.getAreasAboveAvgUsage);
router.post("/users", controller.addUser);
router.get("/areas", controller.getAllAreas);
router.get("/monitoring", controller.getAllMonitoring);
router.put(
  "/monitoring/update-quality",
  controller.updateMonitoringData_waterQuality
);
router.get("/distributions", controller.getAllDistributionData);

module.exports = router;
