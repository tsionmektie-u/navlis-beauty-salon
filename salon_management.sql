-- Tsion Mektie | Sample SQL portfolio project
-- MySQL/MariaDB; fictional practice data only.
CREATE DATABASE IF NOT EXISTS tsion_salon_portfolio;
USE tsion_salon_portfolio;
CREATE TABLE IF NOT EXISTS customers (
 customer_id INT AUTO_INCREMENT PRIMARY KEY,
 full_name VARCHAR(100) NOT NULL,
 phone VARCHAR(25),
 email VARCHAR(120) UNIQUE,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS services (
 service_id INT AUTO_INCREMENT PRIMARY KEY,
 service_name VARCHAR(100) NOT NULL,
 price DECIMAL(10,2) NOT NULL,
 duration_minutes INT NOT NULL
);
CREATE TABLE IF NOT EXISTS staff (
 staff_id INT AUTO_INCREMENT PRIMARY KEY,
 full_name VARCHAR(100) NOT NULL,
 role_title VARCHAR(80)
);
CREATE TABLE IF NOT EXISTS appointments (
 appointment_id INT AUTO_INCREMENT PRIMARY KEY,
 customer_id INT NOT NULL,
 service_id INT NOT NULL,
 staff_id INT NULL,
 appointment_datetime DATETIME NOT NULL,
 status ENUM('Booked','Completed','Cancelled','No-show') DEFAULT 'Booked',
 FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
 FOREIGN KEY(service_id) REFERENCES services(service_id),
 FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
);
INSERT INTO customers(full_name,phone,email) VALUES
('Sara Demo','0900000001','sara.demo@example.com'),
('Mimi Sample','0900000002','mimi.sample@example.com'),
('Hana Example','0900000003','hana.example@example.com')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);
INSERT INTO services(service_name,price,duration_minutes) VALUES
('Hair Styling',500,60),('Facial Treatment',750,75),('Manicure',350,45);
INSERT INTO staff(full_name,role_title) VALUES
('Staff Demo One','Stylist'),('Staff Demo Two','Beauty Therapist');
-- Example JOIN report
SELECT a.appointment_id,c.full_name AS customer,s.service_name,st.full_name AS staff,a.appointment_datetime,a.status
FROM appointments a JOIN customers c ON c.customer_id=a.customer_id
JOIN services s ON s.service_id=a.service_id LEFT JOIN staff st ON st.staff_id=a.staff_id;
-- Count appointments by status
SELECT status,COUNT(*) AS appointment_count FROM appointments GROUP BY status;
-- Average price
SELECT ROUND(AVG(price),2) AS average_service_price FROM services;
-- Most requested services
SELECT s.service_name,COUNT(a.appointment_id) AS bookings FROM services s
LEFT JOIN appointments a ON a.service_id=s.service_id GROUP BY s.service_id,s.service_name
ORDER BY bookings DESC;
-- Add a fictional test booking (run after inserts)
INSERT INTO appointments(customer_id,service_id,staff_id,appointment_datetime,status)
VALUES(1,1,1,'2026-11-01 10:00:00','Booked');
-- Practice CRUD (uncomment to test)
-- UPDATE appointments SET status='Completed' WHERE appointment_id=1;
-- DELETE FROM appointments WHERE appointment_id=1;
