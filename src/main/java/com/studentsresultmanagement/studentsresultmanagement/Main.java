package com.studentsresultmanagement.studentsresultmanagement;

import java.sql.Connection;

public class Main {

    public static void main(String[] args) {

        try(Connection conn = DBSetup.getConnection("studentsresult")) {

            if(conn != null) {
                System.out.println("Connected to database");
            }
        }
        catch(Exception e) {
            e.printStackTrace();
        }
    }
}
