<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>상품관리</title>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type = "text/javascript">
	function f_reg() {
		$(location).attr("href", "<c:url value='../goodsRegist/'/>");
	}
	
	function f_mod(clCode, fileCode) {
		$('#GOODS_CODE').val(clCode);
		$('#FILE_CODE').val(fileCode);
		$("#form1").attr("action", "<c:url value='../goodsModify/'/>").submit();
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
◆ 상품관리
<br><br>
<input type="button" value="등록" onclick="f_reg()">
<br><br>
<table width="1024" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
		<th>순서</th>
		<th>상품코드</th>
		<th>분류</th>		
		<th>상품명</th>
		<th>삭제여부</th>
		<th>등록일자</th>
		<th>수정일자</th>
		<th>파일여부</th>
	<tr>
	<c:forEach var="goods" items="${goodsList}" varStatus="status">
	<tr ondblclick="javascript:f_mod('${goods.GOODS_CODE}', '${goods.FILE_CODE}')">
		<td>
			<c:out value='${status.count}'/>
		</td>
		<td>
			<c:out value='${goods.GOODS_CODE}'/>
		</td>
		<td>
			<c:out value='${goods.CL_NM}'/>
		</td>		
		<td>
			<c:out value='${goods.GOODS_NM}'/>
		</td>
		<td>
			<c:if test="${goods.DELETE_AT == 'N'}">사용</c:if>
			<c:if test="${goods.DELETE_AT == 'Y'}"><font color='red'>삭제</font></c:if>
		</td>		
		<td>
			<c:out value='${goods.WRITNG_DE}'/>
		</td>
		<td>
			<c:out value='${goods.UPDT_DE}'/>
		</td>		
		<td><c:out value='${goods.FILE_CODE}'/></td>
	</tr>
	</c:forEach>
</table>
<form id="form1" method="post" action="<c:url value='../goodsModify/'/>">
	<input type="hidden" name="GOODS_CODE" id="GOODS_CODE">
	<input type="hidden" name="FILE_CODE" id="FILE_CODE">
</form>
</body>
</html>