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
import java.util.Map;

@WebServlet("/overallstats")
public class OverallViewDataLoading extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (Connection conn = DBSetup.getConnection("studentsresult")) {
            int totalNoOfStudents = Statements.getTotalNoOfStudents(conn);
            int totalNoOfPass = Statements.getTotalNoOfPass(conn);
            int totalNoOfFail = Statements.getTotalNoOfFail(conn);
            Map<String, Double> avgMarks = Statements.getAverageMarks(conn);

            Map<String, Object> stats = new HashMap<>();
            stats.put("total", totalNoOfStudents);
            stats.put("passed", totalNoOfPass);
            stats.put("failed", totalNoOfFail);
            stats.put("averages",avgMarks);

            // Convert to JSON
            Gson gson = new Gson();
            String json = gson.toJson(stats);

            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();


        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to fetch stats\"}");

        }
    }

}
