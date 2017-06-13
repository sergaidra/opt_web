<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>여행사관리</title>
<script type = "text/javascript">
	function f_reg() {
		location.href = "<c:url value='../tourCmpnyRegist/'/>";
	}

	function f_mod(code) {
		form1.CMPNY_CODE.value = code;
		form1.submit();
	}
	<c:choose>
		<c:when test="${success eq true}">
			<c:if test="${message ne null}">alert("<c:out value='${message}'/>");</c:if>
		</c:when>
		<c:when test="${success eq false}">alert("<c:out value='${message}'/>");</c:when>
		<c:otherwise/>
	</c:choose>
</script>
</head>
<body>
◆ 여행사관리
<br><br>
<input type="button" value="등록" onclick="f_reg()">
<br><br>
<table border='1'>
	<tr>
		<th>순서</th>
		<th>회사명</th>
		<th>주소</th>
		<th>전화번호</th>
		<th>소개</th>
		<th>등록일자</th>
	<tr>
	<c:forEach var="tourCmpnyList" items="${TOUR_CMPNY_LIST}" varStatus="status">
	<tr>
		<td><c:out value='${status.count}'/></td>
		<td onclick="javascript:f_mod('${tourCmpnyList.CMPNY_CODE}')"><c:out value='${tourCmpnyList.CMPNY_NM}'/></td>
		<td><c:out value='${tourCmpnyList.ADRES}'/></td>
		<td><c:out value='${tourCmpnyList.TELNO}'/></td>
		<td><c:out value='${tourCmpnyList.CMPNY_INTRCN}'/></td>
		<td><c:out value='${tourCmpnyList.WRITNG_DE2}'/></td>
	</tr>
	</c:forEach>
</table>
<form id="form1" method="post" action="<c:url value='../tourCmpnyModify/'/>">
	<input type="hidden" name="CMPNY_CODE">
</form>
</body>
</html>