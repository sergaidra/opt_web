<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<script type="text/javascript">	
	function fnPage() {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidPage]").val(1);
		form.attr({"method":"post","action":"<c:url value='/cart/list/'/>"});
		form.submit();
	}
	
	function fnDetail(cart_sn) {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidCartSn]").val(cart_sn);
		form.attr({"method":"post","action":"<c:url value='/cart/detail/'/>"});
		form.submit();
	}
	
	function fnLinkPage(page){
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidPage]").val(page);
		form.attr({"method":"post","action":"<c:url value='/cart/list/'/>"});
		form.submit();
	}
</script>
<div align="center">
	<form id="frmList" name="frmList" action="<c:url value='/cart/detail/'/>">
	<input type="hidden" id="hidPage" name="hidPage" value="${hidPage}">
	<input type="hidden" id="hidCartSn" name="hidCartSn">
	<table width="1024px" border="1" cellspacing="0" cellpadding="0" height="100%" style="border-collapse:collapse; border:1px gray solid;">
		<tr>
		<c:if test="${fn:length(list) == 0}">
			<td height="100px" align="center">조회된 결과가 없습니다.</td>
		</c:if>
		<c:forEach var="result" items="${list}" varStatus="status">
			<td align="center">	
				<table cellspacing="0" cellpadding="0">
				<tr>		
					<td width="200px" align="center" rowspan="3">
						<a href="javascript:fnDetail('${result.CART_SN}');"><img src="<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}" width="200px" height="150px"></a>
					</td>
					<td width="800px" align="center" title="${result.GOODS_NM}">
						${fn:substring(result.GOODS_NM, 0, 15)}..
					</td>
				</tr>
				<tr>
					<td width="800px" align="center" title="${result.NMPR_CND}">
						${result.NMPR_CND} : ₩ ${result.SETUP_AMOUNT}
					</td>
				</tr>
				<tr>
					<td width="800px" align="center">
						예정일 : ${fn:substring(result.TOUR_DE,0,4)}. ${fn:substring(result.TOUR_DE,4,6)}. ${fn:substring(result.TOUR_DE,6,8)}
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

<div style="height:100px;" align="center">
	<p style="vertical-align:middle;">
		<ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fnLinkPage"/>
	</p>
</div>