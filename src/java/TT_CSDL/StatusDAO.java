package TT_CSDL;

import TT_CSDL.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StatusDAO {

    // Phương thức để lấy danh sách tình trạng sách
    public static List<Object[]> getStatusList() throws SQLException {
        List<Object[]> statusList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            DBConnect db = new DBConnect();
            conn = db.KetNoi();

            // Truy vấn dữ liệu từ bảng tinhtrang và bảng sach
            String query = "SELECT tinhtrang.ma_sach_ct, sach.ten_sach, tinhtrang.trangthai, tinhtrang.tinhtrang ,tinhtrang.tinhtrang_ct"
                    + "FROM tinhtrang "
                    + "JOIN sach ON tinhtrang.ma_sach = sach.ma_sach";
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();

            // Lặp qua kết quả và thêm vào danh sách
            while (rs.next()) {
                int maSachct = rs.getInt("ma_sach_ct");
                String tenSach = rs.getString("ten_sach");
                int trangThai = rs.getInt("trangthai");
                String tinhTrang = rs.getString("tinhtrang");
                String tinhTrangCT = rs.getString("tinhtrang_ct");

                // Thêm mảng đối tượng vào danh sách
                statusList.add(new Object[]{maSachct, tenSach, trangThai, tinhTrang, tinhTrangCT});
            }
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
            }
            if (pstmt != null) try {
                pstmt.close();
            } catch (SQLException e) {
            }
            if (conn != null) try {
                conn.close();
            } catch (SQLException e) {
            }
        }

        return statusList;
    }

    // Phương thức để cập nhật tình trạng sách
    public static boolean updateStatus(int maSachCt, int trangThai, String tinhTrang, String tinhTrangCt) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isUpdated = false;

        try {
            // Kết nối tới cơ sở dữ liệu
            DBConnect db = new DBConnect();
            conn = db.KetNoi();

            // Câu lệnh SQL để cập nhật thông tin
            String sql = "UPDATE tinhtrang SET trangthai = ?, tinhtrang = ?, tinhtrang_ct = ? WHERE ma_sach_ct = ?";
            pstmt = conn.prepareStatement(sql);

            // Gán giá trị cho các tham số
            pstmt.setInt(1, trangThai);
            pstmt.setString(2, tinhTrang);
            pstmt.setString(3, tinhTrangCt);
            pstmt.setInt(4, maSachCt);

            // Thực hiện cập nhật
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                isUpdated = true; // Cập nhật thành công
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Đóng kết nối và các tài nguyên
            if (pstmt != null) {
                try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return isUpdated; // Trả về true nếu cập nhật thành công, false nếu không
    }

    // Phương thức xóa tình trạng sách
    public boolean deleteStatus(int maSachCt) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            DBConnect db = new DBConnect();
            conn = db.KetNoi();
            String sql = "DELETE FROM tinhtrang WHERE ma_sach_ct = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, maSachCt);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (pstmt != null) try {
                pstmt.close();
            } catch (SQLException e) {
            }
            if (conn != null) try {
                conn.close();
            } catch (SQLException e) {
            }
        }
    }

    // Hàm để lấy danh sách tình trạng của sách theo mã sách (ma_sach)
    public static List<Map<String, Object>> getBookStatusByBookId(int maSach) throws SQLException {
        List<Map<String, Object>> bookStatusList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Kết nối tới cơ sở dữ liệu
            DBConnect db = new DBConnect();
            conn = db.KetNoi();

            // Câu truy vấn để lấy thông tin từ bảng tinh_trang_sach dựa trên ma_sach, bao gồm tinhtrang_ct
            String query = "SELECT ma_sach_ct, tinhtrang, trangthai, tinhtrang_ct FROM tinhtrang WHERE ma_sach = ?";

            // Chuẩn bị câu lệnh truy vấn
            ps = conn.prepareStatement(query);
            ps.setInt(1, maSach);

            // Thực thi truy vấn
            rs = ps.executeQuery();

            // Lặp qua kết quả trả về
            while (rs.next()) {
                Map<String, Object> bookStatus = new HashMap<>();
                bookStatus.put("ma_sach_ct", rs.getInt("ma_sach_ct"));
                bookStatus.put("tinh_trang", rs.getString("tinhtrang"));
                bookStatus.put("trang_thai", rs.getInt("trangthai"));
                bookStatus.put("tinhtrang_ct", rs.getString("tinhtrang_ct")); // Thêm cột tinhtrang_ct

                bookStatusList.add(bookStatus);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Đóng các kết nối và tài nguyên
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return bookStatusList;
    }
    
}
