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
		<div class="myinfo">
			<div class="name">
				<c:if test="${user_id == null}">
					<div class="gomy"><a href="javascript:go_login();">로그인</a></div>				
				</c:if>				
				<c:if test="${user_id != null}">
					<!-- <div class="photo"><img src="<c:url value='/images/com/me_photo.jpg' />" alt=""/></div> -->
					<div class="name_tx">${user_nm}님 환영합니다.</div>
					<div class="gomy">
						<a href="javascript:go_mypage();">마이페이지</a>
						<a href="javascript:go_logout();" class="logout">로그아웃</a>
					</div>				
				</c:if>
			</div>
		</div>
		<div class="allmenu"><i class="material-icons">&#xE5D2;</i></div>
	</div>
</div>

<!--모바일  상단메뉴 영역-->
<div class="comf" id="head_home_m">
	<div class="inner">
		<div class="left_icon"><a class="side-left-pushy-button"><i class="material-icons" >&#xE5D2;</i></a></div>
		<div class="toplogo_m"> <a href = "../../../jsp/gnrl/main/index.jsp" ></a></div>
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
          <div class="close side-left-pushy-button"><i class="material-icons">&#xE888;</i></div>
		<c:if test="${user_id == null}">
			<div class="info_btn"> <a  class="info" href="javascript:go_login();">로그인</a> </div>
		</c:if>
		<c:if test="${user_id != null}">
          <div class="info_my">
        	<div class="photo"><img src="<c:url value='/images/com/me_photo.jpg' />" alt=""/></div>
        	<div class="name">${user_nm}</div>
      	  </div>
          <div class="info_btn"> <a href="javascript:go_06_01_01();" class="info">내정보</a><a href="javascript:go_logout();" class="logout">로그아웃</a> </div>
		</c:if>
          <div class="quick_search">
        <input type="text">
        <div class="icon"><i class="material-icons">&#xE8B6;</i></div>
      </div>
        </div>
    <div id="jquery-accordion-menu" class="jquery-accordion-menu red"> 
              <!---탑메뉴-->
        <c:import url="/include/topmenu.jsp" />
<!---//탑메뉴--> 
        </div>
    <script type="text/javascript">
(function($) {
$.expr[":"].Contains = function(a, i, m) {
	return (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
};
function filterList(header, list) {
	var form = $("<form>").attr({
		"class":"filterform",
		action:"#"
	}), input = $("<input>").attr({
		"class":"filterinput",
		type:"text"
	});
	$(form).append(input).appendTo(header);
	$(input).change(function() {
		var filter = $(this).val();
		if (filter) {
			$matches = $(list).find("a:Contains(" + filter + ")").parent();
			$("li", list).not($matches).slideUp();
			$matches.slideDown();
		} else {
			$(list).find("li").slideDown();
		}
		return false;
	}).keyup(function() {
		$(this).change();
	});
}
$(function() {
	filterList($("#form"), $("#demo-list"));
});
})(jQuery);	
</script> 
  </nav>
	<c:if test="${user_id != null}">
        <div class="side-right-pushy-button quick_st1 pc_view" ><i class="material-icons">&#xE314;</i></div>
      <!--오른쪽 예약정보-->
      <nav id="sideRightPushy" class="pushy pushy-right">
    <div class="side-right-pushy-button quick_st2" style="display: none" ><i class="material-icons">&#xE5CD;</i></div>
    <div class="mobile_close  mobile_view"><a class="side-right-pushy-button"><i class="material-icons" >&#xE5CD;</i></a></div>
    <div class="ri_box">
          <div class="title">예약정보
        <div class="reset">초기화</div>
      </div>
          <div class="ri_tab">
        	<ul>
              <li class="on" style="width:calc(50% - 1px);">일정표</li>
              <li style="width:calc(50% - 1px);">항공편</li>
            </ul>
      </div>
          <div class="ri_tb">예약내용 나오는곳</div>
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
