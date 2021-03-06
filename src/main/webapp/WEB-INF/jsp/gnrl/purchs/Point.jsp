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
	var url = "<c:url value='/purchs/getPointList'/>";
	$("#tblList tbody").empty(); 
	$("#paging").empty(); 
	$("#mpaging").empty(); 	

	var param = {};
	param.hidPage = pageNo;
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
            		var tr = $("<tr></tr>");
            		var td1 = $("<td class='left'>" + (data.startIdx + cnt) + "</td>");
            		var td2 = null;
            		if(data.list[cnt].ACCML_SE == "A")
            			td2 = $("<td class='left'>" + data.list[cnt].ACCML_SE_NM + " (" + data.list[cnt].GOODS_NM + ") </td>");
            		else
            			td2 = $("<td class='left'>" + data.list[cnt].ACCML_SE_NM + "</td>");
            		var td3 = $("<td class='point_color_b4'>" + data.list[cnt].ACCML_DT + "</td>");
            		var td4 = $("<td class='point_color_b4'>" + data.list[cnt].POINT + "</td>");
            		var td5 = $("<td class='point_color_b4'>" + nvl(data.list[cnt].RECENT_USE_DT) + "</td>");
            		var td6 = $("<td class='point_color_b4'>" + nvl(data.list[cnt].USE_POINT) + "</td>");
            		var td7 = $("<td class='point_color_b4'>" + data.list[cnt].REST_POINT + "</td>");
            		
            		$(tr).append(td1);
            		$(tr).append(td2);
            		$(tr).append(td3);
            		$(tr).append(td4);
            		$(tr).append(td5);
            		$(tr).append(td6);
            		$(tr).append(td7);
            		
    	        	$("#tblList tbody").append(tr);        
        		}
        		
        		// 모바일
        		{
            		var tr = $("<tr></tr>");
            		var td1 = $("<td class='left'>" + data.list[cnt].ACCML_SE_NM + " (" + data.list[cnt].GOODS_NM + ")<br>" + data.list[cnt].ACCML_DT + "<br>" + data.list[cnt].POINT + "</td>");
            		var td2 = $("<td class='left'>" + nvl(data.list[cnt].RECENT_USE_DT) + "<br>" + nvl(data.list[cnt].USE_POINT) + "</td>");
            		var td3 = $("<td class='font_color3'>" + data.list[cnt].REST_POINT + "</td>");
            		
            		$(tr).append(td1);
            		$(tr).append(td2);
            		$(tr).append(td3);
        			
    	        	$("#tblmList tbody").append(tr);        	        	
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
</script>

</head>

<body>

<input type="hidden" id="hidPage" name="hidPage" value="1">
<input type="hidden" id="pageSize" name="pageSize" value="10">
<input type="hidden" id="blockSize" name="blockSize" value="5">	

<!-- 본문 -->
<div id="container">
  <div class="inner2">
    <div class="my_box01">
      <div class="info">
        <!-- <div class="photo"><img src="/images/com/me_photo.jpg" alt=""/></div> -->
        <!-- <div class="text pointer" onclick="go_myinfo();"> -->
          <div><em>${user_nm} 회원님</em><br>
          환영합니다.</div>
        <div class="btn"><a href="javascript:document.location.href='/member/info/';">개인정보수정</a></div> 
      </div>
      <div class="point">
        <div class="t1">포인트 <em><fmt:formatNumber value="${point}" pattern="#,###" /> P</em></div>
        <div class="btn"><a href="javascript:document.location.href='/purchs/Point';">자세히보기</a></div>
      </div>
      <div class="mymenu">
        <ul>
          <li style="width:25%;"><a href="javascript:document.location.href='/purchs/OrderList';">
            <div class="img"><img src="/images/sub/my_icon01.png"  alt=""/></div>
            <div class="tx"> 결제목록</div>
            </a> </li>
          <li style="width:25%;"> <a href="javascript:document.location.href='/purchs/Cancel';">
            <div class="img"><img src="/images/sub/my_icon02.png"  alt=""/></div>
            <div class="tx"> 취소목록</div>
            </a> </li>
          <li style="width:25%;"> <a href="javascript:document.location.href='/purchs/Wish';">
            <div class="img"><img src="/images/sub/my_icon03.png"  alt=""/></div>
            <div class="tx"> 찜목록</div>
            </a> </li>
          <li style="width:25%;"> <a href="javascript:document.location.href='/cart/list';">
            <div class="img"><img src="/images/sub/my_icon04.png"  alt=""/></div>
            <div class="tx"> 예약목록<div class="mobile_view"></div>(장바구니)</div>
            </a> </li>
        </ul>
      </div>
    </div>
    <div class="order_list">
      <div class="title">포인트 적립 및 사용 내역</div>
      <div class="tb_box">
        <div class="tb_06_box">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tb_06" id="tblList">
            <col width="5%" />
            <col width="" />
            <col width="15%" />
            <col width="15%" />
            <col width="20%" />
            <thead>
              <tr>
                <th>번호</th>
                <th>포인트 내용</th>
                <th >적립날짜</th>
                <th >포인트</th>
                <th >사용날짜</th>
                <th >사용포인트</th>
                <th >보유포인트</th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
          
		<!--모바일일때 -->
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tb_06_m"  id="tblmList">
            <col width="" />
            <col width="15%" />
            <col width="30%" />
            <thead>
              <tr>               
                <th>포인트 내용 /적립날짜/포인트</th>               
                <th >사용날짜/포인트</th>
                <th >보유포인트</th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
			<!--//모바일일-->
          
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
