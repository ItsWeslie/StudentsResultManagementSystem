package com.studentsresultmanagement.studentsresultmanagement;

import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
public class Statements {

    public static ResultSet getUsersDetails(Connection conn,String email,String password) throws SQLException{

        String query = "select * from users where email = ? and password = ?";
        try {
           PreparedStatement ps = conn.prepareStatement(query);
           ps.setString(1,email);
           ps.setString(2,password);
           ResultSet rs = ps.executeQuery();

           return rs;
        }
        catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error in getUsersDetails: ");
            return null;
        }

    }

    public static int setUserDetails(Connection con, String name, String email, String password, String role) {
        int status = 0;
        try {
            String hashedPassword = hashPassword(password);
            String query = "insert into users(name,email,password,role)" + "values(?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            ps.setString(4, role);
            status = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error in setUserDetails");
        }
        return status;
    }

    //Students management servlet code
    public static boolean setStudentDetails(Connection conn,String name,String dob,String email,String phone)
    {
        boolean status = false;
        try{
            String query = "insert into student(name,dob,email,phone)" + "values(?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1,name);
            ps.setString(2,dob);
            ps.setString(3,email);
            ps.setString(4,phone);
            status = ps.executeUpdate()>0;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("Error in setStudentDetails");
        }
        return status;
    }

    //password hashing code
    public static String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256"); // Hashing algorithm
        byte[] hash = md.digest(password.getBytes()); // Perform the hash

        // Convert byte array into hex string
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b); // Mask higher bits
            if (hex.length() == 1) hexString.append('0'); // Pad if necessary
            hexString.append(hex);
        }
        return hexString.toString();
    }
}