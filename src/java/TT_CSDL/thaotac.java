package TT_CSDL;

import TT_CSDL.DBConnect;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

public class thaotac {
    public static String hienthi() {
        DBConnect db = new DBConnect();
        Connection conn = null;
        Statement state = null;
        ResultSet rs = null;

        String sql = "SELECT muonsach.ma_doc_gia, " +
                     "       docgia.ten_doc_gia, " +
                     "       sach.ten_sach, " +
                     "       muonsach.ngay_muon, " +
                     "       muonsach.ngay_tra, " +
                     "       tinhtrang.tinhtrang_ct " +
                     "FROM muonsach " +
                     "JOIN docgia ON muonsach.ma_doc_gia = docgia.ma_doc_gia " +
                     "JOIN tinhtrang ON muonsach.ma_sach_ct = tinhtrang.ma_sach_ct " +
                     "JOIN sach ON tinhtrang.ma_sach = sach.ma_sach;";

        StringBuilder st = new StringBuilder();
        st.append("<table border='1' cellpadding='5' cellspacing='0'>");
        st.append("<tr>");
        st.append("<th>Mã Độc Giả</th>");
        st.append("<th>Tên Độc Giả</th>");
        st.append("<th>Tên Sách Mượn</th>");
        st.append("<th>Ngày Mượn</th>");
        st.append("<th>Ngày Trả</th>");
        st.append("<th>Tình Trạng Chi Tiết</th>");
        st.append("<th>Thao Tác</th>");
        st.append("</tr>");

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        try {
            conn = db.KetNoi();
            if (conn == null) {
                st.append("<tr><td colspan='7'>Error: Cannot connect to the database.</td></tr>");
                return st.toString();
            }

            state = conn.createStatement();
            rs = state.executeQuery(sql);

            while (rs.next()) {
                String Madocgia = rs.getString("ma_doc_gia");
                String Hoten = rs.getString("ten_doc_gia");
                String Tensach = rs.getString("ten_sach");
                Date Ngaymuon = rs.getDate("ngay_muon");
                Date Ngaytra = rs.getDate("ngay_tra");
                String Trangthai = rs.getString("tinhtrang_ct");

                st.append("<tr>");
                st.append("<td>").append(Madocgia).append("</td>");
                st.append("<td>").append(Hoten).append("</td>");
                st.append("<td>").append(Tensach).append("</td>");
                st.append("<td>").append(sdf.format(Ngaymuon)).append("</td>");
                st.append("<td>").append(sdf.format(Ngaytra)).append("</td>");
                st.append("<td>").append(Trangthai).append("</td>");

                // Add "Return Book" button
                st.append("<td>");
                st.append("<form action='TraSachServlet' method='POST'>");
                st.append("<input type='hidden' name='ma_doc_gia' value='").append(Madocgia).append("'/>");
                st.append("<input type='hidden' name='ten_sach' value='").append(Tensach).append("'/>");
                st.append("<button type='submit'>Trả Sách</button>");
                st.append("</form>");
                st.append("</td>");
                st.append("</tr>");
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log error to console
            st.append("<tr><td colspan='7'>Error retrieving data: ").append(e.getMessage()).append("</td></tr>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (state != null) state.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace(); // Log error to console
                st.append("<tr><td colspan='7'>Error closing resources: ").append(e.getMessage()).append("</td></tr>");
            }
        }

        st.append("</table>");
        return st.toString();
    }
}
