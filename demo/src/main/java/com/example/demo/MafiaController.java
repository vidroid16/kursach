package com.example.demo;

import com.example.demo.reps.DBController;
import com.example.demo.reps.JDBCConnector;
import com.example.demo.reps.NewbetBody;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.sql.SQLException;
import java.util.ArrayList;

@RestController
public class MafiaController {

    @PostMapping("/log")
    public String logUser(@RequestBody LogBody body) {
        JDBCConnector connector = new JDBCConnector();
        DBController controller = new DBController(connector);
        ArrayList<String> res = new ArrayList<>();
        res.add(body.getLogin());
        res.add(body.getLogin());
        System.out.println(body.getLogin());
        try {
            System.out.println(controller.logUser(body.getLogin(), body.getPassword()).toString());
            return controller.logUser(body.getLogin(), body.getPassword()).toString();
        } catch (SQLException e) {
            e.printStackTrace();
            return "404";
        }
    }

    @PostMapping("/line")
    public String getLine(@RequestBody MainBody body) {
        String login = body.getLogin();
        JDBCConnector connector = new JDBCConnector();
        DBController controller = new DBController(connector);
        try {
            System.out.println(controller.getLine(login).toString());
            return controller.getLine(login).toString();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @PostMapping("/balance")
    public String setBalance(@RequestBody BalanceBody body) {
        String login = body.getLogin();
        float balance = body.getBalance();
        System.out.println("BALANCIK = "+ body.getBalance());
        JDBCConnector connector = new JDBCConnector();
        DBController controller = new DBController(connector);
        try {
            System.out.println(controller.setBalance(login, balance));
            return "202";
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @PostMapping("/getbal")
    public String getUserBalance(@RequestBody LogBody body) {
        String login = body.getLogin();
        JDBCConnector connector = new JDBCConnector();
        DBController controller = new DBController(connector);
        try {
            return String.valueOf(controller.getBalance(login));
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @PostMapping("/makebet")
    public String makeBet(@RequestBody NewbetBody body) {
        JDBCConnector connector = new JDBCConnector();
        DBController controller = new DBController(connector);
        try {
            return controller.setBet(body.getLogin(), body.getMatch_id(),body.isP1() ,body.getBalance() ).toString();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}