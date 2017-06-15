<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">
	function fnSearch() {
		var form = $("form[id=frmCategory]");
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}

	function fnCheck(cl_code) {
		var obj = $("input[type=checkbox][value*="+cl_code+"]")
		if(obj.is(":checked")){
			obj.prop('checked', false);	
		}else{
			obj.prop('checked', true);	
		}
	}
</script>
<div align="center">
	<div style="height:30px;" align="center">여러분이 원하는 모든것을 선택하세요. <a href="javascript:fnSearch();">검색</a></div>
	<form id="frmCategory" name="frmCategory" action="<c:url value='/goods/list/'/>">
	<table width="1024px" border="1" cellspacing="0" cellpadding="0" height="100%" style="border-collapse:collapse; border:1px gray solid;">
		<tr>
		<c:forEach var="result" items="${tourList}" varStatus="status">
			<td align="center">	
				<table cellspacing="0" cellpadding="0">
				<tr>
					<td align="center">
						<a href="javascript:fnCheck('${result.CL_CODE}');"><img src="<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}&file_sn=1" width="300" height="225px"></a>
					</td>
				</tr>
				<tr>
					<td align="center" title="${result.CL_NM}">
						<input type="checkbox" id="chkCategory" name="chkCategory" value="${result.CL_CODE}">
						${fn:substring(result.CL_NM, 0, 20)}..
					</td>
				</tr>
				</table>
			</td>
	<c:if test="${status.count%3 == 0}">
		</tr>
		<tr>
	</c:if>	
		</c:forEach>
		</tr>
	</table>
	</form>
	
</div>