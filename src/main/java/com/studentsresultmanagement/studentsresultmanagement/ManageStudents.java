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


@WebServlet("/manage")
@MultipartConfig
public class ManageStudents extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String name = req.getParameter("student-name");
        int rollno = Integer.parseInt(req.getParameter("student-rollno"));
        String studclass = req.getParameter("student-class");
        String dob = req.getParameter("student-dob");
        String gender = req.getParameter("student-gender");
        String StudEmail = req.getParameter("student-email");
        String StudPhone = req.getParameter("student-phone");

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        try(Connection conn = DBSetup.getConnection("studentsresult")) {

           int status = Statements.setStudentDetails(conn, name,rollno,studclass ,dob,gender, StudEmail, StudPhone);

            String message = (status == 1) ? "Student added successfully!" : "Failed to add student.";
            String responseStatus = (status == 1) ? "success" : "failure";

            // Send JSON response
            String jsonResponse = String.format("{\"status\":\"%s\", \"message\":\"%s\"}", responseStatus, message);
            out.print(jsonResponse);
        }
        catch (Exception e) {
            e.printStackTrace();
            // Send error response in case of an exception
            String errorResponse = "{\"status\":\"failure\", \"message\":\"An error occurred while adding the student.\"}";
            out.print(errorResponse);
        }
    }


}
