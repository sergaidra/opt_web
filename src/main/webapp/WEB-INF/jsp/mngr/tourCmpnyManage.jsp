<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>여행사관리</title>
<script type = "text/javascript">
	function f_reg() {
		$(location).attr("href", "<c:url value='../tourCmpnyRegist/'/>");
	}

	function f_mod(code) {
		$("#CMPNY_CODE").val(code);
		$("#form1").attr("action", "<c:url value='../tourCmpnyModify/'/>").submit();
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
<br>
<table cellpadding="5" cellspacing="0" border="0" align="left" >
	<tr>
		<td width='100%' align="right">
			<input type="button" value="등록" onclick="f_reg()">
		</td>
	</tr>	
</table>
<br><br>
<table width="1024" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
		<th>순서</th>
		<th>회사명</th>
		<th>주소</th>
		<th>전화번호</th>
		<th>소개</th>
		<th>등록일자</th>
	<tr>
	<tbody>
	<c:forEach var="tourCmpnyList" items="${TOUR_CMPNY_LIST}" varStatus="status">
	<tr>
		<td width="5%">
			<c:out value='${status.count}'/>
		</td width="15%">
		<td onclick="javascript:f_mod('${tourCmpnyList.CMPNY_CODE}')">
			<c:out value='${tourCmpnyList.CMPNY_NM}'/>
		</td>
		<td width="20%">
			<c:out value='${tourCmpnyList.ADRES}'/>
		</td>
		<td width="20%">
			<c:out value='${tourCmpnyList.TELNO}'/>
		</td>
		<td width="30%">
			<c:out value='${tourCmpnyList.CMPNY_INTRCN}'/>
		</td>
		<td width="10%">
			<fmt:parseDate value="${tourCmpnyList.WRITNG_DE}" pattern="yyyyMMdd" var="WRITNG_DE" scope="page"/>
			<fmt:formatDate value="${WRITNG_DE}" pattern="yyyy-MM-dd"/>
		</td>
	</tr>
	</c:forEach>
	</tbody>
</table>



<form id="form1" method="post" action="<c:url value='../tourCmpnyModify/'/>">
	<input type="hidden" name="CMPNY_CODE">
</form>
</body>
</html>