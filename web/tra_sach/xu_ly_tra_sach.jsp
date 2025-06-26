<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Lấy thông tin từ biểu mẫu
    request.setCharacterEncoding("UTF-8");
    String maDocGia = request.getParameter("ma_doc_gia");
    String tenDocGia = request.getParameter("ten_doc_gia");
    String tenSach = request.getParameter("ten_sach");
    String ngayMuon = request.getParameter("ngay_muon");
    String ngayTraDuKien = request.getParameter("ngay_tra");
    String tinhTrangTra = request.getParameter("tinhtrang_lm_tra"); // Tình trạng lúc trả
    int maMuonSach = Integer.parseInt(request.getParameter("ma_muon_sach")); // ID mượn sách từ biểu mẫu

    // Kết nối đến cơ sở dữ liệu
    Connection conn = null;
    PreparedStatement pstmt = null;
    String url = "jdbc:mysql://127.0.0.1:3306/btl_jsp";
    String user = "root";
    String password = "";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);

        // Kiểm tra ngày trả
        java.util.Date today = new java.util.Date();
        java.util.Date ngayTraExpected = java.sql.Date.valueOf(ngayTraDuKien);
        boolean isLate = today.after(ngayTraExpected);

        // Cập nhật bảng trả sách
        String sqlReturn = "INSERT INTO trasach (ma_muon_sach, ngay_tra, tinhtrang_lt) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sqlReturn);
        pstmt.setInt(1, maMuonSach);
        pstmt.setDate(2, new java.sql.Date(today.getTime())); // Ngày trả là hôm nay
        pstmt.setString(3, tinhTrangTra); // Tình trạng lúc trả
        pstmt.executeUpdate();

        // Cập nhật trạng thái sách trong bảng tinhtrang
        String sqlUpdateBook = "UPDATE tinhtrang SET trangthai = 0, tinhtrang_ct = ? WHERE ma_sach_ct = (SELECT ma_sach_ct FROM tinhtrang WHERE ma_sach = (SELECT ma_sach FROM sach WHERE ten_sach = ?))";
        pstmt = conn.prepareStatement(sqlUpdateBook);
        pstmt.setString(1, tinhTrangTra); // Tình trạng lúc trả
        pstmt.setString(2, tenSach);
        pstmt.executeUpdate();

        // Thêm vào bảng phạt nếu cần
        if (isLate) {
            String sqlPenalty = "INSERT INTO phat (ma_doc_gia, so_tien_phat, ly_do) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sqlPenalty);
            pstmt.setString(1, maDocGia);
            pstmt.setInt(2, 10000); // Mức phạt 10,000 nếu trễ hạn
            pstmt.setString(3, "Trả sách muộn");
            pstmt.executeUpdate();
        }

        // Nếu sách bị rách, thêm vào bảng phạt
        if ("Rách".equalsIgnoreCase(tinhTrangTra)) {
            String sqlPenaltyDamage = "INSERT INTO phat (ma_doc_gia, so_tien_phat, ly_do) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sqlPenaltyDamage);
            pstmt.setString(1, maDocGia);
            pstmt.setInt(2, 50000); // Mức phạt 50,000 nếu sách bị rách
            pstmt.setString(3, "Sách bị rách");
            pstmt.executeUpdate();
        }

        out.println("<h2>Trả sách thành công!</h2>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h2>Có lỗi xảy ra: " + e.getMessage() + "</h2>");
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
