<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Theo dõi hạn trả sách</title>
    <script>
        // Tạo mảng để lưu trữ thông báo
        var danhSachThongBao = [];

        // Hàm hiển thị tất cả các thông báo trong một alert duy nhất
        function hienThiTatCaThongBao() {
            if (danhSachThongBao.length > 0) {
                alert(danhSachThongBao.join("\n"));
            }
        }
    </script>
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
        .notify-button, .action-button {
            background-color: #3167AF;
            color: white;
            font-style: italic;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h1 style="text-align: center">THEO DÕI HẠN TRẢ SÁCH</h1>
    
    <table border="1">
        <tr>
            <th>Mã độc giả</th>
            <th>Tên độc giả</th>
            <th>Tên sách mượn</th>
            <th>Ngày trả dự kiến</th>
            <th>Thông báo</th>
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
                
                // Câu truy vấn cập nhật để kiểm tra thông tin trả sách
                String query = "SELECT docgia.ma_doc_gia, docgia.ten_doc_gia, " +
                               "sach.ten_sach, muonsach.ngay_tra, trasach.ma_tra_sach " +
                               "FROM docgia " +
                               "JOIN muonsach ON docgia.ma_doc_gia = muonsach.ma_doc_gia " +
                               "JOIN tinhtrang ON tinhtrang.ma_sach_ct = muonsach.ma_sach_ct " +
                               "JOIN sach ON sach.ma_sach = tinhtrang.ma_sach " +
                               "LEFT JOIN trasach ON trasach.ma_muon_sach = muonsach.ma_muon_sach";

                rs = stmt.executeQuery(query);
                
                while(rs.next()) {
                    String maDocGia = rs.getString("ma_doc_gia");
                    String tenDocGia = rs.getString("ten_doc_gia");
                    String tenSach = rs.getString("ten_sach");
                    java.sql.Date sqlNgayTra = rs.getDate("ngay_tra");
                    String maTraSach = rs.getString("ma_tra_sach");

                    // Chuyển đổi java.sql.Date sang chuỗi ngày (không có thời gian)
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                    String ngayTraStr = (sqlNgayTra != null) ? sdf.format(sqlNgayTra) : "Không xác định";

                    // Lấy ngày hiện tại
                    java.util.Date currentDate = new java.util.Date();
                    
                    // Tính số ngày còn lại (chỉ nếu ngày trả có giá trị)
                    long soNgayConLai = -1;
                    if (sqlNgayTra != null) {
                        long diffInMillies = sqlNgayTra.getTime() - currentDate.getTime();
                        soNgayConLai = diffInMillies / (1000 * 60 * 60 * 24);
                    }

                    // Nếu số ngày còn lại <= 3, thêm thông báo vào mảng
                    if (sqlNgayTra != null && soNgayConLai <= 3) {
                        %>
                        <script>
                            danhSachThongBao.push("Độc giả <%= tenDocGia %> mượn sách '<%= tenSach %>' cần trả vào ngày: <%= ngayTraStr %>");
                        </script>
                        <%
                    }
                    
                    %>
                    <tr>
                        <td><%= maDocGia %></td>
                        <td><%= tenDocGia %></td>
                        <td><%= tenSach %></td>
                        <td><%= ngayTraStr %></td>
                        <td>
                            <% if (maTraSach != null) { %>
                                Đã trả
                            <% } else if (sqlNgayTra != null && soNgayConLai <= 3) { %>
                                <form action="guiThongBao.jsp" method="post">
                                    <input type="hidden" name="maDocGia" value="<%= maDocGia %>">
                                    <button type="submit">Thông báo</button>
                                </form>
                            <% } else { %>
                                Không có thông báo
                            <% } %>
                        </td>
                    </tr>
                    <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>

    <!-- Gọi hàm hiển thị tất cả các thông báo sau khi trang được tải -->
    <script>
        hienThiTatCaThongBao();
    </script>
</body>
</html>
