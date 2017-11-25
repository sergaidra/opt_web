<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<script type="text/javascript">

$(function(){
	search(1);
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
        		var td6 = $("<td >취소</td>");

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
        	var startPageNo = Math.floor((pageNo - 1) / blockSize + 1);
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
          <li><a href="javascript:document.location.href='/purchs/OrderList';">
            <div class="img"><img src="/images/sub/my_icon01.png"  alt=""/></div>
            <div class="tx"> 결제목록</div>
            </a> </li>
          <li class="on"> <a href="javascript:document.location.href='/purchs/Cancel';">
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
    <div class="order_list">
      <div class="title">취소목록</div>
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
          </div>
        </div>
      </div>
      <!--//페이징 --> 
    </div>
  </div>
</div>

<!-- //본문 -->


</body>


