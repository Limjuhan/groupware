<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>알림</title>
    <!-- SweetAlert2 CDN -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
<script>
    // SweetAlert2로 커스텀 알림 표시
    Swal.fire({
        icon: 'warning', // 경고 아이콘
        title: '알림',
        text: '${msg}', // JSP에서 전달된 메시지
        confirmButtonText: '확인',
        confirmButtonColor: '#3085d6',
        allowOutsideClick: false // 외부 클릭으로 닫히지 않음
    }).then((result) => {
        if (result.isConfirmed) {
            window.close();
            window.location.href='${url}';
            opener.location.reload();

        }
    });
</script>
</body>
</html>