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
    const msg = '${msg}';
    const url = '${url}';

    // 아이콘 타입 설정
    let iconType = 'info';
    let titleText = '알림';

    if (msg.includes('성공')) {
        iconType = 'success';
        titleText = '성공';
    } else if (msg.includes('실패') || msg.includes('오류') || msg.includes('에러')) {
        iconType = 'error';
        titleText = '실패';
    } else if (msg.includes('경고')) {
        iconType = 'warning';
        titleText = '경고';
    }

    Swal.fire({
        icon: iconType,
        title: titleText,
        text: msg,
        confirmButtonText: '확인',
        confirmButtonColor: '#3085d6',
        allowOutsideClick: false
    }).then((result) => {
        if (result.isConfirmed) {
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