<%@ page import="java.sql.*" %>
<%
    String dbURL = "jdbc:mysql://localhost:3306/btl_jsp"; // C?p nh?t v?i tên c? s? d? li?u c?a b?n
    String dbUser = "root";  // C?p nh?t v?i tên ng??i dùng c? s? d? li?u c?a b?n
    String dbPass = "";  // C?p nh?t v?i m?t kh?u c? s? d? li?u c?a b?n

    String email = request.getParameter("lmail");
    String pass = request.getParameter("lpass");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // SQL query ?? ki?m tra email và password
        String query = "SELECT * FROM user WHERE email = ? AND password = ?";
        ps = conn.prepareStatement(query);
        ps.setString(1, email);
        ps.setString(2, pass);

        rs = ps.executeQuery();

        if (rs.next()) {
            String role = rs.getString("role"); // L?y vai trò c?a ng??i dùng

            // L?u email vào session
            session.setAttribute("email", email);

            // Ki?m tra vai trò và chuy?n h??ng ??n trang phù h?p
            if ("admin".equals(role)) {
                // ??ng nh?p v?i vai trò admin
                request.getRequestDispatcher("../admin_dashboard.jsp").forward(request, response);
            } else if ("user".equals(role)) {
                // ??ng nh?p v?i vai trò ??c gi? (user)
                request.getRequestDispatcher("../user_dashboard.jsp").forward(request, response);
            } else {
                // N?u vai trò không xác ??nh
                out.println("<h3>Login failed. Invalid role.</h3>");
                response.sendRedirect("index.html"); // Redirect back to index.html for login
            }
        } else {
            // N?u ??ng nh?p th?t b?i
            out.println("<h3>Login failed. Invalid email or password.</h3>");
            response.sendRedirect("index.html"); // Redirect back to index.html for login
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
