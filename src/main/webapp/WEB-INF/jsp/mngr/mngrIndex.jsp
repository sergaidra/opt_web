<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>OPT 관리자 메뉴</title>
</head>
<body>
<ul>
	<li><a href="<c:url value='/mngr/tourCmpnyManage/'/>" target="_self">여행사관리</a></li>
	<li><a href="<c:url value='/mngr/tourCmpnyRegist/'/>" target="_self">여행사등록</a></li>
	<li><a href="<c:url value='/mngr/tourClManage/'/>" target="_self">여행분류관리</a></li>
	<li><a href="<c:url value='/mngr/tourClRegist/'/>" target="_self">여행분류등록</a></li>
	<li><a href="<c:url value='/mngr/mngrManage/'/>" target="_self">가이드관리</a></li>
	<li><a href="<c:url value='/mngr/mngrRegist/'/>" target="_self">가이드등록</a></li>
</ul>
</body>
</html>