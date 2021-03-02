package com.example.demo;

import java.math.BigDecimal;
import java.util.ArrayList;

import org.springframework.web.bind.annotation.*;

@RestController
public class MathController {
    @PostMapping("/getGraph")
    public Object getGraph(@RequestBody MyPBody body){
        LagrangeMethod lagrangeMethod = new LagrangeMethod(body.getPoints());
        String l = lagrangeMethod.getLWithoutF();
        return l;
    }
    @PostMapping("/goAdams")
    public Object goAdams(@RequestBody AdamsBody body){
        System.out.println(".>JHDTJDDHDHR>");
        AdamsMethod adamsMethod = new AdamsMethod(body.getF(), body.getX0(), body.getY0(), body.getXn(), body.getEps());
        System.out.println(body.getF());
        adamsMethod.initX();
        System.out.println(".>bF4>");
        adamsMethod.getFirst4();
        System.out.println(".>bAda");
        ArrayList<ArrayList<Double>> res = adamsMethod.goAdams();
        System.out.println(".>DAWF>AF>AFWF>");
        return res;
    }
    @PostMapping("/findx")
    public Object findx(@RequestBody PointBody body){
        //FunctionManager f = new FunctionManager(body.getF());
        FunctionManager Lg = new FunctionManager(body.getL());
        //System.out.println("FFFFFFF"+body.getL());
        ArrayList<Double> res = new ArrayList<>();
        //res.add(f.get(body.getX()));
        res.add(Lg.get(body.getX()));
        return res;
    }
    @PostMapping("/getL")
    public Object getL(@RequestBody LagrangeBody body){
        LagrangeMethod lagrangeMethod = new LagrangeMethod(new FunctionManager(body.getF()), body.getPoints());
        String l = lagrangeMethod.getL();
        FunctionManager f = new FunctionManager(l);
        System.out.println(f.get(3.14));
        System.out.println(lagrangeMethod.getL());
        return lagrangeMethod.getL();
    }
    @PostMapping("/getfL")
    public Object getL(@RequestBody LagrangePointsBody body){
        FunctionManager f = new FunctionManager(body.getF());
        FunctionManager Lg = new FunctionManager(body.getLg());
        ArrayList<ArrayList<Double>> res = new ArrayList<>();
        ArrayList<Double> pair = new ArrayList<>();
        for (int i = 0; i < body.getPoints().size(); i++) {
            pair.add(body.getPoints().get(i));
            pair.add(f.get(body.getPoints().get(i)));
            res.add((ArrayList<Double>) pair.clone());
            pair.clear();
        }
        return res;
    }
    @PostMapping("/getFs")
    public Object getFuncs(@RequestBody MyIterRequestBody body){
        ArrayList<String> graphFs = new ArrayList<>();
        ItarationMethod iMethod = new ItarationMethod(body.getFs(),body.getA() ,body.getB() ,body.getEps() );
        ArrayList<Double> ans = iMethod.findAnswer();
        graphFs.addAll(body.getFs());
        for (int j = 0; j < graphFs.size(); j++) {
            graphFs.set(j,"("+graphFs.get(j).concat(")-("+String.valueOf((char)(j+97))+")"));
            for (int i = 98; i < graphFs.size()+97; i++) {
                graphFs.set(j, graphFs.get(j).replaceAll(String.valueOf((char)(i)),"("+String.valueOf(ans.get(i-97) )+")"));
                graphFs.set(j, graphFs.get(j).replaceAll("a", "x"));
            }
        }
        return graphFs;
    }
    @PostMapping("/goIter")
    public Object solveIter(@RequestBody MyIterRequestBody body){
        try{
            ItarationMethod iMethod = new ItarationMethod(body.getFs(),body.getA() ,body.getB() ,body.getEps() );
            ArrayList<Double> res = iMethod.findAnswer();
            boolean isNaN = false;
            for (int i = 0; i < res.size(); i++) {
                if(res.get(i).isNaN() || res.get(i).isInfinite()) return "e404";
            }
            return res;
        }catch (RuntimeException e){
            return "e404";
        }
    }
    @PostMapping("/go")
    public Object solve1(@RequestBody MyRequestBody body){
        if(body.getM()==1){
            try{
                BisectionMethod dMethod = new BisectionMethod(body.getF(), body.getA(), body.getB(), body.getEps());
                double ans = dMethod.findRandomAnswer();
                if(Double.isNaN(ans)){
                    return "Ф-я на интервале должна быть ионотонной и не иметь точек экстремума. Иначе мы ничего не гарантируем" ;
                }
                return ans;
            }catch (ArithmeticException e){
                return "e404";
            }catch (NullPointerException e){
                return "e405";
            }
        }
        else {
            try{
                TangentMethod tMethod = new TangentMethod(body.getF(), body.getA(), body.getB(), body.getEps());
                double ans = tMethod.findRandomAnswer();
                if(Double.isNaN(ans)){
                    return "e406" ;
                }
                if(ans< body.getA() || ans>body.getB()){
                  return "e406";
                }
                return ans;
            }catch (ArithmeticException e){
                return "e404";
            }
        }
    }
}