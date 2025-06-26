<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        ul {
            list-style: none;
            padding: 0;
        }
        ul li {
            background: #FF416C;
            background: -webkit-linear-gradient(to right, #FF4B2B, #FF416C);
            background: linear-gradient(to right, #FF4B2B, #FF416C);
            color: white;
            padding: 10px;
            margin-bottom: 10px;
            text-align: center;
            border-radius: 5px;
        }
        ul li a {
            color: white;
            text-decoration: none;
            font-size: 16px;
        }
        ul li a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Xin chào, quản trị viên <%= session.getAttribute("email") %>!</h2>
        <p>Lựa chọn chức năng:</p>
        <ul>
            <li><a href="<%= request.getContextPath() %>/sach/bang_sach.jsp">Quản lý sách</a></li>
            <li><a href="<%= request.getContextPath() %>/doc_gia/danhsachdocgia.jsp">Quản lý độc giả</a></li>
            <li><a href="<%= request.getContextPath() %>/tra_sach/Hienthi.jsp">Theo dõi mượn</a></li>
            <li><a href="<%= request.getContextPath() %>/tra_sach/hantra.jsp">Theo dõi trả</a></li>
            <li><a href="<%= request.getContextPath() %>/doc_gia/theo_doi_phat.jsp">Theo dõi phạt</a></li>
            <li><a href="../BangThongTin.jsp">Xem thống kê</a></li>
<!--<li><a href="logout.jsp">Logout</a></li>-->
        </ul>
    </div>

</body>
</html>
