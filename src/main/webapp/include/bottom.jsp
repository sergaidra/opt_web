<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<footer>
      <div class="inner2">
    <div class="bt_right">
      <div class="tx1">CUSTOMER CENTER</div>
          <div class="tx2">1566-1234</div>
          <div class="tx3">토/일요일 및 공휴일은 휴일<br>
        평일 : 09:00~18:00 </div>
          <div class="sns"> <img src="<c:url value='/images/com/sns_03.png' />"  alt=""/> <img src="<c:url value='/images/com/sns_02.png' />"  alt=""/> <img src="<c:url value='/images/com/sns_01.png' />"  alt=""/></div>
        </div>
    <div class="bt_left">
          <div class="bottom_gomenu">
        <ul>
              <li>
            <div class="img"><img src="<c:url value='/images/com/bottom_icon01.png' />"  alt=""/></div>
            <div class="t_box"><em>여행후기</em><br>
                  간단한 설명이 들어가는
                  <div class="pc_view"></div>
                  공간입니다.</div>
          </li>
              <li>
            <div class="img"><img src="<c:url value='/images/com/bottom_icon02.png' />"  alt=""/></div>
            <div class="t_box"><em>FAQ</em><br>
                  간단한 설명이 들어가는
                  <div class="pc_view"></div>
                  공간입니다.</div>
          </li>
              <li>
            <div class="img"><img src="<c:url value='/images/com/bottom_icon03.png' />"  alt=""/></div>
            <div class="t_box"><em> Q&A</em><br>
                  간단한 설명이 들어가는
                  <div class="pc_view"></div>
                  공간입니다.</div>
          </li>
              <li>
            <div class="img"><img src="<c:url value='/images/com/bottom_icon04.png' />"  alt=""/></div>
            <div class="t_box"><em>여행체크리스트</em><br>
                  간단한 설명이 들어가는
                  <div class="pc_view"></div>
                  공간입니다.</div>
          </li>
            </ul>
      </div>
          <div class="bottom_smenu"><a href="#">회사소개</a> | <a href="#">서비스소개</a> | <a href="#">이용방법</a> | <a href="#">이용약관</a> |
        <div class="mobile_view" ></div>
        <a href="#">여행자약관</a> | <a href="#">개인정보 및 취급방침</a></div>
          <div class="bottom_copy">주소 : 000000000000 | E-mail : 000000000000@daum.net<br>
        COPYRIGHTS &copy; 원패스투어 ALL RIGHTS RESERVED.</div>
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