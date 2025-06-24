package com.studentsresultmanagement.studentsresultmanagement;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/update")
public class UpdateStudent extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("application/json");

        // Read JSON from request body
        BufferedReader reader = req.getReader();
        Gson gson = new Gson();
        JsonObject json = gson.fromJson(reader, JsonObject.class);

        int id = json.get("id").getAsInt();
        String name = json.get("name").getAsString();
        int rollno = json.get("rollno").getAsInt();
        String studclass = json.get("studclass").getAsString();
        String email = json.get("email").getAsString();
        String phone = json.get("phone").getAsString();
        String dob = json.get("dob").getAsString();
        String gender = json.get("gender").getAsString();

        Map<String, Object> responseMap = new HashMap<>();

        try (Connection conn = DBSetup.getConnection("studentsresult")) {
            boolean updateStatus = Statements.updateStudent(conn, id, name, rollno, studclass, dob, gender, email, phone);
            List<Student> studentList = Statements.fetchStudents(conn);

            if (updateStatus) {
                responseMap.put("students", studentList); // send as array, not string!
                responseMap.put("status", "success");
                responseMap.put("message", "Student updated successfully");
            } else {
                responseMap.put("status", "failure");
                responseMap.put("message", "Update failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            responseMap.put("status", "failure");
            responseMap.put("message", "Server error");
        }

        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(responseMap));
        out.flush();
    }
}