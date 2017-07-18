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
		$(location).attr("href", "<c:url value='../tourClRegist/'/>");
	}
	
	function f_mod(clCode, fileCode) {
		$('#CL_CODE').val(clCode);
		$('#FILE_CODE').val(fileCode);
		$("#form1").attr("action", "<c:url value='../tourClModify/'/>").submit();
	}
	<c:choose>
		<c:when test="${result.success eq true}">
			<c:if test="${result.message ne null}">alert("<c:out value='${result.message}'/>");</c:if>
		</c:when>
		<c:when test="${result.success eq false}">alert("<c:out value='${result.message}'/>");</c:when>
		<c:otherwise/>
	</c:choose>
</script>
</head>
<body>
◆ 여행분류관리
<br><br>
<input type="button" value="등록" onclick="f_reg()">
<br><br>
<table width="1024" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
		<th>순서</th>
		<th>분류코드</th>
		<th>분류명</th>
		<th>삭제여부</th>
		<th>등록일자</th>
		<th>수정일자</th>
		<th>파일여부</th>
	<tr>
	<c:forEach var="tourCl" items="${tourClList}" varStatus="status">
	<tr>
		<td>
			<c:out value='${status.count}'/>
		</td>
		<td>
			<c:out value='${tourCl.CL_CODE}'/>
		</td>
		<td ondblclick="javascript:f_mod('${tourCl.CL_CODE}', '${tourCl.FILE_CODE}')">
			<c:out value='${tourCl.CL_NM}'/>
		</td>
		<td>
			<c:if test="${tourCl.DELETE_AT == 'N'}">사용</c:if>
			<c:if test="${tourCl.DELETE_AT == 'Y'}"><font color='red'>삭제</font></c:if>
		</td>		
		<td>
			<c:out value='${tourCl.WRITNG_DE}'/>
		</td>
		<td>
			<c:out value='${tourCl.UPDT_DE}'/>
		</td>		
		<td><c:out value='${tourCl.FILE_CODE}'/></td>
	</tr>
	</c:forEach>
</table>
<form id="form1" method="post" action="<c:url value='../tourClModify/'/>">
	<input type="hidden" name="CL_CODE" id="CL_CODE">
	<input type="hidden" name="FILE_CODE" id="FILE_CODE">
</form>
</body>
</html>