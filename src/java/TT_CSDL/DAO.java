package TT_CSDL;

import TT_CSDL.DBConnect;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
public class DAO {
    public String hienthi() {
        DBConnect db = new DBConnect();
        Connection conn = db.KetNoi();
        
        // Các câu truy vấn
        String sqlSachTrongKho = "SELECT COUNT(*) AS sachTrongKho FROM tinhtrang WHERE trangthai = '0'";
        String sqlSachChoMuon = "SELECT COUNT(*) AS sachChoMuon FROM tinhtrang WHERE trangthai = '1'";
        String sqlTheLoai = "SELECT s.the_loai AS genre, COUNT(ms.ma_muon_sach) AS borrow_count " +
                            "FROM muonsach ms " +
                            "JOIN sach s ON ms.ma_sach_ct = s.ma_sach " +
                            "GROUP BY s.the_loai " +
                            "ORDER BY borrow_count DESC " +
                            "LIMIT 1";
        String sqlDangKy = "SELECT COUNT(*) AS user_count " +
                            "FROM user " +
                            "WHERE time >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);";
        String sqlSachCuMoi = "SELECT tinhtrang, COUNT(*) AS so_luong_sach FROM tinhtrang GROUP BY tinhtrang";
        String sqlDocGiaMuonNhieu = "SELECT dg.ten_doc_gia, COUNT(ms.ma_muon_sach) AS so_luong_sach " +
                                    "FROM muonsach ms " +
                                    "JOIN docgia dg ON ms.ma_doc_gia = dg.ma_doc_gia " +
                                    "WHERE ms.ngay_tra IS NULL " +
                                    "GROUP BY ms.ma_doc_gia " +
                                    "ORDER BY so_luong_sach DESC " +
                                    "LIMIT 1";
        
        StringBuilder sb = new StringBuilder();
        sb.append("<table border='1' cellpadding='5' cellspacing='0'>");
        sb.append("<tr>");
        sb.append("<th>Loại Thống Kê</th>");
        sb.append("<th>Kết Quả</th>");
        sb.append("</tr>");
        
        try (Statement st = conn.createStatement()) {
            
            // Truy vấn số sách còn trong kho
            try (ResultSet rs1 = st.executeQuery(sqlSachTrongKho)) {
                if (rs1.next()) {
                    int sachTrongKho = rs1.getInt("sachTrongKho");
                    sb.append("<tr>");
                    sb.append("<td>Số lượng sách còn trong kho</td>");
                    sb.append("<td>").append(sachTrongKho).append("</td>");
                    sb.append("</tr>");
                }
            }
            
            // Truy vấn số sách đã cho mượn
            try (ResultSet rs2 = st.executeQuery(sqlSachChoMuon)) {
                if (rs2.next()) {
                    int sachChoMuon = rs2.getInt("sachChoMuon");
                    sb.append("<tr>");
                    sb.append("<td>Số lượng sách đã cho mượn</td>");
                    sb.append("<td>").append(sachChoMuon).append("</td>");
                    sb.append("</tr>");
                }
            }
            
            // Truy vấn thể loại sách được mượn nhiều nhất
            try (ResultSet rs3 = st.executeQuery(sqlTheLoai)) {
                if (rs3.next()) {
                    String theLoai = rs3.getString("genre");
                    int soLanMuon = rs3.getInt("borrow_count");
                    sb.append("<tr>");
                    sb.append("<td>Thể loại sách được mượn nhiều nhất</td>");
                    sb.append("<td>").append(theLoai).append(" - Số lần mượn: ").append(soLanMuon).append("</td>");
                    sb.append("</tr>");
                }
            }
            
            // Truy vấn số tài khoản đã đăng ký trong tháng vừa qua
            try (ResultSet rs4 = st.executeQuery(sqlDangKy)) {
                if (rs4.next()) {
                    int dangky = rs4.getInt("user_count");
                    sb.append("<tr>");
                    sb.append("<td>Số tài khoản đã đăng ký trong tháng vừa qua</td>");
                    sb.append("<td>").append(dangky).append("</td>");
                    sb.append("</tr>");
                }
            }
            
            // Truy vấn số lượng sách cũ và mới
            try (ResultSet rs5 = st.executeQuery(sqlSachCuMoi)) {
                while (rs5.next()) {
                    String tinhTrang = rs5.getString("tinhtrang");
                    int soLuongSach = rs5.getInt("so_luong_sach");
                    sb.append("<tr><td>Số lượng sách ").append(tinhTrang).append("</td><td>")
                      .append(soLuongSach).append("</td></tr>");
                }
            }
            
            // Truy vấn độc giả mượn nhiều sách nhất
            try (ResultSet rs6 = st.executeQuery(sqlDocGiaMuonNhieu)) {
                if (rs6.next()) {
                    String tenDocGia = rs6.getString("ten_doc_gia");
                    int soLuongSachMuon = rs6.getInt("so_luong_sach");
                    sb.append("<tr><td>Độc giả mượn nhiều sách nhất</td><td>")
                      .append(tenDocGia).append(" - Số sách mượn: ").append(soLuongSachMuon).append("</td></tr>");
                }
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(DAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(DAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        return sb.toString();
    }
}
