package com.studentsresultmanagement.studentsresultmanagement;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/login")
public class Login extends HttpServlet {

    private static class JsonResponse {
        String status;
        String message;
        String redirect;

        JsonResponse(String status, String message, String redirect) {
            this.status = status;
            this.message = message;
            this.redirect = redirect;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        Gson gson = new Gson();

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String dob = req.getParameter("dob");

        try (Connection conn = DBSetup.getConnection("studentsresult")) {
            HttpSession session = req.getSession();

            if (password != null && !password.isEmpty()) {
                String hashed = Statements.hashPassword(password);
                ResultSet rs = Statements.getUsersDetails(conn, email, hashed);

                if (rs != null && rs.next()) {
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("userName", rs.getString("name"));
                    session.setAttribute("userRole", "staff");

                    out.print(gson.toJson(new JsonResponse("success", null, "admin-dash")));
                } else {
                    out.print(gson.toJson(new JsonResponse("error", "Invalid staff credentials.", null)));
                }

            } else if (dob != null && !dob.isEmpty()) {
                ResultSet rs = Statements.getStudentDetails(conn, email, dob);
                int rollno=0;

                if (rs != null && rs.next()) {
                    session.setAttribute("studentId", rs.getInt("id"));
                    session.setAttribute("studentName", rs.getString("name"));
                    session.setAttribute("studentRollNo",  rollno=rs.getInt("rollno"));
                    session.setAttribute("userRole", "student");

                    out.print(gson.toJson(new JsonResponse("success", rollno==0? "roll no is 0" : "roll no is"+rollno , "studentDash.jsp")));
                } else {
                    out.print(gson.toJson(new JsonResponse("error", "Invalid student credentials.", null)));
                }

            } else {
                out.print(gson.toJson(new JsonResponse("error", "Missing login fields.", null)));
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print(gson.toJson(new JsonResponse("error", "Date of Birth not given properly or invalid email.", null)));
        }

        out.flush();
    }
}
