-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 05, 2026 at 01:06 PM
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
-- Database: `nabh_pr`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_purchase_queries`
--

CREATE TABLE `admin_purchase_queries` (
  `conversation_id` int(11) NOT NULL,
  `admin_id` varchar(50) NOT NULL,
  `dept_id` varchar(100) NOT NULL,
  `admin_chat` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`admin_chat`)),
  `purchase_chat` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`purchase_chat`)),
  `status` enum('open','resolved') DEFAULT 'open',
  `created_at` datetime DEFAULT current_timestamp(),
  `last_updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `admin_unread` int(11) DEFAULT 0,
  `purchase_unread` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `asset_history`
--

CREATE TABLE `asset_history` (
  `item_id` int(11) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `date_purchased` varchar(50) DEFAULT 'nan',
  `date_added_to_inventory` varchar(50) DEFAULT 'nan',
  `allocation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`allocation`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `asset_history`
--

INSERT INTO `asset_history` (`item_id`, `item_name`, `date_purchased`, `date_added_to_inventory`, `allocation`) VALUES
(2, 'KEYBOARD', 'nan', '2026-04-07 09:13:05', '{\"DEPT-PED\":{\"allocation_date\":\"2026-04-07 10:44:09\",\"revoke_date\":\"2026-04-07 10:45:12\"},\"DEPT-ORTHO\":{\"allocation_date\":\"2026-04-07 10:53:08\",\"revoke_date\":\"2026-04-07 10:55:03\"},\"DEPT-ICU\":{\"allocation_date\":\"2026-04-07 10:59:01\",\"revoke_date\":\"2026-04-07 07:29:25\"},\"DEPT-NEURO\":{\"allocation_date\":\"2026-04-08 09:19:26\",\"revoke_date\":\"2026-04-16 05:46:58\"},\"DEPT-ER\":{\"allocation_date\":\"2026-04-16 10:11:23\",\"discarded_date\":\"2026-04-16 10:33:25\"}}'),
(6, 'KEYBOARD', 'nan', '2026-04-07 09:13:05', '{\"DEPT-ICU\":{\"allocation_date\":\"2026-04-16 09:55:50\",\"revoke_date\":\"nan\"},\"DEPT-ER\":{\"allocation_date\":\"2026-04-16 10:11:23\",\"discarded_date\":\"2026-04-16 10:46:12\"}}'),
(7, 'KEYBOARD', 'nan', '2026-04-07 09:13:05', '{\"DEPT-ICU\":{\"allocation_date\":\"2026-04-13 12:31:07\",\"revoke_date\":\"2026-04-16 05:46:58\"},\"DEPT-ER\":{\"allocation_date\":\"2026-04-16 10:11:23\",\"revoke_date\":\"2026-04-16 10:11:52\"},\"DEPT-CARD\":{\"allocation_date\":\"2026-07-01 15:17:17\",\"revoke_date\":\"nan\"}}'),
(9, 'USG Machine', 'nan', '2026-04-07 09:33:11', '{\"DEPT-ER\":{\"allocation_date\":\"2026-04-16 10:11:23\",\"discarded_date\":\"2026-04-16 10:23:03\"}}'),
(10, 'X-RAY Machine', 'nan', '2026-04-07 09:33:11', '{\"DEPT-ER\":{\"allocation_date\":\"2026-04-08 09:48:08\",\"revoke_date\":\"2026-04-16 05:46:58\"},\"DEPT-CARD\":{\"allocation_date\":\"2026-07-01 15:17:17\",\"revoke_date\":\"nan\"}}'),
(11, 'X-RAY Machine', 'nan', '2026-04-07 09:33:11', '{\"DEPT-ER\":{\"allocation_date\":\"2026-04-16 09:11:44\",\"revoke_date\":\"2026-04-16 05:46:58\"},\"DEPT-CARD\":{\"allocation_date\":\"2026-07-01 15:17:17\",\"revoke_date\":\"nan\"}}'),
(13, 'X-RAY Machine', 'nan', '2026-04-07 09:33:11', '{\"DEPT-ER\":{\"allocation_date\":\"2026-04-16 09:11:44\",\"revoke_date\":\"2026-04-16 05:46:58\"},\"DEPT-ICU\":{\"allocation_date\":\"2026-04-16 10:01:19\",\"revoke_date\":\"nan\"}}'),
(14, 'USG Machine', 'nan', '2026-04-08 11:40:24', '{}'),
(17, 'USG Machine', 'nan', '2026-04-08 11:48:25', '{}'),
(18, 'USG Machine', 'nan', '2026-04-08 11:48:25', '{}'),
(19, 'X-RAY Machine', 'nan', '2026-04-08 11:48:25', '{\"DEPT-ICU\":{\"allocation_date\":\"2026-04-16 09:53:44\",\"revoke_date\":\"nan\"}}'),
(20, 'X-RAY Machine', 'nan', '2026-04-08 11:48:25', '{}'),
(21, 'X-RAY Machine', 'nan', '2026-04-08 11:48:25', '{}'),
(22, 'X-RAY Machine', 'nan', '2026-04-08 11:48:25', '{}'),
(23, 'Monitor', '2026-04-13 00:00:00', '2026-04-21 12:24:42', '{\"DEPT-CARD\":{\"allocation_date\":\"2026-06-27 16:42:16\",\"revoke_date\":\"nan\"}}'),
(24, 'Monitor', '2026-04-13 00:00:00', '2026-04-21 12:24:42', '{\"DEPT-CARD\":{\"allocation_date\":\"2026-06-27 16:42:16\",\"revoke_date\":\"nan\"}}'),
(25, 'Monitor', '2026-04-13 00:00:00', '2026-04-21 12:30:36', '{}'),
(26, 'Patient Monitor', 'nan', 'nan', '{\"DEPT-CARD\":{\"allocation_date\":\"2026-07-01 17:01:29\",\"revoke_date\":\"nan\"}}'),
(27, 'Ventilator', '2025-11-24 16:00:00', '2025-11-28 16:00:00', '{}'),
(28, 'ECG Machine', '2025-01-26 22:00:00', '2025-02-03 22:00:00', '{}'),
(29, 'ECG Machine', '2025-06-24 12:00:00', '2025-06-28 12:00:00', '{}'),
(30, 'Billing Workstation', '2025-03-22 08:00:00', '2025-03-30 08:00:00', '{\"DEPT-ER\": {\"allocation_date\": \"2025-03-31 08:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(31, 'ECG Machine', '2025-10-11 11:00:00', '2025-10-13 11:00:00', '{\"DEPT-CARD\": {\"allocation_date\": \"2025-10-16 11:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(32, 'Billing Workstation', '2025-06-09 16:00:00', '2025-06-16 16:00:00', '{\"DEPT-NEURO\": {\"allocation_date\": \"2025-06-19 16:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(33, 'Server Switch', '2025-01-11 01:00:00', '2025-01-16 01:00:00', '{\"DEPT-ORTHO\": {\"allocation_date\": \"2025-01-17 01:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(34, 'ECG Machine', '2025-07-22 21:00:00', '2025-07-28 21:00:00', '{\"DEPT-NEURO\": {\"allocation_date\": \"2025-07-31 21:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(35, 'Server Switch', '2026-02-01 05:00:00', '2026-02-07 05:00:00', '{\"DEPT-ER\": {\"allocation_date\": \"2026-02-08 05:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(36, 'Ventilator', '2025-02-26 08:00:00', '2025-03-07 08:00:00', '{\"DEPT-NEURO\": {\"allocation_date\": \"2025-03-08 08:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(37, 'Patient Monitor', '2025-06-27 22:00:00', '2025-07-07 22:00:00', '{\"DEPT-ORTHO\": {\"allocation_date\": \"2025-07-08 22:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(38, 'Patient Monitor', '2025-02-05 13:00:00', '2025-02-13 13:00:00', '{\"DEPT-ICU\": {\"allocation_date\": \"2025-02-18 13:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(39, 'ECG Machine', '2025-03-21 11:00:00', '2025-03-23 11:00:00', '{\"DEPT-RAD\": {\"allocation_date\": \"2025-03-28 11:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(40, 'USG Machine', '2025-09-17 10:00:00', '2025-09-24 10:00:00', '{\"DEPT-ORTHO\": {\"allocation_date\": \"2025-09-27 10:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(41, 'Ventilator', '2025-03-16 22:00:00', '2025-03-24 22:00:00', '{\"DEPT-ORTHO\": {\"allocation_date\": \"2025-03-26 22:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(42, 'Ventilator', '2025-04-02 11:00:00', '2025-04-11 11:00:00', '{}'),
(43, 'Billing Workstation', '2025-11-24 23:00:00', '2025-12-02 23:00:00', '{\"DEPT-ER\": {\"allocation_date\": \"2025-12-03 23:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(44, 'Ventilator', '2025-09-20 18:00:00', '2025-09-29 18:00:00', '{\"DEPT-NEURO\": {\"allocation_date\": \"2025-10-04 18:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(45, 'X-RAY Machine', '2025-10-21 18:00:00', '2025-10-27 18:00:00', '{\"DEPT-NEURO\": {\"allocation_date\": \"2025-11-01 18:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(46, 'Printer', '2025-11-05 18:00:00', '2025-11-14 18:00:00', '{\"DEPT-PED\": {\"allocation_date\": \"2025-11-19 18:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(47, 'X-RAY Machine', '2025-02-04 03:00:00', '2025-02-06 03:00:00', '{\"DEPT-NEURO\": {\"allocation_date\": \"2025-02-08 03:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(48, 'X-RAY Machine', '2026-02-06 22:00:00', '2026-02-09 22:00:00', '{\"DEPT-ORTHO\": {\"allocation_date\": \"2026-02-14 22:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(49, 'Billing Workstation', '2026-02-03 07:00:00', '2026-02-07 07:00:00', '{\"DEPT-ORTHO\": {\"allocation_date\": \"2026-02-12 07:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(50, 'Ventilator', '2026-02-01 20:00:00', '2026-02-06 20:00:00', '{\"DEPT-CARD\": {\"allocation_date\": \"2026-02-10 20:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(51, 'Ventilator', '2026-01-18 09:00:00', '2026-01-25 09:00:00', '{\"DEPT-ER\": {\"allocation_date\": \"2026-01-27 09:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(52, 'Defibrillator', '2025-10-07 02:00:00', '2025-10-11 02:00:00', '{}'),
(53, 'Defibrillator', '2025-01-14 16:00:00', '2025-01-20 16:00:00', '{\"DEPT-OT\": {\"allocation_date\": \"2025-01-22 16:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(54, 'Ventilator', '2025-06-05 13:00:00', '2025-06-13 13:00:00', '{}'),
(55, 'Ventilator', '2025-02-15 15:00:00', '2025-02-17 15:00:00', '{}'),
(56, 'Server Switch', '2025-04-17 18:00:00', '2025-04-26 18:00:00', '{\"DEPT-OT\": {\"allocation_date\": \"2025-04-30 18:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(57, 'Printer', '2025-03-29 18:00:00', '2025-03-31 18:00:00', '{}'),
(58, 'Ventilator', '2025-03-25 01:00:00', '2025-03-31 01:00:00', '{\"DEPT-CARD\": {\"allocation_date\": \"2025-04-04 01:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(59, 'ECG Machine', '2025-05-12 14:00:00', '2025-05-18 14:00:00', '{}'),
(60, 'Ventilator', '2025-05-17 08:00:00', '2025-05-23 08:00:00', '{\"DEPT-PED\": {\"allocation_date\": \"2025-05-25 08:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(61, 'Ventilator', '2025-05-09 08:00:00', '2025-05-18 08:00:00', '{\"DEPT-RAD\": {\"allocation_date\": \"2025-05-21 08:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(62, 'Defibrillator', '2025-06-24 21:00:00', '2025-06-30 21:00:00', '{\"DEPT-PHARM\": {\"allocation_date\": \"2025-07-05 21:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(63, 'X-RAY Machine', '2025-06-03 19:00:00', '2025-06-05 19:00:00', '{}'),
(64, 'Printer', '2025-09-24 13:00:00', '2025-09-26 13:00:00', '{\"DEPT-ICU\": {\"allocation_date\": \"2025-09-29 13:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(65, 'USG Machine', '2026-01-12 02:00:00', '2026-01-22 02:00:00', '{\"DEPT-ICU\": {\"allocation_date\": \"2026-01-26 02:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(66, 'Server Switch', '2025-02-01 10:00:00', '2025-02-04 10:00:00', '{\"DEPT-RAD\": {\"allocation_date\": \"2025-02-06 10:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(67, 'Ventilator', '2025-07-11 01:00:00', '2025-07-18 01:00:00', '{\"DEPT-RAD\": {\"allocation_date\": \"2025-07-20 01:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(68, 'USG Machine', '2025-09-13 14:00:00', '2025-09-15 14:00:00', '{\"DEPT-NEURO\": {\"allocation_date\": \"2025-09-18 14:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(69, 'Defibrillator', '2025-02-19 01:00:00', '2025-02-28 01:00:00', '{\"DEPT-RAD\": {\"allocation_date\": \"2025-03-01 01:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(70, 'Patient Monitor', '2025-12-08 11:00:00', '2025-12-12 11:00:00', '{\"DEPT-ICU\": {\"allocation_date\": \"2025-12-17 11:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(71, 'Ventilator', '2025-10-17 22:00:00', '2025-10-23 22:00:00', '{\"DEPT-NEURO\": {\"allocation_date\": \"2025-10-24 22:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(72, 'Billing Workstation', '2025-05-20 21:00:00', '2025-05-25 21:00:00', '{\"DEPT-NEURO\": {\"allocation_date\": \"2025-05-30 21:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(73, 'Printer', '2025-01-18 18:00:00', '2025-01-23 18:00:00', '{\"DEPT-ER\": {\"allocation_date\": \"2025-01-27 18:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(74, 'X-RAY Machine', '2025-04-25 22:00:00', '2025-05-04 22:00:00', '{\"DEPT-PHARM\": {\"allocation_date\": \"2025-05-08 22:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(75, 'Defibrillator', '2026-01-19 06:00:00', '2026-01-29 06:00:00', '{\"DEPT-ORTHO\": {\"allocation_date\": \"2026-01-31 06:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(76, 'Printer', '2025-03-02 02:00:00', '2025-03-12 02:00:00', '{\"DEPT-PED\": {\"allocation_date\": \"2025-03-16 02:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(77, 'Ventilator', '2025-12-27 17:00:00', '2026-01-05 17:00:00', '{}'),
(78, 'Server Switch', '2025-08-21 09:00:00', '2025-08-29 09:00:00', '{\"DEPT-OT\": {\"allocation_date\": \"2025-08-31 09:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(79, 'Server Switch', '2025-03-05 10:00:00', '2025-03-14 10:00:00', '{}'),
(80, 'ECG Machine', '2025-02-26 19:00:00', '2025-03-06 19:00:00', '{\"DEPT-CARD\": {\"allocation_date\": \"2025-03-09 19:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(81, 'Ventilator', '2026-01-15 22:00:00', '2026-01-17 22:00:00', '{\"DEPT-ORTHO\": {\"allocation_date\": \"2026-01-18 22:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(82, 'Server Switch', '2025-02-06 10:00:00', '2025-02-13 10:00:00', '{\"DEPT-PED\": {\"allocation_date\": \"2025-02-18 10:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(83, 'Printer', '2025-09-14 04:00:00', '2025-09-22 04:00:00', '{\"DEPT-CARD\": {\"allocation_date\": \"2025-09-26 04:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(84, 'Printer', '2025-12-03 16:00:00', '2025-12-06 16:00:00', '{\"DEPT-ER\": {\"allocation_date\": \"2025-12-11 16:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(85, 'Patient Monitor', '2025-04-13 05:00:00', '2025-04-20 05:00:00', '{\"DEPT-CARD\": {\"allocation_date\": \"2025-04-24 05:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(86, 'Ventilator', '2025-10-30 21:00:00', '2025-11-06 21:00:00', '{}'),
(87, 'ECG Machine', '2025-06-08 07:00:00', '2025-06-18 07:00:00', '{}'),
(88, 'USG Machine', '2025-07-02 12:00:00', '2025-07-12 12:00:00', '{\"DEPT-ICU\": {\"allocation_date\": \"2025-07-15 12:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(89, 'Printer', '2025-10-24 21:00:00', '2025-10-27 21:00:00', '{\"DEPT-OT\": {\"allocation_date\": \"2025-10-28 21:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(90, 'Billing Workstation', '2025-03-31 15:00:00', '2025-04-09 15:00:00', '{\"DEPT-OT\": {\"allocation_date\": \"2025-04-14 15:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(91, 'USG Machine', '2025-02-24 11:00:00', '2025-02-26 11:00:00', '{\"DEPT-CARD\": {\"allocation_date\": \"2025-03-03 11:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(92, 'X-RAY Machine', '2025-06-01 08:00:00', '2025-06-05 08:00:00', '{}'),
(93, 'Billing Workstation', '2025-10-31 07:00:00', '2025-11-04 07:00:00', '{\"DEPT-ER\": {\"allocation_date\": \"2025-11-07 07:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(94, 'Ventilator', '2025-01-16 10:00:00', '2025-01-25 10:00:00', '{\"DEPT-ICU\": {\"allocation_date\": \"2025-01-30 10:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(95, 'Patient Monitor', '2025-08-27 04:00:00', '2025-09-06 04:00:00', '{\"DEPT-ORTHO\": {\"allocation_date\": \"2025-09-09 04:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(96, 'Server Switch', '2025-01-15 15:00:00', '2025-01-21 15:00:00', '{\"DEPT-NEURO\": {\"allocation_date\": \"2025-01-26 15:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(97, 'USG Machine', '2025-09-14 01:00:00', '2025-09-19 01:00:00', '{\"DEPT-CARD\": {\"allocation_date\": \"2025-09-20 01:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(98, 'Patient Monitor', '2025-07-05 05:00:00', '2025-07-10 05:00:00', '{\"DEPT-RAD\": {\"allocation_date\": \"2025-07-12 05:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(99, 'Patient Monitor', '2025-12-31 17:00:00', '2026-01-02 17:00:00', '{\"DEPT-OT\": {\"allocation_date\": \"2026-01-07 17:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(100, 'X-RAY Machine', '2026-01-20 23:00:00', '2026-01-25 23:00:00', '{}'),
(101, 'Ventilator', '2025-10-21 23:00:00', '2025-10-23 23:00:00', '{\"DEPT-ER\": {\"allocation_date\": \"2025-10-25 23:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(102, 'Ventilator', '2025-10-02 19:00:00', '2025-10-06 19:00:00', '{\"DEPT-PHARM\": {\"allocation_date\": \"2025-10-09 19:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(103, 'ECG Machine', '2025-09-09 10:00:00', '2025-09-16 10:00:00', '{\"DEPT-OT\": {\"allocation_date\": \"2025-09-18 10:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(104, 'Printer', '2025-08-03 20:00:00', '2025-08-13 20:00:00', '{\"DEPT-NEURO\": {\"allocation_date\": \"2025-08-14 20:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(105, 'X-RAY Machine', '2025-08-11 21:00:00', '2025-08-15 21:00:00', '{\"DEPT-ER\": {\"allocation_date\": \"2025-08-20 21:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(106, 'Ventilator', '2025-11-18 17:00:00', '2025-11-25 17:00:00', '{\"DEPT-PHARM\": {\"allocation_date\": \"2025-11-29 17:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(107, 'Patient Monitor', '2025-04-22 06:00:00', '2025-04-24 06:00:00', '{\"DEPT-ICU\": {\"allocation_date\": \"2025-04-29 06:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(108, 'Printer', '2025-02-10 11:00:00', '2025-02-18 11:00:00', '{\"DEPT-ER\": {\"allocation_date\": \"2025-02-20 11:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(109, 'ECG Machine', '2025-09-09 04:00:00', '2025-09-14 04:00:00', '{\"DEPT-PHARM\": {\"allocation_date\": \"2025-09-15 04:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(110, 'Patient Monitor', '2025-11-20 20:00:00', '2025-11-30 20:00:00', '{\"DEPT-OT\": {\"allocation_date\": \"2025-12-05 20:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(111, 'ECG Machine', '2025-10-17 18:00:00', '2025-10-27 18:00:00', '{\"DEPT-CARD\": {\"allocation_date\": \"2025-10-30 18:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(112, 'Patient Monitor', '2025-02-13 08:00:00', '2025-02-16 08:00:00', '{\"DEPT-ER\": {\"allocation_date\": \"2025-02-21 08:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(113, 'Defibrillator', '2026-01-30 19:00:00', '2026-02-02 19:00:00', '{\"DEPT-OT\": {\"allocation_date\": \"2026-02-07 19:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(114, 'USG Machine', '2025-08-26 06:00:00', '2025-08-29 06:00:00', '{\"DEPT-ORTHO\": {\"allocation_date\": \"2025-08-31 06:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(115, 'Billing Workstation', '2025-07-28 07:00:00', '2025-07-30 07:00:00', '{\"DEPT-ER\": {\"allocation_date\": \"2025-07-31 07:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(116, 'Billing Workstation', '2025-08-12 02:00:00', '2025-08-17 02:00:00', '{\"DEPT-OT\": {\"allocation_date\": \"2025-08-22 02:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(117, 'Server Switch', '2026-01-05 18:00:00', '2026-01-14 18:00:00', '{}'),
(118, 'Ventilator', '2025-12-17 05:00:00', '2025-12-20 05:00:00', '{\"DEPT-PED\": {\"allocation_date\": \"2025-12-21 05:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(119, 'ECG Machine', '2025-11-13 23:00:00', '2025-11-22 23:00:00', '{\"DEPT-PHARM\": {\"allocation_date\": \"2025-11-27 23:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(120, 'Server Switch', '2025-10-24 16:00:00', '2025-10-27 16:00:00', '{\"DEPT-RAD\": {\"allocation_date\": \"2025-10-28 16:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(121, 'Ventilator', '2025-10-18 09:00:00', '2025-10-24 09:00:00', '{}'),
(122, 'ECG Machine', '2026-01-16 14:00:00', '2026-01-18 14:00:00', '{\"DEPT-RAD\": {\"allocation_date\": \"2026-01-20 14:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(123, 'Ventilator', '2025-12-14 13:00:00', '2025-12-23 13:00:00', '{\"DEPT-ORTHO\": {\"allocation_date\": \"2025-12-26 13:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(124, 'Server Switch', '2025-11-24 07:00:00', '2025-11-28 07:00:00', '{\"DEPT-OT\": {\"allocation_date\": \"2025-11-29 07:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(125, 'Defibrillator', '2025-03-03 19:00:00', '2025-03-09 19:00:00', '{\"DEPT-ICU\": {\"allocation_date\": \"2025-03-14 19:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}'),
(126, 'Billing Workstation', '2025-12-25 23:00:00', '2025-12-27 23:00:00', '{\"DEPT-ICU\": {\"allocation_date\": \"2026-01-01 23:00:00\", \"revoke_date\": \"nan\", \"discarded_date\": \"nan\"}}');

-- --------------------------------------------------------

--
-- Table structure for table `asset_report`
--

CREATE TABLE `asset_report` (
  `report_id` int(11) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `asset_name` varchar(255) NOT NULL,
  `urgency_level` varchar(20) NOT NULL,
  `department` varchar(100) NOT NULL,
  `floor` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `parts_required` char(1) DEFAULT 'n',
  `photos` text DEFAULT NULL,
  `checked` int(1) DEFAULT 0,
  `report_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `verified_date` datetime DEFAULT NULL,
  `forwarded_date` datetime DEFAULT NULL,
  `resolved_date` datetime DEFAULT NULL,
  `approved_date` varchar(50) DEFAULT 'nan',
  `disapprove_date` varchar(50) DEFAULT 'nan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `asset_report`
--

INSERT INTO `asset_report` (`report_id`, `user_id`, `asset_name`, `urgency_level`, `department`, `floor`, `description`, `parts_required`, `photos`, `checked`, `report_date`, `verified_date`, `forwarded_date`, `resolved_date`, `approved_date`, `disapprove_date`) VALUES
(1, 'GIMSH2618', 'printer', 'medium', 'werw4tt', 'teegeg', 'tgeegege', 'y', '[\"asset_69d3814d2933e_1775468877.avif\"]', 2, '2026-04-06 09:47:57', '2026-04-06 15:24:49', '2026-04-06 15:25:31', '2026-04-06 15:25:20', 'nan', 'nan'),
(2, 'GIMSH2618', 'printer', 'medium', 'eeeg', 'egeeetetg', 'etyetet', 'y', '[\"asset_69d387d46eff8_1775470548.jpg\"]', 1, '2026-04-06 10:15:48', '2026-04-06 15:46:15', '2026-04-06 11:03:52', NULL, 'nan', 'nan'),
(3, 'GIMSH2618', 'Switch', 'medium', 'ykk', 'iyik', 'kiii', 'n', '[\"asset_69d38844a6b84_1775470660.avif\"]', 1, '2026-04-06 10:17:40', '2026-04-07 12:44:45', '2026-04-06 15:48:15', '0000-00-00 00:00:00', 'nan', 'nan'),
(4, 'GIMSH2618', 'Monitor', 'low', 'Academy', '1st academy building', 'wrwtftgetgt', 'n', '[\"asset_69d4b0cff194c_1775546575.avif\"]', 0, '2026-04-07 07:22:55', NULL, '2026-04-07 12:53:12', NULL, '2026-04-14 10:50:54', 'nan'),
(5, 'GIMSH2618', 'Switch', 'medium', 'rrhh', 'rhhrfyh', 'rfhjhfyjfy', 'n', '[\"asset_69d4d131ed901_1775554865.avif\"]', 0, '2026-04-07 09:41:05', NULL, '2026-04-07 15:11:17', NULL, '2026-04-14 10:50:54', 'nan'),
(6, 'GIMSH2618', 'printer', 'high', 'Intensive Care Unit', '4th', 'ffsfvgdfgge', 'y', '[\"asset_69d4e9b493865_1775561140.jpg\"]', 0, '2026-04-07 11:25:40', '2026-04-13 12:24:32', NULL, NULL, 'nan', 'nan'),
(7, 'GIMSH2618', 'Switch', 'medium', 'Operation Theater', '1st', 'tget', 'n', '[\"asset_69d5e1df95f45_1775624671.avif\"]', 1, '2026-04-08 05:04:31', '2026-04-08 10:34:40', NULL, NULL, 'nan', 'nan'),
(8, '1000', 'printer', 'low', 'Pharmacy', '3rd', 'none', 'n', '[\"asset_69d5ee2950ce2_1775627817.jpg\"]', 0, '2026-04-08 05:56:57', NULL, '2026-04-08 11:27:20', NULL, '2026-04-14 10:50:53', 'nan'),
(9, 'GIMSH2618', 'KEYBOARD (840755)', 'low', 'Intensive Care Unit', '1st', 'Not working, need a replacement. ', 'y', '[]', 0, '2026-04-15 04:01:52', NULL, NULL, NULL, 'nan', 'nan'),
(10, '2222', 'Billing Device ', 'high', 'Pharmacy', 'Ground Floor', 'The current device is not working as it intended to.', 'n', '[]', 2, '2026-04-15 04:12:42', '2026-04-15 10:27:12', NULL, '2026-06-27 16:22:42', 'nan', 'nan'),
(11, 'GIMSH2618', 'Monitor (656361)', 'medium', 'Cardiology', '1st', 'Need a new power adapter', 'y', '[]', 2, '2026-06-27 11:13:29', '2026-06-27 16:44:01', NULL, '2026-06-27 16:44:03', 'nan', 'nan'),
(12, 'GIMSH2618', 'Monitor (656361)', 'medium', 'Cardiology', '1st', 'none', 'y', '[]', 0, '2026-06-27 11:16:20', NULL, NULL, NULL, 'nan', 'nan'),
(13, 'GIMSH2618', 'KEYBOARD (840755)', 'high', 'Cardiology', 'csfvv', 'fsefsf', 'n', '[]', 2, '2026-07-01 10:09:47', '2026-07-01 15:40:07', NULL, '2026-07-01 15:40:08', 'nan', 'nan'),
(14, 'GIMSH2618', 'KEYBOARD (840755)', 'critical', 'Cardiology', 'sfxd', 'svdxvsxf', 'n', '[]', 2, '2026-07-01 10:10:25', '2026-07-01 15:41:23', '2026-07-01 15:40:46', '2026-07-01 15:41:23', 'nan', 'nan'),
(15, 'GIMSH2618', 'Patient Monitor (3685175)', 'medium', 'Cardiology', 'czdc', 'dad', 'n', '[]', 2, '2026-07-01 11:31:47', '2026-07-01 17:01:57', NULL, '2026-07-01 17:01:57', 'nan', 'nan'),
(16, 'GIMSH2618', 'Patient Monitor (3685175)', 'low', 'Cardiology', 'fsv', 'fvsfsfcsf', 'n', '[]', 2, '2026-07-01 11:32:16', '2026-07-01 17:02:22', NULL, '2026-07-01 17:02:23', 'nan', 'nan'),
(17, 'EMP-102', 'Ventilator (SN-818742-97)', 'low', 'DEPT-ORTHO', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-02-25 01:30:00', '2026-02-25 09:00:00', NULL, '2026-02-26 22:00:00', '2026-02-27 10:00:00', 'nan'),
(18, '2222', 'Ventilator (SN-818742-97)', 'critical', 'DEPT-ORTHO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'y', '[]', 0, '2026-02-12 05:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(19, '1000', 'Printer (SN-158640-38)', 'critical', 'DEPT-ICU', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-12-30 01:30:00', '2025-12-30 10:00:00', NULL, '2025-12-30 18:00:00', '2025-12-30 23:00:00', 'nan'),
(20, '3333', 'Server Switch (SN-656572-98)', 'critical', 'DEPT-OT', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2026-01-14 23:30:00', '2026-01-15 09:00:00', '2026-01-15 11:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(21, 'GIMSH2618', 'USG Machine (SN-344223-14)', 'low', 'DEPT-ORTHO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2025-11-04 18:30:00', '2025-11-05 03:00:00', '2025-11-05 12:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(22, 'EMP-102', 'Billing Workstation (SN-954437-23)', 'critical', 'DEPT-ORTHO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-02-16 22:30:00', '2026-02-17 06:00:00', NULL, '2026-02-18 17:00:00', '2026-02-19 01:00:00', 'nan'),
(23, 'EMP-101', 'USG Machine (SN-538187-62)', 'high', 'DEPT-ICU', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2025-07-27 13:30:00', '2025-07-27 23:00:00', '2025-07-28 02:00:00', '2025-08-01 11:00:00', '2025-08-01 20:00:00', 'nan'),
(24, '2222', 'ECG Machine (SN-360324-96)', 'critical', 'DEPT-RAD', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-02-10 16:30:00', '2026-02-10 23:00:00', NULL, '2026-02-12 22:00:00', '2026-02-13 08:00:00', 'nan'),
(25, 'EMP-101', 'USG Machine (SN-344223-14)', 'low', 'DEPT-ORTHO', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-03-14 05:30:00', '2026-03-14 15:00:00', NULL, '2026-03-16 07:00:00', '2026-03-16 17:00:00', 'nan'),
(26, '2222', 'Defibrillator (SN-153048-49)', 'critical', 'DEPT-ORTHO', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-04-12 16:30:00', '2026-04-13 00:00:00', NULL, '2026-04-13 03:00:00', '2026-04-13 11:00:00', 'nan'),
(27, '1000', 'Billing Workstation (SN-853350-90)', 'high', 'DEPT-OT', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2025-12-08 14:30:00', '2025-12-08 23:00:00', '2025-12-09 06:00:00', '2025-12-13 21:00:00', '2025-12-14 01:00:00', 'nan'),
(28, '2222', 'Defibrillator (SN-293760-43)', 'low', 'DEPT-RAD', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-09-14 23:30:00', '2025-09-15 07:00:00', NULL, '2025-09-16 01:00:00', '2025-09-16 06:00:00', 'nan'),
(29, '2222', 'Defibrillator (SN-652687-99)', 'critical', 'DEPT-ICU', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-09-20 16:30:00', '2025-09-20 23:00:00', NULL, '2025-09-22 20:00:00', '2025-09-23 05:00:00', 'nan'),
(30, '3333', 'Ventilator (SN-148412-68)', 'low', 'DEPT-ICU', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2025-08-07 00:30:00', '2025-08-07 09:00:00', '2025-08-07 13:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(31, 'EMP-101', 'Ventilator (SN-980849-34)', 'medium', 'DEPT-PED', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2025-05-31 14:30:00', '2025-05-31 23:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(32, '2222', 'X-RAY Machine (SN-319026-79)', 'critical', 'DEPT-ER', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2026-03-30 03:30:00', '2026-03-30 13:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(33, '1000', 'USG Machine (SN-497674-39)', 'high', 'DEPT-ICU', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-03-26 23:30:00', '2026-03-27 07:00:00', NULL, '2026-03-27 14:00:00', '2026-03-28 01:00:00', 'nan'),
(34, '1000', 'Billing Workstation (SN-853350-90)', 'medium', 'DEPT-OT', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-08-18 22:30:00', '2025-08-19 07:00:00', NULL, '2025-08-20 08:00:00', '2025-08-20 17:00:00', 'nan'),
(35, '3333', 'USG Machine (SN-538187-62)', 'low', 'DEPT-ICU', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-11-16 04:30:00', '2025-11-16 13:00:00', NULL, '2025-11-16 23:00:00', '2025-11-17 09:00:00', 'nan'),
(36, '2222', 'Server Switch (SN-714048-7)', 'medium', 'DEPT-ORTHO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-09-29 13:30:00', '2025-09-29 23:00:00', NULL, '2025-10-01 02:00:00', '2025-10-01 08:00:00', 'nan'),
(37, '2222', 'ECG Machine (SN-859424-77)', 'medium', 'DEPT-OT', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2026-02-10 05:30:00', '2026-02-10 12:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(38, 'EMP-101', 'Ventilator (SN-386136-18)', 'low', 'DEPT-NEURO', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-12-14 18:30:00', '2025-12-15 02:00:00', NULL, '2025-12-15 19:00:00', '2025-12-16 06:00:00', 'nan'),
(39, '1000', 'Ventilator (SN-278123-15)', 'medium', 'DEPT-ORTHO', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-02-25 14:30:00', '2026-02-26 00:00:00', '2026-02-26 07:00:00', '2026-03-04 02:00:00', '2026-03-04 13:00:00', 'nan'),
(40, 'EMP-102', 'Billing Workstation (SN-416789-67)', 'critical', 'DEPT-ER', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2025-11-26 16:30:00', '2025-11-27 01:00:00', '2025-11-27 06:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(41, 'GIMSH2618', 'Server Switch (SN-534566-70)', 'low', 'DEPT-NEURO', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-02-08 17:30:00', '2026-02-09 03:00:00', '2026-02-09 08:00:00', '2026-02-15 01:00:00', '2026-02-15 13:00:00', 'nan'),
(42, '2222', 'Defibrillator (SN-153048-49)', 'critical', 'DEPT-ORTHO', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-04-12 16:30:00', '2026-04-13 01:00:00', NULL, '2026-04-14 01:00:00', '2026-04-14 02:00:00', 'nan'),
(43, '2222', 'Billing Workstation (SN-380045-17)', 'medium', 'DEPT-ER', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-12-07 11:30:00', '2025-12-07 18:00:00', NULL, '2025-12-09 02:00:00', '2025-12-09 05:00:00', 'nan'),
(44, '2222', 'Ventilator (SN-278123-15)', 'critical', 'DEPT-ORTHO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'y', '[]', 0, '2026-01-18 06:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(45, 'EMP-101', 'Ventilator (SN-980849-34)', 'low', 'DEPT-PED', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-08-18 00:30:00', '2025-08-18 08:00:00', NULL, '2025-08-18 09:00:00', '2025-08-18 17:00:00', 'nan'),
(46, '1000', 'Patient Monitor (SN-171731-69)', 'high', 'DEPT-ORTHO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-03-04 21:30:00', '2026-03-05 05:00:00', '2026-03-05 13:00:00', '2026-03-11 23:00:00', '2026-03-12 00:00:00', 'nan'),
(47, 'EMP-102', 'Patient Monitor (SN-171731-69)', 'high', 'DEPT-ORTHO', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2026-02-03 10:30:00', '2026-02-03 19:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(48, '3333', 'ECG Machine (SN-149277-85)', 'critical', 'DEPT-CARD', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2026-04-09 18:30:00', '2026-04-10 02:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(49, 'GIMSH2618', 'Billing Workstation (SN-767826-64)', 'low', 'DEPT-OT', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2025-10-21 19:30:00', '2025-10-22 03:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(50, 'EMP-102', 'Ventilator (SN-362221-92)', 'high', 'DEPT-PED', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-01-27 01:30:00', '2026-01-27 10:00:00', '2026-01-27 16:00:00', '2026-01-31 17:00:00', '2026-01-31 20:00:00', 'nan'),
(51, '3333', 'Patient Monitor (SN-226375-11)', 'critical', 'DEPT-ORTHO', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-11-23 13:30:00', '2025-11-23 22:00:00', NULL, '2025-11-24 05:00:00', '2025-11-24 08:00:00', 'nan'),
(52, 'GIMSH2618', 'Ventilator (SN-980849-34)', 'low', 'DEPT-PED', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2026-02-23 10:30:00', '2026-02-23 17:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(53, '3333', 'Defibrillator (SN-652687-99)', 'critical', 'DEPT-ICU', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-01-10 14:30:00', '2026-01-10 23:00:00', '2026-01-11 02:00:00', '2026-01-14 21:00:00', '2026-01-15 06:00:00', 'nan'),
(54, '3333', 'ECG Machine (SN-113057-93)', 'low', 'DEPT-PHARM', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-12-12 05:30:00', '2025-12-12 15:00:00', NULL, '2025-12-13 18:00:00', '2025-12-14 00:00:00', 'nan'),
(55, '1000', 'Printer (SN-914037-82)', 'medium', 'DEPT-ER', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2025-05-27 13:30:00', '2025-05-27 21:00:00', '2025-05-28 00:00:00', '2025-06-02 00:00:00', '2025-06-02 10:00:00', 'nan'),
(56, '3333', 'USG Machine (SN-538187-62)', 'high', 'DEPT-ICU', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-07-19 13:30:00', '2025-07-19 22:00:00', NULL, '2025-07-20 20:00:00', '2025-07-20 21:00:00', 'nan'),
(57, '2222', 'Billing Workstation (SN-570333-89)', 'high', 'DEPT-ER', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-02-03 22:30:00', '2026-02-04 06:00:00', '2026-02-04 16:00:00', '2026-02-10 09:00:00', '2026-02-10 19:00:00', 'nan'),
(58, '1000', 'ECG Machine (SN-149277-85)', 'high', 'DEPT-CARD', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-03-10 03:30:00', '2026-03-10 11:00:00', NULL, '2026-03-11 08:00:00', '2026-03-11 14:00:00', 'nan'),
(59, 'GIMSH2618', 'Ventilator (SN-980849-34)', 'high', 'DEPT-PED', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'n', '[]', 0, '2026-03-22 07:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(60, 'EMP-101', 'X-RAY Machine (SN-634763-21)', 'medium', 'DEPT-NEURO', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-01-28 05:30:00', '2026-01-28 15:00:00', NULL, '2026-01-29 20:00:00', '2026-01-29 21:00:00', 'nan'),
(61, 'EMP-101', 'X-RAY Machine (SN-243553-22)', 'high', 'DEPT-ORTHO', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'y', '[]', 0, '2026-04-04 06:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(62, '1000', 'Patient Monitor (SN-207413-12)', 'medium', 'DEPT-ICU', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-01-31 13:30:00', '2026-01-31 23:00:00', '2026-02-01 01:00:00', '2026-02-04 07:00:00', '2026-02-04 15:00:00', 'nan'),
(63, 'GIMSH2618', 'Billing Workstation (SN-570333-89)', 'low', 'DEPT-ER', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-01-10 15:30:00', '2026-01-10 23:00:00', NULL, '2026-01-11 23:00:00', '2026-01-12 04:00:00', 'nan'),
(64, '3333', 'Server Switch (SN-207598-40)', 'critical', 'DEPT-RAD', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-11-09 14:30:00', '2025-11-09 23:00:00', NULL, '2025-11-11 19:00:00', '2025-11-12 04:00:00', 'nan'),
(65, 'EMP-102', 'Ventilator (SN-980849-34)', 'low', 'DEPT-PED', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-11-11 17:30:00', '2025-11-12 00:00:00', NULL, '2025-11-12 23:00:00', '2025-11-13 07:00:00', 'nan'),
(66, '2222', 'Defibrillator (SN-302132-27)', 'critical', 'DEPT-OT', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'n', '[]', 0, '2025-08-02 18:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(67, '2222', 'Billing Workstation (SN-570333-89)', 'medium', 'DEPT-ER', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-08-04 05:30:00', '2025-08-04 12:00:00', NULL, '2025-08-04 14:00:00', '2025-08-04 22:00:00', 'nan'),
(68, 'EMP-101', 'Server Switch (SN-480648-9)', 'high', 'DEPT-ER', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2026-02-09 00:30:00', '2026-02-09 09:00:00', '2026-02-09 14:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(69, '1000', 'X-RAY Machine (SN-319026-79)', 'high', 'DEPT-ER', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-12-31 17:30:00', '2026-01-01 00:00:00', NULL, '2026-01-02 07:00:00', '2026-01-02 12:00:00', 'nan'),
(70, '3333', 'Server Switch (SN-656572-98)', 'medium', 'DEPT-OT', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2025-12-12 17:30:00', '2025-12-13 00:00:00', '2025-12-13 07:00:00', '2025-12-19 21:00:00', '2025-12-19 22:00:00', 'nan'),
(71, 'EMP-102', 'Ventilator (SN-868685-80)', 'medium', 'DEPT-PHARM', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-03-17 10:30:00', '2026-03-17 17:00:00', NULL, '2026-03-19 00:00:00', '2026-03-19 07:00:00', 'nan'),
(72, 'EMP-102', 'Patient Monitor (SN-226375-11)', 'critical', 'DEPT-ORTHO', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'y', '[]', 0, '2026-03-19 09:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(73, 'EMP-101', 'Patient Monitor (SN-226375-11)', 'medium', 'DEPT-ORTHO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-01-24 07:30:00', '2026-01-24 17:00:00', NULL, '2026-01-25 03:00:00', '2026-01-25 05:00:00', 'nan'),
(74, '3333', 'Defibrillator (SN-852154-36)', 'critical', 'DEPT-PHARM', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-11-26 23:30:00', '2025-11-27 07:00:00', NULL, '2025-11-28 08:00:00', '2025-11-28 17:00:00', 'nan'),
(75, '2222', 'ECG Machine (SN-797217-13)', 'critical', 'DEPT-RAD', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2026-04-13 10:30:00', '2026-04-13 18:00:00', '2026-04-13 23:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(76, '1000', 'Printer (SN-970870-57)', 'critical', 'DEPT-CARD', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'n', '[]', 0, '2026-01-01 06:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(77, '1000', 'Printer (SN-941939-58)', 'low', 'DEPT-ER', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'n', '[]', 0, '2025-12-13 02:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(78, '1000', 'Patient Monitor (SN-207413-12)', 'medium', 'DEPT-ICU', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2025-07-30 16:30:00', '2025-07-31 00:00:00', '2025-07-31 06:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(79, 'EMP-102', 'Billing Workstation (SN-416789-67)', 'high', 'DEPT-ER', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-01-17 09:30:00', '2026-01-17 18:00:00', NULL, '2026-01-18 22:00:00', '2026-01-19 03:00:00', 'nan'),
(80, 'EMP-101', 'X-RAY Machine (SN-495374-19)', 'critical', 'DEPT-NEURO', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-03-24 15:30:00', '2026-03-24 22:00:00', NULL, '2026-03-25 16:00:00', '2026-03-25 18:00:00', 'nan'),
(81, '2222', 'USG Machine (SN-344223-14)', 'critical', 'DEPT-ORTHO', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-01-17 22:30:00', '2026-01-18 05:00:00', '2026-01-18 11:00:00', '2026-01-22 19:00:00', '2026-01-22 20:00:00', 'nan'),
(82, '3333', 'Ventilator (SN-862750-35)', 'low', 'DEPT-RAD', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-04-07 16:30:00', '2026-04-08 01:00:00', '2026-04-08 06:00:00', '2026-04-12 10:00:00', '2026-04-12 12:00:00', 'nan'),
(83, 'EMP-102', 'Ventilator (SN-980849-34)', 'low', 'DEPT-PED', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2025-12-26 20:30:00', '2025-12-27 04:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(84, '1000', 'Server Switch (SN-792116-56)', 'high', 'DEPT-PED', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2025-10-01 06:30:00', '2025-10-01 13:00:00', '2025-10-01 19:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(85, '2222', 'Patient Monitor (SN-350408-84)', 'critical', 'DEPT-OT', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'y', '[]', 0, '2026-02-07 17:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(86, '3333', 'Ventilator (SN-316884-45)', 'low', 'DEPT-NEURO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-03-07 22:30:00', '2026-03-08 08:00:00', '2026-03-08 13:00:00', '2026-03-15 03:00:00', '2026-03-15 15:00:00', 'nan'),
(87, '2222', 'USG Machine (SN-786181-42)', 'medium', 'DEPT-NEURO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2025-10-16 18:30:00', '2025-10-17 01:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(88, 'EMP-101', 'Ventilator (SN-807099-75)', 'low', 'DEPT-ER', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2026-03-28 04:30:00', '2026-03-28 12:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(89, '1000', 'USG Machine (SN-497674-39)', 'high', 'DEPT-ICU', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-02-02 18:30:00', '2026-02-03 04:00:00', NULL, '2026-02-04 23:00:00', '2026-02-05 07:00:00', 'nan'),
(90, 'GIMSH2618', 'Ventilator (SN-148412-68)', 'low', 'DEPT-ICU', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'n', '[]', 0, '2025-11-06 20:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(91, 'EMP-102', 'Ventilator (SN-953591-25)', 'medium', 'DEPT-ER', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-02-13 16:30:00', '2026-02-13 23:00:00', '2026-02-14 10:00:00', '2026-02-18 00:00:00', '2026-02-18 07:00:00', 'nan'),
(92, 'EMP-101', 'Printer (SN-970870-57)', 'critical', 'DEPT-CARD', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-01-04 01:30:00', '2026-01-04 10:00:00', NULL, '2026-01-05 04:00:00', '2026-01-05 13:00:00', 'nan'),
(93, 'GIMSH2618', 'Ventilator (SN-818742-97)', 'medium', 'DEPT-ORTHO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-03-20 19:30:00', '2026-03-21 02:00:00', NULL, '2026-03-21 13:00:00', '2026-03-21 16:00:00', 'nan'),
(94, '1000', 'Patient Monitor (SN-587912-86)', 'low', 'DEPT-ER', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-04-29 14:30:00', '2025-04-30 00:00:00', NULL, '2025-04-30 11:00:00', '2025-04-30 23:00:00', 'nan'),
(95, 'EMP-101', 'Billing Workstation (SN-705876-46)', 'medium', 'DEPT-NEURO', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'n', '[]', 0, '2025-07-27 14:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(96, '1000', 'Ventilator (SN-434614-32)', 'medium', 'DEPT-CARD', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2025-06-24 04:30:00', '2025-06-24 14:00:00', '2025-06-24 20:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(97, 'EMP-101', 'ECG Machine (SN-797217-13)', 'high', 'DEPT-RAD', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2026-04-08 15:30:00', '2026-04-09 01:00:00', '2026-04-09 05:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(98, 'EMP-102', 'USG Machine (SN-497674-39)', 'critical', 'DEPT-ICU', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2026-02-28 08:30:00', '2026-02-28 17:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(99, '2222', 'ECG Machine (SN-360324-96)', 'high', 'DEPT-RAD', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'y', '[]', 0, '2026-02-02 09:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(100, 'EMP-102', 'Printer (SN-941939-58)', 'medium', 'DEPT-ER', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-03-13 09:30:00', '2026-03-13 17:00:00', NULL, '2026-03-14 01:00:00', '2026-03-14 10:00:00', 'nan'),
(101, 'EMP-102', 'Patient Monitor (SN-587912-86)', 'high', 'DEPT-ER', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-02-03 17:30:00', '2026-02-04 00:00:00', NULL, '2026-02-05 01:00:00', '2026-02-05 06:00:00', 'nan'),
(102, '1000', 'X-RAY Machine (SN-495374-19)', 'low', 'DEPT-NEURO', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-11-28 23:30:00', '2025-11-29 09:00:00', NULL, '2025-11-29 21:00:00', '2025-11-30 09:00:00', 'nan'),
(103, 'GIMSH2618', 'Ventilator (SN-362221-92)', 'high', 'DEPT-PED', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2026-02-23 20:30:00', '2026-02-24 04:00:00', '2026-02-24 08:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(104, 'EMP-102', 'X-RAY Machine (SN-319026-79)', 'medium', 'DEPT-ER', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-10-01 11:30:00', '2025-10-01 19:00:00', NULL, '2025-10-03 16:00:00', '2025-10-03 18:00:00', 'nan'),
(105, '3333', 'X-RAY Machine (SN-634763-21)', 'medium', 'DEPT-NEURO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-11-12 17:30:00', '2025-11-13 01:00:00', NULL, '2025-11-13 23:00:00', '2025-11-14 00:00:00', 'nan'),
(106, 'EMP-102', 'Ventilator (SN-557742-55)', 'high', 'DEPT-ORTHO', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-01-18 17:30:00', '2026-01-19 03:00:00', NULL, '2026-01-20 11:00:00', '2026-01-20 15:00:00', 'nan'),
(107, 'GIMSH2618', 'Patient Monitor (SN-773603-44)', 'medium', 'DEPT-ICU', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'n', '[]', 0, '2026-03-25 03:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(108, '1000', 'Billing Workstation (SN-476103-100)', 'critical', 'DEPT-ICU', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-12-28 00:30:00', '2025-12-28 09:00:00', NULL, '2025-12-30 04:00:00', '2025-12-30 05:00:00', 'nan'),
(109, 'GIMSH2618', 'Server Switch (SN-656572-98)', 'critical', 'DEPT-OT', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2026-03-09 10:30:00', '2026-03-09 20:00:00', '2026-03-10 02:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(110, 'EMP-102', 'Server Switch (SN-480648-9)', 'high', 'DEPT-ER', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-02-28 14:30:00', '2026-02-28 21:00:00', NULL, '2026-03-01 13:00:00', '2026-03-01 14:00:00', 'nan'),
(111, '3333', 'Billing Workstation (SN-705876-46)', 'high', 'DEPT-NEURO', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-06-23 21:30:00', '2025-06-24 06:00:00', NULL, '2025-06-24 09:00:00', '2025-06-24 13:00:00', 'nan'),
(112, '2222', 'ECG Machine (SN-497657-8)', 'low', 'DEPT-NEURO', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-02-06 09:30:00', '2026-02-06 18:00:00', '2026-02-06 20:00:00', '2026-02-10 21:00:00', '2026-02-11 03:00:00', 'nan'),
(113, 'GIMSH2618', 'Billing Workstation (SN-380045-17)', 'low', 'DEPT-ER', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-04-01 23:30:00', '2026-04-02 07:00:00', '2026-04-02 17:00:00', '2026-04-07 19:00:00', '2026-04-08 06:00:00', 'nan'),
(114, '3333', 'USG Machine (SN-538187-62)', 'high', 'DEPT-ICU', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2025-09-17 13:30:00', '2025-09-17 20:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(115, 'EMP-101', 'Ventilator (SN-807099-75)', 'critical', 'DEPT-ER', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2026-04-06 13:30:00', '2026-04-06 21:00:00', '2026-04-07 04:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(116, '1000', 'Patient Monitor (SN-338476-73)', 'critical', 'DEPT-OT', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-03-12 15:30:00', '2026-03-12 23:00:00', NULL, '2026-03-14 16:00:00', '2026-03-14 18:00:00', 'nan'),
(117, '3333', 'ECG Machine (SN-302818-83)', 'low', 'DEPT-PHARM', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-10-06 17:30:00', '2025-10-07 03:00:00', NULL, '2025-10-07 23:00:00', '2025-10-08 04:00:00', 'nan'),
(118, '1000', 'Server Switch (SN-792116-56)', 'critical', 'DEPT-PED', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-03-15 19:30:00', '2026-03-16 03:00:00', '2026-03-16 12:00:00', '2026-03-19 06:00:00', '2026-03-19 15:00:00', 'nan'),
(119, 'EMP-102', 'Ventilator (SN-980849-34)', 'critical', 'DEPT-PED', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-01-07 13:30:00', '2026-01-07 20:00:00', NULL, '2026-01-08 18:00:00', '2026-01-08 21:00:00', 'nan'),
(120, 'EMP-101', 'Billing Workstation (SN-104956-6)', 'critical', 'DEPT-NEURO', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2026-01-15 19:30:00', '2026-01-16 03:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(121, '2222', 'Printer (SN-970870-57)', 'high', 'DEPT-CARD', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2025-10-07 05:30:00', '2025-10-07 13:00:00', '2025-10-07 16:00:00', '2025-10-14 08:00:00', '2025-10-14 14:00:00', 'nan'),
(122, '1000', 'Patient Monitor (SN-207413-12)', 'critical', 'DEPT-ICU', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-08-11 13:30:00', '2025-08-11 20:00:00', NULL, '2025-08-13 10:00:00', '2025-08-13 13:00:00', 'nan'),
(123, 'EMP-102', 'Server Switch (SN-792116-56)', 'low', 'DEPT-PED', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-10-09 06:30:00', '2025-10-09 16:00:00', NULL, '2025-10-10 15:00:00', '2025-10-10 16:00:00', 'nan'),
(124, 'GIMSH2618', 'ECG Machine (SN-797217-13)', 'critical', 'DEPT-RAD', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-04-05 06:30:00', '2026-04-05 14:00:00', NULL, '2026-04-07 03:00:00', '2026-04-07 11:00:00', 'nan'),
(125, '2222', 'Patient Monitor (SN-654540-72)', 'high', 'DEPT-RAD', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2025-07-21 21:30:00', '2025-07-22 06:00:00', '2025-07-22 14:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(126, 'EMP-102', 'Printer (SN-418726-50)', 'low', 'DEPT-PED', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2026-02-14 16:30:00', '2026-02-15 01:00:00', '2026-02-15 08:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(127, '3333', 'Printer (SN-970870-57)', 'medium', 'DEPT-CARD', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-12-18 17:30:00', '2025-12-19 03:00:00', NULL, '2025-12-20 15:00:00', '2025-12-20 23:00:00', 'nan'),
(128, 'GIMSH2618', 'USG Machine (SN-497674-39)', 'low', 'DEPT-ICU', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-02-20 12:30:00', '2026-02-20 20:00:00', NULL, '2026-02-20 22:00:00', '2026-02-21 01:00:00', 'nan'),
(129, 'EMP-102', 'Ventilator (SN-980849-34)', 'medium', 'DEPT-PED', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2026-01-26 04:30:00', '2026-01-26 12:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(130, 'EMP-101', 'Billing Workstation (SN-104956-6)', 'low', 'DEPT-NEURO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-07-21 14:30:00', '2025-07-22 00:00:00', NULL, '2025-07-23 03:00:00', '2025-07-23 05:00:00', 'nan'),
(131, 'EMP-101', 'ECG Machine (SN-302818-83)', 'critical', 'DEPT-PHARM', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2026-03-25 16:30:00', '2026-03-25 23:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(132, 'EMP-101', 'Ventilator (SN-980849-34)', 'high', 'DEPT-PED', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2025-10-04 09:30:00', '2025-10-04 18:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(133, 'EMP-101', 'Ventilator (SN-278123-15)', 'low', 'DEPT-ORTHO', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-01-14 14:30:00', '2026-01-14 22:00:00', NULL, '2026-01-16 05:00:00', '2026-01-16 14:00:00', 'nan'),
(134, '1000', 'Patient Monitor (SN-350408-84)', 'critical', 'DEPT-OT', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-02-13 12:30:00', '2026-02-13 22:00:00', '2026-02-14 06:00:00', '2026-02-20 12:00:00', '2026-02-20 17:00:00', 'nan'),
(135, '2222', 'Ventilator (SN-154874-76)', 'critical', 'DEPT-PHARM', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-03-16 00:30:00', '2026-03-16 10:00:00', NULL, '2026-03-18 06:00:00', '2026-03-18 13:00:00', 'nan'),
(136, 'EMP-102', 'Ventilator (SN-278123-15)', 'high', 'DEPT-ORTHO', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2025-05-28 23:30:00', '2025-05-29 07:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(137, '3333', 'Server Switch (SN-555958-30)', 'high', 'DEPT-OT', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'y', '[]', 1, '2025-08-08 11:30:00', '2025-08-08 19:00:00', '2025-08-08 22:00:00', '0000-00-00 00:00:00', 'nan', 'nan'),
(138, '1000', 'Printer (SN-158640-38)', 'critical', 'DEPT-ICU', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2025-11-27 09:30:00', '2025-11-27 18:00:00', '2025-11-28 03:00:00', '2025-12-02 16:00:00', '2025-12-02 22:00:00', 'nan'),
(139, '1000', 'ECG Machine (SN-797217-13)', 'critical', 'DEPT-RAD', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-02-22 16:30:00', '2026-02-23 00:00:00', NULL, '2026-02-24 14:00:00', '2026-02-25 00:00:00', 'nan'),
(140, '3333', 'X-RAY Machine (SN-643956-48)', 'high', 'DEPT-PHARM', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-11-08 11:30:00', '2025-11-08 20:00:00', NULL, '2025-11-09 13:00:00', '2025-11-09 15:00:00', 'nan'),
(141, '3333', 'Printer (SN-877330-78)', 'critical', 'DEPT-NEURO', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-12-07 09:30:00', '2025-12-07 18:00:00', NULL, '2025-12-09 07:00:00', '2025-12-09 09:00:00', 'nan'),
(142, 'GIMSH2618', 'Defibrillator (SN-302132-27)', 'medium', 'DEPT-OT', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-01-31 21:30:00', '2025-02-01 06:00:00', NULL, '2025-02-02 21:00:00', '2025-02-03 02:00:00', 'nan'),
(143, '3333', 'Ventilator (SN-362221-92)', 'critical', 'DEPT-PED', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-03-17 22:30:00', '2026-03-18 05:00:00', NULL, '2026-03-19 02:00:00', '2026-03-19 03:00:00', 'nan'),
(144, 'EMP-102', 'Server Switch (SN-714048-7)', 'high', 'DEPT-ORTHO', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-07-21 02:30:00', '2025-07-21 10:00:00', NULL, '2025-07-22 00:00:00', '2025-07-22 07:00:00', 'nan'),
(145, 'EMP-102', 'Printer (SN-545181-47)', 'low', 'DEPT-ER', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'y', '[]', 0, '2025-02-25 03:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(146, '2222', 'Billing Workstation (SN-380045-17)', 'low', 'DEPT-ER', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'y', '[]', 0, '2026-01-29 13:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(147, 'EMP-102', 'X-RAY Machine (SN-643956-48)', 'high', 'DEPT-PHARM', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-01-02 20:30:00', '2026-01-03 06:00:00', '2026-01-03 08:00:00', '2026-01-07 16:00:00', '2026-01-07 21:00:00', 'nan'),
(148, 'EMP-101', 'Billing Workstation (SN-853350-90)', 'critical', 'DEPT-OT', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-08-18 02:30:00', '2025-08-18 09:00:00', NULL, '2025-08-19 16:00:00', '2025-08-20 04:00:00', 'nan'),
(149, 'EMP-101', 'Server Switch (SN-656572-98)', 'low', 'DEPT-OT', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2026-02-08 21:30:00', '2026-02-09 05:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(150, '3333', 'Ventilator (SN-798107-24)', 'medium', 'DEPT-CARD', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-03-14 18:30:00', '2026-03-15 03:00:00', '2026-03-15 05:00:00', '2026-03-19 23:00:00', '2026-03-20 03:00:00', 'nan'),
(151, 'EMP-102', 'Ventilator (SN-868685-80)', 'critical', 'DEPT-PHARM', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2026-02-24 05:30:00', '2026-02-24 12:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(152, '3333', 'Server Switch (SN-555958-30)', 'medium', 'DEPT-OT', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-03-15 10:30:00', '2026-03-15 19:00:00', '2026-03-16 02:00:00', '2026-03-20 04:00:00', '2026-03-20 08:00:00', 'nan'),
(153, 'GIMSH2618', 'Billing Workstation (SN-570333-89)', 'medium', 'DEPT-ER', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-11-28 06:30:00', '2025-11-28 16:00:00', NULL, '2025-11-28 21:00:00', '2025-11-29 09:00:00', 'nan'),
(154, '1000', 'Billing Workstation (SN-476103-100)', 'high', 'DEPT-ICU', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-01-01 00:30:00', '2026-01-01 09:00:00', NULL, '2026-01-01 12:00:00', '2026-01-01 16:00:00', 'nan'),
(155, 'EMP-102', 'Defibrillator (SN-852154-36)', 'low', 'DEPT-PHARM', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2025-09-28 06:30:00', '2025-09-28 16:00:00', NULL, '2025-09-28 15:00:00', '2025-09-28 21:00:00', 'nan'),
(156, '1000', 'Billing Workstation (SN-954437-23)', 'low', 'DEPT-ORTHO', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-03-28 00:30:00', '2026-03-28 09:00:00', NULL, '2026-03-28 18:00:00', '2026-03-29 06:00:00', 'nan'),
(157, '1000', 'Ventilator (SN-868685-80)', 'high', 'DEPT-PHARM', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-03-12 12:30:00', '2026-03-12 21:00:00', NULL, '2026-03-14 00:00:00', '2026-03-14 03:00:00', 'nan'),
(158, 'EMP-102', 'Ventilator (SN-386136-18)', 'medium', 'DEPT-NEURO', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2025-10-19 06:30:00', '2025-10-19 16:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(159, 'GIMSH2618', 'X-RAY Machine (SN-319026-79)', 'medium', 'DEPT-ER', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'y', '[]', 0, '2026-02-02 13:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(160, 'EMP-102', 'USG Machine (SN-786181-42)', 'low', 'DEPT-NEURO', 'Floor 1', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-04-07 12:30:00', '2026-04-07 22:00:00', NULL, '2026-04-08 05:00:00', '2026-04-08 07:00:00', 'nan'),
(161, '2222', 'X-RAY Machine (SN-495374-19)', 'low', 'DEPT-NEURO', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-02-01 01:30:00', '2026-02-01 11:00:00', NULL, '2026-02-02 09:00:00', '2026-02-02 20:00:00', 'nan'),
(162, '1000', 'X-RAY Machine (SN-643956-48)', 'low', 'DEPT-PHARM', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-01-04 10:30:00', '2026-01-04 19:00:00', '2026-01-05 03:00:00', '2026-01-07 18:00:00', '2026-01-07 20:00:00', 'nan'),
(163, 'EMP-102', 'Server Switch (SN-555958-30)', 'high', 'DEPT-OT', 'Floor 3', 'Routine maintenance issue generated synthetically. Status: 0. Needs attention.', 'y', '[]', 0, '2026-04-13 20:30:00', NULL, NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(164, '3333', 'Billing Workstation (SN-767826-64)', 'medium', 'DEPT-OT', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 1. Needs attention.', 'n', '[]', 1, '2025-08-06 22:30:00', '2025-08-07 05:00:00', NULL, '0000-00-00 00:00:00', 'nan', 'nan'),
(165, '3333', 'Billing Workstation (SN-104956-6)', 'critical', 'DEPT-NEURO', 'Floor 2', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'n', '[]', 2, '2026-01-01 17:30:00', '2026-01-02 03:00:00', NULL, '2026-01-02 05:00:00', '2026-01-02 10:00:00', 'nan'),
(166, 'EMP-101', 'Printer (SN-158640-38)', 'low', 'DEPT-ICU', 'Floor 4', 'Routine maintenance issue generated synthetically. Status: 2. Needs attention.', 'y', '[]', 2, '2026-03-16 19:30:00', '2026-03-17 03:00:00', '2026-03-17 06:00:00', '2026-03-22 13:00:00', '2026-03-23 01:00:00', 'nan');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `dept_id` varchar(50) NOT NULL,
  `dept_name` varchar(255) NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`dept_id`, `dept_name`, `date_created`) VALUES
('DEPT-CARD', 'Cardiology', '2026-04-07 03:55:24'),
('DEPT-ER', 'Emergency Department', '2026-04-07 03:55:24'),
('DEPT-ICU', 'Intensive Care Unit', '2026-04-07 03:55:24'),
('DEPT-NEURO', 'Neurology', '2026-04-07 03:55:24'),
('DEPT-ORTHO', 'Orthopedic Surgery', '2026-04-07 03:55:24'),
('DEPT-OT', 'Operation Theater', '2026-04-07 03:55:24'),
('DEPT-PED', 'Pediatrics', '2026-04-07 03:55:24'),
('DEPT-PHARM', 'Pharmacy', '2026-04-07 03:55:24'),
('DEPT-PRC', 'Purchase', '2026-07-05 08:28:18'),
('DEPT-RAD', 'Radiology', '2026-04-07 03:55:24');

-- --------------------------------------------------------

--
-- Table structure for table `dept_user_queries`
--

CREATE TABLE `dept_user_queries` (
  `conversation_id` int(11) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `dept_id` varchar(100) NOT NULL,
  `user_chat` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`user_chat`)),
  `admin_chat` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`admin_chat`)),
  `status` enum('open','resolved') DEFAULT 'open',
  `created_at` datetime DEFAULT current_timestamp(),
  `last_updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `admin_unread` int(11) DEFAULT 0,
  `user_unread` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dept_user_queries`
--

INSERT INTO `dept_user_queries` (`conversation_id`, `user_id`, `dept_id`, `user_chat`, `admin_chat`, `status`, `created_at`, `last_updated`, `admin_unread`, `user_unread`) VALUES
(1, 'GIMSH2618', 'DEPT-ICU', '[{\"datetime\":\"2026-04-21 14:32:00\",\"message\":\"Need help\"},{\"datetime\":\"2026-04-21 15:32:23\",\"message\":\"Is there anyone?\"},{\"datetime\":\"2026-04-26 11:35:26\",\"message\":\"hhjhjhfjhgy\"},{\"datetime\":\"2026-04-26 12:40:31\",\"message\":\"hello there\"},{\"datetime\":\"2026-04-26 12:40:43\",\"message\":\"I need support\"},{\"datetime\":\"2026-04-26 13:22:52\",\"message\":\"\\ud83d\\ude0e\"},{\"datetime\":\"2026-04-26 16:05:13\",\"message\":\"cfcbhcbh\"}]', '[{\"datetime\":\"2026-04-26 12:40:56\",\"message\":\"Ok what help do you need\"},{\"datetime\":\"2026-04-26 12:41:14\",\"message\":\"give me the details\"},{\"datetime\":\"2026-04-26 16:05:25\",\"message\":\"fghxfgxf\"}]', 'open', '2026-04-21 14:32:00', '2026-04-26 16:05:27', 0, 0),
(2, '2222', 'DEPT-ICU', '[{\"datetime\":\"2026-04-26 12:44:14\",\"message\":\"hello sir there is a machine on my dept, that is not registered but required maintenance\"},{\"datetime\":\"2026-04-26 13:05:32\",\"message\":\"hello sir\"},{\"datetime\":\"2026-04-26 13:07:50\",\"message\":\"hellooo..........\"},{\"datetime\":\"2026-04-26 13:15:06\",\"message\":\".......\"},{\"datetime\":\"2026-04-26 13:15:53\",\"message\":\".................\"},{\"datetime\":\"2026-06-27 16:24:35\",\"message\":\"Hello\"},{\"datetime\":\"2026-06-27 16:25:24\",\"message\":\"Need help with the device installation pls\"}]', '[{\"datetime\":\"2026-06-27 16:24:53\",\"message\":\"What is the issue ?\"}]', 'open', '2026-04-26 12:44:14', '2026-06-27 16:25:25', 0, 0),
(3, '3333', 'DEPT-ORTHO', '[{\"datetime\":\"2026-04-26 15:04:31\",\"message\":\"hello..........\"},{\"datetime\":\"2026-06-27 16:29:18\",\"message\":\"hello\"},{\"datetime\":\"2026-06-27 16:30:45\",\"message\":\"fhhhfhjngvjnfcjnn\"}]', '[]', 'open', '2026-04-26 15:04:31', '2026-06-27 16:30:45', 2, 0),
(4, '1000', 'DEPT-PHARM', '[{\"datetime\":\"2026-06-27 16:26:17\",\"message\":\"Hello sir\"}]', '[]', 'open', '2026-06-27 16:26:17', '2026-06-27 16:31:36', 0, 0),
(5, '9999', 'DEPT-CARD', '[{\"datetime\":\"2026-06-27 16:37:09\",\"message\":\"hello\"}]', '[]', 'open', '2026-06-27 16:37:09', '2026-06-27 16:37:27', 0, 0),
(6, '1478', 'DEPT-PRC', '[{\"datetime\":\"2026-07-05 16:12:04\",\"message\":\"hello\"},{\"datetime\":\"2026-07-05 16:19:23\",\"message\":\"I need and help with auditing some asset, can you provide me with some assistance\"}]', '[{\"datetime\":\"2026-07-05 16:13:51\",\"message\":\"How may I help you\"},{\"datetime\":\"2026-07-05 16:20:45\",\"message\":\"Okay, I will send someone to you \\ud83d\\udc4d\"}]', 'open', '2026-07-05 16:12:04', '2026-07-05 16:20:48', 0, 0),
(7, 'GIMSH2014', 'DEPT-CARD', '[{\"datetime\":\"2026-07-05 16:23:42\",\"message\":\"Hello there\"}]', '[{\"datetime\":\"2026-07-05 16:24:14\",\"message\":\"Yes, How may I help you\"}]', 'open', '2026-07-05 16:23:42', '2026-07-05 16:24:16', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `discarded_items`
--

CREATE TABLE `discarded_items` (
  `discard_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `item_model` varchar(255) NOT NULL,
  `item_manufacturer` varchar(255) NOT NULL,
  `serial_number` varchar(100) NOT NULL,
  `discarded_from_dept` varchar(50) DEFAULT 'NAN',
  `discarded_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `original_added_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `discarded_items`
--

INSERT INTO `discarded_items` (`discard_id`, `item_id`, `item_name`, `item_model`, `item_manufacturer`, `serial_number`, `discarded_from_dept`, `discarded_date`, `original_added_date`) VALUES
(1, 4, 'KEYBOARD', 'KYHJ3467', 'HP', '985755', 'DEPT-PED', '2026-04-07 05:25:23', '2026-04-07 09:13:05'),
(2, 5, 'KEYBOARD', 'KYHJ3468', 'HP', '650755', 'DEPT-ICU', '2026-04-07 05:29:37', '2026-04-07 09:13:05'),
(3, 1, 'Monitor', 'ME3453S', 'ACER', '78762658', 'DEPT-ICU', '2026-04-07 05:39:31', '2026-04-07 09:06:02'),
(4, 13, 'X-RAY Machine', 'XRY MARS', 'ALLENGERS', '2K16050073', 'DEPT-ICU', '2026-04-16 04:31:51', '2026-04-07 09:33:11'),
(5, 9, 'USG Machine', 'USG 150D', 'SYSMAX', '804507', 'DEPT-ER', '2026-04-16 04:53:03', '2026-04-07 09:33:11'),
(6, 2, 'KEYBOARD', 'KYHJ3465', 'HP', '950755', 'DEPT-ER', '2026-04-16 05:03:25', '2026-04-07 09:13:05'),
(7, 14, 'USG Machine', 'USG 150D', 'SYSMAX', '1318225', 'NAN', '2026-04-16 05:10:09', '2026-04-08 11:40:24'),
(8, 6, 'KEYBOARD', 'KYHJ3469', 'HP', '770755', 'DEPT-ER', '2026-04-16 05:16:12', '2026-04-07 09:13:05');

-- --------------------------------------------------------

--
-- Table structure for table `forwarded_items`
--

CREATE TABLE `forwarded_items` (
  `serial_number` varchar(100) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `item_model` varchar(255) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `date_forwarded` timestamp NOT NULL DEFAULT current_timestamp(),
  `forwarded_by_user_id` varchar(50) DEFAULT 'nan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `forwarded_reports`
--

CREATE TABLE `forwarded_reports` (
  `id` int(11) NOT NULL,
  `report_id` int(11) NOT NULL,
  `original_user_id` varchar(50) NOT NULL,
  `admin_id` varchar(50) NOT NULL,
  `forwarded_at` datetime NOT NULL DEFAULT current_timestamp(),
  `approved_date` varchar(50) DEFAULT 'nan',
  `disapprove_date` varchar(50) DEFAULT 'nan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `forwarded_reports`
--

INSERT INTO `forwarded_reports` (`id`, `report_id`, `original_user_id`, `admin_id`, `forwarded_at`, `approved_date`, `disapprove_date`) VALUES
(1, 2, 'GIMSH2618', 'GIMSH2618', '2026-04-06 11:03:52', 'nan', 'nan'),
(2, 7, 'GIMSH2618', 'GIMSH2618', '2026-04-06 14:14:22', 'nan', 'nan'),
(3, 1, 'GIMSH2618', 'GIMSH2618', '2026-04-06 15:25:31', 'nan', 'nan'),
(4, 3, 'GIMSH2618', 'GIMSH2618', '2026-04-06 15:48:15', 'nan', 'nan'),
(5, 4, 'GIMSH2618', 'GIMSH2618', '2026-04-07 12:53:12', '2026-04-14 10:50:54', 'nan'),
(6, 5, 'GIMSH2618', 'GIMSH2618', '2026-04-07 15:11:17', '2026-04-14 10:50:54', 'nan'),
(7, 8, '1000', '1000', '2026-04-08 11:27:20', '2026-04-14 10:50:53', 'nan'),
(8, 14, 'GIMSH2618', 'GIMSH2618', '2026-07-01 15:40:46', 'nan', 'nan');

-- --------------------------------------------------------

--
-- Table structure for table `item_assigneds`
--

CREATE TABLE `item_assigneds` (
  `assign_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `dept_id` varchar(50) NOT NULL,
  `date_assigned` datetime NOT NULL,
  `date_revoked` varchar(50) DEFAULT 'nan',
  `discarded_date` varchar(50) DEFAULT 'nan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `item_assigneds`
--

INSERT INTO `item_assigneds` (`assign_id`, `item_id`, `dept_id`, `date_assigned`, `date_revoked`, `discarded_date`) VALUES
(5, 2, 'DEPT-PED', '2026-04-07 10:44:09', '2026-04-07 10:45:12', 'nan'),
(8, 2, 'DEPT-ORTHO', '2026-04-07 10:53:08', '2026-04-07 10:55:03', 'nan'),
(9, 2, 'DEPT-ICU', '2026-04-07 10:59:01', '2026-04-07 07:29:25', 'nan'),
(12, 2, 'DEPT-NEURO', '2026-04-08 09:19:26', '2026-04-16 05:46:58', 'nan'),
(14, 10, 'DEPT-ER', '2026-04-08 09:48:08', '2026-04-16 05:46:58', 'nan'),
(15, 6, 'DEPT-ICU', '2026-04-13 12:31:07', '2026-04-16 05:46:58', 'nan'),
(16, 7, 'DEPT-ICU', '2026-04-13 12:31:07', '2026-04-16 05:46:58', 'nan'),
(17, 11, 'DEPT-ER', '2026-04-16 09:11:44', '2026-04-16 05:46:58', 'nan'),
(19, 19, 'DEPT-ICU', '2026-04-16 06:01:16', '2026-04-16 06:06:28', 'nan'),
(20, 19, 'DEPT-ICU', '2026-04-16 06:09:13', '2026-04-16 06:23:11', 'nan'),
(21, 19, 'DEPT-ICU', '2026-04-16 09:53:44', '2026-04-16 06:24:26', 'nan'),
(22, 6, 'DEPT-ICU', '2026-04-16 09:55:50', '2026-04-16 06:26:02', 'nan'),
(24, 2, 'DEPT-ER', '2026-04-16 10:07:38', '2026-04-16 06:37:59', 'nan'),
(25, 2, 'DEPT-ER', '2026-04-16 10:11:23', 'nan', '2026-04-16 10:33:25'),
(26, 6, 'DEPT-ER', '2026-04-16 10:11:23', 'nan', '2026-04-16 10:46:12'),
(27, 7, 'DEPT-ER', '2026-04-16 10:11:23', '2026-04-16 10:11:52', 'nan'),
(29, 23, 'DEPT-CARD', '2026-06-27 16:42:16', 'nan', 'nan'),
(30, 24, 'DEPT-CARD', '2026-06-27 16:42:16', 'nan', 'nan'),
(31, 7, 'DEPT-CARD', '2026-07-01 15:17:17', 'nan', 'nan'),
(32, 10, 'DEPT-CARD', '2026-07-01 15:17:17', 'nan', 'nan'),
(33, 11, 'DEPT-CARD', '2026-07-01 15:17:17', 'nan', 'nan'),
(34, 26, 'DEPT-CARD', '2026-07-01 17:01:29', 'nan', 'nan'),
(35, 30, 'DEPT-ER', '2025-03-31 08:00:00', 'nan', 'nan'),
(36, 31, 'DEPT-CARD', '2025-10-16 11:00:00', 'nan', 'nan'),
(37, 32, 'DEPT-NEURO', '2025-06-19 16:00:00', 'nan', 'nan'),
(38, 33, 'DEPT-ORTHO', '2025-01-17 01:00:00', 'nan', 'nan'),
(39, 34, 'DEPT-NEURO', '2025-07-31 21:00:00', 'nan', 'nan'),
(40, 35, 'DEPT-ER', '2026-02-08 05:00:00', 'nan', 'nan'),
(41, 36, 'DEPT-NEURO', '2025-03-08 08:00:00', 'nan', 'nan'),
(42, 37, 'DEPT-ORTHO', '2025-07-08 22:00:00', 'nan', 'nan'),
(43, 38, 'DEPT-ICU', '2025-02-18 13:00:00', 'nan', 'nan'),
(44, 39, 'DEPT-RAD', '2025-03-28 11:00:00', 'nan', 'nan'),
(45, 40, 'DEPT-ORTHO', '2025-09-27 10:00:00', 'nan', 'nan'),
(46, 41, 'DEPT-ORTHO', '2025-03-26 22:00:00', 'nan', 'nan'),
(47, 43, 'DEPT-ER', '2025-12-03 23:00:00', 'nan', 'nan'),
(48, 44, 'DEPT-NEURO', '2025-10-04 18:00:00', 'nan', 'nan'),
(49, 45, 'DEPT-NEURO', '2025-11-01 18:00:00', 'nan', 'nan'),
(50, 46, 'DEPT-PED', '2025-11-19 18:00:00', 'nan', 'nan'),
(51, 47, 'DEPT-NEURO', '2025-02-08 03:00:00', 'nan', 'nan'),
(52, 48, 'DEPT-ORTHO', '2026-02-14 22:00:00', 'nan', 'nan'),
(53, 49, 'DEPT-ORTHO', '2026-02-12 07:00:00', 'nan', 'nan'),
(54, 50, 'DEPT-CARD', '2026-02-10 20:00:00', 'nan', 'nan'),
(55, 51, 'DEPT-ER', '2026-01-27 09:00:00', 'nan', 'nan'),
(56, 53, 'DEPT-OT', '2025-01-22 16:00:00', 'nan', 'nan'),
(57, 56, 'DEPT-OT', '2025-04-30 18:00:00', 'nan', 'nan'),
(58, 58, 'DEPT-CARD', '2025-04-04 01:00:00', 'nan', 'nan'),
(59, 60, 'DEPT-PED', '2025-05-25 08:00:00', 'nan', 'nan'),
(60, 61, 'DEPT-RAD', '2025-05-21 08:00:00', 'nan', 'nan'),
(61, 62, 'DEPT-PHARM', '2025-07-05 21:00:00', 'nan', 'nan'),
(62, 64, 'DEPT-ICU', '2025-09-29 13:00:00', 'nan', 'nan'),
(63, 65, 'DEPT-ICU', '2026-01-26 02:00:00', 'nan', 'nan'),
(64, 66, 'DEPT-RAD', '2025-02-06 10:00:00', 'nan', 'nan'),
(65, 67, 'DEPT-RAD', '2025-07-20 01:00:00', 'nan', 'nan'),
(66, 68, 'DEPT-NEURO', '2025-09-18 14:00:00', 'nan', 'nan'),
(67, 69, 'DEPT-RAD', '2025-03-01 01:00:00', 'nan', 'nan'),
(68, 70, 'DEPT-ICU', '2025-12-17 11:00:00', 'nan', 'nan'),
(69, 71, 'DEPT-NEURO', '2025-10-24 22:00:00', 'nan', 'nan'),
(70, 72, 'DEPT-NEURO', '2025-05-30 21:00:00', 'nan', 'nan'),
(71, 73, 'DEPT-ER', '2025-01-27 18:00:00', 'nan', 'nan'),
(72, 74, 'DEPT-PHARM', '2025-05-08 22:00:00', 'nan', 'nan'),
(73, 75, 'DEPT-ORTHO', '2026-01-31 06:00:00', 'nan', 'nan'),
(74, 76, 'DEPT-PED', '2025-03-16 02:00:00', 'nan', 'nan'),
(75, 78, 'DEPT-OT', '2025-08-31 09:00:00', 'nan', 'nan'),
(76, 80, 'DEPT-CARD', '2025-03-09 19:00:00', 'nan', 'nan'),
(77, 81, 'DEPT-ORTHO', '2026-01-18 22:00:00', 'nan', 'nan'),
(78, 82, 'DEPT-PED', '2025-02-18 10:00:00', 'nan', 'nan'),
(79, 83, 'DEPT-CARD', '2025-09-26 04:00:00', 'nan', 'nan'),
(80, 84, 'DEPT-ER', '2025-12-11 16:00:00', 'nan', 'nan'),
(81, 85, 'DEPT-CARD', '2025-04-24 05:00:00', 'nan', 'nan'),
(82, 88, 'DEPT-ICU', '2025-07-15 12:00:00', 'nan', 'nan'),
(83, 89, 'DEPT-OT', '2025-10-28 21:00:00', 'nan', 'nan'),
(84, 90, 'DEPT-OT', '2025-04-14 15:00:00', 'nan', 'nan'),
(85, 91, 'DEPT-CARD', '2025-03-03 11:00:00', 'nan', 'nan'),
(86, 93, 'DEPT-ER', '2025-11-07 07:00:00', 'nan', 'nan'),
(87, 94, 'DEPT-ICU', '2025-01-30 10:00:00', 'nan', 'nan'),
(88, 95, 'DEPT-ORTHO', '2025-09-09 04:00:00', 'nan', 'nan'),
(89, 96, 'DEPT-NEURO', '2025-01-26 15:00:00', 'nan', 'nan'),
(90, 97, 'DEPT-CARD', '2025-09-20 01:00:00', 'nan', 'nan'),
(91, 98, 'DEPT-RAD', '2025-07-12 05:00:00', 'nan', 'nan'),
(92, 99, 'DEPT-OT', '2026-01-07 17:00:00', 'nan', 'nan'),
(93, 101, 'DEPT-ER', '2025-10-25 23:00:00', 'nan', 'nan'),
(94, 102, 'DEPT-PHARM', '2025-10-09 19:00:00', 'nan', 'nan'),
(95, 103, 'DEPT-OT', '2025-09-18 10:00:00', 'nan', 'nan'),
(96, 104, 'DEPT-NEURO', '2025-08-14 20:00:00', 'nan', 'nan'),
(97, 105, 'DEPT-ER', '2025-08-20 21:00:00', 'nan', 'nan'),
(98, 106, 'DEPT-PHARM', '2025-11-29 17:00:00', 'nan', 'nan'),
(99, 107, 'DEPT-ICU', '2025-04-29 06:00:00', 'nan', 'nan'),
(100, 108, 'DEPT-ER', '2025-02-20 11:00:00', 'nan', 'nan'),
(101, 109, 'DEPT-PHARM', '2025-09-15 04:00:00', 'nan', 'nan'),
(102, 110, 'DEPT-OT', '2025-12-05 20:00:00', 'nan', 'nan'),
(103, 111, 'DEPT-CARD', '2025-10-30 18:00:00', 'nan', 'nan'),
(104, 112, 'DEPT-ER', '2025-02-21 08:00:00', 'nan', 'nan'),
(105, 113, 'DEPT-OT', '2026-02-07 19:00:00', 'nan', 'nan'),
(106, 114, 'DEPT-ORTHO', '2025-08-31 06:00:00', 'nan', 'nan'),
(107, 115, 'DEPT-ER', '2025-07-31 07:00:00', 'nan', 'nan'),
(108, 116, 'DEPT-OT', '2025-08-22 02:00:00', 'nan', 'nan'),
(109, 118, 'DEPT-PED', '2025-12-21 05:00:00', 'nan', 'nan'),
(110, 119, 'DEPT-PHARM', '2025-11-27 23:00:00', 'nan', 'nan'),
(111, 120, 'DEPT-RAD', '2025-10-28 16:00:00', 'nan', 'nan'),
(112, 122, 'DEPT-RAD', '2026-01-20 14:00:00', 'nan', 'nan'),
(113, 123, 'DEPT-ORTHO', '2025-12-26 13:00:00', 'nan', 'nan'),
(114, 124, 'DEPT-OT', '2025-11-29 07:00:00', 'nan', 'nan'),
(115, 125, 'DEPT-ICU', '2025-03-14 19:00:00', 'nan', 'nan'),
(116, 126, 'DEPT-ICU', '2026-01-01 23:00:00', 'nan', 'nan');

-- --------------------------------------------------------

--
-- Table structure for table `item_requests`
--

CREATE TABLE `item_requests` (
  `request_id` int(11) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `description` text DEFAULT NULL,
  `status` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`status`)),
  `request_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `item_table`
--

CREATE TABLE `item_table` (
  `item_id` int(11) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `item_model` varchar(255) NOT NULL,
  `item_manufacturer` varchar(255) NOT NULL,
  `serial_number` varchar(100) NOT NULL,
  `date_added` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `item_table`
--

INSERT INTO `item_table` (`item_id`, `item_name`, `item_model`, `item_manufacturer`, `serial_number`, `date_added`) VALUES
(7, 'KEYBOARD', 'KYHJ3470', 'HP', '840755', '2026-04-07 03:43:05'),
(10, 'X-RAY Machine', 'XRY 325', 'ALLENGERS', '2K16050030', '2026-04-07 04:03:11'),
(11, 'X-RAY Machine', 'XRY 326', 'ALLENGERS', '2K19100246', '2026-04-07 04:03:11'),
(17, 'USG Machine', 'USG 150D', 'SYSMAX', '131825', '2026-04-08 06:18:25'),
(18, 'USG Machine', 'USG 150D', 'SYSMAX', '80407', '2026-04-08 06:18:25'),
(19, 'X-RAY Machine', 'XRY 325', 'ALLENGERS', '2K1605030', '2026-04-08 06:18:25'),
(20, 'X-RAY Machine', 'XRY 326', 'ALLENGERS', '2K1910026', '2026-04-08 06:18:25'),
(21, 'X-RAY Machine', 'XRY MARS', 'ALLENGERS', '2K1808032', '2026-04-08 06:18:25'),
(22, 'X-RAY Machine', 'XRY MARS', 'ALLENGERS', '2K1605003', '2026-04-08 06:18:25'),
(23, 'Monitor', 'HP-367', 'HP', '656361', '2026-04-21 06:54:42'),
(24, 'Monitor', 'HP-368', 'HP', '656362', '2026-04-21 06:54:42'),
(25, 'Monitor', 'ME3453S', 'ACER', '78762658', '2026-04-21 07:00:36'),
(26, 'Patient Monitor', 'PM-10', 'Dell', '3685175', '2026-07-01 11:31:05'),
(27, 'Ventilator', 'V-105', 'Medtronic', 'SN-495284-1', '2025-11-28 10:30:00'),
(28, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-595344-2', '2025-02-03 16:30:00'),
(29, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-556275-3', '2025-06-28 06:30:00'),
(30, 'Billing Workstation', 'OptiPlex', 'Dell', 'SN-677061-4', '2025-03-30 02:30:00'),
(31, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-218202-5', '2025-10-13 05:30:00'),
(32, 'Billing Workstation', 'OptiPlex', 'Dell', 'SN-104956-6', '2025-06-16 10:30:00'),
(33, 'Server Switch', 'Catalyst 2960', 'Cisco', 'SN-714048-7', '2025-01-15 19:30:00'),
(34, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-497657-8', '2025-07-28 15:30:00'),
(35, 'Server Switch', 'Catalyst 2960', 'Cisco', 'SN-480648-9', '2026-02-06 23:30:00'),
(36, 'Ventilator', 'V-105', 'Medtronic', 'SN-900246-10', '2025-03-07 02:30:00'),
(37, 'Patient Monitor', 'PM-10', 'Mindray', 'SN-226375-11', '2025-07-07 16:30:00'),
(38, 'Patient Monitor', 'PM-10', 'Mindray', 'SN-207413-12', '2025-02-13 07:30:00'),
(39, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-797217-13', '2025-03-23 05:30:00'),
(40, 'USG Machine', '150D', 'Siemens', 'SN-344223-14', '2025-09-24 04:30:00'),
(41, 'Ventilator', 'V-105', 'Medtronic', 'SN-278123-15', '2025-03-24 16:30:00'),
(42, 'Ventilator', 'V-102', 'Philips Healthcare', 'SN-713017-16', '2025-04-11 05:30:00'),
(43, 'Billing Workstation', 'OptiPlex', 'Dell', 'SN-380045-17', '2025-12-02 17:30:00'),
(44, 'Ventilator', 'V-102', 'Philips Healthcare', 'SN-386136-18', '2025-09-29 12:30:00'),
(45, 'X-RAY Machine', 'MARS', 'Allengers', 'SN-495374-19', '2025-10-27 12:30:00'),
(46, 'Printer', 'LaserJet Pro', 'HP', 'SN-613357-20', '2025-11-14 12:30:00'),
(47, 'X-RAY Machine', 'MARS', 'Allengers', 'SN-634763-21', '2025-02-05 21:30:00'),
(48, 'X-RAY Machine', 'MARS', 'Allengers', 'SN-243553-22', '2026-02-09 16:30:00'),
(49, 'Billing Workstation', 'OptiPlex', 'Dell', 'SN-954437-23', '2026-02-07 01:30:00'),
(50, 'Ventilator', 'V-105', 'Medtronic', 'SN-798107-24', '2026-02-06 14:30:00'),
(51, 'Ventilator', 'V-105', 'Medtronic', 'SN-953591-25', '2026-01-25 03:30:00'),
(52, 'Defibrillator', 'D-50', 'Zoll Medical', 'SN-236195-26', '2025-10-10 20:30:00'),
(53, 'Defibrillator', 'D-50', 'Zoll Medical', 'SN-302132-27', '2025-01-20 10:30:00'),
(54, 'Ventilator', 'V-105', 'Medtronic', 'SN-202437-28', '2025-06-13 07:30:00'),
(55, 'Ventilator', 'V-102', 'Philips Healthcare', 'SN-370174-29', '2025-02-17 09:30:00'),
(56, 'Server Switch', 'Catalyst 2960', 'Cisco', 'SN-555958-30', '2025-04-26 12:30:00'),
(57, 'Printer', 'LaserJet Pro', 'HP', 'SN-484832-31', '2025-03-31 12:30:00'),
(58, 'Ventilator', 'V-102', 'Philips Healthcare', 'SN-434614-32', '2025-03-30 19:30:00'),
(59, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-197544-33', '2025-05-18 08:30:00'),
(60, 'Ventilator', 'V-105', 'Medtronic', 'SN-980849-34', '2025-05-23 02:30:00'),
(61, 'Ventilator', 'V-105', 'Medtronic', 'SN-862750-35', '2025-05-18 02:30:00'),
(62, 'Defibrillator', 'D-50', 'Zoll Medical', 'SN-852154-36', '2025-06-30 15:30:00'),
(63, 'X-RAY Machine', 'MARS', 'Allengers', 'SN-334675-37', '2025-06-05 13:30:00'),
(64, 'Printer', 'LaserJet Pro', 'HP', 'SN-158640-38', '2025-09-26 07:30:00'),
(65, 'USG Machine', '150D', 'Siemens', 'SN-497674-39', '2026-01-21 20:30:00'),
(66, 'Server Switch', 'Catalyst 2960', 'Cisco', 'SN-207598-40', '2025-02-04 04:30:00'),
(67, 'Ventilator', 'V-102', 'Philips Healthcare', 'SN-843473-41', '2025-07-17 19:30:00'),
(68, 'USG Machine', '150D', 'Siemens', 'SN-786181-42', '2025-09-15 08:30:00'),
(69, 'Defibrillator', 'D-50', 'Zoll Medical', 'SN-293760-43', '2025-02-27 19:30:00'),
(70, 'Patient Monitor', 'PM-10', 'Mindray', 'SN-773603-44', '2025-12-12 05:30:00'),
(71, 'Ventilator', 'V-102', 'Philips Healthcare', 'SN-316884-45', '2025-10-23 16:30:00'),
(72, 'Billing Workstation', 'OptiPlex', 'Dell', 'SN-705876-46', '2025-05-25 15:30:00'),
(73, 'Printer', 'LaserJet Pro', 'HP', 'SN-545181-47', '2025-01-23 12:30:00'),
(74, 'X-RAY Machine', 'MARS', 'Allengers', 'SN-643956-48', '2025-05-04 16:30:00'),
(75, 'Defibrillator', 'D-50', 'Zoll Medical', 'SN-153048-49', '2026-01-29 00:30:00'),
(76, 'Printer', 'LaserJet Pro', 'HP', 'SN-418726-50', '2025-03-11 20:30:00'),
(77, 'Ventilator', 'V-105', 'Medtronic', 'SN-272718-51', '2026-01-05 11:30:00'),
(78, 'Server Switch', 'Catalyst 2960', 'Cisco', 'SN-455239-52', '2025-08-29 03:30:00'),
(79, 'Server Switch', 'Catalyst 2960', 'Cisco', 'SN-882125-53', '2025-03-14 04:30:00'),
(80, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-558213-54', '2025-03-06 13:30:00'),
(81, 'Ventilator', 'V-105', 'Medtronic', 'SN-557742-55', '2026-01-17 16:30:00'),
(82, 'Server Switch', 'Catalyst 2960', 'Cisco', 'SN-792116-56', '2025-02-13 04:30:00'),
(83, 'Printer', 'LaserJet Pro', 'HP', 'SN-970870-57', '2025-09-21 22:30:00'),
(84, 'Printer', 'LaserJet Pro', 'HP', 'SN-941939-58', '2025-12-06 10:30:00'),
(85, 'Patient Monitor', 'PM-10', 'Mindray', 'SN-891371-59', '2025-04-19 23:30:00'),
(86, 'Ventilator', 'V-102', 'Philips Healthcare', 'SN-102190-60', '2025-11-06 15:30:00'),
(87, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-162314-61', '2025-06-18 01:30:00'),
(88, 'USG Machine', '150D', 'Siemens', 'SN-538187-62', '2025-07-12 06:30:00'),
(89, 'Printer', 'LaserJet Pro', 'HP', 'SN-134802-63', '2025-10-27 15:30:00'),
(90, 'Billing Workstation', 'OptiPlex', 'Dell', 'SN-767826-64', '2025-04-09 09:30:00'),
(91, 'USG Machine', '150D', 'Siemens', 'SN-502221-65', '2025-02-26 05:30:00'),
(92, 'X-RAY Machine', 'MARS', 'Allengers', 'SN-705490-66', '2025-06-05 02:30:00'),
(93, 'Billing Workstation', 'OptiPlex', 'Dell', 'SN-416789-67', '2025-11-04 01:30:00'),
(94, 'Ventilator', 'V-102', 'Philips Healthcare', 'SN-148412-68', '2025-01-25 04:30:00'),
(95, 'Patient Monitor', 'PM-10', 'Mindray', 'SN-171731-69', '2025-09-05 22:30:00'),
(96, 'Server Switch', 'Catalyst 2960', 'Cisco', 'SN-534566-70', '2025-01-21 09:30:00'),
(97, 'USG Machine', '150D', 'Siemens', 'SN-998442-71', '2025-09-18 19:30:00'),
(98, 'Patient Monitor', 'PM-10', 'Mindray', 'SN-654540-72', '2025-07-09 23:30:00'),
(99, 'Patient Monitor', 'PM-10', 'Mindray', 'SN-338476-73', '2026-01-02 11:30:00'),
(100, 'X-RAY Machine', 'MARS', 'Allengers', 'SN-278372-74', '2026-01-25 17:30:00'),
(101, 'Ventilator', 'V-102', 'Philips Healthcare', 'SN-807099-75', '2025-10-23 17:30:00'),
(102, 'Ventilator', 'V-105', 'Medtronic', 'SN-154874-76', '2025-10-06 13:30:00'),
(103, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-859424-77', '2025-09-16 04:30:00'),
(104, 'Printer', 'LaserJet Pro', 'HP', 'SN-877330-78', '2025-08-13 14:30:00'),
(105, 'X-RAY Machine', 'MARS', 'Allengers', 'SN-319026-79', '2025-08-15 15:30:00'),
(106, 'Ventilator', 'V-105', 'Medtronic', 'SN-868685-80', '2025-11-25 11:30:00'),
(107, 'Patient Monitor', 'PM-10', 'Mindray', 'SN-352545-81', '2025-04-24 00:30:00'),
(108, 'Printer', 'LaserJet Pro', 'HP', 'SN-914037-82', '2025-02-18 05:30:00'),
(109, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-302818-83', '2025-09-13 22:30:00'),
(110, 'Patient Monitor', 'PM-10', 'Mindray', 'SN-350408-84', '2025-11-30 14:30:00'),
(111, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-149277-85', '2025-10-27 12:30:00'),
(112, 'Patient Monitor', 'PM-10', 'Mindray', 'SN-587912-86', '2025-02-16 02:30:00'),
(113, 'Defibrillator', 'D-50', 'Zoll Medical', 'SN-913492-87', '2026-02-02 13:30:00'),
(114, 'USG Machine', '150D', 'Siemens', 'SN-260559-88', '2025-08-29 00:30:00'),
(115, 'Billing Workstation', 'OptiPlex', 'Dell', 'SN-570333-89', '2025-07-30 01:30:00'),
(116, 'Billing Workstation', 'OptiPlex', 'Dell', 'SN-853350-90', '2025-08-16 20:30:00'),
(117, 'Server Switch', 'Catalyst 2960', 'Cisco', 'SN-753234-91', '2026-01-14 12:30:00'),
(118, 'Ventilator', 'V-105', 'Medtronic', 'SN-362221-92', '2025-12-19 23:30:00'),
(119, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-113057-93', '2025-11-22 17:30:00'),
(120, 'Server Switch', 'Catalyst 2960', 'Cisco', 'SN-342852-94', '2025-10-27 10:30:00'),
(121, 'Ventilator', 'V-105', 'Medtronic', 'SN-806518-95', '2025-10-24 03:30:00'),
(122, 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'SN-360324-96', '2026-01-18 08:30:00'),
(123, 'Ventilator', 'V-102', 'Philips Healthcare', 'SN-818742-97', '2025-12-23 07:30:00'),
(124, 'Server Switch', 'Catalyst 2960', 'Cisco', 'SN-656572-98', '2025-11-28 01:30:00'),
(125, 'Defibrillator', 'D-50', 'Zoll Medical', 'SN-652687-99', '2025-03-09 13:30:00'),
(126, 'Billing Workstation', 'OptiPlex', 'Dell', 'SN-476103-100', '2025-12-27 17:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `purchased_items`
--

CREATE TABLE `purchased_items` (
  `serial_number` varchar(100) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `item_model` varchar(255) NOT NULL,
  `item_manufacturer` varchar(255) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `date_purchased` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_forwarded` varchar(50) DEFAULT 'nan',
  `date_added_to_inventory` varchar(50) DEFAULT 'nan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchased_items`
--

INSERT INTO `purchased_items` (`serial_number`, `item_name`, `item_model`, `item_manufacturer`, `user_id`, `date_purchased`, `date_forwarded`, `date_added_to_inventory`) VALUES
('656361', 'Monitor', 'HP-367', 'HP', 'GIMSH2618', '2026-04-12 18:30:00', '2026-04-16', '2026-04-21 12:24:42'),
('656362', 'Monitor', 'HP-368', 'HP', 'GIMSH2618', '2026-04-12 18:30:00', '2026-04-16', '2026-04-21 12:24:42'),
('78762658', 'Monitor', 'ME3453S', 'ACER', 'GIMSH2618', '2026-04-12 18:30:00', '2026-04-14', '2026-04-21 12:30:36'),
('SN-102190-60', 'Ventilator', 'V-102', 'Philips Healthcare', '3333', '2025-10-30 15:30:00', '2025-11-06 21:00:00', '2025-11-06 21:00:00'),
('SN-104956-6', 'Billing Workstation', 'OptiPlex', 'Dell', 'EMP-101', '2025-06-09 10:30:00', '2025-06-16 16:00:00', '2025-06-16 16:00:00'),
('SN-113057-93', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'EMP-102', '2025-11-13 17:30:00', '2025-11-22 23:00:00', '2025-11-22 23:00:00'),
('SN-134802-63', 'Printer', 'LaserJet Pro', 'HP', '2222', '2025-10-24 15:30:00', '2025-10-27 21:00:00', '2025-10-27 21:00:00'),
('SN-148412-68', 'Ventilator', 'V-102', 'Philips Healthcare', '1000', '2025-01-16 04:30:00', '2025-01-25 10:00:00', '2025-01-25 10:00:00'),
('SN-149277-85', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', '2222', '2025-10-17 12:30:00', '2025-10-27 18:00:00', '2025-10-27 18:00:00'),
('SN-153048-49', 'Defibrillator', 'D-50', 'Zoll Medical', 'GIMSH2618', '2026-01-19 00:30:00', '2026-01-29 06:00:00', '2026-01-29 06:00:00'),
('SN-154874-76', 'Ventilator', 'V-105', 'Medtronic', '3333', '2025-10-02 13:30:00', '2025-10-06 19:00:00', '2025-10-06 19:00:00'),
('SN-158640-38', 'Printer', 'LaserJet Pro', 'HP', '2222', '2025-09-24 07:30:00', '2025-09-26 13:00:00', '2025-09-26 13:00:00'),
('SN-162314-61', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', '1000', '2025-06-08 01:30:00', '2025-06-18 07:00:00', '2025-06-18 07:00:00'),
('SN-171731-69', 'Patient Monitor', 'PM-10', 'Mindray', 'EMP-102', '2025-08-26 22:30:00', '2025-09-06 04:00:00', '2025-09-06 04:00:00'),
('SN-197544-33', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'GIMSH2618', '2025-05-12 08:30:00', '2025-05-18 14:00:00', '2025-05-18 14:00:00'),
('SN-202437-28', 'Ventilator', 'V-105', 'Medtronic', '2222', '2025-06-05 07:30:00', '2025-06-13 13:00:00', '2025-06-13 13:00:00'),
('SN-207413-12', 'Patient Monitor', 'PM-10', 'Mindray', '1000', '2025-02-05 07:30:00', '2025-02-13 13:00:00', '2025-02-13 13:00:00'),
('SN-207598-40', 'Server Switch', 'Catalyst 2960', 'Cisco', 'GIMSH2618', '2025-02-01 04:30:00', '2025-02-04 10:00:00', '2025-02-04 10:00:00'),
('SN-218202-5', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'EMP-101', '2025-10-11 05:30:00', '2025-10-13 11:00:00', '2025-10-13 11:00:00'),
('SN-226375-11', 'Patient Monitor', 'PM-10', 'Mindray', '3333', '2025-06-27 16:30:00', '2025-07-07 22:00:00', '2025-07-07 22:00:00'),
('SN-236195-26', 'Defibrillator', 'D-50', 'Zoll Medical', '1000', '2025-10-06 20:30:00', '2025-10-11 02:00:00', '2025-10-11 02:00:00'),
('SN-243553-22', 'X-RAY Machine', 'MARS', 'Allengers', 'EMP-102', '2026-02-06 16:30:00', '2026-02-09 22:00:00', '2026-02-09 22:00:00'),
('SN-260559-88', 'USG Machine', '150D', 'Siemens', '2222', '2025-08-26 00:30:00', '2025-08-29 06:00:00', '2025-08-29 06:00:00'),
('SN-272718-51', 'Ventilator', 'V-105', 'Medtronic', 'GIMSH2618', '2025-12-27 11:30:00', '2026-01-05 17:00:00', '2026-01-05 17:00:00'),
('SN-278123-15', 'Ventilator', 'V-105', 'Medtronic', '2222', '2025-03-16 16:30:00', '2025-03-24 22:00:00', '2025-03-24 22:00:00'),
('SN-278372-74', 'X-RAY Machine', 'MARS', 'Allengers', 'EMP-101', '2026-01-20 17:30:00', '2026-01-25 23:00:00', '2026-01-25 23:00:00'),
('SN-293760-43', 'Defibrillator', 'D-50', 'Zoll Medical', '2222', '2025-02-18 19:30:00', '2025-02-28 01:00:00', '2025-02-28 01:00:00'),
('SN-302132-27', 'Defibrillator', 'D-50', 'Zoll Medical', '2222', '2025-01-14 10:30:00', '2025-01-20 16:00:00', '2025-01-20 16:00:00'),
('SN-302818-83', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', '2222', '2025-09-08 22:30:00', '2025-09-14 04:00:00', '2025-09-14 04:00:00'),
('SN-316884-45', 'Ventilator', 'V-102', 'Philips Healthcare', '2222', '2025-10-17 16:30:00', '2025-10-23 22:00:00', '2025-10-23 22:00:00'),
('SN-319026-79', 'X-RAY Machine', 'MARS', 'Allengers', '2222', '2025-08-11 15:30:00', '2025-08-15 21:00:00', '2025-08-15 21:00:00'),
('SN-334675-37', 'X-RAY Machine', 'MARS', 'Allengers', '3333', '2025-06-03 13:30:00', '2025-06-05 19:00:00', '2025-06-05 19:00:00'),
('SN-338476-73', 'Patient Monitor', 'PM-10', 'Mindray', 'EMP-102', '2025-12-31 11:30:00', '2026-01-02 17:00:00', '2026-01-02 17:00:00'),
('SN-342852-94', 'Server Switch', 'Catalyst 2960', 'Cisco', 'GIMSH2618', '2025-10-24 10:30:00', '2025-10-27 16:00:00', '2025-10-27 16:00:00'),
('SN-344223-14', 'USG Machine', '150D', 'Siemens', 'EMP-101', '2025-09-17 04:30:00', '2025-09-24 10:00:00', '2025-09-24 10:00:00'),
('SN-350408-84', 'Patient Monitor', 'PM-10', 'Mindray', 'GIMSH2618', '2025-11-20 14:30:00', '2025-11-30 20:00:00', '2025-11-30 20:00:00'),
('SN-352545-81', 'Patient Monitor', 'PM-10', 'Mindray', 'EMP-101', '2025-04-22 00:30:00', '2025-04-24 06:00:00', '2025-04-24 06:00:00'),
('SN-360324-96', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', '3333', '2026-01-16 08:30:00', '2026-01-18 14:00:00', '2026-01-18 14:00:00'),
('SN-362221-92', 'Ventilator', 'V-105', 'Medtronic', '2222', '2025-12-16 23:30:00', '2025-12-20 05:00:00', '2025-12-20 05:00:00'),
('SN-370174-29', 'Ventilator', 'V-102', 'Philips Healthcare', '1000', '2025-02-15 09:30:00', '2025-02-17 15:00:00', '2025-02-17 15:00:00'),
('SN-380045-17', 'Billing Workstation', 'OptiPlex', 'Dell', 'EMP-101', '2025-11-24 17:30:00', '2025-12-02 23:00:00', '2025-12-02 23:00:00'),
('SN-386136-18', 'Ventilator', 'V-102', 'Philips Healthcare', 'EMP-101', '2025-09-20 12:30:00', '2025-09-29 18:00:00', '2025-09-29 18:00:00'),
('SN-416789-67', 'Billing Workstation', 'OptiPlex', 'Dell', 'EMP-101', '2025-10-31 01:30:00', '2025-11-04 07:00:00', '2025-11-04 07:00:00'),
('SN-418726-50', 'Printer', 'LaserJet Pro', 'HP', '2222', '2025-03-01 20:30:00', '2025-03-12 02:00:00', '2025-03-12 02:00:00'),
('SN-434614-32', 'Ventilator', 'V-102', 'Philips Healthcare', 'EMP-102', '2025-03-24 19:30:00', '2025-03-31 01:00:00', '2025-03-31 01:00:00'),
('SN-455239-52', 'Server Switch', 'Catalyst 2960', 'Cisco', 'EMP-102', '2025-08-21 03:30:00', '2025-08-29 09:00:00', '2025-08-29 09:00:00'),
('SN-476103-100', 'Billing Workstation', 'OptiPlex', 'Dell', 'EMP-102', '2025-12-25 17:30:00', '2025-12-27 23:00:00', '2025-12-27 23:00:00'),
('SN-480648-9', 'Server Switch', 'Catalyst 2960', 'Cisco', 'GIMSH2618', '2026-01-31 23:30:00', '2026-02-07 05:00:00', '2026-02-07 05:00:00'),
('SN-484832-31', 'Printer', 'LaserJet Pro', 'HP', '2222', '2025-03-29 12:30:00', '2025-03-31 18:00:00', '2025-03-31 18:00:00'),
('SN-495284-1', 'Ventilator', 'V-105', 'Medtronic', '3333', '2025-11-24 10:30:00', '2025-11-28 16:00:00', '2025-11-28 16:00:00'),
('SN-495374-19', 'X-RAY Machine', 'MARS', 'Allengers', '2222', '2025-10-21 12:30:00', '2025-10-27 18:00:00', '2025-10-27 18:00:00'),
('SN-497657-8', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'EMP-101', '2025-07-22 15:30:00', '2025-07-28 21:00:00', '2025-07-28 21:00:00'),
('SN-497674-39', 'USG Machine', '150D', 'Siemens', 'GIMSH2618', '2026-01-11 20:30:00', '2026-01-22 02:00:00', '2026-01-22 02:00:00'),
('SN-502221-65', 'USG Machine', '150D', 'Siemens', 'EMP-102', '2025-02-24 05:30:00', '2025-02-26 11:00:00', '2025-02-26 11:00:00'),
('SN-534566-70', 'Server Switch', 'Catalyst 2960', 'Cisco', 'GIMSH2618', '2025-01-15 09:30:00', '2025-01-21 15:00:00', '2025-01-21 15:00:00'),
('SN-538187-62', 'USG Machine', '150D', 'Siemens', 'GIMSH2618', '2025-07-02 06:30:00', '2025-07-12 12:00:00', '2025-07-12 12:00:00'),
('SN-545181-47', 'Printer', 'LaserJet Pro', 'HP', '1000', '2025-01-18 12:30:00', '2025-01-23 18:00:00', '2025-01-23 18:00:00'),
('SN-555958-30', 'Server Switch', 'Catalyst 2960', 'Cisco', 'EMP-102', '2025-04-17 12:30:00', '2025-04-26 18:00:00', '2025-04-26 18:00:00'),
('SN-556275-3', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'GIMSH2618', '2025-06-24 06:30:00', '2025-06-28 12:00:00', '2025-06-28 12:00:00'),
('SN-557742-55', 'Ventilator', 'V-105', 'Medtronic', 'EMP-102', '2026-01-15 16:30:00', '2026-01-17 22:00:00', '2026-01-17 22:00:00'),
('SN-558213-54', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', '1000', '2025-02-26 13:30:00', '2025-03-06 19:00:00', '2025-03-06 19:00:00'),
('SN-570333-89', 'Billing Workstation', 'OptiPlex', 'Dell', 'EMP-101', '2025-07-28 01:30:00', '2025-07-30 07:00:00', '2025-07-30 07:00:00'),
('SN-587912-86', 'Patient Monitor', 'PM-10', 'Mindray', '1000', '2025-02-13 02:30:00', '2025-02-16 08:00:00', '2025-02-16 08:00:00'),
('SN-595344-2', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'EMP-101', '2025-01-26 16:30:00', '2025-02-03 22:00:00', '2025-02-03 22:00:00'),
('SN-613357-20', 'Printer', 'LaserJet Pro', 'HP', 'EMP-102', '2025-11-05 12:30:00', '2025-11-14 18:00:00', '2025-11-14 18:00:00'),
('SN-634763-21', 'X-RAY Machine', 'MARS', 'Allengers', 'GIMSH2618', '2025-02-03 21:30:00', '2025-02-06 03:00:00', '2025-02-06 03:00:00'),
('SN-643956-48', 'X-RAY Machine', 'MARS', 'Allengers', '2222', '2025-04-25 16:30:00', '2025-05-04 22:00:00', '2025-05-04 22:00:00'),
('SN-652687-99', 'Defibrillator', 'D-50', 'Zoll Medical', '3333', '2025-03-03 13:30:00', '2025-03-09 19:00:00', '2025-03-09 19:00:00'),
('SN-654540-72', 'Patient Monitor', 'PM-10', 'Mindray', 'EMP-102', '2025-07-04 23:30:00', '2025-07-10 05:00:00', '2025-07-10 05:00:00'),
('SN-656572-98', 'Server Switch', 'Catalyst 2960', 'Cisco', 'EMP-102', '2025-11-24 01:30:00', '2025-11-28 07:00:00', '2025-11-28 07:00:00'),
('SN-677061-4', 'Billing Workstation', 'OptiPlex', 'Dell', '2222', '2025-03-22 02:30:00', '2025-03-30 08:00:00', '2025-03-30 08:00:00'),
('SN-705490-66', 'X-RAY Machine', 'MARS', 'Allengers', '2222', '2025-06-01 02:30:00', '2025-06-05 08:00:00', '2025-06-05 08:00:00'),
('SN-705876-46', 'Billing Workstation', 'OptiPlex', 'Dell', '3333', '2025-05-20 15:30:00', '2025-05-25 21:00:00', '2025-05-25 21:00:00'),
('SN-713017-16', 'Ventilator', 'V-102', 'Philips Healthcare', 'EMP-102', '2025-04-02 05:30:00', '2025-04-11 11:00:00', '2025-04-11 11:00:00'),
('SN-714048-7', 'Server Switch', 'Catalyst 2960', 'Cisco', '3333', '2025-01-10 19:30:00', '2025-01-16 01:00:00', '2025-01-16 01:00:00'),
('SN-753234-91', 'Server Switch', 'Catalyst 2960', 'Cisco', '3333', '2026-01-05 12:30:00', '2026-01-14 18:00:00', '2026-01-14 18:00:00'),
('SN-767826-64', 'Billing Workstation', 'OptiPlex', 'Dell', '2222', '2025-03-31 09:30:00', '2025-04-09 15:00:00', '2025-04-09 15:00:00'),
('SN-773603-44', 'Patient Monitor', 'PM-10', 'Mindray', 'EMP-102', '2025-12-08 05:30:00', '2025-12-12 11:00:00', '2025-12-12 11:00:00'),
('SN-786181-42', 'USG Machine', '150D', 'Siemens', '2222', '2025-09-13 08:30:00', '2025-09-15 14:00:00', '2025-09-15 14:00:00'),
('SN-792116-56', 'Server Switch', 'Catalyst 2960', 'Cisco', '2222', '2025-02-06 04:30:00', '2025-02-13 10:00:00', '2025-02-13 10:00:00'),
('SN-797217-13', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'GIMSH2618', '2025-03-21 05:30:00', '2025-03-23 11:00:00', '2025-03-23 11:00:00'),
('SN-798107-24', 'Ventilator', 'V-105', 'Medtronic', 'EMP-102', '2026-02-01 14:30:00', '2026-02-06 20:00:00', '2026-02-06 20:00:00'),
('SN-806518-95', 'Ventilator', 'V-105', 'Medtronic', 'GIMSH2618', '2025-10-18 03:30:00', '2025-10-24 09:00:00', '2025-10-24 09:00:00'),
('SN-807099-75', 'Ventilator', 'V-102', 'Philips Healthcare', 'EMP-102', '2025-10-21 17:30:00', '2025-10-23 23:00:00', '2025-10-23 23:00:00'),
('SN-818742-97', 'Ventilator', 'V-102', 'Philips Healthcare', 'EMP-102', '2025-12-14 07:30:00', '2025-12-23 13:00:00', '2025-12-23 13:00:00'),
('SN-843473-41', 'Ventilator', 'V-102', 'Philips Healthcare', '1000', '2025-07-10 19:30:00', '2025-07-18 01:00:00', '2025-07-18 01:00:00'),
('SN-852154-36', 'Defibrillator', 'D-50', 'Zoll Medical', '2222', '2025-06-24 15:30:00', '2025-06-30 21:00:00', '2025-06-30 21:00:00'),
('SN-853350-90', 'Billing Workstation', 'OptiPlex', 'Dell', 'EMP-101', '2025-08-11 20:30:00', '2025-08-17 02:00:00', '2025-08-17 02:00:00'),
('SN-859424-77', 'ECG Machine', 'Cardio-X1', 'GE Healthcare', 'EMP-101', '2025-09-09 04:30:00', '2025-09-16 10:00:00', '2025-09-16 10:00:00'),
('SN-862750-35', 'Ventilator', 'V-105', 'Medtronic', '1000', '2025-05-09 02:30:00', '2025-05-18 08:00:00', '2025-05-18 08:00:00'),
('SN-868685-80', 'Ventilator', 'V-105', 'Medtronic', 'GIMSH2618', '2025-11-18 11:30:00', '2025-11-25 17:00:00', '2025-11-25 17:00:00'),
('SN-877330-78', 'Printer', 'LaserJet Pro', 'HP', 'EMP-101', '2025-08-03 14:30:00', '2025-08-13 20:00:00', '2025-08-13 20:00:00'),
('SN-882125-53', 'Server Switch', 'Catalyst 2960', 'Cisco', 'EMP-101', '2025-03-05 04:30:00', '2025-03-14 10:00:00', '2025-03-14 10:00:00'),
('SN-891371-59', 'Patient Monitor', 'PM-10', 'Mindray', 'EMP-102', '2025-04-12 23:30:00', '2025-04-20 05:00:00', '2025-04-20 05:00:00'),
('SN-900246-10', 'Ventilator', 'V-105', 'Medtronic', 'EMP-101', '2025-02-26 02:30:00', '2025-03-07 08:00:00', '2025-03-07 08:00:00'),
('SN-913492-87', 'Defibrillator', 'D-50', 'Zoll Medical', 'EMP-102', '2026-01-30 13:30:00', '2026-02-02 19:00:00', '2026-02-02 19:00:00'),
('SN-914037-82', 'Printer', 'LaserJet Pro', 'HP', 'GIMSH2618', '2025-02-10 05:30:00', '2025-02-18 11:00:00', '2025-02-18 11:00:00'),
('SN-941939-58', 'Printer', 'LaserJet Pro', 'HP', '1000', '2025-12-03 10:30:00', '2025-12-06 16:00:00', '2025-12-06 16:00:00'),
('SN-953591-25', 'Ventilator', 'V-105', 'Medtronic', '1000', '2026-01-18 03:30:00', '2026-01-25 09:00:00', '2026-01-25 09:00:00'),
('SN-954437-23', 'Billing Workstation', 'OptiPlex', 'Dell', '2222', '2026-02-03 01:30:00', '2026-02-07 07:00:00', '2026-02-07 07:00:00'),
('SN-970870-57', 'Printer', 'LaserJet Pro', 'HP', '3333', '2025-09-13 22:30:00', '2025-09-22 04:00:00', '2025-09-22 04:00:00'),
('SN-980849-34', 'Ventilator', 'V-105', 'Medtronic', '3333', '2025-05-17 02:30:00', '2025-05-23 08:00:00', '2025-05-23 08:00:00'),
('SN-998442-71', 'USG Machine', '150D', 'Siemens', 'EMP-101', '2025-09-13 19:30:00', '2025-09-19 01:00:00', '2025-09-19 01:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `user_dataset`
--

CREATE TABLE `user_dataset` (
  `user_name` text NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `user_mail` varchar(20) NOT NULL,
  `user_password` varchar(20) NOT NULL,
  `user_role` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`user_role`)),
  `date_created` date NOT NULL,
  `dept_id` varchar(50) DEFAULT 'nan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_dataset`
--

INSERT INTO `user_dataset` (`user_name`, `user_id`, `user_mail`, `user_password`, `user_role`, `date_created`, `dept_id`) VALUES
('Arka', '1000', 'arka@gmail.com', '1000', '{\"user\":0,\"admin\":1,\"purchase\":0}', '2026-04-06', 'DEPT-PHARM'),
('Rakesh', '1234', 'ra@mail.com', '1234', '{\"user\":1,\"admin\":0,\"purchase\":0}', '2026-04-04', 'DEPT-PED'),
('1478', '1478', 'sun@gmail.com', '1478', '{\"user\":0,\"admin\":0,\"purchase\":1}', '2026-07-05', 'DEPT-PRC'),
('Sonu', '2222', 'sonu@gmail.com', '2222', '{\"user\":0,\"admin\":1,\"purchase\":1}', '2026-04-06', 'DEPT-PRC'),
('Raj', '3333', 'raj@gmail.com', '3333', '{\"user\":1,\"admin\":0,\"purchase\":0}', '2026-04-06', 'DEPT-ICU'),
('Just a User', '9999', 'user@mail.com', '9999', '{\"user\":1,\"admin\":0,\"purchase\":0}', '2026-06-27', 'DEPT-CARD'),
('Jane Smith', 'EMP-102', 'jane@hospital.com', '1111', '{\"user\":1,\"admin\":0,\"purchase\":0}', '2026-04-15', 'nan'),
('Bamon Chattrjee', 'GIMSH2014', 'bam@gmail.com', '1234', '{\"user\":1,\"admin\":0,\"purchase\":0}', '2026-04-07', 'DEPT-CARD'),
('Admin', 'GIMSH2051', 'admin@mail.com', 'admin', '{\"user\":1,\"admin\":0,\"purchase\":0}', '2026-04-06', 'DEPT-NEURO'),
('Surya Saha', 'GIMSH2618', 'surya@mail.com', '1234', '{\"user\":1,\"admin\":1,\"purchase\":1}', '2026-04-04', 'DEPT-CARD');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_purchase_queries`
--
ALTER TABLE `admin_purchase_queries`
  ADD PRIMARY KEY (`conversation_id`);

--
-- Indexes for table `asset_history`
--
ALTER TABLE `asset_history`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `asset_report`
--
ALTER TABLE `asset_report`
  ADD PRIMARY KEY (`report_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`dept_id`);

--
-- Indexes for table `dept_user_queries`
--
ALTER TABLE `dept_user_queries`
  ADD PRIMARY KEY (`conversation_id`);

--
-- Indexes for table `discarded_items`
--
ALTER TABLE `discarded_items`
  ADD PRIMARY KEY (`discard_id`);

--
-- Indexes for table `forwarded_items`
--
ALTER TABLE `forwarded_items`
  ADD PRIMARY KEY (`serial_number`);

--
-- Indexes for table `forwarded_reports`
--
ALTER TABLE `forwarded_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_report` (`report_id`);

--
-- Indexes for table `item_assigneds`
--
ALTER TABLE `item_assigneds`
  ADD PRIMARY KEY (`assign_id`),
  ADD KEY `fk_assignment_item` (`item_id`),
  ADD KEY `fk_assignment_dept` (`dept_id`);

--
-- Indexes for table `item_requests`
--
ALTER TABLE `item_requests`
  ADD PRIMARY KEY (`request_id`);

--
-- Indexes for table `item_table`
--
ALTER TABLE `item_table`
  ADD PRIMARY KEY (`item_id`),
  ADD UNIQUE KEY `serial_number` (`serial_number`);

--
-- Indexes for table `purchased_items`
--
ALTER TABLE `purchased_items`
  ADD PRIMARY KEY (`serial_number`);

--
-- Indexes for table `user_dataset`
--
ALTER TABLE `user_dataset`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_purchase_queries`
--
ALTER TABLE `admin_purchase_queries`
  MODIFY `conversation_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `asset_report`
--
ALTER TABLE `asset_report`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=167;

--
-- AUTO_INCREMENT for table `dept_user_queries`
--
ALTER TABLE `dept_user_queries`
  MODIFY `conversation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `discarded_items`
--
ALTER TABLE `discarded_items`
  MODIFY `discard_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `forwarded_reports`
--
ALTER TABLE `forwarded_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `item_assigneds`
--
ALTER TABLE `item_assigneds`
  MODIFY `assign_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=117;

--
-- AUTO_INCREMENT for table `item_requests`
--
ALTER TABLE `item_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item_table`
--
ALTER TABLE `item_table`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `forwarded_items`
--
ALTER TABLE `forwarded_items`
  ADD CONSTRAINT `forwarded_items_ibfk_1` FOREIGN KEY (`serial_number`) REFERENCES `purchased_items` (`serial_number`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `item_assigneds`
--
ALTER TABLE `item_assigneds`
  ADD CONSTRAINT `fk_assignment_dept` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_assignment_item` FOREIGN KEY (`item_id`) REFERENCES `item_table` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
