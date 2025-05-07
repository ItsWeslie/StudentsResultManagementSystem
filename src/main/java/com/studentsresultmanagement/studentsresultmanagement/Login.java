package com.studentsresultmanagement.studentsresultmanagement;

import java.io.*;
import java.sql.Connection;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/login")
public class Login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try(Connection conn = DBSetup.getConnection("studentsResult")){
            String hashedPassword = Statements.hashPassword(password);
            ResultSet rs = Statements.getUsersDetails(conn, email, hashedPassword);

            if (rs != null) {
                while(rs.next()) {
                    if (rs.getString(5).equals("admin")) {
                        resp.sendRedirect("adminDash.jsp");
                    } else if (rs.getString(5).equals("student")) {
                        resp.sendRedirect("studentDash.jsp");
                    } else {
                        resp.sendRedirect("login.jsp?error=invalid");
                    }
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
}