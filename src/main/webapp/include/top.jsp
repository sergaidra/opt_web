<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<header>

<script language="javascript" type="text/javascript">
function changeLocale() {	
	var lang = $("#cmbLocale").val();
	if(window.location.href.indexOf('?') < 0) {
		window.location.href = window.location.href + "?language=" + lang;		
	} else {
		if(window.location.href.indexOf('language=') < 0) {
			window.location.href = window.location.href + "&language=" + lang;		
		} else {
			window.location.href = window.location.href.replace(/language=[a-z]+/, "language=" + lang);
		}
	}
}
</script>
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
			<!-- <div class="myinfo">
				<div class="name">
					<div class="gomy"><a href="javascript:go_login();">로그인</a></div>
				</div>
			</div> -->				
			</c:if>				
			<c:if test="${user_id != null}">
			<div class="myinfo">
				<div class="name">
					<div class="name_tx"><spring:message code='top.user.welcome' arguments="${user_nm}"/></div>
					<div class="gomy">
						<a href="javascript:go_logout();"><spring:message code='top.logout'/></a>
					</div>					
				</div>
			</div>			
			</c:if>
			<div class="lang_sel">
				<select id="cmbLocale" class="w_50p pointer" onchange="changeLocale();">
					<option <c:if test="${pageContext.response.locale.language == 'ko'}">selected</c:if> value="ko">Korean</option>
					<option <c:if test="${pageContext.response.locale.language == 'en'}">selected</c:if> value="en">English</option>
				</select>
			</div>			

			<c:if test="${user_id == null}">
				<a href="javascript:go_login();">
					<div class="mygo">
						<i class="material-icons">&#xE899;</i>
						<div class="tx"><spring:message code='top.login'/> </div>
					</div>
				</a> 
				<a href="javascript:go_join();">
					<div class="allmenu">
						<i class="material-icons">&#xE853;</i>
        				<div class="tx"><spring:message code='top.join'/></div>
      				</div>
      			</a>
			</c:if>			
			<c:if test="${user_id != null}">
				<a href="javascript:go_mypage();">
					<div class="mygo">
						<i class="material-icons">&#xE87C;</i>
        				<div class="tx"><spring:message code='top.mypage'/></div>
      				</div>
      			</a> 
      			<a href="javascript:go_cartpage();">
      				<div class="allmenu">
      					<i class="material-icons">&#xE854;</i>
        				<div class="tx"><spring:message code='top.cart'/></div>
      				</div>
      			</a>
			</c:if>		  
	</div>
</div>

<!--모바일  상단메뉴 영역-->
<div class="comf" id="head_home_m">
	<div class="inner">
		<div class="left_icon"><a class="side-left-pushy-button"><i class="material-icons" >&#xE5D2;</i></a></div>
		<div class="toplogo_m"> <a href = "<c:url value='/' />" ></a></div>
		<!-- <div class="right_icon mobile_view"><a class="side-right-pushy-button"><i class="material-icons">&#xE916;</i></a></div> -->
		<div class="right_icon"><a class="side-right-pushy-button"><i class="material-icons">&#xE916;</i></a></div>
		<a href="#"><div class="right_lang"><i class="material-icons">&#xE040;</i></div></a>		
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
				<div class="name"><spring:message code='top.login.msg'/></div>
				<div class="info_btn"> 
					<a href="javascript:go_login();" class="info"><spring:message code='top.login'/></a>
					<a href="javascript:go_join();" class="logout"><spring:message code='top.join'/></a>
				</div>
			</div>
			</c:if>
			<c:if test="${user_id != null}">
			<div class="info_my">
        		<div class="photo"><img src="/images/com/member_icon01.png" alt=""/></div>
				<div class="name"><em>${user_nm}</em></div>
				<div class="info_btn"> <a href="javascript:go_mypage();" class="info"><spring:message code='top.mypage'/></a><a href="javascript:go_logout();" class="logout"><spring:message code='top.logout'/></a></div>
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
        <div class="pc_open side-right-pushy-button" ><i class="material-icons">&#xE314;</i></div>
      <!--오른쪽 예약정보-->
      <nav id="sideRightPushy" class="pushy pushy-right pushy_450 pushy_over">
	<div class="pc_close  pc_view"><a class="side-right-pushy-button" style="padding-bottom:0px;"><i class="material-icons" >&#xE5CD;</i></a></div>    
    <div class="mobile_close  mobile_view"><a class="side-right-pushy-button"><i class="material-icons" >&#xE5CD;</i></a></div>
    <div class="ri_box">
		<div class="title"><spring:message code='top.reservation'/>
        	<div id="divAirReset" class="reset" style="cursor:pointer;" onclick="flightInit();"><spring:message code='top.reservation.flight.init'/></div>
        	<div id="divAirUpdate" class="reset" style="cursor:pointer;" onclick="flightView();"><spring:message code='top.reservation.flight.update'/></div>
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
	if(divName == "cont_1") {
		$("#divAirReset").hide();
		$("#divAirUpdate").hide();
	} else {
		$("#divAirReset").show();
		$("#divAirUpdate").show();
	}
}

function flightView() {
	$.featherlight('/cmmn/popupFlight', {});
}

function flightInit() {
	var url = "<c:url value='/cmmn/initFlight'/>";

	if(!confirm("<spring:message code='confirm.flight.init'/>"))
		return;
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( {} ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("<spring:message code='info.init'/>");
				getMyFlightInfo();
			} else if(data.result == "-2") {
				alert("<spring:message code='info.login'/>");
				go_login();
			} else if(data.result == "9") {
				alert(data.message);
			} else{
				alert("<spring:message code='info.ajax.fail'/>");
			}	        	
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});			
}

var startRoomtDt = "";
var endRoomDt = "";

function getMyFlightInfo() {
	var url = "<c:url value='/cmmn/getCurrentFlight'/>";

	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( {} ),
        success : function(data,status,request){
			if(data.result == "0") {
				$("#tblFlightInfo tbody").empty();
				var html = ""; 
				for(var cnt = 0; cnt < data.data.length; cnt++) {
					var item = data.data[cnt];
					html += "<tr><td rowspan='2'><spring:message code='flight.leave'/></td><td>" + nvl(item.DTRMC_START_ARPRT_NM) + " &rarr; " + nvl(item.DTRMC_ARVL_ARPRT_NM) + " (<spring:message code='flight.flightname'/>:" + nvl(item.DTRMC_FLIGHT) + ")</td></tr>";
					html += "<tr><td>[<spring:message code='flight.departure'/>] " + nvl(item.DTRMC_START_DT) + "<br>[<spring:message code='flight.arrival'/>] " + nvl(item.DTRMC_ARVL_DT) + "<br></td></tr>";
					html += "<tr><td rowspan='2'><spring:message code='flight.entry'/></td><td>" + nvl(item.HMCMG_START_ARPRT_NM) + " &rarr; " + nvl(item.HMCMG_ARVL_ARPRT_NM) + " (<spring:message code='flight.flightname'/>:" + nvl(item.HMCMG_FLIGHT) + ")</td></tr>";
					html += "<tr><td>[<spring:message code='flight.departure'/>] " + nvl(item.HMCMG_START_DT) + "<br>[<spring:message code='flight.arrival'/>] " + nvl(item.HMCMG_ARVL_DT) + "<br></td></tr>";
					
					startRoomtDt = nvl(item.DTRMC_ARVL_DT);
					endRoomtDt = nvl(item.HMCMG_START_DT);
				}
				$("#tblFlightInfo tbody").append(html);
			} else if(data.result == "-2") {
				alert("<spring:message code='info.login'/>");
				go_login();
			} else if(data.result == "9") {
				alert(data.message);
			} else{
				alert("<spring:message code='info.ajax.fail'/>");
			}	        	
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});				
}

function getMySchedule() {
	var url = "<c:url value='/main/getMySchedule'/>";

	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( {} ),
        success : function(data,status,request){
			if(data.result == "0") {
				$("#tblMyScheduleInfo tbody").empty();
				var html = ""; 
				console.log(data.data);
				for(var cnt = 0; cnt < data.data.lst.length; cnt++) {
					var item = data.data.lst[cnt];
					console.log(item);
					for(var cnt2 = 0; cnt2 < item.lstTime.length; cnt2++) {
						html += "<tr>";
						if(cnt2 == 0) {
							html += "<td rowspan='" + item.lstTime.length + "'>" + item.date + "</td>";
						}
						if(item.lstTime[cnt2].text == null) {
							if(item.lstTime[cnt2].mode == "breakfast")
								html += "<td colspan='2' style='text-align:center;'><button onclick='javascript:goScheduleSelect(\"" + item.date + "\", \"breakfast\");'>조식 선택</button></td>";
							if(item.lstTime[cnt2].mode == "morning")
								html += "<td colspan='2' style='text-align:center;'><button onclick='javascript:goScheduleSelect(\"" + item.date + "\", \"morning\");'>오전일정 선택</button></td>";
							if(item.lstTime[cnt2].mode == "lunch")
								html += "<td colspan='2' style='text-align:center;'><button onclick='javascript:goScheduleSelect(\"" + item.date + "\", \"lunch\");'>중식 선택</button></td>";
							if(item.lstTime[cnt2].mode == "afternoon")
								html += "<td colspan='2' style='text-align:center;'><button onclick='javascript:goScheduleSelect(\"" + item.date + "\", \"afternoon\");'>오후일정 선택</button></td>";
							if(item.lstTime[cnt2].mode == "dinner")
								html += "<td colspan='2' style='text-align:center;'><button onclick='javascript:goScheduleSelect(\"" + item.date + "\", \"dinner\");'>석식 선택</button></td>";
							if(item.lstTime[cnt2].mode == "night")
								html += "<td colspan='2' style='text-align:center;'><button onclick='javascript:goScheduleSelect(\"" + item.date + "\", \"night\");'>저녁일정 선택</button></td>";
						} else {
							html += "<td style='text-align:center;'>" + nvl(item.lstTime[cnt2].time) + "</td><td style='text-align:center;'>" + nvl(item.lstTime[cnt2].text) + "</td>";
						}
						html += "</tr>";
					}
				}
				$("#tblMyScheduleInfo tbody").append(html);				
				$("#tblMyScheduleInfo td[name='schedulePrice']").text(numberWithCommas(data.data.totalPrice) + " 원");
			} else if(data.result == "-2") {
				alert("<spring:message code='info.login'/>");
				go_login();
			} else if(data.result == "9") {
				alert(data.message);
			} else{
				alert("<spring:message code='info.ajax.fail'/>");
			}	        	
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});				
}

function getMyScheduleRoom() {
	var url = "<c:url value='/main/getMyScheduleRoom'/>";

	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( {} ),
        success : function(data,status,request){
			if(data.result == "0") {
				$("#tblHotelInfo tbody").empty();
				console.log(data);
				var html = "<tr>";
				for(var cnt = 0; cnt < data.data.length; cnt++) {
					var item = data.data[cnt];
					html += "<td style='text-align:center;'>" + item.CHKIN_DE + " ~ " + item.CHCKT_DE + "</td><td>" + item.GOODS_NM + "</td>";
					html += "</tr>";
				}
				$("#tblHotelInfo tbody").append(html);
			} else if(data.result == "-2") {
				alert("<spring:message code='info.login'/>");
				go_login();
			} else if(data.result == "9") {
				alert(data.message);
			} else{
				alert("<spring:message code='info.ajax.fail'/>");
			}	        	
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});				
}

function numberWithCommas(x) {
	if(x == null)
		return "";
	else
    	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function getMySchedule_old() {
	var url = "<c:url value='/main/getMySchedule'/>";

	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( {} ),
        success : function(data,status,request){
			if(data.result == "0") {
				$("#tblMyScheduleInfo tbody").empty();
				var html = ""; 
				for(var cnt = 0; cnt < data.data.length; cnt++) {
					var item = data.data[cnt];
					for(var cnt2 = 0; cnt2 < item.list.length; cnt2++) {
						html += "<tr>";
						
						if(cnt2 == 0) {
							html += "<td rowspan='" + item.list.length + "'>" + item.day + "</td>";
						} 
						html += "<td>" + nvl(item.list[cnt2].time) + "</td><td>" + nvl(item.list[cnt2].text) + "</td>";
						
						html += "</tr>";
					}
				}
				$("#tblMyScheduleInfo tbody").append(html);
			} else if(data.result == "-2") {
				alert("<spring:message code='info.login'/>");
				go_login();
			} else if(data.result == "9") {
				alert(data.message);
			} else{
				alert("<spring:message code='info.ajax.fail'/>");
			}	        	
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});				
}

function goScheduleSelect(date, mode, date2) {
	if(mode == "breakfast" || mode == "lunch" || mode == "dinner") {
		alert("준비 중 입니다.");
		return;		
	}
	
	var form = $("form[id=frmMenuCategory]");
	$(form).empty();

	$(form).append("<input type=\"hidden\" name=\"hidUpperClCodeNavi\" value=\"00429@00571@00414@00415\" >");
	$(form).append("<input type=\"hidden\" name=\"category\" value=\"S\" >");
	$(form).append("<input type=\"hidden\" name=\"date\" value=\"" + date.replace(/-/g, "") + "\" >");
	$(form).append("<input type=\"hidden\" name=\"mode\" value=\"" + mode + "\" >");
	$(form).append("<input type=\"hidden\" name=\"date2\" value=\"" + date2.replace(/-/g, "") + "\" >");
	form.attr({"method":"get","action":"<c:url value='/goods/list'/>"});
	form.submit();
}

function goScheduleRoomSelect() {
	if(startRoomtDt == "" || endRoomtDt == "") {
		alert("항공편을 입력해주세요.");
		return;
	}
	var form = $("form[id=frmMenuCategory]");
	$(form).empty();
	
	var st = startRoomtDt.substring(0, 10).replace(/-/g, "");
	var end = endRoomtDt.substring(0, 10).replace(/-/g, "");

	$(form).append("<input type=\"hidden\" name=\"hidUpperClCodeNavi\" value=\"00411\" >");
	$(form).append("<input type=\"hidden\" name=\"category\" value=\"S\" >");
	$(form).append("<input type=\"hidden\" name=\"date\" value=\"" + st + "\" >");
	$(form).append("<input type=\"hidden\" name=\"mode\" value=\"room\" >");
	$(form).append("<input type=\"hidden\" name=\"date2\" value=\"" + end + "\" >");
	form.attr({"method":"get","action":"<c:url value='/goods/list'/>"});
	form.submit();
}

getMySchedule();
getMyFlightInfo();
getMyScheduleRoom();
</script>

		<div id="cont_1" >
		<!--일정표 -->
			<div class="ri_tab" style="text-align:center; font-size:12px; color:#333; background-color:#fff; border:1px solid #000; padding:5px; cursor:pointer;" onclick="javascript:goScheduleRoomSelect();">
				숙박선택
			</div>
			<div class="ri_tb">
				<div class="tb_01_box_s" style="">
					<table class="tb_01" id="tblHotelInfo">
						<col width="50%">
						<col width="">
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
			<div class="ri_tab" style="text-align:center; font-size:12px; color:#333; background-color:#fff; border:1px solid #000; padding:5px;">
				<spring:message code='top.reservation.schedule'/>
			</div>
			<div class="ri_tb">
				<div class="tb_01_box_s" style="display:none;">
					<table class="tb_01" id="tblFlightInfo">
						<col width="20%">
						<col width="">
						<tbody>
						</tbody>
					</table>
				</div>
				<div class="tb_01_box_s">
					<table class="tb_01" id="tblMyScheduleInfo">
						<col width="22%">
						<col width="30%">
						<col width="">
						<tbody>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="2" style="text-align:center;">총 결재 예정금</td><td name="schedulePrice" style="text-align:right; padding:10px;"></td>
							</tr>
						</tfoot>
					</table>
				</div>
			</div>
		<!--일정표 -->
		</div>
		<div id="cont_2" style="display:none;">
		<!--항공 -->
			<div class="ri_tab">
				<ul>
					<li><a href="javascript:void(0)" onclick="switch_product_img('cont_1', 2);" ><spring:message code='top.reservation.schedule'/></a></li>
					<li  class="on"><a href="javascript:void(0)" onclick="switch_product_img('cont_2', 2);" ><spring:message code='top.reservation.flight'/></a></li>
				</ul>
			</div>
			<div class="ri_tb">
				<div class="tb_01_box_s">
					<table class="tb_01" id="tblFlightInfo">
						<col width="20%">
						<col width="">
						<tbody>
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

<!--팝업 : 경고안내문구-->
<div class="lightbox" id="alert_popup">
  <div class="popup_com3">
    <div class="icon"><i class="material-icons">&#xE8B2;</i> </div>
    <div class="text">
 옵션을 선택해 주세요 <br>
경고안내 문구 나오는곳
    </div>
	<div class="popup_btn2">
	   	<a href="javascript:dialogOkFunc();" class="btnst1">확인</a>
	   	<a href="javascript:dialogCancelFunc();" class="btnst2" id="btnDialogCalc">취소</a>
	</div>
  </div>
</div>
<!--팝업-->	  

<script>
var dialogOkFunc = null;
var dialogCancelFunc = null;

function alertPopup(text, okFunc, closeFunc) {
	var config = {};
	if(okFunc == null) {
		okFunc = function() {
			$.featherlight.close();
		}
	}
	if(closeFunc != null) 
		config.afterClose = closeFunc;
	else
		config.afterClose = okFunc;
	dialogOkFunc = okFunc;
	$.featherlight($("#alert_popup"), config);
	$(".featherlight #btnDialogCalc").hide();
	$(".featherlight .text").text(text);
}

function confirmPopup(text, okFunc, closeFunc) {
	var config = {};
	if(closeFunc != null) {
		config.afterClose = closeFunc;
		dialogCancelFunc = closeFunc;
	} else {
		dialogCancelFunc = function() {
			$.featherlight.close();
		}
	}
	dialogOkFunc = okFunc;
	$.featherlight($("#alert_popup"), config);
	$(".featherlight #btnDialogCalc").show();
	$(".featherlight .text").text(text);
}

</script>

    