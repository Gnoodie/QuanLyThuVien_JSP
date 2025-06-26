<%@page import="java.util.Map"%>
<%@page import="java.math.BigDecimal"%>
<%@ page import="java.sql.*, TT_CSDL.BookDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Cập nhật sách</title>
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
            input[type="text"], input[type="number"] {
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
        <h2>Cập nhật thông tin sách</h2>

        <%
            request.setCharacterEncoding("UTF-8");
            String maSachStr = request.getParameter("ma_sach");
            int maSach = 0;
            if (maSachStr != null && !maSachStr.isEmpty()) {
                maSach = Integer.parseInt(maSachStr);
            }
            
            // Lấy thông tin sách từ DAO
            Map<String, Object> book = BookDAO.getBookById(maSach);
            
            // Kiểm tra form POST
            if (request.getMethod().equalsIgnoreCase("POST")) {
                // Lấy dữ liệu từ form
                String tenSach = request.getParameter("ten_sach");
                String tenTacGia = request.getParameter("ten_tac_gia");
                String tenNXB = request.getParameter("ten_nxb");
                String namXuatBanStr = request.getParameter("nam_xuat_ban");
                String giaStr = request.getParameter("gia");
                String isbn = request.getParameter("isbn");
                String soTrangStr = request.getParameter("so_trang");
                String theLoai = request.getParameter("the_loai");

                int namXuatBan = 0;
                if (namXuatBanStr != null && !namXuatBanStr.isEmpty()) {
                    namXuatBan = Integer.parseInt(namXuatBanStr);
                }

                BigDecimal gia = BigDecimal.ZERO;
                if (giaStr != null && !giaStr.isEmpty()) {
                    gia = new BigDecimal(giaStr);
                }

                int soTrang = 0;
                if (soTrangStr != null && !soTrangStr.isEmpty()) {
                    soTrang = Integer.parseInt(soTrangStr);
                }

                // Gọi phương thức cập nhật sách trong BookDAO
                boolean updated = BookDAO.updateBook(maSach, tenSach, tenTacGia, tenNXB, namXuatBan, gia, isbn, soTrang, theLoai);
                
                if (updated) {
                    out.println("<p>Sách đã được cập nhật thành công! Đang chuyển hướng...</p>");
                    response.setHeader("Refresh", "3; URL=bang_sach.jsp"); // Tự động chuyển về trang list_sach.jsp
                } else {
                    out.println("<p>Cập nhật sách thất bại!</p>");
                }
            }
        %>

        <form action="sua_sach.jsp" method="post">
            <input type="hidden" name="ma_sach" value="<%= book.get("ma_sach") %>">
            Tên sách: <input type="text" name="ten_sach" value="<%= book.get("ten_sach") %>"><br>
            Tên tác giả: <input type="text" name="ten_tac_gia" value="<%= book.get("ten_tac_gia") %>"><br>
            Nhà xuất bản: <input type="text" name="ten_nxb" value="<%= book.get("ten_nxb") %>"><br>
            Năm xuất bản: <input type="text" name="nam_xuat_ban" value="<%= book.get("nam_xuat_ban") %>"><br>
            Giá: <input type="text" name="gia" value="<%= book.get("gia") %>"><br>
            ISBN: <input type="text" name="isbn" value="<%= book.get("isbn") %>"><br>
            Số trang: <input type="text" name="so_trang" value="<%= book.get("so_trang") %>"><br>
            Thể loại: <input type="text" name="the_loai" value="<%= book.get("the_loai") %>"><br>
            <input type="submit" value="Cập nhật">
        </form>
    </body>
</html>
