package com.studentsresultmanagement.studentsresultmanagement;

public class Results {
    private int result_id;
    private int rollno;
    private String name;
    private String studclass;
    private int tamil;
    private int english;
    private int maths;
    private int science;
    private int social_science;
    private int total_marks;
    private String status;

    public Results(int result_id,int rollno,String name,String studclass,int tamil,int english,int maths,int science,int social_science,int total_marks,String status) {

        this.rollno=rollno;
        this.name=name;
        this.studclass=studclass;
        this.tamil=tamil;
        this.english=english;
        this.maths=maths;
        this.science=science;
        this.social_science=social_science;
        this.total_marks=total_marks;
        this.status=status;
        this.result_id=result_id;
    }

    public Results(String name, String studclass, int tamil, int english, int maths, int science, int socialScience, int totalMarks, String status) {

        this.name=name;
        this.studclass=studclass;
        this.tamil=tamil;
        this.english=english;
        this.maths=maths;
        this.science=science;
        this.social_science=socialScience;
        this.total_marks=totalMarks;
        this.status=status;
    }

    public int getEnglish() {
        return english;
    }

    public void setEnglish(int english) {
        this.english = english;
    }

    public int getRollno() {
        return rollno;
    }

    public void setRollno(int rollno) {
        this.rollno = rollno;
    }

    public int getTamil() {
        return tamil;
    }

    public void setTamil(int tamil) {
        this.tamil = tamil;
    }

    public int getMaths() {
        return maths;
    }

    public void setMaths(int maths) {
        this.maths = maths;
    }

    public int getScience() {
        return science;
    }

    public void setScience(int science) {
        this.science = science;
    }

    public int getSocial_science() {
        return social_science;
    }

    public void setSocial_science(int social_science) {
        this.social_science = social_science;
    }

    public String getStudclass() {
        return studclass;
    }

    public void setStudclass(String studclass) {
        this.studclass = studclass;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getTotal_marks() {
        return total_marks;
    }

    public void setTotal_marks(int total_marks) {
        this.total_marks = total_marks;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getResult_id() {
        return result_id;
    }

    public void setResult_id(int result_id) {
        this.result_id = result_id;
    }
}
