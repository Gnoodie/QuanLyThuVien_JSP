package TT_CSDL;

import TT_CSDL.DBConnect;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class BookDAO {

    // Method to retrieve books based on optional search criteria
    public static List<Map<String, Object>> getBooks(String tenSach, String tenTacGia, String tenNXB, String theLoai) throws SQLException {
    List<Map<String, Object>> books = new ArrayList<>();

    String sql = "SELECT sach.ma_sach, sach.ten_sach, tacgia.ten_tac_gia, nhaxuatban.ten_nxb, sach.nam_xuat_ban, sach.gia, sach.isbn, sach.so_trang, sach.the_loai "
            + "FROM sach "
            + "JOIN tacgia ON sach.ma_tac_gia = tacgia.ma_tac_gia "
            + "JOIN nhaxuatban ON sach.ma_nxb = nhaxuatban.ma_nxb WHERE 1=1";

    // Building the query dynamically based on input criteria
    List<String> params = new ArrayList<>();
    if (tenSach != null && !tenSach.isEmpty()) {
        sql += " AND sach.ten_sach LIKE ?";
        params.add("%" + tenSach + "%");
    }
    if (tenTacGia != null && !tenTacGia.isEmpty()) {
        sql += " AND tacgia.ten_tac_gia LIKE ?";
        params.add("%" + tenTacGia + "%");
    }
    if (tenNXB != null && !tenNXB.isEmpty()) {
        sql += " AND nhaxuatban.ten_nxb LIKE ?";
        params.add("%" + tenNXB + "%");
    }
    if (theLoai != null && !theLoai.isEmpty()) {
        sql += " AND sach.the_loai LIKE ?";
        params.add("%" + theLoai + "%");
    }

    try (Connection conn = new DBConnect().KetNoi(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
        // Set parameters in the prepared statement
        for (int i = 0; i < params.size(); i++) {
            pstmt.setString(i + 1, params.get(i));
        }

        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> book = new HashMap<>();
                book.put("ma_sach", rs.getInt("ma_sach"));
                book.put("ten_sach", rs.getString("ten_sach"));
                book.put("ten_tac_gia", rs.getString("ten_tac_gia"));
                book.put("ten_nxb", rs.getString("ten_nxb"));
                book.put("nam_xuat_ban", rs.getInt("nam_xuat_ban"));
                book.put("gia", rs.getBigDecimal("gia"));
                book.put("isbn", rs.getString("isbn"));
                book.put("so_trang", rs.getInt("so_trang"));
                book.put("the_loai", rs.getString("the_loai"));
                books.add(book);
            }
        }
    }
    return books;
}


    // Phương thức thêm sách vào bảng sach và trạng thái vào bảng tinhtrang
    public static void addBook(String tenSach, int maTacGia, int maNXB, int namXuatBan, BigDecimal gia, String isbn,
                                int soTrang, String theLoai, int soLuong) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmtBook = null;
        PreparedStatement pstmtTinhTrang = null;
        ResultSet rs = null;

        try {
            DBConnect db = new DBConnect();
            conn = db.KetNoi();

            // Thêm sách vào bảng sach
            String sqlInsertBook = "INSERT INTO sach (ten_sach, ma_tac_gia, ma_nxb, nam_xuat_ban, gia, isbn, so_trang, the_loai) " +
                                   "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pstmtBook = conn.prepareStatement(sqlInsertBook, PreparedStatement.RETURN_GENERATED_KEYS);
            pstmtBook.setString(1, tenSach);
            pstmtBook.setInt(2, maTacGia);
            pstmtBook.setInt(3, maNXB);
            pstmtBook.setInt(4, namXuatBan);
            pstmtBook.setBigDecimal(5, gia);
            pstmtBook.setString(6, isbn);
            pstmtBook.setInt(7, soTrang);
            pstmtBook.setString(8, theLoai);

            int rowsInserted = pstmtBook.executeUpdate();
            if (rowsInserted > 0) {
                // Lấy ma_sach mới vừa được tạo
                rs = pstmtBook.getGeneratedKeys();
                int maSachMoi = 0;
                if (rs.next()) {
                    maSachMoi = rs.getInt(1);
                }

                // Thêm trạng thái vào bảng tinhtrang
                String sqlInsertTinhTrang = "INSERT INTO tinhtrang (ma_sach, trangthai, tinhtrang) VALUES (?, ?, ?)";
                pstmtTinhTrang = conn.prepareStatement(sqlInsertTinhTrang);

                for (int i = 0; i < soLuong; i++) {
                    pstmtTinhTrang.setInt(1, maSachMoi);
                    pstmtTinhTrang.setInt(2, 0); // Giá trị mặc định cho trangthai (0 = còn)
                    pstmtTinhTrang.setString(3, "Mới"); // Giá trị mặc định cho tình trạng sách
                    pstmtTinhTrang.addBatch(); // Thêm vào batch
                }

                // Thực thi batch để thêm trạng thái sách
                pstmtTinhTrang.executeBatch();
            }
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pstmtBook != null) try { pstmtBook.close(); } catch (SQLException e) {}
            if (pstmtTinhTrang != null) try { pstmtTinhTrang.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }
    
    // Method to update a book record
    public static boolean updateBook(int maSach, String tenSach, String tenTacGia, String tenNXB, int namXuatBan, BigDecimal gia, String isbn, int soTrang, String theLoai) {
        String sql = "UPDATE sach SET ten_sach = ?, ma_tac_gia = (SELECT ma_tac_gia FROM tacgia WHERE ten_tac_gia = ?), "
                + "ma_nxb = (SELECT ma_nxb FROM nhaxuatban WHERE ten_nxb = ?), nam_xuat_ban = ?, gia = ?, isbn = ?, "
                + "so_trang = ?, the_loai = ? WHERE ma_sach = ?";

        try (Connection conn = new DBConnect().KetNoi(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // Setting the values for the parameters
            pstmt.setString(1, tenSach);
            pstmt.setString(2, tenTacGia);
            pstmt.setString(3, tenNXB);
            pstmt.setInt(4, namXuatBan);
            pstmt.setBigDecimal(5, gia);
            pstmt.setString(6, isbn);
            pstmt.setInt(7, soTrang);
            pstmt.setString(8, theLoai);
            pstmt.setInt(9, maSach);

            // Execute the update query
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0; // Return true if update was successful

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Return false if update failed
    }

    public static Map<String, Object> getBookById(int maSach) throws SQLException {
        Map<String, Object> book = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            DBConnect db = new DBConnect();
            conn = db.KetNoi();

            String sql = "SELECT sach.ma_sach, sach.ten_sach, tacgia.ten_tac_gia, nhaxuatban.ten_nxb, sach.nam_xuat_ban, sach.gia, sach.isbn, sach.so_trang, sach.the_loai "
                    + "FROM sach "
                    + "JOIN tacgia ON sach.ma_tac_gia = tacgia.ma_tac_gia "
                    + "JOIN nhaxuatban ON sach.ma_nxb = nhaxuatban.ma_nxb "
                    + "WHERE sach.ma_sach = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, maSach);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                book = new HashMap<>();
                book.put("ma_sach", rs.getInt("ma_sach"));
                book.put("ten_sach", rs.getString("ten_sach"));
                book.put("ten_tac_gia", rs.getString("ten_tac_gia"));
                book.put("ten_nxb", rs.getString("ten_nxb"));
                book.put("nam_xuat_ban", rs.getInt("nam_xuat_ban"));
                book.put("gia", rs.getBigDecimal("gia"));
                book.put("isbn", rs.getString("isbn"));
                book.put("so_trang", rs.getInt("so_trang"));
                book.put("the_loai", rs.getString("the_loai"));
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

        return book;
    }

    public static boolean deleteBook(int maSach) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean deleted = false;

        try {
            DBConnect db = new DBConnect();
            conn = db.KetNoi();

            // Query to delete the book
            String sql = "DELETE FROM sach WHERE ma_sach = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, maSach);

            // Execute the delete operation
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                deleted = true; // Deletion successful
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close connection
            if (pstmt != null) try {
                pstmt.close();
            } catch (SQLException e) {
            }
            if (conn != null) try {
                conn.close();
            } catch (SQLException e) {
            }
        }
        return deleted;
    }
}
