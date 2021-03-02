package com.example.demo;

import org.mariuszgromada.math.mxparser.Function;

import java.util.ArrayList;

public class AdamsMethod {
    private double eps;
    private double xn;
    private Function f;

    private ArrayList<Double> y;
    private ArrayList<Double> x;
    private double h;

    public AdamsMethod(String signature, double x0, double y0, double xn,  double eps) {
        this.eps = eps;
        this.xn = xn;
        this.f = new Function("f(x,y) = "+signature);

        this.x = new ArrayList<>();
        this.y = new ArrayList<>();
        x.add(x0);
        y.add(y0);
        h = Math.pow(eps,0.25);
    }
    public ArrayList<Double> initX(){
        double x_cur = x.get(0)+h;
        while(x_cur<=xn){
            x.add(x_cur);
            x_cur +=h;
        }
        return x ;
    }
    public ArrayList<Double> getFirst4(){
        double k1=0;
        double k2=0;
        double k3=0;
        double k4=0;
        double y_next = 0;
        for (int i = 0; i < 4; i++) {
            k1 = h*f.calculate(x.get(i),y.get(i));
            k2 = h*f.calculate(x.get(i)+h/2,y.get(i)+k1/2);
            k3 = h*f.calculate(x.get(i)+h/2,y.get(i)+k2/2);
            k4 = h*f.calculate(x.get(i)+h,y.get(i)+k3);
            y_next = y.get(i)+((k1+2*k2+2*k3+k4)/6);
            y.add(y_next);
        }
        return y;
    }

    public ArrayList<ArrayList<Double>> goAdams(){
        double y_next = 0;
        for (int i = 4; i < x.size(); i++) {
            y_next = y.get(i)+(h/24)*(55*f.calculate(x.get(i),y.get(i))
                    - 59*f.calculate(x.get(i-1),y.get(i-1))
                    + 37*f.calculate(x.get(i-2),y.get(i-2))
                    -9*f.calculate(x.get(i-3),y.get(i-3)));
            y.add(y_next);
        }
        ArrayList<ArrayList<Double>> res = new ArrayList<>();
        ArrayList<Double> pair = new ArrayList<>();
        for (int i = 0; i <x.size(); i++) {
            pair.add(x.get(i));
            pair.add(y.get(i));
            res.add((ArrayList<Double>) pair.clone());
            pair.clear();
        }
        return res;
    }

}
