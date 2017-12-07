<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>

<script type="text/javascript">

function searchPw() {
	if($.trim($("#email").val()) == "") {
		alert("이메일을 입력해주세요.");
		$("#email").focus();
		return false;
	}

	if($.trim($("#user_nm").val()) == "") {
		alert("성명을 입력해주세요.");
		$("#user_nm").focus();
		return false;
	}

	var url = "<c:url value='/member/searchPw'/>";
	
	var param = {};
	param.email = $.trim($("#email").val());
	param.user_nm = $.trim($("#user_nm").val());
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("비밀번호를 재설정할 수 있습니다.\r\n이메일을 확인해주세요.");
				go_home();
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
    <!-- <div class="inbox">
      <div class="title">
        <p>아이디 찾기</p>
      </div>
      <div class="texttbox">아이디를 잊어버리셨나요?<br />
        아래 항목을 채워 버튼을 눌러주세요.</div>
      <div class="inputbox">
        <input name="" type="text"  placeholder="아이디"/>
        <br />
        <input name="" type="text"  placeholder="휴대폰 번호 -없이"/>
      </div>
      <div class="btnbox"><a href="#">아이디 찾기</a></div>
    </div> -->
    <div class="inbox">
      <div class="title">
        <p>비밀번호 찾기</p>
      </div>
      <div class="texttbox">비밀번호를 잊어버리셨나요?<br />
        아래 항목을 채워 버튼을 눌러주세요.</div>
      <div class="inputbox">
        <input name="email" type="text" id="email"  placeholder="이메일"/>
        <br />
        <input name="user_nm" type="text" id="user_nm"  placeholder="성명"/>
      </div>
      <div class="btnbox"><a href="javascript:searchPw();" class="big-link button white medium" data-reveal-id="myModal" >비밀번호 찾기</a></div>
    </div>
  </div>

		  
	    </div> 
		  <div class="sp_50"></div>
  </div>
     

<!-- //본문 -->
</body>
