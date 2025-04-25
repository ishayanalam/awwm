-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 25, 2025 at 03:18 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `awwms`
--

-- --------------------------------------------------------

--
-- Table structure for table `area`
--

CREATE TABLE `area` (
  `Area_ID` int(11) NOT NULL,
  `Location` varchar(100) DEFAULT NULL,
  `WASA_Zone` varchar(50) DEFAULT NULL,
  `Water_Source` varchar(100) DEFAULT NULL,
  `Water_Supply_Capacity` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `area`
--

INSERT INTO `area` (`Area_ID`, `Location`, `WASA_Zone`, `Water_Source`, `Water_Supply_Capacity`) VALUES
(1, 'Mirpur', 'Zone 1', 'Shitalakkhya River', 5000.00),
(2, 'Uttara', 'Zone 2', 'Tongi Canal', 4500.00),
(3, 'Dhanmondi', 'Zone 3', 'Buriganga River', 3000.00),
(4, 'Gulshan', 'Zone 4', 'Sitalakshya River', 4000.00),
(5, 'Mohammadpur', 'Zone 5', 'Jamuna River', 3500.00);

-- --------------------------------------------------------

--
-- Table structure for table `authority`
--

CREATE TABLE `authority` (
  `Admin_ID` int(11) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Role` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `authority`
--

INSERT INTO `authority` (`Admin_ID`, `Name`, `Role`) VALUES
(1, 'Md. Abdul Majid', 'Admin'),
(2, 'Fatema Naz', 'Water Supply Officer'),
(3, 'Khalilur Rahman', 'Area Supervisor'),
(4, 'Ayesha Akter', 'Field Engineer'),
(5, 'Hossain Ahmed', 'Monitoring Officer');

-- --------------------------------------------------------

--
-- Table structure for table `billing`
--

CREATE TABLE `billing` (
  `Billing_ID` int(11) NOT NULL,
  `Billing_Date` date DEFAULT NULL,
  `Usage_Volume` decimal(10,2) DEFAULT NULL,
  `Rate_Per_Unit` decimal(10,2) DEFAULT NULL,
  `Total_Amount` decimal(10,2) DEFAULT NULL,
  `Payment_Status` varchar(20) DEFAULT NULL,
  `User_ID` int(11) DEFAULT NULL,
  `Area_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `billing`
--

INSERT INTO `billing` (`Billing_ID`, `Billing_Date`, `Usage_Volume`, `Rate_Per_Unit`, `Total_Amount`, `Payment_Status`, `User_ID`, `Area_ID`) VALUES
(1, '2025-04-20', 400.00, 5.00, 2000.00, 'Paid', 1, 1),
(2, '2025-04-21', 350.00, 5.50, 1925.00, 'Unpaid', 2, 2),
(3, '2025-04-22', 300.00, 6.00, 1800.00, 'Paid', 3, 3),
(4, '2025-04-23', 450.00, 4.50, 2025.00, 'Unpaid', 4, 4),
(5, '2025-04-24', 380.00, 5.20, 1976.00, 'Paid', 5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `complaint`
--

CREATE TABLE `complaint` (
  `Complaint_ID` int(11) NOT NULL,
  `User_ID` int(11) DEFAULT NULL,
  `Area_ID` int(11) DEFAULT NULL,
  `Issue_Type` varchar(100) DEFAULT NULL,
  `Submission_Date` date DEFAULT NULL,
  `Resolution_Date` date DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `complaint`
--

INSERT INTO `complaint` (`Complaint_ID`, `User_ID`, `Area_ID`, `Issue_Type`, `Submission_Date`, `Resolution_Date`, `Status`) VALUES
(1, 1, 1, 'Water Supply Disruption', '2025-04-20', '2025-04-25', 'Resolved'),
(2, 2, 2, 'Water Leakage', '2025-03-03', NULL, 'Pending'),
(3, 3, 3, 'Poor Water Pressure', '2025-04-22', '2025-04-25', 'Resolved'),
(4, 4, 4, 'Water Contamination', '2025-04-23', '2025-04-24', 'Resolved'),
(5, 5, 5, 'Irregular Water Supply', '2025-04-24', NULL, 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `distribution`
--

CREATE TABLE `distribution` (
  `Distribution_ID` int(11) NOT NULL,
  `Area_ID` int(11) DEFAULT NULL,
  `Water_Source` varchar(100) DEFAULT NULL,
  `Distribution_Date` date DEFAULT NULL,
  `Water_Volume` decimal(10,2) DEFAULT NULL,
  `Backup_Supply_Status` varchar(50) DEFAULT NULL,
  `Leak_Detection_Sensor_Status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `distribution`
--

INSERT INTO `distribution` (`Distribution_ID`, `Area_ID`, `Water_Source`, `Distribution_Date`, `Water_Volume`, `Backup_Supply_Status`, `Leak_Detection_Sensor_Status`) VALUES
(1, 1, 'Shitalakkhya River', '2025-04-20', 450.00, 'Active', 'Working'),
(2, 2, 'Tongi Canal', '2025-04-21', 400.00, 'Inactive', 'Working'),
(3, 3, 'Buriganga River', '2025-04-22', 350.00, 'Active', 'Not Working'),
(4, 4, 'Sitalakshya River', '2025-04-23', 500.00, 'Active', 'Working'),
(5, 5, 'Jamuna River', '2025-04-24', 420.00, 'Inactive', 'Working');

-- --------------------------------------------------------

--
-- Table structure for table `monitoring`
--

CREATE TABLE `monitoring` (
  `Monitoring_ID` int(11) NOT NULL,
  `Area_ID` int(11) DEFAULT NULL,
  `Monitoring_Date` date DEFAULT NULL,
  `Usage_Volume` decimal(10,2) DEFAULT NULL,
  `Water_Quality_Status` varchar(50) DEFAULT NULL,
  `Water_Pressure` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `monitoring`
--

INSERT INTO `monitoring` (`Monitoring_ID`, `Area_ID`, `Monitoring_Date`, `Usage_Volume`, `Water_Quality_Status`, `Water_Pressure`) VALUES
(1, 1, '2025-04-20', 400.00, 'Good', 'Normal'),
(2, 2, '2025-04-21', 350.00, 'Satisfactory', 'Low'),
(3, 3, '2025-04-22', 300.00, 'Good', 'High'),
(4, 4, '2025-04-23', 450.00, 'Excellent', 'Normal'),
(5, 5, '2025-04-24', 380.00, 'Good', 'Low');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `User_ID` int(11) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Area_ID` int(11) DEFAULT NULL,
  `Meter_ID` int(11) DEFAULT NULL,
  `Account_Status` varchar(20) DEFAULT 'Active',
  `Phone` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`User_ID`, `Name`, `Address`, `Area_ID`, `Meter_ID`, `Account_Status`, `Phone`) VALUES
(1, 'Md. Shahinur Rahman', 'House 5, Road 12, Mirpur', 1, 101, 'Active', '01912345678'),
(2, 'Fatima Begum', 'Flat 7B, Block F, Uttara', 2, 102, 'Active', '01912345676'),
(3, 'Mohammad Zahirul Islam', '45, Dhanmondi Lake Road', 3, 103, 'Inactive', '01912345674'),
(4, 'Razia Sultana', '123, Gulshan Avenue', 4, 104, 'Active', '01912345178'),
(5, 'Abdul Kadir', 'House 17, Mohammadpur', 5, 105, 'Active', '01910345678'),
(6, 'Tariq Hossain', 'House 45, Road 3, Mirpur-10, Dhaka', 2, 23456, 'Active', '01712345678');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `area`
--
ALTER TABLE `area`
  ADD PRIMARY KEY (`Area_ID`);

--
-- Indexes for table `authority`
--
ALTER TABLE `authority`
  ADD PRIMARY KEY (`Admin_ID`);

--
-- Indexes for table `billing`
--
ALTER TABLE `billing`
  ADD PRIMARY KEY (`Billing_ID`),
  ADD KEY `User_ID` (`User_ID`),
  ADD KEY `Area_ID` (`Area_ID`);

--
-- Indexes for table `complaint`
--
ALTER TABLE `complaint`
  ADD PRIMARY KEY (`Complaint_ID`),
  ADD KEY `User_ID` (`User_ID`),
  ADD KEY `Area_ID` (`Area_ID`);

--
-- Indexes for table `distribution`
--
ALTER TABLE `distribution`
  ADD PRIMARY KEY (`Distribution_ID`),
  ADD KEY `Area_ID` (`Area_ID`);

--
-- Indexes for table `monitoring`
--
ALTER TABLE `monitoring`
  ADD PRIMARY KEY (`Monitoring_ID`),
  ADD KEY `Area_ID` (`Area_ID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`User_ID`),
  ADD KEY `Area_ID` (`Area_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `area`
--
ALTER TABLE `area`
  MODIFY `Area_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `authority`
--
ALTER TABLE `authority`
  MODIFY `Admin_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `billing`
--
ALTER TABLE `billing`
  MODIFY `Billing_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `complaint`
--
ALTER TABLE `complaint`
  MODIFY `Complaint_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `distribution`
--
ALTER TABLE `distribution`
  MODIFY `Distribution_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `monitoring`
--
ALTER TABLE `monitoring`
  MODIFY `Monitoring_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `User_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `billing`
--
ALTER TABLE `billing`
  ADD CONSTRAINT `billing_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `users` (`User_ID`),
  ADD CONSTRAINT `billing_ibfk_2` FOREIGN KEY (`Area_ID`) REFERENCES `area` (`Area_ID`);

--
-- Constraints for table `complaint`
--
ALTER TABLE `complaint`
  ADD CONSTRAINT `complaint_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `users` (`User_ID`),
  ADD CONSTRAINT `complaint_ibfk_2` FOREIGN KEY (`Area_ID`) REFERENCES `area` (`Area_ID`);

--
-- Constraints for table `distribution`
--
ALTER TABLE `distribution`
  ADD CONSTRAINT `distribution_ibfk_1` FOREIGN KEY (`Area_ID`) REFERENCES `area` (`Area_ID`);

--
-- Constraints for table `monitoring`
--
ALTER TABLE `monitoring`
  ADD CONSTRAINT `monitoring_ibfk_1` FOREIGN KEY (`Area_ID`) REFERENCES `area` (`Area_ID`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`Area_ID`) REFERENCES `area` (`Area_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
