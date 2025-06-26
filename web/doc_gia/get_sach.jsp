<%@ page import="java.sql.*" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    String maSach = request.getParameter("ma_sach");
    String json = "{}"; // Dữ liệu JSON mặc định
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/btl_jsp", "root", "");
        String query = "SELECT ten_sach FROM sach WHERE ma_sach = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, maSach);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            String tenSach = rs.getString("ten_sach");
            json = String.format("{\"ten_sach\":\"%s\"}", tenSach);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }

    out.print(json);
%>
