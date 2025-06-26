<%@ page import="java.sql.*, TT_CSDL.DBConnect, TT_CSDL.StatusDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sửa tình trạng sách</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        form {
            margin-top: 20px;
        }
        label {
            font-size: 16px;
            color: #555;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            font-size: 16px;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        input:focus, select:focus {
            outline: none;
            border-color: #007BFF;
        }
        input[type="submit"] {
            background-color: #007BFF;
            color: white;
            border: none;
            cursor: pointer;
            font-weight: bold;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        a {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #007BFF;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Sửa tình trạng sách</h2>

        <%
            int maSachct = 0;
            String tenSach = "";
            int trangThai = 0; // mặc định
            String tinhTrang = "";
            String tinhTrangCt = "";

            // Kiểm tra nếu có tham số ma_sach_ct
            if (request.getParameter("ma_sach_ct") != null) {
                maSachct = Integer.parseInt(request.getParameter("ma_sach_ct"));

                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    // Xử lý cập nhật khi form được submit
                    trangThai = Integer.parseInt(request.getParameter("trangthai"));
                    tinhTrang = request.getParameter("tinhtrang");
                    tinhTrangCt = request.getParameter("tinhtrang_ct");

                    // Cập nhật dữ liệu vào DB
                    boolean isUpdated = StatusDAO.updateStatus(maSachct, trangThai, tinhTrang, tinhTrangCt);

                    if (isUpdated) {
                        out.println("<p>Cập nhật thành công!</p>");
                    } else {
                        out.println("<p>Có lỗi xảy ra khi cập nhật!</p>");
                    }
                } else {
                    // Lấy thông tin sách để hiển thị trong form
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        DBConnect db = new DBConnect();
                        conn = db.KetNoi();

                        String query = "SELECT sach.ten_sach, tinhtrang.trangthai, tinhtrang.tinhtrang, tinhtrang.tinhtrang_ct "
                                     + "FROM tinhtrang "
                                     + "JOIN sach ON tinhtrang.ma_sach = sach.ma_sach "
                                     + "WHERE tinhtrang.ma_sach_ct = ?";
                        pstmt = conn.prepareStatement(query);
                        pstmt.setInt(1, maSachct);
                        rs = pstmt.executeQuery();

                        if (rs.next()) {
                            tenSach = rs.getString("ten_sach");
                            trangThai = rs.getInt("trangthai");
                            tinhTrang = rs.getString("tinhtrang");
                            tinhTrangCt = rs.getString("tinhtrang_ct");
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { }
                    }
                }
            }
        %>

        <form method="post" action="sua_tt.jsp?ma_sach_ct=<%= maSachct %>">
            <label for="ten_sach">Tên sách:</label>
            <input type="text" id="ten_sach" name="ten_sach" value="<%= tenSach %>" readonly><br>

            <label for="trangthai">Trạng thái:</label>
            <select id="trangthai" name="trangthai">
                <option value="0" <%= trangThai == 0 ? "selected" : "" %>>Còn</option>
                <option value="1" <%= trangThai == 1 ? "selected" : "" %>>Đã mượn</option>
            </select><br>

            <label for="tinhtrang">Tình trạng:</label>
            <select id="tinhtrang" name="tinhtrang">
                <option value="Mới" <%= "Mới".equalsIgnoreCase(tinhTrang) ? "selected" : "" %>>Mới</option>
                <option value="Cũ" <%= "Cũ".equalsIgnoreCase(tinhTrang) ? "selected" : "" %>>Cũ</option>
            </select><br>

            <label for="tinhtrang_ct">Tình trạng chi tiết:</label>
            <select id="tinhtrang_ct" name="tinhtrang_ct">
                <option value="Nguyên" <%= "Nguyên".equalsIgnoreCase(tinhTrangCt) ? "selected" : "" %>>Nguyên</option>
                <option value="Rách" <%= "Rách".equalsIgnoreCase(tinhTrangCt) ? "selected" : "" %>>Rách</option>
            </select><br><br>

            <input type="submit" value="Cập nhật">
        </form>

        <a href="tinh-trang_sach.jsp">Quay lại danh sách tình trạng sách</a>
    </div>
</body>
</html>
