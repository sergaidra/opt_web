<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<footer>
      <div class="inner2">
    <div class="bt_right">
      <div class="tx1">CUSTOMER CENTER</div>
          <div class="tx2">(63)32-410-8454  <br>070-8668-2286</div>
          <div class="tx4">kakao ID : onepasstour</div>
          <div class="tx3"><spring:message code='bottom.msg1'/></div>
          <div class="sns"> 
          	<img src="<c:url value='/images/com/sns_03.png' />"  alt=""/> 
          	<img src="<c:url value='/images/com/sns_02.png' />"  alt=""/> 
          	<a href="javascript:window.open('https://www.facebook.com/JHOSUB/');"><img src="<c:url value='/images/com/sns_01.png' />"  alt=""/></a>
          </div>
        </div>
    <div class="bt_left">
          <div class="bottom_gomenu">
        <ul>
              <li style="cursor:pointer;" onclick="go_07_01_01();">
            <div class="img"><img src="<c:url value='/images/com/bottom_icon01.png' />"  alt=""/></div>
            <div class="t_box"><spring:message code='bottom.review'/></div>
          </li>
              <li style="cursor:pointer;" onclick="go_07_02_01();">
            <div class="img"><img src="<c:url value='/images/com/bottom_icon02.png' />"  alt=""/></div>
            <div class="t_box"><spring:message code='bottom.faq'/></div>
          </li>
              <li style="cursor:pointer;" onclick="go_07_03_01();">
            <div class="img"><img src="<c:url value='/images/com/bottom_icon03.png' />"  alt=""/></div>
            <div class="t_box"><spring:message code='bottom.opinion'/></div>
          </li>
              <li style="cursor:pointer;" onclick="go_04_03_01();">
            <div class="img"><img src="<c:url value='/images/com/bottom_icon04.png' />"  alt=""/></div>
            <div class="t_box"><spring:message code='bottom.checklist'/></div>
          </li>
            </ul>
      </div>
          <div class="bottom_smenu"><a href="#"><spring:message code='bottom.introducecom'/></a> | <a href="#"><spring:message code='bottom.introduceservice'/></a> | <a href="javascript:go_08_03_01();"><spring:message code='topmenu.usemethod'/></a> | <a href="javascript:go_07_06_01();"><spring:message code='topmenu.usetext1'/></a> |
        <div class="mobile_view" ></div>
        <a href="javascript:go_07_07_01();"><spring:message code='topmenu.usetext2'/></a> | <a href="javascript:go_07_08_01();"><spring:message code='topmenu.usetext3'/></a><c:if test="${author_cl == 'A' or author_cl == 'M'}"> | <a href="javascript:go_09_01_01();">ADMIN</a></c:if></div>
          <div class="bottom_copy" style="line-height:120%;">
          	<div class="fl_box"><spring:message code='bottom.copyright_1'/></div>
          	<div class="fr_box"><spring:message code='bottom.copyright_2'/></div>
          </div>
         </div>
       </div>
</footer>
<!-- 팝업 js --> 
<script src="<c:url value='/jq/popup/featherlight.min.js' />" type="text/javascript" charset="utf-8"></script> 
<script>
	( function ( i, s, o, g, r, a, m ) {
		i[ 'GoogleAnalyticsObject' ] = r;
		i[ r ] = i[ r ] || function () {
			( i[ r ].q = i[ r ].q || [] ).push( arguments )
		}, i[ r ].l = 1 * new Date();
		a = s.createElement( o ),
			m = s.getElementsByTagName( o )[ 0 ];
		a.async = 1;
		a.src = g;
		m.parentNode.insertBefore( a, m )
	} )( window, document, 'script', '//stats.g.doubleclick.net/dc.js', 'ga' );

	ga( 'create', 'UA-5342062-6', 'noelboss.github.io' );
	ga( 'send', 'pageview' );
</script> 
<!-- //팝업 js -->