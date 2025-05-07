<%--
  Created by IntelliJ IDEA.
  User: 91763
  Date: 29-04-2025
  Time: 11:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student & Results Management</title>
    <link rel="stylesheet" href="CSS/AdminDashCSS.css">
</head>
<body>
<div class="container">
    <header>
        <h1>Student & Results Management</h1>
    </header>
    <div class="dashboard-links">
        <button id="student-dashboard-btn">Manage Students</button>
        <button id="results-dashboard-btn">Manage Results</button>
    </div>
    <!-- Student Management Section -->
    <div id="student-section" class="content">
        <form id="student-form">
            <h2>Add / Update Student</h2>
            <input type="hidden" id="student-id">
            <input type="text" id="student-name" placeholder="Name" required>
            <input type="date" id="student-dob" placeholder="Date of Birth" required>
            <input type="email" id="student-email" placeholder="Email" required>
            <input type="text" id="student-phone" placeholder="Phone" required>
            <button type="submit">Save</button>
        </form>
        <div class="table-container">
            <h2>Student Records</h2>
            <table id="student-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Date of Birth</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <!-- Dynamic rows -->
                </tbody>
            </table>
        </div>
    </div>
    <!-- Results Management Section -->
    <div id="results-section" class="content hidden">
        <form id="results-form">
            <h2>Add / Update Results</h2>
            <input type="hidden" id="result-id">
            <input type="number" id="stud-id" placeholder="Student ID" required>
            <input type="text" id="subject" placeholder="Subject" required>
            <input type="number" id="marks" placeholder="Marks" required>
            <input type="text" id="semester" placeholder="Semester" required>
            <button type="submit">Save</button>
        </form>
        <div class="table-container">
            <h2>Results Records</h2>
            <table id="results-table">
                <thead>
                <tr>
                    <th>Result ID</th>
                    <th>Student ID</th>
                    <th>Subject</th>
                    <th>Marks</th>
                    <th>Semester</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <!-- Dynamic rows -->
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
    // Initial data arrays
    const students = [];
    const results = [];

    // Switching between dashboards
    document.getElementById("student-dashboard-btn").addEventListener("click", () => {
        document.getElementById("student-section").classList.remove("hidden");
        document.getElementById("results-section").classList.add("hidden");
    });

    document.getElementById("results-dashboard-btn").addEventListener("click", () => {
        document.getElementById("results-section").classList.remove("hidden");
        document.getElementById("student-section").classList.add("hidden");
    });

    /* ------------------- Student Management ------------------- */
    // Form submit event for students
    document.getElementById("student-form").addEventListener("submit", function (e) {
        e.preventDefault();

        const id = document.getElementById("student-id").value;
        const name = document.getElementById("student-name").value;
        const dob = document.getElementById("student-dob").value;
        const email = document.getElementById("student-email").value;
        const phone = document.getElementById("student-phone").value;

        if (id) {
            // Update existing student
            const index = students.findIndex((student) => student.id === parseInt(id));
            if (index !== -1) {
                students[index] = { id: parseInt(id), name, dob, email, phone };
            }
        } else {
            // Add new student
            const newId = students.length ? students[students.length - 1].id + 1 : 1;
            students.push({ id: newId, name, dob, email, phone });
        }

        resetStudentForm();
        renderStudentTable();
    });

    // Render student table
    function renderStudentTable() {
        const tableBody = document.querySelector("#student-table tbody");
        tableBody.innerHTML = "";

        students.forEach((student) => {
            const row = document.createElement("tr");

            row.innerHTML = `
            <td>${student.id}</td>
            <td>${student.name}</td>
            <td>${student.dob}</td>
            <td>${student.email}</td>
            <td>${student.phone}</td>
            <td class="actions">
                <button class="edit" onclick="editStudent(${student.id})">Edit</button>
                <button class="delete" onclick="deleteStudent(${student.id})">Delete</button>
            </td>
        `;

            tableBody.appendChild(row);
        });
    }

    // Edit student
    function editStudent(id) {
        const student = students.find((student) => student.id === id);
        if (student) {
            document.getElementById("student-id").value = student.id;
            document.getElementById("student-name").value = student.name;
            document.getElementById("student-dob").value = student.dob;
            document.getElementById("student-email").value = student.email;
            document.getElementById("student-phone").value = student.phone;
        }
    }

    // Delete student
    function deleteStudent(id) {
        const index = students.findIndex((student) => student.id === id);
        if (index !== -1) {
            students.splice(index, 1);
            renderStudentTable();
        }
    }

    // Reset student form
    function resetStudentForm() {
        document.getElementById("student-id").value = "";
        document.getElementById("student-form").reset();
    }

    /* ------------------- Results Management ------------------- */
    // Form submit event for results
    document.getElementById("results-form").addEventListener("submit", function (e) {
        e.preventDefault();

        const resultId = document.getElementById("result-id").value;
        const studId = parseInt(document.getElementById("stud-id").value);
        const subject = document.getElementById("subject").value;
        const marks = parseInt(document.getElementById("marks").value);
        const semester = document.getElementById("semester").value;

        if (!students.some((student) => student.id === studId)) {
            alert("Student ID not found. Please add the student first.");
            return;
        }

        if (resultId) {
            // Update existing result
            const index = results.findIndex((result) => result.result_id === parseInt(resultId));
            if (index !== -1) {
                results[index] = { result_id: parseInt(resultId), stud_id: studId, subject, marks, semester };
            }
        } else {
            // Add new result
            const newResultId = results.length ? results[results.length - 1].result_id + 1 : 1;
            results.push({ result_id: newResultId, stud_id: studId, subject, marks, semester });
        }

        resetResultsForm();
        renderResultsTable();
    });

    // Render results table
    function renderResultsTable() {
        const tableBody = document.querySelector("#results-table tbody");
        tableBody.innerHTML = "";

        results.forEach((result) => {
            const row = document.createElement("tr");

            row.innerHTML = `
            <td>${result.result_id}</td>
            <td>${result.stud_id}</td>
            <td>${result.subject}</td>
            <td>${result.marks}</td>
            <td>${result.semester}</td>
            <td class="actions">
                <button class="edit" onclick="editResult(${result.result_id})">Edit</button>
                <button class="delete" onclick="deleteResult(${result.result_id})">Delete</button>
            </td>
        `;

            tableBody.appendChild(row);
        });
    }

    // Edit result
    function editResult(resultId) {
        const result = results.find((result) => result.result_id === resultId);
        if (result) {
            document.getElementById("result-id").value = result.result_id;
            document.getElementById("stud-id").value = result.stud_id;
            document.getElementById("subject").value = result.subject;
            document.getElementById("marks").value = result.marks;
            document.getElementById("semester").value = result.semester;
        }
    }

    // Delete result
    function deleteResult(resultId) {
        const index = results.findIndex((result) => result.result_id === resultId);
        if (index !== -1) {
            results.splice(index, 1);
            renderResultsTable();
        }
    }

    // Reset results form
    function resetResultsForm() {
        document.getElementById("result-id").value = "";
        document.getElementById("results-form").reset();
    }

</script>
</body>
</html>

