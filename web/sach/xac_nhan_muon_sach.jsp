<%@ page import="java.text.SimpleDateFormat, java.util.Date, java.sql.*, TT_CSDL.DBConnect" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận mượn sách</title>
</head>
<body>

<%
    request.setCharacterEncoding("UTF-8");
    // Lấy dữ liệu từ form
    String ngayMuonStr = request.getParameter("ngay_muon");
    String ngayTraStr = request.getParameter("ngay_tra");
    String tinhtrang = request.getParameter("tinh_trang_chi_tiet");
    int maSachCT = Integer.parseInt(request.getParameter("ma_sach_ct"));

    // Nếu người dùng không nhập ngày mượn, đặt mặc định là ngày hôm nay
    if (ngayMuonStr == null || ngayMuonStr.isEmpty()) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date today = new Date(); // Ngày hôm nay
        ngayMuonStr = sdf.format(today); // Chuyển sang định dạng yyyy-MM-dd
    }

    // Lưu dữ liệu vào database (giả sử đã có kết nối CSDL)
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Kết nối đến CSDL
        DBConnect db = new DBConnect();
        conn = db.KetNoi();

        // Lưu thông tin mượn sách
        String sqlInsert = "INSERT INTO muonsach (ma_doc_gia, ma_sach_ct, ngay_muon, ngay_tra, tinhtrang_lm) VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sqlInsert);
        pstmt.setInt(1, (Integer) session.getAttribute("ma_doc_gia"));
        pstmt.setInt(2, maSachCT);
        pstmt.setString(3, ngayMuonStr);
        pstmt.setString(4, ngayTraStr);
        pstmt.setString(5, tinhtrang);

        int result = pstmt.executeUpdate();

        if (result > 0) {
            // Cập nhật trạng thái trong bảng tinhtrang
            String sqlUpdate = "UPDATE tinhtrang SET trangthai = 1 WHERE ma_sach_ct = ?";
            pstmt = conn.prepareStatement(sqlUpdate);
            pstmt.setInt(1, maSachCT);
            int updateResult = pstmt.executeUpdate();

            if (updateResult > 0) {
                out.println("Phiếu mượn đã được tạo thành công và trạng thái sách đã được cập nhật!");
            } else {
                out.println("Phiếu mượn đã được tạo thành công nhưng không thể cập nhật trạng thái sách.");
            }
        } else {
            out.println("Lỗi khi tạo phiếu mượn.");
        }

    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>

</body>
</html>
