<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>LDBSOFT Groupware - 비밀번호 찾기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex justify-content-center align-items-center" style="height: 100vh;">

<div class="card p-4 shadow" style="max-width: 400px; width: 100%;">
    <h4 class="text-center mb-4">비밀번호 찾기</h4>
    <form id="authForm">
        <div class="mb-3">
            <label class="form-label">이름</label>
            <input type="text" name="memName" class="form-control" required/>
        </div>
        <div class="mb-3">
            <label class="form-label">사원번호</label>
            <input type="text" name="memId" class="form-control" required/>
        </div>
        <div class="mb-4">
            <label class="form-label">2차 이메일 (개인 이메일)</label>
            <input type="email" name="memPrivateEmail" class="form-control" required/>
        </div>
        <div class="d-grid gap-2">
            <button type="button" class="btn btn-primary w-100" id="sendCodeBtn">
                <span class="spinner-border spinner-border-sm me-2 d-none" id="sendSpinner" role="status"></span>
                인증번호 전송
            </button>
            <div id="sendInfoText" class="form-text text-muted mt-1">
                📧 이메일 전송에는 최대 <strong>10~15초</strong>가 소요될 수 있습니다. 잠시만 기다려 주세요.
            </div>
        </div>
    </form>
</div>

<!-- 인증번호 확인 모달 -->
<div class="modal fade" id="codeModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form id="verifyForm">
                <div class="modal-header">
                    <h5 class="modal-title">인증번호 확인</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
                </div>
                <div class="modal-body">
                    <p>이메일로 발송된 인증번호를 입력해주세요.</p>
                    <input type="text" name="inputCode" class="form-control" required placeholder="인증번호 입력"/>
                    <input type="hidden" name="memId"/>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="submit" class="btn btn-success">확인</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 비밀번호 재설정 선택 모달 -->
<div class="modal fade" id="pwSelectModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">비밀번호 재설정 방법</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body">
                <p>비밀번호를 어떻게 변경하시겠습니까?</p>
                <input type="hidden" id="selectMemId"/>
                <div class="d-grid gap-2">
                    <button class="btn btn-outline-primary w-100" onclick="openResetModal()">직접 재설정</button>
                    <input type="hidden" id="tempMemId"/>
                    <button type="button" class="btn btn-outline-secondary w-100" id="sendTempBtn">
                        <span class="spinner-border spinner-border-sm me-2 d-none" id="tempSpinner"
                              role="status"></span>
                        임시 비밀번호 발급
                    </button>
                    <div id="tempInfoText" class="form-text text-muted mt-1">
                        📧 이메일 전송에는 최대 <strong>10~15초</strong>가 소요될 수 있습니다. 잠시만 기다려 주세요.
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 직접 재설정 모달 -->
<div class="modal fade" id="resetModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">비밀번호 재설정</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="password" id="newPw" class="form-control mb-2" placeholder="새 비밀번호" required/>
                <input type="password" id="confirmPw" class="form-control" placeholder="비밀번호 확인" required/>
                <input type="hidden" id="resetMemId"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-success" id="resetPwBtn">변경</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 인증번호 전송
    document.getElementById("sendCodeBtn").addEventListener("click", function () {
        const btn = this;
        const spinner = document.getElementById("sendSpinner");
        const infoText = document.getElementById("sendInfoText");
        const formData = new FormData(document.getElementById("authForm"));

        btn.disabled = true;
        spinner.classList.remove("d-none");
        infoText.className = "form-text text-muted mt-1";
        infoText.innerHTML = "📨 이메일 전송 중입니다...";

        fetch("/member/sendCode", {
            method: "POST",
            headers: {"X-Requested-With": "XMLHttpRequest"},
            body: formData
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    infoText.className = "form-text text-success mt-1";
                    infoText.innerHTML = "인증번호가 이메일로 전송되었습니다.";
                    const memId = document.querySelector('#authForm input[name="memId"]').value;
                    document.querySelector('#verifyForm input[name="memId"]').value = memId;
                    document.getElementById('selectMemId').value = memId;
                    document.getElementById('tempMemId').value = memId;
                    new bootstrap.Modal(document.getElementById("codeModal")).show();
                } else {
                    infoText.className = "form-text text-danger mt-1";
                    infoText.innerHTML = "인증번호 전송 실패. 다시 시도해주세요.";
                }
            })
            .catch(() => {
                infoText.className = "form-text text-danger mt-1";
                infoText.innerHTML = "서버 오류로 전송에 실패했습니다.";
            })
            .finally(() => {
                btn.disabled = false;
                spinner.classList.add("d-none");
            });
    });

    // 인증번호 확인
    document.getElementById("verifyForm").addEventListener("submit", function (e) {
        e.preventDefault();
        const btn = this.querySelector("button[type='submit']");
        btn.disabled = true;
        const formData = new FormData(this);

        fetch("/member/verifyCode", {
            method: "POST",
            headers: {"X-Requested-With": "XMLHttpRequest"},
            body: formData
        })
            .then(res => res.json())
            .then(data => {
                alert(data.message);
                if (data.success) {
                    bootstrap.Modal.getInstance(document.getElementById("codeModal")).hide();
                    new bootstrap.Modal(document.getElementById("pwSelectModal")).show();
                }
            })
            .finally(() => btn.disabled = false);
    });

    // 직접 재설정 열기
    function openResetModal() {
        const memId = document.getElementById('selectMemId').value;
        document.getElementById('resetMemId').value = memId;
        bootstrap.Modal.getInstance(document.getElementById('pwSelectModal')).hide();
        new bootstrap.Modal(document.getElementById('resetModal')).show();
    }

    // 임시 비밀번호 발급
    document.getElementById("sendTempBtn").addEventListener("click", function () {
        const btn = this;
        const spinner = document.getElementById("tempSpinner");
        const infoText = document.getElementById("tempInfoText");
        const memId = document.getElementById("tempMemId").value;

        btn.disabled = true;
        spinner.classList.remove("d-none");
        infoText.className = "form-text text-muted mt-1";
        infoText.innerHTML = "📨 이메일 전송 중입니다...";

        fetch("/member/sendTemp", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "X-Requested-With": "XMLHttpRequest"
            },
            body: new URLSearchParams({memId})
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    infoText.className = "form-text text-success mt-1";
                    infoText.innerHTML = "임시 비밀번호가 이메일로 전송되었습니다.";

                    bootstrap.Modal.getInstance(document.getElementById("pwSelectModal"))?.hide();

                    setTimeout(() => {
                        window.opener?.focus();
                        window.close();
                    }, 300);
                } else {
                    infoText.className = "form-text text-danger mt-1";
                    infoText.innerHTML = "발급 실패. 다시 시도해주세요.";
                }
            })
            .catch(() => {
                infoText.className = "form-text text-danger mt-1";
                infoText.innerHTML = "서버 오류로 전송 실패.";
            })
            .finally(() => {
                btn.disabled = false;
                spinner.classList.add("d-none");
            });
    });

    // 비밀번호 재설정
    document.getElementById("resetPwBtn").addEventListener("click", function () {
        const btn = this;
        btn.disabled = true;
        const memId = document.getElementById("resetMemId").value;
        const newPw = document.getElementById("newPw").value;
        const confirmPw = document.getElementById("confirmPw").value;

        console.log("Sending resetPw request with:", {memId, newPw, confirmPw});

        fetch("/member/resetPw", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded", "X-Requested-With": "XMLHttpRequest"},
            body: new URLSearchParams({memId, newPw, confirmPw})
        })
            .then(res => res.json())
            .then(data => {
                console.log("resetPw response:", data);
                alert(data.message);
                if (data.success) {
                    console.log("Hiding resetModal...");
                    const resetModal = bootstrap.Modal.getInstance(document.getElementById("resetModal"));
                    if (resetModal) {
                        resetModal.hide();
                        document.getElementById("resetModal").addEventListener("hidden.bs.modal", () => {
                            console.log("resetModal hidden, attempting to close window...");
                            console.log("window.opener exists:", !!window.opener);
                            if (window.opener) {
                                window.opener.focus();
                                window.close();
                                setTimeout(() => {
                                    if (!window.closed) {
                                        console.error("Window close failed, redirecting to /login...");
                                        alert("창을 닫을 수 없습니다. 로그인 페이지로 이동합니다.");
                                        window.location.href = "/login";
                                    }
                                }, 500);
                            } else {
                                console.warn("No window.opener, redirecting to /login...");
                                alert("팝업 창이 아니므로 로그인 페이지로 이동합니다.");
                                window.location.href = "/login";
                            }
                        }, {once: true});
                    } else {
                        console.warn("resetModal instance not found, redirecting to /login...");
                        alert("모달을 찾을 수 없습니다. 로그인 페이지로 이동합니다.");
                        window.location.href = "/login";
                    }
                } else {
                    console.warn("resetPw failed:", data.message);
                }
            })
            .catch(error => {
                console.error("Error in resetPw:", error);
                alert("서버 오류로 비밀번호 변경에 실패했습니다.");
            })
            .finally(() => {
                btn.disabled = false;
                console.log("resetPwBtn re-enabled");
            });
    });

    // Enter 키 제출 처리
    ["authForm", "verifyForm", "resetModal"].forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener("keyup", function (e) {
                if (e.key === "Enter") {
                    e.preventDefault(); // 기본 동작(모달 닫기) 방지
                    const submitBtn = el.querySelector("#resetPwBtn"); // resetModal에서 특정 버튼 타겟
                    if (submitBtn) {
                        submitBtn.click(); // "변경" 버튼 클릭
                    } else {
                        const btn = el.querySelector("button[type='submit'], button[type='button']");
                        btn?.click(); // 다른 폼은 기존 로직 유지
                    }
                }
            });
        }
    });
</script>
</body>
</html>