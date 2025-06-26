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
    String password = "123"; // Mật khẩu tự động là 123
    String role = "user"; // Vai trò mặc định cho độc giả

    Connection conn = null;
    PreparedStatement pstmtDocGia = null;
    PreparedStatement pstmtUser = null;

    try {
        // Kết nối đến cơ sở dữ liệu
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/btl_jsp", "root", "");

        // Câu lệnh SQL thêm vào bảng user
        String sqlUser = "INSERT INTO user (email, password, role) VALUES (?, ?, ?)";
        pstmtUser = conn.prepareStatement(sqlUser);
        pstmtUser.setString(1, email);
        pstmtUser.setString(2, password); // Mật khẩu là 123
        pstmtUser.setString(3, role);     // Vai trò mặc định là "user"
        
        // Câu lệnh SQL thêm vào bảng docgia
        String sqlDocGia = "INSERT INTO docgia (ma_doc_gia, ten_doc_gia, ngay_sinh, dia_chi, so_dien_thoai, email) VALUES (?, ?, ?, ?, ?, ?)";
        pstmtDocGia = conn.prepareStatement(sqlDocGia);
        pstmtDocGia.setString(1, maDocGia);
        pstmtDocGia.setString(2, tenDocGia);
        pstmtDocGia.setString(3, ngaySinh);
        pstmtDocGia.setString(4, diaChi);
        pstmtDocGia.setString(5, soDienThoai);
        pstmtDocGia.setString(6, email);

        // Thực thi cả hai câu lệnh
        int rowsUser = pstmtUser.executeUpdate();
        int rowsDocGia = pstmtDocGia.executeUpdate();

        // Kiểm tra xem có thành công không
        if (rowsDocGia > 0 && rowsUser > 0) {
            out.print("Thêm độc giả và tài khoản người dùng thành công!");
        } else {
            out.print("Có lỗi xảy ra khi thêm độc giả hoặc tài khoản.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("Lỗi: " + e.getMessage());
    } finally {
        if (pstmtDocGia != null) pstmtDocGia.close();
        if (pstmtUser != null) pstmtUser.close();
        if (conn != null) conn.close();
    }
%>
