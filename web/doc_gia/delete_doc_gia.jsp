<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String email = request.getParameter("email"); // Nhận email từ request

    Connection conn = null;
    PreparedStatement pstmtDocGia = null;
    PreparedStatement pstmtUser = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/btl_jsp", "root", "");

        // Bắt đầu giao dịch
        conn.setAutoCommit(false); // Tắt tự động xác nhận

        // Câu lệnh SQL xóa trong bảng docgia
        String sqlDocGia = "DELETE FROM docgia WHERE email=?";
        pstmtDocGia = conn.prepareStatement(sqlDocGia);
        pstmtDocGia.setString(1, email);

        int rowsDocGia = pstmtDocGia.executeUpdate();
        
        // Nếu xóa độc giả thành công, xóa tài khoản trong bảng user
        if (rowsDocGia > 0) {
            // Câu lệnh SQL xóa trong bảng user
            String sqlUser = "DELETE FROM user WHERE email=?";
            pstmtUser = conn.prepareStatement(sqlUser);
            pstmtUser.setString(1, email);
            
            int rowsUser = pstmtUser.executeUpdate();

            // Kiểm tra xem có xóa tài khoản thành công không
            if (rowsUser > 0) {
                out.print("Xóa độc giả và tài khoản người dùng thành công!");
            } else {
                out.print("Đã xóa độc giả nhưng không tìm thấy tài khoản để xóa.");
            }
        } else {
            out.print("Không tìm thấy độc giả để xóa.");
        }

        // Xác nhận giao dịch
        conn.commit();
    } catch (Exception e) {
        if (conn != null) {
            try {
                conn.rollback(); // Hoàn tác nếu có lỗi
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        e.printStackTrace();
        out.print("Lỗi: " + e.getMessage());
    } finally {
        if (pstmtDocGia != null) pstmtDocGia.close();
        if (pstmtUser != null) pstmtUser.close();
        if (conn != null) conn.close();
    }
%>
