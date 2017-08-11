<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %> 
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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>OnePassTour</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jquery-ui.css'/>"  media="screen"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jquery.comiseo.daterangepicker.css'/>" />
<style type="text/css">
	.layer {display:none; position:fixed; _position:absolute; top:0; left:0; width:100%; height:100%; z-index:100;}
		.layer .bg {position:absolute; top:0; left:0; width:100%; height:100%; background:#000; opacity:.5; filter:alpha(opacity=50);}
		.layer .pop-layer {display:block;}

	.pop-layer {display:none; position: absolute; top: 50%; left: 50%; width: 410px; height:auto;  background-color:#fff; border: 5px solid #3571B5; z-index: 10;}	
	.pop-layer .pop-container {padding: 20px 25px;}
	.pop-layer p.ctxt {color: #666; line-height: 25px;}
	.pop-layer .btn-r {width: 100%; margin:10px 0 20px; padding-top: 10px; border-top: 1px solid #DDD; text-align:right;}

	a.cbtn {display:inline-block; height:25px; padding:0 14px 0; border:1px solid #304a8a; background-color:#3f5a9d; font-size:13px; color:#fff; line-height:25px;}	
	a.cbtn:hover {border: 1px solid #091940; background-color:#1f326a; color:#fff;}
	
	#divFloatingCart {
		position:absolute;
		width:320px;
		top:138px;
		right:0px;
		padding:0;
		margin:0;
		z-index:1000;
		text-align:center;
		float:center;
	}	

	/*float:left;*/
</style>

<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.blockUI.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione.js'/>"></script>
      
<decorator:head />

</head>
<body>

<div style="width:100%;height:100px;" align="center">
	<table style="width:100%;height:100%;" border="0">
		<tr>
			<td align="center">
				<table style="border-collapse: collapse; margin-top: 3px; height:40px;">
					<tr>
						<td width="80px" align="center" style="border: 1px solid #bcbcbc;"><a href="<c:url value='/main/intro/'/>">OPT</a></td>
						<td width="120px" align="center" style="border: 1px solid #bcbcbc;">원패스투어?</td>
						<td width="120px" align="center" style="border: 1px solid #bcbcbc;"><a href="<c:url value='/goods/category/'/>">투어상품</a></td>
						<td width="120px" align="center" style="border: 1px solid #bcbcbc;">여행후기</td>
						<td width="120px" align="center" style="border: 1px solid #bcbcbc;"><a href="<c:url value='/cart/list/'/>">장바구니</a></td>
					</tr>
				</table>
			</td>
			<td align="center">
				<table style="border-collapse: collapse; margin-top: 3px; height:40px;">
					<tr>
<c:choose>
	<c:when test="${fn:length(esntl_id) > 0}">
		<td width="250px" align="center" style="border: 1px solid #bcbcbc;">
			${user_id}(${user_nm}) <a href="javascript:fnTimeout();">로그아웃</a>
		</td>
		<td width="100px" align="center" style="border: 1px solid #bcbcbc;">
			<iframe id="sessionFrame" src="<c:url value='/member/timerIframe/'/>" width="90" height="30" frameborder=0 scrolling="no" ></iframe>
		</td>

<script type="text/javascript">

	function fnTimerStart(){
        layer_open('divWarning');
		//fnTimer_02 호출
		fnTimer_02(30, "divExpireTime","Y");
	}
	
	//타이머 종료
	function fnTimer_02_callback(){
    	fnTimeout();
	}

	function fnTimeout(){
		//로그아웃
	    location.href = "<c:url value='/member/logoutAction/'/>";
	}

	function fnNotEnd(second){
		sessionFrame.fnRestart(second);
        clearTimeout(timerChecker_02);
		$('.layer').fadeOut();
	}

	function layer_open(el){
		var temp = $('#' + el);
		var bg = temp.prev().hasClass('bg');	//dimmed 레이어를 감지하기 위한 boolean 변수

		if(bg){
			$('.layer').fadeIn();	//'bg' 클래스가 존재하면 레이어가 나타나고 배경은 dimmed 된다. 
		}else{
			temp.fadeIn();
		}

		// 화면의 중앙에 레이어를 띄운다.
		if (temp.outerHeight() < $(document).height() ) temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
		else temp.css('top', '0px');
		if (temp.outerWidth() < $(document).width() ) temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
		else temp.css('left', '0px');

		temp.find('a.cbtn').click(function(e){
			if(bg){
				$('.layer').fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다. 
			}else{
				temp.fadeOut();
			}
			e.preventDefault();
		});
	}		
</script>

	</c:when>
	<c:otherwise>
		<td width="300px" align="center" style="border: 1px solid #bcbcbc;">
			<a href="<c:url value='javascript:fnLogin();'/>">로그인</a>
		</td>
		<td width="150px" align="center" style="border: 1px solid #bcbcbc;">
			<a href="<c:url value='/mngr/'/>">관리자메뉴</a>
		</td>

<script type="text/javascript">
	function fnLogin(){
	    location.href = "<c:url value='/member/login/'/>";
	}
</script>

	</c:otherwise>
</c:choose>
				</table>
			</td>
		</tr>
	</table>
</div>

<div id="divLayoutBody">
	<decorator:body />
</div>

<script type="text/javascript">
	// 장바구니에 담은 상품 목록
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
						var str = '<table width="300" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid; font-size: 9pt;">'
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
						$("#divSchedulList").html(str);
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
	}

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
					if(flight.FLIGHT_SN) {
						var str1 = '<table width="300" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid; font-size: 9pt;">'
								 + '<tr>';
						if(flight.DTRMC_START_DE == flight.DTRMC_ARVL_DE) {
							str1 += '<td align="center" width="25%" rowspan="2">' + flight.DTRMC_START_DE + "<br>(" + flight.DTRMC_START_DY + ")</td>"; 
						} else {
							str1 += '<td align="center" width="25%">' + flight.DTRMC_START_DE + "<br>(" + flight.DTRMC_START_DY + ")</td>"
						}
						
						str1 += '<td align="center" width="15%">'+flight.DTRMC_START_HH+":"+flight.DTRMC_START_MI+'</td>'
							  + '<td align="center" width="15%">출발</td>'
							  + '<td align="left" width="45%">'+flight.DTRMC_FLIGHT+' '+flight.DTRMC_START_CTY+'</td>'
							  + '</tr>'
							  + '<tr>';

						if(flight.DTRMC_START_DE != flight.DTRMC_ARVL_DE) {
							str1 += '<td align="center">' + flight.DTRMC_ARVL_DE + "<br>(" + flight.DTRMC_ARVL_DY + ")</td>";
						}

						str1 += '<td align="center">'+flight.DTRMC_ARVL_HH+":"+flight.DTRMC_ARVL_MI+'</td>'
							  + '<td align="center">도착</td>'
							  + '<td align="left">'+flight.DTRMC_ARVL_CTY+'</td>'
							  + '</tr>'
							  + '</table>';
						$("#divFlightDepart").html(str1);

						var str2 = '<table width="300" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid; font-size: 9pt;">'
								 + '<tr>';
								 
						if(flight.HMCMG_START_DE == flight.HMCMG_ARVL_DE) {
							str2 += '<td align="center" width="25%" rowspan="2">' + flight.HMCMG_START_DE + "<br>(" + flight.HMCMG_START_DY + ")</td>";
						} else {
							str2 += '<td align="center" width="25%">' + flight.HMCMG_START_DE + "<br>(" + flight.HMCMG_START_DY + ")</td>";
						}
						
						str2 += '<td align="center" width="15%">'+flight.HMCMG_START_HH+":"+flight.HMCMG_START_MI+'</td>'
							  + '<td align="center" width="15%">출발</td>'
							  + '<td align="left" width="50%">'+flight.HMCMG_FLIGHT+' '+flight.HMCMG_START_CTY+'</td>'
							  + '</tr>'
							  + '<tr>';

						if(flight.HMCMG_START_DE != flight.HMCMG_ARVL_DE) {
							str2 += '<td align="center">' + flight.HMCMG_ARVL_DE + "<br>(" + flight.HMCMG_ARVL_DY + ")</td>";
						}

						str2 += '<td align="center">'+flight.HMCMG_ARVL_HH+":"+flight.HMCMG_ARVL_MI+'</td>'
							  + '<td align="center">도착</td>'
							  + '<td align="left">'+flight.HMCMG_ARVL_CTY+'</td>'
							  + '</tr>'
							  + '</table>';
						$("#divFlightReturn").html(str2);

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
	}

	$(document).ready(function(){
		// 우측 장바구니 Floating Banner 
		var topHeight = parseInt($("#divFloatingCart").css("top").substring(0,$("#divFloatingCart").css("top").indexOf("px")));
		
		$(window).scroll(function () { 
			offset = topHeight+$(document).scrollTop()+"px";
			$("#divFloatingCart").animate({top:offset},{duration:500,queue:false});
		});
			
		fnCartList();
		fnFlightInfo();
	});

	function fnCartDetail(str) {
		var form = $("form[id=frmCartDetail]");
		$("input:hidden[id=hidCartSn]").val(str);
		form.submit();
	}
	
	function fnFlightPopup() {
		var sMsg = "항공편을 입력(수정)하시겠습니까?";  
		var sUrl = "<c:url value='/cart/flightPopup/'/>";
		if(confirm(sMsg)){
			fnOpenPopup(sUrl, "winFightPopup", 650, 450);
		}
	}	
</script>


<div id="divFloatingCart">
	<table>
		<tr>
			<td>
			<!-- 일정표 시작 -->
			<table width="300" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
				<tr height="30" width="100%" align="center">
					<td onclick="fnFlightPopup()">항공편</td>
				</tr>
			</table>
			<table width="300">
				<tr height="5" width="100%" align="center">
					<td></td>
				</tr>
			</table>
			<table width="300" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
				<tr height="30" width="100%" align="center">
					<td onclick="frmBannerCategory.submit();">숙박 호텔</td>
				</tr>
			</table>
			<table width="300">
				<tr height="5" width="100%" align="center">
					<td></td>
				</tr>
			</table>
			<table width="300" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
				<tr height="30" width="100%" align="center">
					<td>일정표</td>
				</tr>
			</table>
			<table width="300">
				<tr height="5" width="100%" align="center">
					<td></td>
				</tr>
			</table>
			<div id="divFlightDepart"></div>
			<table width="300">
				<tr height="5" width="100%" align="center">
					<td></td>
				</tr>
			</table>					
			<div id="divSchedulList"></div>
			<table width="300">
				<tr height="5" width="100%" align="center">
					<td></td>
				</tr>
			</table>					
			<div id="divFlightReturn"></div>					
			<!-- 일정표 끝 -->
			</td>
		</tr>
	</table>
</div>

<div class="layer">
	<div class="bg"></div>
	<div id="divWarning" class="pop-layer">
		<div class="pop-container">
			<div class="pop-conts">
				<!--content //-->
				<p class="ctxt mb20">				
					<font size="30"><span id="divExpireTime"></span></font><br><br>
					<input type="button" value="10분 연장" onclick="javascript:fnNotEnd('600');">
					<input type="button" value="5분 연장" onclick="javascript:fnNotEnd('300');">
				</p>

				<div class="btn-r">
					<a href="javascript:fnTimeout();" class="cbtn">로그아웃</a>
				</div>
				<!--// content-->
			</div>
		</div>
	</div>
</div>


<form name="frmBannerCategory" id="frmBannerCategory" method="post" target="divLayoutBody" action="<c:url value='/goods/list/'/>">
	<input type="hidden" id="hidStayngFcltyAt" name="hidStayngFcltyAt" value="Y">
</form>

<form name="frmCartDetail" id="frmCartDetail" method="post" action="<c:url value='/cart/detail/'/>">
	<input type="hidden" id="hidCartSn" name="hidCartSn">
</form>

<input type="hidden" id="hidLayout" name="hidLayout" value="Y">

</body>
</html>