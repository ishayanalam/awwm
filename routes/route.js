const express = require("express");
const router = express.Router();
const controller = require("../controllers/controller.js");

// routes

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
router.post("/distribution-add", controller.addDistribution);
router.post("/billing-new", controller.addBilling);
router.get("/monitoring/area-report", controller.getAreaMonitoringReport);
router.post("/area/add-new", controller.addArea);
router.post("/monitoring/add-new", controller.addMonitoring);
router.post("/billing/updateStatus", controller.updateBillingStatus);
router.get("/complaints/:complaint_id", controller.getComplaintDataById);
router.get("/users/get-user-info", controller.getAllUserInfo);

module.exports = router;
