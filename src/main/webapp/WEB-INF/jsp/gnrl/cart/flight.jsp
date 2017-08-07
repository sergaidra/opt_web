<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>항공편</title>
<link type="text/css" href="/css/jquery-ui.css" rel="stylesheet" media="screen"/>
<style type="text/css">
	.ui-datepicker-calendar > tbody td.ui-datepicker-week-end:first-child a{color:red;}
	.ui-datepicker-calendar > tbody td.ui-datepicker-week-end:last-child a{color:blue;}
</style>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.blockUI.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione.js'/>"></script>
<script type="text/javascript">
	function fnSaveFlight() {
		
		var form_data = $("form[id=frmSave]").serialize();
		var sUrl = "<c:url value='/cart/addFlightAction/'/>";
	
		if("${flight.FLIGHT_SN}") {
			sUrl = "<c:url value='/cart/modFlightAction/'/>";
		}

		$.ajax({
			url : sUrl,
			dataType : "json",
			type : "POST",
			async : true,
			data : form_data,
			beforeSend:function(){
				showLoading();
			},
			success : function(json) {
				if(json.result == "0") {
					alert("항공편이 저장되었습니다.");
					if(window.opener != null && !window.opener.cloed) {
						if($("#hidLayout", opener.document).val() == 'Y') {
							window.opener.fnFlightInfo();							
						} else {
							window.opener.location.reload();
						}
						window.close();
					}
				} else if(json.result == "-2") {
					alert("로그인이 필요합니다.");
				} else{
					alert("작업을 실패하였습니다.");
				}
			},
			complete:function() {
				hideLoading();
			},
			error : function() {
				alert("오류가 발생하였습니다.");
			}
		});		

	}
	
</script>
</head>
<body>
항공편 입력
<br><br>
<form name="frmSave" id="frmSave" method="post" action="../addFlightAction/">
<input type="hidden" name="hidFlightSn" id="hidFlightSn" value="${flight.FLIGHT_SN}">
<table width="500" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
		<td widht="15%" rowspan="5" align="center">출국</td>
		<td width="25%" align="center">항공편</td>
		<td width="60%">
			<input type="text" id="DTRMC_FLIGHT" name="DTRMC_FLIGHT" size="40" maxlength="50" value="<c:out value="${flight.DTRMC_FLIGHT}"/>" title="출국시 항공편">
		</td>
	</tr>
	<tr>
		<td width="25%" align="center">출발 도시</td>
		<td width="60%">
			<input type="text" id=DTRMC_START_CTY name="DTRMC_START_CTY" size="40" maxlength="50" value="<c:out value="${flight.DTRMC_START_CTY}"/>" title="출발 도시">
		</td>
	</tr>	
	<tr>
		<td width="25%" align="center">출발 일시</td>
		<td width="60%">
			<input type="text" id="DTRMC_START_DE" name="DTRMC_START_DE" size="10" maxlength="10" readonly value="<c:out value="${flight.DTRMC_START_DE}"/>" onfocus="this.blur();" title="출발 일자">
			<input type="button" value="달력" onclick='fnCalendarPopup("DTRMC_START_DE")'>
			<select name="DTRMC_START_HH" id="DTRMC_START_HH" title="출발 시">
				<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.DTRMC_START_HH eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>시</option>
			</c:forEach></select> :
			<select name="DTRMC_START_MI" id="DTRMC_START_MI" title="출발 분">
				<option value="">선택</option><c:forEach var="i" begin="0" end="55" step="5">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.DTRMC_START_MI eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>분</option>
			</c:forEach></select>
		</td>
	</tr>	
	<tr>
		<td align="center">도착 도시</td>
		<td>
			<input type="text" id="DTRMC_ARVL_CTY" name="DTRMC_ARVL_CTY" size="40" maxlength="50" value="<c:out value="${flight.DTRMC_ARVL_CTY}"/>" title="도착 도시">
		</td>
	</tr>	
	<tr>
		<td align="center">도착 일시</td>
		<td>
			<input type="text" id="DTRMC_ARVL_DE" name="DTRMC_ARVL_DE" size="10" maxlength="10" readonly value="<c:out value="${flight.DTRMC_ARVL_DE}"/>" onfocus="this.blur();" title="도착 일자">
			<input type="button" value="달력" onclick='fnCalendarPopup("DTRMC_ARVL_DE")'>
			<select name="DTRMC_ARVL_HH" id="DTRMC_ARVL_HH" title="도착 시">
				<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.DTRMC_ARVL_HH eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>시</option>
			</c:forEach></select> :
			<select name="DTRMC_ARVL_MI" id="DTRMC_ARVL_MI" title="도착 분">
				<option value="">선택</option><c:forEach var="i" begin="0" end="55" step="5">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.DTRMC_ARVL_MI eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>분</option>
			</c:forEach></select>			
		</td>
	</tr>	
	<tr>
		<td widht="15%" rowspan="5" align="center">입국</td>
		<td width="25%" align="center">항공편</td>
		<td width="60%">
			<input type="text" id="HMCMG_FLIGHT" name="HMCMG_FLIGHT" size="40" maxlength="50" value="<c:out value="${flight.HMCMG_FLIGHT}"/>" title="입국시 항공편">
		</td>
	</tr>
	<tr>
		<td width="25%" align="center">출발 도시</td>
		<td width="60%">
			<input type="text" id="HMCMG_START_CTY" name="HMCMG_START_CTY" size="40" maxlength="50" value="<c:out value="${flight.HMCMG_START_CTY}"/>" title="입국시 항공편">
		</td>
	</tr>	
	<tr>
		<td align="center">출발 일시</td>
		<td>
			<input type="text" id="HMCMG_START_DE" name="HMCMG_START_DE" size="10" maxlength="10" readonly value="<c:out value="${flight.HMCMG_START_DE}"/>" onfocus="this.blur();" title="입국시 출발 일자">
			<input type="button" value="달력" onclick='fnCalendarPopup("HMCMG_START_DE")'>
			<select name="HMCMG_START_HH" id="HMCMG_START_HH" title="입국시 출발 시">
				<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.HMCMG_START_HH eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>시</option>
			</c:forEach></select> :
			<select name="HMCMG_START_MI" id="HMCMG_START_MI" title="입국시 출발 분">
				<option value="">선택</option><c:forEach var="i" begin="0" end="55" step="5">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.HMCMG_START_MI eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>분</option>
			</c:forEach></select>
		</td>
	</tr>	
	<tr>
		<td align="center">도착 공항</td>
		<td>
			<input type="text" id="HMCMG_ARVL_CTY" name="HMCMG_ARVL_CTY" size="40" maxlength="50" value="<c:out value="${flight.HMCMG_ARVL_CTY}"/>"  title="입국시 도착 항공 정보">
		</td>
	</tr>		
	<tr>
		<td align="center">도착 일시</td>
		<td>
			<input type="text" id="HMCMG_ARVL_DE" name="HMCMG_ARVL_DE" size="10" maxlength="10" readonly value="<c:out value="${flight.HMCMG_ARVL_DE}"/>"  onfocus="this.blur();" title="입국시 도착 일자">
			<input type="button" value="달력" onclick='fnCalendarPopup("HMCMG_ARVL_DE")'>
			<select name="HMCMG_ARVL_HH" id="HMCMG_ARVL_HH" title="입국시 도착 시">
				<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.HMCMG_ARVL_HH eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>시</option>
			</c:forEach></select> :
			<select name="HMCMG_ARVL_MI" id="HMCMG_ARVL_MI" title="입국시 도착 분">
				<option value="">선택</option><c:forEach var="i" begin="0" end="55" step="5">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.HMCMG_ARVL_MI eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>분</option>
			</c:forEach></select>			
		</td>
	</tr>
</table>
&nbsp;<br>&nbsp;
&nbsp;<br>&nbsp;
<table width="500" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px white solid;">
	<tr align="right">
		<td>
			<input type="button" value="저장" onclick='fnSaveFlight();'>
			<input type="button" value="닫기" onclick='this.close();'>
		</td>
	</tr>
</table>


</form>
</body>
</html>