<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<head>
<script type="text/javascript">	
	function fnDeleteCart(cart_sn) {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidCartSn]").val(cart_sn);
		form.attr({"method":"post","action":"<c:url value='/cart/delAction/'/>"});
		form.submit();
	}

	function fnCalendar(){
		var popNm = "popCalendar";
		var valUrl = "<c:url value='/cart/calendarPopup/'/>";
		var strStatus = "width=800,height=600,toolbar=no,status=no,scrollbars=yes,resizable=yes";
		var debugWin = window.open(valUrl, popNm, strStatus);
		debugWin.focus();
	}

	function fnSchedule() {
		var popNm = "popSchedule";
		var valUrl = "<c:url value='/cart/schedulePopup/'/>";
		var strStatus = "width=1024,height=768,toolbar=yes,status=yes,scrollbars=yes,resizable=yes";
		var debugWin = window.open(valUrl, popNm, strStatus);
		debugWin.focus();
	}
	
	function fnPurchase(){
		$.ajax({
			url : "<c:url value='/purchs/addAction/'/>",
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
	
	function fnSearchGoods() {
		var form = $("form[id=frmGoodsCategory]");
		form.submit();
	}
</script>
</head>

<body>	
<div class="location">
	<p class="loc_area">
		홈<span class="arrow_loc"></span>투어상품
	</p>
</div>
<!--컨텐츠 시작-->
<div class="infor_area">
	<!--result 탭시작-->
	<div id="carttab_set_02">
		<p class="line-left"></p>
		<p class="rtab_cart_selected">
			<a href='#'>장바구니</a>
		</p>
		<p class="rtab">
			<a href='#'>결제목록</a>
		</p>
		<p class="rtab">
			<a href='#'>찜목록</a>
		</p>
		<!--result 탭끝-->
	</div>
	<!-- 중앙정렬 -->
	<div class="edit_center">
		<div class="bar">
			<span class="bar_txt">장바구니에 총 <span class="t_blue">${payCount}</span>개의 상품이 있습니다.
			</span>
			<div class="fl_right">
				<fieldset>
					<span class="bar_txt2">전체선택</span> <span class="ch_box_top"><img src="/images/chbox.gif"
						onClick="this.src=(this.src=='/images/chbox.gif')?'/images/chbox.gif':'/images/chbox_hover.gif'; document.getElementsByName('')[].checked=(this.src=='/images/chbox_hover.gif')?true:false;"></span>
					<span class="bar_txt2">선택취소</span> <span class="ch_box_top"><img src="/images/chbox.gif"
						onClick="this.src=(this.src=='/images/chbox.gif')?'/images/chbox.gif':'/images/chbox_hover.gif'; document.getElementsByName('')[].checked=(this.src=='/images/chbox_hover.gif')?true:false;"></span>
					<input type="button" value="선택삭제" class="btn_cart_select_del" />

				</fieldset>
			</div>
		</div>
		<!--carttab_01 시작-->
		<div class="carttab_01_area">
			<div class="cart_resultlst_area">
				<ul>
				<c:forEach var="result" items="${cartList}" varStatus="status">
					<li>
						<p class="pr2_photo_area">
							<!-- <span class="hotdeal2">★핫딜</span> --><img src="<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}" width="auto" height="150">
						</p>
						<div class="pr2_rtxt_area">
							<p class="fl_left circle">A</p>
							<dl>
								<dt>
									<span class="p_head">${result.GOODS_NM}</span>
									<span class="p_del"></span>
									<p class="subtxtarea">
										<span class="blt_box">이용일</span>
										<span class="sub_01">
										<c:if test="${!empty result.TOUR_DE}">
											${fn:substring(result.TOUR_DE,0,4)}년 ${fn:substring(result.TOUR_DE,4,6)}월 ${fn:substring(result.TOUR_DE,6,8)}일
										</c:if>
										<c:if test="${!empty result.CHKIN_DE}">
											${fn:substring(result.CHKIN_DE,0,4)}년 ${fn:substring(result.CHKIN_DE,4,6)}월 ${fn:substring(result.CHKIN_DE,6,8)}일 ~ ${fn:substring(result.CHCKT_DE,0,4)}년 ${fn:substring(result.CHCKT_DE,4,6)}월 ${fn:substring(result.CHCKT_DE,6,8)}일
										</c:if>										
										</span>
									</p>
									<c:if test="${result.CL_SE eq 'S'}">
									<c:forEach var="options" items="${result.OPTIONS}" varStatus="status">
									<p class="subtxtarea">
										<span class="blt_box">${options.SETUP_NM}</span>
										<span class="sub_01">${options.NMPR_CND}</span>
									</p>									
									</c:forEach>
									</c:if>
									<c:if test="${result.CL_SE ne 'S'}">
									<p class="subtxtarea">
										<span class="blt_box">이용시간</span>
										<span class="sub_01">${fn:substring(result.BEGIN_TIME,0,2)}시 ${fn:substring(result.BEGIN_TIME,2,4)}분 ~ ${fn:substring(result.END_TIME,0,2)}시 ${fn:substring(result.END_TIME,2,4)}분</span>
									</p>
									<p class="subtxtarea">
										<span class="blt_box">${result.OPTIONS[0].SETUP_NM}</span>
										<span class="sub_01">
										<c:forEach var="options" items="${result.OPTIONS}" varStatus="status">
										${options.NMPR_CND} ${options.NMPR_CO}명  <c:if test="${!status.last}">/</c:if>
										</c:forEach>
										</span>
									</p>									
									</c:if>									
								</dt>
								<dd>
									<fmt:formatNumber value="${result.PURCHS_AMOUNT}" pattern="#,###" /><span class="txt_won">원</span>
								</dd>
							</dl>

						</div>
						<p class="category2">${result.CTY_NM} > ${result.UPPER_CL_NM} > ${result.CL_NM}</p>
					</li>
					</c:forEach>				
					<li>
						<p class="pr2_photo_area">
							<!-- <span class="hotdeal2">★핫딜</span> --><img src="/images/pr_img_01.jpg" width="auto" height="150">
						</p>
						<div class="pr2_rtxt_area">
							<p class="fl_left circle">A</p>
							<dl>
								<dt>
									<span class="p_head">샹그릴라 막탄 리조트 / Shangri-La Mactan
										Resort </span> <span class="p_del"></span>
									<p class="subtxtarea">
										<span class="blt_box">이용일</span> <span class="sub_01">2017년
											9월 6일~2017년 9월 12일 </span>
									</p>
									<p class="subtxtarea">
										<span class="blt_box">옵션</span> <span class="sub_01">옵션
											선택(필수) > 세부 먹방 투어 : 20:00PM~23:55PM </span>
									</p>
									<p class="subtxtarea">
										<span class="blt_box">인원</span> <span class="sub_01">성인
											1 명 / 아동 0 명 / 유아 0 명 </span>
									</p>
								</dt>
								<dd>
									378905<span class="txt_won">원</span>
								</dd>
							</dl>

						</div>
						<p class="category2">숙박</p>
					</li>

				</ul>

				<!--결제금액 시작-->
				<p class="total_price_area">
					결제 총 금액 <span class="pinkprice"><fmt:formatNumber value="${payment}" pattern="#,###" /><span class="txt_won">원</span></span>
				</p>
				<p class="total_point_area">
					적립예정포인트<span class="pinkprice">3700<span class="txt_won">POINT</span></span>
				</p>
				<p class="total_point_area">
					<a href="javascript:fnPurchase()">결제하기</a>				
				</p>
				<p class="notibox_area">
					<span class="notice_text">※ 결제금액은 결제 당일 환율을 기준으로 책정됩니다.
						결제일 기준 환율에 따라 캐리어 내 상품가 변동이 있을 수 있습니다.<br /> ※ 이용예정일이 지나거나 판매
						중지 상품은 캐리어에서 삭제됩니다.
					</span>
				</p>
				<!--결제금액 끝-->
			</div>
		</div>
		<!--carttab영역 끝-->
	</div>
	<!-- 중앙정렬 끝 -->
</div>
<!--컨텐츠 끝-->
</body>