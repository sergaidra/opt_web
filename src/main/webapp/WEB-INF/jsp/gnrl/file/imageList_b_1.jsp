<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>이미지보기</title>
<!-- fotorama.css & fotorama.js. -->
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jquery.fotorama.css'/>" />
<style type="text/css">
body{
	margin:0 auto; 
	background:#F0F0F0;
	-webkit-transform: translateZ(0); 
	-ms-transform: translateZ(0); 
	transform: translateZ(0); 
}

.fotorama__arr,
.fotorama__fullscreen-icon {
    display: block !important;
    opacity: 1 !important;
    -webkit-transform: translate3d(0, 0, 0) !important;
    -ms-transform: translate3d(0, 0, 0) !important;
    transform: translate3d(0, 0, 0) !important;
}

.fotorama__arr--disabled {
    opacity: .1 !important;
}

.fotorama__wrap--video .fotorama__arr,
.fotorama__wrap--video .fotorama__fullscreen-icon {
    display: none !important;
}
</style>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.fotorama.js'/>"></script>
</head>
<body>
<%-- <div class="fotorama" 
	data-width="100%"
	data-height="100%"
	data-fit="cover"
	data-autoplay="true"
	data-nav="false"
	data-arrows="true"
	data-click="true"
	data-swipe="false"
	data-loop="true">
<c:forEach var="list" items="${result}" varStatus="status">
<img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN}" width="824"" height="428">
</c:forEach>
</div> --%>

<div align="center">
<div class="fotorama" 
	data-width="824"
	data-height="428"
	data-fit="cover"
	data-autoplay="true"
	data-nav="false"
	data-arrows="true"
	data-click="true"
	data-swipe="false"
	data-loop="true"
	>
	<img src="/images/photos/01.jpg">
	<img src="/images/photos/02.jpg">
	<img src="/images/photos/03.jpg">
	<img src="/images/photos/04.jpg">
	<img src="/images/photos/05.jpg">
	<img src="/images/photos/06.jpg">
</div>
</div>
</body>
</html>
