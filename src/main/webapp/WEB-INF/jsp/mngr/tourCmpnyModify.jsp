<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>여행사수정</title>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione2.js'/>"></script>
<script type="text/javascript">
	function f_mod() {
		fnCheckRequired();
		if(!fnCheckMaxLength("CMPNY_NM", "회사이름")) return false;
		//if(!fnCheckMaxLength("CMPNY_INTRCN", "회사소개") return false;
		if(!fnCheckMaxLength("ADRES", "회사주소")) return false;
		if(!fnCheckMaxLength("TELNO", "전화번호")) return false;
		
		form1.action = "<c:url value='../modTourCmpny/'/>";
		form1.submit();	
	}
	
	function f_del() {
		form1.action = "<c:url value='../delTourCmpny/'/>";
		form1.submit();
	}

	<c:if test="${success eq false}">
		alert("조회 중 오류 발생");
	</c:if>
</script>
</head>
<body>
◆ 여행사수정
<br><br>
<form id="form1" method="post">
<input type="hidden" id="CMPNY_CODE" name="CMPNY_CODE" value="<c:out value='${tourCmpnyInfo.CMPNY_CODE}'/>">
<table width="800" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
		<td width="25%">회사이름</td>
		<td width="75%"><input type="text" id="CMPNY_NM" name="CMPNY_NM" size="50" maxlength="100" title="회사이름" value="<c:out value='${tourCmpnyInfo.CMPNY_NM}'/>"></td>
	</tr>
	<tr>
		<td width="25%">전화번호</td>
		<td width="75%"><input type="text" id="TELNO" name="TELNO" size="50" maxlength="20" title="전화번호" value="<c:out value='${tourCmpnyInfo.TELNO}'/>"></td>
	</tr>	
	<tr>
		<td width="25%">회사주소</td>
		<td width="75%"><input type="text" id="ADRES" name="ADRES" size="50" maxlength="500" title="주소"  value="<c:out value='${tourCmpnyInfo.ADRES}'/>"></td>
	</tr>	
			<tr>
		<td width="25%">회사소개</td>
		<td width="75%"><textarea id="CMPNY_INTRCN" name="CMPNY_INTRCN" cols="50" rows="10" title="소개"><c:out value='${tourCmpnyInfo.CMPNY_INTRCN}'/></textarea></td>
	</tr>	
</table>

<table width="800" cellpadding="5" cellspacing="0" border="0" align="left" >
	<tr>
		<td width='100%' align="right">
			<input type="button" value="저장" onclick="f_mod()">
			<input type="button" value="삭제" onclick="f_del()">
			<input type="button" value="취소" onclick="form1.reset();">
		</td>
	</tr>	
</table>
</form>
</body>
</html>