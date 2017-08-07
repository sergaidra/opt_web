<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>일정표</title>
<style type="text/css">
</style>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.blockUI.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/calendar.js'/>"></script>
<script type="text/javascript">
	function fnFlight() {
		var sMsg = "항공편을 입력하시겠습니까?";  
		
		if(parseInt("${fn:length(flight)}") > 0) {
			sMsg = "항공편을 수정하시겠습니까?";
		}

		if(confirm(sMsg)){
			fnOpenPopup("<c:url value='/cart/flightPopup/'/>", "winFightPopup", 620, 430);
		}
	}

	function fnStayng() {
		if(confirm("숙박 시설을 검색하시겠습니까?")) {
			window.opener.fnSearchGoods();
			window.close();
		}
	}

</script>
</head>

<body>
<table width="600" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr height="50" width="100%" align="center">
		<td onclick="fnFlight()">항공편</td>
	</tr>
</table>
<table width="600">
	<tr height="5" width="100%" align="center">
		<td></td>
	</tr>
</table>
<table width="600" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr height="50" width="100%" align="center">
		<td onclick="fnStayng()">숙박 호텔</td>
	</tr>
</table>
<table width="600">
	<tr height="5" width="100%" align="center">
		<td></td>
	</tr>
</table>
<table width="600" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr height="50" width="100%" align="center">
		<td>일정표</td>
	</tr>
</table>
<c:if test="${fn:length(flight) > 0}">
<table width="600">
	<tr height="5" width="100%" align="center">
		<td></td>
	</tr>
</table>
<table width="600" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>	
		<td width="15%" align="center" <c:choose><c:when test="${flight.DTRMC_START_DE eq flight.DTRMC_ARVL_DE}">rowspan="2"</c:when><c:otherwise/></c:choose>>
			${flight.DTRMC_START_DE}<br>(${flight.DTRMC_START_DY})
		</td>		
		<td width="8%" align="center">
			출발
		</td>
		<td width="12%" align="center">
			${flight.DTRMC_START_HH}:${flight.DTRMC_START_MI}
		</td>
		<td width="65%">
			${flight.DTRMC_FLIGHT} ${flight.DTRMC_START_CTY}
		</td>
	</tr>
	<tr>
	<c:choose><c:when test="${flight.DTRMC_START_DE ne flight.DTRMC_ARVL_DE}">	
		<td width="15%" align="center">
			${flight.DTRMC_ARVL_DE}<br>(${flight.DTRMC_ARVL_DY})
		</td>		
	</c:when><c:otherwise/></c:choose>
		<td width="8%" align="center">
			도착
		</td>	
		<td width="12%" align="center">
			${flight.DTRMC_ARVL_HH}:${flight.DTRMC_ARVL_MI}
		</td>
		<td width="65%">
			${flight.DTRMC_ARVL_CTY}
		</td>
	</tr>	
</table>	
</table>
</c:if>
<table width="600">
	<tr height="5" width="100%" align="center">
		<td></td>
	</tr>
</table>
<table width="600" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
<c:forEach var="list" items="${cartList}" varStatus="status">
	<tr>	
	<c:if test="${list.TOUR_SN eq 1}">
		<td width="15%" rowspan="${list.TOUR_SN_DESC}" align="center">
			${fn:substring(list.TOUR_DE,0,4)}-${fn:substring(list.TOUR_DE,4,6)}-${fn:substring(list.TOUR_DE,6,8)}<br>(${list.TOUR_DY})
		</td>		
	</c:if>
		<td width="20%" align="center">
			${fn:substring(list.BEGIN_TIME,0,2)}:${fn:substring(list.BEGIN_TIME,2,4)} ~ ${fn:substring(list.END_TIME,0,2)}:${fn:substring(list.END_TIME,2,4)}
		</td>
		<td width="65%">
			${list.GOODS_NM}
		</td>
	</tr>
</c:forEach>
</table>
<c:if test="${fn:length(flight) > 0}">
<table width="600">
	<tr height="5" width="100%" align="center">
		<td></td>
	</tr>
</table>
<table width="600" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>	
		<td width="15%" align="center" <c:choose><c:when test="${flight.HMCMG_START_DE eq flight.HMCMG_ARVL_DE}">rowspan="2"</c:when><c:otherwise/></c:choose>>
			${flight.HMCMG_START_DE}<br>(${flight.HMCMG_START_DY})
		</td>		
		<td width="8%" align="center">
			출발
		</td>
		<td width="12%" align="center">
			${flight.HMCMG_START_HH}:${flight.HMCMG_START_MI}
		</td>
		<td width="65%">
			${flight.HMCMG_FLIGHT} ${flight.HMCMG_START_CTY}
		</td>
	</tr>
	<tr>
	<c:choose><c:when test="${flight.HMCMG_START_DE ne flight.HMCMG_ARVL_DE}">	
		<td width="15%" align="center">
			${flight.HMCMG_ARVL_DE}<br>(${flight.HMCMG_ARVL_DY})
		</td>		
	</c:when><c:otherwise/></c:choose>
		<td width="8%" align="center">
			도착
		</td>
		<td width="12%" align="center">
			${flight.HMCMG_ARVL_HH}:${flight.HMCMG_ARVL_MI}
		</td>
		<td width="65%">
			${flight.HMCMG_ARVL_CTY}
		</td>
	</tr>	
</table>
</c:if>
</body>
</html>