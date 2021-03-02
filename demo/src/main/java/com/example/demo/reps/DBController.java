package com.example.demo.reps;

import com.example.demo.BalanceBody;
import com.example.demo.MainBody;
import javafx.util.Pair;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.bind.annotation.RequestBody;

import javax.swing.*;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;


public class DBController {

    private JDBCConnector connector;

    public DBController(JDBCConnector connector){
        this.connector = connector;
    }

    public JSONObject logUser(String login, String password) throws SQLException {
        Pair<PreparedStatement, ResultSet> pair = connector.execSQLQuery("SELECT * FROM Члены_Мафии where login = '"
                +login+"'and password = '"+password+"';");
        ResultSet set = pair.getValue();
        set.next();
        JSONObject o = new JSONObject();
        o.put("name", set.getString("Имя"));
        o.put("login", set.getString("login"));
        o.put("surname", set.getString("Фамилия"));
        o.put("balance", getBalance(login));
        pair.getKey().close();
        return o;
    }
    public JSONArray getLine(String login) throws SQLException {
        System.out.println("VHODIM V MATRIZU");
        System.out.println(login);
        Pair<PreparedStatement, ResultSet> pair = connector.execSQLQuery("SELECT БК_Матчи.Коэф_на_победу_1, БК_Матчи.Коэф_на_победу_2,Ма.ID_Матча, Ма.ID_Команды1, Ма.ID_Команды2 FROM БК_Матчи\n" +
                "INNER JOIN БК Б on БК_Матчи.ID_БК = Б.ID_БК\n" +
                "INNER JOIN Мафия М on М.ID_Мафии = Б.ID_Мафии\n" +
                "INNER JOIN Члены_Мафии Ч on М.ID_Мафии = Ч.ID_Мафии\n" +
                "INNER JOIN Матчи Ма on Ма.ID_Матча = БК_Матчи.ID_Команды\n" +
                "WHERE Ч.login = '"+login+"' AND Ма.Статус = 'Не начался';");
        ResultSet set = pair.getValue();
        ResultSet set1 = pair.getValue();
        JSONArray resultObj = new JSONArray();
        ArrayList<String> teams1 = new ArrayList<>();
        ArrayList<String> teams2 = new ArrayList<>();
        while(set.next()){
            String name1 = set.getString("ID_Команды1");
            String name2 = set.getString("ID_Команды2");
            Pair<PreparedStatement, ResultSet> t1 = connector.execSQLQuery("SELECT Команды.Название FROM Команды WHERE ID_Команды = "+name1+";");
            Pair<PreparedStatement, ResultSet> t2 = connector.execSQLQuery("SELECT Команды.Название FROM Команды WHERE ID_Команды = "+name2+";");
            ResultSet sett1 = t1.getValue();
            ResultSet sett2 = t2.getValue();
            sett1.next();
            sett2.next();
            teams1.add(sett1.getString("Название"));
            teams2.add(sett2.getString("Название"));

        }
        set1.beforeFirst();
        int i = 0;
        while(set1.next()){
            System.out.println("HELLO MAZAF");
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("id", set1.getString("ID_Матча"));
            jsonObject.put("firstTeam", teams1.get(i));
            jsonObject.put("secTeam", teams2.get(i));
            jsonObject.put("firstCoef", set1.getString("Коэф_на_победу_1"));
            System.out.println(set1.getString("Коэф_на_победу_1"));
            jsonObject.put("secCoef", set1.getString("Коэф_на_победу_2"));
            resultObj.put(jsonObject);
            System.out.println(jsonObject.toString()+"thisismatch");
            i++;
        }
        pair.getKey().close();
        return resultObj;
    }

    public String setBalance(String login, float balance) throws SQLException{
        String query = String.format("UPDATE Члены_Мафии SET balance = %s where login = '%s';",
                balance, login);
        connector.execSQLUpdate(query);
        return "202";
    }
    public float getBalance(String login) throws SQLException{
        Pair<PreparedStatement, ResultSet> pair = connector.execSQLQuery("SELECT balance FROM Члены_Мафии where login = '"+login+"';");
        ResultSet set = pair.getValue();
        set.next();
        float ret = set.getFloat("balance");
        return ret;
    }
    public String setBalance(String login, float balance, boolean plus) throws SQLException{
        if(plus){
            String s = String.format(Locale.US, "%.2f", balance);
            String query = String.format("UPDATE Члены_Мафии SET balance = balance + %s where login = '%s';",
                    balance, login);
            float balanar = getBalance(login);
            connector.execSQLUpdate(query);
        }else{
            String s = String.format(Locale.US, "%.2f", balance);
            String query = String.format("UPDATE Члены_Мафии SET balance = balance - %s where login = '%s';",
                    balance, login);
            connector.execSQLUpdate(query);
        }
        return "202";
    }
    public JSONArray setBet(String login, int matchID, boolean p1, float balance) throws SQLException {
        //insert bet
        Pair<PreparedStatement, ResultSet> pair = connector.execSQLQuery("SELECT * FROM Члены_Мафии where login = '"
                +login+"';");
        ResultSet set = pair.getValue();
        set.next();
        int user_id = set.getInt("ID_Члена");
        System.out.println(user_id);
        float balanceOld = getBalance(login);
        System.out.println(balanceOld);
        //change match status
        System.out.println(matchID);
        String queryDelete = ("UPDATE Матчи SET Статус = 'Прошел' WHERE ID_Матча ="+matchID+";");
        connector.execSQLUpdate(queryDelete);

        //analyze bet
        boolean win1;
        try {
            Pair<PreparedStatement, ResultSet> pairResult = connector.execSQLQuery("SELECT БК_Матчи.Договорной_исход FROM БК_Матчи WHERE БК_Матчи.ID_Команды = "+matchID+" AND БК_Матчи.Договорной_исход notnull ;");
            ResultSet setResult = pairResult.getValue();
            setResult.next();
            if(     setResult.getString("Договорной_исход").equals("2-1") ||
                    setResult.getString("Договорной_исход").equals("2-0") ||
                    setResult.getString("Договорной_исход").equals("1-0"))
            {
                win1 = true;
            }
            else
            {
                win1 = false;
            }
        }catch (SQLException e){
            win1 = (Math.random()>0.5);
        }

        Pair<PreparedStatement, ResultSet> pairCoef = connector.execSQLQuery(
                "SELECT БК_Матчи.Коэф_на_победу_1, БК_Матчи.Коэф_на_победу_2 FROM БК_Матчи\n" +
                "INNER JOIN БК Б on БК_Матчи.ID_БК = Б.ID_БК\n" +
                "INNER JOIN Мафия М on М.ID_Мафии = Б.ID_Мафии\n" +
                "INNER JOIN Члены_Мафии Ч on М.ID_Мафии = Ч.ID_Мафии\n" +
                "INNER JOIN Матчи Ма on Ма.ID_Матча = БК_Матчи.ID_Команды\n" +
                "WHERE Ч.login = '"+login+"' AND Ма.ID_Матча = "+matchID+";");
        pairCoef.getValue().next();
        float c1 = pairCoef.getValue().getFloat("Коэф_на_победу_1");
        float c2 = pairCoef.getValue().getFloat("Коэф_на_победу_2");
        if(p1==win1){
            if(p1){
                setBalance(login, balance*c1,true);
            }
            if(!p1){
                setBalance(login, balance*c2,true);
            }
        }else{
            setBalance(login, balance,false);
        }

        float balanceNew = getBalance(login);
        System.out.println(balanceNew);
        //add bet
        String queryAdding = String.format("INSERT INTO Пользователи_Ставки (ID_Матча, ID_Пользователя, Ставка, П1, Результат) values (%d,%d,%s,%s,%s);",
                matchID, user_id, balance, p1, balanceNew-balanceOld);
        connector.execSQLUpdate(queryAdding);

        //return history
        Pair<PreparedStatement, ResultSet> pairHistory = connector.execSQLQuery(
                "SELECT DISTINCT БК_Матчи.Коэф_на_победу_1, БК_Матчи.Коэф_на_победу_2, Ма.ID_Команды1, Ма.ID_Команды2, Пс.Результат FROM БК_Матчи\n" +
                        "INNER JOIN БК Б on БК_Матчи.ID_БК = Б.ID_БК\n" +
                        "INNER JOIN Мафия М on М.ID_Мафии = Б.ID_Мафии\n" +
                        "INNER JOIN Члены_Мафии Ч on М.ID_Мафии = Ч.ID_Мафии\n" +
                        "INNER JOIN Матчи Ма on Ма.ID_Матча = БК_Матчи.ID_Команды\n" +
                        "INNER JOIN Пользователи_Ставки Пс on Ма.ID_Матча = Пс.ID_Матча\n" +
                        "WHERE Пс.ID_Пользователя = "+user_id+";");
        ResultSet setHistory = pairHistory.getValue();
        ResultSet set2 = setHistory;
        ResultSet set1 = setHistory;
        JSONArray resultObj = new JSONArray();
        ArrayList<String> teams1 = new ArrayList<>();
        ArrayList<String> teams2 = new ArrayList<>();
        set2.beforeFirst();
        while(set2.next()){
            String name1 = set2.getString("ID_Команды1");
            String name2 = set2.getString("ID_Команды2");
            Pair<PreparedStatement, ResultSet> t1 = connector.execSQLQuery("SELECT Команды.Название FROM Команды WHERE ID_Команды = "+name1+";");
            Pair<PreparedStatement, ResultSet> t2 = connector.execSQLQuery("SELECT Команды.Название FROM Команды WHERE ID_Команды = "+name2+";");
            ResultSet sett1 = t1.getValue();
            ResultSet sett2 = t2.getValue();
            sett1.next();
            sett2.next();
            teams1.add(sett1.getString("Название"));
            teams2.add(sett2.getString("Название"));

        }
        System.out.println(teams1.get(0));
        System.out.println(teams2.get(0));
        setHistory.beforeFirst();
        int i = 0;
        while(setHistory.next()){
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("firstTeam", teams1.get(i));
            //jsonObject.put("id",setHistory.getString("ID_Матча"));
            jsonObject.put("secTeam", teams2.get(i));
            jsonObject.put("firstCoef", setHistory.getString("Коэф_на_победу_1"));
            jsonObject.put("secCoef", setHistory.getString("Коэф_на_победу_2"));
            jsonObject.put("result", setHistory.getString("Результат"));
            resultObj.put(jsonObject);
            i++;
        }
       // System.out.println(resultObj.toString());
        return resultObj;
    }
}
