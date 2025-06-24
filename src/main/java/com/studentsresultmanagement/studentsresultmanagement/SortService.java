package com.studentsresultmanagement.studentsresultmanagement;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/sort")
public class SortService extends HttpServlet {

    private Student student;

    @Override
    public void init() throws ServletException {
        student = new Student();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        try(Connection conn = DBSetup.getConnection("studentsresult"))
        {


            String sort = req.getParameter("sort");  // name_asc, name_desc, etc.

            if (sort == null || sort.isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"Missing sort parameter\"}");
                return;
            }


            List<Student> students;


            switch (sort) {
                case "name_asc":
                    students = Statements.getStudentsSortedBy(conn, "name", true);
                    break;
                case "name_desc":
                    students = Statements.getStudentsSortedBy(conn, "name", false);
                    break;
                case "class":
                    students = Statements.getStudentsSortedBy(conn, "studclass", true);
                    break;
                default:
                    students = Statements.fetchStudents(conn);
            }

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            String json = new Gson().toJson(students);
            resp.getWriter().write(json);

        }
        catch (Exception e){
            e.printStackTrace();
        }

    }
}
