<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>
<style type="text/css">
.activity-description .intro_title {
    color: #994ede;
    font-size: 20px;
    line-height: 28px;
    font-weight: 500;
    margin: 10px 0 10px 5px;
}
.activity-description .intro_caption {
    color: #575757;
    font-size: 14px;
    line-height: 26px;
    font-weight: 700;
    height: 30px;
    margin-right: 10px;
    padding-left: 20px;
    padding-top: 10px;
    min-width: fit-content;
    min-width: -webkit-fit-content;
    min-width: -moz-fit-content;
}
.activity-description .intro_content {
    color: #575757;
    font-size: 12px;
    line-height: 20px;
    font-weight: 400;
    margin-left: 30px;
    padding-left: 20px;
    padding-bottom: 20px;
    padding-right: 20px;
}
.activity-description .intro_content2 {
    color: #575757;
    font-size: 12px;
    line-height: 20px;
    font-weight: 400;
    padding-left: 20px;
    padding-bottom: 20px;
    padding-right: 20px;
}
</style>
<script type="text/javascript" src="<c:url value='/js/jquery.comiseo.daterangepicker.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/moment.min.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(){
		// 상품소개 선택 init
		$("#informenu4_set_01 .tab_01_area").css('visibility','visible').css('display','block');
		$("#informenu4_set_01 .tab_01").wrapInner('<a href="#none"/>');
		
		// 상품소개 선택
		$("#informenu4_set_01 > p").click(function(){
			var pClass = $(this).attr("class");
			var divClass = ("#informenu4_set_01 ." + pClass + "_area");

			$("#informenu4_set_01 > div").css('visibility','hidden').css('display','none');
			$("#informenu4_set_01 > p").find("a").contents().unwrap();

			$(divClass).css('visibility','visible').css('display','block');
			$(this).wrapInner('<a href="#none"/>');
		});

		// 후기, Q&A 선택 init
		$("#review_set_01 .rtab_01_area").css('visibility','visible').css('display','block');
		$("#review_set_01 .rtab_01").wrapInner('<a/>');
		$('#btn_qna_write').hide();

		// 후기, Q&A 선택
		$("#review_set_01 > p").click(function(){
			var pClass = $(this).attr("class");
			var divClass = ("#review_set_01 ." + pClass + "_area");

			$("#review_set_01 > div").css('visibility','hidden').css('display','none');
			$("#review_set_01 > p").find("a").contents().unwrap();

			$(divClass).css('visibility','visible').css('display','block');
			$(this).wrapInner('<a href="#none"/>');
			
			if(pClass == 'rtab_02') {
				$('#btn_qna_write').show();
			} else {
				$('#btn_qna_write').hide();
			}
		});

		


		// 날짜 선택
		$(".btn_op_calendar").click(function(){
			fnCalendarPopup('TOUR_DE', '${result.CF_MIN_BEGIN_DE}', '${result.CF_MAX_END_DE}');
		});

		// 금액 선택
		$("#num2_dropdown01 ul").on("click", ".init", function() {
		    $(this).closest("ul").children('li:not(.init)').toggle();
		});

		$("#btn_save_reserv").click(function(){
			fnAddCart();
		});

		$(".infor_productarea_right > ul li").click(function(){
			iframeMainPhoto.fnSelPhoto($(this).index());
		});

		$("#TOUR_RANGE_DE").daterangepicker({
			initialText : '기간을 선택하세요.',
			applyButtonText: '선택', // use '' to get rid of the button
			clearButtonText: '초기화', // use '' to get rid of the button
			cancelButtonText: '취소', // use '' to get rid of the button
			dateFormat: 'yy-mm-dd',
			presetRanges: [],
			rangeSplitter: ' ~ ',
			applyOnMenuSelect: false,
			datepickerOptions : {
				numberOfMonths: 2,
				minDate: "${result.CF_MIN_BEGIN_DE}",
				maxDate: "${result.CF_MAX_END_DE}"
			}
		});

		$("#TOUR_RANGE_DE").on('change', function(event) {
			if($("#TOUR_RANGE_DE").val()) {
				var __val =  jQuery.parseJSON($("#TOUR_RANGE_DE").val());
				$("#CHKIN_DE").val(__val.start);
				$("#CHCKT_DE").val(__val.end);

				var arr1 = __val.start.split('-');
				var arr2 = __val.end.split('-');

				var dat1 = new Date(parseInt(arr1[0]), parseInt(arr1[1])-1, parseInt(arr1[2]));
				var dat2 = new Date(parseInt(arr2[0]), parseInt(arr2[1])-1, parseInt(arr2[2]));

				var diff = dat2.getTime() - dat1.getTime() ;
				var currDay = 24 * 60 * 60 * 1000;

				$("#DAYS_CO").val(diff/currDay);
			} else {
				$("#CHKIN_DE").val('');
				$("#CHCKT_DE").val('');
				$("#DAYS_CO").val('0');
				fnInitCartStay();
			}
			
			fnSetCart();
		});

		$("#btn_op_calendar_range").click(function(){
			$("#TOUR_RANGE_DE").daterangepicker("open");
		});
	});

	function fnList() {
		var form = $("form[id=frmDetail]");
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}

	function fnGoCartList() {
		var form = $("form[id=frmDetail]");
		form.attr({"method":"post","action":"<c:url value='/cart/list/'/>"});
		form.submit();
	}

	function fnSearch(cl_code) {
		var form = $("form[id=frmDetail]");
		$("input:hidden[id=hidUpperClCode]").val(cl_code);
		$("input:hidden[id=hidPage]").val(1);
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}

	function fnAddCart(){
		if($('#hidClSe').val() == 'S') {
			if(!$('#TOUR_RANGE_DE').val()) {
				alert('기간을 선택하세요.');
				return;
			}
			
			if($('#R_NMPR') && !$('#R_NMPR').val()) {
				alert('객실을 선택하세요.');
				return;				
			}
		} else {
			if( !$('#TOUR_DE').val().replace('일정을 선택하세요.', '')) {
				alert('일정을 선택하세요.');
				return;
			}
			
			if($('#hidClSe').val() == 'P' && !$('#frmLayout [name="hidFlightSn"]').val()) {
				if(confirm('픽업/드랍 서비스는 항공편을 반드시 입력해야 합니다.')) {
					fnOpenPopup("<c:url value='/cart/flightPopup/'/>", "winFightPopup", 750, 550);
					return;
				}
			}
			
			if(!$('#TOUR_TIME').val()) {
				alert('시간을 선택하세요.');
				return;				
			}

			var re = false;
			$("input[name='CART_NMPR_CO']").each(function(i) {
				var div = $(this).attr('id').substring(0, 1);
				if(div == 'P') {
					if($(this).val() > 0) {
						re = true;
					}				
				}
			});
			
			if(!re) {
				alert('인원을 선택하세요.');
				return;	
			}
		}

		var form_data = $("form[id=frmDetail]").serialize();

		$.ajax({
			url : "<c:url value='/cart/addAction/'/>",
			dataType : "json",
			type : "POST",
			async : true,
			data : form_data,
			beforeSend:function(){
				showLoading();
			},
			success : function(json) {
				if(json.result == "0") {
					//장바구니에 담은 상품 목록 (우측 일정표 조회)
					fnCartList();
					if(confirm("예약되었습니다. 장바구니로 이동하시겠습니까?")) {
						fnGoCartList();
					} else {
						fnList();
					}
				} else if(json.result == "-2") {
					alert("로그인이 필요합니다.");
					$(".login").click();
				} else if(json.result == "9") {
					alert(json.message);
				} else{
					alert("작업을 실패하였습니다.");
				}
			},
			complete:function() {
				hideLoading();
			},
			error : function() {
				alert("오류가 발생하였습니다.");
			}
		});
	}

	function fnSetCart(){
		var div = '';
		var idx = '';  
		var str = '';
		var sum = 0;
		var tot = 0;
		$("input[name='CART_NMPR_CO']").each(function(i) {
			if($("input[name='CART_NMPR_CO']").eq(i).val() > 0) {
				var id = $("input[name='CART_NMPR_CO']").eq(i).attr('id');
				div = id.substring(0, 1);
				idx = id.substring(id.lastIndexOf('_')+1);
				
				if(div == 'P') {
					sum = parseInt($('#'+div+'_SETUP_AMOUNT_'+idx).val(), 10) * parseInt($('#'+div+'_CART_NMPR_CO_'+idx).val(),10);
					//str += $('#'+div+'_NMPR_CND_'+idx).val() + '(₩' +  comma($('#'+div+'_SETUP_AMOUNT_'+idx).val()) +') * ' + $('#'+div+'_CART_NMPR_CO_'+idx).val();
					str += "<p class='n3_lst'>"+$('#'+div+'_NMPR_CND_'+idx).val()+"<span class='yellow'> "+$('#'+div+'_CART_NMPR_CO_'+idx).val()+"</span>명 ";
				} else if(div == 'R') {
					$('#TEMP_NMPR_CO').val($('#'+div+'_GOODS_NMPR_CO_'+idx).val());
					$('#TEMP_SETUP_AMOUNT').val($('#'+div+'_SETUP_AMOUNT_'+idx).val());
					sum = parseInt($('#'+div+'_SETUP_AMOUNT_'+idx).val(), 10) * parseInt($('#DAYS_CO').val(),10); 
					//str += $('#'+div+'_NMPR_CND_'+idx).val() + '(₩' + comma($('#'+div+'_SETUP_AMOUNT_'+idx).val()) +') * ' + $('#DAYS_CO').val();
					str += "<p class='n3_lst'>"+$('#'+div+'_NMPR_CND_'+idx).val()+"<span class='yellow'> "+$('#DAYS_CO').val()+"</span>박 ";
				} else if(div == 'E') {
					sum = parseInt($('#'+div+'_SETUP_AMOUNT_'+idx).val(), 10) * parseInt($('#DAYS_CO').val(),10) * parseInt($('#TEMP_NMPR_CO').val(), 10); 
					//str += $('#'+div+'_NMPR_CND_'+idx).val() + '(₩' + comma($('#'+div+'_SETUP_AMOUNT_'+idx).val()) +') * ' + $('#TEMP_NMPR_CO').val() + ' * ' + $('#DAYS_CO').val();
					str += "<p class='n3_lst'>"+$('#'+div+'_NMPR_CND_'+idx).val()+"<span class='yellow'> "+$('#TEMP_NMPR_CO').val()+"</span>인 <span class='yellow'>"+ $('#DAYS_CO').val()+'</span>박';
				} else if(div == 'C') {
					if($('#'+div+'_FIXED_AT_'+idx).val() == 'Y') {
						sum = parseInt($('#'+div+'_SETUP_AMOUNT_'+idx).val(), 10);
						//str += $('#'+div+'_NMPR_CND_'+idx).val() + '(₩' + comma($('#'+div+'_SETUP_AMOUNT_'+idx).val()) +')';					
						str += "<p class='n3_lst'>"+$('#'+div+'_NMPR_CND_'+idx).val();
					} else {
						sum = parseInt($('#TEMP_SETUP_AMOUNT').val(), 10) * parseFloat($('#'+div+'_SETUP_RATE_'+idx).val());
						var tmp = parseFloat($('#'+div+'_SETUP_RATE_'+idx).val()) * 100;
						console.log('비율 sum:'+sum);
						//str += $('#'+div+'_NMPR_CND_'+idx).val() + '(₩' + comma($('#TEMP_SETUP_AMOUNT').val()) +') * ' + tmp + '%';
						str += "<p class='n3_lst'>"+$('#'+div+'_NMPR_CND_'+idx).val();
					}
				}
				
				
				console.log('fnSetCart > div: '+div);
				
				if(div == 'P') {
					tot += sum;
					//str += ' :  ' + "₩"+comma(sum) 
					//	+ '<a onclick="fnAdd(\''+div+'\', \''+idx+'\');return false;" class="btn_add_selected">+</a>'
					//	+ '<a onclick="fnMinus(\''+div+'\', \''+idx+'\');return false;" class="btn_add_selected">-</a><br>';
					str += "<span class='yellow'>"+comma(sum)+"</span>원"
				    	+ '<a onclick="fnAdd(\''+div+'\', \''+idx+'\');return false;" class="btn_add_selected">+</a>'
				    	+ '<a onclick="fnMinus(\''+div+'\', \''+idx+'\');return false;" class="btn_add_selected">-</a></p>';			    	
				} else {
					tot += sum;
					str += "<span class='yellow'>"+comma(sum)+"</span>원"
					    + '<a onclick="fnMinus(\''+div+'\', \''+idx+'\');return false;" class="btn_add_selected">-</a></p>';					    
					//str += ' :  ' + "₩"+comma(sum) 
					//	+ '<a onclick="fnMinus(\''+div+'\', \''+idx+'\');return false;" class="btn_add_selected">-</a><br>';
				}
			}
	    });
		
		if(div == 'P') {
			if(str) {
				str = '<li><div id="num3_dropdown01">' + str + '</div></li>';	
			} 
		} else {
			if(str) {
				str = '<li>' + str + '</li>';	
			}
		}
			
		$('#divCartDesc').html(str);
		$('#PURCHS_AMOUNT').val("₩"+comma(tot));
	}
	
	function fnAddInit(div, objId){
		var idx = $("#"+objId).val();
		var cnt = parseInt($('#'+div+'_CART_NMPR_CO_'+idx).val(), 10) + 1;
		$('#'+div+'_CART_NMPR_CO_'+idx).val(cnt);
		fnSetCart();
	}
	
	function fnAdd(div, idx){
		if(div != 'P') {
			$('#'+div+'_NMPR').val('');
		}	
		
		if(div == 'R') {
			fnInitCartStay();
		} else {
			var cnt = parseInt($('#'+div+'_CART_NMPR_CO_'+idx).val(), 10) + 1;
			$('#'+div+'_CART_NMPR_CO_'+idx).val(cnt);
		}
		
		fnSetCart();
	}
	
	function fnMinus(div, idx) {
		if(div != 'P') {
			$('#'+div+'_NMPR').val('');
		}	
		
		if(div == 'R') {
			fnInitCartStay();
		} else {
			var cnt = parseInt($('#'+div+'_CART_NMPR_CO_'+idx).val(), 10) - 1;
			$('#'+div+'_CART_NMPR_CO_'+idx).val(cnt);
			
			if(div == 'P' && cnt == 0) {
				fnInitCartGoods();
			}
		}
		
		fnSetCart();
	}
	
	function fnInitCartGoods() {
		var re = false;
		$("input[name='CART_NMPR_CO']").each(function(i) {
			if($(this).val() > 0) {
				re = true;
			}
		});
		
		if(!re) {
			$('#P_NMPR').val('');
		}
	}
	
	function fnInitCartStay() {
		$('#R_NMPR').val('');
		$('#E_NMPR').val('');
		$('#C_NMPR').val('');
		
		$("input[name='CART_NMPR_CO']").each(function(i) {
			$(this).val('0');
		});
		
		$('#TEMP_NMPR_CO').val('0');
		$('#TEMP_SETUP_AMOUNT').val('0');
	}
	
	function fnChange(div, objId) {
		if($('#DAYS_CO').val() == '0') {
			alert('기간을 선택하세요.');
			$('#'+objId).val('');
			return;
		}
		
		if((div == 'E' || div == 'C') && $('#R_NMPR').val() == '') {
			alert('객실을 선택하세요.');
			$('#'+objId).val('');
			return;
		}
	
		$("input[name='CART_NMPR_CO']").each(function(i) {
			if($(this).attr('id').substr(0, 2) == div+'_') {
				$("input[name='CART_NMPR_CO']").eq(i).val('0');
			}
	    });
		
		var idx = $("#"+objId).val();
		$('#'+div+'_CART_NMPR_CO_'+idx).val('1');
		
		fnSetCart();
	}
</script>
</head>
<body>
<form id="frmDetail" name="frmDetail" method="post" action="<c:url value='/goods/list/'/>">
<input type="hidden" id="hidPage" name="hidPage" value="${hidPage}">
<input type="hidden" id="hidGoodsCode" name="hidGoodsCode" value="${goods_code}">
<input type="hidden" id="hidUpperClCode" name="hidUpperClCode" value="${hidUpperClCode}">
<input type="hidden" id="hidUpperClCodeNavi" name="hidUpperClCodeNavi" value="${hidUpperClCodeNavi}">
<input type="hidden" id="hidClSe" name="hidClSe" value="${result.CL_SE}">
<input type="hidden" id="hidWaitTime" name="hidWaitTime" value="${result.WAIT_TIME}">
<input type="hidden" id="hidMvmnTime" name="hidMvmnTime" value="${result.MVMN_TIME}">

<c:forEach var="list" items="${nmprList}" varStatus="status">
<input type="hidden" name="SETUP_SE"       id="${list.SETUP_SE}_SETUP_SE_${status.index}"       value="${list.SETUP_SE}">
<input type="hidden" name="NMPR_SN"        id="${list.SETUP_SE}_NMPR_SN_${status.index}"        value="${list.NMPR_SN}">
<input type="hidden" name="NMPR_CND"       id="${list.SETUP_SE}_NMPR_CND_${status.index}"       value="${list.NMPR_CND}">
<input type="hidden" name="FIXED_AT"       id="${list.SETUP_SE}_FIXED_AT_${status.index}"       value="${list.FIXED_AT}">
<input type="hidden" name="SETUP_AMOUNT"   id="${list.SETUP_SE}_SETUP_AMOUNT_${status.index}"   value="${list.SETUP_AMOUNT}">
<input type="hidden" name="SETUP_RATE"     id="${list.SETUP_SE}_SETUP_RATE_${status.index}"     value="${list.SETUP_RATE}">
<input type="hidden" name="GOODS_NMPR_CO"  id="${list.SETUP_SE}_GOODS_NMPR_CO_${status.index}"  value="${list.NMPR_CO}">
<input type="hidden" name="CART_NMPR_CO"   id="${list.SETUP_SE}_CART_NMPR_CO_${status.index}"   value="0">

</c:forEach>
<c:forEach var="list" items="${roomList}" varStatus="status">
<input type="hidden" name="SETUP_SE"       id="${list.SETUP_SE}_SETUP_SE_${status.index}"       value="${list.SETUP_SE}">
<input type="hidden" name="NMPR_SN"        id="${list.SETUP_SE}_NMPR_SN_${status.index}"        value="${list.NMPR_SN}">
<input type="hidden" name="NMPR_CND"       id="${list.SETUP_SE}_NMPR_CND_${status.index}"       value="${list.NMPR_CND}">
<input type="hidden" name="FIXED_AT"       id="${list.SETUP_SE}_FIXED_AT_${status.index}"       value="${list.FIXED_AT}">
<input type="hidden" name="SETUP_AMOUNT"   id="${list.SETUP_SE}_SETUP_AMOUNT_${status.index}"   value="${list.SETUP_AMOUNT}">
<input type="hidden" name="SETUP_RATE"     id="${list.SETUP_SE}_SETUP_RATE_${status.index}"     value="${list.SETUP_RATE}">
<input type="hidden" name="GOODS_NMPR_CO"  id="${list.SETUP_SE}_GOODS_NMPR_CO_${status.index}"  value="${list.NMPR_CO}">
<input type="hidden" name="CART_NMPR_CO"   id="${list.SETUP_SE}_CART_NMPR_CO_${status.index}"   value="0">

</c:forEach>
<c:forEach var="list" items="${eatList}" varStatus="status">
<input type="hidden" name="SETUP_SE"       id="${list.SETUP_SE}_SETUP_SE_${status.index}"       value="${list.SETUP_SE}">
<input type="hidden" name="NMPR_SN"        id="${list.SETUP_SE}_NMPR_SN_${status.index}"        value="${list.NMPR_SN}">
<input type="hidden" name="NMPR_CND"       id="${list.SETUP_SE}_NMPR_CND_${status.index}"       value="${list.NMPR_CND}">
<input type="hidden" name="FIXED_AT"       id="${list.SETUP_SE}_FIXED_AT_${status.index}"       value="${list.FIXED_AT}">
<input type="hidden" name="SETUP_AMOUNT"   id="${list.SETUP_SE}_SETUP_AMOUNT_${status.index}"   value="${list.SETUP_AMOUNT}">
<input type="hidden" name="SETUP_RATE"     id="${list.SETUP_SE}_SETUP_RATE_${status.index}"     value="${list.SETUP_RATE}">
<input type="hidden" name="GOODS_NMPR_CO"  id="${list.SETUP_SE}_GOODS_NMPR_CO_${status.index}"  value="${list.NMPR_CO}">
<input type="hidden" name="CART_NMPR_CO"   id="${list.SETUP_SE}_CART_NMPR_CO_${status.index}"   value="0">

</c:forEach>
<c:forEach var="list" items="${checkList}" varStatus="status">
<input type="hidden" name="SETUP_SE"       id="${list.SETUP_SE}_SETUP_SE_${status.index}"       value="${list.SETUP_SE}">
<input type="hidden" name="NMPR_SN"        id="${list.SETUP_SE}_NMPR_SN_${status.index}"        value="${list.NMPR_SN}">
<input type="hidden" name="NMPR_CND"       id="${list.SETUP_SE}_NMPR_CND_${status.index}"       value="${list.NMPR_CND}">
<input type="hidden" name="FIXED_AT"       id="${list.SETUP_SE}_FIXED_AT_${status.index}"       value="${list.FIXED_AT}">
<input type="hidden" name="SETUP_AMOUNT"   id="${list.SETUP_SE}_SETUP_AMOUNT_${status.index}"   value="${list.SETUP_AMOUNT}">
<input type="hidden" name="SETUP_RATE"     id="${list.SETUP_SE}_SETUP_RATE_${status.index}"     value="${list.SETUP_RATE}">
<input type="hidden" name="GOODS_NMPR_CO"  id="${list.SETUP_SE}_GOODS_NMPR_CO_${status.index}"  value="${list.NMPR_CO}">
<input type="hidden" name="CART_NMPR_CO"   id="${list.SETUP_SE}_CART_NMPR_CO_${status.index}"   value="0">

</c:forEach>

<c:if test="${result.CL_SE eq 'S'}">
<input type="hidden" name="CHKIN_DE" id="CHKIN_DE">
<input type="hidden" name="CHCKT_DE" id="CHCKT_DE">
<input type="hidden" name="DAYS_CO" id="DAYS_CO" value="0">
<input type="hidden" name="TEMP_NMPR_CO" id="TEMP_NMPR_CO" value="0">
<input type="hidden" name="TEMP_SETUP_AMOUNT" id="TEMP_SETUP_AMOUNT" value="0">
</c:if>



<div class="location">
	<p class="loc_area">
		홈<span class="arrow_loc"></span>투어상품
	</p>
</div>
<div class="infor_area">
	<!--윈도우시작-->
	<div id="window">
		<p class="hotdeal">★핫딜</p>
		<!-- <p class="a_pre"></p>
		<p class="a_next"></p> -->
		<p class="main_photo">
			<iframe id="iframeMainPhoto" src="<c:url value='/file/imageListIframe/'/>?file_code=${result.FILE_CODE}" width="824" height="428" scrolling="no" frameborder="0"></iframe>
		</p>
		<!--옵션박스영역시작-->
		<div class="area_option">
			<div class="option_box">
				<span class="txt_reserv">RESERVATION</span>
				<div class="area_star">
					<ul>
						<li><img src="<c:url value='/images/star_yellow.png'/>" width="13" height="15"></li>
						<li><img src="<c:url value='/images/star_yellow.png'/>" width="13" height="15"></li>
						<li><img src="<c:url value='/images/star_yellow.png'/>" width="13" height="15"></li>
						<li></li>
						<li></li>
					</ul>
					<span class="txt_ranking">8.8</span>
					<ul id="num_area">
						<c:if test="${result.CL_SE ne 'S'}">
						<li class="num01">날짜
							<input type="text" name="TOUR_DE" id="TOUR_DE" class="input_datebox2" value="일정을 선택하세요." readonly onfocus="this.blur()">
							<span class="btn_op_calendar" id="btn_op_calendar"></span>
						</li>
						<li class="num02">시간
							<select name="TOUR_TIME" id="TOUR_TIME" class="time_sbox2">
								<option value="">선택</option>
							<c:forEach var="list" items="${timeList}" varStatus="status">
								<option value="${list.TOUR_TIME}">${fn:substring(list.BEGIN_TIME,0,2)} : ${fn:substring(list.BEGIN_TIME,2,4)} ~ ${fn:substring(list.END_TIME,0,2)} : ${fn:substring(list.END_TIME,2,4)}</option>
							</c:forEach>
							</select>
						</li>
						<li class="num03">인원
							<select name="P_NMPR" id="P_NMPR" class="time_sbox2" onchange='fnAddInit("P", "P_NMPR");this.blur();'>
								<option value="">선택</option><c:forEach var="list" items="${nmprList}" varStatus="status">
								<option value="${status.index}">${list.NMPR_CND}</option>
							</c:forEach></select>
						</li>
						</c:if><c:if test="${result.CL_SE eq 'S'}">
						<li class="num01">날짜
							<input type="text" name="TOUR_RANGE_DE" id="TOUR_RANGE_DE" class="input_datebox2" size="15">
							<span class="btn_op_calendar" id="btn_op_calendar_range"></span>
						</li>
						<li class="num02">객실
							<select name="R_NMPR" id="R_NMPR" class="time_sbox2" onchange="fnChange('R', 'R_NMPR');this.blur();">
								<option value="">선택</option><c:forEach var="list" items="${roomList}" varStatus="status">
								<option value="${status.index}">${list.NMPR_CND}</option>
							</c:forEach></select>
						</li>
						<c:if test="${fn:length(eatList) > 0}">
						<li class="num03">옵션
							<select name="E_NMPR" id="E_NMPR" class="time_sbox2" onchange="fnChange('E', 'E_NMPR');this.blur();">
								<option value="">선택</option><c:forEach var="list" items="${eatList}" varStatus="status">
								<option value="${status.index}">${list.NMPR_CND}</option>
							</c:forEach></select>
						</li></c:if>
						<c:if test="${fn:length(checkList) > 0}">
						<li>　　
							<select name="C_NMPR" id="C_NMPR" class="time_sbox2" onchange="fnChange('C', 'C_NMPR');this.blur();">
								<option value="">선택</option><c:forEach var="list" items="${checkList}" varStatus="status">
								<option value="${status.index}">${list.NMPR_CND}</option>
							</c:forEach></select>
						</li></c:if>
						</c:if>
						<div id="divCartDesc"></div>
					</ul>
					<p id="price">
						<input type="text" name="PURCHS_AMOUNT" id="PURCHS_AMOUNT" class="txt_price" value="₩0" readonly onfocus="this.blur()">&nbsp;&nbsp;
					</p>
					<p id="btn_save_reserv">예약하기</p>
				</div>
			</div>
		</div>
		<!--옵션박스영역끝-->
	</div>
	<!--윈도우끝-->
	<!--컨텐츠 설명영역시작-->
	<div id="infor_productarea">
		<!--좌측-->
		<div class="infor_productarea_left">
			<div class="tit_area">
				<h3>${result.GOODS_NM}</h3>
				<p class="heart_area">25</p>
			</div>
			<div class="subtit_area">
				<!-- TODO 주소 -->
				<!-- Punta Engaño Road, Lapu-Lapu City, Cebu, 6015 Mactan, Philippine -->
				<ul class="btnarea_qna">
					<li class="pbtn_left"></li>
					<li>1:1문의</li>
					<li class="pbtn_right"></li>
				</ul>
				<ul class="btnarea_sns">
					<li class="pbtn_left"></li>
					<li>공유하기</li>
					<li class="pbtn_right"></li>
				</ul>
			</div>
			<p class="txt_infor">
				${result.GOODS_INTRCN}
			</p>
			<c:if test="${!empty result.INTRCN_GOODS_TY || !empty result.INTRCN_USE_TIME || !empty result.INTRCN_MEET_TIME || !empty result.INTRCN_REQRE_TIME || !empty result.INTRCN_PROVD_LANG || !empty result.INTRCN_POSBL_AGE || !empty result.INTRCN_PLACE}" >
			<ul class="information7_area">
			<c:if test="${!empty result.INTRCN_GOODS_TY}">
				<li><img src="<c:url value='/images/picon_01.gif'/>" width="42" height="42" alt=""><span>상품유형</span>
				<sapn class="infor7_txt"><c:if test="${result.INTRCN_GOODS_TY eq 'G'}">단체투어</c:if><c:if test="${result.INTRCN_GOODS_TY eq 'P'}">프라이빗투어</c:if></span></li>
			</c:if><c:if test="${!empty result.INTRCN_USE_TIME}">
				<li><img src="<c:url value='/images/picon_02.gif'/>" width="42" height="42" alt=""><span>이용시간</span>
				<sapn class="infor7_txt">${result.INTRCN_USE_TIME}</span></li>
			</c:if><c:if test="${!empty result.INTRCN_MEET_TIME}">
				<li><img src="<c:url value='/images/picon_03.gif'/>" width="42" height="42" alt=""><span>집합시간</span>
				<sapn class="infor7_txt">${result.INTRCN_MEET_TIME}</span></li>
			</c:if><c:if test="${!empty result.INTRCN_REQRE_TIME}">
				<li><img src="<c:url value='/images/picon_03.gif'/>" width="42" height="42" alt=""><span>소요시간</span>
				<sapn class="infor7_txt">${result.INTRCN_REQRE_TIME}</span></li>
			</c:if><c:if test="${!empty result.INTRCN_PROVD_LANG}">
				<li><img src="<c:url value='/images/picon_03.gif'/>" width="42" height="42" alt=""><span>제공언어</span>
				<sapn class="infor7_txt">${result.INTRCN_PROVD_LANG}</span></li>
			</c:if><c:if test="${!empty result.INTRCN_POSBL_AGE}">
				<li><img src="<c:url value='/images/picon_03.gif'/>" width="42" height="42" alt=""><span>가능연령</span>
				<sapn class="infor7_txt">${result.INTRCN_POSBL_AGE}</span></li>
			</c:if><c:if test="${!empty result.INTRCN_PLACE}">
				<li><img src="<c:url value='/images/picon_03.gif'/>" width="42" height="42" alt=""><span>장소</span>
				<sapn class="infor7_txt">${result.INTRCN_PLACE}</span></li>
			</c:if>
			</ul>
			</c:if>
			<!--인포4 메뉴영역 시작-->
			<div id="informenu4_set_01">
				<p class="tab_01"><a href="#none">이용안내</a></p>
				<p class="tab_02">추가안내 및 유의사항</p>
				<p class="tab_03">변경 및 환불규정</p>
				<p class="tab_04">위치안내</p>
				<!--tab_01 테이블-->
				<div class="tab_01_area">
				<div class="activity-description">
					<c:if test="${!empty result.VOCHR_TICKET_TY || !empty result.VOCHR_NTSS_REQRE_TIME || !empty result.VOCHR_USE_MTH}">
					<div class="intro_title">
						바우처
					</div>
					<c:if test="${!empty result.VOCHR_TICKET_TY}">
					<div class="intro_caption">
						티켓형태
					</div>
					<div class="intro_content">
					    <c:if test="${result.VOCHR_TICKET_TY eq 'V'}">E-바우처</c:if>
						<c:if test="${result.VOCHR_TICKET_TY eq 'T'}">E-티켓(캡쳐가능)</c:if>
						<c:if test="${result.VOCHR_TICKET_TY eq 'E'}">확정메일(캡쳐가능)</c:if>
					</div>
					</c:if>
					<c:if test="${!empty result.VOCHR_NTSS_REQRE_TIME}">
					<div class="intro_caption">
						발권소요시간
					</div>
					<div class="intro_content">
					    ${result.VOCHR_NTSS_REQRE_TIME}
					</div>
					</c:if>
					<c:if test="${!empty result.VOCHR_USE_MTH}">
					<div class="intro_caption">
						사용방법
					</div>
					<div class="intro_content">
						${result.VOCHR_USE_MTH}
					</div>
					</c:if>
					</c:if>
					<c:if test="${!empty result.GUIDANCE_USE_TIME  || !empty result.GUIDANCE_REQRE_TIME || !empty result.GUIDANCE_AGE_DIV || !empty result.GUIDANCE_TOUR_SCHDUL || !empty result.GUIDANCE_PRFPLC_LC || !empty result.GUIDANCE_EDC_CRSE || !empty result.GUIDANCE_OPTN_MATTER || !empty result.GUIDANCE_PICKUP || !empty result.GUIDANCE_PRPARETG || !empty result.GUIDANCE_INCLS_MATTER || !empty result.GUIDANCE_NOT_INCLS_MATTER}">
					<div class="intro_title">
						이용안내
					</div>
					</c:if>					
					<c:if test="${!empty result.GUIDANCE_USE_TIME}">
					<div class="intro_caption">
						이용시간
					</div>
					<div class="intro_content">
					    ${result.GUIDANCE_USE_TIME}
					</div>
					</c:if>
					<c:if test="${!empty result.GUIDANCE_REQRE_TIME}">
					<div class="intro_caption">
						소요시간
					</div>
					<div class="intro_content">
					    ${result.GUIDANCE_REQRE_TIME}
					</div>
					</c:if>
					<c:if test="${!empty result.GUIDANCE_AGE_DIV}">
					<div class="intro_caption">
						연령구분
					</div>
					<div class="intro_content">
					    ${result.GUIDANCE_AGE_DIV}
					</div>
					</c:if>
					<c:if test="${!empty result.GUIDANCE_TOUR_SCHDUL}">
					<div class="intro_caption">
						 여행일정
					</div>
					<div class="intro_content">
					    ${result.GUIDANCE_TOUR_SCHDUL}
					</div>
					</c:if>
					<c:if test="${!empty result.GUIDANCE_PRFPLC_LC}">
					<div class="intro_caption">
						 공연장위치
					</div>
					<div class="intro_content">
					    ${result.GUIDANCE_PRFPLC_LC}
					</div>
					</c:if>
					<c:if test="${!empty result.GUIDANCE_EDC_CRSE}">
					<div class="intro_caption">
						 교육과정
					</div>
					<div class="intro_content">
					    ${result.GUIDANCE_EDC_CRSE}
					</div>
					</c:if>
					<c:if test="${!empty result.GUIDANCE_OPTN_MATTER}">
					<div class="intro_caption">
						 옵션사항
					</div>
					<div class="intro_content">
					    ${result.GUIDANCE_OPTN_MATTER}
					</div>
					</c:if>
					<c:if test="${!empty result.GUIDANCE_PICKUP}">
					<div class="intro_caption">
						 픽업
					</div>
					<div class="intro_content">
					    ${result.GUIDANCE_PICKUP}
					</div>
					</c:if>
					<c:if test="${!empty result.GUIDANCE_PRPARETG}">
					<div class="intro_caption">
						 준비물
					</div>
					<div class="intro_content">
					    ${result.GUIDANCE_PRPARETG}
					</div>
					</c:if>
					<c:if test="${!empty result.GUIDANCE_INCLS_MATTER}">
					<div class="intro_caption">
						 포함사항
					</div>
					<div class="intro_content">
					    ${result.GUIDANCE_INCLS_MATTER}
					</div>
					</c:if>
					<c:if test="${!empty result.GUIDANCE_NOT_INCLS_MATTER}">
					<div class="intro_caption">
						 불포함사항
					</div>
					<div class="intro_content">
					    ${result.GUIDANCE_NOT_INCLS_MATTER}
					</div>
					</c:if>
					<c:if test="${empty result.VOCHR_TICKET_TY && empty result.VOCHR_NTSS_REQRE_TIME && empty result.VOCHR_USE_MTH && empty result.GUIDANCE_USE_TIME && empty result.GUIDANCE_REQRE_TIME && empty result.GUIDANCE_AGE_DIV && empty result.GUIDANCE_TOUR_SCHDUL && empty result.GUIDANCE_PRFPLC_LC && empty result.GUIDANCE_EDC_CRSE && empty result.GUIDANCE_OPTN_MATTER && empty result.GUIDANCE_PICKUP && empty result.GUIDANCE_PRPARETG && empty result.GUIDANCE_INCLS_MATTER && empty result.GUIDANCE_NOT_INCLS_MATTER}">
					<div class="intro_content">
					</div>
					</c:if>
				</div>
				</div>
				<!-- tab_01 테이블 끝 -->
				<!-- tab_02 테이블-->
				<div class="tab_02_area">
					<div class="activity-description">
					<c:if test="${!empty result.ADIT_GUIDANCE || !empty result.ATENT_MATTER}">
					<c:if test="${!empty result.ADIT_GUIDANCE}">					
					<div class="intro_title">
						추가안내
					</div>
					<div class="intro_content2">
						${result.ADIT_GUIDANCE}
					</div>
					</c:if>
					<c:if test="${!empty result.ATENT_MATTER}">
					<div class="intro_title">
						유의사항
					</div>
					<div class="intro_content2">
						${result.ATENT_MATTER}
					</div>
					</c:if>
					</c:if>
					<c:if test="${empty result.ADIT_GUIDANCE && empty result.ATENT_MATTER}">
					<div class="intro_content2">
					</div>					
					</c:if>
					</div>
				</div>
				<!-- tab_02 테이블 끝 -->
				<!-- tab_03 테이블-->
				<div class="tab_03_area">
					<div class="activity-description">
					<c:if test="${!empty result.CHANGE_REFND_REGLTN}">					
					<div class="intro_title">
						변경/환불규정
					</div>
					<div class="intro_content2">
						${result.CHANGE_REFND_REGLTN}
					</div>
					</c:if>
					<c:if test="${empty result.CHANGE_REFND_REGLTN}">	
					<div class="intro_content2">
					</div>
					</c:if>
					</div>
				</div>
				<!-- tab_03 테이블 끝 -->
				<!-- tab_04 지도-->
				<div class="tab_04_area">
					<iframe src="<c:url value='/mngr/gmap/'/>?la=${result.ACT_LA}&lo=${result.ACT_LO}" width="100%" height="100%"></iframe>
				</div>
				<!-- tab_04 지도 끝 -->
			</div>

			<!--인포4 메뉴영역 끝-->
			<!--이용후기영역 시작-->

			<div id="review_set_01">
				<p class="rtab_01">
					<a href="#none">후기 (13건)</a>
				</p>
				<p class="rtab_02">문의하기</p>
				<input type="button" value="글쓰기" id="btn_qna_write" class="btn_review_write" />
				<!--rtab_01 테이블(목록) 시작-->
				<%-- <div class="rtab_01_area">
					<div class="review_tablestyle">
						<table summary="" cellpadding="0" cellspacing="0">
							<caption>게시판 템플릿 목록</caption>
							<colgroup>
								<col width="80px">
								<col width="433px">
								<col width="100px">
								<col width="100px">
								<col width="80px">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">No.</th>
									<th scope="col">제목</th>
									<th scope="col">작성자</th>
									<th scope="col">작성일</th>
									<th scope="col">평점</th>
								</tr>
							</thead>

							<tbody>
								<tr>
									<td nowrap="nowrap">05</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point40"><span class="blind">4점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">04</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point30"><span class="blind">3점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">03</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point20"><span class="blind">2점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">02</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point10"><span class="blind">1점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">01</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point50"><span class="blind">5점</span></span>
										</div></td>
								</tr>


							</tbody>
						</table>
					</div>

					<ul class="paging">
						<li class="btn_pprev"><a href="#">첫페이지</a></li>
						<li class="btn_prev"><a href="#">이전페이지</a></li>
						<li><a href="#">1</a></li>
						<li><a href="#">2</a></li>
						<li><a href="#">3</a></li>
						<li><a href="#">4</a></li>
						<li><a href="#">5</a></li>
						<li><a href="#">6</a></li>
						<li><a href="#">7</a></li>
						<li><a href="#">8</a></li>
						<li><a href="#">9</a></li>
						<li><a href="#">10</a></li>
						<li class="btn_next"><a href="#">다음페이지</a></li>
						<li class="btn_nnext"><a href="#">마지막페이지</a></li>
					</ul>

				</div> --%>
				<!-- rtab_01 테이블(목록) 끝 -->
				<!--rtab_01 테이블(읽기) 시작-->
				<div class="rtab_01_area">
					<div class="review_tablestyle">
						<table summary="" cellpadding="0" cellspacing="0">
							<caption>게시판 템플릿 목록</caption>
							<colgroup>
								<col width="80px">
								<col width="433px">
								<col width="100px">
								<col width="100px">
								<col width="80px">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">No.</th>
									<th scope="col">제목</th>
									<th scope="col">작성자</th>
									<th scope="col">작성일</th>
									<th scope="col">평점</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td nowrap="nowrap">05</td>
									<td nowrap="nowrap" class="listleft" >생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point40"><span class="blind">4점</span></span>
										</div></td>
								</tr>
								<tr>
								<td class="td_comment_view" colspan="5">
									<div class="comment_view">
										<dl>
											<!-- <dt>상품구성(숙소/식사)</dt>
											<dd>
												<div class="star_score_bgray">
													<span class="review_point40"><span class="blind">4점</span></span>
												</div>
											</dd>
											<dt>일정구성</dt>
											<dd>
												<div class="star_score_bgray">
													<span class="review_point40"><span class="blind">4점</span></span>
												</div>
											</dd>
											<dt>상품안내</dt>
											<dd>
												<div class="star_score_bgray">
													<span class="review_point40"><span class="blind">4점</span></span>
												</div>
											</dd> -->
										</dl>
										<div class="comment_view_txt">아이들 데리고 처음 가는 해외여행이라
											걱정했는데.. 리조트까지 픽업서비스가 잘 되어있어서 별 무리없이 잘 다녀왔습니다.. 리조트의 경우
											한국사람이 많아서인지 한국인까지 있어서 필요한걸 물어볼 수 있어서 좋았습니다. 감사합니다~</div>
										<!-- <div class="btn_comment_area">
											<input type="button" value="수정" class="btn_comment_modify" /><input
												type="button" value="삭제" class="btn_comment_delete" />
										</div>
										<div class="reply_area">
											<div class="reply_txt">로그인 후 소중한 의견을 남겨주세요.</div>
											<span class="btn_reply">댓글쓰기</span>
										</div> -->

									</div>
								</td>
								</tr>
								<tr>
									<td nowrap="nowrap">04</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point30"><span class="blind">3점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">03</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point20"><span class="blind">2점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">02</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point10"><span class="blind">1점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">01</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point50"><span class="blind">5점</span></span>
										</div></td>
								</tr>


							</tbody>
						</table>
					</div>
				</div>
				<!-- rtab_01 테이블(읽기) 끝 -->
				<!--rtab_01 테이블(글쓰기) 시작-->
				<%-- <div class="rtab_01_area">
					<div class="review_tablestyle">
						<table summary="" cellpadding="0" cellspacing="0">
							<caption>게시판 템플릿 목록</caption>
							<colgroup>
								<col width="115px">
								<col width="143px">
								<col width="535px">
							</colgroup>
							<tbody>
							<thead></thead>
							<tr>
								<th scope="col" class="listleft lineright">구매상품정보</th>
								<td scope="col" colspan="2" class="listleft"># 세부
									날루수안&힐루뚱안 호핑투어</td>
							</tr>
							<tr>
								<th scope="col" class="listleft lineright" rowspan="3">만족도
									평가</th>
								<td scope="col" class="listleft lineright ss_head">상품구성(숙소/식사)</td>
								<td scope="col" class="listleft">
									<ul class="ss_write_area">
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point50"><span class="blind">5점</span></span></li>
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point40"><span class="blind">4점</span></span></li>
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point30"><span class="blind">3점</span></span></li>
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point20"><span class="blind">2점</span></span></li>
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point10"><span class="blind">1점</span></span></li>
									</ul>
								</td>
							</tr>
							<tr>
								<td scope="col" class="listleft lineright ss_head">일정구성</td>
								<td scope="col" class="listleft">
									<ul class="ss_write_area">
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point50"><span class="blind">5점</span></span></li>
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point40"><span class="blind">4점</span></span></li>
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point30"><span class="blind">3점</span></span></li>
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point20"><span class="blind">2점</span></span></li>
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point10"><span class="blind">1점</span></span></li>
									</ul>
								</td>
							</tr>
							<tr>
								<td scope="col" class="listleft lineright ss_head">상품안내</td>
								<td scope="col" class="listleft">
									<ul class="ss_write_area">
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point50"><span class="blind">5점</span></span></li>
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point40"><span class="blind">4점</span></span></li>
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point30"><span class="blind">3점</span></span></li>
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point20"><span class="blind">2점</span></span></li>
										<li><input name="" type="radio" value="">
										<div class="sscore_bgray">
												<span class="review_point10"><span class="blind">1점</span></span></li>
									</ul>
								</td>
							</tr>
							<tr>
								<th scope="col" class="listleft lineright">제목</th>
								<td scope="col" class="listleft" colspan="2"><input
									type="text" class="input_tit" /></td>
							</tr>
							<tr>
								<th scope="col" class="listleft lineright">내용</th>
								<td scope="col" class="listleft" colspan="2"><textarea
										class="txt_write"></textarea><br /> <span class="small_txt">상품평과
										상관없는 홍보글 또는 비방글 등은 사전 통보없이 관리자에 의해 삭제될 수 있습니다.</span> <span
									class="small_txt2">글자수 10자 이상 작성가능</span></td>
							</tr>



							</tbody>
						</table>

					</div>


				</div> --%>
				<!-- rtab_01 테이블(글쓰기) 끝 -->
				<!-- rtab_02 테이블-->
				<div class="rtab_02_area">
					<div class="default_tablestyle">
						<table summary="" cellpadding="0" cellspacing="0">
							<caption>게시판 템플릿 목록</caption>
							<colgroup>
								<col width="80px">
								<col width="433px">
								<col width="100px">
								<col width="100px">
								<col width="80px">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">순번</th>
									<th scope="col">제목</th>
									<th scope="col">작성자</th>
									<th scope="col">작성일</th>
									<th scope="col">평점</th>
								</tr>
							</thead>

							<tbody>
								<tr>
									<td nowrap="nowrap">99</td>
									<td nowrap="nowrap" class="listleft">생애 첫dsdsdsdfsd 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point40"><span class="blind">4점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">04</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point30"><span class="blind">3점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">03</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point20"><span class="blind">2점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">02</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point10"><span class="blind">1점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">01</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point50"><span class="blind">5점</span></span>
										</div></td>
								</tr>


							</tbody>
						</table>

					</div>
				</div>
				<!-- rtab_02 테이블 끝 -->



			</div>

			<!--이용후기영역 끝-->
		</div>
		<!--좌측 끝-->
		<!--우측-->
		<div class="infor_productarea_right">
			<ul class="photolst_area">
			<c:forEach var="list" items="${fileList}" varStatus="status">
			<li <c:if test="${status.count%6 == 0}">class="pright"</c:if>>
				<img src="<c:url value='/file/getImageThumb/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN}" width="43" height="43">
			</li></c:forEach>
			</ul>
			<p class="btn_review_right">이용후기 보러가기</p>
			<div class="right_qna">
				<p class="rtit">온라인 문의</p>
				<dl>
					<dt>직통전화:</dt>
					<dd>02-3479-4248</dd>
					<dt>이메일:</dt>
					<dd>ssyeon224@interpark.com</dd>
					<dt>팩스번호:</dt>
					<dd>070-4850-8262</dd>

					<dt class="w100">상담시간안내</dt>
					<dd>평일 09:00 ~ 18:00 주말 / 공휴일 09:00 ~ 17:00</dd>
				</dl>


			</div>
		</div>
		<!--우측 끝-->
	</div>
	<!--컨텐츠 설명영역 끝-->
</div>
<!--인포메이션 끝-->
</form>
</body>