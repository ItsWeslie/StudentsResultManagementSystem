<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.studentsresultmanagement.studentsresultmanagement.Results" %>
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
    String studentRollNo = String.valueOf(Httpsession.getAttribute("studentRollNo"));
    List<Results> resultsList = (List<Results>) Httpsession.getAttribute("results");

    // Assuming all results have same class, take from first result
    String studentClass = resultsList != null && !resultsList.isEmpty() ? resultsList.get(0).getStudclass() : "N/A";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Result</title>
    <link rel="stylesheet" href="CSS/resultCSS.css">
</head>
<body>

<h2>Result for <%= studentName %></h2>

<div class="student-info">
    Roll No: <strong><%= studentRollNo %></strong> |
    Class: <strong><%= studentClass %></strong>
</div>

<table>
    <thead>
    <tr>
        <th>Subject</th>
        <th>Marks</th>
    </tr>
    </thead>
    <tbody>
    <% if (resultsList != null && !resultsList.isEmpty()) {
        // Display marks from the first result (assuming one result per student)
        Results r = resultsList.get(0);
    %>
    <tr><td class="subject">Tamil</td><td class="marks"><%= r.getTamil() %></td></tr>
    <tr><td class="subject">English</td><td class="marks"><%= r.getEnglish() %></td></tr>
    <tr><td class="subject">Maths</td><td class="marks"><%= r.getMaths() %></td></tr>
    <tr><td class="subject">Science</td><td class="marks"><%= r.getScience() %></td></tr>
    <tr><td class="subject">Social Science</td><td class="marks"><%= r.getSocial_science() %></td></tr>
    <tr><td class="subject">Total Marks</td><td class="marks"><%= r.getTotal_marks() %></td></tr>
    <tr><td class="subject">Status</td><td class="marks"><%= r.getStatus() %></td></tr>
    <% } else { %>
    <tr><td colspan="2" style="text-align:center; padding: 20px;">No results available</td></tr>
    <% } %>
    </tbody>
</table>
</body>
</html>
