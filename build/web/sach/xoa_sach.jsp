<%@ page import="java.sql.*, TT_CSDL.BookDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xóa Sách</title>
</head>
<body>
    <%
        int maSach = Integer.parseInt(request.getParameter("ma_sach"));

        // Call the delete method from BookDAO
        boolean deleted = BookDAO.deleteBook(maSach);

        if (deleted) {
            out.println("<h2>Xóa sách thành công!</h2>");
        } else {
            out.println("<h2>Có lỗi xảy ra khi xóa sách!</h2>");
        }
        out.println("<a href='bang_sach.jsp'>Quay lại danh sách sách</a>");
    %>
</body>
</html>
