const signUpButton = document.getElementById('signUp');
const signInButton = document.getElementById('signIn');
const container = document.getElementById('container');

signUpButton.addEventListener('click', () => {
    container.classList.add('right-panel-active');
});

signInButton.addEventListener('click', () => {
    container.classList.remove('right-panel-active');
});
// Hàm kiểm tra thông tin form đăng ký
function validateRegisterForm() {
    const uname = document.getElementById('uname').value.trim();
    const email = document.getElementById('mail').value.trim();
    const password = document.getElementById('pass').value.trim();

    if (uname === "" || email === "" || password === "") {
        alert("Vui lòng điền đầy đủ thông tin đăng ký.");
        return false; // Ngăn form gửi đi
    }

    // Có thể thêm kiểm tra định dạng email và độ mạnh mật khẩu nếu cần
    return true; // Cho phép gửi form
}

// Hàm kiểm tra thông tin form đăng nhập
function validateLoginForm() {
    const email = document.getElementById('lmail').value.trim();
    const password = document.getElementById('lpass').value.trim();

    if (email === "" || password === "") {
        alert("Vui lòng điền đầy đủ thông tin đăng nhập.");
        return false; // Ngăn form gửi đi
    }

    return true; // Cho phép gửi form
}