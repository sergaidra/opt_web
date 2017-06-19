<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>관리자관리</title>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$("#btn_reg").click(function(){
			$(location).attr("href", "<c:url value='../tourCmpnyRegist/'/>");
		});
		
		$("#btn_sch").click(function(){
			$("form").attr("action", "<c:url value='../getMngrList/'/>").submit();
		});
	});

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
◆ 관리자관리
<br>
<br>
<form id="form1" method="post" action="<c:url value='../tourCmpnyModify/'/>">
<table width="800" cellpadding="5" cellspacing="0" border="0" align="left" >
	<tr>
		<td>이름:</td>
		<td><input type="text" name="SCH_MNGR_NM" id="SCH_MNGR_NM" value="<c:out value='${param.SCH_MNGR_NM}'/>"></td>
		<td>권한구분:</td>
		<td><input type="radio" name="SCH_AUTHOR_CD" id="SCH_AUTHOR_CD" value="A">관리자
			<input type="radio" name="SCH_AUTHOR_CD" id="SCH_AUTHOR_CD" value="G">가이드</td>
		<td>승인여부:</td>
		<td><select name="SCH_CONFM_AT" id="SCH_CONFM_AT">
				<option value="">전체</option>
				<option value="Y">승인</option>
				<option value="N">미승인</option>
			 </select></td>	
		<td><input type="button" id="btn_sch" value="검색">
			<input type="button" id="btn_reg" value="등록"></td>
	</tr>
</table>
<br>
<br>
<br>
<table width="800" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
		<th>순서</th>
		<th>아이디</th>
		<th>이름</th>
		<th>소속여행사</th>
		<th>권한구분</th>
		<th>승인여부</th>
		<th>등록일자</th>
		<th>수정일자</th>
	<tr>
	<tbody>
	<c:forEach var="mngr" items="${mngrList}" varStatus="status">
	<tr>
		<td><c:out value='${status.count}'/></td>
		<td onclick="javascript:f_mod('${mngr.ESNTL_ID}')"><c:out value='${mngr.MNGR_ID}'/></td>
		<td><c:out value='${mngr.MNGR_NM}'/></td>
		<td><c:out value='${mngr.CMPNY_NM}'/></td>
		<td><c:out value='${mngr.AUTHOR_CL}'/></td>
		<td><c:out value='${mngr.CONFM_AT}'/></td>
		<td><c:out value='${mngr.WRITNG_DE}'/></td>
		<td><c:out value='${mngr.UPDT_DE}'/></td>
	</tr>
	</c:forEach>
	</tbody>
</table>
</form>
</body>
</html>