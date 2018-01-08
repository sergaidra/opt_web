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
	$("#noticekeyword").keydown(function (key) {		 
        if(key.keyCode == 13){
        	$("#btnSearch").trigger("click");
        } 
    });
	$("#btnSearch").click(function () {
		search(1);
	});

	search(1);
});

function viewBbs(bbs_sn) {
	var frm = $("#frmBbs");
	$("#bbs_sn").val(bbs_sn);
	$(frm).attr("action", "/cs/viewNotice");
	$(frm).submit();
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
	param.keyword = $("#noticekeyword").val();
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
            		var tr = $("<tr onclick='javascript:viewBbs(" + data.list[cnt].BBS_SN + ");'></tr>");
            		var td1 = $("<td>" + (Number(data.startIdx) + cnt) + "</td>");
            		var td2 = $("<td class=\"left\">" + data.list[cnt].SUBJECT + "<img src=\"/images/com/icon_new.gif\" width=\"19\" height=\"9\" /></td>")
            		var td3 = $("<td>" + data.list[cnt].VIEWCNT + "</td>");
            		var td4 = $("<td>" + data.list[cnt].WRITNG_DT + "</td>");
            		
            		$(tr).append(td1);
            		$(tr).append(td2);
            		$(tr).append(td3);
            		$(tr).append(td4);
            		
    	        	$("#tblList tbody").append(tr);
        		}
        		{
            		var tr = $("<tr onclick='javascript:viewBbs(" + data.list[cnt].BBS_SN + ");'></tr>");;
            		var td1 = $("<td class=\"left\"><em>no." + (Number(data.startIdx) + cnt) + " [" + data.list[cnt].WRITNG_DT + "]</em><br>"
            			    + data.list[cnt].SUBJECT + "<img src=\"/images/com/icon_new.gif\" width=\"19\" height=\"9\" /></td>");
            		
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
		             <!--FAQ검색-->  <div class="bbs_search">
			    <div class="search_text">
			      <div class="tx1 fw_500">공지사항</div>
				  <div class="tx2">원패스투어의 새로운 소식을 전합니다. </div>
			    </div>
		<div class="search_in">
      
          <div class="search_input w_80p"><input type="text" class="w_100p" id="noticekeyword" name="noticekeyword">
	      <div class="btn" id="btnSearch"><i class="material-icons">&#xE8B6;</i></div>
	    </div>

        </div>
		 
      </div> <!--//FAQ검색--> 

        <div class="bba_list_box">
          <table width="100%" cellpadding="0" cellspacing="0" class="bba_list" id="tblList">
            <col width="8%" />
            <col width="" />
            <col width="5%" />
            <col width="15%" />
            <thead>
              <tr>
                <th>no.</th>
                <th>글제목 </th>
                <th >조회수 </th>
                <th class="end">작성일 </th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
			<!--모바일-->
			<table width="100%" cellpadding="0" cellspacing="0" class="bba_list_m" id="tblmList">
            <col width="" />
            <tbody>             
            </tbody>
          </table>
			<!--//모바일 -->
			
        </div>
         <!--하단버튼/ 페이징 -->
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

   	<c:if test="${author_cl == 'A'}">
       <div class="right_btn"><a href="/cs/writeNotice" class="button_m1">작성하기</a> </div>
	</c:if>   
      </div></div> 
		<div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div>
  </div>
     

</section>
<!-- //본문 -->

</body>
