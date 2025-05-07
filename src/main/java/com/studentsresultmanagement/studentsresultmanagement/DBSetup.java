package com.studentsresultmanagement.studentsresultmanagement;

import java.sql.*;
import com.mysql.cj.jdbc.MysqlDataSource;
public class DBSetup {
    private static String URL = "jdbc:mysql://localhost:3306/";
    private static String USERNAME="root";
    private static String PASSWORD="SamWeslie@14";

    public static Connection getConnection(String dbName) throws SQLException, ClassNotFoundException {
        MysqlDataSource ds = null;
        Connection conn = null;

        try {
            ds = new MysqlDataSource();
            ds.setURL(URL + dbName);
            ds.setUser(USERNAME);
            ds.setPassword(PASSWORD);
            conn = ds.getConnection();


        } catch (Exception e) {
            e.printStackTrace();
        }

        return conn;
    }
}
