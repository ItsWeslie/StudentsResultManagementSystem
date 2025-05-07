package com.studentsresultmanagement.studentsresultmanagement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/manage")
public class ManageStudents extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("student-name");
        String dob = req.getParameter("student-dob");
        String StudEmail = req.getParameter("student-email");
        String StudPhone = req.getParameter("student-phone");

        try(Connection conn = DBSetup.getConnection("studentsResult")) {

           boolean status = Statements.setStudentDetails(conn, name, dob, StudEmail, StudPhone);
           if(status)
           {
               System.out.println("Student details updated successfully");
           }
           else
           {
               System.out.println("Student details update failed");
           }

        }
        catch (Exception e) {
            e.printStackTrace();
        }


    }
}
