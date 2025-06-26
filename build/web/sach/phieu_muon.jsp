<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat, TT_CSDL.DBConnect" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tạo phiếu mượn sách</title>
    <style>
        table {
            margin: 0 auto;
            border-collapse: collapse;
            width: 50%;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
        input[type="date"] {
            padding: 5px;
            margin: 10px;
        }
        /* Style cho nút xác nhận */
        .submit-button {
            display: block; /* Để căn giữa */
            margin: 20px auto; /* Giữa theo chiều dọc và căn giữa */
            padding: 10px 20px; /* Khoảng cách trong nút */
            background-color: #4CAF50; /* Màu nền */
            color: white; /* Màu chữ */
            border: none; /* Không có viền */
            border-radius: 5px; /* Bo góc */
            cursor: pointer; /* Hiển thị con trỏ khi di chuột */
            font-size: 16px; /* Kích thước chữ */
            transition: background-color 0.3s; /* Hiệu ứng chuyển màu */
        }
        .submit-button:hover {
            background-color: #45a049; /* Màu khi di chuột */
        }
    </style>
</head>
<body>
    <h2 style="text-align: center;">Tạo phiếu mượn sách</h2>

    <%
        // Lấy ma_doc_gia từ session (giả định người dùng đã đăng nhập)
        Integer maDocGia = (Integer) session.getAttribute("ma_doc_gia");
        if (maDocGia == null) {
            maDocGia = 1; // Tạm thời dùng mã giả lập nếu chưa có session
        }

        // Lấy mã sách từ request
        int maSachCT = Integer.parseInt(request.getParameter("ma_sach_ct"));

        // Khai báo các biến để lưu tên sách và tên độc giả
        String tenSach = "";
        String tenDocGia = "";
        String tinhTrang = "";
        String tinhTrangChiTiet = ""; 

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            DBConnect db = new DBConnect();
            conn = db.KetNoi();

            // Lấy thông tin tên sách và tình trạng sách
            String query = "SELECT s.ten_sach, t.tinhtrang, t.tinhtrang_ct " +
                           "FROM sach s " +
                           "JOIN tinhtrang t ON s.ma_sach = t.ma_sach " +
                           "WHERE t.ma_sach_ct = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, maSachCT);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                tenSach = rs.getString("ten_sach");
                tinhTrang = rs.getString("tinhtrang");
                tinhTrangChiTiet = rs.getString("tinhtrang_ct");
            }

            // Lấy thông tin tên độc giả dựa trên ma_doc_gia
            String queryDocGia = "SELECT ten_doc_gia FROM docgia WHERE ma_doc_gia = ?";
            pstmt = conn.prepareStatement(queryDocGia);
            pstmt.setInt(1, maDocGia);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                tenDocGia = rs.getString("ten_doc_gia");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>

    <!-- Form nhập thông tin ngày mượn và ngày trả -->
    <form action="xac_nhan_muon_sach.jsp" method="post">
        <table>
            <tr>
                <th>Mã độc giả</th>
                <td><%= maDocGia %></td>
            </tr>
            <tr>
                <th>Tên độc giả</th>
                <td><%= tenDocGia %></td> <!-- Hiển thị tên độc giả -->
            </tr>
            <tr>
                <th>Mã sách CT</th>
                <td><%= maSachCT %></td>
            </tr>
            <tr>
                <th>Tên sách</th>
                <td><%= tenSach %></td> <!-- Hiển thị tên sách -->
            </tr>
            <tr>
                <th>Ngày mượn</th>
                <td><input type="date" name="ngay_muon" required></td>
            </tr>
            <tr>
                <th>Tình trạng sách</th>
                <td><%= tinhTrang %></td>
            </tr>
            <tr>
                <th>Tình trạng chi tiết</th>
                <td><%= tinhTrangChiTiet %></td>
            </tr>
            <tr>
                <th>Ngày trả</th>
                <td><input type="date" name="ngay_tra" required></td>
            </tr>
        </table>
        <input type="hidden" name="ma_sach_ct" value="<%= maSachCT %>">
        <input type="hidden" name="tinh_trang" value="<%= tinhTrang %>">
        <input type="hidden" name="tinh_trang_chi_tiet" value="<%= tinhTrangChiTiet %>">
        <!-- Nút xác nhận -->
        <input type="submit" class="submit-button" value="Xác nhận mượn">
    </form>
</body>
</html>
