<%@ page import="java.sql.*, TT_CSDL.DBConnect" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Người Dùng</title>
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

<%
    // Lấy email từ session
    String email = (String) session.getAttribute("email");
    Integer maDocGia = null;

    if (email != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            DBConnect db = new DBConnect();
            conn = db.KetNoi();

            // Truy vấn để lấy ma_doc_gia từ email
            String query = "SELECT ma_doc_gia FROM docgia WHERE email = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                maDocGia = rs.getInt("ma_doc_gia");
                session.setAttribute("ma_doc_gia", maDocGia);
            } else {
                out.println("Không tìm thấy mã độc giả cho email này.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    } else {
        out.println("Người dùng chưa đăng nhập.");
    }
%>

    <div class="container">
        <h2>Xin chào, <%= email %>!</h2>
<!--        <p>Mã độc giả của bạn là: <%= maDocGia != null ? maDocGia : "Không xác định" %></p>-->
        <p>Lựa chọn chức năng:</p>
        <ul>
            <li><a href="<%= request.getContextPath() %>/sach/muon_sach.jsp">Mượn sách</a></li>
            <li><a href="<%= request.getContextPath() %>/sach/sach_muon.jsp">Xem danh sách đang mượn</a></li>
            <li><a href="<%= request.getContextPath() %>/doc_gia/theo_doi_phat_dg.jsp">Theo dõi phạt cá nhân</a></li>
        </ul>
    </div>

</body>
</html>
