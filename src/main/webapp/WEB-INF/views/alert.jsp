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
    Swal.fire({
        icon: 'success',
        title: '알림',
        text: '${msg}',
        confirmButtonText: '확인',
        confirmButtonColor: '#3085d6',
        allowOutsideClick: false
    }).then((result) => {
        if (result.isConfirmed) {
            let url = '${url}';
            if (url && url !== 'null' && url !== '') {
                // 팝업창이면 부모창 이동
                if (window.opener) {
                    window.opener.location.href = url;
                    window.close();
                } else {
                    window.location.href = url;
                }
            } else {
                if (window.opener) {
                    window.opener.location.reload();
                    window.close();
                } else {
                    window.location.reload();
                }
            }
        }
    });

</script>

</body>
</html>