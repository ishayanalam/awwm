require("dotenv").config();
const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");

const app = express();
const userRouter = require("./routes/userRoute.js");

require("./db/database"); // DB connection

app.use(cors());
app.use(express.json()); // Parses incoming JSON
app.use(bodyParser.urlencoded({ extended: true }));
app.use("/api", userRouter);

// Global error handler
app.use((err, req, res, next) => {
  err.statusCode = err.statusCode || 500;
  err.message = err.message || "Internal Server Error";
  res.status(err.statusCode).json({ message: err.message });
});
console.log("Server is running");
app.listen(3000, () => console.log("Server is running on port 3000"));
