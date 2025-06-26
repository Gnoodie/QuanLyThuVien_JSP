package TT_CSDL;

import TT_CSDL.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BorrowDAO {
    public boolean borrowBook(int maSachCt) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            DBConnect db = new DBConnect();
            conn = db.KetNoi();

            // Cập nhật trạng thái sách thành đã mượn
            String sql = "UPDATE tinhtrang SET trangthai = 1 WHERE ma_sach_ct = ?"; // 1 = Đã mượn
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, maSachCt);
            int rowsUpdated = pstmt.executeUpdate();

            return rowsUpdated > 0; // Trả về true nếu có bản ghi được cập nhật
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Trả về false nếu có lỗi xảy ra
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }
}
