<%-- 
    Document   : HienThi
    Created on : Sep 25, 2024, 2:43:59 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="TT_CSDL.DAO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>BTL</title>
        <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
            text-align: center;
        }
    </style>
    </head>
    <body>
        <h2 style="text-align: center">BÁO CÁO THỐNG KÊ</h2>

    <%
        DAO dao = new DAO();
        String tableContent = dao.hienthi();
        out.print(tableContent);
    %>
    </body>
</html>

