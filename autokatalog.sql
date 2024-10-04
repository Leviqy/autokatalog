-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 04. Okt 2024 um 11:31
-- Server-Version: 10.4.24-MariaDB
-- PHP-Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `autokatalog`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `accessories`
--

CREATE TABLE `accessories` (
  `accessory_id` int(11) NOT NULL,
  `accessory_name` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `model_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `accessories`
--

INSERT INTO `accessories` (`accessory_id`, `accessory_name`, `price`, `model_id`) VALUES
(1, 'Leather Seats', '1200.00', 1),
(2, 'Navigation System', '800.00', 3),
(3, 'Leather Seats', '1200.00', 1),
(4, 'Navigation System', '800.00', 3),
(5, 'Leather Seats', '1200.00', 1),
(6, 'Navigation System', '800.00', 3);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `brands`
--

CREATE TABLE `brands` (
  `brand_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `brands`
--

INSERT INTO `brands` (`brand_id`, `name`) VALUES
(1, 'Toyota'),
(2, 'BMW'),
(3, 'Mercedes-Benz'),
(4, 'Tesla'),
(5, 'Toyota'),
(6, 'BMW'),
(7, 'Audi');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `carmodels`
--

CREATE TABLE `carmodels` (
  `model_id` int(11) NOT NULL,
  `model_name` varchar(50) NOT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `carmodels`
--

INSERT INTO `carmodels` (`model_id`, `model_name`, `brand_id`, `year`) VALUES
(1, 'Corolla', 1, 2020),
(2, 'Camry', 1, 2021),
(3, '3 Series', 2, 2021),
(4, 'X5', 2, 2022),
(5, 'C-Class', 3, 2022),
(6, 'GLE', 3, 2023),
(7, 'Model S', 4, 2021),
(8, 'Model X', 4, 2022),
(9, 'Corolla', 1, 2024),
(10, 'X5', 2, 2023),
(11, 'A4', 3, 2024);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `customers`
--

INSERT INTO `customers` (`customer_id`, `name`, `email`, `phone`, `address`) VALUES
(1, 'John Doe', 'john.doe@example.com', '555-1234', '123 Elm Street, Springfield'),
(2, 'Jane Smith', 'jane.smith@example.com', '555-5678', '456 Oak Avenue, Springfield'),
(3, 'John Doe', 'john.doe@example.com', '555-1234', '123 Elm Street, Springfield'),
(4, 'Jane Smith', 'jane.smith@example.com', '555-5678', '456 Oak Avenue, Springfield'),
(5, 'John Doe', 'john.doe@example.com', '555-1234', '123 Elm Street, Springfield'),
(6, 'Jane Smith', 'jane.smith@example.com', '555-5678', '456 Oak Avenue, Springfield');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `engines`
--

CREATE TABLE `engines` (
  `engine_id` int(11) NOT NULL,
  `engine_type` varchar(50) DEFAULT NULL,
  `horsepower` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `engines`
--

INSERT INTO `engines` (`engine_id`, `engine_type`, `horsepower`) VALUES
(1, 'Benzin', 150),
(2, 'Diesel', 200),
(3, 'Elektro', 250);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `maintenancelogs`
--

CREATE TABLE `maintenancelogs` (
  `log_id` int(11) NOT NULL,
  `model_id` int(11) DEFAULT NULL,
  `workshop_id` int(11) DEFAULT NULL,
  `maintenance_date` date DEFAULT NULL,
  `details` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `maintenancelogs`
--

INSERT INTO `maintenancelogs` (`log_id`, `model_id`, `workshop_id`, `maintenance_date`, `details`) VALUES
(1, 1, 1, '2024-03-01', 'Oil change and tire rotation'),
(2, 3, 2, '2024-04-15', 'Brake inspection and alignment'),
(3, 1, 1, '2024-03-01', 'Oil change and tire rotation'),
(4, 3, 2, '2024-04-15', 'Brake inspection and alignment'),
(5, 1, 1, '2024-03-01', 'Oil change and tire rotation'),
(6, 3, 2, '2024-04-15', 'Brake inspection and alignment');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `sales`
--

CREATE TABLE `sales` (
  `sale_id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `model_id` int(11) DEFAULT NULL,
  `sale_date` date DEFAULT NULL,
  `sale_price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `sales`
--

INSERT INTO `sales` (`sale_id`, `customer_id`, `model_id`, `sale_date`, `sale_price`) VALUES
(1, 1, 1, '2024-01-15', '20000.00'),
(2, 2, 3, '2024-02-20', '35000.00'),
(3, 1, 1, '2024-01-15', '20000.00'),
(4, 2, 3, '2024-02-20', '35000.00'),
(5, 1, 1, '2024-01-15', '20000.00'),
(6, 2, 3, '2024-02-20', '35000.00');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `specifications`
--

CREATE TABLE `specifications` (
  `specification_id` int(11) NOT NULL,
  `model_id` int(11) DEFAULT NULL,
  `engine_id` int(11) DEFAULT NULL,
  `transmission` varchar(50) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `specifications`
--

INSERT INTO `specifications` (`specification_id`, `model_id`, `engine_id`, `transmission`, `color`, `price`) VALUES
(1, 1, 1, 'Automatik', 'Rot', '20000.00'),
(2, 2, 2, 'Manuell', 'Blau', '30000.00'),
(3, 3, 1, 'Automatik', 'Schwarz', '35000.00'),
(4, 4, 2, 'Automatik', 'Weiß', '50000.00'),
(5, 5, 1, 'Manuell', 'Grau', '40000.00'),
(6, 6, 2, 'Automatik', 'Silber', '60000.00'),
(7, 7, 3, 'Automatik', 'Schwarz', '80000.00'),
(8, 8, 3, 'Automatik', 'Weiß', '100000.00');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `workshops`
--

CREATE TABLE `workshops` (
  `workshop_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `workshops`
--

INSERT INTO `workshops` (`workshop_id`, `name`, `address`, `phone`, `email`) VALUES
(1, 'Speedy Repairs', '789 Maple Drive, Springfield', '555-8765', 'contact@speedyrepairs.com'),
(2, 'Expert Auto Service', '101 Pine Street, Springfield', '555-4321', 'info@expertautoservice.com'),
(3, 'Speedy Repairs', '789 Maple Drive, Springfield', '555-8765', 'contact@speedyrepairs.com'),
(4, 'Expert Auto Service', '101 Pine Street, Springfield', '555-4321', 'info@expertautoservice.com'),
(5, 'Speedy Repairs', '789 Maple Drive, Springfield', '555-8765', 'contact@speedyrepairs.com'),
(6, 'Expert Auto Service', '101 Pine Street, Springfield', '555-4321', 'info@expertautoservice.com');

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `accessories`
--
ALTER TABLE `accessories`
  ADD PRIMARY KEY (`accessory_id`),
  ADD KEY `model_id` (`model_id`);

--
-- Indizes für die Tabelle `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`brand_id`);

--
-- Indizes für die Tabelle `carmodels`
--
ALTER TABLE `carmodels`
  ADD PRIMARY KEY (`model_id`),
  ADD KEY `brand_id` (`brand_id`);

--
-- Indizes für die Tabelle `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indizes für die Tabelle `engines`
--
ALTER TABLE `engines`
  ADD PRIMARY KEY (`engine_id`);

--
-- Indizes für die Tabelle `maintenancelogs`
--
ALTER TABLE `maintenancelogs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `model_id` (`model_id`),
  ADD KEY `workshop_id` (`workshop_id`);

--
-- Indizes für die Tabelle `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`sale_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `model_id` (`model_id`);

--
-- Indizes für die Tabelle `specifications`
--
ALTER TABLE `specifications`
  ADD PRIMARY KEY (`specification_id`),
  ADD KEY `model_id` (`model_id`),
  ADD KEY `engine_id` (`engine_id`);

--
-- Indizes für die Tabelle `workshops`
--
ALTER TABLE `workshops`
  ADD PRIMARY KEY (`workshop_id`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `accessories`
--
ALTER TABLE `accessories`
  MODIFY `accessory_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT für Tabelle `brands`
--
ALTER TABLE `brands`
  MODIFY `brand_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT für Tabelle `carmodels`
--
ALTER TABLE `carmodels`
  MODIFY `model_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT für Tabelle `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT für Tabelle `engines`
--
ALTER TABLE `engines`
  MODIFY `engine_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT für Tabelle `maintenancelogs`
--
ALTER TABLE `maintenancelogs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT für Tabelle `sales`
--
ALTER TABLE `sales`
  MODIFY `sale_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT für Tabelle `specifications`
--
ALTER TABLE `specifications`
  MODIFY `specification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT für Tabelle `workshops`
--
ALTER TABLE `workshops`
  MODIFY `workshop_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `accessories`
--
ALTER TABLE `accessories`
  ADD CONSTRAINT `accessories_ibfk_1` FOREIGN KEY (`model_id`) REFERENCES `carmodels` (`model_id`);

--
-- Constraints der Tabelle `carmodels`
--
ALTER TABLE `carmodels`
  ADD CONSTRAINT `carmodels_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`brand_id`);

--
-- Constraints der Tabelle `maintenancelogs`
--
ALTER TABLE `maintenancelogs`
  ADD CONSTRAINT `maintenancelogs_ibfk_1` FOREIGN KEY (`model_id`) REFERENCES `carmodels` (`model_id`),
  ADD CONSTRAINT `maintenancelogs_ibfk_2` FOREIGN KEY (`workshop_id`) REFERENCES `workshops` (`workshop_id`);

--
-- Constraints der Tabelle `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  ADD CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`model_id`) REFERENCES `carmodels` (`model_id`);

--
-- Constraints der Tabelle `specifications`
--
ALTER TABLE `specifications`
  ADD CONSTRAINT `specifications_ibfk_1` FOREIGN KEY (`model_id`) REFERENCES `carmodels` (`model_id`),
  ADD CONSTRAINT `specifications_ibfk_2` FOREIGN KEY (`engine_id`) REFERENCES `engines` (`engine_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
