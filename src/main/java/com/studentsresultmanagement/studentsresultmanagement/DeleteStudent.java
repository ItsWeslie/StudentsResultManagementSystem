package com.studentsresultmanagement.studentsresultmanagement;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/delete")
public class DeleteStudent extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("student-id"));

        Map<String, Object> responseMap = new HashMap<>();

        try (Connection conn = DBSetup.getConnection("studentsresult")) {
           boolean deleteSuccess = Statements.deleteStudent(conn, id);
            List<Student> studentList = Statements.fetchStudents(conn);

            responseMap.put("status", deleteSuccess ? "success" : "failure");
            responseMap.put("message", deleteSuccess ? "Student deleted successfully." : "Failed to delete student.");
            responseMap.put("students", studentList);  // Send updated student list


        } catch (Exception e) {
            e.printStackTrace();
            responseMap.put("status", "error");
            responseMap.put("message", "Server error while deleting student.");
        }
        Gson gson = new Gson();
        String jsonResponse = gson.toJson(responseMap);
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();

    }
}
