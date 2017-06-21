<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>가이드등록</title>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione2.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$("#CMPNY_NM").click(function(){
			if($(this).val() == '') {
				f_popupTourCmpy();
			}
		});

		$('#PASSWORD').keyup(function(){
			f_chkPwd($(this).val());
		});

		$('#PASSWORD_CONFIRM').keyup(function(){
			f_cfmPwd($('#PASSWORD').val(), $(this).val());
		});
	});
	
	function f_add() {
		fnCheckRequired();
		if(!fnCheckMaxLength("MNGR_NM", "이름")) return;
		if(!fnCheckMaxLength("MNGR_ID", "아이디")) return;
		if(!fnCheckMaxLength("PASSWORD", "비밀번호")) return;
		if(!fnCheckMaxLength("PASSWORD_CONFIRM", "비밀번호확인")) return;
		//if(!fnCheckMaxLength("AUTHOR_CL", "가입유형")) return;
		if(!fnCheckMaxLength("CMPNY_CODE", "소속여행사")) return;
		
		if(!f_chkPwd($('#PASSWORD').val())) return;
		if(!f_cfmPwd($('#PASSWORD').val(), $('#PASSWORD_CONFIRM').val())) return;
		
		form1.submit();
	}
	
	function f_chkPwd(str){
		var pw = str;
		var num = pw.search(/[0-9]/g);
		var eng = pw.search(/[a-z]/ig);
		var spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);

		if(pw.length < 10 || pw.length > 20){
			$("#divChkPwd").html("10~20자리 이내로 입력하십시오.");
			return false;
		}

		if(pw.search(/₩s/) != -1){
			$("#divChkPwd").html("비밀번호는 공백없이 입력하십시오.");
			return false;
		}

		if( (num < 0 && eng < 0) || (eng < 0 && spe < 0) || (spe < 0 && num < 0) ){
			$("#divChkPwd").html("영문, 숫자, 특수문자 중 2가지 이상을 혼합하여 입력하십시오.");
			return false;
		}
		
		$("#divChkPwd").html("");
		return true;
	}
	
	function f_cfmPwd(str1, str2) {
		var pw1 = str1;
		var pw2 = str2;
		
		if(!pw1) return false;
		if(!pw2) return false;
		
		if(pw1 != pw2) {
			$("#divCfmPwd").html("비밀번호와 일치하지 않습니다. 다시 입력하십시오.");
			return false;
		}
		
		$("#divCfmPwd").html("비밀번호와 일치합니다.");
		return true;
	}
	
	function f_popupTourCmpy() {
		fnOpenPopup("../tourCmpnyPopup/", "winTourCmpnyPopup", 700, 450);
	}
</script>
</head>
<body>
◆ 가이드등록
<br><br>
<form id="form1" method="post" action="<c:url value='../addMngr/'/>" >
<table width="800" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
		<td width="25%">이름</td>
		<td width="75%"><input type="text" id="MNGR_NM" name="MNGR_NM" size="50" maxlength="100" title="이름"></td>
	</tr>
	<tr>
		<td width="25%">아이디</td>
		<td width="75%"><input type="text" id="MNGR_ID" name="MNGR_ID" size="50" maxlength="20" title="아이디"></td>
	</tr>	
	<tr>
		<td width="25%">비밀번호</td>
		<td width="75%">
			<input type="text" id="PASSWORD" name="PASSWORD" size="50" maxlength="20" title="비밀번호">
			<div id="divChkPwd"></div>
		</td>
	</tr>	
	<tr>
		<td width="25%">비밀번호 확인</td>
		<td width="75%">
			<input type="text" id="PASSWORD_CONFIRM" name="PASSWORD_CONFIRM" size="50" maxlength="20" title="비밀번호확인">
			<input type="button" value="비밀번호확인" onclick="f_cfmPw()">
			<div id="divCfmPwd"></div>
		</td>
	</tr>
	<tr>
		<td width="25%">가입유형</td>
		<td width="75%">
			<input type="radio" name="AUTHOR_CL" value="A">관리자
			<input type="radio" name="AUTHOR_CL" value="G">가이드
		</td>
	</tr>		
	<tr>
		<td width="25%">소속여행사선택</td>
		<td width="75%">
			<input type="text" id="CMPNY_NM" name="CMPNY_NM" size="50" maxlength="100" title="소속여행사" readonly>
			<input type="hidden" id="CMPNY_CODE" name="CMPNY_CODE" size="50" maxlength="20" title="소속여행사코드">
			<input type="button" value="여행사" onclick="f_popupTourCmpy()">
		</td>
	</tr>	
</table>

<table width="800" cellpadding="5" cellspacing="0" border="0" align="left">
	<tr>
		<td width="100%" align="right">
			<input type="button" value="저장" onclick="f_add()">
			<input type="button" value="취소" onclick="form1.reset();">
		</td>
	</tr>	
</table>
</form>
</body>
</html>