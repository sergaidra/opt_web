<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<style>
	table {
		border-collapse: collapse;
	}
	th, td {
		border: 1px solid #bcbcbc;
	}
</style>
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
<script type="text/javascript">

	//checkUnload true일 경우 페이지 나갈때 알림
	var checkUnload = false;
	$(window).on("beforeunload", function(){
	    if(checkUnload) return "이 페이지를 벗어나면 작성된 내용은 저장되지 않습니다.";
	});

	$(function () {
		$("#userID").keyup(function () {
			//작성이벤트 발생
			checkUnload = true; 
		});

		$("#userPW").keyup(function () {
			//작성이벤트 발생
			checkUnload = true; 
		});
	});

	
	function login(){
		//알림없이 이동할 경우
	    checkUnload = false;
		frmLogin.action="<c:url value='/uia/loginAction/'/>";
		frmLogin.submit();
	}

	<c:if test="${result eq 'fail'}">
		alert("ID/PW가 정확하지 않다.")
	</c:if>

</script>
</head>
<body>
<div align="center">
	<table width="400">
		<tr>
			<td align="center" colspan="2">현재 접속자수 : ${userCnt}</td>
		</tr>

<c:choose>
	<c:when test="${userID ne ''}">
	<iframe id="sessionFrame" src="<c:url value='/uia/sessionTimeout/'/>" width="300" height="50" frameborder=0 scrolling="yes" ></iframe>
		<tr>
			<td align="center">
				${userID}(${userNm}) 로그인중...
			<th align="center"><a href="<c:url value='/uia/logout/'/>">로그아웃</a></th>
			</td>
		</tr>

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
	    location.href = "/uia/logout/";
	}

	function fnNotEnd(){
		sessionFrame.fnRestart();
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
<script type="text/javascript">
/*
	function sessionAlive(){
		$.ajax({
			url : "<c:url value='/uia/sessionAlive/'/>",
			dataType : "json",
			type : "POST",
			async : false,
			data : "",
			success : function(json) {
				if(json.RESULT == "-1"){
					alert("로그인 대기 유효기간이 만료되었습니다.");	
					location.reload();
				}
			},
			error : function() {
				//통신오류
			}
		});

		//세션 타임아웃에 맞도록 시간조절, 세션타임아웃 오버되도록 
		setTimeout("sessionAlive()", 65000);  
		return false;
	}
	
	//로그인 된경우 호출
	sessionAlive();
*/
</script>
		
	</c:when>
	<c:otherwise>

	<form name="frmLogin" action="<c:url value='/uia/loginAction/'/>">
		<tr>
			<th align="left">아이디</th>
			<td align="left"><input type="text" id="userID" name="userID"></td>
		</tr>
		<tr>
			<th align="left">비밀번호</th>
			<td align="left"><input type="text" id="userPW" name="userPW"></td>
		</tr>
		<tr>
			<th align="center" colspan="2"><a href="javascript:login();">로그인</a></th>
		</tr>
	</form>
		
	</c:otherwise>
</c:choose>

	</table>
</div>

<div class="layer">
	<div class="bg"></div>
	<div id="divWarning" class="pop-layer">
		<div class="pop-container">
			<div class="pop-conts">
				<!--content //-->
				<p class="ctxt mb20">				
					<font size="30"><span id='divExpireTime'></span></font><br><br>
					<input type='button' value='연장하기' onclick='javascript:fnNotEnd();'>
					<input type='button' value='끝내기' onclick='javascript:fnTimeout();'>
				</p>

				<div class="btn-r">
					<a href="#" class="cbtn">Close</a>
				</div>
				<!--// content-->
			</div>
		</div>
	</div>
</div>
</body>
</html>