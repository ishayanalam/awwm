-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 28, 2025 at 08:24 PM
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
(5, 'Mohammadpur', 'Zone 5', 'Jamuna River', 3500.00),
(6, 'Banani, Dhaka', 'Zone 3', 'Dhaleshwari River', 5000.00),
(7, 'Dhaka', 'Zone 5', 'River', 5000.00),
(8, 'Dhaka Uddan ', 'Dhaka Uddan Wasa', 'Gabtoli Switch gate', 100000.00);

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
  `User_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `billing`
--

INSERT INTO `billing` (`Billing_ID`, `Billing_Date`, `Usage_Volume`, `Rate_Per_Unit`, `Total_Amount`, `Payment_Status`, `User_ID`) VALUES
(1, '2025-04-20', 400.00, 5.00, 2000.00, 'Paid', 1),
(2, '2025-04-21', 350.00, 5.50, 1925.00, 'Unpaid', 2),
(3, '2025-04-22', 300.00, 6.00, 1800.00, 'Paid', 3),
(4, '2025-04-23', 450.00, 4.50, 2025.00, 'Unpaid', 4),
(5, '2025-04-24', 380.00, 5.20, 1976.00, 'Paid', 5),
(6, '2025-04-27', 1500.00, 5.00, 7500.00, 'Paid', 1),
(7, '2025-04-27', 12042.00, 1.00, 12042.00, 'Unpaid', 1),
(8, '2025-04-01', 12333.00, 1.00, 12333.00, 'Unpaid', 3),
(9, '2025-04-27', 123.00, 1.00, 123.00, 'Unpaid', 3),
(10, '2025-04-24', 1444.00, 1.00, 1444.00, 'Unpaid', 3),
(11, '2025-04-28', 11.00, 1.00, 11.00, 'Unpaid', 8),
(12, '2025-04-28', 112.00, 1.00, 112.00, 'Unpaid', 8),
(13, '2025-04-28', 123.00, 1.00, 123.00, 'Paid', 8);

--
-- Triggers `billing`
--
DELIMITER $$
CREATE TRIGGER `UpdateAccountStatusAfterBilling` AFTER INSERT ON `billing` FOR EACH ROW BEGIN
DECLARE unpaid_count INT;
SELECT COUNT(*) INTO unpaid_count
FROM Billing
WHERE User_ID = NEW.User_ID AND Payment_Status = 'Unpaid';
-- Check unpaid bill count
IF unpaid_count >= 3 THEN
UPDATE Users
SET Account_Status = 'Inactive'
WHERE User_ID = NEW.User_ID;
ELSE
UPDATE Users
SET Account_Status = 'Active'
WHERE User_ID = NEW.User_ID;
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `UpdateAccountStatusAfterBillingUpdate` AFTER UPDATE ON `billing` FOR EACH ROW BEGIN
DECLARE unpaid_count INT;
-- Count unpaid bills for this user
SELECT COUNT(*) INTO unpaid_count
FROM Billing
WHERE User_ID = NEW.User_ID AND Payment_Status = 'Unpaid';
 -- Check unpaid bill count
IF unpaid_count >= 3 THEN
UPDATE Users
SET Account_Status = 'Inactive'
WHERE User_ID = NEW.User_ID;
ELSE
UPDATE Users
SET Account_Status = 'Active'
WHERE User_ID = NEW.User_ID;
END IF;
END
$$
DELIMITER ;

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
(26, 5, 5, 'Irregular ', '2025-04-28', NULL, 'Pending'),
(27, 1, 1, '1', '2025-04-28', NULL, 'Pending'),
(28, 1, 1, 'Irregular ', '2025-04-28', NULL, 'Pending'),
(29, 1, 1, 'Irregular ', '2025-04-28', NULL, 'Pending'),
(30, 5, 5, 'Water leakage detected', '2025-04-28', NULL, 'Pending'),
(31, 5, 5, 'Water leakage detected', '2025-04-28', NULL, 'Pending'),
(32, 5, 5, 'Testing', '2025-04-28', NULL, 'Pending'),
(33, 6, 2, 'Testing', '2025-04-28', NULL, 'Pending'),
(34, 2, 2, 'Irregular ', '2025-04-29', NULL, 'Pending'),
(35, 1, 1, 'Garbage on water', '2025-04-29', '2025-04-29', 'Resolved');

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
(5, 5, 'Jamuna River', '2025-04-24', 420.00, 'Inactive', 'Working'),
(6, 1, 'River', '2025-04-28', 5000.00, 'Active', 'Working'),
(7, 1, 'River', '2025-04-28', 5000.00, 'Active', 'Working'),
(8, 1, 'River', '2025-04-28', 5000.00, 'Active', 'Working'),
(9, 3, 'Gabtoli Switch gate', '2025-04-27', 123000.00, 'Inactive', 'Working');

-- --------------------------------------------------------

--
-- Table structure for table `monitoring`
--

CREATE TABLE `monitoring` (
  `Monitoring_ID` int(11) NOT NULL,
  `Area_ID` int(11) DEFAULT NULL,
  `Monitoring_Date` date DEFAULT NULL,
  `Water_Quality_Status` varchar(50) DEFAULT NULL,
  `Water_Pressure` varchar(50) DEFAULT NULL,
  `Usage_Volume` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `monitoring`
--

INSERT INTO `monitoring` (`Monitoring_ID`, `Area_ID`, `Monitoring_Date`, `Water_Quality_Status`, `Water_Pressure`, `Usage_Volume`) VALUES
(1, 1, '2025-04-27', 'Average', 'Normal', 1000.00),
(2, 2, '2025-04-21', 'Average', 'Low', 2000.00),
(3, 3, '2025-04-22', 'Not Good', 'High', 3000.00),
(4, 4, '2025-04-23', 'Very Good', 'Normal', 4000.00),
(5, 5, '2025-04-24', 'Average', 'Low', 3500.00),
(6, 1, '2025-04-28', 'Good', 'Normal', 5000.00),
(7, 1, '2025-04-28', 'Good', 'Normal', 5000.00),
(8, 2, '2025-04-18', 'Good', 'High', 1123.00);

-- --------------------------------------------------------

--
-- Stand-in structure for view `userandarea`
-- (See below for the actual view)
--
CREATE TABLE `userandarea` (
`User_ID` int(11)
,`Name` varchar(100)
,`Phone` varchar(15)
,`Address` varchar(255)
,`Account_Status` varchar(20)
,`Area_Name` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `userfullinfo_view`
-- (See below for the actual view)
--
CREATE TABLE `userfullinfo_view` (
`User_ID` int(11)
,`Name` varchar(100)
,`Phone` varchar(15)
,`Address` varchar(255)
,`Account_Status` varchar(20)
,`Meter_ID` int(11)
,`Area_Name` varchar(100)
);

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
(6, 'Tariq Hossain', 'House 45, Road 3, Mirpur-10, Dhaka', 2, 23456, 'Active', '01712345678'),
(7, 'Tariq Hossain', 'House 45, Road 3, Mirpur-10, Dhaka', 2, 23456, 'Active', '01712345678'),
(8, 'Shayan', 'Shekertec 06, Adabor, Dhaka', 2, 24411, 'Active', '01239128301'),
(9, 'Rafsan Jani Washi', 'Dhanmondi', 3, 2345, 'Inactive', '01239128369');

-- --------------------------------------------------------

--
-- Structure for view `userandarea`
--
DROP TABLE IF EXISTS `userandarea`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `userandarea`  AS SELECT `u`.`User_ID` AS `User_ID`, `u`.`Name` AS `Name`, `u`.`Phone` AS `Phone`, `u`.`Address` AS `Address`, `u`.`Account_Status` AS `Account_Status`, `a`.`Location` AS `Area_Name` FROM (`users` `u` join `area` `a` on(`u`.`Area_ID` = `a`.`Area_ID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `userfullinfo_view`
--
DROP TABLE IF EXISTS `userfullinfo_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `userfullinfo_view`  AS SELECT `u`.`User_ID` AS `User_ID`, `u`.`Name` AS `Name`, `u`.`Phone` AS `Phone`, `u`.`Address` AS `Address`, `u`.`Account_Status` AS `Account_Status`, `u`.`Meter_ID` AS `Meter_ID`, `a`.`Location` AS `Area_Name` FROM (`users` `u` join `area` `a` on(`u`.`Area_ID` = `a`.`Area_ID`)) ;

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
  ADD KEY `User_ID` (`User_ID`);

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
  MODIFY `Area_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `authority`
--
ALTER TABLE `authority`
  MODIFY `Admin_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `billing`
--
ALTER TABLE `billing`
  MODIFY `Billing_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `complaint`
--
ALTER TABLE `complaint`
  MODIFY `Complaint_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `distribution`
--
ALTER TABLE `distribution`
  MODIFY `Distribution_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `monitoring`
--
ALTER TABLE `monitoring`
  MODIFY `Monitoring_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `User_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `billing`
--
ALTER TABLE `billing`
  ADD CONSTRAINT `billing_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `users` (`User_ID`);

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
