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

function viewBbs(bbs_sn) {
	var frm = $("#frmBbs");
	$("#bbs_sn").val(bbs_sn);
	$(frm).attr("action", "/bbs/view");
	$(frm).submit();
}

function search(pageNo) {
	var url = "<c:url value='/bbs/getBbsList'/>";
	$("#tblList tbody").empty(); 
	$("#paging").empty(); 
	
	var param = {};
	param.hidPage = pageNo;
	param.category = $("#category").val();
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
				var tr = $("<tr onclick='javascript:viewBbs(" + data.list[cnt].BBS_SN + ");'></tr>");
        		var td1 = $("<td>" + (Number(data.startIdx) + cnt) + "</td>");
        		var td2 = $("<td class='left'>" + data.list[cnt].SUBJECT + "</td>");
        		var td3 = $("<td>" + data.list[cnt].VIEWCNT + "</td>");
        		var td4 = $("<td>" + data.list[cnt].USER_NM + "</td>");        		
        		var td5 = $("<td>" + data.list[cnt].WRITNG_DT + "</td>");
        		
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
<form id="frmBbs" method="post">
	<input type="hidden" id="category" name="category" value="${category}">
	<input type="hidden" id="bbs_sn" name="bbs_sn" value="">
</form>

<!-- 본문 -->
<section>
     
      <div id="container"> 
		  <div class="sp_50"></div>
    <div class="inner2"><div class="comf">
		             <!--FAQ검색-->  <div class="faq_search">
			    <div class="search_text">
			      <div class="tx1 fw_500">여행예약</div>
				  <div class="tx2">무엇을 도와드릴까요? <br>
고객님의 궁금함을 빠르게 해결해 드리겠습니다. </div>
			    </div>
<div class="search_in">
		 <div class="search_select  w_50p"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
              <select class="w_100p">
                      <option value="subject">글제목</option>
              </select>
                     
            <!--//기본 셀렉트 박스 --></div>
      
          <div class="search_input w_50p"><input type="text">
	      <div class="btn"><i class="material-icons">&#xE8B6;</i></div>
	    </div>

                </div>
		 
      </div> <!--//FAQ검색--> 

        <div class="bba_list_box">
          <table width="100%" cellpadding="0" cellspacing="0" class="bba_list" id="tblList">
            <col width="8%" />
            <col width="" />
            <col width="5%" />
            <col width="15%" />
            <col width="15%" />
            <thead>
              <tr>
                <th>no.</th>
                <th>글제목 </th>
                <th >조회수 </th>
                <th class="end">작성자 </th>
                <th class="end">작성일 </th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
         <!--하단버튼/ 페이징 -->
      <div class="bbs_bottom">
       <!-- 페이징 -->
    <div class="paginate">
      <div class="number" id="paging">
      
		</div>
    </div>
    <!-- /페이징 --> 

       <div class="right_btn"><a href="/bbs/write" class="button_m1">예약하기</a> </div>
       
      </div>
      <!--//하단버튼/ 페이징 -->
      </div></div> 
		  <div class="sp_50"></div>
  </div>
</section>
<!-- //본문 -->

</body>
