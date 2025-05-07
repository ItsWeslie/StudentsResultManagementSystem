<%--
  Created by IntelliJ IDEA.
  User: 91763
  Date: 28-04-2025
  Time: 22:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="CSS/dashboardCSS.css">
</head>
<body>
<div class="container">
    <h1>Admin Dashboard</h1>
    <div class="dashboard">
        <div class="card">
            <a href="dashBoard.jsp" id="manage-students">Manage Details and Result</a>
        </div>
        <div class="card">
            <a href="viewStudents.jsp" id="view-students">View Students</a>
        </div>
    </div>
</div>
<script>
    document.getElementById("view-students")?.addEventListener("click", function (event) {
        event.preventDefault(); // Prevent default anchor action
        window.location.href = "viewStudents.jsp"; // Redirect to results.html
        fetchStudentData();
    });
</script>
</body>
</html>

