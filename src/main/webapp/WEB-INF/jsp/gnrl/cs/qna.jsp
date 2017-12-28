<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<style>
tbody td .btn{ position: absolute; right: 5px; top: 18px}
tbody td .btn a.modify{ padding: 3px 5px; background: #eee; border: 1px solid #999; font-size: 11px; margin-right: -1px}
tbody td .btn a.del{ padding: 3px 5px; background: #eee; border: 1px solid #999; font-size: 11px}
tbody td .more_text{ width: 100%; float: left; padding:10px 110px 10px 40px; box-sizing: border-box; color: #666 ; font-size: 13px}
tbody td .more_title{ float: left; box-sizing: border-box; padding-left: 40px  }
tbody td .more_title p{ float: left; box-sizing: border-box; color: #fff; padding: 3px 5px; background-color: #666; font-size: 12px; border-radius: 50px}

</style>

<script type="text/javascript">

$(function(){	
	search(1);
});

function search(pageNo) {
	var url = "<c:url value='/cs/getOpinion'/>";
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
        	var rowCnt = 0;
        	for(var cnt = 0; cnt < data.list.length; cnt++) {
        		// PC
        		{
            		var tr = $("<tr onclick='showOpinion(" + data.list[cnt].OPINION_SN + ", 0);' style='cursor:pointer;'></tr>");

        			var td1 = $("<td>" + (Number(data.startIdx) + rowCnt) + "</td>");
        			var td2 = $("<td class=\"left\">[" + data.list[cnt].GOODS_NM + "] " + data.list[cnt].OPINION_SJ + "</td>");
            		var td3 = $("<td>" + data.list[cnt].USER_NM + "</td>");
            		var td4 = $("<td>" + data.list[cnt].WRITNG_DT + "</td>");
            		var td5 = null;
               		if(data.list[cnt].C_OPINION_SN != null) {
                   		td5 = $("<td><div class=\"listin_btn1\">답변완료</div ></td>");
   					} else {
                   		td5 = $("<td><div class=\"listin_btn2\">문의접수</div ></td>");
   					}
            		
            		$(tr).append(td1);
            		$(tr).append(td2);
            		$(tr).append(td3);
            		$(tr).append(td4);
            		$(tr).append(td5);

    	        	$("#tblList tbody").append(tr);        
    	        	
            		var tr2 = $("<tr style='display:none;' id='trOpinion_" + data.list[cnt].OPINION_SN + "'></tr>");
            		var td2_1 = $("<td colspan=\"5\"  class='left'><div id='re' class='re'></div></td>");
            		var td2_q_title = $("<div class=\"title_box\"><div class=\"title\">질문내용</div></div>");
            		var td2_q_cn = $("<div class=\"t_cont\">" + replaceBrSpace(data.list[cnt].OPINION_CN) + "</div>");
            		var td2_a_title = $("<div class=\"title_box\"><div class=\"title mt_20\">답변내용</div></div>");
            		var td2_a_cn = $("<div class=\"t_cont\">" + replaceBrSpace(data.list[cnt].C_OPINION_CN) + "</div>");
            		var td2_btn = $("<div class=\"btn\"></div>");
              		if(data.list[cnt].C_OPINION_SN == null && "${author_cl}" == "A") {
              			$(td2_btn).append($("<a href=\"javascript:viewOpinion(" + data.list[cnt].OPINION_SN + ", '" + data.list[cnt].GOODS_CODE + "', 'A');\" class=\"modify\">답변</a>"));
              		}
                	if(data.list[cnt].C_OPINION_SN != null && "${author_cl}" == "A") {
            			$(td2_btn).append($("<a href=\"javascript:viewOpinion(" + data.list[cnt].C_OPINION_SN + ", '" + data.list[cnt].GOODS_CODE + "', 'U');\" class=\"modify\">답변수정</a>"));
              		}
            		td2_1.find("#re").append(td2_q_title);
            		td2_1.find("#re").append(td2_q_cn);
               		if(data.list[cnt].C_OPINION_SN != null) {
                		td2_1.find("#re").append(td2_a_title);
                		td2_1.find("#re").append(td2_a_cn);
               		}
            		td2_1.find("#re").append(td2_btn);            		
            		td2_1.find("#re").append("<div style='clear:both;'></div>");            		
            		tr2.append(td2_1);
    	        	
    	        	$("#tblList tbody").append(tr2);        
        		}
        		
        		// 모바일
        		{
            		var tr = $("<tr onclick='showOpinion(" + data.list[cnt].OPINION_SN + ", 1);' style='cursor:pointer;'></tr>");

            		var tr1 = null;
        			var tr2 = null;
        			var td2span = null;

            		if(data.list[cnt].CHILDCNT > 0) {
            			divHtml = "<div class=\"listin_btn1\" style=\"float:right;\">답변완료</div >";
					} else {
						divHtml = "<div class=\"listin_btn2\" style=\"float:right;\">문의접수</div >";
					}

           			var divHtml = "";
               		if(data.list[cnt].C_OPINION_SN != null) {
               			divHtml = "<div class=\"listin_btn1\" style=\"float:right;\">답변완료</div >";
   					} else {
   						divHtml = "<div class=\"listin_btn2\" style=\"float:right;\">문의접수</div >";
   					}

           			td1 = $("<td></td>");
           			td1span = $("<span class='tb_font1' style='width:100%; float:left; text-align:left;'>no." + (Number(data.startIdx) + rowCnt) + " [" + data.list[cnt].USER_NM + "] [" + data.list[cnt].WRITNG_DT + "]"  + divHtml + "</span><br><span>" + data.list[cnt].OPINION_SJ + "</span>");

            		$(td1).append(td1span);
            		$(tr).append(td1);

    	        	$("#tblmList tbody").append(tr);
    	        	
            		var tr2 = $("<tr style='display:none;' id='trOpinionM_" + data.list[cnt].OPINION_SN + "'></tr>");
            		var td2_1 = $("<td class='left'><div id='re' class='re'></div></td>");
            		var td2_q_title = $("<div class=\"title_box\"><div class=\"title\">질문내용</div></div>");
            		var td2_q_cn = $("<div class=\"t_cont\" style='padding-right:0px;'>" + replaceBrSpace(data.list[cnt].OPINION_CN) + "</div>");
            		var td2_a_title = $("<div class=\"title_box\"><div class=\"title mt_20\">답변내용</div></div>");
            		var td2_a_cn = $("<div class=\"t_cont\" style='padding-right:0px;'>" + replaceBrSpace(data.list[cnt].C_OPINION_CN) + "</div>");
            		var td2_btn = $("<div class=\"btn\"></div>");
              		if(data.list[cnt].C_OPINION_SN == null && "${author_cl}" == "A") {
              			$(td2_btn).append($("<a href=\"javascript:viewOpinion(" + data.list[cnt].OPINION_SN + ", '" + data.list[cnt].GOODS_CODE + "', 'A');\" class=\"modify\">답변</a>"));
              		}
                	if(data.list[cnt].C_OPINION_SN != null && "${author_cl}" == "A") {
            			$(td2_btn).append($("<a href=\"javascript:viewOpinion(" + data.list[cnt].C_OPINION_SN + ", '" + data.list[cnt].GOODS_CODE + "', 'U');\" class=\"modify\">답변수정</a>"));
              		}
            		td2_1.find("#re").append(td2_q_title);
            		td2_1.find("#re").append(td2_q_cn);
               		if(data.list[cnt].C_OPINION_SN != null) {
                		td2_1.find("#re").append(td2_a_title);
                		td2_1.find("#re").append(td2_a_cn);
               		}
            		td2_1.find("#re").append(td2_btn);            		
            		td2_1.find("#re").append("<div style='clear:both;'></div>");            		
            		tr2.append(td2_1);
    	        	
    	        	$("#tblmList tbody").append(tr2);
        		}
        		if(data.list[cnt].DEPTH == 1) {
            		rowCnt++;
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

function showOpinion(opinion_sn, mode) {
	if(mode == 0)
		$("#trOpinion_" + opinion_sn).show();
	else
		$("#trOpinionM_" + opinion_sn).show();
}


function viewOpinion(opinion_sn, goods_code, mode) {
	$.featherlight('/cs/popupOpinion?opinion_sn=' + opinion_sn + '&goods_code=' + goods_code + '&callback=saveOpinionComplete&mode=' + mode, {});
}


function saveOpinionComplete() {
	search(1);
}

function replaceBrSpace(str) {
	if(str == null)
		return "";
	return str.replace(/\n/g, "<br />").replace(/  /g, "&nbsp;");
}

</script>
	
</head>

<body>

<input type="hidden" id="hidPage" name="hidPage" value="1">
<input type="hidden" id="pageSize" name="pageSize" value="5">
<input type="hidden" id="blockSize" name="blockSize" value="5">	

<!-- 본문 -->
<section>
     
      <div id="container"> 
	<div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div>
    <div class="inner2"><div class="comf">
		             <!--FAQ검색-->  <div class="bbs_search">
			    <div class="search_text">
			      <div class="tx1 fw_500">1:1 문의하기</div>
				  <div class="tx2">무엇을 도와드릴까요? <br>
고객님의 궁금함을 빠르게 해결해 드리겠습니다. </div>
			    </div>
<div class="search_in">
		 <div class="search_select  w_50p"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
              <select class="w_100p">
                      <option>상세분류</option>
                      <option>상세분류</option>
              </select>
                     
            <!--//기본 셀렉트 박스 --></div>
      
          <div class="search_input w_50p"><input type="text" class="w_100p">
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
                <th >작성자 </th>
                <th class="end">작성일 </th>
                <th class="end">진행상태 </th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
			<!--모바일-->
			<table width="100%" cellpadding="0" cellspacing="0" class="bba_list_m" id="tblmList">
              <col width="">           
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
        <div class="paginate mobile_view mt_30">
          <div class="number" id="mpaging">
          </div>
        </div>
        </div>
        <!--//페이징 --> 
      </div></div> 
		<div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div>
  </div>
     

</section>
<!-- //본문 -->

</body>
