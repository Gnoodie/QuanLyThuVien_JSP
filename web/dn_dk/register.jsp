<%@ page import="java.sql.*" %>
<%
    String dbURL = "jdbc:mysql://localhost:3306/btl_jsp"; // Update with your database name
    String dbUser = "root";  // Update with your database username
    String dbPass = "";  // Update with your database password

    String email = request.getParameter("mail");   // User's email
    String pass = request.getParameter("pass");    // User's password

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Create a connection to the database
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Step 1: Check if the email already exists
        String checkEmailQuery = "SELECT * FROM user WHERE email = ?";
        ps = conn.prepareStatement(checkEmailQuery);
        ps.setString(1, email);
        rs = ps.executeQuery();

        if (rs.next()) {
            // If email already exists, display an error message
            out.println("<h3>Error: Email already exists. Please use a different email.</h3>");
        } else {
            // Step 2: If email doesn't exist, insert the new user
            String insertQuery = "INSERT INTO user (email, password) VALUES (?, ?)";
            ps = conn.prepareStatement(insertQuery);
            ps.setString(1, email);
            ps.setString(2, pass);

            int result = ps.executeUpdate();

            if (result > 0) {
%>
                <!-- JavaScript to show pop-up and redirect -->
                <script>
                    alert("Register success!");
                    setTimeout(function() {
                        window.location.href = 'login.jsp'; // Redirect to login page after 2 seconds
                    }, 1000); // 2000 milliseconds = 2 seconds
                </script>
<%
            } else {
                out.println("<h3>Error: Could not register user.</h3>");
            }
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
