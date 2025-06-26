<%@page import="java.sql.SQLException"%>
<%@ page import="java.util.*, TT_CSDL.BookDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách tất cả các sách trong thư viện</title>
        <style>
            table {
                width: 80%;
                margin: 20px auto;
                border-collapse: collapse;
                text-align: left;
            }

            table, th, td {
                border: 1px solid #ccc;
            }

            th, td {
                padding: 10px;
            }

            th {
                background-color: #f2f2f2;
            }

            h2 {
                text-align: center;
                color: #333;
            }

            .add-button {
                display: block;
                width: 200px;
                margin: 20px auto;
                padding: 10px;
                text-align: center;
                background-color: #4CAF50;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                transition: background-color 0.3s ease;
            }

            .add-button:hover {
                background-color: #45a049;
            }

            .action-button {
                padding: 5px 10px;
                color: white;
                border: none;
                border-radius: 3px;
                cursor: pointer;
            }

            .delete-button {
                background-color: #f44336;
            }

            .edit-button {
                background-color: #2196F3;
            }

            .search-form {
                text-align: center;
                margin: 20px auto;
            }

            .search-input {
                margin-right: 10px;
                padding: 5px;
                border-radius: 3px;
                border: 1px solid #ccc;
            }

            .search-button {
                padding: 5px 10px;
                border-radius: 3px;
                border: none;
                background-color: #2196F3;
                color: white;
                cursor: pointer;
            }

            .search-button:hover {
                background-color: #1e88e5;
            }
            .view-button {
                background-color: #ffa500; /* Màu cam cho nút Tình trạng */
                padding: 5px 10px;
                color: white;
                border: none;
                border-radius: 3px;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <h2>Danh sách tất cả các sách trong thư viện</h2>

        <a href="add_book.jsp" class="add-button">Thêm sách</a>

        <div class="search-form">
            <form action="" method="get">
                <input type="text" name="ten_sach" class="search-input" placeholder="Tên sách">
                <input type="text" name="ten_tac_gia" class="search-input" placeholder="Tác giả">
                <input type="text" name="ten_nxb" class="search-input" placeholder="Nhà xuất bản">
                <input type="text" name="the_loai" class="search-input" placeholder="Thể loại">
                <input type="submit" value="Tìm kiếm" class="search-button">
            </form>
        </div>

        <%
            String tenSach = request.getParameter("ten_sach");
            String tenTacGia = request.getParameter("ten_tac_gia");
            String tenNXB = request.getParameter("ten_nxb");
            String theLoai = request.getParameter("the_loai");

            List<Map<String, Object>> books = null;
            try {
                books = BookDAO.getBooks(tenSach, tenTacGia, tenNXB, theLoai);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>

        <table>
            <tr>
                <th>Mã sách</th>
                <th>Tên sách</th>
                <th>Tên tác giả</th>
                <th>Nhà xuất bản</th>
                <th>Năm xuất bản</th>
                <th>Giá</th>
                <th>ISBN</th>
                <th>Số trang</th>
                <th>Thể loại</th>
                <th>Thao tác</th>
            </tr>
            <%
                if (books != null) {
                    for (Map<String, Object> book : books) {
            %>
            <tr>
                <td><%= book.get("ma_sach")%></td>
                <td><%= book.get("ten_sach")%></td>
                <td><%= book.get("ten_tac_gia")%></td>
                <td><%= book.get("ten_nxb")%></td>
                <td><%= book.get("nam_xuat_ban")%></td>
                <td><%= book.get("gia")%></td>
                <td><%= book.get("isbn")%></td>
                <td><%= book.get("so_trang")%></td>
                <td><%= book.get("the_loai")%></td>
                <td>
                    <a href="sua_sach.jsp?ma_sach=<%= book.get("ma_sach")%>" class="action-button edit-button">Sửa</a>
                    <a href="xoa_sach.jsp?ma_sach=<%= book.get("ma_sach")%>" class="action-button delete-button" onclick="return confirm('Bạn có chắc chắn muốn xóa sách này?');">Xóa</a>
                    <a href="tinh_trang_sach.jsp?ma_sach=<%= book.get("ma_sach")%>" class="action-button view-button">Tình trạng</a>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table>
    </body>
</html>
