<%--
  Created by IntelliJ IDEA.
  User: 91763
  Date: 28-04-2025
  Time: 22:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>z
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="CSS/dashboardCSS.css">
</head>
<body>
<div class="container">
    <h1>Student Dashboard</h1>
    <!-- Welcome Section -->
    <div class="welcome-message">
        <p>Welcome, <span class="user-name">John Doe</span>!</p>
    </div>
    <div class="dashboard">
        <div class="card">
            <a href="" id="view-results">View Results</a>
        </div>
    </div>
</div>
<script>
    document.getElementById("view-results")?.addEventListener("click", function (event) {
        event.preventDefault(); // Prevent default anchor action
        window.location.href = "results.jsp"; // Redirect to results.html
    });
</script>
</body>
</html>
