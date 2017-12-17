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
	var url = "<c:url value='/purchs/getWishList'/>";
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
        		var tr = $("<tr></tr>");
        		//var td1 = $("<td class='left'><div class='cart_img' style=\"background: url(<c:url value='/file/getImage/'/>?file_code=" + data.list[cnt].FILE_CODE + "); background-size: cover; \"></div></td>");
        		var td1 = $("<td class='left'><div class='order_list_img'><img src='<c:url value='/file/getImage/'/>?file_code=" + data.list[cnt].FILE_CODE + "' width='150' alt='''/></div></td>");
				var td2 = $("<td  class='left'>" + data.list[cnt].GOODS_NM + "</td>");
				var td3 = $("<td  class='left'>" + nvl(data.list[cnt].GOODS_INTRCN_SIMPL) + "</td>");
				var td4 = $("<td >" + data.list[cnt].REVIEW_SCORE + "</td>");
				var td5 = $("<td ><a href=\"javascript:delWish('" + data.list[cnt].GOODS_CODE + "')\" class='sbtn_01'>삭제하기</a></td>");				

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

function delWish(goods_code) {
	var lst = [];
	lst.push(goods_code);
	
	var url = "<c:url value='/purchs/deleteWish'/>";
	var param = {};
	param.goods_code = lst;
	console.log(param);
	
	if(!confirm("찜 목록에서 삭제하겠습니까?"))
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
				alert("삭제하였습니다.");
				search(1);
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
<input type="hidden" id="hidPage" name="hidPage" value="1">
<input type="hidden" id="pageSize" name="pageSize" value="5">
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
          <li class="on"> <a href="javascript:document.location.href='/purchs/Wish';">
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
    <div class="order_list">
      <div class="title">찜목록(위시리스트) <div class="stex"> 가로 터치 슬라이딩 해주세요 ← →</div></div>
      <div class="tb_box">
        <div class="tb_05_box">
          <table width="100%" class="tb_05" id="tblList">
            <col width="15%" />
            <col width="" />
            <col width="13%" />
            <col width="15%" />
            <thead>
              <tr>
		          <th>&nbsp;</th>
		          <th>상품명</th>
		          <th >설명</th>
		          <th >평점</th>
		          <th ></th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
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
