package com.studentsresultmanagement.studentsresultmanagement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin-dash")
public class DataPreLoadingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection conn = DBSetup.getConnection("studentsresult")) {
            List<Student> studentList = Statements.fetchStudents(conn);
            req.setAttribute("student", studentList);

            List<Results> resultsList = Statements.fetchResults(conn);
            req.setAttribute("results", resultsList);
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("/adminDash.jsp").forward(req, resp);
    }
}
