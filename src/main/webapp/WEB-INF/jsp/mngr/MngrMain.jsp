<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>관리자모드</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/extjs/resources/ext-theme-neptune/ext-theme-neptune-all.css' />">
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/extjs/ext-all.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/extjs/ext-theme-neptune.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/mngr/MngrMain.js' />"></script>
</head>
<body>
<div id="north" class="x-hide-display">
	<c:if test="${ssAuthorCl ne ''}"><h1>OnePassTour 관리자화면 (${ssUserNm}${ssAuthorCl})</h1></c:if>
	<c:if test="${ssAuthorCl eq ''}"><h1 title="login"><a href="<c:url value="/mngr/login/"/>">관리자 로그인</a></h1></c:if>
</div>
<div id="center">
</div>	
</body>
</html>
