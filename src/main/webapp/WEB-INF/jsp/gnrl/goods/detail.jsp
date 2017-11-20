<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>
	<!-- Link Swiper's CSS -->
	<link rel="stylesheet" href="<c:url value='/jq/swiper/dist/css/swiper.min.css'/>">
	
	<!--달력-->
	<link rel="stylesheet" href="<c:url value='/jq/calendar/css/normalize.css'/>">
	<link rel="stylesheet" href="<c:url value='/jq/calendar/css/style.css'/>">
	<link href='https://fonts.googleapis.com/css?family=Roboto:400,300,300italic,400italic,500,700,100,100italic' rel='stylesheet' type='text/css'>
	<!--//달력-->
	<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script> --> 

<style>
#map { height: 550px; }
</style>
<script>
$(document).ready(function(){
	  $(".photo_btn1").click(function(){
        $(".photo_box").show();
		$(".map_box").hide();
		
    });
   $(".photo_btn2").click(function(){
        $(".photo_box").hide();
		$(".map_box").show();
		initMap();
	});

	  $(".tab_btn1").click(function(){
	        $(".review_box").show();
			$(".qa_box").hide();
			
	    });
	   $(".tab_btn2").click(function(){
	        $(".review_box").hide();
			$(".qa_box").show();
	    });

});

var lstNmpr = [];
var roomInfo = { "days" : 0, "room" : null, "eat" : null, "check" : null};
var selectDt = { "startDt" : null, "endDt" : null };

$(function() {
	$("#reservation").click(function () {
		// 예약
		var purchs_amount = 0;
		var tour_de = "";
		var tour_tiem = "";
		var chkin_de = "";
		var chckt_de = "";
		var setup_se = "";
		var nmpr_sn = "";
		var cart_nmpr_co = "";

		// 밸리데이션 체크	
		if($('#hidClSe').val() == 'S') {
			if(roomInfo.days == 0) {
				alert("기간을 선택하세요.");
				return false;
			}
			if(roomInfo.room == null) {
				alert("객실을 선택하세요.");
				return false;
			}
			
			//for(var cnt )

		} else {
			
		}
		
		
			var url = "<c:url value='/cart/addAction'/>";
			var param = {};
			param.hidGoodsCode = "${goods_code}";
			param.PURCHS_AMOUNT = "";
			param.TOUR_DE = "";
			param.TOUR_TIME = "";
			param.CHKIN_DE = "";
			param.CHCKT_DE = "";
			param.SETUP_SE = "";
			param.NMPR_SN = "";
			param.CART_NMPR_CO = "";
			
			$.ajax({
		        url : url,
		        type: "post",
		        dataType : "json",
		        async: "true",
		        contentType: "application/json; charset=utf-8",
		        data : JSON.stringify( param ),
		        //data : "hidUpperClCode=00411",
		        success : function(data,status,request){
		        },
		        error : function(request,status,error) {
		        	alert(error);
		        },
			});			

	});
	
	$("#cmbNmpr").change(function () {
		if($("#cmbNmpr option:selected").val() == "")
			return false;
		
		var text = $("#cmbNmpr option:selected").text();
		var nmpr_sn = $("#cmbNmpr option:selected").attr("nmpr_sn");
		var setup_amount = $("#cmbNmpr option:selected").attr("setup_amount");
		var nmpr_co = $("#cmbNmpr option:selected").attr("nmpr_co");
		
		var isFind = false;
		for(var cnt = 0; cnt < lstNmpr.length; cnt++) {
			if(lstNmpr[cnt].nmpr_sn == nmpr_sn) {
				lstNmpr[cnt].nmprCnt++;
				isFind = true;
				break;
			}
		}
		if(isFind == false) {
			var item = { "text" : text, "nmpr_sn" : nmpr_sn, "setup_amount" : setup_amount, "nmpr_co" : nmpr_co, "nmprCnt" : 1 };
			lstNmpr.push(item);
		}
		
		$("#cmbNmpr").val("");
		displayNmpr();
	});
	
	$("#cmbRoom").change(function () {
		if($("#cmbRoom option:selected").val() == "") {
			removeRoom();
		} else {
			if(roomInfo.days == 0) {
				alert("기간을 선택하세요.");
				$("#cmbRoom").val("");
				return false;
			}
			var text = $("#cmbRoom option:selected").text();
			var nmpr_sn = $("#cmbRoom option:selected").attr("nmpr_sn");
			var setup_amount = $("#cmbRoom option:selected").attr("setup_amount");
			var nmpr_co = $("#cmbRoom option:selected").attr("nmpr_co");

			var item = { "text" : text, "nmpr_sn" : nmpr_sn, "setup_amount" : setup_amount, "nmpr_co" : nmpr_co };
			roomInfo.room = item;		
			displayRoom();
		}
	});

	$("#cmbEat").change(function () {
		if($("#cmbEat option:selected").val() == "") {
			removeEat();
		} else {
			if(roomInfo.days == 0) {
				alert("기간을 선택하세요.");
				$("#cmbEat").val("");
				return false;
			}
			if(roomInfo.room == null) {
				alert("객실을 선택하세요.");
				$("#cmbEat").val("");
				return false;
			}
			var text = $("#cmbEat option:selected").text();
			var nmpr_sn = $("#cmbEat option:selected").attr("nmpr_sn");
			var setup_amount = $("#cmbEat option:selected").attr("setup_amount");
			var nmpr_co = $("#cmbEat option:selected").attr("nmpr_co");

			var item = { "text" : text, "nmpr_sn" : nmpr_sn, "setup_amount" : setup_amount, "nmpr_co" : nmpr_co };
			roomInfo.eat = item;		
			displayRoom();
		}

	});

	$("#cmbCheck").change(function () {
		if($("#cmbCheck option:selected").val() == "") {
			removeCheck();
		} else {
			if(roomInfo.days == 0) {
				alert("기간을 선택하세요.");
				$("#cmbCheck").val("");
				return false;
			}
			if(roomInfo.room == null) {
				alert("객실을 선택하세요.");
				$("#cmbCheck").val("");
				return false;
			}
			var text = $("#cmbCheck option:selected").text();
			var nmpr_sn = $("#cmbCheck option:selected").attr("nmpr_sn");
			var setup_amount = $("#cmbCheck option:selected").attr("setup_amount");
			var nmpr_co = $("#cmbCheck option:selected").attr("nmpr_co");

			var item = { "text" : text, "nmpr_sn" : nmpr_sn, "setup_amount" : setup_amount, "nmpr_co" : nmpr_co };
			roomInfo.check = item;		
			displayRoom();
		}
	});
});

function setDateRange() {
	if(selectDt.startDt == null || selectDt.endDt == null) {
		roomInfo.days = 0;
	} else {
		var startDt = selectDt.startDt.split("-");
		var endDt = selectDt.endDt.split("-");
		var days = (new Date(endDt[0], endDt[1] - 1, endDt[2]) - new Date(startDt[0], startDt[1] - 1, startDt[2]).getTime())/1000/60/60/24;
		roomInfo.days = days;
	}
	displayRoom();
}

function displayRoom() {
	$("#purchInfo").empty();
	var totalprice = 0;
		
	if(roomInfo.days != 0) {
		if(roomInfo.room != null) {
			var nmpr_sn = roomInfo.room.nmpr_sn;
			var minus = $("<span onclick='removeRoom(" + nmpr_sn + ");'>-</span>");
			var price = roomInfo.days * roomInfo.room.setup_amount;

			var html = $("<div class='um_box'></div>");
			var fl_text = $("<div class='fl_text'>" + roomInfo.room.text + "</div>");
			var fl_total = $("<div class='fl_total'><em>" + roomInfo.days + "</em>박 <em>\\ " + numberWithCommas(price) + "</em></div>");
			$(fl_text).append(fl_total);
			var fr_updown = $("<div class='fr_updown'><div class='um_d' style='float:right;' onclick='removeRoom(" + nmpr_sn + ");'>-</div></div>");
			
			roomInfo.room.price = price;
			
			$(html).append(fl_text);
			$(html).append(fr_updown);
			
			$("#purchInfo").append($(html));
			totalprice += price;
		}

		if(roomInfo.eat != null) {
			var nmpr_sn = roomInfo.eat.nmpr_sn;
			var minus = $("<span onclick='removeEat(" + nmpr_sn + ");'>-</span>");
			var price = roomInfo.eat.nmpr_co * roomInfo.days * roomInfo.eat.setup_amount;
			
			var html = $("<div class='um_box'></div>");
			var fl_text = $("<div class='fl_text'>" + roomInfo.eat.text + "</div>");
			var fl_total = $("<div class='fl_total'><em>" + roomInfo.eat.nmpr_co + "</em>인 <em>" + roomInfo.days + "</em>박 <em>\\ " + numberWithCommas(price) + "</em></div>");
			$(fl_text).append(fl_total);
			var fr_updown = $("<div class='fr_updown'><div class='um_d' style='float:right;' onclick='removeRoom(" + nmpr_sn + ");'>-</div></div>");

			roomInfo.eat.price = price;

			$(html).append(fl_text);
			$(html).append(fr_updown);
			
			$("#purchInfo").append($(html));
			totalprice += price;
		}
		
		if(roomInfo.check != null) {
			var nmpr_sn = roomInfo.check.nmpr_sn;
			var minus = $("<span onclick='removeCheck(" + nmpr_sn + ");'>-</span>");
			var price = roomInfo.check.setup_amount * 1;
			
			var html = $("<div class='um_box'></div>");
			var fl_text = $("<div class='fl_text'></div>");
			var fl_total = $("<div class='fl_total'><em>" + roomInfo.check.text + "</em> <em>\\ " + numberWithCommas(price) + "</em></div>");
			$(fl_text).append(fl_total);
			var fr_updown = $("<div class='fr_updown'><div class='um_d' style='float:right;' onclick='removeRoom(" + nmpr_sn + ");'>-</div></div>");

			roomInfo.check.price = price;

			$(html).append(fl_text);
			$(html).append(fr_updown);
			
			$("#purchInfo").append($(html));
			totalprice += price;
		}
	}

	$("#totalprice").text("￦ " + numberWithCommas(totalprice));
}

function removeRoom() {
	roomInfo.room = null;
	roomInfo.eat = null;
	roomInfo.check = null;
	$("#cmbRoom").val("");
	$("#cmbEat").val("");
	$("#cmbCheck").val("");
	displayRoom();
}

function removeEat() {
	roomInfo.eat = null;
	$("#cmbEat").val("");
	displayRoom();
}

function removeCheck() {
	roomInfo.check = null;
	$("#cmbCheck").val("");
	displayRoom();
}

function displayNmpr() {
	$("#purchInfo").empty();
	var totalprice = 0;
	for(var cnt = 0; cnt < lstNmpr.length; cnt++) {
		var nmpr_sn = lstNmpr[cnt].nmpr_sn;
		var plus = $("<span onclick='plusNmpr(" + nmpr_sn + ");'>+</span>");
		var minus = $("<span onclick='minusNmpr(" + nmpr_sn + ");'>-</span>");
		var price = lstNmpr[cnt].nmprCnt * lstNmpr[cnt].setup_amount;

		var html = $("<div class='um_box'></div>");
		var fl_text = $("<div class='fl_text'></div>");
		var fl_total = $("<div class='fl_total'>" + lstNmpr[cnt].text + " <em>" + lstNmpr[cnt].nmprCnt + "</em>명 <em>\\ " + numberWithCommas(price) + "</em></div>");
		$(fl_text).append(fl_total);
		var fr_updown = $("<div class='fr_updown'><div class='um_d' onclick='minusNmpr(" + nmpr_sn + ");'>-</div><div class='um_input'><input type='text' value='" + lstNmpr[cnt].nmprCnt + "' readonly></div><div class='um_d' onclick='plusNmpr(" + nmpr_sn + ");'>+</div></div>");
		
		lstNmpr[cnt].price = price;

		$(html).append(fl_text);
		$(html).append(fr_updown);

		$("#purchInfo").append($(html));
		totalprice += price;
	}
	
	$("#totalprice").text("￦ " + numberWithCommas(totalprice));
}

function plusNmpr(nmpr_sn) {
	for(var cnt = 0; cnt < lstNmpr.length; cnt++) {
		if(lstNmpr[cnt].nmpr_sn == nmpr_sn) {
			lstNmpr[cnt].nmprCnt++;
			break;
		}
	}
	displayNmpr();
}
function minusNmpr(nmpr_sn) {
	for(var cnt = 0; cnt < lstNmpr.length; cnt++) {
		if(lstNmpr[cnt].nmpr_sn == nmpr_sn) {
			lstNmpr[cnt].nmprCnt--;
			if(lstNmpr[cnt].nmprCnt == 0)
				lstNmpr.splice(cnt, 1);
			break;
		}
	}	
	displayNmpr();
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

var isMap = false;
function initMap() {
	if(isMap == true)
		return false;
	var lat = Number($("#ACT_LA").val());
	var lng = Number($("#ACT_LO").val());
  var uluru = { "lat": lat, "lng": lng}; //{lat: -25.363, lng: 131.044};
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 16,
    center: uluru
  });
  var marker = new google.maps.Marker({
    position: uluru,
    map: map
  });
  isMap = true;
}

</script>
	
</head>

<body>

<input type="hidden" id="ACT_LA" value="${result.ACT_LA}">
<input type="hidden" id="ACT_LO" value="${result.ACT_LO}">
<input type="hidden" id="hidClSe" value="${result.CL_SE}">

<form id="">

</form>
<section>

<div id="container">
  <div class="sp_50 pc_view"></div>
  <div class="sp_10 mobile_view"></div>
  <div class="inner2_2">
    <div class="good_detail">
      <div class="fl_left"> 
        <div class="photo_box">
          <div class="ov_btn">
            <div class="ov_on photo_btn1"><i class="material-icons">&#xE3B0;</i><span>PHOTO VIEW</span></div>
            <div class="ov_off photo_btn2"><i class="material-icons">&#xE55F;</i><span>MAP</span></div>
          </div>
          <div class="sp-black">
            <div class="slider_text">
              <div class="slider_t1">${result.GOODS_NM}</div>
              <div class="slider_t2"><!-- 바다의 젠틀맨 고래상어와 함께 수영을 하는 흔치 않은 경험이 가능한 오슬롭!!! 스페인 시절의 흔적이 남아있는 유적지, 
                깊은 산속에 숨어있는 시원한 폭포 그리고 한적한 비치 리조트에서 점심을 즐기실 수 있는 투어입니다. --> </div>
            </div>
          </div>
          <div class="hit_box"><i class="material-icons">&#xE87E;</i><span>25</span></div>
          <div class="share_box"><i class="material-icons">&#xE80D;</i></div>
          <div class="qa_btn"><a href="#" data-featherlight="#pa_popup2">1:1문의하기</a></div>
          <!-- Swiper -->
          <div class="swiper-container">
            <div class="swiper-wrapper">
				<c:forEach var="result" items="${lstFile}" varStatus="status">
	              <div class="swiper-slide"><img src="<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}" width="100%" alt=""/></div>
				</c:forEach>
            </div>
            <!-- Add Pagination 
        <div class="swiper-pagination"></div>--> 
            <!-- Add Navigation -->
            <div class="swiper-button-prev"></div>
            <div class="swiper-button-next"></div>
          </div>
          
          <!-- jQuery 
    <script src="http://code.jquery.com/jquery-2.1.3.min.js"></script>
    <!-- Swiper JS --> 
          <script src="/jq/swiper/dist/js/swiper.jquery.min.js"></script> 
          
          <!-- Initialize Swiper --> 
          <script>
    var swiper = new Swiper('.swiper-container', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        nextButton: '.swiper-button-next',
        prevButton: '.swiper-button-prev'
    });
    </script> 
        </div>
        <div class="map_box" style="display: none">
			<div class="ov_btn">
				<div class="ov_off photo_btn1"><i class="material-icons">&#xE3B0;</i><span>PHOTO VIEW</span></div>
				<div class="ov_on photo_btn2"><i class="material-icons">&#xE55F;</i><span>MAP</span></div>
			</div>
			<div class="comf t_center ">
			    <div id="map"></div>
			    <script async defer
			    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA88oWHhxjR6HD5RqCg2lvXAkp0fj_Vatc">
			    </script>
				<!-- <iframe src="<c:url value='/gmap/location/'/>?la=${result.ACT_LA}&lo=${result.ACT_LO}" width="100%" height="100%"></iframe> -->
			</div>
        </div>
        <!--아이콘 설명-->
		<c:if test="${!empty result.INTRCN_GOODS_TY || !empty result.INTRCN_USE_TIME || !empty result.INTRCN_MEET_TIME || !empty result.INTRCN_REQRE_TIME || !empty result.INTRCN_PROVD_LANG || !empty result.INTRCN_POSBL_AGE || !empty result.INTRCN_PLACE}" >
	        <div class="icon_info">
	          <ul>
				<c:if test="${!empty result.INTRCN_GOODS_TY}">
	            <li>
	              <div class="icon_b">
	                <div class="icon_in"><img src="/images/sub/detail_icon01.png" alt=""/></div>
	                <div class="tx1">상품유형</div>
	                <div class="tx2"><c:if test="${result.INTRCN_GOODS_TY eq 'G'}">단체투어</c:if><c:if test="${result.INTRCN_GOODS_TY eq 'P'}">프라이빗투어</c:if></div>
	              </div>
	            </li>
	            </c:if>
	            <c:if test="${!empty result.INTRCN_USE_TIME}">
	            <li>
	              <div class="icon_b">
	                <div class="icon_in"><img src="/images/sub/detail_icon02.png" alt=""/></div>
	                <div class="tx1">이용시간</div>
	                <div class="tx2">${result.INTRCN_USE_TIME}</div>
	              </div>
	            </li>
	            </c:if>
	            <c:if test="${!empty result.INTRCN_MEET_TIME}">
	            <li>
	              <div class="icon_b">
	                <div class="icon_in"><img src="/images/sub/detail_icon03.png" alt=""/></div>
	                <div class="tx1">집합시간</div>
	                <div class="tx2">${result.INTRCN_MEET_TIME}</div>
	              </div>
	            </li>
	            </c:if>
	            <c:if test="${!empty result.INTRCN_REQRE_TIME}">
	            <li>
	              <div class="icon_b">
	                <div class="icon_in"><img src="/images/sub/detail_icon04.png" alt=""/></div>
	                <div class="tx1">소요시간</div>
	                <div class="tx2">${result.INTRCN_REQRE_TIME}</div>
	              </div>
	            </li>
	            </c:if>
	            <c:if test="${!empty result.INTRCN_PROVD_LANG}">
	            <li>
	              <div class="icon_b">
	                <div class="icon_in"><img src="/images/sub/detail_icon05.png" alt=""/></div>
	                <div class="tx1">제공언어</div>
	                <div class="tx2">${result.INTRCN_PROVD_LANG}</div>
	              </div>
	            </li>
	            </c:if>
	            <c:if test="${!empty result.INTRCN_POSBL_AGE}">
	            <li>
	              <div class="icon_b">
	                <div class="icon_in"><img src="/images/sub/detail_icon06.png" alt=""/></div>
	                <div class="tx1">가능연령</div>
	                <div class="tx2">${result.INTRCN_POSBL_AGE}</div>
	              </div>
	            </li>
	            </c:if>
	            <c:if test="${!empty result.INTRCN_PLACE}">
	            <li>
	              <div class="icon_b">
	                <div class="icon_in"><img src="/images/sub/detail_icon07.png" alt=""/></div>
	                <div class="tx1">장소</div>
	                <div class="tx2">${result.INTRCN_PLACE}</div>
	              </div>
	            </li>
	            </c:if>
	          </ul>
	        </div>
		</c:if>
        <!--바우처-->
        <c:if test="${fn:length(lstVoucher) > 0 }">
			<div class="text_info">
				<div class="fl_tx tw_500">바우처 </div>
				<div class="fr_tx">
				<c:forEach var="item" items="${lstVoucher}" varStatus="status">
					<c:if test="${fn:length(lstVoucher) != status.index + 1 }">
		            <div class="tx_line">
					</c:if>
					<c:if test="${fn:length(lstVoucher) == status.index + 1 }">
		            <div class="tx_noline">
					</c:if>
		              <div class="fl_intx tw_400">${item.text}</div>
		              <div class="fr_intx">${item.value}</div>
		            </div>
				</c:forEach>
				</div>
			</div>
        </c:if>
		
        <!--이용안내 -->
        <c:if test="${fn:length(lstOpGuide) > 0 }">
			<div class="text_info">
				<div class="fl_tx tw_500">이용안내 </div>
				<div class="fr_tx">
				<c:forEach var="item" items="${lstOpGuide}" varStatus="status">
					<c:if test="${fn:length(lstOpGuide) != status.index + 1 }">
		            <div class="tx_line">
					</c:if>
					<c:if test="${fn:length(lstOpGuide) == status.index + 1 }">
		            <div class="tx_noline">
					</c:if>
		              <div class="fl_intx tw_400">${item.text}</div>
		              <div class="fr_intx">${item.value}</div>
		            </div>
				</c:forEach>
				</div>
			</div>
        </c:if>

        <!--기타정보 -->
        <c:if test="${fn:length(lstEtcInfo) > 0 }">
			<div class="text_info">
				<div class="fl_tx tw_500">기타정보 </div>
				<div class="fr_tx">
				<c:forEach var="item" items="${lstEtcInfo}" varStatus="status">
					<c:if test="${fn:length(lstEtcInfo) != status.index + 1 }">
		            <div class="tx_line">
					</c:if>
					<c:if test="${fn:length(lstEtcInfo) == status.index + 1 }">
		            <div class="tx_noline">
					</c:if>
		              <div class="fl_intx tw_400">${item.text}</div>
		              <div class="fr_intx">${item.value}</div>
		            </div>
				</c:forEach>
				</div>
			</div>
        </c:if>
        <!----> 
        
        <div class="review_box"> 
          <!--탭-->
          <div class="tab_box">
            <ul>
              <li class="on tab_btn1">후기(13건)</li>
              <li class="off tab_btn2">문의하기</li>
            </ul>
          </div>
          <!--//탭-->
          <div class="title_box">
            <div class="title tw_500">이용후기</div>
            <div class="star_um">총<em>10명</em></div>
            <div class="star_icon"><i class="material-icons on">star_rate</i> <i class="material-icons on">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i></div>
            <a  href="#" data-featherlight="#review_popup">
            <input type="button" class="btn" value="후기쓰기">
            </a> </div>
          <div class="tb_01_box"> 
            <!--//pc 테블 일때 -->
            <table width="100%"  class="tb_01 pc_view comf">
              <col width="5%">
              <col width="">
              <col width="15%">
              <col width="15%">
              <col width="15%">
              <tbody>
                <tr>
                  <td class="t_center">2</td>
                  <td>생애 첫dsdsdsdfsd 호핑투어</td>
                  <td>아이디 닉네임</td>
                  <td>2016-09-30</td>
                  <td><div class="star_icon"><i class="material-icons on">star_rate</i> <i class="material-icons on">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i></div></td>
                </tr>
              </tbody>
            </table>
            <!--//pc 테블 일때 --> 
            <!--모바일  일때 -->
            <table width="100%"  class="tb_01 mobile_view">
              <col width="5%">
              <col width="">
              <tbody>
                <tr>
                  <td class="t_center">2</td>
                  <td><span class="tb_font1">2016-09-30 [아이디 닉네임]</span><br>
                    생애 첫dsdsdsdfsd 호핑투어<br>
                    <div class="star_icon"><i class="material-icons on">star_rate</i> <i class="material-icons on">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i></div></td>
                </tr>
                <tr>
                  <td class="t_center">2</td>
                  <td><span class="tb_font1">2016-09-30 [아이디 닉네임]</span><br>
                    생애 첫dsdsdsdfsd 호핑투어<br>
                    <div class="star_icon"><i class="material-icons on">star_rate</i> <i class="material-icons on">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i></div></td>
                </tr>
              </tbody>
            </table>
            <!--모바일  일때 --> 
            
          </div>
        <!--하단버튼/ 페이징 -->
        <div class="bbs_bottom"> 
          <!-- 페이징 -->
          <div class="paginate">
            <div class="number"><a href="#" class="pre_end">← First</a><a href="#" class="pre">이전</a><a href="#">11</a><a href="#" class="on">12</a><a href="#">13</a><a href="#">14</a><a href="#">15</a><a href="#">16</a><a href="#">17</a><a href="#">18</a><a href="#">19</a><a href="#">20</a><a href="#" class="next">다음</a><a href="#" class="next_end">Last → </a> </div>
          </div>
          <!-- /페이징 -->
          
        </div>
        <!--//하단버튼/ 페이징 --> 
        </div>
        <!--//리뷰 --> 
        <!--상품문의 -->
        <div class="qa_box" style="display: none"> 
          <!--탭-->
          <div class="tab_box">
            <ul>
              <li class="off tab_btn1">후기(13건)</li>
              <li class="on tab_btn2">문의하기</li>
            </ul>
          </div>
          <!--//탭-->
          <div class="title_box">
            <div class="title tw_500">문의하기</div>
            <div class="star_um">총<em>10명</em></div>
            <a  href="#" data-featherlight="#pa_popup">
            <input type="button" class="btn" value="문의하기">
            </a> </div>
          <div class="tb_01_box"> 
            <!--pc 테블릿 일때 -->
            <table width="100%"  class="tb_01 pc_view">
              <col width="5%">
              <col width="">
              <col width="15%">
              <col width="15%">
              <tbody>
                <tr>
                  <td class="t_center">2</td>
                  <td>생애 첫dsdsdsdfsd 호핑투어</td>
                  <td>아이디 닉네임</td>
                  <td>2016-09-30</td>
                </tr>
                <tr>
                  <td class="t_center">2</td>
                  <td>생애 첫dsdsdsdfsd 호핑투어</td>
                  <td>아이디 닉네임</td>
                  <td>2016-09-30</td>
                </tr>
                <tr>
                  <td class="t_center">2</td>
                  <td>생애 첫dsdsdsdfsd 호핑투어</td>
                  <td>아이디 닉네임</td>
                  <td>2016-09-30</td>
                </tr>
              </tbody>
            </table>
            <!--pc 테블릿 일때 --> 
            <!--모바일  일때 -->
            <table width="100%"  class="tb_01 mobile_view">
              <col width="5%">
              <col width="">
              <tbody>
                <tr>
                  <td class="t_center">2</td>
                  <td><span class="tb_font1">2016-09-30 [아이디 닉네임]</span><br>
                    생애 첫dsdsdsdfsd 호핑투어<br>
                    <div class="star_icon"><i class="material-icons on">star_rate</i> <i class="material-icons on">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i></div></td>
                </tr>
                <tr>
                  <td class="t_center">2</td>
                  <td><span class="tb_font1">2016-09-30 [아이디 닉네임]</span><br>
                    생애 첫dsdsdsdfsd 호핑투어<br>
                    <div class="star_icon"><i class="material-icons on">star_rate</i> <i class="material-icons on">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i></div></td>
                </tr>
              </tbody>
            </table>
            <!--모바일  일때 --> 
          </div>
        <!--하단버튼/ 페이징 -->
        <div class="bbs_bottom"> 
          <!-- 페이징 -->
          <div class="paginate">
            <div class="number"><a href="#" class="pre_end">← First</a><a href="#" class="pre">이전</a><a href="#">11</a><a href="#" class="on">12</a><a href="#">13</a><a href="#">14</a><a href="#">15</a><a href="#">16</a><a href="#">17</a><a href="#">18</a><a href="#">19</a><a href="#">20</a><a href="#" class="next">다음</a><a href="#" class="next_end">Last → </a> </div>
          </div>
          <!-- /페이징 -->
          
        </div>
        <!--//하단버튼/ 페이징 --> 
        </div>
        <!--//상품문의 --> 
        
      </div>
      <div class="fl_right">
        <div class="day_box">
          <div class="title">RESERVATION
            <div class="star_box">
              <div class="star_i"><i class="material-icons off">star_rate</i> <i class="material-icons off">star_rate</i> <i class="material-icons off">star_rate</i> <i class="material-icons on">star_rate</i> <i class="material-icons on">star_rate</i> </div>
            </div>
            <div class="um">8.8</div>
          </div>
        </div>
        <div class="day_box2">
			<c:if test="${result.CL_SE ne 'S'}">
				<div id="c">
					<div id="disp">
						<div id="prev" class="nav">&larr;</div>
						<div id="month">Hello world</div>
						<div id="next" class="nav">&rarr;</div>
					</div>
					<div id="cal" ></div>
					<div id="calHelp">
						<div class="first active"><i>일정</i> <b id="sel1text">날짜선택</b></div>
					</div>
				</div>
				<!-- /#c --> 
				<!-- <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script> --> 
				<script src="/jq/calendar/js/index2.js"></script>
			</c:if>
			<c:if test="${result.CL_SE eq 'S'}">
				<div id="c">
					<div id="disp">
						<div id="prev" class="nav">&larr;</div>
						<div id="month">Hello world</div>
						<div id="next" class="nav">&rarr;</div>
					</div>
					<div id="cal" ></div>
					<div id="calHelp">
						<div class="first active"><i>출발</i> <b id="sel1text">날짜선택</b></div>
						<div class="disabled"><i>도착</i> <b id="sel2text">날짜선택</b></div>
					</div>
				</div>
				<!-- /#c --> 
				<!-- <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script> --> 
				<script src="/jq/calendar/js/index.js"></script>
			</c:if> 
		</div>
        <div class="day_box3 ">
        	<c:if test="${result.CL_SE ne 'S'}">
				<div class="input_box">
					<div class="tx1">시간</div>
					<div class="select_box"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
						<select class="w_100p">
							<option value="">시간선택</option>
							<c:forEach var="list" items="${lstTime}" varStatus="status">
								<option value="${list.TOUR_TIME}">${fn:substring(list.BEGIN_TIME,0,2)} : ${fn:substring(list.BEGIN_TIME,2,4)} ~ ${fn:substring(list.END_TIME,0,2)} : ${fn:substring(list.END_TIME,2,4)}</option>
							</c:forEach>							
						</select>
						<!--//기본 셀렉트 박스 -->
					</div>
				</div>
				<div class="input_box">
					<div class="tx1">인원</div>
					<div class="select_box"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
						<select class="w_100p" id="cmbNmpr">
							<option value="">인원선택</option>
							<c:forEach var="list" items="${lstNmpr}" varStatus="status">
								<option value="${status.index}" nmpr_sn="${list.NMPR_SN}" setup_amount="${list.SETUP_AMOUNT}" nmpr_co="${list.NMPR_CO}">${list.NMPR_CND}</option>
							</c:forEach>							
						</select>
						<!--//기본 셀렉트 박스 -->
					</div>
				</div>
        	</c:if>
        	<c:if test="${result.CL_SE eq 'S'}">
				<div class="input_box">
					<div class="tx1">객실선택</div>
					<div class="select_box"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
						<select class="w_100p" id="cmbRoom">
							<option value="">객실선택</option>
							<c:forEach var="list" items="${lstRoom}" varStatus="status">
								<option value="${status.index}" nmpr_sn="${list.NMPR_SN}" setup_amount="${list.SETUP_AMOUNT}" nmpr_co="${list.NMPR_CO}">${list.NMPR_CND}</option>
							</c:forEach>							
						</select>
						<!--//기본 셀렉트 박스 -->
					</div>
				</div>
	        	<c:if test="${fn:length(lstEat) > 0}">
				<div class="input_box">
					<div class="tx1">옵션선택</div>
					<div class="select_box"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
						<select class="w_100p" id="cmbEat">
							<option value="">옵션선택</option>
							<c:forEach var="list" items="${lstEat}" varStatus="status">
								<option value="${status.index}" nmpr_sn="${list.NMPR_SN}" setup_amount="${list.SETUP_AMOUNT}" nmpr_co="${list.NMPR_CO}">${list.NMPR_CND}</option>
							</c:forEach>							
						</select>
						<!--//기본 셀렉트 박스 -->
					</div>
				</div>
	        	</c:if>
	        	<c:if test="${fn:length(lstCheck) > 0}">
				<div class="input_box">
					<div class="tx1"></div>
					<div class="select_box"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
						<select class="w_100p" id="cmbCheck">
							<option value="">선택</option>
							<c:forEach var="list" items="${lstCheck}" varStatus="status">
								<option value="${status.index}" nmpr_sn="${list.NMPR_SN}" setup_amount="${list.SETUP_AMOUNT}" nmpr_co="${list.NMPR_CO}">${list.NMPR_CND}</option>
							</c:forEach>							
						</select>
						<!--//기본 셀렉트 박스 -->
					</div>
				</div>
	        	</c:if>
        	</c:if>
 		</div>
		<!--개수추가 -->
		<div class="day_box4" id="purchInfo">
		</div>
		<!---->
		<div class="day_box3 ">        	
			<div class="total_box">
				<div class="tx1">\ 28,227 </div>
				<div class="tx2" id="totalprice">￦ 10,000 <em>/ 1인</em> </div>
				<div class="icon"><img src="/images/sub/icon_sale.png" alt=""/> </div>
			</div>
        	<div class="btn_box" id="reservation">예약하기</div>
      	</div>
    </div>
  </div>
  <div class="sp_50 pc_view"></div>
  <div class="sp_10 mobile_view"></div>
</div>
</section>

<!-- //본문 --> 
<!--팝업 : 이용후기 -->
<div class="lightbox" id="review_popup">
  <div class="popup_com">
    <div class="title">이용후기</div>
    <div class="popup_cont">
      <div class="tb_01_box">
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="">
          <tbody>
            <tr>
              <th >이름</th>
              <td><input type="text" placeholder="" class="w_100p input_st"></td>
            </tr>
            <tr>
              <th >비밀번호</th>
              <td><input type="text" placeholder="" class="w_100p input_st"></td>
            </tr>
            <tr>
              <th >이메일</th>
              <td><input type="text" placeholder="형식에 맞게 적어주세요 (예:test@asdf.com)" class="w_100p input_st"></td>
            </tr>
            <tr>
              <th >점수</th>
              <td><div class="star_icon"><i class="material-icons on">star_rate</i> <i class="material-icons on">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i></div></td>
            </tr>
            <tr>
              <th >내용쓰기</th>
              <td><textarea name="textarea" id="textarea" class="w_100p input_st"  placeholder="" style="height: 300px"></textarea></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn"><a href="#">등록하기</a></div>
    </div>
  </div>
</div>
<!--팝업--> 

<!--팝업 : 문의하기-->
<div class="lightbox" id="pa_popup">
  <div class="popup_com">
    <div class="title">문의하기 </div>
    <div class="popup_cont">
      <div class="tb_01_box">
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="">
          <tbody>
            <tr>
              <th >이름</th>
              <td><input type="text" placeholder="" class="w_100p input_st"></td>
            </tr>
            <tr>
              <th >비밀번호</th>
              <td><input type="text" placeholder="" class="w_100p input_st"></td>
            </tr>
            <tr>
              <th >이메일</th>
              <td><input type="text" placeholder="형식에 맞게 적어주세요 (예:test@asdf.com)" class="w_100p input_st"></td>
            </tr>
            <tr>
              <th >내용쓰기</th>
              <td><textarea name="textarea" id="textarea" class="w_100p input_st"  placeholder="" style="height: 300px"></textarea></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn"><a href="#">등록하기</a></div>
    </div>
  </div>
</div>
<!--팝업-->
<!--팝업 : 1:1문의하기-->
<div class="lightbox" id="pa_popup2">
  <div class="popup_com">
    <div class="title">1:1문의하기 </div>
    <div class="popup_cont">
      <div class="tb_01_box">
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="">
          <tbody>
            <tr>
              <th >이름</th>
              <td><input type="text" placeholder="" class="w_100p input_st"></td>
            </tr>
            <tr>
              <th >비밀번호</th>
              <td><input type="text" placeholder="" class="w_100p input_st"></td>
            </tr>
            <tr>
              <th >이메일</th>
              <td><input type="text" placeholder="형식에 맞게 적어주세요 (예:test@asdf.com)" class="w_100p input_st"></td>
            </tr>
            <tr>
              <th >내용쓰기</th>
              <td><textarea name="textarea" id="textarea" class="w_100p input_st"  placeholder="" style="height: 300px"></textarea></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn"><a href="#">등록하기</a></div>
    </div>
  </div>
</div>
<!--팝업-->
</body>