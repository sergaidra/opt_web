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
        		var tr = $("<tr></tr>");
        		var td1 = $("<td class='left'>" + (data.startIdx + cnt) + "</td>");
        		var td2 = $("<td class='left'>" + data.list[cnt].ACCML_SE_NM + "</td>");
        		var td3 = $("<td class='point_color_b4'>" + data.list[cnt].ACCML_DT + "</td>");
        		var td4 = null;
        		
        		if(data.list[cnt].POINT.substr(0, 1) == "+")
        			td4 = $("<td class='font_color1'>" + data.list[cnt].POINT + "</td>");
        		else
        			td4 = $("<td class='font_color2'>" + data.list[cnt].POINT + "</td>");
        			
        		var td5 = $("<td class='font_color3'>" + "" + "</td>");
        		
        		$(tr).append(td1);
        		$(tr).append(td2);
        		$(tr).append(td3);
        		$(tr).append(td4);
        		$(tr).append(td5);
        		
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
    <div class="order_list">
      <div class="title">포인트 사용 내역</div>
      <div class="tb_box">
        <div class="tb_05_box">
          <table width="100%" class="tb_05" id="tblList">
            <col width="5%" />
            <col width="" />
            <col width="10%" />
            <col width="10%" />
            <col width="10%" />
            <thead>
              <tr>
                <th>번호</th>
                <th>포인트 내용</th>
                <th >사용/적립날짜</th>
                <th >포인트</th>
                <th >총 보유포인트</th>
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
