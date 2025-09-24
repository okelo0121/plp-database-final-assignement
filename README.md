# plp-database-final-assignement

# 📚 Database Management System Project

## 📝 Assignment Overview
This project is part of the **Database Management Systems** course assignment.  
The objective was to **design and implement a complete relational database** using MySQL based on a real-world scenario.

---

## 🎯 Objectives
- Design a relational database schema.
- Apply **normalization principles** for efficient data storage.
- Define **relationships** (One-to-One, One-to-Many, Many-to-Many).
- Use **SQL constraints** such as:
  - `PRIMARY KEY`
  - `FOREIGN KEY`
  - `NOT NULL`
  - `UNIQUE`

---

## 📂 Project Deliverables
- A single **answers.sql** file containing:
  1. `CREATE DATABASE` statement
  2. `CREATE TABLE` statements
  3. Relationship constraints

---

## 🏥 Use Case: Clinic Booking System
The system manages:
- **Patients**
- **Doctors**
- **Appointments**
- **Payments**

### 🔗 Relationships
- One **Doctor** can have many **Appointments**.  
- One **Patient** can book many **Appointments**.  
- Each **Appointment** can have one **Payment**.

---

## 🛠️ Database Setup

### 1. Create the Database
```sql
CREATE DATABASE ClinicDB;
USE ClinicDB;

2. Create Tables
-- Patients Table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    date_of_birth DATE
);

-- Doctors Table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50) NOT NULL
);

-- Appointments Table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

🚀 How to Run

Open MySQL Workbench (or any SQL client).

Copy and paste the contents of answers.sql.

Run the script to create the database and tables.

Verify using:

SHOW DATABASES;
SHOW TABLES;

👤 Author

Name: Okelo Ulak Angelo

Course: Database Management Systems

Date: September 2025


---

⚡ Question: Do you want me to also add **sample data insertion queries (INSERT)** into this README so your instructor can test it easily, or should I keep it just with the schema?
