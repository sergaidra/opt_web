<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<header>
    
<!--PC 상단메뉴 영역-->
<div class="comf" id="head_home">
	<div class="inner">
		<div class="toplogo"> <a href = "<c:url value='/' />" ></a></div>
		<div class="menu">
        <!---탑메뉴-->
        <c:import url="/include/topmenu.jsp" />
		<!---//탑메뉴--> 
      	</div>
			<c:if test="${user_id == null}">
			<div class="myinfo">
				<div class="name">
					<div class="gomy"><a href="javascript:go_login();">로그인</a></div>
				</div>
			</div>				
			</c:if>				
			<c:if test="${user_id != null}">
			<div class="myinfo">
				<div class="name">
					<div class="name_tx">${user_nm}님 환영합니다.</div>
					<div class="gomy">
						<a href="javascript:go_mypage();">마이페이지</a>
						<a href="javascript:go_logout();" class="logout">로그아웃</a>
					</div>
				</div>
			</div>
			<a href="javascript:go_cartpage();"><div class="allmenu"><i class="material-icons">&#xE854;</i></div></a>									
			</c:if>
	</div>
</div>

<!--모바일  상단메뉴 영역-->
<div class="comf" id="head_home_m">
	<div class="inner">
		<div class="left_icon"><a class="side-left-pushy-button"><i class="material-icons" >&#xE5D2;</i></a></div>
		<div class="toplogo_m"> <a href = "<c:url value='/' />" ></a></div>
		<div class="right_icon mobile_view"><a class="side-right-pushy-button"><i class="material-icons">&#xE916;</i></a></div>
		<div class="menu"> 
			<!---탑메뉴-->
			<c:import url="/include/topmenu.jsp" />
			<!---//탑메뉴--> 
		</div>
	</div>
</div>
      
      <!-- left: 푸시영역 -->
	<nav id="sideLeftPushy" class="pushy pushy-left pushy_over" >
		<div class="quick_info">
			<div class="close side-left-pushy-button"><i class="material-icons">&#xE14C;</i></div>
			<c:if test="${user_id == null}">
        	<div class="info_my">
				<div class="photo"><img src="/images/com/member_icon02.png" alt=""/></div>
				<div class="name">로그인 해주세요!</div>
				<div class="info_btn"> 
					<a href="javascript:go_login();" class="info">로그인</a>
					<a href="#javascript:go_join();" class="logout">회원가입</a>
				</div>
			</div>
			</c:if>
			<c:if test="${user_id != null}">
			<div class="info_my">
        		<div class="photo"><img src="/images/com/member_icon01.png" alt=""/></div>
				<div class="name"><em>${user_nm}</em></div>
				<div class="info_btn"> <a href="javascript:go_mypage();" class="info">마이페이지</a><a href="javascript:go_logout();" class="logout">로그아웃</a></div>
			</div>  
			</c:if>
			<div class="quick_search">
				<input type="text">
				<a href="#"><div class="icon"><i class="material-icons">&#xE8B6;</i></div></a>
			</div>
		</div>
		<aside class="sidebar">
			<div id="leftside-navigation" class="nano">
			<!---탑메뉴-->
        	<c:import url="/include/topmenu.jsp" />
			<!---//탑메뉴--> 
        	</div>
        </aside>
<script>
$("#leftside-navigation .sub-menu > a").click(function(e) {
  $("#leftside-navigation ul ul").slideUp(), $(this).next().is(":visible") || $(this).next().slideDown(),
  e.stopPropagation()
})
</script>
	</nav>
	<c:if test="${user_id != null}">
        <div class="side-right-pushy-button quick_st1 pc_view" ><i class="material-icons">&#xE314;</i></div>
      <!--오른쪽 예약정보-->
      <nav id="sideRightPushy" class="pushy pushy-right pushy_450">
    <div class="side-right-pushy-button quick_st2" style="display: none" ><i class="material-icons">&#xE5CD;</i></div>
    <div class="mobile_close  mobile_view"><a class="side-right-pushy-button"><i class="material-icons" >&#xE5CD;</i></a></div>
    <div class="ri_box">
		<div class="title">예약정보
        	<div class="reset">초기화</div>
		</div>
<script language="javascript" type="text/javascript">
function switch_product_img(divName, totalImgs) {
	for (var i=1; i<=totalImgs; i++) {
		var showDivName = 'cont_' + i;
		var showObj = document.getElementById(showDivName);
		if (showDivName == divName)
			showObj.style.display = 'block';
		else
			showObj.style.display = 'none';
		}
	}
</script>

		<div id="cont_1" >
		<!--일정표 -->
			<div class="ri_tab">
				<ul>
					<li class="on"><a href="javascript:void(0)" onclick="switch_product_img('cont_1', 2);" >일정표</a></li>
					<li><a href="javascript:void(0)" onclick="switch_product_img('cont_2', 2);" >항공편</a></li>
				</ul>
			</div>
			<div class="ri_tb">
				<div class="tb_01_box_s">
					<table class="tb_01">
						<col width="22%">
						<col width="30%">
						<col width="">
						<tbody>
						<tr>
							<td rowspan="4">2017-07-07(금)</td>
							<td>07:30 ~ 09:00</td>
							<td>아침에는 커피한잔</td>
						</tr>
						<tr>
							<td>10:00 ~ 14:30</td>
							<td>보름성 데이투어</td>
						</tr>
						<tr>
							<td>07:30 ~ 09:00</td>
							<td>중식은 한인 식장에서</td>
						</tr>
						<tr>
							<td>10:00 ~ 14:30</td>
							<td>저녁은 간단하게</td>
						</tr>
						</tbody>
					</table>
				</div>
			</div>
		<!--일정표 -->
		</div>
		<div id="cont_2" style="display:none;">
		<!--항공 -->
			<div class="ri_tab">
				<ul>
					<li><a href="javascript:void(0)" onclick="switch_product_img('cont_1', 2);" >일정표</a></li>
					<li  class="on"><a href="javascript:void(0)" onclick="switch_product_img('cont_2', 2);" >항공편</a></li>
				</ul>
			</div>
			<div class="ri_tb">
				<div class="tb_01_box_s">
					<table class="tb_01">
						<col width="20%">
						<col width="">
						<tbody>
						<tr>
							<td rowspan="2">출국</td>
							<td>대한항공(인천) &rarr; (로마)</td>
						</tr>
						<tr>
							<td>        [출발] 2017-09-24 13:30 
								[도착]  2017-09-24 13:30<br></td>
						</tr>
						<tr>
							<td rowspan="2">입국</td>
							<td>대한항공(밀라노) &rarr; (로마)</td>
						</tr>
						<tr>
							<td>        [출발] 2017-09-24 13:30 
								[도착]  2017-09-24 13:30<br></td>
						</tr>
						</tbody>
					</table>
				</div>
			</div>			
		<!--항공 -->
		</div>
	</div>
  </nav>

      
      <!--//오른쪽 예약정보--> 
	</c:if>      
      <script >
            //상단배너 이용
            //var optionSideTop = {
               // button: "side-top-pushy-button",
               // container: "container",
                //containerPush: true,
                //menuPosition: "top",
               // menuOpen: false,
               // overlayShow: true                                    
           // };
           // $("#sideTopPushy").Pushy(optionSideTop);


             var optionSideLeft = {
                button: "side-left-pushy-button",
                container: "container",
                containerPush: false,
                menuPosition: "left",
                menuOpen: false,
                overlayShow: true          
            }
            $("#sideLeftPushy").Pushy(optionSideLeft);

           
            var optionSideRight = {
                button: "side-right-pushy-button",
                container: "container",
                containerPush: true,
                menuPosition: "right",
                menuOpen: false,
                overlayShow:  true
            };

            $("#sideRightPushy").Pushy(optionSideRight);

            
        </script> 
      <!-- //left: 푸시영역 --> 
      
    </header>
