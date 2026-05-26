# Hospital Management Database — SQL

## Overview

This project is a SQL-based Hospital Management Database System designed to simulate real hospital operations. It manages patients, doctors, appointments, billing, prescriptions, medical records, rooms, and audit tracking using a fully normalized relational database.

The project demonstrates advanced database administration concepts including:

* Views
* Triggers
* Stored Procedures
* Transactions
* User Roles & Permissions
* Indexing & Query Optimization

---

## Features

* 11 interconnected tables
* Fully normalized schema
* Foreign key relationships with cascade rules
* Automated triggers and audit logging
* Multi-table SQL views
* Transaction-based stored procedures
* Role-based access control
* Query optimization using indexes

---

## Technologies Used

* SQL
* MySQL
* MySQL Workbench

---

## Tables Included

* Patients
* Doctors
* Departments
* Rooms
* Appointments
* Medical Records
* Prescriptions
* Prescription Items
* Billing
* Billing Line Items
* Audit Log

---

## Views

* Doctor Schedule
* Patient Full History
* Overdue Bills
* Department Workload
* Revenue Summary
* Patient Summary

---

## Triggers

* Auto-update billing status
* Audit log generation
* Appointment cancellation handling

---

## Stored Procedures

### `book_appointment`

Creates appointments and billing records in a single transaction.

### `discharge_patient`

Completes discharge workflow and releases room allocation.

### `process_payment`

Validates and processes bill payments safely.

---

## Security & User Roles

* Doctor
* Receptionist
* Billing User
* Auditor

Each role has restricted database access using `GRANT` permissions.

---

## Indexing

Indexes are created on:

* Appointment Date
* Billing Status
* Billing Due Date
* Patient Phone
* Doctor Department

to improve query performance and reduce table scans.

---

## Project Structure

```bash id="f3t8px"
├── schema.sql
├── views.sql
├── triggers.sql
├── procedures.sql
├── indexes.sql
├── users.sql
├── sample_data.sql
└── README.md
```

---

## How to Run

1. Create the database
2. Execute all SQL scripts in MySQL Workbench
3. Test views, triggers, procedures, and user permissions

---

## Concepts Demonstrated

* Relational Database Design
* Normalization
* SQL Views
* Triggers
* Stored Procedures
* Transactions
* Access Control
* Query Optimization

---

## License

This project is licensed under the MIT License.
