<%@ page import="java.sql.*, java.util.*, TT_CSDL.DBConnect" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Thông tin sách đang mượn</title>
    <style>
        table {
            margin: 0 auto;
            border-collapse: collapse;
            width: 70%;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
        h2 {
            text-align: center;
        }
    </style>
</head>
<body>
    <h2>Thông tin sách đang mượn</h2>

    <%
        Integer maDocGia = (Integer) session.getAttribute("ma_doc_gia");
        if (maDocGia == null) {
            out.println("<p>Vui lòng đăng nhập để xem thông tin mượn sách.</p>");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            DBConnect db = new DBConnect();
            conn = db.KetNoi();

            // Lấy thông tin sách đang mượn, loại bỏ sách đã được trả
            String query = "SELECT d.ten_doc_gia, s.ten_sach, tt.tinhtrang, ms.ngay_muon, ms.ngay_tra " +
                           "FROM muonsach ms " +
                           "JOIN tinhtrang tt ON ms.ma_sach_ct = tt.ma_sach_ct " +
                           "JOIN sach s ON tt.ma_sach = s.ma_sach " +
                           "JOIN docgia d ON ms.ma_doc_gia = d.ma_doc_gia " +
                           "LEFT JOIN trasach ts ON ms.ma_muon_sach = ts.ma_muon_sach " +
                           "WHERE ms.ma_doc_gia = ? AND ts.ma_muon_sach IS NULL";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, maDocGia);
            rs = pstmt.executeQuery();

            // Hiển thị thông tin trong bảng
            if (rs.next()) {
                out.println("<table>");
                out.println("<tr><th>Tên độc giả</th><th>Tên sách</th><th>Tình trạng sách</th><th>Ngày mượn</th><th>Ngày trả</th></tr>");
                do {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("ten_doc_gia") + "</td>");
                    out.println("<td>" + rs.getString("ten_sach") + "</td>");
                    out.println("<td>" + rs.getString("tinhtrang") + "</td>");
                    out.println("<td>" + rs.getDate("ngay_muon") + "</td>");
                    out.println("<td>" + rs.getDate("ngay_tra") + "</td>");
                    out.println("</tr>");
                } while (rs.next());
                out.println("</table>");
            } else {
                out.println("<p>Không có sách nào đang mượn.</p>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Đã xảy ra lỗi trong quá trình truy vấn dữ liệu.</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
</body>
</html>
