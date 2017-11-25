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
        		var td1 = $("<td class='left'><div class='cart_img' style=\"background: url(<c:url value='/file/getImage/'/>?file_code=" + data.list[cnt].FILE_CODE + "); background-size: cover; \"></div></td>");
				var td2 = $("<td  class='t_left'></td>");
				var td3 = $("<td><div class='cart_price2'>" + numberWithCommas(data.list[cnt].ORIGIN_AMOUNT) + "원</div></td>");
				var td4 = $("<td>" + numberWithCommas(data.list[cnt].ORIGIN_AMOUNT - data.list[cnt].PURCHS_AMOUNT) + "원</td>");
				var td5 = $("<td ><div class='cart_price3'>" + numberWithCommas(data.list[cnt].PURCHS_AMOUNT) + "원</div></td>");
				var td6 = $("<td ><a href=\"javascript:toCart('" + data.list[cnt].CART_SN + "')\" class='sbtn_01'>장바구니담기</a><br>" +
                        "<a href=\"javascript:delCart('" + data.list[cnt].CART_SN + "')\" class='sbtn_02'>삭제하기</a></td>");				

				var td2_sub = $("<div class='cart_pro_text'></div>");
				var html = "<div class='text1'>" + data.list[cnt].GOODS_NM + "<br />";
				
				if(data.list[cnt].CL_SE == 'S') {
					html += dateWithHyphen(data.list[cnt].CHKIN_DE) + " ~ " + dateWithHyphen(data.list[cnt].CHCKT_DE) + "<br>";
				} else {
					html += dateWithHyphen(data.list[cnt].TOUR_DE) + " " + timeWithColon(data.list[cnt].BEGIN_TIME) + " ~ " + timeWithColon(data.list[cnt].END_TIME) + "<br>";
				}
				
				html += "</div>";

				var html2 = "";
				if(data.list[cnt].CL_SE == 'S') {
					for(var cnt2 = 0; cnt2 < data.list[cnt].OPTIONS.length; cnt2++) {
						html2 += "<div class='text1'>" + data.list[cnt].OPTIONS[cnt2].SETUP_NM + " " + data.list[cnt].OPTIONS[cnt2].NMPR_CND + " </div>";
					}
				} else {
					for(var cnt2 = 0; cnt2 < data.list[cnt].OPTIONS.length; cnt2++) {
						html2 += "<div class='text1'>" + data.list[cnt].OPTIONS[cnt2].NMPR_CND + " " + data.list[cnt].OPTIONS[cnt2].NMPR_CO + "명 </div>";
					}
				}
				
				$(td2_sub).append($(html + html2));
				$(td2).append(td2_sub);

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

function toCart(cart_sn) {
	var lst = [];
	lst.push(cart_sn);
	
	var url = "<c:url value='/cart/changeCartMode'/>";
	var param = {};
	param.cart_sn = lst;
	param.cart_mode = "C"
	console.log(param);
	
	if(!confirm("해당 상품을 장바구니에 담겠습니까?"))
		return false;
		
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("장바구니에 담았습니다.");
				search(1);
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

function delCart(cart_sn) {
	var url = "<c:url value='/cart/delAction'/>";
	var lst = [];
	lst.push(cart_sn);
	var param = {};
	param.cart_sn = lst;
	console.log(param);
	
	if(!confirm("정말 삭제하겠습니까?"))
		return false;
		
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("삭제되었습니다.");
				search(1);
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
            <div class="tx"> 예약목록(장바구니)</div>
            </a> </li>
        </ul>
      </div>
    </div>
    <div class="order_list">
      <div class="title">찜목록(위시리스트)</div>
      <div class="tb_box">
        <div class="tb_05_box">
          <table width="100%" class="tb_05" id="tblList">
            <col width="15%" />
            <col width="" />
            <col width="13%" />
            <col width="15%" />
            <col width="10%" />
            <col width="10%" />
            <thead>
              <tr>
		          <th>&nbsp;</th>
		          <th>상품정보</th>
		          <th >판매가격</th>
		          <th >할인</th>
		          <th >구매예정가</th>
		          <th ></th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td class="left"><img src="../../../images/sub/ex1.jpg" width="150" alt=""/></td>
                <td class="left"><span class="tx2">여행명이 나오는 곳입니다.</span>
                <td >2017.11.15 ~ 2017.11.20</td>
                <td >성인2명</td>
                <td class="right"><span class="point_color_b4">1,001,000원</span></td>
                <td ><a href="#" class="sbtn_01">장바구니담기</a><br>
<a href="#" class="sbtn_02">삭제하기</a></td>
              </tr>
              <tr>
                <td class="left"><img src="../../../images/sub/ex1.jpg" width="150" alt=""/></td>
                <td class="left"><span class="tx2">여행명이 나오는 곳입니다.</span>                
                <td >2017.11.15 ~ 2017.11.20</td>
                <td >성인2명, 아동2인</td>
                <td class="right"><span class="point_color_b4">1,001,000원</span></td>
                <td ><a href="#" class="sbtn_01">장바구니담기</a><br>
                  <a href="#" class="sbtn_02">삭제하기</a></td>
              </tr>
              <tr>
                <td class="left"><img src="../../../images/sub/ex1.jpg" width="150" alt=""/></td>
                <td class="left"><span class="tx2">여행명이 나오는 곳입니다.</span>                
                <td >2017.11.15 ~ 2017.11.20</td>
                <td >성인2명, 아동2인</td>
                <td class="right"><span class="point_color_b4">1,001,000원</span></td>
                <td ><a href="#" class="sbtn_01">장바구니담기</a><br>
                  <a href="#" class="sbtn_02">삭제하기</a></td>
              </tr>
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
