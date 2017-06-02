<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>여행사관리</title>
</head>
<body>
여행사관리테스트
	<table border='1'>
		<tr>
			<th>순서</th>
			<th>회사명</th>
			<th>주소</th>
			<th>전화번호</th>
			<th>등록일자</th>
		<tr>
		<c:forEach var="tourCmpnyList" items="${TOUR_CMPNY_LIST}" varStatus="status">
		<tr>
			<td>1</td>
			<td>${tourCmpnyList.CMPNY_NM}</td>
			<td>${tourCmpnyList.ADRES}</td>
			<td>${tourCmpnyList.TELNO}</td>
			<td>${tourCmpnyList.WRITNG_DE2}</td>
		</tr>
		</c:forEach>
	</table>
</body>
</html>