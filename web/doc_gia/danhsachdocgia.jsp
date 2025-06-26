<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Danh sách độc giả</title>
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
        .notify-button{
            background-color: #3167AF;
            color: white;
            font-style: italic;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
        } 
        .action-button {
            background-color: #4CAF50;
            color: white;
            font-style: italic;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
        }
        .notify-button:hover, .action-button:hover {
            background-color: #254f8b;
        }
        .action-button-xoa {
            background-color: red;
            color: white;
            font-style: italic;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
        }
        .action-button-xoa:hover {
            background-color: darkred;
        }
        /* Styles for modals */
        .modal {
            display: none; 
            position: fixed; 
            z-index: 1; 
            left: 0;
            top: 0;
            width: 100%; 
            height: 100%; 
            overflow: auto; 
            background-color: rgb(0,0,0); 
            background-color: rgba(0,0,0,0.4); 
            padding-top: 60px; 
        }
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto; 
            padding: 20px;
            border: 1px solid #888;
            width: 80%; 
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
        }
        .form-group input {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
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
        .thongtin{
            height: 40px;
            width: 400px;
            margin-left: 37%;
            align-items: center;
            justify-content: center;
            display: flex;
            background-color: greenyellow;
            border-radius: 10px;
        }

    </style>
</head>
<body>
<div class="thongtin">
<h2>Theo dõi thông tin độc giả</h2>
</div>
<!-- Thanh tìm kiếm -->
<div class="search-bar">
    <input type="text" id="searchInput" placeholder="Tìm kiếm độc giả..." onkeyup="searchReaders()">
</div>

<button class="action-button" style="margin-left: 50%" onclick="showModal('addModal')">Thêm độc giả</button>

<!-- Modal thêm độc giả -->
<div id="addModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal('addModal')">&times;</span>
        <h3>Thêm thông tin độc giả</h3>
        <div class="form-group">
            <label for="ma_doc_gia">Mã độc giả</label>
            <input type="text" id="ma_doc_gia" placeholder="Nhập mã độc giả">
        </div>
        <div class="form-group">
            <label for="ten_doc_gia">Tên độc giả</label>
            <input type="text" id="ten_doc_gia" placeholder="Nhập tên độc giả">
        </div>
        <div class="form-group">
            <label for="ngay_sinh">Ngày sinh</label>
            <input type="date" id="ngay_sinh" placeholder="Nhập ngày sinh">
        </div>
        <div class="form-group">
            <label for="dia_chi">Địa chỉ</label>
            <input type="text" id="dia_chi" placeholder="Nhập địa chỉ">
        </div>
        <div class="form-group">
            <label for="so_dien_thoai">Số điện thoại</label>
            <input type="text" id="so_dien_thoai" placeholder="Nhập số điện thoại">
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" placeholder="Nhập email">
        </div>
        <button class="action-button" onclick="submitForm()">Lưu</button>
    </div>
</div>

<!-- Modal sửa độc giả -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal('editModal')">&times;</span>
        <h3>Sửa thông tin độc giả</h3>
        <div class="form-group">
            <label for="edit_ma_doc_gia">Mã độc giả (Sửa)</label>
            <input type="text" id="edit_ma_doc_gia" placeholder="Nhập mã độc giả mới">
        </div>
        <div class="form-group">
            <label for="edit_ten_doc_gia">Tên độc giả</label>
            <input type="text" id="edit_ten_doc_gia" placeholder="Nhập tên độc giả">
        </div>
        <div class="form-group">
            <label for="edit_ngay_sinh">Ngày sinh</label>
            <input type="date" id="edit_ngay_sinh" placeholder="Nhập ngày sinh">
        </div>
        <div class="form-group">
            <label for="edit_dia_chi">Địa chỉ</label>
            <input type="text" id="edit_dia_chi" placeholder="Nhập địa chỉ">
        </div>
        <div class="form-group">
            <label for="edit_so_dien_thoai">Số điện thoại</label>
            <input type="text" id="edit_so_dien_thoai" placeholder="Nhập số điện thoại">
        </div>
        <div class="form-group">
            <label for="edit_email">Email</label>
            <input type="email" id="edit_email" placeholder="Nhập email">
        </div>
        <button class="action-button" onclick="submitEditForm()">Cập nhật</button>
    </div>
</div>

<table>
    <thead>
        <tr>
            <th>Mã độc giả</th>
            <th>Tên độc giả</th>
            <th>Ngày sinh</th>
            <th>Địa chỉ</th>
            <th>Số điện thoại</th>
            <th>Email</th>
            <th>Thao tác</th>
        </tr>
    </thead>
    <tbody id="readerTable">
        <%
            // Kết nối cơ sở dữ liệu
            Connection conn = null;
            Statement stmt = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/btl_jsp", "root", "");
                stmt = conn.createStatement();
                String query = "SELECT ma_doc_gia, ten_doc_gia, ngay_sinh, dia_chi, so_dien_thoai, email FROM docgia";
                ResultSet rs = stmt.executeQuery(query);

                while(rs.next()) {
                    String mdg = rs.getString("ma_doc_gia");
                    String ht = rs.getString("ten_doc_gia");    
                    String ns = rs.getString("ngay_sinh");
                    String dc = rs.getString("dia_chi");
                    String sdt = rs.getString("so_dien_thoai");
                    String email = rs.getString("email");
        %>  
        <tr id="row_<%= mdg %>">
            <td><%= mdg %></td>
            <td><%= ht %></td>
            <td><%= ns %></td>
            <td><%= dc %></td>
            <td><%= sdt %></td>
            <td><%= email %></td>
            <td>
                <button class="notify-button" onclick="loadEditForm('<%= mdg %>', '<%= ht %>', '<%= ns %>', '<%= dc %>', '<%= sdt %>', '<%= email %>')">Sửa</button>
                <button class="action-button-xoa" onclick="deleteReader('<%= email %>')">Xóa</button>
            </td>
        </tr>
        <%
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch(Exception e) {
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

    function submitForm() {
        // Lấy dữ liệu từ form thêm
        const maDocGia = document.getElementById('ma_doc_gia').value;
        const tenDocGia = document.getElementById('ten_doc_gia').value;
        const ngaySinh = document.getElementById('ngay_sinh').value;
        const diaChi = document.getElementById('dia_chi').value;
        const soDienThoai = document.getElementById('so_dien_thoai').value;
        const email = document.getElementById('email').value;

        // Kiểm tra thông tin đầy đủ
        if (maDocGia && tenDocGia && ngaySinh && diaChi && soDienThoai && email) {
            fetch('add_doc_gia.jsp', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({
                    'ma_doc_gia': maDocGia,
                    'ten_doc_gia': tenDocGia,
                    'ngay_sinh': ngaySinh,
                    'dia_chi': diaChi,
                    'so_dien_thoai': soDienThoai,
                    'email': email
                })
            })
            .then(response => response.text())
            .then(data => {
                alert(data);
                location.reload(); // Làm mới trang
            });
        } else {
            alert("Vui lòng nhập đầy đủ thông tin.");
        }
    }

    function loadEditForm(mdg, ht, ns, dc, sdt, email) {
        // Điền thông tin độc giả cũ
        document.getElementById('edit_ma_doc_gia').value = mdg;
        document.getElementById('edit_ten_doc_gia').value = ht;
        document.getElementById('edit_ngay_sinh').value = ns;
        document.getElementById('edit_dia_chi').value = dc;
        document.getElementById('edit_so_dien_thoai').value = sdt;
        document.getElementById('edit_email').value = email;
        showModal('editModal');
    }

    function submitEditForm() {
        // Lấy dữ liệu từ form sửa
        const maDocGia = document.getElementById('edit_ma_doc_gia').value;
        const tenDocGia = document.getElementById('edit_ten_doc_gia').value;
        const ngaySinh = document.getElementById('edit_ngay_sinh').value;
        const diaChi = document.getElementById('edit_dia_chi').value;
        const soDienThoai = document.getElementById('edit_so_dien_thoai').value;
        const email = document.getElementById('edit_email').value;

        // Gửi dữ liệu đến file edit_doc_gia.jsp
        fetch('edit_doc_gia.jsp', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({
                'ma_doc_gia': maDocGia,
                'ten_doc_gia': tenDocGia,
                'ngay_sinh': ngaySinh,
                'dia_chi': diaChi,
                'so_dien_thoai': soDienThoai,
                'email': email
            })
        })
        .then(response => response.text())
        .then(data => {
            alert(data); // Thông báo khi cập nhật thành công
            location.reload(); // Làm mới trang
        });
    }

    function deleteReader(mdg) {
        if (confirm("Bạn có chắc chắn muốn xóa độc giả có email " + mdg + "?")) {
            fetch('delete_doc_gia.jsp', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({
                    'email': mdg
                })
            })
            .then(response => response.text())
            .then(data => {
                alert(data);
                document.getElementById("row_" + mdg).remove(); // Xóa hàng khỏi bảng
            });
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
