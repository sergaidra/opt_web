<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">	
	function fnPage() {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidPage]").val(1);
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}
	
	function fnDetail(goods_code) {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidGoodsCode]").val(goods_code);
		form.attr({"method":"post","action":"<c:url value='/goods/detail/'/>"});
		form.submit();
	}
</script>
<div align="center">
	<div style="height:30px;" align="center">
		<c:if test="${fn:length(tourList) == 0}">
			전체
		</c:if>
		<c:forEach var="result" items="${tourList}" varStatus="status">
			<c:if test="${status.count > 1}"> - </c:if>
			${result.CL_NM}
		</c:forEach>
	</div>
	<form id="frmList" name="frmList" action="<c:url value='/goods/detail/'/>">
	<input type="hidden" id="hidPage" name="hidPage" value="${page}">
	<input type="hidden" id="hidGoodsCode" name="hidGoodsCode">
	<table width="1024px" border="1" cellspacing="0" cellpadding="0" height="100%" style="border-collapse:collapse; border:1px gray solid;">
		<tr>
		<c:if test="${fn:length(goodsList) == 0}">
			<td height="100px" align="center">조회된 결과가 없습니다.</td>
		</c:if>
		<c:forEach var="result" items="${goodsList}" varStatus="status">
			<td align="center">	
				<table cellspacing="0" cellpadding="0">
				<tr>
					<td width="200px" align="center" rowspan="3">
						<a href="javascript:fnDetail('${result.GOODS_CODE}');"><img src="<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}" width="200px" height="150px"></a>
					</td>
					<td width="800px" align="center" title="${result.GOODS_NM}">
						${fn:substring(result.GOODS_NM, 0, 15)}..
					</td>
				</tr>
				<tr>
					<td width="800px" align="center" title="${result.SCHDUL_LIST}">
						${result.SCHDUL_LIST}
					</td>
				</tr>
				<tr>
					<td width="800px" align="center" title="${result.CL_LIST}">
						${result.CL_LIST}
					</td>
				</tr>
				</table>
			</td>
	<c:if test="${status.count%2 == 0}">
		</tr>
		<tr>
	</c:if>	
		</c:forEach>
		</tr>
	</table>
	</form>
	
</div>