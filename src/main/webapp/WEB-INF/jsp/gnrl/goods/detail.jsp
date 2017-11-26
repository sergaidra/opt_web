<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
	<!-- Link Swiper's CSS -->
	<link rel="stylesheet" href="<c:url value='/jq/swiper/dist/css/swiper.min.css'/>">
	
	<!--달력-->
	<link rel="stylesheet" href="<c:url value='/jq/calendar/css/normalize.css'/>">
	<link rel="stylesheet" href="<c:url value='/jq/calendar/css/style.css'/>">
	<link href='https://fonts.googleapis.com/css?family=Roboto:400,300,300italic,400italic,500,700,100,100italic' rel='stylesheet' type='text/css'>
	<!--//달력-->
	<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script> --> 
	<!-- 날짜선택 -->	
	<script src="/jq/time/build/jquery.datetimepicker.full.js"></script> 

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
var roomInfo = { "days" : 0, "room" : null, "eat" : [], "check" : []};
var selectDt = { "startDt" : null, "endDt" : null };
var lstSchdul = [];
var flight_sn = "";

<c:forEach var="list" items="${lstSchdul}">
	lstSchdul.push({"BEGIN_DE" : "${list.BEGIN_DE}", "END_DE" : "${list.END_DE}" });
</c:forEach>



$(function() {
	$.datetimepicker.setLocale('en');
	
	$("#reservation").click(function () {
		// 예약
		var purchs_amount = 0;
		var origin_amount = 0;
		var tour_de = "";
		var tour_time = "";
		var chkin_de = "";
		var chckt_de = "";
		var nmprList = [];

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
			
			//roomInfo.days
			
			if(roomInfo.room != null) {
				purchs_amount += roomInfo.room.price;
				origin_amount += roomInfo.room.originPrice;
				var item = { "setup_se" : roomInfo.room.setup_se, "nmpr_sn" : roomInfo.room.nmpr_sn, "nmpr_co" : roomInfo.room.nmpr_cnt, "amount" : roomInfo.room.price };
				nmprList.push(item);
			}
			for(var cnt = 0; cnt < roomInfo.eat.length; cnt++) {
				purchs_amount += roomInfo.eat[cnt].price;
				origin_amount += roomInfo.eat[cnt].originPrice;
				var item = { "setup_se" : roomInfo.eat[cnt].setup_se, "nmpr_sn" : roomInfo.eat[cnt].nmpr_sn, "nmpr_co" : roomInfo.eat[cnt].nmpr_cnt, "amount" : roomInfo.eat[cnt].price };
				nmprList.push(item);
			}
			for(var cnt = 0; cnt < roomInfo.check.length; cnt++) {
				purchs_amount += roomInfo.check[cnt].price;
				origin_amount += roomInfo.check[cnt].originPrice;
				var item = { "setup_se" : roomInfo.check[cnt].setup_se, "nmpr_sn" : roomInfo.check[cnt].nmpr_sn, "nmpr_co" : "1", "amount" : roomInfo.check[cnt].price };
				nmprList.push(item);
			}
			chkin_de = selectDt.startDt;
			chckt_de = selectDt.endDt;
		} else {
			if(selectDt.startDt == null) {
				alert('일정을 선택하세요.');
				return;
			}
			if(!$('#cmbTime').val()) {
				alert('시간을 선택하세요.');
				return;				
			}
			// to do
			if($('#hidClSe').val() == 'P' && flight_sn == "") {
				if(confirm('픽업/드랍 서비스는 항공편을 반드시 입력해야 합니다.')) {
					getFlight();
				}
				return false;
			}
			if(lstNmpr.length == 0) {
				alert('인원을 선택하세요.');
				return;
			}
			
			for(var cnt = 0; cnt < lstNmpr.length; cnt++) {
				purchs_amount += lstNmpr[cnt].price;
				origin_amount += lstNmpr[cnt].originPrice;
				var item = { "setup_se" : lstNmpr[cnt].setup_se, "nmpr_sn" : lstNmpr[cnt].nmpr_sn, "nmpr_co" : lstNmpr[cnt].nmprCnt, "amount" : lstNmpr[cnt].price };
				nmprList.push(item);
			}
			
			tour_de = selectDt.startDt;
			tour_time = $('#cmbTime').val();
		}
		
		var url = "<c:url value='/cart/addAction'/>";
		var param = {};
		param.hidGoodsCode = "${goods_code}";
		param.PURCHS_AMOUNT = purchs_amount;
		param.ORIGIN_AMOUNT = origin_amount;
		param.TOUR_DE = tour_de;
		param.TOUR_TIME = tour_time;
		param.CHKIN_DE = chkin_de;
		param.CHCKT_DE = chckt_de;
		param.flight_sn = flight_sn;
		param.nmprList = nmprList;

		$.ajax({
	        url : url,
	        type: "post",
	        dataType : "json",
	        async: "true",
	        contentType: "application/json; charset=utf-8",
	        data : JSON.stringify( param ),
	        success : function(data,status,request){
				if(data.result == "0") {
					alert("예약되었습니다. 장바구니로 이동합니다.");
					document.location.href = "<c:url value='/cart/list'/>";
				} else if(data.result == "-2") {
					alert("로그인이 필요합니다.");
					$(".login").click();
				} else if(data.result == "9") {
					alert(data.message);
				} else{
					alert("작업을 실패하였습니다.");
				}	        	
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
		var setup_se = $("#cmbNmpr option:selected").attr("setup_se");
		var dscnt_rate = $("#cmbNmpr option:selected").attr("dscnt_rate");

		var isFind = false;
		for(var cnt = 0; cnt < lstNmpr.length; cnt++) {
			if(lstNmpr[cnt].nmpr_sn == nmpr_sn) {
				lstNmpr[cnt].nmprCnt++;
				isFind = true;
				break;
			}
		}
		if(isFind == false) {
			var item = { "text" : text, "setup_se" : setup_se, "nmpr_sn" : nmpr_sn, "setup_amount" : setup_amount
						, "nmpr_co" : nmpr_co, "nmprCnt" : 1, "dscnt_rate" : dscnt_rate };
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
			var setup_se = $("#cmbRoom option:selected").attr("setup_se");
			var max_nmpr_co = $("#cmbRoom option:selected").attr("max_nmpr_co");
			var adit_nmpr_amount = $("#cmbRoom option:selected").attr("adit_nmpr_amount");
			var dscnt_rate = $("#cmbRoom option:selected").attr("dscnt_rate");
			var nmpr_cnt = nmpr_co;
			
			var item = { "text" : text, "setup_se" : setup_se, "nmpr_sn" : nmpr_sn, "setup_amount" : setup_amount
					, "nmpr_co" : nmpr_co, "nmpr_cnt" : nmpr_cnt, "max_nmpr_co" : max_nmpr_co
					, "adit_nmpr_amount" : adit_nmpr_amount, "dscnt_rate" : dscnt_rate };
			roomInfo.room = item;		
			displayRoom();
		}
	});

	$("#cmbEat").change(function () {
		if($("#cmbEat option:selected").val() == "") {
			//removeEat();
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
			
			var nmpr_sn = $("#cmbEat option:selected").attr("nmpr_sn");
			for(var cnt = 0; cnt < roomInfo.eat.length; cnt++) {
				if(roomInfo.eat[cnt].nmpr_sn == nmpr_sn)
					return false;
			}
			var text = $("#cmbEat option:selected").text();
			var setup_amount = $("#cmbEat option:selected").attr("setup_amount");
			var nmpr_co = $("#cmbEat option:selected").attr("nmpr_co");
			var setup_se = $("#cmbEat option:selected").attr("setup_se");
			var max_nmpr_co = $("#cmbEat option:selected").attr("max_nmpr_co");
			var dscnt_rate = $("#cmbEat option:selected").attr("dscnt_rate");
			var nmpr_cnt = roomInfo.room.nmpr_co;

			var item = { "text" : text, "setup_se" : setup_se, "nmpr_sn" : nmpr_sn, "setup_amount" : setup_amount
					, "nmpr_co" : nmpr_co, "nmpr_cnt" : nmpr_cnt, "max_nmpr_co" : max_nmpr_co, "dscnt_rate" : dscnt_rate };
			roomInfo.eat.push(item);		
			displayRoom();
		}

	});

	$("#cmbCheck").change(function () {
		if($("#cmbCheck option:selected").val() == "") {
			//removeCheck();
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

			var nmpr_sn = $("#cmbCheck option:selected").attr("nmpr_sn");
			for(var cnt = 0; cnt < roomInfo.check.length; cnt++) {
				if(roomInfo.check[cnt].nmpr_sn == nmpr_sn)
					return false;
			}
			var text = $("#cmbCheck option:selected").text();
			var nmpr_sn = $("#cmbCheck option:selected").attr("nmpr_sn");
			var setup_amount = $("#cmbCheck option:selected").attr("setup_amount");
			var nmpr_co = $("#cmbCheck option:selected").attr("nmpr_co");
			var setup_se = $("#cmbCheck option:selected").attr("setup_se");
			var dscnt_rate = $("#cmbCheck option:selected").attr("dscnt_rate");

			var item = { "text" : text, "setup_se" : setup_se, "nmpr_sn" : nmpr_sn, "setup_amount" : setup_amount
					, "nmpr_co" : nmpr_co, "dscnt_rate" : dscnt_rate };
			roomInfo.check.push(item);	
			displayRoom();
		}
	});
	
	goSearchReview(1);
	goSearchOpinion(1);
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
	var originTotalPrice = 0;
		
	if(roomInfo.days != 0) {
		if(roomInfo.room != null) {
			var nmpr_sn = roomInfo.room.nmpr_sn;
			var nmpr_cnt = roomInfo.room.nmpr_cnt;
			var max_nmpr_co = roomInfo.room.max_nmpr_co;
			var nmpr_co = roomInfo.room.nmpr_co;
			var adit_nmpr_amount = roomInfo.room.adit_nmpr_amount;
			var dscnt_rate = roomInfo.room.dscnt_rate;

			var price = roomInfo.days * roomInfo.room.setup_amount * dscnt_rate;
			var originPrice = roomInfo.days * roomInfo.room.setup_amount;

			if(!isNaN(max_nmpr_co)) {
				if(!isNaN(adit_nmpr_amount)) {
					if(Number(nmpr_co) < Number(nmpr_cnt)) {
						var diff = Number(nmpr_cnt) - Number(nmpr_co);
						price += diff * Number(adit_nmpr_amount) * roomInfo.days;	// 추가 정원은 할인 제외
						originPrice += diff * Number(adit_nmpr_amount) * roomInfo.days;
					}
				}
			}

			var html = $("<div class='um_box'></div>");
			var fl_text = $("<div class='fl_text'>" + roomInfo.room.text + "</div>");
			var fl_total = $("<div class='fl_total'><em>" + roomInfo.days + "</em>박 <em>\\ " + numberWithCommas(price) + "</em></div>");
			$(fl_text).append(fl_total);
			//var fr_updown = $("<div class='fr_updown'><div class='um_d' style='float:right;' onclick='removeRoom(" + nmpr_sn + ");'>-</div></div>");
			var fr_updown = $("<div class='fr_updown'><div class='um_d' onclick='minusRoom(" + nmpr_sn + ");'>-</div><div class='um_input'><input type='text' value='" + nmpr_cnt + "' readonly></div><div class='um_d' onclick='plusRoom(" + nmpr_sn + ");'>+</div></div>");
			
			roomInfo.room.price = price;
			roomInfo.room.originPrice = originPrice;
			
			$(html).append(fl_text);
			$(html).append(fr_updown);
			
			$("#purchInfo").append($(html));
			totalprice += price;
			originTotalPrice += originPrice;
		}

		for(var cnt = 0; cnt < roomInfo.eat.length; cnt++) {
			var nmpr_sn = roomInfo.eat[cnt].nmpr_sn;
			var nmpr_cnt = roomInfo.eat[cnt].nmpr_cnt;
			var dscnt_rate = roomInfo.eat[cnt].dscnt_rate;
			var price = roomInfo.eat[cnt].nmpr_cnt * roomInfo.days * roomInfo.eat[cnt].setup_amount * dscnt_rate;
			var originPrice = roomInfo.eat[cnt].nmpr_cnt * roomInfo.days * roomInfo.eat[cnt].setup_amount;

			var html = $("<div class='um_box'></div>");
			var fl_text = $("<div class='fl_text'>" + roomInfo.eat[cnt].text + "</div>");
			var fl_total = $("<div class='fl_total'><em>" + nmpr_cnt + "</em>인 <em>" + roomInfo.days + "</em>박 <em>\\ " + numberWithCommas(price) + "</em></div>");
			$(fl_text).append(fl_total);
			var fr_updown = $("<div class='fr_updown'><div class='um_d' onclick='minusEat(" + nmpr_sn + ");'>-</div><div class='um_input'><input type='text' value='" + nmpr_cnt + "' readonly></div><div class='um_d' onclick='plusEat(" + nmpr_sn + ");'>+</div></div>");

			roomInfo.eat[cnt].price = price;
			roomInfo.eat[cnt].originPrice = originPrice;

			$(html).append(fl_text);
			$(html).append(fr_updown);
			
			$("#purchInfo").append($(html));
			totalprice += price;
			originTotalPrice += originPrice;
		}
		
		for(var cnt = 0; cnt < roomInfo.check.length; cnt++) {
			var nmpr_sn = roomInfo.check[cnt].nmpr_sn;
			var dscnt_rate = roomInfo.check[cnt].dscnt_rate;
			var price = roomInfo.check[cnt].setup_amount * 1 * dscnt_rate;
			var originPrice = roomInfo.check[cnt].setup_amount * 1;
			
			var html = $("<div class='um_box'></div>");
			var fl_text = $("<div class='fl_text'></div>");
			var fl_total = $("<div class='fl_total'><em>" + roomInfo.check[cnt].text + "</em> <em>\\ " + numberWithCommas(price) + "</em></div>");
			$(fl_text).append(fl_total);
			var fr_updown = $("<div class='fr_updown'><div class='um_d' style='float:right;' onclick='removeCheck(" + nmpr_sn + ");'>-</div></div>");

			roomInfo.check[cnt].price = price;
			roomInfo.check[cnt].originPrice = originPrice;

			$(html).append(fl_text);
			$(html).append(fr_updown);
			
			$("#purchInfo").append($(html));
			totalprice += price;
			originTotalPrice += originPrice;
		}
	}

	$("#totalprice").text("￦ " + numberWithCommas(totalprice));
	$("#originTotalPrice").text("￦ " + numberWithCommas(originTotalPrice));
	
	if(totalprice == originTotalPrice) {
		$("#originTotalPrice").hide();
		$("#imgSale").hide();
	} else {
		$("#imgSale").show();
		$("#originTotalPrice").show();
	}
}

function removeRoom() {
	roomInfo.room = null;
	roomInfo.eat = [];
	roomInfo.check = null;
	$("#cmbRoom").val("");
	$("#cmbEat").val("");
	$("#cmbCheck").val("");
	displayRoom();
}

function removeEat() {
	roomInfo.eat = [];
	$("#cmbEat").val("");
	displayRoom();
}

function removeCheck(nmpr_sn) {
	//roomInfo.check = [];
	$("#cmbCheck").val("");
	for(var cnt = 0; cnt < roomInfo.check.length; cnt++) {
		if(roomInfo.check[cnt].nmpr_sn == nmpr_sn) {
			roomInfo.check.splice(cnt, 1);
			break;
		}
	}	
	displayRoom();
}

function plusRoom(nmpr_sn) {
	if(!isNaN(roomInfo.room.max_nmpr_co)) {
		var max = Number(roomInfo.room.max_nmpr_co);
		if(max < Number(roomInfo.room.nmpr_cnt) + 1) {
			alert("최대 " + max + "인 입니다.");
			return false;
		} else {
			roomInfo.room.nmpr_cnt++;
		}
	}
	displayRoom();
}

function minusRoom(nmpr_sn) {
	roomInfo.room.nmpr_cnt--;
	if(roomInfo.room.nmpr_cnt == 0)
		removeRoom();
	else
		displayRoom();
}

function plusEat(nmpr_sn) {
	if(!isNaN(roomInfo.room.max_nmpr_co)) {
		var max = Number(roomInfo.room.max_nmpr_co);
		for(var cnt = 0; cnt < roomInfo.eat.length; cnt++) {
			if(roomInfo.eat[cnt].nmpr_sn == nmpr_sn) {
				if(max < Number(roomInfo.eat[cnt].nmpr_cnt) + 1) {
					alert("최대 " + max + "인 입니다.");
					return false;
				} else {
					roomInfo.eat[cnt].nmpr_cnt++;
				}
			}
		}
	}
	displayRoom();
}
function minusEat(nmpr_sn) {
	for(var cnt = 0; cnt < roomInfo.eat.length; cnt++) {
		if(roomInfo.eat[cnt].nmpr_sn == nmpr_sn) {
			roomInfo.eat[cnt].nmpr_cnt--;
			if(roomInfo.eat[cnt].nmpr_cnt == 0)
				roomInfo.eat.splice(cnt, 1);
		}
	}
	displayRoom();
}

function displayNmpr() {
	$("#purchInfo").empty();
	var totalprice = 0;
	var originTotalPrice = 0;

	for(var cnt = 0; cnt < lstNmpr.length; cnt++) {
		var nmpr_sn = lstNmpr[cnt].nmpr_sn;
		var plus = $("<span onclick='plusNmpr(" + nmpr_sn + ");'>+</span>");
		var minus = $("<span onclick='minusNmpr(" + nmpr_sn + ");'>-</span>");
		var dscnt_rate = lstNmpr[cnt].dscnt_rate;
		var price = lstNmpr[cnt].nmprCnt * lstNmpr[cnt].setup_amount * dscnt_rate;
		var originPrice = lstNmpr[cnt].nmprCnt * lstNmpr[cnt].setup_amount;

		var html = $("<div class='um_box'></div>");
		var fl_text = $("<div class='fl_text'></div>");
		var fl_total = $("<div class='fl_total'>" + lstNmpr[cnt].text + " <em>" + lstNmpr[cnt].nmprCnt + "</em>명 <em>\\ " + numberWithCommas(price) + "</em></div>");
		$(fl_text).append(fl_total);
		var fr_updown = $("<div class='fr_updown'><div class='um_d' onclick='minusNmpr(" + nmpr_sn + ");'>-</div><div class='um_input'><input type='text' value='" + lstNmpr[cnt].nmprCnt + "' readonly></div><div class='um_d' onclick='plusNmpr(" + nmpr_sn + ");'>+</div></div>");
		
		lstNmpr[cnt].price = price;
		lstNmpr[cnt].originPrice = originPrice;

		$(html).append(fl_text);
		$(html).append(fr_updown);

		$("#purchInfo").append($(html));
		totalprice += price;
		originTotalPrice += originPrice;
	}
	
	$("#totalprice").text("￦ " + numberWithCommas(totalprice));
	$("#originTotalPrice").text("￦ " + numberWithCommas(originTotalPrice));
	
	if(totalprice == originTotalPrice) {
		$("#originTotalPrice").hide();
		$("#imgSale").hide();
	} else {
		$("#imgSale").show();
		$("#originTotalPrice").show();
	}
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

function goSearchReview(pageNo) {
	var url = "<c:url value='/goods/getReview'/>";
	$("#tblReviewPC tbody").empty(); 
	$("#tblReviewMobile tbody").empty(); 
	$("#pagingReview").empty(); 
	
	var param = {};
	param.hidPage = pageNo;
	param.goods_code = "${goods_code}";
	$("#hidReviewPage").val(pageNo);
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
        	for(var cnt = 0; cnt < data.list.length; cnt++) {
        		{
            		var tr = $("<tr></tr>");
            		var td1 = $("<td class='t_center'>" + (Number(data.startIdx) + cnt) + "</td>");
            		var td2 = $("<td>" + data.list[cnt].REVIEW_CN + "</td>");
            		var td3 = $("<td>" + data.list[cnt].USER_NM + "</td>");
            		var td4 = $("<td>" + data.list[cnt].WRITNG_DT + "</td>");
            		var td5 = $("<td></td>");
            		var td5sub = $("<div class='star_icon'></div>");
            		
            		for(var cnt2 = 0; cnt2 < 5; cnt2++) {
            			var item = null;
            			
            			if(cnt2 + 1 <= Number(data.list[cnt].REVIEW_SCORE))
            				item = $("<i class='material-icons on'>star_rate</i>");
            			else
            				item = $("<i class='material-icons'>star_rate</i>");
            				
                		$(td5sub).append(item);
            		}
            		
            		$(td5).append(td5sub);        		
            		$(tr).append(td1);
            		$(tr).append(td2);
            		$(tr).append(td3);
            		$(tr).append(td4);
            		$(tr).append(td5);

    	        	$("#tblReviewPC tbody").append(tr);        
        		}
        		{
        			var tr = $("<tr></tr>");
        			var td1 = $("<td class='t_center'>" + (Number(data.startIdx) + cnt) + "</td>");
        			var td2 = $("<td></td>");
        			var td2span = $("<span class='tb_font1'>" + data.list[cnt].WRITNG_DT + " [" + data.list[cnt].USER_NM + "]</span><br>" + data.list[cnt].REVIEW_CN + "<br>");
            		var td2sub = $("<div class='star_icon'></div>");
            		
            		for(var cnt2 = 0; cnt2 < 5; cnt2++) {
            			var item = null;
            			
            			if(cnt2 + 1 <= Number(data.list[cnt].REVIEW_SCORE))
            				item = $("<i class='material-icons on'>star_rate</i>");
            			else
            				item = $("<i class='material-icons'>star_rate</i>");
            				
                		$(td2sub).append(item);
            		}
            		$(td2).append(td2span);
            		$(td2).append(td2sub);
            		$(tr).append(td1);
            		$(tr).append(td2);

    	        	$("#tblReviewMobile tbody").append(tr);
        		}
        	}
        	$("#spnReviewCount").text(data.totalCount);
        	$("#spnReviewCount2").text(data.totalCount);

        	// 페이징 처리
        	var totalCount = Number(data.totalCount);
        	var pageNo = Number($("#hidReviewPage").val());
        	var blockSize = Number($("#blockSize").val());
        	var pageSize = Number($("#pageSize").val());
        	
        	// 첫 페이지 검색
        	var startPageNo = Math.floor((pageNo - 1) / blockSize + 1);
        	var totalPageCnt = Math.ceil(totalCount / pageSize);
        	
        	if(startPageNo > 1) {
        		$("#pagingReview").append("<a href='javascript:goSearchReview(1);' class='pre_end'>← First</a>");
        		$("#pagingReview").append("<a href='javascript:goSearchReview(" + (startPageNo - 1) + ");' class='pre'>이전</a>");
        	}

        	for(var cnt = 0; cnt < blockSize; cnt++) {
        		var page = startPageNo + cnt;
        		if(page > totalPageCnt)
        			break;
        		if(page == pageNo)
        			$("#pagingReview").append("<a href='javascript:goSearchReview(" + page + ");' class='on'>" + page + "</a>");
        		else
        			$("#pagingReview").append("<a href='javascript:goSearchReview(" + page + ");'>" + page + "</a>");
        	}
        	
        	if(startPageNo + blockSize <= totalPageCnt) {
        		$("#pagingReview").append("<a href='javascript:goSearchReview(" + (startPageNo + blockSize) + ");' class='next'>다음</a>");
        		$("#pagingReview").append("<a href='javascript:goSearchReview(" + totalPageCnt + ");' class='next_end'>Last → </a>");
        	}
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});			

}

function saveOpinion() {
	if($.trim($(".featherlight #opinion_sj").val()) == "") {
		alert("제목을 입력해주세요.");
		$(".featherlight #opinion_sj").focus();
		return false;
	}
	if($.trim($(".featherlight #opinion_cn").val()) == "") {
		alert("내용을 입력해주세요.");
		$(".featherlight #opinion_cn").focus();
		return false;
	}
	
	var url = "<c:url value='/goods/saveOpinion'/>";
	
	var param = {};
	param.opinion_sj = $(".featherlight #opinion_sj").val();
	param.opinion_cn = $(".featherlight #opinion_cn").val();
	param.goods_code = "${goods_code}";
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
			if(data.result == "0") {	        	
				alert("등록되었습니다.");
				$.featherlight.close();
				goSearchOpinion(1);
			} else if(data.result == "-2") {
				alert("로그인이 필요합니다.");
				$(".login").click();
			} else if(data.result == "9") {
				alert(data.message);
			} else{
				alert("작업을 실패하였습니다.");
			}	        	
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});			
}

function goSearchOpinion(pageNo) {
	var url = "<c:url value='/goods/getOpinion'/>";
	$("#tblOpinionPC tbody").empty(); 
	$("#tblOpinionMobile tbody").empty(); 
	$("#pagingOpinion").empty(); 
	
	var param = {};
	param.hidPage = pageNo;
	param.goods_code = "${goods_code}";
	$("#hidOpinionPage").val(pageNo);
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
        	for(var cnt = 0; cnt < data.list.length; cnt++) {
        		{
            		var tr = $("<tr></tr>");
            		var td1 = $("<td class='t_center'>" + (Number(data.startIdx) + cnt) + "</td>");
            		var td2 = $("<td>" + data.list[cnt].OPINION_SJ + "</td>");
            		var td3 = $("<td>" + data.list[cnt].USER_NM + "</td>");
            		var td4 = $("<td>" + data.list[cnt].WRITNG_DT + "</td>");

            		$(tr).append(td1);
            		$(tr).append(td2);
            		$(tr).append(td3);
            		$(tr).append(td4);

    	        	$("#tblOpinionPC tbody").append(tr);        
        		}
        		{
        			var tr = $("<tr></tr>");
        			var td1 = $("<td class='t_center'>" + (Number(data.startIdx) + cnt) + "</td>");
        			var td2 = $("<td></td>");
        			var td2span = $("<span class='tb_font1'>" + data.list[cnt].WRITNG_DT + " [" + data.list[cnt].USER_NM + "]</span><br>" + data.list[cnt].OPINION_SJ);

            		$(td2).append(td2span);
            		$(tr).append(td1);
            		$(tr).append(td2);

    	        	$("#tblOpinionMobile tbody").append(tr);
        		}
        	}
        	
        	$("#spnOpinionCount").text(data.totalCount);
        	// 페이징 처리
        	var totalCount = Number(data.totalCount);
        	var pageNo = Number($("#hidOpinionPage").val());
        	var blockSize = Number($("#blockSize").val());
        	var pageSize = Number($("#pageSize").val());
        	
        	// 첫 페이지 검색
        	var startPageNo = Math.floor((pageNo - 1) / blockSize + 1);
        	var totalPageCnt = Math.ceil(totalCount / pageSize);
        	
        	if(startPageNo > 1) {
        		$("#pagingOpinion").append("<a href='javascript:goSearchOpinion(1);' class='pre_end'>← First</a>");
        		$("#pagingOpinion").append("<a href='javascript:goSearchOpinion(" + (startPageNo - 1) + ");' class='pre'>이전</a>");
        	}

        	for(var cnt = 0; cnt < blockSize; cnt++) {
        		var page = startPageNo + cnt;
        		if(page > totalPageCnt)
        			break;
        		if(page == pageNo)
        			$("#pagingOpinion").append("<a href='javascript:goSearchOpinion(" + page + ");' class='on'>" + page + "</a>");
        		else
        			$("#pagingOpinion").append("<a href='javascript:goSearchOpinion(" + page + ");'>" + page + "</a>");
        	}
        	
        	if(startPageNo + blockSize <= totalPageCnt) {
        		$("#pagingOpinion").append("<a href='javascript:goSearchOpinion(" + (startPageNo + blockSize) + ");' class='next'>다음</a>");
        		$("#pagingOpinion").append("<a href='javascript:goSearchOpinion(" + totalPageCnt + ");' class='next_end'>Last → </a>");
        	}
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});			

}

function getFlight() {
	var url = "<c:url value='/cmmn/getCurrentFlight'/>";
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( {  } ),
        success : function(data,status,request){
			if(data.result == "0") {
				if(data.data.length > 0) {
					
				}
				$.featherlight($('#pa_airpopup'), {});
				$('.featherlight .some_class').datetimepicker( {
					format:'Y-m-d H:i',
					inline:true,
					step:5
				});

			} else if(data.result == "-2") {
				alert("로그인이 필요합니다.");
				$(".login").click();
			} else if(data.result == "9") {
				alert(data.message);
			} else{
				alert("작업을 실패하였습니다.");
			}	        	
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});
}

function inputAir() {
	var url = "<c:url value='/cmmn/saveFlight'/>";
	
	var param = {};
	param.flight_sn = flight_sn;
	param.dtrmc_flight = $(".featherlight #DTRMC_FLIGHT").val();
	param.dtrmc_start_arprt_code = $(".featherlight #DTRMC_START_ARPRT_CODE").val();
	param.dtrmc_start_cty = "";
	param.dtrmc_start_dt = $(".featherlight #DTRMC_START_DT").val();
	
	param.dtrmc_arvl_arprt_code = $(".featherlight #DTRMC_ARVL_ARPRT_CODE").val();
	param.dtrmc_arvl_cty = "";
	param.dtrmc_arvl_dt = $(".featherlight #DTRMC_ARVL_DT").val();

	param.hmcmg_flight = $(".featherlight #HMCMG_FLIGHT").val();
	param.hmcmg_start_arprt_code = $(".featherlight #HMCMG_START_ARPRT_CODE").val();
	param.hmcmg_start_cty = "";
	param.hmcmg_start_dt = $(".featherlight #HMCMG_START_DT").val();

	param.hmcmg_arvl_arprt_code = $(".featherlight #HMCMG_ARVL_ARPRT_CODE").val();
	param.hmcmg_arvl_cty = "";
	param.hmcmg_arvl_dt = $(".featherlight #HMCMG_ARVL_DT").val();

	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
			if(data.result == "0") {	   
				alert("저장되었습니다.");
				flight_sn = data.data;
				$.featherlight.close();
			} else if(data.result == "-2") {
				alert("로그인이 필요합니다.");
				$(".login").click();
			} else if(data.result == "9") {
				alert(data.message);
			} else{
				alert("작업을 실패하였습니다.");
			}	        	
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});	
}
</script>
	
</head>

<body>

<input type="hidden" id="ACT_LA" value="${result.ACT_LA}">
<input type="hidden" id="ACT_LO" value="${result.ACT_LO}">
<input type="hidden" id="hidClSe" value="${result.CL_SE}">

<input type="hidden" id="hidReviewPage" name="hidReviewPage" value="1">
<input type="hidden" id="hidOpinionPage" name="hidOpinionPage" value="1">
<input type="hidden" id="pageSize" name="pageSize" value="5">
<input type="hidden" id="blockSize" name="blockSize" value="5">	

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
              <div class="slider_t2">${result.GOODS_INTRCN_SIMPL}</div>
            </div>
          </div>
          <div class="hit_box"><i class="material-icons">&#xE87E;</i><span data-featherlight="#pa_airpopup">25</span></div>
          <div class="share_box"><i class="material-icons">&#xE80D;</i></div>
          <div class="qa_btn"><a href="#" data-featherlight="#pa_popup2">1:1문의하기</a></div>
          <!-- Swiper -->
          <div class="swiper-container">
            <div class="swiper-wrapper">
				<c:forEach var="result" items="${lstFile}" varStatus="status">
	              <div class="swiper-slide"><img src="<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}&file_sn=${result.FILE_SN}" width="100%" alt=""/></div>
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
		<div class="text_info" style="font-size:14px;">
			${result.GOODS_INTRCN}
		</div>
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
              <li class="on tab_btn1">후기(<span id="spnReviewCount"></span>건)</li>
              <li class="off tab_btn2">문의하기</li>
            </ul>
          </div>
          <!--//탭-->
          <div class="title_box">
            <div class="title tw_500">이용후기</div>
            <div class="star_um">총<em>${review_count}명</em></div>
            <div class="star_icon">
            	<c:forEach begin="1" end="5"  var="x">
	            	<i class="material-icons <c:if test="${x <= ceil_review_score}">on</c:if>">star_rate</i> 
            	</c:forEach>
            </div>
            <a  href="#" data-featherlight="#review_popup">
            <!-- <input type="button" class="btn" value="후기쓰기"> -->
            </a> </div>
          <div class="tb_01_box"> 
            <!--//pc 테블 일때 -->
            <table width="100%"  class="tb_01 pc_view comf" id="tblReviewPC">
              <col width="5%">
              <col width="">
              <col width="15%">
              <col width="15%">
              <col width="15%">
              <tbody>
              </tbody>
            </table>
            <!--//pc 테블 일때 --> 
            <!--모바일  일때 -->
            <table width="100%"  class="tb_01 mobile_view" id="tblReviewMobile">
              <col width="5%">
              <col width="">
              <tbody>
              </tbody>
            </table>
            <!--모바일  일때 --> 
            
          </div>
        <!--하단버튼/ 페이징 -->
        <div class="bbs_bottom"> 
          <!-- 페이징 -->
          <div class="paginate">
            <div class="number"  id="pagingReview">
            </div>
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
              <li class="off tab_btn1">후기(<span id="spnReviewCount2"></span>건)</li>
              <li class="on tab_btn2">문의하기</li>
            </ul>
          </div>
          <!--//탭-->
          <div class="title_box">
            <div class="title tw_500">문의하기</div>
            <div class="star_um">총<em><span id="spnOpinionCount"></span>명</em></div>
            <a  href="#" data-featherlight="#pa_popup">
            <input type="button" class="btn" value="문의하기">
            </a> </div>
          <div class="tb_01_box"> 
            <!--pc 테블릿 일때 -->
            <table width="100%"  class="tb_01 pc_view" id="tblOpinionPC">
              <col width="5%">
              <col width="">
              <col width="15%">
              <col width="15%">
              <tbody>
              </tbody>
            </table>
            <!--pc 테블릿 일때 --> 
            <!--모바일  일때 -->
            <table width="100%"  class="tb_01 mobile_view" id="tblOpinionMobile">
              <col width="5%">
              <col width="">
              <tbody>
              </tbody>
            </table>
            <!--모바일  일때 --> 
          </div>
        <!--하단버튼/ 페이징 -->
        <div class="bbs_bottom"> 
          <!-- 페이징 -->
          <div class="paginate">
            <div class="number" id="pagingOpinion">
			</div>
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
              <div class="star_i">
            	<c:forEach begin="1" end="5"  var="x">
	            	<i class="material-icons <c:if test="${x <= ceil_review_score}">on</c:if><c:if test="${x > ceil_review_score}">off</c:if>">star_rate</i> 
            	</c:forEach>              	
              </div>
            </div>
            <div class="um">${review_score}</div>
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
						<div class="first active"><i>입실</i> <b id="sel1text">날짜선택</b></div>
						<div class="disabled"><i>퇴실</i> <b id="sel2text">날짜선택</b></div>
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
						<select class="w_100p" id="cmbTime">
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
								<option value="${status.index}" nmpr_sn="${list.NMPR_SN}" setup_amount="${list.SETUP_AMOUNT}" nmpr_co="${list.NMPR_CO}" setup_se="${list.SETUP_SE}" adit_nmpr_amount="${list.ADIT_NMPR_AMOUNT}" dscnt_rate="${list.DSCNT_RATE}">${list.NMPR_CND}</option>
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
								<option value="${status.index}" nmpr_sn="${list.NMPR_SN}" setup_amount="${list.SETUP_AMOUNT}" nmpr_co="${list.NMPR_CO}" setup_se="${list.SETUP_SE}" max_nmpr_co="${list.MAX_NMPR_CO}" adit_nmpr_amount="${list.ADIT_NMPR_AMOUNT}" dscnt_rate="${list.DSCNT_RATE}">
									${list.NMPR_CND}
									<c:if test="${list.NMPR_CO != null}" >
										(기준인원 ${list.NMPR_CO}명)
									</c:if>									
								</option>
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
								<option value="${status.index}" nmpr_sn="${list.NMPR_SN}" setup_amount="${list.SETUP_AMOUNT}" nmpr_co="${list.NMPR_CO}" setup_se="${list.SETUP_SE}" max_nmpr_co="${list.MAX_NMPR_CO}" adit_nmpr_amount="${list.ADIT_NMPR_AMOUNT}" dscnt_rate="${list.DSCNT_RATE}">${list.NMPR_CND}</option>
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
								<option value="${status.index}" nmpr_sn="${list.NMPR_SN}" setup_amount="${list.SETUP_AMOUNT}" nmpr_co="${list.NMPR_CO}" setup_se="${list.SETUP_SE}" adit_nmpr_amount="${list.ADIT_NMPR_AMOUNT}" dscnt_rate="${list.DSCNT_RATE}">${list.NMPR_CND}</option>
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
				<div class="tx1" id="originTotalPrice"></div>
				<div class="tx2" id="totalprice"></div>
				<div class="icon"><img id="imgSale" src="/images/sub/icon_sale.png" alt="" style="display:none;"/> </div>
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
              <th >제목</th>
              <td><input type="text" placeholder="" class="w_100p input_st" id="opinion_sj" name="opinion_cn"></td>
            </tr>
            <tr>
              <th >내용쓰기</th>
              <td><textarea name="opinion_cn" id="opinion_cn" class="w_100p input_st"  placeholder="" style="height: 300px"></textarea></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn"><a href="javascript:saveOpinion();">등록하기</a></div>
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
              <th >제목</th>
              <td><input type="text" placeholder="" class="w_100p input_st" id="opinion_sj" name="opinion_cn"></td>
            </tr>
            <tr>
              <th >내용쓰기</th>
              <td><textarea name="opinion_cn" id="opinion_cn" class="w_100p input_st"  placeholder="" style="height: 300px"></textarea></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn"><a href="javascript:saveOpinion();">등록하기</a></div>
    </div>
  </div>
</div>
<!--팝업-->

<!--팝업 : 1:1문의하기-->
<div class="lightbox" id="pa_airpopup">
  <div class="popup_com" style="width:900px;">
    <div class="title">항공편 입력</div>
    <div class="popup_cont">
      <div class="tb_01_box">
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="40%">
          <col width="40%">
          <tbody>
            <tr>
              <th >출국정보</th><th >출발</th><th >도착</th>
            </tr>
            <tr>
              <td>공항</td>
              <td>
              	<select id="DTRMC_START_ARPRT_CODE" name="DTRMC_START_ARPRT_CODE">
              		<option value="">선택</option>
              		<c:forEach var="list" items="${lstFlight}">
	              		<option value="${list.ARPRT_CODE}">${list.ARPRT_NM}</option>
              		</c:forEach>
              	</select>
              </td>
              <td>
              	<select id="DTRMC_ARVL_ARPRT_CODE" name="DTRMC_ARVL_ARPRT_CODE">
              		<option value="">선택</option>
              		<c:forEach var="list" items="${lstFlight}">
	              		<option value="${list.ARPRT_CODE}">${list.ARPRT_NM}</option>
              		</c:forEach>
              	</select>
              </td>
            </tr>
            <tr>
              <td>일자</td>
              <td><input class="some_class" id="DTRMC_START_DT" name="DTRMC_START_DT"></td>
              <td><input class="some_class" id="DTRMC_ARVL_DT" name="DTRMC_ARVL_DT"></td>
            </tr>
            <tr>
              <td>항공편명</td>
              <td colspan="2"><input type="text"  id="DTRMC_FLIGHT" name="DTRMC_FLIGHT"></td>
            </tr>
          </tbody>
        </table>
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="40%">
          <col width="40%">
          <tbody>
            <tr>
              <th >입국정보</th><th >출발</th><th >도착</th>
            </tr>
            <tr>
              <td>공항</td>
              <td>
              	<select id="HMCMG_START_ARPRT_CODE" name="HMCMG_START_ARPRT_CODE">
              		<option value="">선택</option>
              		<c:forEach var="list" items="${lstFlight}">
	              		<option value="${list.ARPRT_CODE}">${list.ARPRT_NM}</option>
              		</c:forEach>
              	</select>
              </td>
              <td>
              	<select id="HMCMG_ARVL_ARPRT_CODE" name="HMCMG_ARVL_ARPRT_CODE">
              		<option value="">선택</option>
              		<c:forEach var="list" items="${lstFlight}">
	              		<option value="${list.ARPRT_CODE}">${list.ARPRT_NM}</option>
              		</c:forEach>
              	</select>
              </td>
            </tr>
            <tr>
              <td>일자</td>
              <td><input class="some_class" id="HMCMG_START_DT" name="HMCMG_START_DT"></td>
              <td><input class="some_class" id="HMCMG_ARVL_DT" name="HMCMG_ARVL_DT"></td>
            </tr>
            <tr>
              <td>항공편명</td>
              <td colspan="2"><input type="text" id="HMCMG_FLIGHT" name="HMCMG_FLIGHT"></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn">
      	<a href="javascript:inputAir();">저장</a>
      </div>
    </div>
  </div>
</div>
<!--팝업-->
</body>