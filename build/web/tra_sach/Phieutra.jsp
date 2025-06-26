<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>THÔNG TIN TRẢ SÁCH</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        input[type="text"], input[type="date"], select {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }
        button {
            padding: 10px 15px;
            background-color: #2196F3;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #0b7dda;
        }
    </style>
</head>
<body>
    <h1 style="text-align: center">THÔNG TIN TRẢ SÁCH</h1>

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

    <form action="xu_ly_tra_sach.jsp" method="post">
        <table>
            <tr>
                <th>Mã mượn sách</th>
                <td><input type="text" name="ma_muon_sach" value="<%= maMuonSach %>" readonly></td>
            </tr>
            <tr>
                <th>Mã độc giả</th>
                <td><input type="text" name="ma_doc_gia" value="<%= maDocGia %>" readonly></td>
            </tr>
            <tr>
                <th>Tên độc giả</th>
                <td><input type="text" name="ten_doc_gia" value="<%= tenDocGia %>" readonly></td>
            </tr>
            <tr>
                <th>Tên sách</th>
                <td><input type="text" name="ten_sach" value="<%= tenSach %>" readonly></td>
            </tr>
            <tr>
                <th>Ngày mượn</th>
                <td><input type="date" name="ngay_muon" value="<%= ngayMuon %>" readonly></td>
            </tr>
            <tr>
                <th>Ngày trả dự kiến</th>
                <td><input type="date" name="ngay_tra" value="<%= ngayTra %>" readonly></td>
            </tr>
            <tr>
                <th>Tình trạng lúc mượn</th>
                <td><input type="text" name="tinhtrang_lm" value="<%= tinhTrang %>" readonly></td>
            </tr>
            <tr>
                <th>Tình trạng lúc trả</th>
                <td>
                    <select name="tinhtrang_lm_tra" required>
                        <option value="">Chọn tình trạng lúc trả</option>
                        <option value="Nguyên">Nguyên</option>
                        <option value="Rách">Rách</option>
                    </select>
                </td>
            </tr>
        </table>

            <button type="submit" style="margin-left: 40%">Xác nhận trả sách</button>
    </form>
</body>
</html>
