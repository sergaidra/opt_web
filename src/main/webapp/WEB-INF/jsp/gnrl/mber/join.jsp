<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>

<!-- 날짜선택 -->	
<script src="/jq/time/build/jquery.datetimepicker.full.js"></script> 

<script type="text/javascript">
$(function() {
	$.datetimepicker.setLocale('en');

	$('#birth').datetimepicker( {
		format:'Y-m-d',
		timepicker:false
	});
	
	$("#user_id").change(function () {
		isUserIdDup = false;
		$("#btnUserIdChk").show();
		$("#muser_id").val($("#user_id").val());	
	});
	
	$("#muser_id").change(function() {
		isUserIdDup = false;
		$("#btnUserIdChk").show();
		$("#user_id").val($("#muser_id").val());	
	});
	
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

});

var isUserIdDup = false;

function join() {
	if(validation() == false)
		return false;
	
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
				alert("회원가입 신청되었습니다.\r\n이메일을 확인해주세요.");
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

function useridchk() {
	if($.trim($("#user_id").val()) == "") {
		alert("아이디를 입력해주세요.");
		$("#user_id").focus();
		return false;
	}

	var url = "<c:url value='/member/chkUserInfo'/>";
	
	var param = {};
	param.user_id = $.trim($("#user_id").val());
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
			if(data.result == "0") {
	        	if(data.data == "Y") {
	        		isUserIdDup = true;
	        		$("#btnUserIdChk").hide();        		
	        	} else {
	        		alert("동일한 아이디가 존재합니다.");
	        		return false;
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
	//if($.trim($("#user_id").val()) == "") {
	//	alert("아이디를 입력해주세요.");
	//	$("#user_id").focus();
	//	return false;
	//}
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
	if($(':radio[name="rdoSex"]:checked').length == 0) {
		alert("성별을 선택해주세요.");
		return false;		
	}
	if($.trim($("#birth").val()) == "") {
		alert("생년월일을 입력해주세요.");
		$("#birth").focus();
		return false;
	}

	var password = $.trim($("#password").val());
	var passwordchk = $.trim($("#passwordchk").val());
	
	if(password.length < 4 || password.length > 12) {
		alert("비밀번호는 4~12자리 이내로 입력하세요.");
		$("#password").focus();
		return false;
	}
	
	if(password != passwordchk) {
		alert("비밀본호와 비밀번호 확인이 맞지 않습니다.")
		return false;
	}
	
	//if(isUserIdDup == false) {
	//	alert("아이디 중복 확인해주세요.");
	//	return false;
	//}
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
      <div class="title">제1장 총칙 </div>
      <div class="text"><em>[제1조 목적]</em><br>
        이 약관은 ooo(이하 'ooo')가 제공하는 서비스 이용조건 및 절차에 관한 사항과 기타 필요한 사항을 전기통신사업법 및 동법 시행령이 정하는 대로 준수하고 규정함을 목적으로 합니다.<br />
        <br />
        <em>[제2조 약관의 효력과 변경]</em><br />
        (1) 이 약관은 이용자에게 공시함으로서 효력이 발생합니다.<br />
        (2) ooo는 사정 변경의 경우와 영업상 중요 사유가 있을 때 약관을 변경할 수 있으며, 변경된 약관은 전항과 같은 방법으로 효력이 발생합니다.<br />
        <br />
        <em>[제3조 약관 외 준칙]</em><br />
        이 약관에 명시되지 않은 사항이 관계 법령에 규정되어 있을 경우에는 그 규정에 따릅니다. </div>
      <div class="sp_30"></div>
      <div class="title">제2장 회원 가입과 서비스 이용 </div>
      <div class="text"><em>[제1조 회원의 정의]</em><br />
        회원이란 ooo가 회원으로 적합하다고 인정하는 일반 개인으로 본 약관에 동의하고 서비스의 회원 가입양식을 작성하고 'ID'와 '비밀번호'를 발급 받은 사람을 말합니다.<br />
        <br />
        <em> [제2조 서비스 가입의 성립]</em><br />
        (1) 서비스 가입은 이용자의 이용 신청에 대한 ooo의 이용 승낙과 이용자의 약관 내용에 대한 동의로 성립됩니다.<br />
        (2) 회원으로 가입하여 서비스를 이용하고자 하는 희망자는 ooo에서 요청하는 개인 신상정보를 제공해야 합니다.<br />
        (3) 이용자의 가입 신청에 대하여 회사가 승낙한 경우, ooo는 회원 ID와 기타 ooo가 필요하다고 인정하는 내용을 이용자에게 통지합니다.<br />
        (4) 가입할 때 입력한 ID는 변경할 수 없으며, 한 사람에게 오직 한 개의 ID가 발급됩니다.<br />
        (5) ooo는 다음 각 호에 해당하는 가입 신청에 대하여는 승낙하지 않습니다.<br />
        가. 다른 사람의 명의를 사용하여 신청하였을 때 <br />
        나. 본인의 실명으로 신청하지 않았을 때<br />
        다. 가입 신청서의 내용을 허위로 기재하였을 때 <br />
        라. 사회의 안녕과 질서 혹은 미풍양속을 저해할 목적으로 신청하였을 때 <br />
        <br />
        <em> [제3조 서비스 이용 및 제한]</em><br />
        (1) 서비스 이용은 ooo의 업무상 또는 기술상 특별한 지장이 없는 한 연중무휴, 1일 24시간을 원칙으로 합니다.<br />
        (2) 전항의 서비스 이용시간은 시스템 정기점검 등 회사가 필요한 경우, 회원에게 사전 통지한 후, 제한할 수 있습니다. <br />
        (3) 서비스 내용중 상담 서비스는 답변하는 전문 의사의 개인 사정에 따라 1일 24시간 서비스가 불가능 할 수도 있습니다.<br />
        <br />
        <em> [제4조 서비스의 사용료]</em><br />
        (1) 서비스는 회원으로 등록한 모든 사람들이 무료로 사용할 수 있습니다.<br />
        (2) ooo가 서비스를 유료화할 경우 유료화의 시기, 정책, 비용에 대하여 유료화 실시 이전에 서비스에 공시하여야 합니다.<br />
      </div>
      <div class="sp_30"></div>
      <div class="title">제3장 서비스 탈퇴, 재가입 및 이용 제한</div>
      <div class="text"><em>[제1조 서비스 탈퇴]</em><br />
        (1) 회원이 서비스의 탈퇴를 원하면 회원 본인이 직접 전자메일을 통해 운영자(info@adamsclinic.co.kr)에게 해지 신청을 요청해야 합니다.<br />
        (2) 탈퇴 신청시 본인임을 알 수 있는 이름, ID, 전화번호, 해지사유를 알려주면, 가입기록과 일치여부를 확인한 후 가입을 해지합니다.<br />
        (3) 탈퇴 여부는 기존의 ID와 비밀번호로 로그인이 되지 않으면 해지된 것입니다.<br />
        <br />
        <em> [제2조 서비스 재가입]</em><br />
        (1) 제1조에 의하여 서비스에서 탈퇴한 사용자가 재가입을 원할 경우 회원 본인이 직접 전자메일을 통해 운영자(info@adamsclinic.co.kr)에게 재가입을 요청하면 됩니다.<br />
        (2) 재가입 요청시 본인임을 알 수 있는 이름, ID, 전화번호를 알려주면 재가입 처리를 해드립니다.<br />
        (3) 기존의 ID와 비밀번호로 로그인이 되면 재가입이 이루어진 것입니다. <br />
        <br />
        <em> [제3조 서비스 이용제한] </em><br />
        ooo는 회원이 다음 사항에 해당하는 행위를 하였을 경우, 사전통지 없이 이용계약을 해지하거나 기간을 정하여 서비스 이용을 중지할 수 있습니다.<br />
        가. 공공 질서 및 미풍 양속에 반하는 경우<br />
        나. 범죄적 행위에 관련되는 경우<br />
        다. 국익 또는 사회적 공익을 저해할 목적으로 서비스 이용을 계획 또는 실행할 경우<br />
        라. 타인의 ID 및 비밀번호를 도용한 경우<br />
        마. 타인의 명예를 손상시키거나 불이익을 주는 경우 <br />
        바. 같은 사용자가 다른 ID로 이중 등록을 한 경우<br />
        사. 서비스에 위해를 가하는 등 건전한 이용을 저해하는 경우<br />
        아. 기타 관련 법령이나 회사가 정한 이용조건에 위배되는 경우<br />
      </div>
      <div class="sp_30"></div>
      <div class="title"> 제4장 서비스에 관한 책임의 제한</div>
      <div class="text"><em>[제1조 상담 서비스]</em><br />
        (1) ooo는 서비스의 회원 혹은 사용자들의 상담 내용이 상담의와 서비스 관리자를 제외한 제3자에게 유출되지 않도록 최선을 다해 보안을 유지하려고 노력합니다. 그러나 다음과 같은 경우에는 상담 내용 공개 및 상실에 대하여 회사에 책임이 없습니다.<br />
        가. 사용자의 부주의로 암호가 유출되어 상담 내용이 공개되는 경우<br />
        나. 사용자가 '상담삭제' 기능을 사용하여 상담을 삭제하였을 경우<br />
        다. 천재지변이나 그 밖의 ooo가 통제할 수 없는 상황에 의하여 상담 내용이 공개되거나상담내용이 상실되었을 경우<br />
        (2) 회원이 신청한 상담에 대한 종합적이고 적절한 답변을 위하여 주치의사, 각과 전문의사들은 상담 내용과 답변을 참고할 수 있습니다.<br />
        (3) 서비스에서 진행된 상담의 내용은 개인 신상정보를 삭제한 다음 아래와 같은 목적으로 사용할 수 있습니다.
        가. 학술활동<br />
        나. 인쇄물, CD-ROM 등의 저작활동<br />
        다. FAQ, 추천상담 등의 서비스 내용의 일부<br />
        (4) 상담에 대한 답변 내용은 각 전문 의사의 의학적 지식을 바탕으로 한 주관적인 답변으로 ooo 서비스의 의견을 대표하지는 않습니다.<br />
        (5) 아래와 같은 상담을 신청하는 경우에는 상담 서비스를 전체 또는 일부 제공하지 않을수 있습니다.<br />
        가. 같은 내용의 상담을 반복하여 신청하는 경우<br />
        나. 상식에 어긋나는 표현을 사용하여 상담을 신청하는 경우<br />
        다. 진단명을 요구하는 상담을 신청하는 경우<br />
        라. 치료비, 검사비, 의약품 가격 등에 대하여 상담을 신청하는 경우<br />
        <br />
        <em>[제2조 정보 서비스]</em><br />
        (1) 서비스에서 제공되는 내용은 개략적이며 일반적인 내용이고 정보제공만을 위해 제공됩니다. 서비스에서 제공되는 정보나 상담은 절대로 의학적인 진단을 대신할 수 없습니다. 서비스에서 제공되는 정보나 상담은 결코 의학적 진단, 진료, 혹은 치료를 대신하려는 목적이 아닙니다. 회원의 건강상태에 관한 의문점이나 걱정이 있다면 실제 전문의사를 찾아 진단을 받아야 합니다. 어떠한 경우에도 서비스에서 제공하는 정보 때문에 의학전 진단을 무시하거나, 진단, 진료 혹은 치료 받는 것을 미루지 마십시요.<br />
        (2) 본 서비스의 정보, 서비스에 참여하는 전문 의사 혹은 서비스를 사용하는 다른 회원이나 방문객의 의견을 받아들이는 것은 전적으로 사용자의 판단에 따르는 것입니다. 따라서 ooo에서는 회원에게 제공된 어떠한 제품의 활용, 정보, 아이디어 혹은 지시로부터 비롯하는 어떠한 손해, 상해 혹은 그 밖의 불이익에 대한 책임을 지지 않습니다.</div>
      <div class="sp_30"></div>
      <div class="title"> 제5장 의무</div>
      <div class="text"><em>[제1조 ooo의 의무]</em><br />
        (1) ooo는 특별한 사정이 없는 한 회원이 서비스를 이용할 수 있도록 합니다.<br />
        (2) ooo는 이 약관에서 정한 바에 따라 계속적, 안정적으로 서비스를 제공할 의무가 있습니다.<br />
        (3) ooo는 회원으로부터 소정의 절차에 의해 제기되는 의견에 대해서 적절한 절차를 거쳐처리하며, 처리시 일정기간이 소요될 경우 회원에게 그 사유와 처리 일정을 알려주어야 합니다.<br />
        <br />
        <em>[제2조 회원 정보 보안의 의무]</em><br />
        (1) 회원의 ID와 비밀번호에 관한 모든 관리의 책임은 회원에게 있습니다.<br />
        (2) 회원은 서비스의 일부로 보내지는 서비스의 전자우편을 받는 것에 동의합니다.<br />
        (3) 자신의 ID가 부정하게 사용된 경우, 회원은 반드시 ooo에 그 사실을 통보해야 합니다.<br />
        (4) ooo는 개인의 신분 확인이 가능한 정보를 회원 혹은 사용자의 사전허락 없이 ooo와 관계가 없는 제3자에게 팔거나 제공하지 않습니다. 그러나 ooo는 자발적으로 제공된 등록된 정보를 다음과 같은 경우에 활용할 수 있습니다.<br />
        가. 회원들에게 유용한 새 기능, 정보, 서비스 개발에 필요한 정보를 개발자들에게 제공하는 경우<br />
        나. 광고주들에게 서비스 회원과 사용자 집단에 대한 통계적(결코 회원 개개인의 신분이 드러나지 않는) 정보를 제공하는 경우<br />
        다. 회원과 사용자 선호에 따른 광고 또는 서비스를 실시하기 위하여 ooo에서 사용하는 경우<br />
        (5) 게시판, 대화방 등의 커뮤니케이션 공간(이하 커뮤니케이션 공간)에 개인 신분 확인이 가능한 정보(사용자 이름, ID, e-mail 주소 등)가 자발적으로 공개될 수 있습니다. 이런 경우 공개된 정보가 제3자에 의해 수집되고, 연관되어지며, 사용될 수 있으며 제3자로부터 원하지 않는 메시지를 받을 수도 있습니다. 제3자의 그러한 행위는 ooo가 통제할 수 없습니다. 따라서 ooo는 ooo가 통제할 수 없는 방법에 의한 회원 정보의 발견 가능성에 대해 아무런 보장을 하지 않습니다.<br />
        (6) ooo는 서비스의 사용의 편의를 위하여 Cookie 기술을 사용할 수 있습니다. Cookie란 다시 방문하는 사용자를 파악하고 그 사용자의 계속된 접속과 개인화된 서비스 제공을 돕기 위해 웹 사이트가 사용하는 작은 텍스트 파일입니다. 일반적으로 Cookie는 Cookie를 부여한 사이트 밖에서는 의미가 없는 유일한 번호를 사용자에게 부여하는 방식으로 작동합니다. Cookie는 사용자의 시스템 내부로 침입하지 않으며 사용자의 파일에 위험하지 않습니다. ooo는 서비스의 광고주나 관련있는 제3자가 Cookie를 사용하는 것을 막을 수 없습니다. 회원 혹은 사용자가 Cookie를 사용한 정보수집을 원하지 않는 경우에는 웹 브라우저에서 Cookie를 받아들일 지 여부를 조절할 수 있습니다. 하지만 서비스(특히, 개인화된 정보)가 제대로 작동하기 위해서는 Cookie의 사용이 필요할 수 있습니다. <br />
        (7) ooo는 회원의 정보를 서비스 또는 회사와 업무제휴 업체간에 상호 제공/활용할 수 있습니다.<br />
      </div>
      <div class="sp_30"></div>
      <div class="title">제6장 분쟁조정</div>
      <div class="text"><em>[제1조 ooo의 의무]</em><br />
        (1) 본 이용약관에 규정된 것을 제외하고 발생하는 서비스 이용에 관한 제반 문제에 관한분쟁은 최대한 쌍방합의에 의해 해결하도록 합니다.<br />
        (2) 서비스 이용으로 발생한 분쟁에 대해 소송이 제기될 경우 ooo의 소재지를 관할하는 법원을 관할법원으로 합니다. <br />
        <br />
        <br />
        <em> [부칙] </em> 이 약관은 2004년 3월 1일부터 시행합니다.</div>
    </div>
</div>  <div class="agr_ch">
    <input type="checkbox" required id="chkReq1">
   이용약관에 동의합니다.</div></div>
 <div class="agr_out_fr">

  <div class="agr">
    <div class="privacy">
      <div class="title1">개인정보의 수집목적 및 이용목적</div>
      <ul>
        <li>서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산
          콘텐츠 제공 , 구매 및 요금 결제 , 물품배송 또는 청구지 등 발송</li>
        <li>회원제 서비스 이용에 따른 본인확인 , 개인 식별 , 가입 의사 확인 , 연령확인 , 불만처리 등 
          민원처리 , 고지사항 전달</li>
        <li>신규 서비스(제품) 개발 및 특화 , 이벤트 등 광고성 정보 전달 , 접속 빈도 파악 또는 
          회원의 서비스 이용에 대한 통계 </li>
      </ul>
      <br />
      <br />
      <div class="sp_30"></div>
      <div class="title">수집하는 개인정보의 항목</div>
      <ul>
        <li>이름, 생년월일, 성별, 로그인ID, 비밀번호, 비밀번호 질문과 답변, 자택전화번호, 자택주소, 
          휴대전화번호, 이메일, 회사명, 회사전화번호, 기념일, 서비스 이용기록, 접속 로그, 쿠키, 
          접속 IP 정보, 결제기록 </li>
      </ul>
      <br />
      <br />
      <div class="sp_30"></div>
      <div class="title">개인정보의 보유 및 이용기간</div>
      <ul>
        <li>원칙적으로 개인정보의 수집 또는 제공받은 목적 달성 시 지체 없이 파기합니다.</li>
        <li>전자상거래에서의 소비자보호에 관한 법률 등 타법률에 의해 보존할 필요가 있는 경우에는  일정기간 보존합니다. </li>
        <li>보존 항목 : 이름 , 생년월일 , 성별 , 로그인ID , 비밀번호 질문과 답변 , 자택 전화번호 , 
          자택 주소 , 휴대전화번호 , 이메일 , 회사전화번호 , 기념일 , 서비스 이용기록 , 접속 로그 ,
          쿠키 , 접속 IP 정보 , 결제기록<br />
          보존 기간 : 5년 </li>
        <li>보존 항목 : 비밀번호 , 회사명<br />
          보존 기간 : 3년 </li>
        <li>계약 또는 청약철회 등에 관한 기록 : 5년 </li>
        <li>대금결제 및 재화 등의 공급에 관한 기록 : 5년 </li>
        <li>소비자의 불만 또는 분쟁처리에 관한 기록 : 3년 </li>
        <li>신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년 </li>
      </ul>
      <br />
      <br />
    </div>
  </div>   <div class="agr_ch">
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
        <!-- <tr>
          <th>아이디 </th>
          <td class="line"><input id="user_id" name="user_id" type="text" class="w_30p pc_view" value=""  />
          	<input id="muser_id" name="user_id" type="text" class="w_100p mobile_view"  value=""  />
            &nbsp;
            <div class="btnst"><a href="javascript:useridchk();" id="btnUserIdChk">아이디 중복 확인</a></div></td>
        </tr> -->
        <tr>
          <th>이메일</th>
          <td class="line"><input id="email" name="email" type="text" class="w_30p pc_view" value=""   />
          <!--모바일 --> <input id="memail" name="email" type="text" class="w_100p mobile_view"  value=""   />
            &nbsp;&nbsp;&nbsp;
            <input type="checkbox" id="email_recptn_at" name="email_recptn_at" id="checkbox" value="Y"/>
            이벤트 및 새로운 소식 수신 </td>
        </tr>
        <tr>
          <th>비밀번호</th>
          <td class="line"><input id="password" name="password" type="password" class="w_20p pc_view" value=""   />
          	<!--모바일 --><input id="mpassword" name="password" type="password" class="w_50p mobile_view"  value=""   />
            &nbsp;&nbsp;4~12자리 이내로 입력하세요.</td>
        </tr>
        <tr>
          <th>비밀번호 확인</th>
          <td class="line"><input id="passwordchk" name="passwordchk" type="password" class="w_20p pc_view" value=""   />
          <!--모바일 --><input id="mpasswordchk" name="passwordchk" type="password" class="w_50p mobile_view"   value=""   /></td>
        </tr>
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
          <td class="line"><input id="moblphon_no" name="moblphon_no" type="text"  class="w_30p pc_view" value=""   />
          <!--모바일 --><input id="mmoblphon_no" name="moblphon_no" name="input3" type="text" class="w_100p mobile_view"  value=""   />
            &nbsp;&nbsp;&nbsp;
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
          <td class="line"><input type="radio" name="rdoSex" id="rdoSexM" value="M" />
            <label for="radio"></label>
            남성
            <input type="radio" name="rdoSex" id="rdoSexF" value="F" />
            여성</td>
        </tr>
        <tr>
          <th>생년월일</th>
          <td class="line"><input id="birth" name="birth" type="text" class="w_100p" value=""  /></td>
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

