package com.example.demo;

import org.mariuszgromada.math.mxparser.Expression;
import org.mariuszgromada.math.mxparser.Function;

import java.security.Signature;
import java.util.ArrayList;

public class FunctionManager{
    private Function f;
    private String signature;

    public FunctionManager(String signature){
        signature = "("+signature+")";
        f = new Function("f(x)="+signature);
        this.signature = signature;
    }
    public void changeF(String signature){
       f = new Function("f(x)="+signature) ;
       this.signature = signature;
    }
    public double get(double x){
        return f.calculate(x);
    }
//    public double get(ArrayList<Double> x){
//        double[] arr = new double[x.size()];
//        for (int i = 0; i < arr.length; i++) {
//            arr[i] = x.get(i);
//        }
//        return f.calculate(arr);
//    }
    public static int sign(double a){
        if(a<0)return -1;
        if(a>0)return 1;
        return 0;
    }
    public double getDerivate(double x){
        Expression e = new Expression("der("+signature+",x,"+String.valueOf(x)+")");
        return e.calculate();
    }

    public String getSignature() {
        return signature;
    }
}