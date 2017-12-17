<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>

<script type="text/javascript">

function changePw() {
	if($.trim($("#password").val()) == "") {
		alert("비밀번호를 입력해주세요.");
		$("#password").focus();
		return;
	}
	if($.trim($("#passwordchk").val()) == "") {
		alert("비밀번호 확인을 입력해주세요.");
		$("#passwordchk").focus();
		return;
	}

	var password = $.trim($("#password").val());
	var passwordchk = $.trim($("#passwordchk").val());
	
	if(password.length < 4 || password.length > 12) {
		alert("비밀번호는 4~12자리 이내로 입력하세요.");
		$("#password").focus();
		return ;
	}
	
	if(password != passwordchk) {
		alert("비밀본호와 비밀번호 확인이 맞지 않습니다.")
		return ;
	}

	var url = "<c:url value='/member/changePw'/>";
	
	var param = {};
	param.certkey = "${certkey}";
	param.password = $.trim($("#password").val());
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("비밀번호를 재설정하였습니다.");
				go_login();
			} else if(data.result == "9") {
				alert(data.message);
			} else{
				alert("작업을 실패하였습니다.");
			}	        	
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});
	
}

</script>

</head>

<body>
<!-- 본문 -->

      <div id="container"> 
    <div class="inner2">

  <div class="idpw_box">
    <div class="inbox">
      <div class="title">
        <p>비밀번호 재설정</p>
      </div>
      <div class="texttbox">비밀번호를 재설정합니다.</div>
      <div class="inputbox">
        <input name="password" type="password" id="password"  placeholder="비밀번호"/>&nbsp;&nbsp;4~12자리 이내로 입력하세요.
        <br />
        <input name="passwordchk" type="password" id="passwordchk"  placeholder="비밀번호 확인"/>
      </div>
      <div class="btnbox"><a href="javascript:changePw();" class="big-link button white medium" data-reveal-id="myModal" >비밀번호 설정</a></div>
    </div>
  </div>
	  
	    </div> 
		  <div class="sp_50"></div>
  </div>
     

<!-- //본문 -->
</body>
