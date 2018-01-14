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
		
	$('.some_class').val(getToday());
	
	$("#btnSearch").trigger("click");
});

function search(pageNo) {
	var url = "<c:url value='/purchs/getPurchsList'/>";
	$("#tblList tbody").empty(); 
	$("#tblmList tbody").empty(); 
	$("#paging").empty(); 
	$("#mpaging").empty(); 	

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
        		// PC
        		{
        			for(var cnt2 = 0; cnt2 < data.list[cnt].cartlist.length; cnt2++) {
                		var tr = $("<tr></tr>");
                		var td1 = $("<td rowspan=" + (data.list[cnt].cartlist.length + 1) + ">" + data.list[cnt].PURCHS_SN + "<br><br><a href='javascript:orderDetail(" + data.list[cnt].PURCHS_SN + ");'>[상세보기]</a><br><a href='javascript:orderInfo(" + data.list[cnt].PURCHS_SN + ");'>[일정보기]</a></td>");
                		var td2 = $("<td class='left'><div class='order_list_img'><img src='<c:url value='/file/getImage/'/>?file_code=" + data.list[cnt].cartlist[cnt2].FILE_CODE + "' width='150' alt='''/></div></td>");
                		var td3 = $("<td class='left'></td>");
                		var td4 = $("<td rowspan=" + data.list[cnt].cartlist.length + ">" + dateWithHyphen(data.list[cnt].PURCHS_DE) + "</td>");
                		var td5 = $("<td class='right r_line'><span class='point_color_b4'>" + numberWithCommas(data.list[cnt].cartlist[cnt2].PURCHS_AMOUNT) + "원</span></td>");
                		var td6 = null;                		
                		
                		if(data.list[cnt].cartlist[cnt2].CL_SE == 'S' || data.list[cnt].cartlist[cnt2].CL_SE == 'T') {
                    		$(td3).append("<div class='tx1'>[" + dateWithHyphen(data.list[cnt].cartlist[cnt2].CHKIN_DE) + " ~ " + dateWithHyphen(data.list[cnt].cartlist[cnt2].CHCKT_DE) + "]</div>");
                		} else {
                    		$(td3).append("<div class='tx1'>[" + dateWithHyphen(data.list[cnt].cartlist[cnt2].TOUR_DE) + " " + timeWithColon(data.list[cnt].cartlist[cnt2].BEGIN_TIME) + " ~ " + timeWithColon(data.list[cnt].cartlist[cnt2].END_TIME) + "]</div>");
                		}
                		$(td3).append("<div class='tx2'>" + data.list[cnt].cartlist[cnt2].GOODS_NM + "</div>");
                		var td3sub = $("<div class='tx3'></div>");
                		for(var cnt3 = 0; cnt3 < data.list[cnt].cartlist[cnt2].OPTIONS.length; cnt3++) {
                    		if(data.list[cnt].cartlist[cnt2].CL_SE == 'S') {
                    			$(td3sub).append(data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].SETUP_NM + " " + data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].NMPR_CND + " " + data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].NMPR_CO + data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].UNIT_NM);
                    		} else {
                    			$(td3sub).append(data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].NMPR_CND + " " + data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].NMPR_CO + data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].UNIT_NM);
                    		}
								
                    		if(cnt2 + 1 != data.list[cnt].cartlist[cnt2].OPTIONS.length)
                    			$(td3sub).append("<br/>");
                		}
                		$(td3).append(td3sub);
                		
                		var today = getToday(); 
                		
                		if(data.list[cnt].cartlist[cnt2].ENDDT <= today && today <= data.list[cnt].cartlist[cnt2].REVIEWDT) {
                			if(data.list[cnt].cartlist[cnt2].EXISTREVIEW == "Y")
                				td6 = $("<td ><a href='javascript:openWriteReview(\"" + data.list[cnt].PURCHS_SN + "\", \"" + data.list[cnt].cartlist[cnt2].CART_SN + "\", \"" + data.list[cnt].cartlist[cnt2].GOODS_CODE + "\", \"W\", \"Y\");' class='sbtn_01' style='background-color:#ff6600; border:none;'>후기수정</a></td>");
                			else
                				td6 = $("<td ><a href='javascript:openWriteReview(\"" + data.list[cnt].PURCHS_SN + "\", \"" + data.list[cnt].cartlist[cnt2].CART_SN + "\", \"" + data.list[cnt].cartlist[cnt2].GOODS_CODE + "\", \"W\", \"Y\");' class='sbtn_01' style='background-color:#ff6600; border:none;' >후기쓰기</a></td>");
                		} else {
                			if(data.list[cnt].cartlist[cnt2].EXISTREVIEW == "Y")
                				td6 = $("<td ><a href='javascript:openWriteReview(\"" + data.list[cnt].PURCHS_SN + "\", \"" + data.list[cnt].cartlist[cnt2].CART_SN + "\", \"" + data.list[cnt].cartlist[cnt2].GOODS_CODE + "\", \"R\", \"Y\");' class='sbtn_01' style='background-color:#ff6600; border:none;'>후기보기</a></td>");
                			else                 			
                				td6 = $("<td ><a href='javascript:openWriteReview(\"" + data.list[cnt].PURCHS_SN + "\", \"" + data.list[cnt].cartlist[cnt2].CART_SN + "\", \"" + data.list[cnt].cartlist[cnt2].GOODS_CODE + "\", \"R\", \"N\");' class='sbtn_01' style='cursor:not-allowed;' >후기</a></td>");
                		}
                		
                		if(cnt2 == 0) {
							$(tr).append(td1);
                		}
                		$(tr).append(td2);
                		$(tr).append(td3);
                		if(cnt2 == 0) {
	                		$(tr).append(td4);
                		}
                		$(tr).append(td5);
                		$(tr).append(td6);                		
                		
        	        	$("#tblList tbody").append(tr);        
        			}
        			
            		var tr2 = "<tr><td colspan=\"5\" class=\"totalbg\" >합계 : " + numberWithCommas(data.list[cnt].TOT_SETLE_AMOUNT) + "원</td></tr>";
    	        	$("#tblList tbody").append(tr2);        
        		}
        		// 모바일
        		{
        			for(var cnt2 = 0; cnt2 < data.list[cnt].cartlist.length; cnt2++) {
            			var tx1 = "";
                		if(data.list[cnt].cartlist[cnt2].CL_SE == 'S' || data.list[cnt].cartlist[cnt2].CL_SE == 'T') {
                    		tx1 = dateWithHyphen(data.list[cnt].cartlist[cnt2].CHKIN_DE) + " ~ " + dateWithHyphen(data.list[cnt].cartlist[cnt2].CHCKT_DE);
                		} else {
                			tx1 = dateWithHyphen(data.list[cnt].cartlist[cnt2].TOUR_DE) + " " + timeWithColon(data.list[cnt].cartlist[cnt2].BEGIN_TIME) + " ~ " + timeWithColon(data.list[cnt].cartlist[cnt2].END_TIME);
                		}
                		var tx3 = "";
                		for(var cnt3 = 0; cnt3 < data.list[cnt].cartlist[cnt2].OPTIONS.length; cnt3++) {
                    		if(data.list[cnt].cartlist[cnt2].CL_SE == 'S') {
                    			tx3 += data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].SETUP_NM + " " + data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].NMPR_CND + " " + data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].NMPR_CO + data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].UNIT_NM;
                    		} else {
                    			tx3 += data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].NMPR_CND + " " + data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].NMPR_CO + data.list[cnt].cartlist[cnt2].OPTIONS[cnt3].UNIT_NM;
                    		}    
                    			
                    		if(cnt2 + 1 != data.list[cnt].cartlist[cnt2].OPTIONS.length)
                    			tx3 += "<br/>";
                		}

                		var tr = $("<tr></tr>");
                		var td1 = $("<td class='left'><div class='order_list_img'><img src='<c:url value='/file/getImage/'/>?file_code=" + data.list[cnt].cartlist[cnt2].FILE_CODE + "' width='100%' alt=\"\"/></div></td>");
                		var td2 = $("<td class='left'><div class='tx0'>" + data.list[cnt].PURCHS_SN + "</div><div class='tx1'>[" + tx1 + "]</div><div class='tx2'>" + data.list[cnt].cartlist[cnt2].GOODS_NM + "</div><div class='tx3'>" + tx3 + "</div></td>");

                		$(tr).append(td1);
                		$(tr).append(td2);

        	        	$("#tblmList tbody").append(tr);        
        			}
        			
            		if(getToday() < data.list[cnt].cartlist[0].BEGINDT) {
            			$("#tblmList tbody").append("<tr><td colspan='2' class='totalbg'><div class='total'> <a href='javascript:orderDetail(" + data.list[cnt].PURCHS_SN + ");' class=\"sbtn_01\">상세보기</a><a href='javascript:orderInfo(" + data.list[cnt].PURCHS_SN + ");' class=\"sbtn_01\">일정보기</a> <a href=\"#\" class=\"sbtn_01\" data-featherlight=\"#secession\">취소하기</a></div>합계 : " + numberWithCommas(data.list[cnt].TOT_SETLE_AMOUNT) + "원</td></tr>");
            		} else {
            			$("#tblmList tbody").append("<tr><td colspan='2' class='totalbg'><div class='total'> <a href='javascript:orderDetail(" + data.list[cnt].PURCHS_SN + ");' class=\"sbtn_01\">상세보기</a><a href='javascript:orderInfo(" + data.list[cnt].PURCHS_SN + ");' class=\"sbtn_01\">일정보기</a> </div>합계 : " + numberWithCommas(data.list[cnt].TOT_SETLE_AMOUNT) + "원</td></tr>");
            		}
        			
        		}
        	}
        	
        	// 페이징 처리
        	var totalCount = Number(data.totalCount);
        	var pageNo = Number($("#hidPage").val());
        	var blockSize = Number($("#blockSize").val());
        	var pageSize = Number($("#pageSize").val());
        	
        	// 첫 페이지 검색
        	var startPageNo = Math.floor((pageNo - 1) / blockSize + 1);
        	var totalPageCnt = Math.ceil(totalCount / pageSize);
        	
        	if(startPageNo > 1) {
        		$("#paging").append("<a href='javascript:search(1);' class='pre_end'>← First</a>");
        		$("#paging").append("<a href='javascript:search(" + (startPageNo - 1) + ");' class='pre'>이전</a>");
        		$("#mpaging").append("<a href='javascript:search(1);' class='pre_end'>← </a>");
        	}

        	for(var cnt = 0; cnt < blockSize; cnt++) {
        		var page = startPageNo + cnt;
        		if(page > totalPageCnt)
        			break;
        		if(page == pageNo) {
        			$("#paging").append("<a href='javascript:search(" + page + ");' class='on'>" + page + "</a>");
        			$("#mpaging").append("<a href='javascript:search(" + page + ");' class='on'>" + page + "</a>");        			
        		} else {
        			$("#paging").append("<a href='javascript:search(" + page + ");'>" + page + "</a>");
        			$("#mpaging").append("<a href='javascript:search(" + page + ");'>" + page + "</a>");        			
        		}
        	}
        	
        	if(startPageNo + blockSize <= totalPageCnt) {
        		$("#paging").append("<a href='javascript:search(" + (startPageNo + blockSize) + ");' class='next'>다음</a>");
        		$("#paging").append("<a href='javascript:search(" + totalPageCnt + ");' class='next_end'>Last → </a>");
        		$("#mpaging").append("<a href='javascript:search(" + totalPageCnt + ");' class='next_end'>→ </a>");
        	}
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});			

}

function openWriteReview(purchs_sn, cart_sn, goods_code, mode, isCan) {
	if(isCan == "Y")
		$.featherlight('/cs/popupReview?purchs_sn=' + purchs_sn + '&cart_sn=' + cart_sn + '&goods_code=' + goods_code + '&mode=' + mode + '', {});
	else
		alert("후기 작성 시기가 아닙니다.");
}

function orderInfo(purchs_sn) {
	window.open("<c:url value='/purchs/OrderInfo'/>?purchs_sn=" + purchs_sn);
}

function orderDetail(purchs_sn) {
	document.location.href="<c:url value='/purchs/OrderDetail'/>?purchs_sn=" + purchs_sn;
}

function timeWithColon(x) {
	if(x == null)
		return "";
	if(x.length < 4)
		return x;
	return x.substr(0, 2) + ":" + x.substr(2, 2);
}

function dateWithHyphen(x) {
	if(x == null)
		return "";
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
        <div class="photo"><!-- <img src="/images/com/me_photo.jpg" alt=""/> --></div>
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
            <div class="tx"> 예약목록<div class="mobile_view"></div>(장바구니)</div>
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
        <!-- <div class="inbox3">
          <div class="fl_t1">통합검색</div>
          <div class="fl_t2">
            <select class="w_30p">
              <option>통합검색</option>
              <option>통합검색</option>
            </select>
            <input type="text"  value="" id="" class="w_60p"/>
          </div>
        </div> -->
      </div>
      <div class="s_box2">
        <div class="search_btn pointer" id="btnSearch">조회하기</div>
      </div>
    </div>
    <div class="order_list">
      <div class="title">결제목록</div>
      <div class="tb_box">
        <div class="tb_05_box">
          <table id="tblList" width="100%" class="tb_07 pc_view" >
            <col width="13%" />
            <col width="15%" />
            <col width="" />
            <col width="15%" />
            <col width="10%" />
            <col width="10%" />
            <col width="10%" />
            <thead>
              <tr>
                <th>결제번호</th>
                <th>이미지</th>
                <th>여행정보</th>
                <th>구매일</th>
                <th>금액</th>
                <th>후기</th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
			<!--  모바일--->
			<table id="tblmList" width="100%" border="0" cellpadding="0" cellspacing="0" class="tb_07 mobile_view mb_20" >
            <col width="10%" />
            <col width="" />
        
            <tbody>
            </tbody>
            </table>
			<!-- 모바일 -->           
          
        </div>
      </div>
      <!--페이징 -->
      <div class="bbs_bottom"> 
        <div class="paginate pc_view">
          <div class="number" id="paging">
          </div>
        </div>
        <div class="paginate mobile_view">
          <div class="number" id="mpaging">
          </div>
        </div>
      </div>
      <!--//페이징 --> 
    </div>
  </div>
</div>

<!-- //본문 -->




</body>


