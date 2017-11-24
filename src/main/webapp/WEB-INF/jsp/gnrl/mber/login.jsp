<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  

<head>
<script type="text/javascript" src="/js/acco.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		$("#txtPW").keydown(function(event){
			if(event.keyCode == 13) {
				login();
			}
		});	
		
	});

	function login(){
		frmLogin.action="<c:url value='/member/loginAction/'/>";
		frmLogin.submit();
	}
	<c:choose>
		<c:when test="${result eq 'fail'}">
			alert("ID/PW가 정확하지 않습니다.");
		</c:when>
		<c:when test="${result eq 'need'}">
			alert("로그인해야 사용할 수 있습니다.");
		</c:when>
		<c:when test="${result eq 'mngr'}">
			alert("관리자 권한이 없습니다.");
		</c:when>		
		<c:otherwise></c:otherwise>
	</c:choose>
</script>

</head>

<body>

<!-- 본문 -->
<section>
 <div id="container">
		<div class="sp_100 "></div>
    <div class="inner2">
		<div class="login_box">
	<form name="frmLogin" action="<c:url value='/member/loginAction/'/>">
    <div class="inbox">
      <div class="login_div1">
        <div class="text1"><em>Membership</em> Login</div>
        <div class="text2">원패스투어에 오신것을 환영합니다. </div>
        <div class="line"></div>
        <div class="input_box">
          <div class="idpw">
          
            <p class="input">
              <input  id="txtID" name="txtID" type="text" placeholder="아이디"/>
            </p>
          </div>
          <div class="idpw">
           
            <p class="input">
              <input id="txtPW" name="txtPW" type="password" placeholder="비밀번호"/>
            </p>
          </div>
        </div>
        <div class="login"><a href="javascript:login();">로그인</a></div>
        <div class="line"></div>
        <div class="find">
          <div class="text1">아직도 회원이 아니신가요? </div>
          
          <div class="btn"><a href="#">회원가입</a></div>
        </div>
        <div class="find">
          <div class="text1">아이디/비밀번호를 분실하셨나요? </div>
          
          <div class="btn"><a href="#">아이디/비밀번호</a></div>
        </div>
      </div>
      <div class="login_div2"><a href="#"><img src="/images/com/sns_login1.gif" alt=""/></a> <a href="#"><img src="/images/com/sns_login2.gif" alt=""/></a>  <a href="#"><img src="/images/com/sns_login3.gif" alt=""/></a> </div>
    </div>
    </form>
  </div></div>   
		  <div class="sp_50"></div>
  </div>
</section>

<!-- //본문 -->

</body>
