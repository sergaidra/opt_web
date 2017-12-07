<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>원패스투어</title>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/layout.css' />" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/content.css' />" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/ay_com.css' />" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/btn.css' />" media="all">	
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/bbs.css' />" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css' />" media="all">
	<script type="text/javascript" src="<c:url value='/js/link.js' />"></script>
		
	<script src="<c:url value='/js/jquery-1.10.1.min.js' />"></script>
		
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">
	<!-- 하위메뉴-->
	<link href="<c:url value='/jq/q_menu/css/jquery-accordion-menu.css' />" rel="stylesheet" type="text/css" />
	<link href="<c:url value='/jq/q_menu/css/font-awesome.css' />" rel="stylesheet" type="text/css" />
	<!--<script src="<c:url value='/jq/q_menu/js/jquery-1.11.2.min.js' />" type="text/javascript"></script>-->
	<script src="<c:url value='/jq/q_menu/js/jquery-accordion-menu.js' />" type="text/javascript"></script>
<script type="text/javascript">
jQuery(document).ready(function () {
	jQuery("#jquery-accordion-menu").jqueryAccordionMenu();
	
});

$(function(){	
	//
	$("#demo-list li").click(function(){
		$("#demo-list li.active").removeClass("active")
		$(this).addClass("active");
	})	
})	
</script>
	<!-- //하위메뉴-->
	<!-- Pushy CSS -->
	<link rel="stylesheet" href="<c:url value='/jq/quick/css/pushy.css' />">
	<script src="<c:url value='/jq/quick/js/pushy.js' />"></script>
	<!-- 체크박스,라디오버튼 -->
	<script type="text/javascript" src="<c:url value='/jq/check/source/jquery-labelauty.js' />"></script>
		
	<link rel="stylesheet" href="<c:url value='/jq/check/source/jquery-labelauty.css' />" type="text/css" media="screen" charset="utf-8" />
	<script>
		$(document).ready(function(){
			$(".to-labelauty").labelauty({ minimum_width: "15px" });
			$(".to-labelauty-icon").labelauty({ label: false });
		});
	</script>
	<!-- //체크박스,라디오버튼 -->
	<!-- 달력체크 -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/jq/time/jquery.datetimepicker.css' />"/>
	<!-- //달력체크 -->
	<!-- 팝업 -->
	<link type="text/css" rel="stylesheet" href="<c:url value='/jq/popup/featherlight.min.css' />" />
	<style type="text/css">
		@media all {.lightbox { display: none; }}
		/**** pc ****/
		@media only all and (min-width:769px) {.lightbox2 { display: block; }
											}
		/**** 모바일 ****/
		@media only all and (max-width:768px) {.lightbox2 { display: none; }
											}			
	</style>

	<!-- //팝업 -->

<!--<script type="text/javascript">
		$(document).on("scroll",function(){
			if($(document).scrollTop()>50){ 
				$("header").removeClass("large").addClass("small");
				}
			else{
				$("header").removeClass("small").addClass("large");
				}
			});
			
</script>-->
<script>
$(document).ready(function(){
	  $(".quick_st1").click(function(){
        $(".quick_st1").hide();
		$(".quick_st2").show();
		
    });
    $(".quick_st2").click(function(){
         $(".quick_st1").show();
		$(".quick_st2").hide();
    });
	
});

</script>

<decorator:head />		
</head>

<body>

<c:import url="/include/top.jsp" />

<decorator:body />

<c:import url="/include/bottom.jsp" />

</body>
</html>