<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="kr.co.siione.dist.utils.SimpleUtils" %>
<%@ page import="kr.co.siione.utl.LoginManager" %>
<%
	LoginManager loginManager = LoginManager.getInstance();
	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
	String user_id = SimpleUtils.default_set((String)session.getAttribute("user_id"));
	String user_nm = SimpleUtils.default_set((String)session.getAttribute("user_nm"));
	String result = SimpleUtils.default_set(request.getParameter("result"));
%>
<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>OnePassTour</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/form.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css'/>" />
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.blockUI.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$("#btn_my_reservation").click(function(){
			$("#btn_my_reservation").attr("style", 'visibility:hidden');
			$("#btn_show_my_reservation").attr("style", 'visibility:visible');				
			$("#show_area_my_reservation").attr("style", 'visibility:visible');				
		});
		
		$("#btn_show_my_reservation").click(function(){
			$("#btn_my_reservation").attr("style", 'visibility:visible');
			$("#btn_show_my_reservation").attr("style", 'visibility:hidden');				
			$("#show_area_my_reservation").attr("style", 'visibility:hidden');			
		});
		
		$(".tab_01").click(function(){
			$("#area_airset_01").show();
			$("#area_hotelset_01").hide();
		});
		
		$(".tab_02").click(function(){
			$("#area_airset_01").hide();
			$("#area_hotelset_01").show();
		});
		
		$(".tab_03").click(function(){
			$("#area_airset_01").hide();
			$("#area_hotelset_01").hide();
		});
	});
	
</script>
<decorator:head />
</head>
<body style="overflow: hidden;">
<!--상단네비게이션 시작-->
<header id="header">
	<div class="area_head">
		<h1>ci</h1>
		<nav id="nav">
			<ul class="nav_left">
				<li><a href="#">원패스투어</a></li>
				<li><a href="<c:url value='/goods/category/'/>">투어상품</a></li>
				<li><a href="#">여행후기</a></li>
				<li class="noline"><a href="#">고객서비스</a></li>
			</ul>
			<ul class="nav_right">
			<c:choose>
				<c:when test="${fn:length(esntl_id) > 0}">
					<li class="login"><a href="<c:url value='/member/logoutAction/'/>">로그아웃</a></li>
					<li class="cart"><a href="#">장바구니</a></li>
				</c:when>
				<c:otherwise>
					<li class="login"><a href="<c:url value='/member/login/'/>">로그인</a></li>
					<li class="regi"><a href="#">회원가입</a></li>
				</c:otherwise>
			</c:choose>
			</ul>
		</nav>
	</div>
</header>
<!--상단네비게이션 끝-->

<!--하단 시작-->
	<div id="container">
	  	<div class="container2">	
	
		<!-- 내용 시작 -->
		
			<decorator:body />
			
		<!-- 내용 끝 -->
		</div>
		<div id="footer">
		<div class="area_footer">
			<ul class="f_nav">
				<li class="m_first">개인정보취급방침</li>
				<li>이용약관</li>
				<li>여행자약관</li>
				<li class="m_last">about onepasstour</li>
			</ul>
			<span class="txt_copyright">Copyright 2017 SⅡONE.CO.LTD. All Right Resesrved.</span>
		</div>
	</div>
	</div>	
	

	<!--우측예약정보 시작-->
	<p id="btn_my_reservation"></p>
	<p id="btn_show_my_reservation"></p>
	<div id="show_area_my_reservation">
		<div class="show_area_my_res">
			<div class="top_res">
				<span><a href='#' class="btn_revert">초기화</a></span>
			</div>
			<!--예약정보 메뉴영역 시작-->
			<div id="area_nav_myr">
				<div id="set_01">
					<p class="tab_01">항공편</p>
					<p class="tab_02">호텔</p>
					<p class="tab_03">일정표</p>
					<!--항공예약시작-->
					<div id="area_airset_01">
						<p class="air_areatit">
							<span class="air_from_tit">출발</span> <span class="setting"></span>
						</p>
						<dl id="sch_air">
							<dt>출국일</dt>
							<dd class="blue">09월 22일(목) 11: 40</dd>
							<dt>도착일</dt>
							<dd class="blue">09월 22일(목) 11: 40</dd>
							<dt>출발지</dt>
							<dd>인천</dd>
							<dt>도착지</dt>
							<dd class="pink">세부</dd>
							<dt>직항/경유</dt>
							<dd>직항</dd>
							<dt>편명</dt>
							<dd>진에어 LJ0215편</dd>
							<dt>예약번호</dt>
							<dd>8LQTRP</dd>
						</dl>
						<p class="air_bgbottom"></p>
					</div>
					<div id="area_airset_01">
						<p class="air_areatit">
							<span class="air_to_tit">도착</span>
						</p>
						<dl id="sch_air">
							<dt>출국일</dt>
							<dd class="blue">09월 22일(목) 11: 40</dd>
							<dt>도착일</dt>
							<dd class="blue">09월 22일(목) 11: 40</dd>
							<dt>출발지</dt>
							<dd>인천</dd>
							<dt>도착지</dt>
							<dd class="pink">세부</dd>
							<dt>직항/경유</dt>
							<dd>직항</dd>
							<dt>편명</dt>
							<dd>진에어 LJ0215편</dd>
							<dt>예약번호</dt>
							<dd>8LQTRP</dd>
						</dl>
						<p class="air_bgbottom"></p>
					</div>
					<!--항공예약 끝-->
					<!--호텔예약시작-->
					<div id="area_hotelset_01">
						<p class="hotel_areatit">
							<span class="hotel_tit">모멘틱 리조트</span> <span class="setting"></span>
						</p>
						<dl id="sch_hotel">
							<dt>체크인</dt>
							<dd>09월 22일(목) 11: 40</dd>
							<dt>체크아웃</dt>
							<dd>09월 22일(목) 11: 40</dd>
							<dt>성인</dt>
							<dd>1명</dd>
							<dt>어린이</dt>
							<dd>0명</dd>
							<dt>유아</dt>
							<dd>0명</dd>

						</dl>
						<p class="hotel_bgbottom"></p>
					</div>
					<!--호텔예약 끝-->
				</div>
			</div>
			<!--예약정보 메뉴영역 끝-->
		</div>
	</div>
	<!--우측예약정보 끝-->	
	
	

<!--하단 끝-->

<form name="frmBannerCategory" id="frmBannerCategory" method="post" target="divLayoutBody" action="<c:url value='/goods/list/'/>">
	<input type="hidden" id="hidStayngFcltyAt" name="hidStayngFcltyAt" value="Y">
</form>
<form name="frmCartDetail" id="frmCartDetail" method="post" action="<c:url value='/cart/detail/'/>">
	<input type="hidden" id="hidCartSn" name="hidCartSn">
</form>
<input type="hidden" id="hidLayout" name="hidLayout" value="Y">	
</body>
</html>