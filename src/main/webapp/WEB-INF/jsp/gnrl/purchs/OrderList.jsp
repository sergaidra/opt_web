<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<!-- 날짜선택 -->	
<script src="/jq/time/build/jquery.datetimepicker.full.js"></script> 

<script type="text/javascript">
var DAY = 1000 * 60 * 60 * 24;

$(function(){	
	$.datetimepicker.setLocale('en');

	$('.some_class').datetimepicker( {
		format:'Y-m-d',
		timepicker:false
	});
	
	$("input[name='chkRange']").click(function () {
		$("input[name='chkRange']").prop("checked", false);
		$(this).prop("checked", true);
		$('#end_dt').val(getToday());
		switch($(this).val()) {
		case "0":	// 오늘
			$('#start_dt').val(getToday());
			break;
		case "1":	// 1주일
			$('#start_dt').val(getDateToString(new Date(new Date() - (7 * DAY))));
			break;
		case "2":	// 15일
			$('#start_dt').val(getDateToString(new Date(new Date() - (15 * DAY))));
			break;
		case "3":	// 1개월
			$('#start_dt').val(getDateToString(new Date(new Date() - (30 * DAY))));
			break;
		case "4":	// 3개월
			$('#start_dt').val(getDateToString(new Date(new Date() - (90 * DAY))));
			break;
		case "5":	// 6개월
			$('#start_dt').val(getDateToString(new Date(new Date() - (180 * DAY))));
			break;
		case "6":	// 1년
			var dd = new Date();
			dd.setFullYear(dd.getFullYear() - 1);
			$('#start_dt').val(getDateToString(dd));
			break;
		}
	});
	
	$("#btnSearch").click(function () {
		$("#search_start_dt").val($("#start_dt").val().replace(/[\-]/g, ""));
		$("#search_end_dt").val($("#end_dt").val().replace(/[\-]/g, ""));
		search(1);
	});
	
	$(".star_icon i").click(function () {
		$(".star_icon i").removeClass("on");
		var myIdx = $(this).index();
		$(".featherlight .star_icon i").each(function (index) {
			if(index <= myIdx)
				$(this).addClass("on");
		});
	});
	
	$('.some_class').val(getToday());
	
	$("#btnSearch").trigger("click");
});

function search(pageNo) {
	var url = "<c:url value='/purchs/getPurchsList'/>";
	$("#tblList tbody").empty(); 
	$("#paging").empty(); 
	
	var param = {};
	param.hidPage = pageNo;
	param.start_dt = $("#search_start_dt").val();
	param.end_dt = $("#search_end_dt").val();
	$("#hidPage").val(pageNo);
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
        	for(var cnt = 0; cnt < data.list.length; cnt++) {
        		var tr = $("<tr></tr>");
        		var td1 = $("<td class='left'><img src='<c:url value='/file/getImage/'/>?file_code=" + data.list[cnt].FILE_CODE + "' width='150' alt='''/></td>");
        		var td2 = $("<td >" + data.list[cnt].PURCHS_SN + "<br /><a href='#' class='big-link button white medium' data-reveal-id='myModal' ></a></td>");
        		var td3 = $("<td >" + dateWithHyphen(data.list[cnt].PURCHS_DE) + "</td>");
        		var td4 = $("<td class='left'></td>");
        		var td5 = $("<td class='right'><span class='point_color_b4'>" + numberWithCommas(data.list[cnt].TOT_SETLE_AMOUNT) + "원</span></td>");
        		var td6 = $("<td >결제진행중<br><a href='javascript:cancelPurchs(\"" + data.list[cnt].PURCHS_SN + "\", \"" + data.list[cnt].CART_SN + "\");' class='sbtn_01'>취소하기</a>"
        					+ "<a href='javascript:openWriteReview(\"" + data.list[cnt].PURCHS_SN + "\", \"" + data.list[cnt].CART_SN + "\", \"" + data.list[cnt].GOODS_CODE + "\");' class='sbtn_01' >후기쓰기</a></td>");

        		if(data.list[cnt].CL_SE == 'S') {
            		$(td4).append("<div class='tx1'>[" + dateWithHyphen(data.list[cnt].CHKIN_DE) + " ~ " + dateWithHyphen(data.list[cnt].CHCKT_DE) + "]</div>");
        		} else {
            		$(td4).append("<div class='tx1'>[" + dateWithHyphen(data.list[cnt].TOUR_DE) + " " + timeWithColon(data.list[cnt].BEGIN_TIME) + " ~ " + timeWithColon(data.list[cnt].END_TIME) + "]</div>");
        		}
        		$(td4).append("<div class='tx2'>" + data.list[cnt].GOODS_NM + "</div>");
        		var td4sub = $("<div class='tx3'></div>");
        		for(var cnt2 = 0; cnt2 < data.list[cnt].OPTIONS.length; cnt2++) {
            		if(data.list[cnt].CL_SE == 'S') {
            			$(td4sub).append("옵션 : " + data.list[cnt].OPTIONS[cnt2].SETUP_NM + " " + data.list[cnt].OPTIONS[cnt2].NMPR_CND);            			
            		} else {
            			$(td4sub).append("옵션 : " + data.list[cnt].OPTIONS[cnt2].NMPR_CND + " " + data.list[cnt].OPTIONS[cnt2].NMPR_CO + "명");
            		}           		
            		if(cnt2 + 1 != data.list[cnt].OPTIONS.length)
            			$(td4sub).append("<br/>");
        		}
        		$(td4).append(td4sub);
        		
        		$(tr).append(td1);
        		$(tr).append(td2);
        		$(tr).append(td3);
        		$(tr).append(td4);
        		$(tr).append(td5);
        		$(tr).append(td6);
        		
	        	$("#tblList tbody").append(tr);        
        	}
        	
        	// 페이징 처리
        	var totalCount = Number(data.totalCount);
        	var pageNo = Number($("#hidPage").val());
        	var blockSize = Number($("#blockSize").val());
        	var pageSize = Number($("#pageSize").val());
        	
        	// 첫 페이지 검색
        	var startPageNo = (pageNo - 1) / blockSize + 1;
        	var totalPageCnt = Math.ceil(totalCount / pageSize);
        	
        	if(startPageNo > 1) {
        		$("#paging").append("<a href='javascript:search(1);' class='pre_end'>← First</a>");
        		$("#paging").append("<a href='javascript:search(" + (startPageNo - 1) + ");' class='pre'>이전</a>");
        	}

        	for(var cnt = 0; cnt < blockSize; cnt++) {
        		var page = startPageNo + cnt;
        		if(page > totalPageCnt)
        			break;
        		if(page == pageNo)
        			$("#paging").append("<a href='javascript:search(" + page + ");' class='on'>" + page + "</a>");
        		else
        			$("#paging").append("<a href='javascript:search(" + page + ");'>" + page + "</a>");
        	}
        	
        	if(startPageNo + blockSize <= totalPageCnt) {
        		$("#paging").append("<a href='javascript:search(" + (startPageNo + blockSize) + ");' class='next'>다음</a>");
        		$("#paging").append("<a href='javascript:search(" + totalPageCnt + ");' class='next_end'>Last → </a>");
        	}
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});			

}

function openWriteReview(purchs_sn, cart_sn, goods_code) {
	var url = "<c:url value='/purchs/getPurchsReview'/>";
	$(".star_icon i").removeClass("on"); 
	$("#review_cn").val("");
	$("#review_purchs_sn").val(purchs_sn);
	$("#review_cart_sn").val(cart_sn);
	$("#review_goods_code").val(goods_code);
	
	var param = {};
	param.purchs_sn = purchs_sn;
	param.cart_sn = cart_sn;
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
        	$("#review_cn").val(data.REVIEW_CN);
   		   	if(typeof data.REVIEW_SCORE != "undefined") {
   		   		$(".star_icon i").each(function (index) {
   		   			if(index <= data.REVIEW_SCORE)
   		   				$(this).addClass("on");
   		   		});
   		   	}
        	$.featherlight($('#review_popup'), {});
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});			
}

function saveReview() {
	if($.trim($(".featherlight #review_cn").val()) == "") {
		alert("내용을 입력해주세요.");
		$(".featherlight #review_cn").focus();
		return false;
	}
	if($(".featherlight .star_icon").find(".on").length == 0) {
		alert("점수를 선택해주세요.");
		return false;
	}
	
	var url = "<c:url value='/purchs/savePurchsReview'/>";
	
	var param = {};
	param.purchs_sn = $(".featherlight #review_purchs_sn").val();
	param.cart_sn = $(".featherlight #review_cart_sn").val();
	param.review_cn = $(".featherlight #review_cn").val();
	param.review_score = $(".featherlight .star_icon").find(".on").length;
	param.goods_code = $(".featherlight #review_goods_code").val();
	
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

function cancelPurchs(purchs_sn, cart_sn) {
	if(!confirm("정말 취소하겠습니까?"))
		return false;
	
	var url = "<c:url value='/purchs/cancelPurchs'/>";
	
	var param = {};
	param.purchs_sn = purchs_sn;
	param.cart_sn = cart_sn;
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
			if(data.result == "0") {
	        	alert("취소되었습니다.");
	        	document.location.reload();
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

function timeWithColon(x) {
	if(x.length < 4)
		return x;
	return x.substr(0, 2) + ":" + x.substr(2, 2);
}

function dateWithHyphen(x) {
	if(x.length < 8)
		return x;
	return x.substr(0, 4) + "-" + x.substr(4, 2) + "-" + x.substr(6, 2);
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function getDateToString(d) {
	return String(d.getFullYear()) + lpad(String(d.getMonth() + 1), 2, "0") + lpad(String(d.getDate()), 2, "0");
}

function getToday() {
	var d = new Date();
	return String(d.getFullYear()) + lpad(String(d.getMonth() + 1), 2, "0") + lpad(String(d.getDate()), 2, "0");
}

function lpad(s, padLength, padString){
	 
    while(s.length < padLength)
        s = padString + s;
    return s;
}
</script>
</head>

<body>

<form>
	<input type="hidden" id="hidPage" name="hidPage" value="1">
	<input type="hidden" id="pageSize" name="pageSize" value="5">
	<input type="hidden" id="blockSize" name="blockSize" value="5">	
	<input type="hidden" id="search_start_dt" name="search_start_dt" value="">	
	<input type="hidden" id="search_end_dt" name="search_end_dt" value="">	
</form>

<!-- 본문 -->
<div id="container">
  <div class="inner2">
    <div class="my_box01">
      <div class="info">
        <div class="photo"><img src="/images/com/me_photo.jpg" alt=""/></div>
        <div class="text"><em>${user_nm} 회원님</em><br>
          환영합니다.</div>
      </div>
      <div class="point">
        <div class="t1">포인트 <em><fmt:formatNumber value="${point}" pattern="#,###" /> P</em></div>
        <div class="btn"><a href="javascript:document.location.href='/purchs/Point';">자세히보기</a></div>
      </div>
      <div class="mymenu">
        <ul>
          <li class="on"><a href="javascript:document.location.href='/purchs/OrderList';">
            <div class="img"><img src="/images/sub/my_icon01.png"  alt=""/></div>
            <div class="tx"> 결제목록</div>
            </a> </li>
          <li> <a href="javascript:document.location.href='/purchs/Cancel';">
            <div class="img"><img src="/images/sub/my_icon02.png"  alt=""/></div>
            <div class="tx"> 취소목록</div>
            </a> </li>
          <li> <a href="javascript:document.location.href='/purchs/Wish';">
            <div class="img"><img src="/images/sub/my_icon03.png"  alt=""/></div>
            <div class="tx"> 찜목록</div>
            </a> </li>
          <li> <a href="javascript:document.location.href='/cart/list';">
            <div class="img"><img src="/images/sub/my_icon04.png"  alt=""/></div>
            <div class="tx"> 예약목록(장바구니)</div>
            </a> </li>
        </ul>
      </div>
    </div>
    <div class="order_search">
      <div class="s_box1">
        <div class="inbox">
          <div class="fl_t1">조회기간 선택</div>
          <div class="fl_t2">
            <input class="to-labelauty st_w2 input_w30" type="checkbox" name="chkRange" data-labelauty="오늘" value="0" checked/>
            <input class="to-labelauty st_w2 input_w30" type="checkbox" name="chkRange" data-labelauty="1주일" value="1" />
            <input class="to-labelauty st_w2 fl" type="checkbox" name="chkRange" data-labelauty="15일" value="2"/>
            <input class="to-labelauty st_w2 fl" type="checkbox" name="chkRange" data-labelauty="1개월" value="3"/>
            <input class="to-labelauty st_w2 fl" type="checkbox" name="chkRange" data-labelauty="3개월" value="4"/>
            <input class="to-labelauty st_w2 fl" type="checkbox" name="chkRange" data-labelauty="6개월" value="5"/>
            <input class="to-labelauty st_w2 fl" type="checkbox" name="chkRange" data-labelauty="1년" value="6"/>
          </div>
        </div>
        <div class="inbox2">
          <div class="fl_t1">조회기간 선택</div>
          <div class="fl_t2">
            <div class="day_input">
              <input type="text" class="some_class" value="" id="start_dt"/>
              <i class="material-icons">date_range</i> </div>
            <span>~</span>
            <div class="day_input">
              <input type="text" class="some_class" value="" id="end_dt"/>
              <i class="material-icons">date_range</i></div>
          </div>
        </div>
        <div class="inbox3">
          <div class="fl_t1">통합검색</div>
          <div class="fl_t2">
            <select class="w_30p">
              <option>통합검색</option>
              <option>통합검색</option>
            </select>
            <input type="text"  value="" id="" class="w_60p"/>
          </div>
        </div>
      </div>
      <div class="s_box2">
        <div class="search_btn" id="btnSearch">조회하기</div>
      </div>
    </div>
    <div class="order_list">
      <div class="title">결제목록</div>
      <div class="tb_box">
        <div class="tb_05_box">
          <table id="tblList" width="100%" class="tb_05" >
            <col width="15%" />
            <col width="13%" />
            <col width="" />
            <col width="15%" />
            <col width="10%" />
            <col width="10%" />
            <thead>
              <tr>
                <th>이미지</th>
                <th>결제번호</th>
                <th>구매일</th>
                <th>여행정보</th>
                <th >금액</th>
                <th >결제상태</th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
      </div>
      <!--페이징 -->
      <div class="bbs_bottom"> 
        <div class="paginate">
          <div class="number" id="paging">
          	<a href="#" class="pre_end">← First</a>
          	<a href="#" class="pre">이전</a>
          	<a href="#">11</a>
          	<a href="#" class="on">12</a>
          	<a href="#">13</a>
          	<a href="#">14</a>
          	<a href="#">15</a>
          	<a href="#">16</a>
          	<a href="#">17</a>
          	<a href="#">18</a>
          	<a href="#">19</a>
          	<a href="#">20</a>
          	<a href="#" class="next">다음</a>
          	<a href="#" class="next_end">Last → </a>
          </div>
        </div>
      </div>
      <!--//페이징 --> 
    </div>
  </div>
</div>

<!-- //본문 -->

<!--팝업 : 이용후기 -->
<div class="lightbox" id="review_popup">
	<input type="hidden" id="review_purchs_sn" >
	<input type="hidden" id="review_cart_sn" >
	<input type="hidden" id="review_goods_code" >	
  <div class="popup_com">
    <div class="title">이용후기</div>
    <div class="popup_cont">
      <div class="tb_01_box">
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="">
          <tbody>
            <tr>
              <th >점수</th>
              <td><div id="revice_score" class="star_icon"><i class="material-icons on">star_rate</i> <i class="material-icons on">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i> <i class="material-icons">star_rate</i></div></td>
            </tr>
            <tr>
              <th >내용쓰기</th>
              <td><textarea name="textarea" id="review_cn" class="w_100p input_st"  placeholder="" style="height: 300px"></textarea></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn"><a href="javascript:saveReview();">등록하기</a></div>
    </div>
  </div>
</div>
<!--팝업--> 


</body>


