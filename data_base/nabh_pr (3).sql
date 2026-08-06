-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 21, 2026 at 08:22 AM
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
(7, 'KEYBOARD', 'nan', '2026-04-07 09:13:05', '{\"DEPT-ICU\":{\"allocation_date\":\"2026-04-13 12:31:07\",\"revoke_date\":\"2026-04-16 05:46:58\"},\"DEPT-ER\":{\"allocation_date\":\"2026-04-16 10:11:23\",\"revoke_date\":\"2026-04-16 10:11:52\"}}'),
(9, 'USG Machine', 'nan', '2026-04-07 09:33:11', '{\"DEPT-ER\":{\"allocation_date\":\"2026-04-16 10:11:23\",\"discarded_date\":\"2026-04-16 10:23:03\"}}'),
(10, 'X-RAY Machine', 'nan', '2026-04-07 09:33:11', '{\"DEPT-ER\": {\"allocation_date\": \"2026-04-08 09:48:08\", \"revoke_date\": \"2026-04-16 05:46:58\"}}'),
(11, 'X-RAY Machine', 'nan', '2026-04-07 09:33:11', '{\"DEPT-ER\": {\"allocation_date\": \"2026-04-16 09:11:44\", \"revoke_date\": \"2026-04-16 05:46:58\"}}'),
(13, 'X-RAY Machine', 'nan', '2026-04-07 09:33:11', '{\"DEPT-ER\":{\"allocation_date\":\"2026-04-16 09:11:44\",\"revoke_date\":\"2026-04-16 05:46:58\"},\"DEPT-ICU\":{\"allocation_date\":\"2026-04-16 10:01:19\",\"revoke_date\":\"nan\"}}'),
(14, 'USG Machine', 'nan', '2026-04-08 11:40:24', '{}'),
(17, 'USG Machine', 'nan', '2026-04-08 11:48:25', '{}'),
(18, 'USG Machine', 'nan', '2026-04-08 11:48:25', '{}'),
(19, 'X-RAY Machine', 'nan', '2026-04-08 11:48:25', '{\"DEPT-ICU\":{\"allocation_date\":\"2026-04-16 09:53:44\",\"revoke_date\":\"nan\"}}'),
(20, 'X-RAY Machine', 'nan', '2026-04-08 11:48:25', '{}'),
(21, 'X-RAY Machine', 'nan', '2026-04-08 11:48:25', '{}'),
(22, 'X-RAY Machine', 'nan', '2026-04-08 11:48:25', '{}');

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
(10, '2222', 'Billing Device ', 'high', 'Pharmacy', 'Ground Floor', 'The current device is not working as it intended to.', 'n', '[]', 1, '2026-04-15 04:12:42', '2026-04-15 10:27:12', NULL, '0000-00-00 00:00:00', 'nan', 'nan');

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
('DEPT-RAD', 'Radiology', '2026-04-07 03:55:24');

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

--
-- Dumping data for table `forwarded_items`
--

INSERT INTO `forwarded_items` (`serial_number`, `item_name`, `item_model`, `user_id`, `date_forwarded`, `forwarded_by_user_id`) VALUES
('656361', 'Monitor', 'HP-367', 'GIMSH2618', '2026-04-16 09:00:03', 'GIMSH2618'),
('656362', 'Monitor', 'HP-368', 'GIMSH2618', '2026-04-16 09:00:03', 'GIMSH2618'),
('78762658', 'Monitor', 'ME3453S', 'GIMSH2618', '2026-04-14 08:24:52', '2222');

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
(7, 8, '1000', '1000', '2026-04-08 11:27:20', '2026-04-14 10:50:53', 'nan');

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
(27, 7, 'DEPT-ER', '2026-04-16 10:11:23', '2026-04-16 10:11:52', 'nan');

-- --------------------------------------------------------

--
-- Table structure for table `item_assignments`
--

CREATE TABLE `item_assignments` (
  `assign_id` int(11) NOT NULL,
  `dept_id` varchar(50) NOT NULL,
  `item_id` int(11) NOT NULL,
  `date_assigned` datetime NOT NULL,
  `date_revoked` varchar(50) DEFAULT 'nan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(22, 'X-RAY Machine', 'XRY MARS', 'ALLENGERS', '2K1605003', '2026-04-08 06:18:25');

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
('656361', 'Monitor', 'HP-367', 'HP', 'GIMSH2618', '2026-04-12 18:30:00', '2026-04-16', 'nan'),
('656362', 'Monitor', 'HP-368', 'HP', 'GIMSH2618', '2026-04-12 18:30:00', '2026-04-16', 'nan'),
('78762658', 'Monitor', 'ME3453S', 'ACER', 'GIMSH2618', '2026-04-12 18:30:00', '2026-04-14', 'nan');

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
('Arka', '1000', 'arka@gmail.com', '1000', '{\"user\":1,\"admin\":1,\"purchase\":0}', '2026-04-06', 'DEPT-ICU'),
('Rakesh', '1234', 'ra@mail.com', '1234', '{\"user\":1,\"admin\":0,\"purchase\":0}', '2026-04-04', 'nan'),
('Sonu', '2222', 'sonu@gmail.com', '2222', '{\"user\":1,\"admin\":0,\"purchase\":1}', '2026-04-06', 'DEPT-ICU'),
('Raj', '3333', 'raj@gmail.com', '3333', '{\"user\":1,\"admin\":0,\"purchase\":0}', '2026-04-06', 'nan'),
('John Doe', 'EMP-101', 'john@hospital.com', '1111', '{\"user\":0,\"admin\":0,\"purchase\":0}', '2026-04-15', 'nan'),
('Jane Smith', 'EMP-102', 'jane@hospital.com', '1111', '{\"user\":1,\"admin\":1,\"purchase\":0}', '2026-04-15', 'nan'),
('Bamon Chattrjee', 'GIMSH2014', 'bam@gmail.com', '1234', '{\"user\":1,\"admin\":0,\"purchase\":0}', '2026-04-07', 'DEPT-CARD'),
('Admin', 'GIMSH2051', 'admin@mail.com', 'admin', '{\"user\":1,\"admin\":0,\"purchase\":0}', '2026-04-06', 'nan'),
('Surya Saha', 'GIMSH2618', 'surya@mail.com', '1234', '{\"user\":1,\"admin\":1,\"purchase\":1}', '2026-04-04', 'DEPT-ICU');

--
-- Indexes for dumped tables
--

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
-- Indexes for table `item_assignments`
--
ALTER TABLE `item_assignments`
  ADD PRIMARY KEY (`assign_id`),
  ADD KEY `fk_item` (`item_id`);

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
-- AUTO_INCREMENT for table `asset_report`
--
ALTER TABLE `asset_report`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `discarded_items`
--
ALTER TABLE `discarded_items`
  MODIFY `discard_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `forwarded_reports`
--
ALTER TABLE `forwarded_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `item_assigneds`
--
ALTER TABLE `item_assigneds`
  MODIFY `assign_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `item_assignments`
--
ALTER TABLE `item_assignments`
  MODIFY `assign_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item_requests`
--
ALTER TABLE `item_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item_table`
--
ALTER TABLE `item_table`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

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

--
-- Constraints for table `item_assignments`
--
ALTER TABLE `item_assignments`
  ADD CONSTRAINT `fk_item` FOREIGN KEY (`item_id`) REFERENCES `item_table` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
