<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    // Đặt mã hóa ký tự cho yêu cầu
    request.setCharacterEncoding("UTF-8");
    
    // Lấy các tham số từ yêu cầu
    String maPhat = request.getParameter("ma_phat");
    String ttDongPhat = request.getParameter("tt_dong_phat");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Kết nối đến cơ sở dữ liệu
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/btl_jsp", "root", "");

        // Câu lệnh SQL để cập nhật trạng thái nộp phạt
        String sql = "UPDATE phat SET tt_dong_phat=? WHERE ma_phat=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, ttDongPhat);
        pstmt.setString(2, maPhat);

        // Thực hiện cập nhật
        int rows = pstmt.executeUpdate();
        if (rows > 0) {
            out.print("Cập nhật trạng thái nộp phạt thành công!");
        } else {
            out.print("Không tìm thấy phạt hoặc không có thay đổi.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("Lỗi: " + e.getMessage());
    } finally {
        // Đóng các kết nối
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
