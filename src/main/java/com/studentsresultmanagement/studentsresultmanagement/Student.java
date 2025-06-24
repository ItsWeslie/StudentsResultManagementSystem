package com.studentsresultmanagement.studentsresultmanagement;

public class Student {

    private int id;
    private int rollno;
    private String name;
    private String dob;
    private String gender;
    private String studclass;
    private String email;
    private String phone;

    public Student() {

    }

    // Constructor, Getters, and Setters
    public Student(int id,String name,int rollno,String studclass,String dob,String gender, String email, String phone) {
        this.id = id;
        this.name = name;
        this.dob = dob;
        this.email = email;
        this.phone = phone;
        this.rollno = rollno;
        this.studclass = studclass;
        this.gender = gender;

    }

    // Getters and Setters for all fields
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRollno() {
        return rollno;
    }
    public void setRollno(int rollno) {
        this.rollno = rollno;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getStudclass() {
        return studclass;
    }

    public void setStudclass(String studclass) {
        this.studclass = studclass;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}
