<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<style>
#tblList tr {cursor:pointer;}
</style>

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

function viewSecret(bbs_sn) {
	alert("비밀글입니다.")
	return ;
}

function search(pageNo) {
	var url = "<c:url value='/bbs/getBbsList'/>";
	$("#tblList tbody").empty(); 
	$("#paging").empty(); 
	$("#tblmList tbody").empty(); 
	$("#mpaging").empty(); 
	
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
        	var rowCnt = 0;
        	for(var cnt = 0; cnt < data.list.length; cnt++) {
        		{
            		var tr = null;
            		if(data.list[cnt].SECRET_AT == "Y" && data.list[cnt].WRITNG_ID != "${esntl_id}" && !("${author_cl}" == "A" || "${author_cl}" == "M")) {
        				tr = $("<tr onclick='javascript:viewSecret(" + data.list[cnt].BBS_SN + ");'></tr>");
            		} else {
        				tr = $("<tr onclick='javascript:viewBbs(" + data.list[cnt].BBS_SN + ");'></tr>");
            		}
            		var td1 = null;
            		var td2 = null;
            		if(data.list[cnt].LVL == 1) {
                		td1 = $("<td>" + (Number(data.startIdx) + rowCnt) + "</td>");
                		td2 = $("<td class='left'>[" + data.list[cnt].SUBCATEGORYNM + "] " + data.list[cnt].SUBJECT + "</td>");
                		rowCnt++;
            		} else {
            			var space = "";
            			for(var cnt2 = 1; cnt2 < data.list[cnt].LVL; cnt2++)
            				space += "&nbsp;&nbsp;";
                		td1 = $("<td></td>");
                		td2 = $("<td class='left'>" + space + "→ " + data.list[cnt].SUBJECT + "</td>");
            		}
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
        		{
            		var tr = null;
            		if(data.list[cnt].SECRET_AT == "Y" && data.list[cnt].WRITNG_ID != "${esntl_id}" && !("${author_cl}" == "A" || "${author_cl}" == "M")) {
        				tr = $("<tr onclick='javascript:viewSecret(" + data.list[cnt].BBS_SN + ");'></tr>");
            		} else {
        				tr = $("<tr onclick='javascript:viewBbs(" + data.list[cnt].BBS_SN + ");'></tr>");
            		}
            		var td1 = null;
            		if(data.list[cnt].LVL == 1) {
                		td1 = $("<td class='left'>[" + data.list[cnt].SUBCATEGORYNM + "] " + data.list[cnt].SUBJECT + "<br/>" + data.list[cnt].USER_NM + "(" + data.list[cnt].WRITNG_DT + ")</td>");
            		} else {
            			var space = "";
            			for(var cnt2 = 1; cnt2 < data.list[cnt].LVL; cnt2++)
            				space += "&nbsp;&nbsp;";
                		td1 = $("<td class='left'>" + space + "→ " + data.list[cnt].SUBJECT + "<br/>" + data.list[cnt].USER_NM + "(" + data.list[cnt].WRITNG_DT + ")</td>");
            		}
            		
            		$(tr).append(td1);
            		
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
<form id="frmBbs" method="post">
	<input type="hidden" id="category" name="category" value="${category}">
	<input type="hidden" id="bbs_sn" name="bbs_sn" value="">
</form>

<!-- 본문 -->
<section>

<div id="container">
	   <div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div>
  <div class="inner2"><div class="comf">
	   <div class="com_stitle">여행상담&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:14px;">※ 해당 게시판은 비공개로 작성됩니다.</span></div>
        <div class="review_list_box">
          <table width="100%" class="review_list"  id="tblList">
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
                <th>작성자 </th>
                <th class="end">작성일 </th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
			<!--모바일-->
			<table width="100%" class="review_list_m"  id="tblmList">
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

       <div class="right_btn"><a href="/bbs/write" class="button_m1">문의하기</a> </div>
       
      <!--//하단버튼/ 페이징 -->
      
      </div></div>
	   <div class="sp_50"></div>
</div>


</section>
<!-- //본문 -->

</body>
