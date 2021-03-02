package com.example.demo;

import java.util.ArrayList;

public class LagrangeMethod {
    FunctionManager f;
    ArrayList<Double> points;
    ArrayList<ArrayList<Double>> interPoints;

    public LagrangeMethod(FunctionManager f, ArrayList<Double> points) {
        this.f = f;
        this.points = points;
    }
    public LagrangeMethod(ArrayList<ArrayList<Double>> points) {
        this.interPoints = points;
    }
    public String getLWithoutF(){
        int n = interPoints.size();
        String L= "";
        String l = "";
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if(i!=j){
                    l+="((x-("+String.valueOf(interPoints.get(j).get(0))+"))/(("+String.valueOf(interPoints.get(i).get(0))+")-("+String.valueOf(interPoints.get(j).get(0))+")))*";
                }
            }
            l = l.substring(0, l.length()-1);
            L+="("+String.valueOf(interPoints.get(i).get(1))+")*"+l+"+";
            l="";
        }
        L=L.substring(0, L.length()-1);
        return L;
    }
    public String getL(){
        int n = points.size();
        String L= "";
        String l = "";
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if(i!=j){
                    l+="((x-("+String.valueOf(points.get(j))+"))/(("+String.valueOf(points.get(i))+")-("+String.valueOf(points.get(j))+")))*";
                }
            }
            l = l.substring(0, l.length()-1);
            L+="("+String.valueOf(f.get(points.get(i)))+")*"+l+"+";
            l="";
        }
        L=L.substring(0, L.length()-1);
        return L;
    }
}
