package com.example.demo;

import java.util.ArrayList;

public class TangentMethod {
    private double a;
    private double b;
    private double epsilon;
    private FunctionManager f;
    int counter;
    ArrayList<Double> result = new ArrayList<>();

    public TangentMethod(String signature, double xn, double xk, double eps){
        this.f = new FunctionManager(signature);
        this.a = xn;
        this.b = xk;
        this.epsilon = eps;
    }

    public double findRandomAnswer() throws ArithmeticException{

        double eps = epsilon;
        double xi = 0;
        double tmp = 0;
        double xi_prev = (b+a)/2;
        if(f.get(a) == 0) return a;
        if(f.get(b) == 0) return b;
        if(f.get(xi_prev)==0)return xi_prev;
        xi = xi_prev - (f.get(xi_prev)/f.getDerivate(xi_prev));
        while(Math.abs(xi-xi_prev)>=eps){
            xi_prev = xi;
            xi = xi_prev - (f.get(xi_prev)/f.getDerivate(xi_prev));
            counter++;
        }
        return xi;
    }
}
