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
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;


@WebServlet("/subjectstats")
public class SujectStatsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Map<String, Double>> result = new HashMap<>();

        String query = "SELECT " +
                "ROUND(AVG(tamil), 2) AS avg_tamil, MAX(tamil) AS max_tamil, MIN(tamil) AS min_tamil, " +
                "ROUND(AVG(english), 2) AS avg_english, MAX(english) AS max_english, MIN(english) AS min_english, " +
                "ROUND(AVG(maths), 2) AS avg_maths, MAX(maths) AS max_maths, MIN(maths) AS min_maths, " +
                "ROUND(AVG(science), 2) AS avg_science, MAX(science) AS max_science, MIN(science) AS min_science, " +
                "ROUND(AVG(social_science), 2) AS avg_social, MAX(social_science) AS max_social, MIN(social_science) AS min_social " +
                "FROM results";

        try (Connection conn = DBSetup.getConnection("studentsresult");
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                result.put("Tamil", Map.of(
                        "average", rs.getDouble("avg_tamil"),
                        "max", rs.getDouble("max_tamil"),
                        "min", rs.getDouble("min_tamil")
                ));
                result.put("English", Map.of(
                        "average", rs.getDouble("avg_english"),
                        "max", rs.getDouble("max_english"),
                        "min", rs.getDouble("min_english")
                ));
                result.put("Maths", Map.of(
                        "average", rs.getDouble("avg_maths"),
                        "max", rs.getDouble("max_maths"),
                        "min", rs.getDouble("min_maths")
                ));
                result.put("Science", Map.of(
                        "average", rs.getDouble("avg_science"),
                        "max", rs.getDouble("max_science"),
                        "min", rs.getDouble("min_science")
                ));
                result.put("Social_Science", Map.of(
                        "average", rs.getDouble("avg_social"),
                        "max", rs.getDouble("max_social"),
                        "min", rs.getDouble("min_social")
                ));
            }

            Gson gson = new Gson();
            String json = gson.toJson(result);

            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to fetch subject statistics\"}");
        }
    }
}
