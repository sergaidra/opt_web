<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>

<!-- 날짜선택 -->	
<!-- <script src="/jq/time/build/jquery.datetimepicker.full.js"></script>  -->

<script type="text/javascript">
$(function() {
	/*$.datetimepicker.setLocale('kr');

	$('#birth').datetimepicker( {
		format:'Y-m-d',
		timepicker:false
	});*/
	
	$("#password").change(function () { $("#mpassword").val($("#password").val()); });
	$("#mpassword").change(function () { $("#password").val($("#mpassword").val()); });

	$("#passwordchk").change(function () { $("#mpasswordchk").val($("#passwordchk").val()); });
	$("#mpasswordchk").change(function () { $("#passwordchk").val($("#mpasswordchk").val()); });

	$("#user_nm").change(function () { $("#muser_nm").val($("#user_nm").val()); });
	$("#muser_nm").change(function () { $("#user_nm").val($("#muser_nm").val()); });

	$("#moblphon_no").change(function () { $("#mmoblphon_no").val($("#moblphon_no").val()); });
	$("#mmoblphon_no").change(function () { $("#moblphon_no").val($("#mmoblphon_no").val()); });

	$("#email").change(function () { $("#memail").val($("#email").val()); });
	$("#memail").change(function () { $("#email").val($("#memail").val()); });
	
	$("#birth").change(function () { $("#mbirth").val($("#birth").val()); });
	$("#mbirth").change(function () { $("#birth").val($("#mbirth").val()); });

	<c:if test="${joinMethod == 'Naver'}">
		$("#email").val("${naver_email}");
		$("#memail").val("${naver_email}");
		$("#user_nm").val("${naver_name}");
		$("#muser_nm").val("${naver_name}");
		$("#rdoSex${naver_gender}").prop("checked", true);
		
		$("#email").attr("readonly",true);
		$("#memail").attr("readonly",true);
		$("#user_nm").attr("readonly",true);
		$("#muser_nm").attr("readonly",true);
		$(":radio[name='rdoSex']").attr('disabled', true);
	</c:if>
	
	<c:if test="${joinMethod == 'Google'}">
		$("#email").val("${google_email}");
		$("#memail").val("${google_email}");
		$("#user_nm").val("${google_name}");
		$("#muser_nm").val("${google_name}");
		$("#rdoSex${google_gender}").prop("checked", true);
		
		$("#email").attr("readonly",true);
		$("#memail").attr("readonly",true);
		$("#user_nm").attr("readonly",true);
		$("#muser_nm").attr("readonly",true);
		$(":radio[name='rdoSex']").attr('disabled', true);
	</c:if>
	
});

var isUserIdDup = false;

function join() {
	if(validation() == false)
		return;
	
	var url = "<c:url value='/member/insertUser'/>";
	
	var param = {};
	param.user_id = $.trim($("#user_id").val());
	param.user_nm = $.trim($("#user_nm").val());
	param.password = $.trim($("#password").val());
	param.moblphon_no = $.trim($("#moblphon_no").val());
	param.email = $.trim($("#email").val());
	param.birth = $.trim($("#birth").val());
	param.sex = $(':radio[name="rdoSex"]:checked').val();
	param.email_recptn_at = "N";
	param.joinMethod = "${joinMethod}";
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
				if(param.joinMethod == "Direct") {
					alert("회원가입 신청되었습니다.\r\n이메일을 확인해주세요.");
					go_home();
				} else {
					alert("회원가입되었습니다.\r\n다시 로그인해주세요.");
					go_login();
				}
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
	if(!($("#chkReq1").is(":checked"))) {
		alert("이용약관에 동의해주세요.");
		return false;
	}
	if(!($("#chkReq2").is(":checked"))) {
		alert("개인정보취급방침에 동의해주세요.");
		return false;
	}
	<c:if test="${joinMethod == 'Direct'}">
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
	</c:if>
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
	if($.trim($("#email").val()) == "") {
		alert("이메일을 입력해주세요.");
		$("#email").focus();
		return false;
	}
	var regExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	if ($.trim($("#email").val()).match(regExp) == null) {
		alert("이메일 형식에 맞게 입력해주세요.");
		$("#email").focus();
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

	<c:if test="${joinMethod == 'Direct'}">
	var password = $.trim($("#password").val());
	var passwordchk = $.trim($("#passwordchk").val());
	
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
	</c:if>
	//if(isUserIdDup == false) {
	//	alert("아이디 중복 확인해주세요.");
	//	return false;
	//}
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
      <div class="text1"><em>Member</em> Join</div>
      <div class="text2">아래 약관을 읽으신후 동의해주셔야 회원가입이 됩니다. </div>
    </div>
  </div>
  <div class="sp_20 pc_view"></div>
	  <div class="agr_out_fl">
<div class="agr">
  <div class="privacy">
      <div class="title1">이용약관 </div>
      <!-- <div class="title">제1장 총칙 </div> -->
      <div class="text">${result1}</div>
      <div class="sp_30"></div>

    </div>
</div>  
  <div class="agr_ch">
    <input type="checkbox" required id="chkReq1">
   이용약관에 동의합니다.</div></div>
 <div class="agr_out_fr">

  <div class="agr">
    <div class="privacy">
      <div class="title1">개인정보의 수집목적 및 이용목적</div>
      <div class="text">${result2}</div>
      <div class="sp_30"></div>

    </div>
  </div>   
  <div class="agr_ch">
    <input type="checkbox" required id="chkReq2">
    개인정보취급방침에 동의합니다.</div> </div>

  <div class="sp_50"></div>
	  <div class="combox_out">
<div class="title_bar2">
  <div class="text1"> 개인정보 입력</div>
    <div class="text2">아래 항목을 빠짐없이 기재해 주세요</div>
</div>
  <div id="join_w_box">
    <table cellpadding="0" cellspacing="0" class="join_w">
      <tbody>
        <tr>
          <th>이메일</th>
          <td class="line"><input id="email" name="email" type="text" class="w_30p pc_view" value=""   />
          <!--모바일 --> <input id="memail" name="email" type="text" class="w_100p mobile_view"  value=""   />
            &nbsp;&nbsp;&nbsp;
            <input type="checkbox" id="email_recptn_at" name="email_recptn_at" id="checkbox" value="Y"/>
            이벤트 및 새로운 소식 수신 </td>
        </tr>
        <c:if test="${joinMethod == 'Direct'}">
        <tr>
          <th>비밀번호</th>
          <td class="line"><input id="password" name="password" type="password" class="w_20p pc_view" value=""   />
          	<!--모바일 --><input id="mpassword" name="password" type="password" class="w_50p mobile_view"  value=""   />
            &nbsp;&nbsp;8~12자리 이내로 입력하세요.</td>
        </tr>
        <tr>
          <th>비밀번호 확인</th>
          <td class="line"><input id="passwordchk" name="passwordchk" type="password" class="w_20p pc_view" value=""   />
          <!--모바일 --><input id="mpasswordchk" name="passwordchk" type="password" class="w_50p mobile_view"   value=""   /></td>
        </tr>
        </c:if>
        <tr>
          <th>이름</th>
          <td class="line"><input id="user_nm" name="user_nm" type="text" class="w_20p pc_view" value=""   />
          <!--모바일 --><input id="muser_nm" name="user_nm" type="text" class="w_50p mobile_view"   value=""   /></td>
        </tr>
        <!-- <tr>
          <th>일반전화 </th>
          <td class="line"><input name="input2" type="password" class="input2" style="width:250px;" value=""   /></td>
        </tr> -->
        <tr>
          <th>핸드폰 </th>
          <td class="line"><input id="moblphon_no" name="moblphon_no" type="text"  class="w_20p pc_view" value=""   />
          <!--모바일 --><input id="mmoblphon_no" name="moblphon_no" type="text" class="w_50p mobile_view"  value=""   />
            &nbsp;&nbsp;(예)010-1234-1234
            <!-- <div class="btnst2"><a href="#" class="big-link" data-reveal-id="myModal" >인증번호 전송</a></div> --></td>
        </tr>
        <!-- <tr>
          <th>핸드폰 인증</th>
          <td class="line"><input name="post" type="text" class="w_30p"  value=""  />
            &nbsp;
            <div class="btnst2"><a href="#">인증번호 확인</a></div></td>
        </tr> -->
        <!-- 
        <tr>
          <th height="25">우편번호 </th>
          <td class="line"><input name="post" type="text" class="input2" style="width:100px;" value=""  />
            &nbsp;
            <div class="btnst">  <a  href="#" data-featherlight="#zipcode_popup">우편번호 찾기 </a></div></td>
        </tr>
        <tr>
          <th height="25">주소 </th>
          <td class="line"><span class="btnst">
            <input name="adressBasic" type="text" class="input2" style="width:60%; margin-bottom:3px" value=""  />
            </span><br />
            <input name="adressDetail" type="text" class="input2" style="width:60%;" value=""  /></td>
        </tr> -->
        <tr>
          <th>성별</th>
          <td class="line">
          	<input type="radio" name="rdoSex" id="rdoSexM" value="M" /><label for="rdoSexM">남성</label>&nbsp;&nbsp;&nbsp;
            <input type="radio" name="rdoSex" id="rdoSexF" value="F" /><label for="rdoSexF">여성</label>
          </td>
        </tr>
        <tr>
          <th>생년월일</th>
          <td class="line">
          <input id="birth" name="birth" type="text" class="w_20p pc_view" value=""  />
          <!--모바일 --><input id="mbirth" name="birth" type="text" class="w_50p mobile_view"  value=""   />
          &nbsp;&nbsp;(예)19800101
          </td>
        </tr>
      </tbody>
    </table>
  </div>
		  
  <!-- btn -->
  <div class="btn_box_box"><a href="javascript:join(); " class="button_b1">회원가입</a></div>
  <!-- /btn --> 
  
</div>
		  
	    </div> 
		<div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div>
  </div>
     
</section>
<!-- //본문 -->

</body>

