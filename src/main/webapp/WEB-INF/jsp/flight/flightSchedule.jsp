<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>항공정보</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jquery-ui.css'/>" />
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione.js'/>"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#schDate").click(function(){
		fnCalendarPopup('schDate', '2017-09-08', null);	
	});
});
</script>
</head>
<body>

<form name="frmSch" id="frmSch" method="post" action="/flight/KoreaFlightInfo/">

검색일자 : <input type="input" name="schDate" id="schDate" readonly onfocus="this.blur()"> <br>

출발도시코드 schDeptCityCode : <input type="input" name="schDeptCityCode" id="schDeptCityCode" value="PUS"> <br>
도착도시코드 schArrvCityCode : <input type="input" name="schArrvCityCode" id="schArrvCityCode" value="CEB"> <br>


<input type="button" value="검색" onclick="frmSch.submit();"> <br>

</form>

<table border='1'> 	
 	<tr>
		<td>No</td>
		<td>기준공항</td>
		<td>운항구간</td>
		<td>출/입국코드</td>
		<td>항공편명</td>
		<td>계획시간</td>
		<td>일요일</td>
		<td>월요일</td>
		<td>화요일</td>
		<td>수요일</td>
		<td>목요일</td>
		<td>금요일</td>
		<td>토요일</td>
		<td>시작일자</td>
		<td>종료일자</td>
 	</tr>
 	<c:forEach var="flight" items="${flightApiData}" varStatus="status">
 	<tr>
		<td><c:out value='${status.count}'/></td>
		<td><c:out value='${flight.airport}'/></td>
		<td><c:out value='${flight.city}'/></td>
		<td><c:out value='${flight.internationalIoType}'/></td>
		<td><c:out value='${flight.internationalNum}'/></td>
		<td><c:out value='${flight.internationalTime}'/></td>
		<td><c:out value='${flight.internationalSun}'/></td>
		<td><c:out value='${flight.internationalMon}'/></td>
		<td><c:out value='${flight.internationalTue}'/></td>
		<td><c:out value='${flight.internationalWed}'/></td>
		<td><c:out value='${flight.internationalThu}'/></td>
		<td><c:out value='${flight.internationalFri}'/></td>
		<td><c:out value='${flight.internationalSat}'/></td>
		<td><c:out value='${flight.internationalStdate}'/></td>
		<td><c:out value='${flight.internationalEddate}'/></td>
 	</tr>		
	</c:forEach>
</table>	

msg : ${msg}

</body>
</html>
