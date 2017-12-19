<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>


	<!-- Attach our CSS -->
  	<link rel="stylesheet" href="<c:url value='/jq/popup2/reveal.css'/>">	

	<!-- Attach necessary scripts -->
	<!-- <script type="text/javascript" src="<c:url value='/jq/popup2/jquery-1.4.4.min.js'/>"></script> -->
  	<script type="text/javascript">
		//jQuery.noConflict();
		//var j$ = jQuery;
	</script>
	<!-- <script type="text/javascript" src="http://code.jquery.com/jquery-1.6.min.js"></script> -->
	<script type="text/javascript" src="<c:url value='/jq/popup2/jquery.reveal.js'/>"></script>
	
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

//var lstNmpr = [];
var optionInfo = { "days" : 0, "room" : null, "eat" : [], "check" : [], "nmpr_P" : [], "nmpr_V" : [], "nmpr_S" : []};
var selectDt = { "startDt" : null, "endDt" : null };
var lstSchdul = [];
var detail_flight_sn = "";
var lstOption = [];

<c:forEach var="list" items="${lstSchdul}">
	lstSchdul.push({"BEGIN_DE" : "${list.BEGIN_DE}", "END_DE" : "${list.END_DE}" });
</c:forEach>
console.log(lstSchdul);
<c:forEach var="list" items="${lstNmpr}">
lstOption.push({"nmpr_sn" : "${list.NMPR_SN}", "setup_amount" : "${list.SETUP_AMOUNT}", "nmpr_co" : "${list.NMPR_CO}" , "setup_se" : "${list.SETUP_SE}", "adit_nmpr_amount" : "${list.ADIT_NMPR_AMOUNT}", "dscnt_rate" : "${list.DSCNT_RATE}", "fixed_at" : "${list.FIXED_AT}", "max_nmpr_co" : "${list.MAX_NMPR_CO}", "unit_nm" : "${list.UNIT_NM}", "nmpr_cnd" : "${list.NMPR_CND}" });
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
		var goods_nm = $("#goods_nm").val();

		// 밸리데이션 체크	
		if($('#hidClSe').val() == 'S') {
			if(optionInfo.days == 0) {
				alert("기간을 선택하세요.");
				return;
			}
			if(optionInfo.room == null) {
				alert("객실을 선택하세요.");
				return;
			}
			
			//optionInfo.days
			
			if(optionInfo.room != null) {
				purchs_amount += optionInfo.room.price;
				origin_amount += optionInfo.room.originPrice;
				var item = { "setup_se" : optionInfo.room.setup_se, "nmpr_sn" : optionInfo.room.nmpr_sn, "nmpr_co" : optionInfo.room.nmpr_cnt, "amount" : optionInfo.room.price };
				nmprList.push(item);
			}
			for(var cnt = 0; cnt < optionInfo.eat.length; cnt++) {
				purchs_amount += optionInfo.eat[cnt].price;
				origin_amount += optionInfo.eat[cnt].originPrice;
				var item = { "setup_se" : optionInfo.eat[cnt].setup_se, "nmpr_sn" : optionInfo.eat[cnt].nmpr_sn, "nmpr_co" : optionInfo.eat[cnt].nmpr_cnt, "amount" : optionInfo.eat[cnt].price };
				nmprList.push(item);
			}
			for(var cnt = 0; cnt < optionInfo.check.length; cnt++) {
				purchs_amount += optionInfo.check[cnt].price;
				origin_amount += optionInfo.check[cnt].originPrice;
				var item = { "setup_se" : optionInfo.check[cnt].setup_se, "nmpr_sn" : optionInfo.check[cnt].nmpr_sn, "nmpr_co" : "1", "amount" : optionInfo.check[cnt].price };
				nmprList.push(item);
			}
			for(var cnt = 0; cnt < optionInfo.nmpr_S.length; cnt++) {
				purchs_amount += optionInfo.nmpr_S[cnt].price;
				origin_amount += optionInfo.nmpr_S[cnt].originPrice;
				var item = { "setup_se" : optionInfo.nmpr_S[cnt].setup_se, "nmpr_sn" : optionInfo.nmpr_S[cnt].nmpr_sn, "nmpr_co" : optionInfo.nmpr_S[cnt].nmpr_cnt, "amount" : optionInfo.nmpr_S[cnt].price };
				nmprList.push(item);
			}
			chkin_de = selectDt.startDt;
			chckt_de = selectDt.endDt;
		} else if ($('#hidClSe').val() == 'T') {
			if(selectDt.startDt == null) {
				alert('일정을 선택하세요.');
				return;
			}
			if(optionInfo.nmpr_P.length == 0) {
				alert('인원을 선택하세요.');
				return;
			}
			
			for(var cnt = 0; cnt < optionInfo.nmpr_P.length; cnt++) {
				purchs_amount += optionInfo.nmpr_P[cnt].price;
				origin_amount += optionInfo.nmpr_P[cnt].originPrice;
				var item = { "setup_se" : optionInfo.nmpr_P[cnt].setup_se, "nmpr_sn" : optionInfo.nmpr_P[cnt].nmpr_sn, "nmpr_co" : optionInfo.nmpr_P[cnt].nmprCnt, "amount" : optionInfo.nmpr_P[cnt].price };
				nmprList.push(item);
			}

			for(var cnt = 0; cnt < optionInfo.nmpr_V.length; cnt++) {
				purchs_amount += optionInfo.nmpr_V[cnt].price;
				origin_amount += optionInfo.nmpr_V[cnt].originPrice;
				var item = { "setup_se" : optionInfo.nmpr_V[cnt].setup_se, "nmpr_sn" : optionInfo.nmpr_V[cnt].nmpr_sn, "nmpr_co" : optionInfo.nmpr_V[cnt].nmprCnt, "amount" : optionInfo.nmpr_V[cnt].price };
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
			if(goods_nm.indexOf("픽업") > -1 || goods_nm.indexOf("드랍") > -1) {
				if($('#hidClSe').val() == 'P' && detail_flight_sn == "") {
					if(confirm('픽업/드랍 서비스는 항공편을 반드시 입력해야 합니다.')) {
						flightView();
					}
					return;
				}
			}
			if(optionInfo.nmpr_P.length == 0) {
				alert('인원을 선택하세요.');
				return;
			}
			
			for(var cnt = 0; cnt < optionInfo.nmpr_P.length; cnt++) {
				purchs_amount += optionInfo.nmpr_P[cnt].price;
				origin_amount += optionInfo.nmpr_P[cnt].originPrice;
				var item = { "setup_se" : optionInfo.nmpr_P[cnt].setup_se, "nmpr_sn" : optionInfo.nmpr_P[cnt].nmpr_sn, "nmpr_co" : optionInfo.nmpr_P[cnt].nmprCnt, "amount" : optionInfo.nmpr_P[cnt].price };
				nmprList.push(item);
			}

			for(var cnt = 0; cnt < optionInfo.nmpr_V.length; cnt++) {
				purchs_amount += optionInfo.nmpr_V[cnt].price;
				origin_amount += optionInfo.nmpr_V[cnt].originPrice;
				var item = { "setup_se" : optionInfo.nmpr_V[cnt].setup_se, "nmpr_sn" : optionInfo.nmpr_V[cnt].nmpr_sn, "nmpr_co" : optionInfo.nmpr_V[cnt].nmprCnt, "amount" : optionInfo.nmpr_V[cnt].price };
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
		param.flight_sn = detail_flight_sn;
		param.nmprList = nmprList;

		if(!confirm("예약하겠습니까?"))
			return;
		
		$.ajax({
	        url : url,
	        type: "post",
	        dataType : "json",
	        async: "true",
	        contentType: "application/json; charset=utf-8",
	        data : JSON.stringify( param ),
	        success : function(data,status,request){
				if(data.result == "0") {
					if(confirm("예약되었습니다.\n장바구니로 이동하겠습니까?")) {
						document.location.href = "<c:url value='/cart/list'/>";
					} else {
						history.back();
					}
				} else if(data.result == "-2") {
					alert("로그인이 필요합니다.");
					go_login();
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
	
	$("#cmbNmpr_P").change(function () {
		if($("#cmbNmpr_P option:selected").val() == "")
			return;
		
		var nmpr_sn = $("#cmbNmpr_P").val();
		for(var cnt = 0; cnt < optionInfo.nmpr_P.length; cnt++) {
			if(optionInfo.nmpr_P[cnt].nmpr_sn == nmpr_sn)
				return;
		}

		var originItem = getNmprInfo("P", nmpr_sn);
		var item = null;
		if(originItem != null) {
			item = $.extend(true, {}, originItem);
			item.text = $("#cmbNmpr_P option:selected").text();
			item.nmpr_cnt = item.nmpr_co;
			
			if(item.fixed_at == "Y")
				item.nmpr_cnt = 1;
			
			optionInfo.nmpr_P.push(item);					
		}

		$("#cmbNmpr_P").val("");
		displayNmpr();
	});

	$("#cmbNmpr_V").change(function () {
		if($("#cmbNmpr_V option:selected").val() == "")
			return;
		
		var nmpr_sn = $("#cmbNmpr_V").val();
		for(var cnt = 0; cnt < optionInfo.nmpr_V.length; cnt++) {
			if(optionInfo.nmpr_V[cnt].nmpr_sn == nmpr_sn)
				return;
		}

		var originItem = getNmprInfo("V", nmpr_sn);
		var item = null;
		if(originItem != null) {
			item = $.extend(true, {}, originItem);
			item.text = $("#cmbNmpr_V option:selected").text();
			item.nmpr_cnt = item.nmpr_co;
			
			if(item.fixed_at == "Y")
				item.nmpr_cnt = 1;
			
			optionInfo.nmpr_V.push(item);					
		}

		$("#cmbNmpr_V").val("");
		displayNmpr();
	});

	$("#cmbRoom").change(function () {
		if($("#cmbRoom option:selected").val() == "") {
			removeRoom();
		} else {
			if(validationSelectRoom("cmbRoom", "R") == false)
				return;
			var originItem = getNmprInfo("R", $("#cmbRoom").val());
			var item = null;
			if(originItem != null) {
				item = $.extend(true, {}, originItem);
				item.text = $("#cmbRoom option:selected").text();
				item.nmpr_cnt = item.nmpr_co;
				optionInfo.room = item;		
			}
			
			displayRoom();
		}
	});

	$("#cmbEat").change(function () {
		if($("#cmbEat option:selected").val() == "") {
		} else {
			if(validationSelectRoom("cmbEat", "E") == false)
				return;
			var nmpr_sn = $("#cmbEat").val();
			for(var cnt = 0; cnt < optionInfo.eat.length; cnt++) {
				if(optionInfo.eat[cnt].nmpr_sn == nmpr_sn)
					return;
			}
			var originItem = getNmprInfo("E", nmpr_sn);
			var item = null;
			if(originItem != null) {
				item = $.extend(true, {}, originItem);
				item.text = $("#cmbEat option:selected").text();
				item.nmpr_cnt = optionInfo.room.nmpr_co;
				
				if(item.fixed_at == "Y")
					item.nmpr_cnt = 1;
				
				optionInfo.eat.push(item);					
			}

			displayRoom();
		}

	});

	$("#cmbCheck").change(function () {
		if($("#cmbCheck option:selected").val() == "") {
			//removeCheck();
		} else {
			if(validationSelectRoom("cmbCheck", "C") == false)
				return;
			var nmpr_sn = $("#cmbCheck").val();
			for(var cnt = 0; cnt < optionInfo.check.length; cnt++) {
				if(optionInfo.check[cnt].nmpr_sn == nmpr_sn)
					return;
			}
			
			var originItem = getNmprInfo("C", nmpr_sn);
			var item = null;
			if(originItem != null) {
				item = $.extend(true, {}, originItem);
				item.text = $("#cmbCheck option:selected").text();
				item.nmpr_cnt = item.nmpr_co;
				
				if(item.fixed_at == "Y")
					item.nmpr_cnt = 1;
				
				optionInfo.check.push(item);					
			}
			
			displayRoom();
		}
	});
	
	$("#cmbNmpr_S").change(function () {
		if($("#cmbNmpr_S option:selected").val() == "") {
		} else {
			if(validationSelectRoom("cmbNmpr_S", "P") == false)
				return;

			var nmpr_sn = $("#cmbNmpr_S").val();
			for(var cnt = 0; cnt < optionInfo.nmpr_S.length; cnt++) {
				if(optionInfo.nmpr_S[cnt].nmpr_sn == nmpr_sn)
					return;
			}

			var originItem = getNmprInfo("P", nmpr_sn);
			var item = null;
			if(originItem != null) {
				item = $.extend(true, {}, originItem);
				item.text = $("#cmbNmpr_S option:selected").text();
				item.nmpr_cnt = item.nmpr_co;
				
				if(item.fixed_at == "Y")
					item.nmpr_cnt = 1;
				
				optionInfo.nmpr_S.push(item);					
			}

			displayRoom();
		}
	});
	
	goSearchReview(1);
	goSearchOpinion(1);
});

function getNmprInfo(setup_se, nmpr_sn) {
	for(var cnt = 0; cnt < lstOption.length; cnt++) {
		if(lstOption[cnt].setup_se == setup_se && lstOption[cnt].nmpr_sn == nmpr_sn) {
			return lstOption[cnt];
		}
	}
	return null;
}

function validationSelectRoom(objId, mode) {
	if(optionInfo.days == 0) {
		alert("기간을 선택하세요.");
		$("#" + objId).val("");
		return false;
	}
	if(mode != "R") {
		if(optionInfo.room == null) {
			alert("객실을 선택하세요.");
			$("#" + objId).val("");
			return false;
		}
	}
	
	return true;
}

function setDateRange() {
	if(selectDt.startDt == null || selectDt.endDt == null) {
		optionInfo.days = 0;
	} else {
		var startDt = selectDt.startDt.split("-");
		var endDt = selectDt.endDt.split("-");
		var days = (new Date(endDt[0], endDt[1] - 1, endDt[2]) - new Date(startDt[0], startDt[1] - 1, startDt[2]).getTime())/1000/60/60/24;
		optionInfo.days = days;
	}
	displayRoom();
}

function calcPrice(item, multiply) {
	var nmpr_cnt = item.nmpr_cnt;	// 선택 개수
	var nmpr_co = item.nmpr_co;		// 정원
	var max_nmpr_co = item.max_nmpr_co;		// 최대정원
	var adit_nmpr_amount = item.adit_nmpr_amount;		// 추가인원 금액
	var setup_amount = item.setup_amount;		// 정원까지 금액
	var dscnt_rate = item.dscnt_rate;	// 할인가
	var fixed_at = item.fixed_at;	// 정가구분
	
	var price = 0;
	var originPrice = 0;
	
	if(fixed_at == "Y") {
		// 금액(SETUP_AMOUT)만큼 금액이 추가됨
		// 단, 정원, 최대정원, 추가인원금액이 설정되어 있으면 정원초과인원은 추가인원금액만큼 금액 추가	
		if(nmpr_co == "" || max_nmpr_co == "" || adit_nmpr_amount == "")
			originPrice = nmpr_cnt * setup_amount;
		else {
			var nNmpr_co = Number(nmpr_co);
			var nAdit_nmpr_amount = Number(adit_nmpr_amount);
			for(var cnt = 0; cnt < nmpr_cnt; cnt++) {
				if(cnt < nNmpr_co)
					originPrice += Number(setup_amount);
				else
					originPrice += Number(adit_nmpr_amount);					
			}
		}
	} else {
		// 정원(NMPR_CO), 최대정원(MAX_NMPR_CO), 추가인원금액(ADIT_NMPR_AMOUNT) 반드시 입력
		// 옵션 선택하면 1~정원(NMPR_CO)까지는 금액(SETUP_AMOUT)까지, 정원을 초과하면 추가인원금액(ADIT_NMPR_AMOUNT)만큼 금액 추가
		var nNmpr_co = Number(nmpr_co);
		var nAdit_nmpr_amount = Number(adit_nmpr_amount);
		originPrice = Number(setup_amount);
		for(var cnt = nNmpr_co; cnt < nmpr_cnt; cnt++) {
			originPrice += Number(adit_nmpr_amount);					
		}
	}
	
	item.originPrice = originPrice * multiply;
	item.price = item.originPrice * dscnt_rate;
}

function displayRoom() {
	$("#purchInfo").empty();
	var totalprice = 0;
	var originTotalPrice = 0;
		
	if(optionInfo.days != 0) {
		if(optionInfo.room != null) {
			var item = optionInfo.room;

			calcPrice(item, optionInfo.days);

			var html = $("<div class='um_box'></div>");
			var fl_text = $("<div class='fl_text'>" + item.text + "</div>");
			var fl_total = $("<div class='fl_total'><em>" + optionInfo.days + "</em>박 <em>\\ " + numberWithCommas(item.price) + "</em></div>");
			$(fl_text).append(fl_total);
			var fr_updown = $("<div class='fr_updown'><div class='um_d' onclick='minusRoom(" + item.nmpr_sn + ");'>-</div><div class='um_input'><input type='text' value='" + item.nmpr_cnt + "' readonly></div><div class='um_d' onclick='plusRoom(" + item.nmpr_sn + ");'>+</div></div>");
			
			$(html).append(fl_text);
			$(html).append(fr_updown);
			
			$("#purchInfo").append($(html));
			totalprice += item.price;
			originTotalPrice += item.originPrice;
		}

		for(var cnt = 0; cnt < optionInfo.eat.length; cnt++) {
			var item = optionInfo.eat[cnt];
			
			calcPrice(item, optionInfo.days);

			var html = $("<div class='um_box'></div>");
			var fl_text = $("<div class='fl_text'>" + item.text + "</div>");
			var fl_total = $("<div class='fl_total'><em>" + item.nmpr_cnt + "</em>인 <em>" + optionInfo.days + "</em>식 <em>\\ " + numberWithCommas(item.price) + "</em></div>");
			$(fl_text).append(fl_total);
			var fr_updown = $("<div class='fr_updown'><div class='um_d' onclick='minusOption(" + item.nmpr_sn + ", \"E\");'>-</div><div class='um_input'><input type='text' value='" + item.nmpr_cnt + "' readonly></div><div class='um_d' onclick='plusOption(" + item.nmpr_sn + ", \"E\");'>+</div></div>");

			$(html).append(fl_text);
			$(html).append(fr_updown);
			
			$("#purchInfo").append($(html));
			totalprice += item.price;
			originTotalPrice += item.originPrice;
		}
		
		for(var cnt = 0; cnt < optionInfo.check.length; cnt++) {
			var item = optionInfo.check[cnt];
			
			calcPrice(item, 1);
			
			var html = $("<div class='um_box'></div>");
			var fl_text = $("<div class='fl_text'>" + item.text + "</div>");
			var fl_total = $("<div class='fl_total'><em></em> <em>\\ " + numberWithCommas(item.price) + "</em></div>");
			$(fl_text).append(fl_total);
			var fr_updown = $("<div class='fr_updown'><div class='um_d' style='float:right;' onclick='removeCheck(" + item.nmpr_sn + ");'>-</div></div>");

			$(html).append(fl_text);
			$(html).append(fr_updown);
			
			$("#purchInfo").append($(html));
			totalprice += item.price;
			originTotalPrice += item.originPrice;
		}
		
		for(var cnt = 0; cnt < optionInfo.nmpr_S.length; cnt++) {
			var item = optionInfo.nmpr_S[cnt];
			
			calcPrice(item, 1);
			
			var html = $("<div class='um_box'></div>");
			var fl_text = $("<div class='fl_text'>" + item.text + "</div>");
			var fl_total = $("<div class='fl_total'><em>" + item.nmpr_cnt + "</em>" + item.unit_nm + " <em>\\ " + numberWithCommas(item.price) + "</em></div>");
			$(fl_text).append(fl_total);
			var fr_updown = $("<div class='fr_updown'><div class='um_d' onclick='minusOption(" + item.nmpr_sn + ", \"S\");'>-</div><div class='um_input'><input type='text' value='" + item.nmpr_cnt + "' readonly></div><div class='um_d' onclick='plusOption(" + item.nmpr_sn + ", \"S\");'>+</div></div>");

			$(html).append(fl_text);
			$(html).append(fr_updown);
			
			$("#purchInfo").append($(html));
			totalprice += item.price;
			originTotalPrice += item.originPrice;
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
	optionInfo.room = null;
	optionInfo.eat = [];
	optionInfo.check = [];
	$("#cmbRoom").val("");
	$("#cmbEat").val("");
	$("#cmbCheck").val("");
	displayRoom();
}

function removeCheck(nmpr_sn) {
	$("#cmbCheck").val("");
	for(var cnt = 0; cnt < optionInfo.check.length; cnt++) {
		if(optionInfo.check[cnt].nmpr_sn == nmpr_sn) {
			optionInfo.check.splice(cnt, 1);
			break;
		}
	}	
	displayRoom();
}

function plusRoom(nmpr_sn) {
	if(!isNaN(optionInfo.room.max_nmpr_co)) {
		var max = Number(optionInfo.room.max_nmpr_co);
		if(max < Number(optionInfo.room.nmpr_cnt) + 1) {
			alert("최대 " + max + "인 입니다.");
			return ;
		} else {
			optionInfo.room.nmpr_cnt++;
		}
	}
	displayRoom();
}

function minusRoom(nmpr_sn) {
	optionInfo.room.nmpr_cnt--;
	if(optionInfo.room.nmpr_cnt == 0)
		removeRoom();
	else
		displayRoom();
}

function plusOption(nmpr_sn, mode) {
	var lst = null;
	
	if(mode == "E")
		lst = optionInfo.eat;
	else if(mode == "S")
		lst = optionInfo.nmpr_S;
	else if(mode == "P")
		lst = optionInfo.nmpr_P;
	else if(mode == "V")
		lst = optionInfo.nmpr_V;
	
	for(var cnt = 0; cnt < lst.length; cnt++) {
		if(lst[cnt].nmpr_sn == nmpr_sn) {
			if(lst[cnt].max_nmpr_co == "") {
				lst[cnt].nmpr_cnt++;
			} else {
				var max = Number(lst[cnt].max_nmpr_co);
				if(!isNaN(max)) {
					if(max < Number(lst[cnt].nmpr_cnt) + 1) {
						alert("최대 " + max + lst[cnt].unit_nm + " 입니다.");
						return;
					} else {
						lst[cnt].nmpr_cnt++;
					}
				} else {
					lst[cnt].nmpr_cnt++;
				}
			}
			break;
		}
	}

	if(mode == "E" || mode == "S")
		displayRoom();
	else
		displayNmpr();
}

function minusOption(nmpr_sn, mode) {
	var lst = null;
	
	if(mode == "E")
		lst = optionInfo.eat;
	else if(mode == "S")
		lst = optionInfo.nmpr_S;
	else if(mode == "P")
		lst = optionInfo.nmpr_P;
	else if(mode == "V")
		lst = optionInfo.nmpr_V;

	for(var cnt = 0; cnt < lst.length; cnt++) {
		if(lst[cnt].nmpr_sn == nmpr_sn) {
			lst[cnt].nmpr_cnt--;
			if(lst[cnt].nmpr_cnt == 0)
				lst.splice(cnt, 1);
		}
	}
	
	if(mode == "E" || mode == "S")
		displayRoom();
	else
		displayNmpr();
}


function displayNmpr() {
	$("#purchInfo").empty();
	var totalprice = 0;
	var originTotalPrice = 0;

	for(var cnt = 0; cnt < optionInfo.nmpr_P.length; cnt++) {
		var item = optionInfo.nmpr_P[cnt];

		calcPrice(item, 1);

		var html = $("<div class='um_box'></div>");
		var fl_text = $("<div class='fl_text'>" + item.text + "</div>");
		var fl_total = $("<div class='fl_total'><em>" + item.nmpr_cnt + "</em>" + item.unit_nm + " <em>\\ " + numberWithCommas(item.price) + "</em></div>");
		$(fl_text).append(fl_total);
		var fr_updown = $("<div class='fr_updown'><div class='um_d' onclick='minusOption(" + item.nmpr_sn + ", \"P\");'>-</div><div class='um_input'><input type='text' value='" + item.nmpr_cnt + "' readonly></div><div class='um_d' onclick='plusOption(" + item.nmpr_sn + ", \"P\");'>+</div></div>");
		
		$(html).append(fl_text);
		$(html).append(fr_updown);

		$("#purchInfo").append($(html));
		totalprice += item.price;
		originTotalPrice += item.originPrice;
	}

	for(var cnt = 0; cnt < optionInfo.nmpr_V.length; cnt++) {
		var item = optionInfo.nmpr_V[cnt];

		calcPrice(item, 1);

		var html = $("<div class='um_box'></div>");
		var fl_text = $("<div class='fl_text'>" + item.text + "</div>");
		var fl_total = $("<div class='fl_total'><em>" + item.nmpr_cnt + "</em>" + item.unit_nm + " <em>\\ " + numberWithCommas(item.price) + "</em></div>");
		$(fl_text).append(fl_total);
		var fr_updown = $("<div class='fr_updown'><div class='um_d' onclick='minusOption(" + item.nmpr_sn + ", \"V\");'>-</div><div class='um_input'><input type='text' value='" + item.nmpr_cnt + "' readonly></div><div class='um_d' onclick='plusOption(" + item.nmpr_sn + ", \"V\");'>+</div></div>");
		
		$(html).append(fl_text);
		$(html).append(fr_updown);

		$("#purchInfo").append($(html));
		totalprice += item.price;
		originTotalPrice += item.originPrice;
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


function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

var isMap = false;
function initMap() {
	if(isMap == true)
		return;
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

function goSearchOpinion(pageNo) {
	var url = "<c:url value='/cs/getOpinion'/>";
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
        	var rowCnt = 0;
        	for(var cnt = 0; cnt < data.list.length; cnt++) {
        		{
            		var tr = null;
            		if(data.list[cnt].DEPTH == 1) {
                		if(data.list[cnt].CHILDCNT == 0 && data.list[cnt].WRITNG_ID == "${esntl_id}") {
                    		tr = $("<tr onclick='viewOpinion(" + data.list[cnt].OPINION_SN + ");' style='cursor:pointer;'></tr>");
                		} else {
                    		tr = $("<tr onclick='showOpinion(" + data.list[cnt].OPINION_SN + ", 0);' style='cursor:pointer;'></tr>");
                		}            			
            		} else {
                		if(data.list[cnt].WRITNG_ID == "${esntl_id}") {
                    		tr = $("<tr onclick='viewOpinion(" + data.list[cnt].OPINION_SN + ");' style='cursor:pointer;'></tr>");
                		} else {
                    		tr = $("<tr onclick='showOpinion(" + data.list[cnt].OPINION_SN + ", 0);' style='cursor:pointer;'></tr>");
                		}            			
            		}
            		var td1 = null;
            		var td2 = null;
            		if(data.list[cnt].DEPTH == 1) {
                		td1 = $("<td class='t_center'>" + (Number(data.startIdx) + rowCnt) + "</td>");
                		td2 = $("<td>" + data.list[cnt].OPINION_SJ + "</td>");
            		} else {
                		td1 = $("<td class='t_center'></td>");
                		td2 = $("<td>&nbsp;&nbsp;→ " + data.list[cnt].OPINION_SJ + "</td>");
            		}
            		var td3 = $("<td>" + data.list[cnt].USER_NM + "</td>");
            		var td4 = $("<td>" + data.list[cnt].WRITNG_DT + "</td>");
					var td5 = null;
            		if(data.list[cnt].DEPTH == 1) {
                		if(data.list[cnt].CHILDCNT > 0) {
                    		td5 = $("<td><div class=\"listin_btn1\">답변완료</div ></td>");
    					} else {
                    		td5 = $("<td><div class=\"listin_btn2\">문의접수</div ></td>");
    					}
            		} else {
            			td5 = $("<td></td>");
            		}
            		
            		$(tr).append(td1);
            		$(tr).append(td2);
            		$(tr).append(td3);
            		$(tr).append(td4);
            		$(tr).append(td5);

    	        	$("#tblOpinionPC tbody").append(tr);        
    	        	var tr2 = $("<tr style='display:none;' id='trOpinion_" + data.list[cnt].OPINION_SN + "'><td></td></tr>");
    	        	var td2_1 = $("<td colspan='4'>내용 : </td>");
    	        	$(td2_1).append(data.list[cnt].OPINION_CN);
    	        	$(tr2).append(td2_1);
    	        	$("#tblOpinionPC tbody").append(tr2);        
        		}
        		{
            		var tr = null;
            		if(data.list[cnt].DEPTH == 1) {
                		if(data.list[cnt].CHILDCNT == 0 && data.list[cnt].WRITNG_ID == "${esntl_id}") {
                    		tr = $("<tr onclick='viewOpinion(" + data.list[cnt].OPINION_SN + ");' style='cursor:pointer;'></tr>");
                		} else {
                    		tr = $("<tr onclick='showOpinion(" + data.list[cnt].OPINION_SN + ", 1);' style='cursor:pointer;'></tr>");
                		}            			
            		} else {
                		if(data.list[cnt].WRITNG_ID == "${esntl_id}") {
                    		tr = $("<tr onclick='viewOpinion(" + data.list[cnt].OPINION_SN + ");' style='cursor:pointer;'></tr>");
                		} else {
                    		tr = $("<tr onclick='showOpinion(" + data.list[cnt].OPINION_SN + ", 1);' style='cursor:pointer;'></tr>");
                		}            			
            		}        			
        			var tr1 = null;
        			var tr2 = null;
        			var td2span = null;
            		if(data.list[cnt].DEPTH == 1) {
            			var divHtml = "";
                		if(data.list[cnt].CHILDCNT > 0) {
                			divHtml = "<div class=\"listin_btn1\" style=\"float:right;\">답변완료</div >";
    					} else {
    						divHtml = "<div class=\"listin_btn2\" style=\"float:right;\">문의접수</div >";
    					}

            			td1 = $("<td class='t_center'>" + (Number(data.startIdx) + rowCnt) + "</td>");
            			td2 = $("<td></td>");
            			td2span = $("<span class='tb_font1'>" + data.list[cnt].WRITNG_DT + " [" + data.list[cnt].USER_NM + "]"  + divHtml + "</span><br><span>" + data.list[cnt].OPINION_SJ + "</span>");

            		} else {
            			td1 = $("<td class='t_center'></td>");
            			td2 = $("<td></td>");
            			td2span = $("<span class='tb_font1'>" + data.list[cnt].WRITNG_DT + " [" + data.list[cnt].USER_NM + "]</span><br><span>" + data.list[cnt].OPINION_SJ + "</span>");
            		}

            		$(td2).append(td2span);
            		$(tr).append(td1);
            		$(tr).append(td2);

    	        	$("#tblOpinionMobile tbody").append(tr);
    	        	
    	        	var tr2 = $("<tr style='display:none;' id='trOpinionM_" + data.list[cnt].OPINION_SN + "'><td></td></tr>");
    	        	var td2_1 = $("<td>내용 : </td>");
    	        	$(td2_1).append(data.list[cnt].OPINION_CN);
    	        	$(tr2).append(td2_1);
    	        	$("#tblOpinionMobile tbody").append(tr2);        
        		}
        		if(data.list[cnt].DEPTH == 1) {
            		rowCnt++;
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

function showOpinion(opinion_sn, mode) {
	if(mode == 0)
		$("#trOpinion_" + opinion_sn).show();
	else
		$("#trOpinionM_" + opinion_sn).show();
}

function viewOpinion(opinion_sn) {
	var goods_code = "${goods_code}";
	$.featherlight('/cs/popupOpinion?opinion_sn=' + opinion_sn + '&goods_code=' + goods_code + '&callback=saveOpinionComplete', {});
}

function saveOpinionComplete() {
	goSearchOpinion(1);
}

</script>
	
</head>

<body>

<input type="hidden" id="ACT_LA" value="${result.ACT_LA}">
<input type="hidden" id="ACT_LO" value="${result.ACT_LO}">
<input type="hidden" id="hidClSe" value="${result.CL_SE}">
<input type="hidden" id="tour_days" value="${result.TOUR_DAYS}">


<input type="hidden" id="hidReviewPage" name="hidReviewPage" value="1">
<input type="hidden" id="hidOpinionPage" name="hidOpinionPage" value="1">
<input type="hidden" id="pageSize" name="pageSize" value="5">
<input type="hidden" id="blockSize" name="blockSize" value="5">	

<input type="hidden" id="goods_nm" name="goods_nm" value="${result.GOODS_NM}">
<section>

<div id="container">
  <div class="sp_50 pc_view"></div>
  <div class="sp_10 mobile_view"></div>
  <div class="inner2_2">
    <div class="good_route">
      <div class="route"><em>${result.CL_NM}</em>  ${result.GOODS_NM}</div>
      <c:if test="${back_goodslist == 'Y' }">
	  	<a href="javascript:window.history.back();" class="backbtn"><i class="material-icons">&#xE241;</i> 선택 상품 목록보기</a>
	  </c:if>
    </div>  
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
		  <div class="hot_box">
		  	<c:if test="${result.HOTDEAL_AT == 'Y'}">
		  	<img src="/images/com/hot.png" alt=""/>
		  	</c:if>
		  	<c:if test="${result.RECOMEND_AT == 'Y'}">
		  	<img src="/images/com/recom.png" alt=""/>
		  	</c:if>
		  </div>
			<div class="hit_box"><i class="material-icons">&#xE87E;</i><span>${wish_count}</span></div>
          <div class="share_box"> <a  href="#" data-featherlight="#share"><i class="material-icons">&#xE80D;</i> </a></div>
          <div class="qa_btn"><a href="javascript:viewOpinion('');">1:1문의하기</a></div>
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
		<div class="text_info" style="font-size:14px; line-height:180%;">
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
              <li class="off tab_btn2">1:1문의하기</li>
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
		  </div>
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
              <li class="on tab_btn2">1:1문의하기</li>
            </ul>
          </div>
          <!--//탭-->
          <div class="title_box">
            <div class="title tw_500">1:1문의하기</div>
            <div class="star_um">총<em><span id="spnOpinionCount"></span>명</em></div>
            <a  href="javascript:viewOpinion('');">
            <input type="button" class="btn" value="1:1문의하기">
            </a> </div>
          <div class="tb_01_box"> 
            <!--pc 테블릿 일때 -->
            <table width="100%"  class="tb_01 pc_view" id="tblOpinionPC">
              <col width="5%">
              <col width="">
              <col width="15%">
              <col width="15%">
              <col width="55px;">
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
      
      <!-- 예약하기 -->
      
      <!-- 예약하기 -->
      <div id="myModal2" class="reveal-modal">      
      <div class="fl_right">
	    <div class="title_popup">예약하기	<a class="close-reveal-modal">&#215;</a></div>
	    <div class="sp_50 mobile_view"></div>
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
			<c:if test="${result.CL_SE ne 'S' and result.CL_SE ne 'T'}">
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
			<c:if test="${result.CL_SE eq 'T'}">
				<div id="c">
					<div id="disp">
						<div id="prev" class="nav">&larr;</div>
						<div id="month">Hello world</div>
						<div id="next" class="nav">&rarr;</div>
					</div>
					<div id="cal" ></div>
					<div id="calHelp">
						<div class="first active"><i>시작</i> <b id="sel1text">날짜선택</b></div>
						<div class="disabled"><i>종료</i> <b id="sel2text">날짜선택</b></div>
					</div>
				</div>
				<!-- /#c --> 
				<!-- <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script> --> 
				<script src="/jq/calendar/js/index3.js"></script>
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
	        	<c:if test="${result.CL_SE ne 'T'}">
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
				</c:if>
				<div class="input_box">
					<c:set var="optionNm" value="인원" />
					<c:if test="${result.CL_SE == 'P'}">
						<c:set var="optionNm" value="옵션" />
					</c:if>
					<div class="tx1"><c:out value="${optionNm}" /></div>
					<div class="select_box"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
						<select class="w_100p" id="cmbNmpr_P">
							<option value=""><c:out value="${optionNm}" />선택</option>
							<c:forEach var="list" items="${lstNmpr}" varStatus="status">
								<c:if test="${list.SETUP_SE == 'P'}">
									<option value="${list.NMPR_SN}">${list.NMPR_CND}</option>
								</c:if>
							</c:forEach>							
						</select>
						<!--//기본 셀렉트 박스 -->
					</div>
					<c:if test="${V_cnt > 0}">
					<div class="tx1"></div>
					<div class="select_box"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
						<select class="w_100p" id="cmbNmpr_V">
							<option value="">옵션선택</option>
							<c:forEach var="list" items="${lstNmpr}" varStatus="status">
								<c:if test="${list.SETUP_SE == 'V'}">
									<option value="${list.NMPR_SN}">${list.NMPR_CND}</option>
								</c:if>
							</c:forEach>							
						</select>
						<!--//기본 셀렉트 박스 -->
					</div>
					</c:if>
				</div>
        	</c:if>
        	<c:if test="${result.CL_SE eq 'S'}">
				<div class="input_box">
					<div class="tx1">객실선택</div>
					<div class="select_box"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
						<select class="w_100p" id="cmbRoom">
							<option value="">객실선택</option>
							<c:forEach var="list" items="${lstNmpr}" varStatus="status">
								<c:if test="${list.SETUP_SE == 'R'}">
									<option value="${list.NMPR_SN}">
										${list.NMPR_CND}
										<c:if test="${list.NMPR_CO != null}" >
											(기준인원 ${list.NMPR_CO}명)
										</c:if>
									</option>
								</c:if>
							</c:forEach>							
						</select>
						<!--//기본 셀렉트 박스 -->
					</div>
				</div>
	        	<c:if test="${E_cnt > 0}">
				<div class="input_box">
					<div class="tx1">옵션선택</div>
					<div class="select_box"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
						<select class="w_100p" id="cmbEat">
							<option value="">옵션선택</option>
							<c:forEach var="list" items="${lstNmpr}" varStatus="status">
								<c:if test="${list.SETUP_SE == 'E'}">
									<option value="${list.NMPR_SN}">${list.NMPR_CND}</option>
								</c:if>
							</c:forEach>							
						</select>
						<!--//기본 셀렉트 박스 -->
					</div>
				</div>
	        	</c:if>
	        	<c:if test="${C_cnt > 0}">
				<div class="input_box">
					<div class="tx1"></div>
					<div class="select_box"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
						<select class="w_100p" id="cmbCheck">
							<option value="">선택</option>
							<c:forEach var="list" items="${lstNmpr}" varStatus="status">
								<c:if test="${list.SETUP_SE == 'C'}">
									<option value="${list.NMPR_SN}">${list.NMPR_CND}</option>
								</c:if>
							</c:forEach>							
						</select>
						<!--//기본 셀렉트 박스 -->
					</div>
				</div>
	        	</c:if>
	        	<c:if test="${P_cnt > 0}">
				<div class="input_box">
					<div class="tx1"></div>
					<div class="select_box"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
						<select class="w_100p" id="cmbNmpr_S">
							<option value=""><c:out value="${optionNm}" />선택</option>
							<c:forEach var="list" items="${lstNmpr}" varStatus="status">
								<c:if test="${list.SETUP_SE == 'P'}">
									<option value="${list.NMPR_SN}">${list.NMPR_CND}</option>
								</c:if>
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
  <div class="reservation_mobile_btn mobile_view">	<a href="#" class="big-link" data-reveal-id="myModal2" data-animation="fade">예약하기</a></div>
  </div>
  <div class="sp_50 pc_view"></div>
  <div class="sp_10 mobile_view"></div>
</div>

<!-- //본문 --> 

<!--팝업 : 1:1문의하기-->
<div class="lightbox" id="share">
  <div class="popup_com2">
    <div class="title">공유하기 </div>
    <div class="popup_cont">
   <div class="login_div2"><a href="#"><img src="/images/com/sns_login1.gif" alt=""/></a> <a href="#"><img src="/images/com/sns_login2.gif" alt=""/></a>  <a href="#"><img src="/images/com/sns_login3.gif" alt=""/></a> </div>
    </div>
  </div>
</div>
<!--팝업-->


</section>

</body>