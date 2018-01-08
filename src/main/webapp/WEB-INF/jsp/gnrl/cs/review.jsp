<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<script type="text/javascript" src="/js/acco.js"></script>

<script type="text/javascript">

$(function(){	
	search(1);
});

function search(pageNo) {
	var url = "<c:url value='/cs/getReviewList'/>";
	$("#tblList tbody").empty(); 
	$("#tblmList tbody").empty(); 
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
            		var td1 = $("<td>" + (data.startIdx + cnt) + "</td>");
            		var td2 = $("<td ><span class=\"proimg\"><img src=\"<c:url value='/file/getImageThumb/'/>?file_code=" + data.list[cnt].FILE_CODE + "\"  alt=\"\"/></span></td>");
            		var td3 = null;
            		if(data.list[cnt].ISNEW == "Y")
            			td3 = $("<td class=\"left\">" + data.list[cnt].GOODS_NM + "<img src=\"/images/com/icon_new.gif\" width=\"19\" height=\"9\" /> </td>");
            		else
            			td3 = $("<td class=\"left\">" + data.list[cnt].GOODS_NM + "</td>");
            			
            		var td4 = $("<td ></td>");
            		var td5 = $("<td >" + data.list[cnt].USER_NM + "</td>");
            		var td6 = $("<td  class=\"end\" >" + data.list[cnt].WRITNG_DT + "</td>");
            		
            		for(var cnt2 = 1; cnt2 <= 5; cnt2++) {
            			if(cnt2 <= Number(data.list[cnt].REVIEW_SCORE)) {
            				$(td4).append("<i class=\"material-icons color_on\">&#xE885;</i>");
            			} else {
            				$(td4).append("<i class=\"material-icons color_off\">&#xE885;</i>");
            			}
            		}
            		 
            		var tr2 = $("<tr></tr>");
            		var td2_1 = $("<td colspan=\"6\" class=\"left\"><div class=\"review\"><div class=\"text\">" + replaceBrSpace(data.list[cnt].REVIEW_CN) + "</div></div></td>");
              		if("${author_cl}" == "A") {
              			$(td2_1).find(".text").after("<div class=\"btn\"><a href=\"javascript:deleteReview(" + data.list[cnt].PURCHS_SN + ", " + data.list[cnt].CART_SN + ", " + data.list[cnt].GOODS_CODE + ");\" class=\"button_st1 fl mr_m1\">삭제</a></div>");              			
              		}

            		if(data.list[cnt].WRITNG_ID == "${esntl_id}") {
            			//$(td2_1).find(".text").after("<div class=\"btn\"><a href=\"javascript:viewReview(" + data.list[cnt].PURCHS_SN + ", " + data.list[cnt].CART_SN + ", " + data.list[cnt].GOODS_CODE + ");\" class=\"button_st1 fl mr_m1\">수정</a></div>");
            		}            		
            		
            		$(tr).append(td1);
            		$(tr).append(td2);
            		$(tr).append(td3);
            		$(tr).append(td4);
            		$(tr).append(td5);
            		$(tr).append(td6);

            		$(tr2).append(td2_1);

    	        	$("#tblList tbody").append(tr);        
    	        	$("#tblList tbody").append(tr2);        
        		}
        		
        		// 모바일
        		{
            		var tr = $("<tr></tr>");
            		var td1 = $("<td ><div class=\"proimg\"><img src=\"<c:url value='/file/getImageThumb/'/>?file_code=" + data.list[cnt].FILE_CODE + "\"  alt=\"\"/></div><br/>" + data.list[cnt].GOODS_NM + "<br/>" + data.list[cnt].WRITNG_DT + " [" + data.list[cnt].USER_NM + "]<br/><div class=\"star_icon2\"></div></td>");

            		for(var cnt2 = 1; cnt2 <= 5; cnt2++) {
            			if(cnt2 <= Number(data.list[cnt].REVIEW_SCORE)) {
            				$(td1).find(".star_icon2").append("<i class=\"material-icons color_on\">&#xE885;</i>");
            			} else {
            				$(td1).find(".star_icon2").append("<i class=\"material-icons color_off\">&#xE885;</i>");
            			}
            		}
            		
            		var tr2 = $("<tr></tr>"); 
            		var td2_1 = $("<td colspan=\"2\" class=\"left\"><div class=\"review\"><div class=\"text\">" + replaceBrSpace(data.list[cnt].REVIEW_CN) + "</div></div></td>");
        			
              		if("${author_cl}" == "A") {
              			$(td2_1).find(".text").after("<div class=\"btn\"><a href=\"javascript:deleteReview(" + data.list[cnt].PURCHS_SN + ", " + data.list[cnt].CART_SN + ", " + data.list[cnt].GOODS_CODE + ");\" class=\"button_st1 fl mr_m1\">삭제</a></div>");              			
              		}
            		if(data.list[cnt].WRITNG_ID == "${esntl_id}") {
            			//$(td2_1).find(".text").after("<div class=\"btn\"><a href=\"javascript:viewReview(" + data.list[cnt].PURCHS_SN + ", " + data.list[cnt].CART_SN + ", " + data.list[cnt].GOODS_CODE + ");\" class=\"button_st1 fl mr_m1\">수정</a></div>");
            		}            		

            		$(tr).append(td1);
            		$(tr2).append(td2_1);
        			
    	        	$("#tblmList tbody").append(tr);        	        	
    	        	$("#tblmList tbody").append(tr2);        	        	
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

function viewReview(purchs_sn, cart_sn, goods_code) {
	$.featherlight('/cs/popupReview?purchs_sn=' + purchs_sn + '&cart_sn=' + cart_sn + '&goods_code=' + goods_code + '&callback=saveComplete&mode=R', {});
}

function saveComplete() {
	search($("#hidPage").val());
}

function replaceBrSpace(str) {
	if(str == null)
		return "";
	return str.replace(/\n/g, "<br />").replace(/  /g, "&nbsp;");
}

function deleteReview(purchs_sn, cart_sn) {
	if(!confirm("여행후기를 삭제하겠습니까?"))
		return;
	
	var url = "<c:url value='/cs/deletePurchsReview'/>";
	
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
				alert("삭제되었습니다.");
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

</script>
	
</head>

<body>
<!-- 본문 -->
<section>
<input type="hidden" id="hidPage" name="hidPage" value="1">
<input type="hidden" id="pageSize" name="pageSize" value="5">
<input type="hidden" id="blockSize" name="blockSize" value="5">	

<div id="container">
	   <div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div>
  <div class="inner2"><div class="comf">
	   <!-- <div class="com_stitle">여행후기</div> -->
		             <!--FAQ검색-->  <div class="bbs_search">
			    <div class="search_text">
			      <div class="tx1 fw_500">여행후기</div>
				  <div class="tx2">다른 여행자의 여행 후기를 보며 추억을 공유합니다.</div>
			    </div>
		<!-- <div class="search_in">
      
          <div class="search_input w_80p"><input type="text" class="w_100p" id="reviewkeyword" name="reviewkeyword">
	      <div class="btn" id="btnSearch"><i class="material-icons">&#xE8B6;</i></div>
	    </div>

        </div> -->
		 
      </div> <!--//FAQ검색--> 	
         
        <div class="review_list_box">
          <table width="100%" class="review_list" id="tblList">
            <col width="8%" />
            <col width="8%" />
            <col width="" />
             <col width="15%" />
            <col width="8%" />
            <col width="12%" />
            <thead>
                      <tr>
                <th>no.</th>
                <th>이미지</th>
                <th>여행상품명 </th>
                <th >점수</th>
                <th >작성자</th>
                <th class="end">작성일</th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
			<!--모바일-->
			<table width="100%" class="review_list_m"  id="tblmList">
            <col width="8%" />
            <col width="" />
    
            <tbody>
            </tbody>
          </table>
<!--//모바일-->
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
      </div></div>
	   <div class="sp_50"></div>
</div>

</section>
<!-- //본문 -->

</body>
