<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>분류관리</title>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type = "text/javascript">
	function f_reg() {
		location.href = "<c:url value='../tourClRegist/'/>";
	}
	
	function f_mod(clCode, fileCode) {
		form1.CL_CODE.value = clCode;
		form1.FILE_CODE.value = fileCode;
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
◆ 분류관리
<br><br>
<input type="button" value="등록" onclick="f_reg()">
<br><br>
<table border='1'>
	<tr>
		<th>순서</th>
		<th>분류코드</th>
		<th>분류명</th>
		<th>등록일자</th>
		<th>파일여부</th>
	<tr>
	<c:forEach var="tourCl" items="${tourClList}" varStatus="status">
	<tr>
		<td><c:out value='${status.count}'/></td>
		<td><c:out value='${tourCl.CL_CODE}'/></td>
		<td ondblclick="javascript:f_mod('${tourCl.CL_CODE}', '${tourCl.FILE_CODE}')"><c:out value='${tourCl.CL_NM}'/></td>
		<td><c:out value='${tourCl.WRITNG_DE2}'/></td>
		<td><c:out value='${tourCl.FILE_CODE}'/></td>
	</tr>
	</c:forEach>
</table>
<form id="form1" method="post" action="<c:url value='../tourClModify/'/>">
	<input type="hidden" name="CL_CODE">
	<input type="hidden" name="FILE_CODE">
</form>
</body>
</html>