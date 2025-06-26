<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo cáo độc giả chưa trả sách</title>
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
        }
    </style>
</head>
<body>
    <h1>Báo cáo độc giả chưa trả sách</h1>

    <table border="1">
        <tr>
            <th>Mã Độc Giả</th>
            <th>Tên Độc Giả</th>
            <th>Tên Sách Mượn</th>
            <th>Ngày Trả Dự Kiến</th>
            <th>Số Ngày Muộn</th>
            <th>Số Tiền Phạt</th>
        </tr>
        <%
            String url = "jdbc:mysql://localhost:3306/btl_jsp";
            String username = "root";
            String password = "";

            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, username, password);
                stmt = conn.createStatement();

                // Truy vấn lấy tất cả các độc giả chưa trả sách và có số ngày muộn
                String query = "SELECT docgia.ma_doc_gia, docgia.ten_doc_gia, sach.ten_sach, muonsach.ngay_tra " +
                               "FROM docgia " +
                               "JOIN muonsach ON docgia.ma_doc_gia = muonsach.ma_doc_gia " +
                               "JOIN tinhtrang ON tinhtrang.ma_sach_ct = muonsach.ma_sach_ct " +
                               "JOIN sach ON sach.ma_sach = tinhtrang.ma_sach " +
                               "WHERE muonsach.ngay_tra < CURDATE()";

                rs = stmt.executeQuery(query);

                // Lấy ngày hiện tại
                java.util.Date currentDate = new java.util.Date();
                java.sql.PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO phat (ma_doc_gia, ly_do, so_tien_phat, tt_dong_phat) VALUES (?, ?, ?, ?)");

                // Vòng lặp để hiển thị tất cả kết quả
                while(rs.next()) {
                    String maDocGia = rs.getString("ma_doc_gia");
                    String tenDocGia = rs.getString("ten_doc_gia");
                    String tenSach = rs.getString("ten_sach");
                    java.sql.Date sqlNgayTra = rs.getDate("ngay_tra");

                    // Chuyển đổi java.sql.Date sang chuỗi ngày (không có thời gian)
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                    String ngayTraStr = (sqlNgayTra != null) ? sdf.format(sqlNgayTra) : "Không xác định";

                    // Tính số ngày muộn
                    long soNgayMuon = 0;
                    if (sqlNgayTra != null) {
                        long diffInMillies = currentDate.getTime() - sqlNgayTra.getTime();
                        soNgayMuon = diffInMillies / (1000 * 60 * 60 * 24);
                    }

                    // Tính tiền phạt dựa trên số ngày muộn (giả sử 10.000 VNĐ mỗi ngày muộn)
                    int soTienPhat = (int) (soNgayMuon * 10000);

                    // Thêm thông tin phạt vào bảng 'phat'
                    insertStmt.setString(1, maDocGia);
                    insertStmt.setString(2, "Trễ hạn trả sách: " + tenSach);
                    insertStmt.setInt(3, soTienPhat);
                    insertStmt.setString(4, "Chưa đóng");
                    insertStmt.executeUpdate();

                    // Hiển thị thông tin độc giả chưa trả sách với số ngày muộn và số tiền phạt
                    %>
                    <tr>
                        <td><%= maDocGia %></td>
                        <td><%= tenDocGia %></td>
                        <td><%= tenSach %></td>
                        <td><%= ngayTraStr %></td>
                        <td><%= soNgayMuon %> ngày muộn</td>
                        <td><%= soTienPhat %> VNĐ</td>
                    </tr>
                    <%
                }
                insertStmt.close();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
</body>
</html>
