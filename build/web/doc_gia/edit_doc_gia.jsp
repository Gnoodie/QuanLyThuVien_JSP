<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    String maDocGia = request.getParameter("ma_doc_gia");
    String tenDocGia = request.getParameter("ten_doc_gia");
    String ngaySinh = request.getParameter("ngay_sinh");
    String diaChi = request.getParameter("dia_chi");
    String soDienThoai = request.getParameter("so_dien_thoai");
    String email = request.getParameter("email");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/btl_jsp", "root", "");

        String sql = "UPDATE docgia SET ten_doc_gia=?, ngay_sinh=?, dia_chi=?, so_dien_thoai=?, email=? WHERE ma_doc_gia=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, tenDocGia);
        pstmt.setString(2, ngaySinh);
        pstmt.setString(3, diaChi);
        pstmt.setString(4, soDienThoai);
        pstmt.setString(5, email);
        pstmt.setString(6, maDocGia);

        int rows = pstmt.executeUpdate();
        if (rows > 0) {
            out.print("Cập nhật thông tin độc giả thành công!");
        } else {
            out.print("Không tìm thấy độc giả hoặc không có thay đổi.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("Lỗi: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
