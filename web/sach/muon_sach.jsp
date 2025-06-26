<%@ page import="java.sql.*, TT_CSDL.DBConnect" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Danh sách sách</title>
    <style>
        table {
            width: 90%;
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
        .btn-view {
            padding: 5px 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            text-decoration: none;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <h2 style="text-align: center;">DANH SÁCH</h2>
    <table>
        <thead>
            <tr>
                <th>Mã sách</th>
                <th>Tên sách</th>
                <th>Tác giả</th>
                <th>Nhà xuất bản</th>
                <th>Năm xuất bản</th>
                <th>Thể loại</th>
                <th>Xem chi tiết</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    DBConnect db = new DBConnect();
                    conn = db.KetNoi();

                    String query = "SELECT sach.ma_sach, sach.ten_sach, tacgia.ten_tac_gia, nhaxuatban.ten_nxb, sach.nam_xuat_ban, sach.the_loai "
                                 + "FROM sach "
                                 + "JOIN tacgia ON sach.ma_tac_gia = tacgia.ma_tac_gia "
                                 + "JOIN nhaxuatban ON sach.ma_nxb = nhaxuatban.ma_nxb";

                    pstmt = conn.prepareStatement(query);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        int maSach = rs.getInt("ma_sach");
                        String tenSach = rs.getString("ten_sach");
                        String tenTacGia = rs.getString("ten_tac_gia");
                        String tenNXB = rs.getString("ten_nxb");
                        int namXuatBan = rs.getInt("nam_xuat_ban");
                        String theLoai = rs.getString("the_loai");
            %>
            <tr>
                <td><%= maSach %></td>
                <td><%= tenSach %></td>
                <td><%= tenTacGia %></td>
                <td><%= tenNXB %></td>
                <td><%= namXuatBan %></td>
                <td><%= theLoai %></td>
                <td>
                    <form action="muon_sach_ct.jsp" method="get">
                        <input type="hidden" name="ma_sach" value="<%= maSach %>">
                        <button type="submit" class="btn-view">Xem Chi Tiết</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            %>
        </tbody>
    </table>
</body>
</html>
