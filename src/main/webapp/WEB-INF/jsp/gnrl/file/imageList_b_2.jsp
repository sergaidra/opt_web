<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>이미지보기</title>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.swipe.js'/>"></script>
</head>
<body>
	<div id="sliderWrap">
		<ul>
			<li><img src="/images/photos/01.jpg" alt="" /></li>
			<li><img src="/images/photos/02.jpg" alt="" /></li>
			<li><img src="/images/photos/03.jpg" alt="" /></li>
			<li><img src="/images/photos/04.jpg" alt="" /></li>
			<li><img src="/images/photos/05.jpg" alt="" /></li>
			<li><img src="/images/photos/06.jpg" alt="" /></li>
		</ul>
	</div>
	<div class="arrowBox">
		<a href="#">다음</a>
		<a href="#">이전</a>
	</div>
	<script>
		$(function(){
			var sliderWrap=document.getElementById('sliderWrap');
			sliderObj=new Swipe(sliderWrap);
			$('.arrowBox a').eq(0).click(function(){
				sliderObj.next();
			})
			$('.arrowBox a').eq(1).click(function(){
				sliderObj.prev();
			})
		})
	</script>
</body>
</html>



<!--
data-width="100%"
data-height="100%"
data-fit="cover"
-->