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

@WebServlet("/updateResult")
public class UpdateResult extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        resp.setContentType("application/json");

        // Read JSON from request body
        BufferedReader reader = req.getReader();
        Gson gson = new Gson();
        JsonObject json = gson.fromJson(reader, JsonObject.class);

        // Retrieve the values from the JSON object
        int id = json.get("id").getAsInt();
        int rollno = json.get("rollno").getAsInt();
        String name = json.get("name").getAsString();
        String studclass = json.get("studclass").getAsString();
        int tamil = json.get("tamil").getAsInt();
        int english = json.get("english").getAsInt();
        int maths = json.get("maths").getAsInt();
        int science = json.get("science").getAsInt();
        int socialScience = json.get("social_science").getAsInt();


        Map<String, String> responseMap = new HashMap<>();

        try (Connection conn = DBSetup.getConnection("studentsresult")) {
            // Update the result in the database
            boolean updateStatus = Statements.updateResult(conn, id, rollno, name, studclass, tamil, english, maths,
                    science, socialScience);

            // If update is successful, retrieve the updated results
            List<Results> resultList = Statements.fetchResults(conn);
            String resultJson = gson.toJson(resultList);

            // Return response based on the update status
            if (updateStatus) {
                responseMap.put("results", resultJson);
                responseMap.put("status", "success");
                responseMap.put("message", "Result updated successfully");
            } else {
                responseMap.put("status", "failure");
                responseMap.put("message", "Update failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            responseMap.put("status", "failure");
            responseMap.put("message", "Server error");
        }

        // Send the response back to the client
        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(responseMap));
        out.flush();

    }
}
