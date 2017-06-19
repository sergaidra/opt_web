<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>여행사등록</title>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione2.js'/>"></script>
<script type="text/javascript">
	function f_add() {
		fnCheckRequired();
		if(!fnCheckMaxLength("CMPNY_NM", "회사이름")) return;
		//if(!fnCheckMaxLength("CMPNY_INTRCN", "회사소개") return;
		if(!fnCheckMaxLength("ADRES", "회사주소")) return;
		if(!fnCheckMaxLength("TELNO", "전화번호")) return;
		form1.submit();	
	}
</script>
</head>
<body>
◆ 여행사등록
<br><br>

<form id="form1" method="post" action="<c:url value='../addTourCmpny/'/>">
<br><br>회사이름 : <input type="text" id="CMPNY_NM" name="CMPNY_NM" size="50" maxlength="100" title="회사이름">
<br><br>회사소개 : <textarea id="CMPNY_INTRCN" name="CMPNY_INTRCN" cols="50" rows="10" title="소개">test</textarea>
<br><br>회사주소 : <input type="text" id="ADRES" name="ADRES" size="50" maxlength="500" title="주소">
<br><br>전화번호 : <input type="text" id="TELNO" name="TELNO" size="50" maxlength="20" title="전화번호">
</form>
<br><br>
<input type="button" value="저장" onclick="f_add()">
<input type="button" value="취소" onclick="form1.reset();">
</body>
</html>