<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>

<!-- 날짜선택 -->	
<!-- <script src="/jq/time/build/jquery.datetimepicker.full.js"></script>  -->

<script type="text/javascript">
$(function() {
	/* $.datetimepicker.setLocale('kr');

	$('#birth').datetimepicker( {
		format:'Y-m-d',
		timepicker:false
	});
	$('#mbirth').datetimepicker( {
		format:'Y-m-d',
		timepicker:false
	}); */

	$("#c_password").change(function () { $("#mc_password").val($("#c_password").val()); });
	$("#mc_password").change(function () { $("#c_password").val($("#mc_password").val()); });

	$("#password").change(function () { $("#mpassword").val($("#password").val()); });
	$("#mpassword").change(function () { $("#password").val($("#mpassword").val()); });

	$("#passwordchk").change(function () { $("#mpasswordchk").val($("#passwordchk").val()); });
	$("#mpasswordchk").change(function () { $("#passwordchk").val($("#mpasswordchk").val()); });
	
	$("#user_nm").change(function () { $("#muser_nm").val($("#user_nm").val()); });
	$("#muser_nm").change(function () { $("#user_nm").val($("#muser_nm").val()); });

	$("#moblphon_no").change(function () { $("#mmoblphon_no").val($("#moblphon_no").val()); });
	$("#mmoblphon_no").change(function () { $("#moblphon_no").val($("#mmoblphon_no").val()); });

	$("#birth").change(function () { $("#mbirth").val($("#birth").val()); });
	$("#mbirth").change(function () { $("#birth").val($("#mbirth").val()); });
	
});

var isUserIdDup = false;

function modify() {
	if(validation() == false)
		return;
	
	var url = "<c:url value='/member/modifyUser'/>";
	
	var param = {};
	param.user_nm = $.trim($("#user_nm").val());
	param.password = $.trim($("#password").val());
	param.c_password = $.trim($("#c_password").val());
	param.moblphon_no = $.trim($("#moblphon_no").val());
	param.birth = $.trim($("#birth").val());
	param.sex = $(':radio[name="rdoSex"]:checked').val();
	param.email_recptn_at = "N";
	if($("#email_recptn_at").is(":checked"))
		param.email_recptn_at = "Y";
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("수정되었습니다.\r\n다시 로그인해주세요.");
				go_logout();
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

function validation() {
	if($.trim($("#user_nm").val()) == "") {
		alert("이름을 입력해주세요.");
		$("#user_nm").focus();
		return false;
	}
	if($.trim($("#moblphon_no").val()) == "") {
		alert("핸드폰을 입력해주세요.");
		$("#moblphon_no").focus();
		return false;
	}
	if($(':radio[name="rdoSex"]:checked').length == 0) {
		alert("성별을 선택해주세요.");
		return false;		
	}
	if($.trim($("#birth").val()) == "") {
		alert("생년월일을 입력해주세요.");
		$("#birth").focus();
		return false;
	}

	var c_password = $.trim($("#c_password").val());
	var password = $.trim($("#password").val());
	var passwordchk = $.trim($("#passwordchk").val());

	if(c_password == "" && password != "") {
		alert("현재 비밀번호를 입력하세요.");
		$("#c_password").focus();
		return false;
	}
	if(c_password != "") {
		if($.trim($("#password").val()) == "") {
			alert("비밀번호를 입력해주세요.");
			$("#password").focus();
			return false;
		}
		if($.trim($("#passwordchk").val()) == "") {
			alert("비밀번호 확인을 입력해주세요.");
			$("#passwordchk").focus();
			return false;
		}
		if(password.length < 8 || password.length > 12) {
			alert("비밀번호는 8~12자리 이내로 입력하세요.");
			$("#password").focus();
			return false;
		}
		if(!chkPwd(password)) {
			return false;
		}	
		if(password != passwordchk) {
			alert("비밀번호와 비밀번호 확인이 맞지 않습니다.")
			return false;
		}
	}
}

function chkPwd(str){
	var pw = str;
	var num = pw.search(/[0-9]/g);
	var eng = pw.search(/[a-z]/ig);
	var spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);

	if(pw.search(/₩s/) != -1){
		alert("비밀번호는 공백없이 입력해주세요.");
		return false;
	}
	if(num < 0 || eng < 0 || spe < 0 ){
		alert("영문, 숫자, 특수문자를 혼합하여 입력해주세요.");
		return false;
	}
	return true;
}
</script>
</head>

<body>
<!-- 본문 -->
<section>
     
      <div id="container"> 
    <div class="inner2">
  <div class="top_title_com">
    <div class="title">
      <div class="text1"><em>Member</em> Info</div>
    </div>
  </div>
  <div class="sp_20 pc_view"></div>
	  <div class="combox_out">
<div class="title_bar2">
  <div class="text1"> 개인정보</div>
    <div class="text2">아래 항목을 빠짐없이 기재해 주세요</div>
</div>
  <div id="join_w_box">
    <table cellpadding="0" cellspacing="0" class="join_w">
      <tbody>
        <tr>
          <th>이메일</th>
          <td class="line">${result.EMAIL}&nbsp;&nbsp;&nbsp;
            <input type="checkbox" id="email_recptn_at" name="email_recptn_at" id="checkbox" value="Y" <c:if test="${result.EMAIL_RECPTN_AT == 'Y'}">checked</c:if>/>
            이벤트 및 새로운 소식 수신 </td>
        </tr>
        <tr>
          <th>현재 비밀번호</th>
          <td class="line"><input id="c_password" name="c_password" type="password" class="w_20p pc_view" value=""   />
          	<!--모바일 --><input id="mc_password" name="c_password" type="password" class="w_50p mobile_view"  value=""   />
            </td>
        </tr>
        <tr>
          <th>비밀번호 수정</th>
          <td class="line"><input id="password" name="password" type="password" class="w_20p pc_view" value=""   />
          <!--모바일 --><input id="mpassword" name="password" type="password" class="w_50p mobile_view"   value=""   />
          &nbsp;&nbsp;8~12자리 이내로 입력하세요.</td>
        </tr>
        <tr>
          <th>비밀번호 확인</th>
          <td class="line"><input id="passwordchk" name="passwordchk" type="password" class="w_20p pc_view" value=""   />
          <!--모바일 --><input id="mpasswordchk" name="passwordchk" type="password" class="w_50p mobile_view"   value=""   /></td>
        </tr>
        <tr>
          <th>이름</th>
          <td class="line"><input id="user_nm" name="user_nm" type="text" class="w_20p pc_view" value="${result.USER_NM}"   />
          <!--모바일 --><input id="muser_nm" name="user_nm" type="text" class="w_50p mobile_view"   value="${result.USER_NM}"   /></td>
        </tr>
        <tr>
          <th>핸드폰 </th>
          <td class="line"><input id="moblphon_no" name="moblphon_no" type="text"  class="w_20p pc_view" value="${result.MOBLPHON_NO}"   />
          <!--모바일 --><input id="mmoblphon_no" name="moblphon_no" type="text" class="w_50p mobile_view"  value="${result.MOBLPHON_NO}"   />
            &nbsp;&nbsp;(예)010-1234-1234
        </tr>
        <tr>
          <th>성별</th>
          <td class="line">
          	<input type="radio" name="rdoSex" id="rdoSexM" value="M" <c:if test="${result.SEX == 'M'}">checked</c:if> /><label for="rdoSexM">남성</label>&nbsp;&nbsp;&nbsp;
            <input type="radio" name="rdoSex" id="rdoSexF" value="F" <c:if test="${result.SEX == 'F'}">checked</c:if> /><label for="rdoSexF">여성</label>
          </td>
        </tr>
        <tr>
          <th>생년월일</th>
          <td class="line">
          <input id="birth" name="birth" type="text" class="w_20p pc_view" value="${result.BIRTH}"  />
          <!--모바일 --><input id="mbirth" name="birth" type="text" class="w_50p mobile_view"  value="${result.BIRTH}"   />
          &nbsp;&nbsp;(예)19800101
          </td>
        </tr>
      </tbody>
    </table>
  </div>
		  
  <!-- btn -->
  <div class="btn_box_box"><a href="javascript:modify(); " class="button_b1">정보 수정</a></div>
  <!-- /btn --> 
  
</div>
		  
	    </div> 
		<div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div>
  </div>
     
</section>
<!-- //본문 -->

</body>

