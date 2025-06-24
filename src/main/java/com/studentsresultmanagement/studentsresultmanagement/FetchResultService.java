package com.studentsresultmanagement.studentsresultmanagement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;

@WebServlet("/fetchResult")
public class FetchResultService extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        if (session == null || !"student".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect("index.jsp");
            return;
        }

        String rollno = String.valueOf(session.getAttribute("studentRollNo"));
        String dob = req.getParameter("dob");
        List<Results> studentResults = null;

        try (Connection conn = DBSetup.getConnection("studentsresult")) {
            boolean isValid = Statements.findStudentByRollNoAndDob(conn, rollno, dob);
            if (isValid) {
                studentResults = Statements.fetchResultByRollNo(conn, rollno);
                session.setAttribute("results", studentResults);
                resp.sendRedirect("results.jsp");
                return;
            } else {
                out.write("{\"error\": \"Invalid DOB\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"error\": \"Internal error occurred\"}");
        }
    }
}
