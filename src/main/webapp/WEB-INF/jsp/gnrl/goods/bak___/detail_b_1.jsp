<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jquery.selectbox.css'/>" />
<style type="text/css">
 #num2_dropdown01 .list-unstyled {
	padding-left: 0;
	list-style: none;
}
#num2_dropdown01 ul {
	height: 30px;
	width: 150px;
	border: 1px #000 solid;
}
#num2_dropdown01 ul li {
	padding: 5px 10px;
	z-index: 2;
}
#num2_dropdown01 ul li:not(.init ) {
	float: left;
	width: 130px;
	display: none;
	background: #ddd;
}
#num2_dropdown01 ul li:not(.init ):hover, ul li.selected:not(.init ) {
	background: #09f;
}
#num2_dropdown01 li.init {
	cursor: pointer;
}
#num2_dropdown01 a#submit {
	z-index: 1;
}
</style>

<style type="text/css">
.box {
  width:calc(90% - 200px);
  padding:30px 100px 20px;
  margin:10px auto;
}
.box + .box {
  border-top:2px solid #bdbdbd;
}
.box::after {
  content:'';
  display:block;
  clear:both;
}
.box > * {
  float:left;
  width:50%;
}
.box .explain {
  padding-right: 50px;
  box-sizing:border-box;
}
.box p {
  text-align: right;
  color:#006fff; 
  font-weight: bold; 
}
.box select {
  outline:none;
}




</style>
<script type="text/javascript" src="<c:url value='/js/jquery.comiseo.daterangepicker.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/moment.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.selectbox-0.2.min.js'/>"></script>
<script type="text/javascript">
	window.onload = function(){
		// 상품소개 선택 init
		$("#informenu4_set_01 .tab_01_area").css('visibility','visible').css('display','block');
		$("#informenu4_set_01 .tab_01").wrapInner('<a href="#"/>');
		
		// 금액 선택 init
		//$("#num2_dropdown01 ul").closest("ul").children('li:not(.init)').toggle();
		//var allOptions = $("#num2_dropdown01 ul").children('li:not(.init)');
		//allOptions.toggle();
		
		// 상품소개 선택
		$("#informenu4_set_01 > p").click(function(){
			var pClass = $(this).attr("class");
			var divClass = ("#informenu4_set_01 ." + pClass + "_area");

			$("#informenu4_set_01 > div").css('visibility','hidden').css('display','none');
			$("#informenu4_set_01 > p").find("a").contents().unwrap();
			
			$(divClass).css('visibility','visible').css('display','block');
			$(this).wrapInner('<a href="#"/>');
		});
		
		// 날짜 선택
		$(".btn_op_calendar").click(function(){
			fnCalendarPopup('txtDate', '${result.CF_MIN_BEGIN_DE}', '${result.CF_MAX_END_DE}');
		});
		
		// 금액 선택
		$("#num2_dropdown01 ul").on("click", ".init", function() {
		    $(this).closest("ul").children('li:not(.init)').toggle();
		});

		var allOptions = $("#num2_dropdown01 ul").children('li:not(.init)');
		$("#num2_dropdown01 ul").on("click", "li:not(.init)", function() {
		    allOptions.removeClass('selected');
		    $(this).addClass('selected');
		    $("#num2_dropdown01 ul").children('.init').html($(this).html());
		    allOptions.toggle();
		});		
	}

	function fnList() {
		var form = $("form[id=frmDetail]");
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}

	function fnSearch(cl_code) {
		var form = $("form[id=frmDetail]");
		$("input:hidden[id=hidUpperClCode]").val(cl_code);
		$("input:hidden[id=hidPage]").val(1);
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}

	function fnTimeClick(){
		$("input:radio[name=rdoTime]").each(function() {
			if($(this).is(":checked")) {
				$("input:hidden[id=hidTime]").val($(this).val());
				$("input:text[id=txtTime]").val($(this).val().substring(0,2) + ":" + $(this).val().substring(2,4) + " ~ " + $(this).val().substring(4,6) + ":" + $(this).val().substring(6,8));
			}
		});
	}

	function fnNmprChange(){
		var form = $("form[id=frmDetail]");

		var payment = 0;
		if("${result.STAYNG_FCLTY_AT}" == "Y") {
			$("select[name=selNmprCo]").each(function() {
				payment += $("input:hidden[id="+ this.id +"]").val() * this.value;
			});
			payment = payment * parseInt($("#txtDateCount").val());
		} else {
			$("select[name=selNmprCo]").each(function() {
				payment += $("input:hidden[id="+ this.id +"]").val() * this.value;
			});
		}

		$("input:text[id=txtPay]").val("₩ "+payment);
	}

	function fnAddCart(){
		if("${result.STAYNG_FCLTY_AT}" == "N") {
			var strDate = $("input:text[id=txtDate]").val();
			if(strDate.length!=10){
				alert(strDate);
				return;
			}
		} else if("${result.STAYNG_FCLTY_AT}" == "N") {
			var strDate = $("input:text[id=hidChkinDe]").val();
			if(strDate.length!=10){
				alert("체크인 날짜를 선택하세요.");
				return;
			}

			strDate = $("input:text[id=hidChcktDe]").val();
			if(strDate.length!=10){
				alert("체크아웃 날짜를 선택하세요.");
				return;
			}

			var chkTimeVal = $("input:radio[name=rdoTime]:checked").val();
			if(!chkTimeVal) {
				alert("시간을 선택하세요");
				return;
			}
		}

		var totCo = 0;
		$("select[name=selNmprCo]").each(function() {
			totCo+=this.value
		});
		if(totCo < 1){
			alert("인원을 입력하세요");
			return;
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
					if(confirm("구매 조건이 수정되었습니다. 장바구니로 이동하시겠습니까?")) {
						fnList();
					} else {
						fnCartList();
					}
				} else if(json.result == "-2") {
					alert("로그인이 필요합니다.");
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
</script>
</head>
<body>
<form id="frmDetail" name="frmDetail" method="post" action="<c:url value='/goods/list/'/>">
<input type="hidden" id="hidPage" name="hidPage" value="${hidPage}">
<input type="hidden" id="hidGoodsCode" name="hidGoodsCode" value="${goods_code}">
<input type="hidden" id="hidUpperClCode" name="hidUpperClCode" value="${hidUpperClCode}">
<input type="hidden" id="hidUpperClCodeNavi" name="hidUpperClCodeNavi" value="${hidUpperClCodeNavi}">
<input type="hidden" id="hidStayngFcltyAt" name="hidStayngFcltyAt" value="${stayngFcltyAt}">
<input type="hidden" id="hidWaitTime" name="hidWaitTime" value="${result.WAIT_TIME}">
<input type="hidden" id="hidMvmnTime" name="hidMvmnTime" value="${result.MVMN_TIME}">
<div class="location">
	<p class="loc_area">
		홈<span class="arrow_loc"></span>투어상품
	</p>
</div>
<div class="infor_area">
	<!--윈도우시작-->
	<div id="window">
		<p class="hotdeal">★핫딜</p>
		<p class="a_pre"></p>
		<p class="a_next"></p>
		<p class="main_photo">
			<iframe src="<c:url value='/file/imageListIframe/'/>?file_code=${result.FILE_CODE}" width="100%" height="100%"></iframe>
			<%-- <img src="<c:url value='/images/pr_img_01.jpg'/>" width="824" height="428"> --%>
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
						<li class="num01">날짜
							<input type="text" name="txtDate" id="txtDate" style="width:150px;height:25px;text-align:center;font-size:13px;" value="일정을 선택하세요" readonly onfocus="this.blur()">
							<span class="btn_op_calendar" id="btn_op_calendar"></span>
						</li>
						<li class="num02">시간
							<span class="btn_arrow_down"></span> <!--드랍다운-->
							<%-- <div id="num2_dropdown01">
								<ul class="list-unstyled">
									<li class="init">시간선택</li>
								<c:forEach var="list" items="${timeList}" varStatus="status">
								    <li data-value="${list.TOUR_TIME}" style="display: none;">${fn:substring(list.BEGIN_TIME,0,2)} : ${fn:substring(list.BEGIN_TIME,2,4)} ~ ${fn:substring(list.END_TIME,0,2)} : ${fn:substring(list.END_TIME,2,4)}</li>
								</c:forEach>
								</ul>
							</div> --%>
							
							
							

							<select name="rdoTime" id="rdoTime" style="width:150px;height:25px;text-align:center;font-size:13px;">
								<option value="">선택</option>
							<c:forEach var="list" items="${timeList}" varStatus="status">
								<option value="${list.TOUR_TIME}">${fn:substring(list.BEGIN_TIME,0,2)} : ${fn:substring(list.BEGIN_TIME,2,4)} ~ ${fn:substring(list.END_TIME,0,2)} : ${fn:substring(list.END_TIME,2,4)}</option>
							</c:forEach>
							</select>

							
							
						</li>
						<li class="num03">인원
							<span class="btn_arrow_down"></span>
							<c:forEach var="list" items="${nmprList}" varStatus="status">
								<div>
								${list.NMPR_CND} (₩ ${list.SETUP_AMOUNT}) 
								<select name="selNmprCo" id="txtNmprCo${list.NMPR_SN}" onchange="fnNmprChange()">
								<c:forEach var="i" begin="0" end="10" step="1">
								<option value="${i}" <c:if test="${i == '0'}">selected="selected"</c:if>>${i}</option>
								</c:forEach>
								</select>
								<input type="hidden" name="hidPayment" id="txtNmprCo${list.NMPR_SN}" value="${list.SETUP_AMOUNT}">
								<input type="hidden" name="hidNmprSn" id="hidNmprSn" value="${list.NMPR_SN}">
								</div>
							</c:forEach>
														
						</li>
						<!--
						<li class="num04">픽업<span class="btn_arrow_down"></span></li>
						<li class="num05">인원<span class="btn_arrow_down"></span></li>
						 -->
					</ul>
					<p id="price">
						<input type="text" name="txtPay" id="txtPay" class="txt_price"  style="width:150px;height:25px;text-align:center;font-size:13px;" value ="인원을 선택하세요" readonly onfocus="this.blur()">
						<!-- <span class="txt_price">312,127</span>원 -->
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
			<ul class="information7_area">
			<c:if test="${!empty result.INTRCN_GOODS_TY}">
				<li><img src="<c:url value='/images/picon_01.gif'/>" width="42" height="42"><span>상품유형</span>
				<sapn class="infor7_txt"><c:if test="${result.INTRCN_GOODS_TY eq 'G'}">단체투어</c:if><c:if test="${result.INTRCN_GOODS_TY eq 'P'}">프라이빗투어</c:if></span></li>
			</c:if><c:if test="${!empty result.INTRCN_USE_TIME}">
				<li><img src="<c:url value='/images/picon_02.gif'/>" width="42" height="42"><span>이용시간</span>
				<sapn class="infor7_txt">${result.INTRCN_USE_TIME}</span></li>
			</c:if><c:if test="${!empty result.INTRCN_MEET_TIME}">
				<li><img src="<c:url value='/images/picon_03.gif'/>" width="42" height="42"><span>집합시간</span>
				<sapn class="infor7_txt">${result.INTRCN_MEET_TIME}</span></li>
			</c:if><c:if test="${!empty result.INTRCN_REQRE_TIME}">
				<li><img src="<c:url value='/images/picon_03.gif'/>" width="42" height="42"><span>소요시간</span>
				<sapn class="infor7_txt">${result.INTRCN_REQRE_TIME}</span></li>
			</c:if><c:if test="${!empty result.INTRCN_PROVD_LANG}">
				<li><img src="<c:url value='/images/picon_03.gif'/>" width="42" height="42"><span>제공언어</span>
				<sapn class="infor7_txt">${result.INTRCN_PROVD_LANG}</span></li>
			</c:if><c:if test="${!empty result.INTRCN_POSBL_AGE}">
				<li><img src="<c:url value='/images/picon_03.gif'/>" width="42" height="42"><span>가능연령</span>
				<sapn class="infor7_txt">${result.INTRCN_POSBL_AGE}</span></li>
			</c:if><c:if test="${!empty result.INTRCN_PLACE}">
				<li><img src="<c:url value='/images/picon_03.gif'/>" width="42" height="42"><span>장소</span>
				<sapn class="infor7_txt">${result.INTRCN_PLACE}</span></li>
			</c:if>
			</ul>
			<!--인포4 메뉴영역 시작-->
			<div id="informenu4_set_01">
				<p class="tab_01"><a href='#'>이용안내</a></p>
				<p class="tab_02">추가안내 및 유의사항</p>
				<p class="tab_03">변경 및 환불규정</p>
				<p class="tab_04">위치안내</p>

				<!--tab_01 테이블-->
				<div class="tab_01_area">
					<div class="default_tablestyle">
						<table summary="" cellpadding="0" cellspacing="0">
							<caption>이용 안내</caption>
							<colgroup>
								<col width="120px">
								<col width="673px">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">구분</th>
									<th scope="col">상품안내</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td nowrap="nowrap" class="line_right">바우처</td>
									<td nowrap="nowrap" class="listleft">
									    1. 티켓형태: <c:if test="${result.VOCHR_TICKET_TY eq 'V'}">E-바우처</c:if>
													<c:if test="${result.VOCHR_TICKET_TY eq 'T'}">E-티켓(캡쳐가능)</c:if>
													<c:if test="${result.VOCHR_TICKET_TY eq 'E'}">확정메일(캡쳐가능)</c:if>
									    <br />
										2. 발권소요시간: ${result.VOCHR_NTSS_REQRE_TIME}<br />
										3. 사용방법<br />${result.VOCHR_USE_MTH}<br />
									<!-- <br /> <span class="t_blue">※ 카톡확인 후 꼭 답장해주세요.</span><br />  -->
									<br />

									</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="line_right">소요시간</td>
									<td nowrap="nowrap" class="listleft">${result.GUIDANCE_REQRE_TIME}<br />
										 <!-- <span class="t_blue">※ 호핑일정은 당일 기상에 따라
											30분~1시간 정도로 유동성이 있습니다.<br /> &nbsp; &nbsp; 호핑 다음일정은 호텔 도착
											후 넉넉하게 19:00PM으로 잡아주세요.시간 정도로 유동성이 있습니다.
									</span>  -->

									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- tab_01 테이블 끝 -->
				<!-- tab_02 테이블-->
				<div class="tab_02_area">
					<div class="default_tablestyle">
						<table summary="" cellpadding="0" cellspacing="0">
							<caption>추가안내 및 유의사항</caption>
							<colgroup>
								<col width="120px">
								<col width="673px">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">구분</th>
									<th scope="col">상품안내</th>
								</tr>
							</thead>

							<tbody>
								<tr>
									<td nowrap="nowrap" class="line_right">추가안내</td>
									<td nowrap="nowrap" class="listleft">${result.ADIT_GUIDANCE}</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="line_right">유의사항</td>
									<td nowrap="nowrap" class="listleft">${result.ATENT_MATTER}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- tab_02 테이블 끝 -->
				<!-- tab_03 테이블-->
				<div class="tab_03_area">
					<div class="default_tablestyle">
						<table summary="" cellpadding="0" cellspacing="0">
							<caption>변경 및 환불규경</caption>
							<colgroup>
								<col width="120px">
								<col width="673px">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">구분</th>
									<th scope="col">상품안내</th>
								</tr>
							</thead>

							<tbody>
								<tr>
									<td nowrap="nowrap" class="line_right">변경 및 환불규경</td>
									<td nowrap="nowrap" class="listleft">${result.CHANGE_REFND_REGLTN}</td>
								</tr>
							</tbody>
						</table>
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
					<a href='#'>상품평<span class="sky">(13건)</span></a>
				</p>
				<p>상품 Q&A</p>
				<input type="button" value="글쓰기" class="btn_review_write" />
				<!--rtab_01 테이블(목록) 시작-->
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

				</div>
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
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point40"><span class="blind">4점</span></span>
										</div></td>
								</tr>
								<td class="td_comment_view" colspan="5">
									<div class="comment_view">
										<dl>
											<dt>상품구성(숙소/식사)</dt>
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
											</dd>
										</dl>
										<div class="comment_view_txt">아이들 데리고 처음 가는 해외여행이라
											걱정했는데.. 리조트까지 픽업서비스가 잘 되어있어서 별 무리없이 잘 다녀왔습니다.. 리조트의 경우
											한국사람이 많아서인지 한국인까지 있어서 필요한걸 물어볼 수 있어서 좋았습니다. 감사합니다~</div>
										<div class="btn_comment_area">
											<input type="button" value="수정" class="btn_comment_modify" /><input
												type="button" value="삭제" class="btn_comment_delete" />
										</div>
										<div class="reply_area">
											<div class="reply_txt">로그인 후 소중한 의견을 남겨주세요.</div>
											<span class="btn_reply">댓글쓰기</span>
										</div>

									</div>
								</td>
								<tr>
								</tr>
								<tr>
									<td nowrap="nowrap">04</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point40"><span class="blind">4점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">03</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point40"><span class="blind">4점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">02</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point40"><span class="blind">4점</span></span>
										</div></td>
								</tr>
								<tr>
									<td nowrap="nowrap">01</td>
									<td nowrap="nowrap" class="listleft">생애 첫 호핑투어!</td>
									<td nowrap="nowrap">honggildong</td>
									<td nowrap="nowrap">2017.05.05</td>
									<td nowrap="nowrap"><div class="star_score">
											<span class="review_point40"><span class="blind">4점</span></span>
										</div></td>
								</tr>


							</tbody>
						</table>
					</div>
				</div>
				<!-- rtab_01 테이블(읽기) 끝 -->
				<!--rtab_01 테이블(글쓰기) 시작-->
				<div class="rtab_01_area">
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


				</div>
				<!-- rtab_01 테이블(글쓰기) 끝 -->
				<!-- rtab_02 테이블-->
				<div class="rtab_02_area">
					<div class="default_tablestyle"></div>
				</div>
				<!-- rtab_02 테이블 끝 -->



			</div>

			<!--이용후기영역 끝-->
		</div>
		<!--좌측 끝-->
		<!--우측-->
		<div class="infor_productarea_right">
			<ul class="photolst_area">
				<li><img src="<c:url value='/images/sphoto.gif'/>" width="43" height="43"></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li class="pright"></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li class="pright"></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li class="pright"></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li class="pright"></li>
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
