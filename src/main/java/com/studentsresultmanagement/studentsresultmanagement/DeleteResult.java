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

@WebServlet("/deleteResult")
public class DeleteResult extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        resp.setContentType("application/json");

        // Read JSON from request body
        BufferedReader reader = req.getReader();
        Gson gson = new Gson();
        JsonObject json = gson.fromJson(reader, JsonObject.class);

        // Retrieve the result ID from the request body
        int resultId = json.get("result-id").getAsInt();

        Map<String, String> responseMap = new HashMap<>();

        try (Connection conn = DBSetup.getConnection("studentsresult")) {
            // Delete the result from the database using the ID
            boolean deleteStatus = Statements.deleteResult(conn, resultId);

            // If deletion is successful, retrieve the updated list of results
            List<Results> resultList = Statements.fetchResults(conn);
            String resultJson = gson.toJson(resultList);

            // Send response based on the delete status
            if (deleteStatus) {
                responseMap.put("results", resultJson);
                responseMap.put("status", "success");
                responseMap.put("message", "Result deleted successfully");
            } else {
                responseMap.put("status", "failure");
                responseMap.put("message", "Deletion failed");
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
