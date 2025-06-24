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
import java.util.List;

@WebServlet("/search")
public class SearchService extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String rollno = req.getParameter("rollno");
        String studclass = req.getParameter("studclass");

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        try (Connection conn = DBSetup.getConnection("studentsresult")) {

            List<Student> searchList = null;

            if (rollno != null && !rollno.trim().isEmpty()) {
                searchList = Statements.getStudentByRollno(conn, Integer.parseInt(rollno));
            } else if (studclass != null && !studclass.trim().isEmpty()) {
                searchList = Statements.getStudentsByClass(conn, studclass);
            }

            Gson gson = new Gson();
            String json = gson.toJson(searchList != null ? searchList : List.of());
            out.print(json);

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"An internal error occurred.\"}");
        }

        out.flush();
    }
}
