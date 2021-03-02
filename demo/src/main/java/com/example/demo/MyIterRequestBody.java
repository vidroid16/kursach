package com.example.demo;

import java.util.ArrayList;

public class MyIterRequestBody {
    private ArrayList<String> fs;
    private double a;
    private double b;
    private double eps;

    public ArrayList<String> getFs() {
        return fs;
    }

    public void setFs(ArrayList<String> fs) {
        this.fs = fs;
    }

    public double getA() {
        return a;
    }

    public void setA(double a) {
        this.a = a;
    }

    public double getB() {
        return b;
    }

    public void setB(double b) {
        this.b = b;
    }

    public double getEps() {
        return eps;
    }

    public void setEps(double eps) {
        this.eps = eps;
    }
}
