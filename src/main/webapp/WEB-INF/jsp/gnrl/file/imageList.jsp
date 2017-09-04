<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/reset.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/viSimpleSlider.css'/>" />
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.easing.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/vinyli.viSimpleSlider.js'/>"></script>
<!--[if lt IE 9]>
	<script src="src="<c:url value='/js/html5.js'/>""></script>
<![endif]-->
<!--[if lt IE 8]>
	<script src="src="<c:url value='/js/respond.min.js'/>""></script>
<![endif]-->
</head>
<body>
<div id="divPhotoSlider">
	<ul>
	<c:forEach var="list" items="${result}" varStatus="status">
	    <li>
			<img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN}" width="100%" height="100%">
		</li>
	</c:forEach>
	</ul>
	<a href="#" class="arrowBtn prev"></a>
	<a href="#" class="arrowBtn next"></a>
</div>
<script>
$('#divPhotoSlider').viSimpleSlider({
      ease : 'easeInOutQuart',
      autoPlay : true,
      indicate : true,
      autoTime : 3000,
      speed : 400 
});

function fnSelPhoto(selIdx) {
	$('.indicate a')[selIdx].click();
}
</script>
</body>
</html>