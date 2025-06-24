<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    HttpSession Httpsession = request.getSession(false);
    if (Httpsession == null || !"student".equals(Httpsession.getAttribute("userRole"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    String studentName = (String) Httpsession.getAttribute("studentName");
    int studentRollNo = (int) Httpsession.getAttribute("studentRollNo");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="CSS/index.css">
    <link rel="stylesheet" href="CSS/studentDashboardCSS.css">
</head>
<body>

<header class="header">
    <div class="container">
        <h1 class="logo">Student Portal</h1>
        <nav class="nav">
            <a href="index.jsp">Home</a>
            <a href="index.jsp">Features</a>
            <a href="index.jsp">Contact</a>
            <a href="logout" class="logout-link">Logout</a>
        </nav>
    </div>
</header>

<div class="dashboard-container">
    <h2>Welcome, <%= studentName %> 👋</h2>
    <p class="welcome-message">Please confirm your Date of Birth to view your result.</p>

    <form action="fetchResult" method="post" class="result-form">
        <label for="rollno">Roll Number</label>
        <input type="text" id="rollno" name="rollno_display" value="<%= studentRollNo %>" readonly>

        <label for="dob">Date of Birth</label>
        <input type="date" id="dob" name="dob" required>

        <button type="submit">View Results</button>
    </form>
</div>

</body>
</html>
