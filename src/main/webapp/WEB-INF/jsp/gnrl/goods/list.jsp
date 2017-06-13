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
		<c:forEach var="result" items="${tourList}" varStatus="status">
			<c:if test="${status.count > 1}"> - </c:if>
			${result.CL_NM}
		</c:forEach>
	</div>
	<form id="frmList" name="frmList" action="<c:url value='/goods/detail/'/>">
	<input type="hidden" id="hidPage" name="hidPage">
	<input type="hidden" id="hidGoodsCode" name="hidGoodsCode">
	<table width="1024px" border="1" cellspacing="0" cellpadding="0" height="100%" style="border-collapse:collapse; border:1px gray solid;">
		<tr>
		<c:forEach var="result" items="${goodsList}" varStatus="status">
			<td align="center">	
				<table cellspacing="0" cellpadding="0">
				<tr>
					<td width="40%" align="center" rowspan="3">
						<a href="javascript:fnDetail('${result.GOODS_CODE}');"><img src="<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}&file_sn=1" width="200"></a>
					</td>
					<td align="center" title="${result.GOODS_NM}">
						${fn:substring(result.GOODS_NM, 0, 20)}..
					</td>
				</tr>
				<tr>
					<td align="center" title="${result.GOODS_NM}">
						${fn:substring(result.GOODS_NM, 0, 20)}..
					</td>
				</tr>
				<tr>
					<td align="center" title="${result.GOODS_NM}">
						${fn:substring(result.GOODS_NM, 0, 20)}..
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