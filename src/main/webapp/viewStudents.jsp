<%--
  Created by IntelliJ IDEA.
  User: 91763
  Date: 29-04-2025
  Time: 11:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Results</title>
    <link rel="stylesheet" href="CSS/viewStudents.css">
</head>
<body>
<div class="container">
    <h2>Student Details and Results</h2>
    <table id="student-results-table" class="styled-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Date of Birth</th>
            <th>Email</th>
            <th>Phone No</th>
            <th>Total Marks</th>
            <th>Grade</th>
        </tr>
        </thead>
        <tbody>
        <!-- Data will be dynamically inserted here -->
        </tbody>
    </table>
</div>
<script>
    // Fetch student data and populate the table
    async function fetchStudentData() {
        try {
            // Replace 'api/students' with your actual API endpoint
            const response = await fetch('http://localhost:3000/api/students');
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();
            populateTable(data);
        } catch (error) {
            console.error('Error fetching student data:', error);
        }
    }

    // Populate the table with fetched data
    function populateTable(students) {
        const tableBody = document.querySelector('#student-results-table tbody');
        tableBody.innerHTML = ''; // Clear existing rows

        students.forEach((student) => {
            const row = document.createElement('tr');

            const totalMarks = student.results.reduce((sum, result) => sum + result.marks, 0);
            const grade = calculateGrade(totalMarks);

            row.innerHTML = `
            <td>${student.id}</td>
            <td>${student.name}</td>
            <td>${student.dob}</td>
            <td>${student.email}</td>
            <td>${student.phone}</td>
            <td>${totalMarks}</td>
            <td>${grade}</td>
        `;

            tableBody.appendChild(row);
        });
    }

    // Calculate grade based on total marks
    function calculateGrade(totalMarks) {
        if (totalMarks >= 90) return 'A';
        if (totalMarks >= 75) return 'B';
        if (totalMarks >= 50) return 'C';
        return 'D';
    }

    // Initialize data fetching
    fetchStudentData();

</script>
</body>
</html>

