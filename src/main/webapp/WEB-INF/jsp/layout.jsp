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
	String author_cl = SimpleUtils.default_set((String)session.getAttribute("author_cl"));
	String result = SimpleUtils.default_set(request.getParameter("result"));
%>
<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>OnePassTour</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/form.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jquery-ui.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jquery.comiseo.daterangepicker.css'/>" />
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.blockUI.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$("#btn_my_reservation").click(function(){
			$("#btn_my_reservation").attr("style", 'visibility:hidden');
			$("#btn_show_my_reservation").attr("style", 'visibility:visible').attr("style", 'display:block');
			$("#show_area_my_reservation").attr("style", 'visibility:visible').attr("style", 'display:block');
			$(".show_area_my_res").attr("style", 'display:block');
		});

		$("#btn_show_my_reservation").click(function(){
			$("#btn_my_reservation").attr("style", 'visibility:visible');
			$("#btn_show_my_reservation").attr("style", 'visibility:hidden').attr("style", 'display:none');
			$("#show_area_my_reservation").attr("style", 'visibility:hidden').attr("style", 'display:none');
			$(".show_area_my_res").attr("style", 'display:none');
		});

		$(".tab_01").click(function(){
			$(".area_airset_01").show();
			$(".area_hotelset_01").hide();
			$(".area_schedulset_01").hide();
		});

		$(".tab_02").click(function(){
			$(".area_airset_01").hide();
			$(".area_hotelset_01").show();
			$(".area_schedulset_01").hide();
		});

		$(".tab_03").click(function(){
			$(".area_airset_01").hide();
			$(".area_hotelset_01").hide();
			$(".area_schedulset_01").show();
		});

		$(".login").click(function(){
			go_login();
		});

		$(".logout").click(function(){
			go_logout();
		});

		$(".cart").click(function(){
			go_cartpage();
		});

		$(".regi").click(function(){
			alert('TODO 회원가입 화면');
			//$(location).attr('href', "<c:url value='/cart/list/'/>");
		});
		
		<c:if test="${author_cl == 'A' || author_cl == 'M' }">
		$(".mngr").click(function(){
			$(location).attr('href', "<c:url value='/mngr/'/>");
		});
		</c:if>
	});

</script>
<decorator:head />
</head>
<body>
<!--상단네비게이션 시작-->
<header id="header">
	<div class="area_head">
		<a href="<c:url value='/'/>"><h1>ci</h1></a> 
		<nav id="nav">
			<ul class="nav_left">
				<li><a href="javascript:alert('원패스투어 설명');">원패스투어</a></li>
				<li><a href="<c:url value='/goods/category/'/>">투어상품</a></li>
				<li><a href="javascript:alert('여행후기');">여행후기</a></li>
				<li class="noline"><a href="javascript:alert('고객서비스');">고객서비스</a></li>
			</ul>
			<ul class="nav_right">
			<c:choose>
				<c:when test="${fn:length(esntl_id) > 0}">
					<li class="logout">로그아웃</li>
					<li class="cart">장바구니</li>
				</c:when>
				<c:otherwise>
					<li class="login">로그인</li>
					<li class="regi">회원가입</li>
				</c:otherwise>
			</c:choose>
			<c:if test="${author_cl == 'A' || author_cl == 'M' }">
				<li class="mngr">관리자</li>
			</c:if>
			${user_id}			
			</ul>
		</nav>
	</div>
</header>
<!--상단네비게이션 끝-->

<!--하단 시작-->
<!-- 메인 화면 -->
<c:if test="${main_yn eq 'Y' }"><div id="container" style="height: 894px; background: #fff;"></c:if>
<c:if test="${main_yn ne 'Y' }"><div id="container"></c:if>
<!-- 상품상세설명 화면 -->
<c:if test="${goods_detail_yn eq 'Y'}"><div class="container2"></c:if>
<c:if test="${cart_list_yn eq 'Y'}"><div class="container2"></c:if>
<c:if test="${goods_list_yn eq 'Y'}"><div class="container3"></c:if>

<!-- 내용 시작 -->
<div id="divLayoutBody">
<decorator:body />
</div>
<!-- 내용 끝 -->

<script type="text/javascript">
//장바구니에 담은 상품 목록 (우측 일정표 조회)
var fnCartList = function() {
	$.ajax({
		url : "<c:url value='/cart/getAction/'/>",
		dataType : "json",
		type : "POST",
		async : true,
		beforeSend:function(){
			showLoading();
		},
		success : function(json) {
			if(json.result == "0") {
				if(json.cartList.length > 0) {
					/*
					var str = '<table width="220" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid; font-size: 9pt;">'
					$.each(json.cartList, function(key, value){
						str += "<tr>";
						if(value.TOUR_SN == 1) {
							str += "<td width='25%' rowspan='"+ value.TOUR_SN_DESC +"'>" + value.TOUR_DE.substring(0, 4) +"-" + value.TOUR_DE.substring(4, 6) + "-" +value.TOUR_DE.substring(6, 8)+ "<br>(" + value.TOUR_DY + ")</td>";
						}
						str += "<td width='15%'>" + value.BEGIN_TIME.substring(0,2) +":" + value.BEGIN_TIME.substring(2,4)+ "</td>"
						    + '<td align="left" width="60%"><a href="javascript:fnCartDetail('+value.CART_SN+');">' + value.GOODS_NM + "</a></td>"
						    + "</tr>";
					});
					str += "</table>";
					$("#area_schedulset_01").html(str);
					*/

					var str1= '<div class="area_schedulset_01">'+'<p class="schedul_areatit">'
							+ '<span class="schedul_from_tit">일정표</span>'
							+ '</p>'
							+ '<dl id="sch_schedul">';
					$.each(json.cartList, function(key, value){
						str1+='<dt>'+value.CF_TOUR_DE+' '+value.CF_BEGIN_TIME+'</dt>'
							+ '<dd class="blue">'+value.GOODS_NM+'</dd>';
					});
						str1+='</dl>'
							+ '<p class="schedul_bgbottom"></p></div>';
					$("#area_schedulset_01_whole").html(str1);
				}
			} else if(json.result == "-2") {
				//alert("로그인이 필요합니다.");
			} else{
				//alert("작업을 실패하였습니다.");
			}
		},
		complete:function() {
			hideLoading();
		},
		error : function() {
			alert("오류가 발생하였습니다.");
		}
	});
};

// 항공편
var fnFlightInfo = function(){
	$.ajax({
		url : "<c:url value='/cart/getFlightAction/'/>",
		dataType : "json",
		type : "POST",
		async : true,
		beforeSend:function(){
			showLoading();
		},
		success : function(json) {
			if(json.result == "0") {
				var flight = json.flight;
				if(flight) {
					console.log(flight.FLIGHT_SN);
					$('#frmLayout [name="hidFlightSn"]').val(flight.FLIGHT_SN);

					var str1= '<div class="area_airset_01">'+'<p class="air_areatit">'
							+ '<span class="air_from_tit">출발</span><a href="javascript:fnFlightPopup();"><span class="setting"></span></a>'
							+ '</p>'
							+ '<dl id="sch_air">'
							+ '<dt>출국일시</dt>'
							+ '<dd class="blue">'+flight.DTRMC_START_DT_2+'</dd>'
							+ '<dt>도착일시</dt>'
							+ '<dd class="blue">'+flight.DTRMC_ARVL_DT_2+'</dd>'
							+ '<dt>출발지</dt>'
							+ '<dd>'+flight.DTRMC_START_CTY+'</dd>'
							+ '<dt>도착지</dt>'
							+ '<dd class="pink">'+flight.DTRMC_ARVL_CTY+'</dd>'
							+ '<dt>편명</dt>'
							+ '<dd>'+flight.DTRMC_FLIGHT+'</dd>'
							+ '</dl>'
							+ '<p class="air_bgbottom"></p></div>';
					$("#area_airset_01_whole").html(str1);

					var str2= '<div class="area_airset_01">'+'<p class="air_areatit">'
							+ '<span class="air_to_tit">도착</span>'
							+ '</p>'
							+ '<dl id="sch_air">'
							+ '<dt>출국일시</dt>'
							+ '<dd class="blue">'+flight.HMCMG_START_DT_2+'</dd>'
							+ '<dt>도착일시</dt>'
							+ '<dd class="blue">'+flight.HMCMG_ARVL_DT_2+'</dd>'
							+ '<dt>출발지</dt>'
							+ '<dd>'+flight.HMCMG_START_CTY+'</dd>'
							+ '<dt>도착지</dt>'
							+ '<dd class="pink">'+flight.HMCMG_ARVL_CTY+'</dd>'
							+ '<dt>편명</dt>'
							+ '<dd>'+flight.HMCMG_FLIGHT+'</dd>'
							+ '</dl>'
							+ '<p class="air_bgbottom"></p></div>';
					$("#area_airset_01_whole").append(str2);
				} else {
					var str1= '<div class="area_airset_01">'+'<p class="air_areatit">'
					        + '<span class="air_from_tit">출발</span><a href="javascript:fnFlightPopup();"><span class="setting"></span></a>'	
							+ '</p>'		
							+ '<p class="air_bgbottom"></p></div>';
					$("#area_airset_01_whole").html(str1);
					var str2= '<div class="area_airset_01">'+'<p class="air_areatit">'
							+ '<span class="air_to_tit">도착</span>'
							+ '</p>'
							+ '<p class="air_bgbottom"></p></div>';
					$("#area_airset_01_whole").append(str2);					
				}
			} else if(json.result == "-2") {
				//alert("로그인이 필요합니다.");
			} else{
				alert("작업을 실패하였습니다.");
			}
		},
		complete:function() {
			hideLoading();
		},
		error : function() {
			alert("오류가 발생하였습니다.");
		}
	});
};

$(document).ready(function(){
	fnCartList();
	fnFlightInfo();
});

function fnGoCartDetail(str) {
	var form = $("form[id=frmLayout]");
	$("input:hidden[id=hidCartSn]").val(str);
	form.attr({"method":"post","action":"<c:url value='/cart/detail/'/>"});	
	form.submit();
}

function fnGoGoodsDetail(goods_code) {
	var form = $("form[id=frmLayout]");
	$("input:hidden[id=hidGoodsCode]").val(goods_code);
	form.attr({"method":"post","action":"<c:url value='/goods/detail/'/>"});
	form.submit();
}

function fnFlightPopup() {
	var sMsg = "항공편을 입력(수정)하시겠습니까?";
	var sUrl = "<c:url value='/cart/flightPopup/'/>";
	if(confirm(sMsg)){
		fnOpenPopup(sUrl, "winFightPopup", 750, 550);
	}
}
</script>

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
					<div id="area_airset_01_whole"></div>
					<!--항공예약 끝-->
					<!--호텔예약시작-->
					<div id="area_hotelset_01_whole">
					<div class="area_hotelset_01">
						<p class="hotel_areatit">
							<span class="hotel_tit">모멘틱 리조트(샘플)</span>
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
					</div>
					<!--호텔예약 끝-->
					<div id="area_schedulset_01_whole"></div>
				</div>
			</div>
			<!--예약정보 메뉴영역 끝-->
		</div>
	</div>
	<!--우측예약정보 끝-->

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

<c:if test="${goods_detail_yn eq 'Y'}"></div></c:if>
<c:if test="${cart_list_yn eq 'Y'}"></div></c:if>
<c:if test="${goods_list_yn eq 'Y'}"></div></c:if>

</div>
<!--하단 끝-->

<form name="frmLayout" id="frmLayout" method="post">
	<input type="hidden" id="hidGoodsCode" name="hidGoodsCode">
	<input type="hidden" id="hidCartSn" name="hidCartSn">
	<input type="hidden" id="hidFlightSn" name="hidFlightSn">
</form>
<input type="hidden" id="hidLayout" name="hidLayout" value="Y">
</body>
</html>