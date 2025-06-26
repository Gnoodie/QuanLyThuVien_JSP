<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông Tin Trả Sách</title>
</head>
<body>
    <h1>Thông Tin Trả Sách</h1>

    <%
        // Lấy các tham số từ URL
        request.setCharacterEncoding("UTF-8");
        String maMuonSach = request.getParameter("ma_muon_sach");
        String maDocGia = request.getParameter("ma_doc_gia");
        String tenDocGia = request.getParameter("ten_doc_gia");
        String tenSach = request.getParameter("ten_sach");
        String ngayMuon = request.getParameter("ngay_muon");
        String ngayTra = request.getParameter("ngay_tra");
        String tinhTrang = request.getParameter("tinhtrang_lm");
    %>

    <table border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>Mã Mượn Sách</th>
            <td><%= maMuonSach %></td>
        </tr>
        <tr>
            <th>Mã Độc Giả</th>
            <td><%= maDocGia %></td>
        </tr>
        <tr>
            <th>Tên Độc Giả</th>
            <td><%= tenDocGia %></td>
        </tr>
        <tr>
            <th>Tên Sách</th>
            <td><%= tenSach %></td>
        </tr>
        <tr>
            <th>Ngày Mượn</th>
            <td><%= ngayMuon %></td>
        </tr>
        <tr>
            <th>Ngày Trả Dự Kiến</th>
            <td><%= ngayTra %></td>
        </tr>
        <tr>
            <th>Tình Trạng Lúc Mượn</th>
            <td><%= tinhTrang %></td>
        </tr>
        <tr>
            <th>Tình Trạng Lúc Trả</th>
            <td>
                <input type="text" name="tinhtrang_lm_tra" placeholder="Nhập tình trạng lúc trả">
            </td>
        </tr>
    </table>

    <form action="xulytrasach.jsp" method="post">
        <input type="hidden" name="ma_muon_sach" value="<%= maMuonSach %>">
        <input type="hidden" name="tinhtrang_lm_tra" value="<%= request.getParameter("tinhtrang_lm_tra") %>">
        
        <button type="submit">Xác Nhận Trả Sách</button>
    </form>
</body>
</html>
