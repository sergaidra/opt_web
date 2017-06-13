<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %> 
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
</style>
<script src="/js/jquery-1.11.1.js"></script>
<script src="/js/siione.js"></script>

<decorator:head />

</head>
<body>

<div style="width:100%;height:100px;" align="center">
	<table style="width:100%;height:100%;" border="0">
		<tr>
			<td align="center">
				<table style="border-collapse: collapse; margin-top: 3px; height:40px;">
					<tr>
						<td width="80px" align="center" style="border: 1px solid #bcbcbc;">OPT</td>
						<td width="120px" align="center" style="border: 1px solid #bcbcbc;">원패스투어?</td>
						<td width="120px" align="center" style="border: 1px solid #bcbcbc;"><a href="<c:url value='/goods/category/'/>">투어상품</a></td>
						<td width="120px" align="center" style="border: 1px solid #bcbcbc;">여행후기</td>
						<td width="120px" align="center" style="border: 1px solid #bcbcbc;">고객서비스</td>
						<td width="120px" align="center" style="border: 1px solid #bcbcbc;">Event</td>
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
		<td width="350px" align="center" style="border: 1px solid #bcbcbc;">
			<a href="<c:url value='javascript:fnLogin();'/>">로그인</a>
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

<decorator:body />

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

</body>
</html>