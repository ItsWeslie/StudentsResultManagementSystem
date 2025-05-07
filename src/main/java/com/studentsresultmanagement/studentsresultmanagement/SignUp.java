package com.studentsresultmanagement.studentsresultmanagement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/signup")
public class SignUp extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");
        Statements st= null;
        try(Connection conn = DBSetup.getConnection("studentsresult")) {
            st = new Statements();
            int status = st.setUserDetails(conn, name, email, password, role);
            if(status>0)
            {
                System.out.println("User has been registered successfully");
                resp.sendRedirect("login.jsp");
            }
            else
            {
                System.out.println("User has not been registered successfully");
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

    }
}
