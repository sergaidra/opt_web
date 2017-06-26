<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>관리자관리</title>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$("#btn_reg").click(function(){
			$(location).attr("href", "<c:url value='../mngrRegist/'/>");
		});
		
		$("#btn_sch").click(function(){
			fnPage();
		});
	});

	function f_mod(str) {
		$('#ESNTL_ID').val(str);
		$("#form1").attr("action", "<c:url value='../mngrModify/'/>").submit();
	}
	
	function fnPage() {
		$("#hidPage").val(1);
		$("#form1").attr("action", "<c:url value='../mngrManage/'/>").submit();
	}
	
	function fnLinkPage(page){
		$("#hidPage").val(page);
		$("#form1").attr("action", "<c:url value='../mngrManage/'/>").submit();
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
◆ 관리자관리
<br>
<br>
<form id="form1" method="post" action="<c:url value='../tourCmpnyModify/'/>">
<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" name="ESNTL_ID" id="ESNTL_ID">
<table cellpadding="5" cellspacing="0" border="0" align="left" >
	<tr>
		<td>*이름:</td>
		<td><input type="text" name="SCH_MNGR_NM" id="SCH_MNGR_NM" size="20" value="<c:out value='${param.SCH_MNGR_NM}'/>"></td>
		<td>*권한구분:</td>
		<td><input type="radio" name="SCH_AUTHOR_CL" value=""  <c:if test="${param.SCH_AUTHOR_CL!='A' && param.SCH_AUTHOR_CL!='G'}">checked="checked"</c:if>>전체
			<input type="radio" name="SCH_AUTHOR_CL" value="A" <c:if test="${param.SCH_AUTHOR_CL=='A'}">checked="checked"</c:if>>관리자
			<input type="radio" name="SCH_AUTHOR_CL" value="G" <c:if test="${param.SCH_AUTHOR_CL=='G'}">checked="checked"</c:if>>가이드</td>
		<td>*승인여부:</td>
		<td><input type="radio" name="SCH_CONFM_AT" value=""  <c:if test="${param.SCH_CONFM_AT!='Y' && param.SCH_CONFM_AT!='N'}">checked="checked"</c:if>>전체
			<input type="radio" name="SCH_CONFM_AT" value="Y" <c:if test="${param.SCH_CONFM_AT=='Y'}">checked="checked"</c:if>>승인
			<input type="radio" name="SCH_CONFM_AT" value="N" <c:if test="${param.SCH_CONFM_AT=='N'}">checked="checked"</c:if>>미승인</td>	
		<td><input type="button" id="btn_sch" value="검색">
			<input type="button" id="btn_reg" value="등록"></td>
	</tr>	
</table>
<br>
<br>
<br>
<table width="1024" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
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
	<c:if test="${fn:length(mngrList) == 0}">	
	<tr>
		<td height="25px" colspan="8" align="center">조회된 결과가 없습니다.</td>
	</tr>
	</c:if>	
	<c:forEach var="mngr" items="${mngrList}" varStatus="status">
	<tr>
		<td>
			<c:out value='${status.count}'/>(<c:out value='${mngr.RN}'/>)
		</td>
		<td ondblclick="javascript:f_mod('${mngr.ESNTL_ID}')">
			<c:out value='${mngr.MNGR_ID}'/>
		</td>
		<td>
			<c:out value='${mngr.MNGR_NM}'/>
		</td>
		<td>
			<c:out value='${mngr.CMPNY_NM}'/>
		</td>
		<td>
			<c:if test="${mngr.AUTHOR_CL == 'A'}">관리자</c:if>
			<c:if test="${mngr.AUTHOR_CL == 'G'}">가이드</c:if>
		</td>
		<td>
			<c:if test="${mngr.CONFM_AT == 'Y'}">승인</c:if>
			<c:if test="${mngr.CONFM_AT == 'N'}"><font color='red'>미승인</font></c:if>
		</td>
		<td>
			<fmt:parseDate value="${mngr.WRITNG_DE}" pattern="yyyyMMdd" var="writngDe" scope="page"/>
			<fmt:formatDate value="${writngDe}" pattern="yyyy-MM-dd"/>
		</td>
		<td>
			<fmt:parseDate value="${mngr.UPDT_DE}" pattern="yyyyMMdd" var="updtDe" scope="page"/>
			<fmt:formatDate value="${updtDe}" pattern="yyyy-MM-dd"/>		
		</td>
	</tr>
	</c:forEach>
	</tbody>
</table>
</form>
<br>
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