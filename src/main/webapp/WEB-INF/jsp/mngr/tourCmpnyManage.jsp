<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>여행사관리</title>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/Common.js'/>"></script>
<script type = "text/javascript">
	function f_reg() {
		$(location).attr("href", "<c:url value='../tourCmpnyRegist/'/>");
	}

	function f_sch() {
		fnPage();
	}
	
	function f_mod(code) {
		$("#CMPNY_CODE").val(code);
		$("#form1").attr("action", "<c:url value='../tourCmpnyModify/'/>").submit();
	}
	
	function fnPage() {
		$("#hidPage").val(1);
		$("#form1").attr("action", "<c:url value='../tourCmpnyManage/'/>").submit();
	}
	
	function fnLinkPage(page){
		$("#hidPage").val(page);
		$("#form1").attr("action", "<c:url value='../tourCmpnyManage/'/>").submit();
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
◆ 여행사관리
<br>
<form id="form1" method="post" action="<c:url value='../tourCmpnyModify/'/>">
<input type="hidden" name="CMPNY_CODE" id="CMPNY_CODE">
<input type="hidden" id="hidPage" name="hidPage">
<table cellpadding="5" cellspacing="0" border="0" align="left" >
	<tr>
		<td>*여행사이름:</td>
		<td>
			<input type="text" id="SCH_CMPNY_NM" name="SCH_CMPNY_NM" size="20"  value="<c:out value='${param.SCH_CMPNY_NM}'/>">
		</td>
		<td>
			<input type="button" value="검색" onclick="f_sch()">
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
		<th>삭제</th>
		<th>등록일자</th>
	<tr>
	<tbody>
	<c:forEach var="tourCmpny" items="${tourCmpnyList}" varStatus="status">
	<tr>
		<td width="5%">
			<c:out value='${status.count}'/>
		</td width="15%">
		<td onclick="javascript:f_mod('${tourCmpny.CMPNY_CODE}')">
			<c:out value='${tourCmpny.CMPNY_NM}'/>
		</td>
		<td width="20%">
			<c:out value='${tourCmpny.ADRES}'/>
		</td>
		<td width="15%">
			<c:out value='${tourCmpny.TELNO}'/>
		</td>
		<td width="30%">
			<c:out value='${tourCmpny.CMPNY_INTRCN}'/>
		</td>
		<td width="5%">
			<c:out value='${tourCmpny.DELETE_AT}'/>
		</td>		
		<td width="10%">
			<fmt:parseDate value="${tourCmpny.WRITNG_DE}" pattern="yyyyMMdd" var="writngDe" scope="page"/>
			<fmt:formatDate value="${writngDe}" pattern="yyyy-MM-dd"/>
		</td>
	</tr>
	</c:forEach>
	</tbody>
</table>
</form>
<br>
<br>
<table width="1024">	
	<tr>
		<td align="center">
			<ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fnLinkPage"/>
		</td>
	</tr>
</table>
</body>
</html>