package com.studentsresultmanagement.studentsresultmanagement;

import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Statements {

    //Getting User details functionality
    public static ResultSet getUsersDetails(Connection conn,String email,String password){

        String query = "select * from users where email = ? and password = ?";
        try {
           PreparedStatement ps = conn.prepareStatement(query);
           ps.setString(1,email);
           ps.setString(2,password);
           return ps.executeQuery();
        }
        catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error in getUsersDetails");
            return null;
        }

    }

    //Getting Student details functionality
    public static ResultSet getStudentDetails(Connection conn, String email, String dob){
        try {
            String query = "SELECT * FROM student WHERE email=? AND dob=?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, dob);
            return ps.executeQuery();
        }
        catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error in getStudentDetails");
            return null;
        }
    }

    //Functionality for setting up user data
    public static int setUserDetails(Connection con, String name, String email, String password){
        int status = 0;
        try {
            String hashedPassword = hashPassword(password);
            String query = "insert into users(name,email,password)" + "values(?,?,?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            status = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error in setUserDetails");
        }
        return status;
    }

    //Students management servlet code -> adding students
    public static int setStudentDetails(Connection conn,String name,int rollno,String studclass,String dob,String gender,String email,String phone)
    {
        int status = 0;
        try{
            String query = "insert into student(name,rollno,studclass,dob,gender,email,phone)" + "values(?,?,?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1,name);
            ps.setInt(2,rollno);
            ps.setString(3,studclass);
            ps.setString(4,dob);
            ps.setString(5,gender);
            ps.setString(6,email);
            ps.setString(7,phone);
            status = ps.executeUpdate();
        }
        catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("Error in setStudentDetails");
        }
        return status;
    }


    //Update student details
    public static boolean updateStudent(Connection conn,int id,String name,int rollno,String studclass,String dob,String gender,String email,String phone)
    {
        String query = "update student set name=?,rollno=?,studclass=?,dob=?,gender=?,email=?,phone=? where id=?";
        try(PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1,name);
            ps.setInt(2,rollno);
            ps.setString(3,studclass);
            ps.setString(4,dob);
            ps.setString(5,gender);
            ps.setString(6,email);
            ps.setString(7,phone);
            ps.setInt(8,id);
            int status = ps.executeUpdate();
            return status == 1;
        }
        catch (Exception e) {
             e.printStackTrace();
             System.out.println("Error in updateStudent: ");
             return false;
        }
    }

    //Delete students using id
    public static boolean deleteStudent(Connection conn,int id)
    {
        String query = "delete from student where id = ?";
        try{
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1,id);
            int status = ps.executeUpdate();
            return status == 1;
        }
        catch(Exception e){
            e.printStackTrace();
            System.out.println("Error in deleteStudent: ");
        }

        return false;
    }




    //Returning Table of content data
    public static List<Student> fetchStudents(Connection conn) {
        List<Student> studentList = new ArrayList<>();
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM student");
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                int rollno = rs.getInt("rollno");
                String className = rs.getString("studclass");
                String dob = rs.getString("dob");
                String gender = rs.getString("gender");
                String email = rs.getString("email");
                String phone = rs.getString("phone");

                Student student = new Student(id, name,rollno,className, dob,gender, email, phone);
                studentList.add(student);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return studentList;
    }


    //Result management section -> adding results of the students

    public static int setResultDetails(Connection conn,int rollno,int tamil,int english,int maths,int science,int social)
    {
        int status = 0;
        try{
            String query = "insert into results(rollno,tamil,english,maths,science,social_science)" + "values(?,?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1,rollno);
            ps.setInt(2,tamil);
            ps.setInt(3,english);
            ps.setInt(4,maths);
            ps.setInt(5,science);
            ps.setInt(6,social);
            status = ps.executeUpdate();
        }
        catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("Error in setResultDetails");
        }
        return status;
    }

    public static boolean updateResult(Connection conn,int id,int rollno,String name,String studclass,int tamil,int english,int maths,int science,int social_science)
    {
        String query1 = "update student set name=?,studclass=? where rollno=?";
        String query2 ="update results set tamil=?,english=?,maths=?,science=?,social_science=? where rollno=?";
        try{
            PreparedStatement ps = conn.prepareStatement(query1);

            ps.setString(1,name);
            ps.setString(2,studclass);
            ps.setInt(3,rollno);
            int flag1 = ps.executeUpdate();

            PreparedStatement ps1 = conn.prepareStatement(query2);
            ps1.setInt(1,tamil);
            ps1.setInt(2,english);
            ps1.setInt(3,maths);
            ps1.setInt(4,science);
            ps1.setInt(5,social_science);
            ps1.setInt(6,rollno);
            int flag2 = ps1.executeUpdate();

            if(flag1==1&&flag2==1) {
                System.out.println("Successfully updated results");
                return true;
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error in updateStudent");
        }
        return false;
    }

    public static boolean deleteResult(Connection conn,int result_id)
    {
        try{
            String query = "delete from results where result_id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1,result_id);
            int status = ps.executeUpdate();
            return status == 1;
        }
        catch(Exception e){
            e.printStackTrace();
            System.out.println("Error in deleteResult: ");
        }
        return false;
    }


    public static List<Results> fetchResults(Connection conn){
        List<Results> ResultList = new ArrayList<>();
        try {


            String query ="select s.rollno,s.name,s.studclass,r.result_id,r.tamil,r.english,r.maths,r.science,r.social_science,r.total_marks,r.status from results r join student s on r.rollno=s.rollno";
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int result_id = rs.getInt("result_id");
                int rollno = rs.getInt("rollno");
                String name = rs.getString("name");
                String studclass = rs.getString("studclass");
                int tamil = rs.getInt("tamil");
                int english = rs.getInt("english");
                int maths = rs.getInt("maths");
                int science = rs.getInt("science");
                int social_science = rs.getInt("social_science");
                int total_marks = rs.getInt("total_marks");
                String status = rs.getString("status");


                Results results = new Results(result_id,rollno, name,studclass, tamil,english, maths, science,social_science,total_marks,status);
                ResultList.add(results);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ResultList;
    }

    //get students stats
    public static int getTotalNoOfStudents(Connection conn){

        String query="select count(rollno) from student";

        try{
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
        catch(Exception e){
            e.printStackTrace();
            System.out.println("Error in getStudentsStats: ");
        }
        return 0;
    }

    //Getting total number of passed students
    public static int getTotalNoOfPass(Connection conn){
        String query="select count(*) from results where status='Pass'";

        try{
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
        catch(Exception e){
            e.printStackTrace();
            System.out.println("Error in getStudentsStats: ");
        }

        return 0;
    }

    //Getting total number of failed students
    public static int getTotalNoOfFail(Connection conn){
        String query="select count(*) from results where status = 'Fail' ";
        try{
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
        catch(Exception e){
            e.printStackTrace();
            System.out.println("Error in getStudentsStats: ");
        }

        return 0;
    }

    //Getting average marks of all subjects
    public static Map<String,Double> getAverageMarks(Connection conn)
    {
    String query = "SELECT " +
            "ROUND(AVG(tamil), 2) AS avg_tamil, " +
            "ROUND(AVG(english), 2) AS avg_english, " +
            "ROUND(AVG(maths), 2) AS avg_maths, " +
            "ROUND(AVG(science), 2) AS avg_science, " +
            "ROUND(AVG(social_science), 2) AS avg_social_science " +
            "FROM results";

    Map<String,Double> mp = new HashMap<>();
    try (PreparedStatement ps = conn.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            mp.put("tamil", rs.getDouble("avg_tamil"));
            mp.put("english", rs.getDouble("avg_english"));
            mp.put("maths", rs.getDouble("avg_maths"));
            mp.put("science", rs.getDouble("avg_science"));
            mp.put("social_science", rs.getDouble("avg_social_science"));
        }
    }
    catch(Exception e){
        e.printStackTrace();
        System.out.println("Error in getStudentsStats: ");
    }

    return mp;
}


//Getting student based on their roll number
public static List<Student> getStudentByRollno(Connection conn, int rollno){

        String query = "select * from student where rollno=?";
        List<Student> searchList = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, rollno);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                int studrollno = rs.getInt("rollno");
                String className = rs.getString("studclass");
                String dob = rs.getString("dob");
                String gender = rs.getString("gender");
                String email = rs.getString("email");
                String phone = rs.getString("phone");

                Student student = new Student(id, name,studrollno,className, dob,gender, email, phone);
                searchList.add(student);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error in getStudentByRollno: ");
        }

        return searchList;
}

//Getting student details by class
public static List<Student> getStudentsByClass(Connection conn, String studclass){

    String query = "select * from student where studclass=?";
    List<Student> searchList = new ArrayList<>();
    try {
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, studclass);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            String name = rs.getString("name");
            int studrollno = rs.getInt("rollno");
            String className = rs.getString("studclass");
            String dob = rs.getString("dob");
            String gender = rs.getString("gender");
            String email = rs.getString("email");
            String phone = rs.getString("phone");

            Student student = new Student(id, name, studrollno, className, dob, gender, email, phone);
            searchList.add(student);
        }
    }
    catch(Exception e)
    {
            e.printStackTrace();
            System.out.println("Error in getStudentsByClass");
    }

    return searchList;
    }

    //Getting students in sorted order based on ascending and descending order
    public static List<Student> getStudentsSortedBy(Connection conn, String field, boolean asc) {
        List<Student> list = new ArrayList<>();
        String direction = asc ? "ASC" : "DESC";

        // To avoid SQL injection, allow only safe column names
        if (!field.equals("name") && !field.equals("studclass")) {
            field = "id";
        }

        String query = "SELECT * FROM student ORDER BY " + field + " " + direction;

        try {
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Student s = new Student();
                s.setId(rs.getInt("id"));
                s.setRollno(rs.getInt("rollno"));
                s.setName(rs.getString("name"));
                s.setStudclass(rs.getString("studclass"));
                s.setDob(rs.getString("dob"));
                s.setGender(rs.getString("gender"));
                s.setEmail(rs.getString("email"));
                s.setPhone(rs.getString("phone"));
                list.add(s);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error in getStudentsSortedBy");
        }

        return list;
    }


    //Getting students based on their roll number and dob
    public static boolean findStudentByRollNoAndDob(Connection conn, String rollno, String dob) {
        boolean found = false;

        try {
            String query = "SELECT 1 FROM student WHERE rollno = ? AND dob = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, rollno);
            stmt.setString(2, dob);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                found = true;
            }

            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return found;
    }

    //Getting result based on students roll number
    public static List<Results> fetchResultByRollNo(Connection conn, String rollno) {

        List<Results> ResultList = new ArrayList<>();
        try {
            String query = "SELECT s.name, s.studclass, r.tamil, r.english, r.maths, r.science, r.social_science, r.total_marks, r.status " +
                    "FROM results r JOIN student s ON r.rollno = s.rollno WHERE r.rollno = ?";

            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, rollno);

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                String name = rs.getString("name");
                String studclass = rs.getString("studclass");
                int tamil = rs.getInt("tamil");
                int english = rs.getInt("english");
                int maths = rs.getInt("maths");
                int science = rs.getInt("science");
                int social_science = rs.getInt("social_science");
                int total_marks = rs.getInt("total_marks");
                String status = rs.getString("status");

                Results results = new Results(name, studclass, tamil, english, maths, science, social_science, total_marks, status);
                ResultList.add(results);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ResultList;
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