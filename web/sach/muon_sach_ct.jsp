<%@ page import="java.sql.*, java.util.*, TT_CSDL.DBConnect" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tình trạng sách</title>
    <style>
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>
    <h2 style="text-align: center;">TÌNH TRẠNG SÁCH</h2>
    <%
        int maSach = Integer.parseInt(request.getParameter("ma_sach"));
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            DBConnect db = new DBConnect();
            conn = db.KetNoi();

            String query = "SELECT sach.ten_sach, tinhtrang.ma_sach_ct, tinhtrang.tinhtrang, tinhtrang.trangthai, tinhtrang.tinhtrang_ct " +
                           "FROM sach " +
                           "JOIN tinhtrang ON sach.ma_sach = tinhtrang.ma_sach " +
                           "WHERE sach.ma_sach = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, maSach);
            rs = pstmt.executeQuery();

            List<Map<String, Object>> tinhTrangList = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("ten_sach", rs.getString("ten_sach"));
                item.put("ma_sach_ct", rs.getInt("ma_sach_ct"));
                item.put("tinhtrang", rs.getString("tinhtrang"));
                item.put("trangthai", rs.getInt("trangthai"));
                item.put("tinhtrang_ct", rs.getString("tinhtrang_ct")); // Lấy cột tinhtrang_ct
                tinhTrangList.add(item);
            }

            if (tinhTrangList.size() > 0) {
    %>
    <table>
        <thead>
            <tr>
                <th>Tên sách</th>
                <th>Tình trạng</th>
                <th>Trạng thái</th>
                <th>Tình trạng chi tiết</th> <!-- Cột mới -->
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Map<String, Object> tinhTrang : tinhTrangList) {
                    String tenSach = (String) tinhTrang.get("ten_sach");
                    String tinhTrangSach = (String) tinhTrang.get("tinhtrang");
                    int trangThai = (Integer) tinhTrang.get("trangthai");
                    int maSachCT = (Integer) tinhTrang.get("ma_sach_ct");
                    String tinhTrangChiTiet = (String) tinhTrang.get("tinhtrang_ct"); // Lấy tình trạng chi tiết
            %>
            <tr>
                <td><%= tenSach %></td>
                <td><%= tinhTrangSach %></td>
                <td><%= trangThai == 0 ? "Còn" : "Đã mượn" %></td>
                <td><%= tinhTrangChiTiet %></td> <!-- Hiển thị tình trạng chi tiết -->
                <td>
                    <% if (trangThai == 0 && "Nguyên".equals(tinhTrangChiTiet)) { %>
                        <form action="phieu_muon.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="ma_sach_ct" value="<%= maSachCT %>">
                            <input type="submit" value="Mượn sách">
                        </form>
                    <% } else { %>
                        <span style="color: red;">Không khả dụng</span>
                    <% } %>
                </td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
    <%
            } else {
                out.println("<p style='text-align: center;'>Không có thông tin về tình trạng sách.</p>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
</body>
</html>
