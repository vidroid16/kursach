package com.example.demo;

import org.mariuszgromada.math.mxparser.Argument;
import org.mariuszgromada.math.mxparser.Function;

import java.util.ArrayList;
import java.util.Collections;

public class ItarationMethod {
    private ArrayList<String> funcs;
    private ArrayList<Function> fs;

    private double a;
    private double b;
    private double epsilon;

    public ItarationMethod(ArrayList<String> funcs, double a, double b, double epsilon) {
        this.funcs = new ArrayList<>();
        this.fs = new ArrayList<>();
        this.funcs.addAll(funcs);
        this.a = a;
        this.b = b;
        this.epsilon = epsilon;
    }
    private void prepare(){
        String param = "";
        for (int j = 0; j < funcs.size(); j++) {
            for (int i = 0; i < funcs.size(); i++) {
                if(j==i){

                }else{
                    param = param.concat(String.valueOf((char)(97+i))+",");
                }
            }
            param = param.substring(0, param.length()-1);
            fs.add(new Function("f("+param+")"+"="+funcs.get(j)));
            System.out.println("f("+param+")"+"="+funcs.get(j));
            param = "";
        }
    }
    private double getF(Function f, ArrayList<Double> x){
        double[] arr = new double[x.size()];
        for (int i = 0; i < arr.length; i++) {
            arr[i] = x.get(i);
        }
        System.out.println(f.calculate(arr));
        return f.calculate(arr);
    }
    public ArrayList<Double> findAnswer(){
        prepare();
        int iteration = 0;
        int n = fs.size();
        ArrayList<Double> prev = new ArrayList<>();
        ArrayList<Double> cur = new ArrayList<>();
        ArrayList<Double> errors = new ArrayList<>();
        ArrayList<Double> tmp = new ArrayList<>();

        for (int i = 0; i < n; i++) {
            prev.add(0.0);
        }
        for (int i = 0; i < n; i++) {
            tmp.addAll(prev);
            tmp.remove(i);
            cur.add(getF(fs.get(i), tmp));
            tmp.clear();
        }
        for (int i = 0; i < n; i++) {
            errors.add(Math.abs(cur.get(i)-prev.get(i)));
        }
        while(Collections.max(errors)>epsilon){
            for (int i = 0; i < n; i++) {
                prev.set(i,cur.get(i));
            }
            for (int i = 0; i < n; i++) {
                tmp.addAll(prev);
                tmp.remove(i);
                cur.set(i, getF(fs.get(i), tmp));
                tmp.clear();
            }
            for (int i = 0; i < n; i++) {
                errors.set(i, Math.abs(cur.get(i)-prev.get(i)));
            }
            iteration++;
            if(iteration>1000){
                throw new RuntimeException();
            }
        }
        cur.forEach(p-> System.out.println(p));
        return cur;
    }
}
