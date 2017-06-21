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
<script type = "text/javascript">
	function f_sel(str1, str2) {
		$("#CMPNY_CODE", opener.document).val(str1);
		$("#CMPNY_NM", opener.document).val(str2);
		window.close();
	}
	function fnPage() {
		$("#hidPage").val(1);
		$("#form1").attr("action", "<c:url value='../tourCmpnyManage/'/>").submit();
	}
	
	function fnLinkPage(page){
		$("#hidPage").val(page);
		$("#form1").attr("action", "<c:url value='../tourCmpnyManage/'/>").submit();
	}	
</script>
</head>
<body>
◆ 여행사조회
<br>
<form id="form1" method="post" action="../tourCmpnyPopup/">
<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" id="SCH_DELETE_AT" name="SCH_DELETE_AT" value="N">
<table cellpadding="5" cellspacing="0" border="0" align="left" >
	<tr>
		<td>
			이름 :
		</td>	
		<td>
			<input type="text" id="SCH_CMPNY_NM" name="SCH_CMPNY_NM" value="<c:out value='${param.SCH_CMPNY_NM}'/>">
		</td>	
		<td align="right">
			<input type="button" value="검색" onclick="form1.submit();">
		</td>
	</tr>	
</table>
<br><br>
<table width="650" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
		<th>순서</th>
		<th>회사명</th>
		<th>주소</th>
		<th>전화번호</th>
	<tr>
	<tbody>
	<c:forEach var="tourCmpny" items="${tourCmpnyList}" varStatus="status">
	<tr>
		<td>
			<c:out value='${status.count}'/>
		</td>
		<td ondblclick="javascript:f_sel('${tourCmpny.CMPNY_CODE}', '${tourCmpny.CMPNY_NM}')">
			<c:out value='${tourCmpny.CMPNY_NM}'/>
		</td>
		<td>
			<c:out value='${tourCmpny.ADRES}'/>
		</td>
		<td>
			<c:out value='${tourCmpny.TELNO}'/>
		</td>
	</tr>
	</c:forEach>
	</tbody>
</table>

</form>

<br>
<br>
<table width="650">	
	<tr>
		<td align="center">
			<ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fnLinkPage"/>
		</td>
	</tr>
</table>
</body>
</html>