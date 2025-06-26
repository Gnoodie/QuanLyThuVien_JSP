<%@page import="java.sql.*, java.util.*, TT_CSDL.StatusDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tình trạng sách</title>
    <style>
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            text-align: left;
        }

        table, th, td {
            border: 1px solid #ccc;
        }

        th, td {
            padding: 10px;
        }

        th {
            background-color: #f2f2f2;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        .action-button {
            padding: 5px 10px;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        .edit-button {
            background-color: #2196F3;
        }

        .delete-button {
            background-color: #f44336;
        }

        .view-button {
            background-color: #ffa500;
        }
    </style>
</head>
<body>
    <h2>Tình trạng sách</h2>
    <%
        int maSach = Integer.parseInt(request.getParameter("ma_sach"));
        List<Map<String, Object>> bookStatusList = StatusDAO.getBookStatusByBookId(maSach);
        if (bookStatusList != null && !bookStatusList.isEmpty()) {
    %>
    <table>
        <tr>
            <th>Mã sách chi tiết</th>
            <th>Trạng thái</th>
            <th>Tình trạng</th>
            <th>Tình trạng chi tiết</th>
            <th>Thao tác</th>
        </tr>
        <%
            for (Map<String, Object> bookStatus : bookStatusList) {
        %>
        <tr>
            <td><%= bookStatus.get("ma_sach_ct") %></td>
            <td><%= (Integer.parseInt(bookStatus.get("trang_thai").toString()) == 0) ? "Còn" : "Đã mượn" %></td>
            <td><%= bookStatus.get("tinh_trang") %></td>
            <td><%= bookStatus.get("tinhtrang_ct") %></td>
            <td>
                <a href="sua_tt.jsp?ma_sach_ct=<%= bookStatus.get("ma_sach_ct") %>" class="action-button edit-button">Sửa</a>
            </td>
        </tr>
        <%
            }
        %>
    </table>
    <% } else { %>
    <p>Không có tình trạng cho sách này.</p>
    <% } %>
</body>
</html>
