<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>여객기정보</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
</head>
<body>

<form name="frmSch" id="frmSch" method="post" action="/flight/FlightInfo/">

도착지 공항 코드 airport : <input type="input" name="airport" id="airport" value="CEB"> <br>
항공사 코드 airline : <input type="input" name="airline" id="airline"> <br>

<input type="button" value="검색" onclick="frmSch.submit();"> <br>

</form>

<table border='1'>	
	<ttrh>
		<td>count</td>
		<td>항공사</td>
		<td>항공사</td>
		<td>도착지공항</td>
		<td>도착지공항코드</td>
		<td>체크인카운터</td>
		<td>예정시간</td>
		<td>변경시간</td>
		<td>편명</td>
		<td>탑승구</td>
		<td>현황</td>
	</tr>


 	<c:forEach var="flight" items="${flightApiData}" varStatus="status">
 	<tr>
		<td><c:out value='${status.count}'/></td>
		<td><c:out value='${flight.airline}'/></td>
		<td><c:out value='${flight.airlineCode}'/></td>
		<td><c:out value='${flight.airport}'/></td>
		<td><c:out value='${flight.airportCode}'/></td>
		<td><c:out value='${flight.chkinrange}'/></td>
		<td><c:out value='${flight.scheduleDateTime}'/></td>
		<td><c:out value='${flight.estimatedDateTime}'/></td>
		<td><c:out value='${flight.flightId}'/></td>
		<td><c:out value='${flight.gatenumber}'/></td>
		<td><c:out value='${flight.remark}'/></td>
 	</tr>		
	</c:forEach>
</table>	
</body>
</html>
