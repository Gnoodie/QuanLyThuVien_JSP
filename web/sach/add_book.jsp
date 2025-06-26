<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.*, TT_CSDL.DBConnect, TT_CSDL.BookDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Sách</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        form {
            max-width: 600px;
            margin: auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        label {
            display: block;
            margin-bottom: 10px;
        }
        input[type="text"], input[type="number"], input[type="decimal"], select {
            width: 100%;
            padding: 8px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <h2>THÊM SÁCH MỚI</h2>

    <%
        request.setCharacterEncoding("UTF-8");
        // Kiểm tra nếu có yêu cầu POST
        if (request.getMethod().equalsIgnoreCase("POST")) {
            // Lấy thông tin từ form
            String tenSach = request.getParameter("ten_sach");
            int maTacGia = Integer.parseInt(request.getParameter("ma_tac_gia"));
            int maNXB = Integer.parseInt(request.getParameter("ma_nxb"));
            int namXuatBan = Integer.parseInt(request.getParameter("nam_xuat_ban"));
            BigDecimal gia = new BigDecimal(request.getParameter("gia"));
            String isbn = request.getParameter("isbn");
            int soTrang = Integer.parseInt(request.getParameter("so_trang"));
            String theLoai = request.getParameter("the_loai");
            int soLuong = Integer.parseInt(request.getParameter("so_luong"));

            try {
                // Gọi phương thức thêm sách từ BookDAO
                BookDAO.addBook(tenSach, maTacGia, maNXB, namXuatBan, gia, isbn, soTrang, theLoai, soLuong);
                out.println("<script>alert('Thêm sách và số lượng thành công!'); window.location.href='bang_sach.jsp';</script>");
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<script>alert('Đã xảy ra lỗi khi thêm sách!'); window.location.href='bang_sach.jsp';</script>");
            }
        }
    
        // Truy vấn lấy danh sách tác giả và nhà xuất bản
        Connection conn = null;
        PreparedStatement stmtTacGia = null;
        PreparedStatement stmtNXB = null;
        ResultSet rsTacGia = null;
        ResultSet rsNXB = null;

        try {
            conn = new DBConnect().KetNoi();
            String sqlTacGia = "SELECT ma_tac_gia, ten_tac_gia FROM tacgia";
            String sqlNXB = "SELECT ma_nxb, ten_nxb FROM nhaxuatban";

            stmtTacGia = conn.prepareStatement(sqlTacGia);
            stmtNXB = conn.prepareStatement(sqlNXB);

            rsTacGia = stmtTacGia.executeQuery();
            rsNXB = stmtNXB.executeQuery();
    %>

    <form action="add_book.jsp" method="post">
        <label for="ten_sach">Tên sách:</label>
        <input type="text" id="ten_sach" name="ten_sach" required>

        <label for="ma_tac_gia">Tác giả:</label>
        <select id="ma_tac_gia" name="ma_tac_gia" required>
            <option value="">Chọn tác giả</option>
            <%
                while (rsTacGia.next()) {
                    int maTacGia = rsTacGia.getInt("ma_tac_gia");
                    String tenTacGia = rsTacGia.getString("ten_tac_gia");
                    out.println("<option value='" + maTacGia + "'>" + tenTacGia + "</option>");
                }
            %>
        </select>

        <label for="ma_nxb">Nhà xuất bản:</label>
        <select id="ma_nxb" name="ma_nxb" required>
            <option value="">Chọn nhà xuất bản</option>
            <%
                while (rsNXB.next()) {
                    int maNXB = rsNXB.getInt("ma_nxb");
                    String tenNXB = rsNXB.getString("ten_nxb");
                    out.println("<option value='" + maNXB + "'>" + tenNXB + "</option>");
                }
            %>
        </select>

        <label for="nam_xuat_ban">Năm xuất bản:</label>
        <input type="number" id="nam_xuat_ban" name="nam_xuat_ban" required>

        <label for="gia">Giá:</label>
        <input type="decimal" id="gia" name="gia" required>

        <label for="isbn">ISBN:</label>
        <input type="text" id="isbn" name="isbn" required>

        <label for="so_trang">Số trang:</label>
        <input type="number" id="so_trang" name="so_trang" required>

        <label for="the_loai">Thể loại:</label>
        <input type="text" id="the_loai" name="the_loai" required>

        <label for="so_luong">Số lượng:</label>
        <input type="number" id="so_luong" name="so_luong" required>

        <input type="submit" value="Thêm Sách">
    </form>

    <%
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rsTacGia != null) rsTacGia.close();
            if (rsNXB != null) rsNXB.close();
            if (stmtTacGia != null) stmtTacGia.close();
            if (stmtNXB != null) stmtNXB.close();
            if (conn != null) conn.close();
        }
    %>
</body>
</html>
