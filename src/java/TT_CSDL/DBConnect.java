/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package TT_CSDL;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Admin
 */
public class DBConnect {
    public Connection KetNoi(){
        Connection conn=null;
        String url="jdbc:mysql://127.0.0.1:3306/btl_jsp?useUnicode=true&characterEncoding=UTF-8";
        String user="root";
        String password="";
        try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);
        }catch (ClassNotFoundException | SQLException ex) {
        ex.printStackTrace();
        }
        return conn;
    }
}
