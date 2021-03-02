package com.example.demo;
import org.mariuszgromada.math.mxparser.Function;

import java.util.ArrayList;

public class BisectionMethod {
    private double a;
    private double b;
    private double epsilon;
    private FunctionManager f;
    int counter;
    ArrayList<Double> result = new ArrayList<>();

    public BisectionMethod(String signature, double xn, double xk, double eps){
        this.f = new FunctionManager(signature);
        this.a = xn;
        this.b = xk;
        this.epsilon = eps;
    }

    public double findRandomAnswer() throws ArithmeticException, NullPointerException{
        double xn =a;
        double xk =b;
        double eps = epsilon;
        double dx = 0;
        double xi = 0;
        if(f.get(xn) == 0) return xn;
        if(f.get(xk) == 0) return xk;
        if(FunctionManager.sign(f.get(xn))==FunctionManager.sign(f.get(xk))){
            throw new NullPointerException();
        }
        while(Math.abs(xk-xn)>eps){
            dx = (xk-xn)/2;
            xi = xn + dx;
            if(FunctionManager.sign(f.get(xn))!=FunctionManager.sign(f.get(xi))){
                xk = xi;

            }else{
                xn=xi;
            }
            counter++;
        }
        return xi;
    }
}
