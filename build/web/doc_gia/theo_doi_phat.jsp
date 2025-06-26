<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Theo dõi phạt</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .action-button {
            background-color: #3167AF;
            color: white;
            font-style: italic;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
        }
        .modal {
            display: none; 
            position: fixed; 
            z-index: 1; 
            left: 26%;
            top: 0;
            width: 50%; 
            height: 100%; 
            overflow: auto; 
            padding-top: 200px;
        }
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto; 
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
        }
        .search-bar {
            margin: 20px 0;
            width: 500px;
            margin-left: 35%;
        }
        .search-bar input {
            padding: 10px;
            width: calc(100% - 22px);
            box-sizing: border-box;
        }
        .thongtin {
            height: 40px;
            width: 400px;
            background-color: greenyellow;
            border-radius: 10px;
            margin-left: 37%;
            display: flex;
            justify-content: center;
            align-items: center;
        }
    </style>
</head>
<body>
    <div class="thongtin">
        <h2>Theo dõi phạt</h2>
    </div>

    <!-- Search Bar -->
    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="Tìm kiếm..." onkeyup="searchReaders()">
    </div>

    <!-- Edit Fine Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('editModal')">&times;</span>
            <h3>Sửa trạng thái nộp phạt</h3>
            <div class="form-group">
                <label for="ma_phat">Mã phạt</label>
                <input type="text" id="ma_phat" placeholder="Mã phạt" readonly>
            </div>
            <div class="form-group">
                <label for="tt_dong_phat">Trạng thái nộp phạt</label>
                <input type="text" id="tt_dong_phat" placeholder="Nhập trạng thái nộp phạt" required>
            </div>
            <button class="action-button" onclick="submitEditForm()">Lưu</button>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>Mã độc giả</th>
                <th>Tên độc giả</th>
                <th>Lý do</th>
                <th>Tiền phạt</th>
                <th>Trạng thái nộp phạt</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody id="readerTable">
            <%
                Connection conn = null;
                Statement stmt = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/btl_jsp", "root", "");
                    stmt = conn.createStatement();

                    // Lấy thông tin từ bảng 'phat' và bảng 'docgia'
                    String query = "SELECT d.ma_doc_gia, d.ten_doc_gia, p.ly_do, p.so_tien_phat, p.tt_dong_phat, p.ma_phat " +
                                   "FROM phat p " +
                                   "JOIN docgia d ON p.ma_doc_gia = d.ma_doc_gia";
                    ResultSet rs = stmt.executeQuery(query);

                    while (rs.next()) {
                        String maDocGia = rs.getString("ma_doc_gia");
                        String tenDocGia = rs.getString("ten_doc_gia");
                        String lyDo = rs.getString("ly_do");
                        String soTienPhat = rs.getString("so_tien_phat");
                        String ttDongPhat = rs.getString("tt_dong_phat");
                        String maPhat = rs.getString("ma_phat");
            %>  
            <tr id="row_<%= maDocGia %>">
                <td><%= maDocGia %></td>
                <td><%= tenDocGia %></td>
                <td><%= lyDo %></td>
                <td><%= soTienPhat %></td>
                <td><%= ttDongPhat %></td>
                <td><button class="action-button" onclick="editFine('<%= maPhat %>', '<%= ttDongPhat %>')">Sửa</button></td>
            </tr>
            <%
                    }
                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </tbody>
    </table>

    <script>
        function showModal(modalId) {
            document.getElementById(modalId).style.display = "block";
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = "none";
        }

        function editFine(maPhat, ttDongPhat) {
            document.getElementById('ma_phat').value = maPhat; 
            document.getElementById('tt_dong_phat').value = ttDongPhat; 
            showModal('editModal'); 
        }

        function submitEditForm() {
            const maPhat = document.getElementById('ma_phat').value;
            const ttDongPhat = document.getElementById('tt_dong_phat').value;

            if (ttDongPhat) {
                fetch('edit_phat.jsp', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'ma_phat=' + encodeURIComponent(maPhat) + '&tt_dong_phat=' + encodeURIComponent(ttDongPhat)
                }).then(response => response.text())
                  .then(data => {
                      alert(data);
                      closeModal('editModal');
                      location.reload(); 
                  });
            } else {
                alert('Vui lòng nhập trạng thái nộp phạt');
            }
        }

        function searchReaders() {
            const input = document.getElementById('searchInput').value.toLowerCase();
            const rows = document.querySelectorAll('#readerTable tr');

            rows.forEach(row => {
                const cells = row.getElementsByTagName('td');
                let match = false;

                for (let i = 0; i < cells.length; i++) {
                    const cell = cells[i];
                    if (cell) {
                        if (cell.innerHTML.toLowerCase().includes(input)) {
                            match = true;
                            break;
                        }
                    }
                }

                row.style.display = match ? '' : 'none';
            });
        }
    </script>

</body>
</html>
