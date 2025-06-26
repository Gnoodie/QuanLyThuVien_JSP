<%@page import="TT_CSDL.DBConnect"%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>BẢNG THEO DÕI MƯỢN SÁCH</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>
    <h1 style="text-align: center">BẢNG THEO DÕI MƯỢN SÁCH</h1>
    <%
        DBConnect db = new DBConnect();
        Connection conn = db.KetNoi();

        // Cập nhật truy vấn SQL để lấy thêm mã mượn sách
        String sql = "SELECT muonsach.ma_doc_gia, " +
                     "       docgia.ten_doc_gia, " +
                     "       sach.ten_sach, " +
                     "       muonsach.ngay_muon, " +
                     "       muonsach.ngay_tra, " +
                     "       muonsach.tinhtrang_lm, " +
                     "       muonsach.ma_muon_sach " + // Lấy mã mượn sách
                     "FROM muonsach " +
                     "JOIN docgia ON muonsach.ma_doc_gia = docgia.ma_doc_gia " +
                     "JOIN tinhtrang ON muonsach.ma_sach_ct = tinhtrang.ma_sach_ct " +
                     "JOIN sach ON tinhtrang.ma_sach = sach.ma_sach;";

        StringBuilder st = new StringBuilder();

        st.append("<table border='1' cellpadding='5' cellspacing='0'>");
        st.append("<tr>");
        st.append("<th>Mã độc giả</th>");
        st.append("<th>Tên độc giả</th>");
        st.append("<th>Tên sách mượn</th>");
        st.append("<th>Ngày mượn</th>");
        st.append("<th>Ngày trả dự kiến</th>");
        st.append("<th>Tình trạng lúc mượn</th>");
        st.append("<th>Thao tác</th>");
        st.append("</tr>");

        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);

            while (rs.next()) {
                String Madocgia = rs.getString("ma_doc_gia");
                String Hoten = rs.getString("ten_doc_gia");
                String Tensach = rs.getString("ten_sach");
                Date Ngaymuon = rs.getDate("ngay_muon");
                Date Ngaytra = rs.getDate("ngay_tra");
                String Trangthai = rs.getString("tinhtrang_lm");
                String MaMuonSach = rs.getString("ma_muon_sach"); // Lấy mã mượn sách

                st.append("<tr>");
                st.append("<td>").append(Madocgia).append("</td>");
                st.append("<td>").append(Hoten).append("</td>");
                st.append("<td>").append(Tensach).append("</td>");
                st.append("<td>").append(Ngaymuon).append("</td>");
                st.append("<td>").append(Ngaytra).append("</td>");
                st.append("<td>").append(Trangthai).append("</td>");

                // Kiểm tra xem sách đã được trả hay chưa bằng cách truy vấn bảng trasach
                String checkSql = "SELECT COUNT(*) AS count FROM trasach WHERE ma_muon_sach = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, MaMuonSach);
                ResultSet checkRs = checkStmt.executeQuery();

                boolean isReturned = false;
                if (checkRs.next() && checkRs.getInt("count") > 0) {
                    isReturned = true; // Nếu có bản ghi trong bảng trasach, sách đã được trả
                }

                st.append("<td>");
                if (isReturned) {
                    st.append("Đã trả");
                } else {
                    st.append("<a href='Phieutra.jsp?ma_doc_gia=").append(Madocgia)
                        .append("&ten_doc_gia=").append(Hoten)
                        .append("&ten_sach=").append(Tensach)
                        .append("&ngay_muon=").append(Ngaymuon)
                        .append("&ngay_tra=").append(Ngaytra)
                        .append("&tinhtrang_lm=").append(Trangthai)
                        .append("&ma_muon_sach=").append(MaMuonSach) // Thêm mã mượn sách vào URL
                        .append("'>Trả sách</a>");
                }
                st.append("</td>");
                st.append("</tr>");

                // Đóng ResultSet và PreparedStatement
                checkRs.close();
                checkStmt.close();
            }
            rs.close();
            state.close();
            conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
            st.append("<p>Không thể hiển thị dữ liệu. Vui lòng kiểm tra kết nối.</p>");
        }

        st.append("</table>");
        out.println(st.toString());
    %>
</body>
</html>
