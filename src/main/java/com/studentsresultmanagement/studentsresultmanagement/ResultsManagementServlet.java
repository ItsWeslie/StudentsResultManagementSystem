package com.studentsresultmanagement.studentsresultmanagement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/result")
@MultipartConfig
public class ResultsManagementServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            // Validate and parse input parameters
            String rollStr = req.getParameter("student-rollno");
            String tamilStr = req.getParameter("student-tamil-mark");
            String englishStr = req.getParameter("student-english-mark");
            String mathsStr = req.getParameter("student-maths-mark");
            String scienceStr = req.getParameter("student-science-mark");
            String socialStr = req.getParameter("student-social-mark");

            if (rollStr == null || tamilStr == null || englishStr == null || mathsStr == null
                    || scienceStr == null || socialStr == null ||
                    rollStr.isEmpty() || tamilStr.isEmpty() || englishStr.isEmpty() || mathsStr.isEmpty()
                    || scienceStr.isEmpty() || socialStr.isEmpty()) {

                out.print("{\"status\":\"failure\", \"message\":\"Missing or empty form fields.\"}");
                return;
            }

            int rollno = Integer.parseInt(rollStr);
            int tamil = Integer.parseInt(tamilStr);
            int english = Integer.parseInt(englishStr);
            int maths = Integer.parseInt(mathsStr);
            int science = Integer.parseInt(scienceStr);
            int social = Integer.parseInt(socialStr);

            try (Connection conn = DBSetup.getConnection("studentsresult")) {

                // Check if student roll number exists
                PreparedStatement checkStudent = conn.prepareStatement("SELECT 1 FROM student WHERE rollno = ?");
                checkStudent.setInt(1, rollno);
                ResultSet rs = checkStudent.executeQuery();

                if (!rs.next()) {
                    out.print("{\"status\":\"failure\", \"message\":\"Student with this roll number does not exist.\"}");
                    return;
                }

                // Proceed to insert result
                int status = Statements.setResultDetails(conn, rollno, tamil, english, maths, science, social);

                String message = (status == 1) ? "Result added successfully!" : "Failed to add result.";
                String responseStatus = (status == 1) ? "success" : "failure";
                String jsonResponse = String.format("{\"status\":\"%s\", \"message\":\"%s\"}", responseStatus, message);
                out.print(jsonResponse);
            }

        } catch (NumberFormatException nfe) {
            nfe.printStackTrace();
            out.print("{\"status\":\"failure\", \"message\":\"Invalid number format in one of the fields.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"failure\", \"message\":\"An error occurred while adding the result.\"}");
        }
    }
}
