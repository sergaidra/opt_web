<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<script type="text/javascript">
$(function() {
	$("#subcategory").change(function () {		
		if($("#subcategory").val() == "R" || $("#subcategory").val() == "G") {
			var cont = "작 성 자\n\t- 000";
			cont += "\n\n여행일자\n\t- 00년 00월 00일 ~ 00년 00월 00일(00박 00일)";
			cont += "\n\n인    원\n\t- 00명";
			cont += "\n\n연락처\n\t- 000-0000-0000 ";
			cont += "\n\n1. 풀빌라\n\t- ";
			cont += "\n\n2. 픽업 / 드랍\n\t- ";
			cont += "\n\n3. 엑티비티(00000)\n\t- ";
			cont += "\n\n기타문의\n\t- ";
			$("#contents").val(cont); 
		} else if($("#subcategory").val() == "F" ) {
			var cont = "작 성 자\n\t- 000";
			cont += "\n\n여행일자\n\t- 00년 00월 00일 ~ 00년 00월 00일(00박 00일)";
			cont += "\n\n인    원\n\t- 00명";
			cont += "\n\n연락처\n\t- 000-0000-0000 ";
			$("#contents").val(cont); 
		}		
	});
	
	<c:if test="${mode == 'write' }" >
		<c:if test="${category != 'A' }" >
		$("#subcategory").val("R");
		$("#subcategory").trigger("change");
		</c:if>
	</c:if>
});

var isWrite = false;
function initWrite() {
	isWrite = false;
}

function write() {
	if(isWrite == true)
		return;
	isWrite = true;

	if($.trim($("#subject").val()) == "") {
		initWrite();
		alert("제목을 입력해주세요.");
		$("#subject").focus();
		return ;
	}
	if($.trim($("#contents").val()) == "") {
		initWrite();
		alert("내용을 입력해주세요.");
		$("#contents").focus();
		return ;
	}
	
	var url = "<c:url value='/bbs/writeaction'/>";
	var param = {};
	param.category = $("#category").val();
	param.subject = $.trim($("#subject").val());
	param.contents = $.trim($("#contents").val());
	//param.secret_at = "Y";
	param.subcategory = $("#subcategory").val();
	if($("#secret_at").is(":checked")) {
		param.secret_at = "Y";
	} else {
		param.secret_at = "N";
	}	
	
	if(!confirm("저장하겠습니까?")) {
		initWrite();
		return;
	}

	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				initWrite();
				alert("저장되었습니다.");
				goBbsList();
			} else if(data.result == "-2") {
				initWrite();
				alert("로그인이 필요합니다.");
				go_login();
			} else if(data.result == "9") {
				initWrite();
				alert(data.message);
			} else{
				initWrite();
				alert("작업을 실패하였습니다.");
			}	        	
        },
        error : function(request,status,error) {
    		initWrite();
        	alert(error);
        },
	});			
}

function deleteBbs() {
	var url = "<c:url value='/bbs/deleteaction'/>";
	var param = {};
	param.bbs_sn = $("#bbs_sn").val();

	if(!confirm("삭제하겠습니까?"))
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
				alert("삭제되었습니다.");
				goBbsList();
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

function deletebbsadmin() {
	if($.trim($(".featherlight #answer_subject").val()) == "") {
		alert("제목을 입력해주세요.");
		$(".featherlight #answer_subject").focus();
		return ;
	}
	if($.trim($(".featherlight #answer_contents").val()) == "") {
		alert("내용을 입력해주세요.");
		$(".featherlight #answer_contents").focus();
		return ;
	}
	
	var url = "<c:url value='/bbs/deleteadminaction'/>";
	var param = {};
	param.bbs_sn = $("#bbs_sn").val();
	param.category = $("#category").val();
	param.subject = $.trim($(".featherlight #answer_subject").val());
	param.contents = $.trim($(".featherlight #answer_contents").val());
	//param.secret_at = "Y";
	param.subcategory = $("#subcategory").val();
	param.parent_bbs_sn = $.trim($("#bbs_sn").val());
	if($("#secret_at").is(":checked")) {
		param.secret_at = "Y";
	} else {
		param.secret_at = "N";
	}
	
	if(!confirm("사용자글을 삭제하겠습니까?"))
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
				alert("삭제되었습니다.");
				goBbsList();
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

function modifyBbs() {
	var frm = $("#frmBbs");
	$(frm).attr("action", "/bbs/modify");
	$(frm).submit();
}

function modifyaction() {
	if($.trim($("#subject").val()) == "") {
		alert("제목을 입력해주세요.");
		$("#subject").focus();
		return ;
	}
	if($.trim($("#contents").val()) == "") {
		alert("내용을 입력해주세요.");
		$("#contents").focus();
		return ;
	}
	
	var url = "<c:url value='/bbs/modifyaction'/>";
	var param = {};
	param.category = $("#category").val();
	param.subject = $.trim($("#subject").val());
	param.contents = $.trim($("#contents").val());
	param.bbs_sn = $.trim($("#bbs_sn").val());
	//param.secret_at = "Y";
	param.subcategory = $("#subcategory").val();
	if($("#secret_at").is(":checked")) {
		param.secret_at = "Y";
	} else {
		param.secret_at = "N";
	}
	
	if(!confirm("수정하겠습니까?"))
		return ;
		
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("수정되었습니다.");
				goBbsList();
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

function writeComment() {
	if($.trim($("#cmt").val()) == "") {
		alert("댓글을 입력해주세요.");
		$("#cmt").focus();
		return ;
	}
	
	var url = "<c:url value='/bbs/writecommentaction'/>";
	var param = {};
	param.cmt = $("#cmt").val();
	param.bbs_sn = $.trim($("#bbs_sn").val());
	
	if(!confirm("댓글을 저장하겠습니까?"))
		return ;
		
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("저장되었습니다.");
				document.location.reload();
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

function deleteComment(comment_sn) {
	
	var url = "<c:url value='/bbs/deletecommentaction'/>";
	var param = {};
	param.comment_sn = comment_sn;
	
	if(!confirm("댓글 삭제하겠습니까?"))
		return ;
		
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("댓글 삭제되었습니다.");
				document.location.reload();
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

function writeanswer() {
	if($.trim($(".featherlight #answer_subject").val()) == "") {
		alert("제목을 입력해주세요.");
		$(".featherlight #answer_subject").focus();
		return ;
	}
	if($.trim($(".featherlight #answer_contents").val()) == "") {
		alert("내용을 입력해주세요.");
		$(".featherlight #answer_contents").focus();
		return ;
	}
	
	var url = "<c:url value='/bbs/writeaction'/>";
	var param = {};
	param.category = $("#category").val();
	param.subject = $.trim($(".featherlight #answer_subject").val());
	param.contents = $.trim($(".featherlight #answer_contents").val());
	//param.secret_at = "Y";
	param.subcategory = $("#subcategory").val();
	param.parent_bbs_sn = $.trim($("#bbs_sn").val());
	if($("#secret_at").is(":checked")) {
		param.secret_at = "Y";
	} else {
		param.secret_at = "N";
	}	
	
	if(!confirm("저장하겠습니까?"))
		return ;
		
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("저장되었습니다.");
				goBbsList();
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

function goBbsList() {
	<c:if test="${category == 'A'}">
		go_05_02_01();
	</c:if>
	<c:if test="${category != 'A'}">
		go_05_01_01();
	</c:if>
}
</script>
</head>

<body>


<form id="frmBbs" method="post">
	<input type="hidden" id="category" name="category" value="${category}">
	<input type="hidden" id="bbs_sn" name="bbs_sn" value="${view.BBS_SN}">
</form>

<!-- 본문 -->
<section>

<div id="container">
	   <div class="sp_50"></div>
  <div class="inner2">
  	<div class="order_list">
	   <div class="com_stitle">
	        <c:if test="${mode == 'write'}" >작성하기</c:if>
	        <c:if test="${mode == 'modify'}" >수정하기</c:if>
	        <c:if test="${mode == 'view'}" >상세보기</c:if>
	    </div>
        <div class="review_wr_box">
        	<c:if test="${mode == 'write' or mode == 'modify' }" >
            <table  class="review_wr">
                <col width="13%" />
                <col width="22%" />
                <col width="12%" />
                <col width="23%" />
                <col width="12%" />
                <col width="18%" />
                <tbody>
                   <tr>
                    <th>작성자</th>
                    <td>${view.USER_NM }</td>
                    <th>작성일</th>
                    <td>${view.WRITNG_DT }</td>
                    <th>비밀글</th>
                    <td class="end"><input type="checkbox" id="secret_at" name="secret_at" <c:if test="${view.SECRET_AT == 'Y'}"> checked</c:if>></td>
                  </tr>
                   <tr style="display:<c:if test='${category == "A"}'>none</c:if>;">
                    <th>문의종류</th>
                    <td>
                    	<c:if test="${mode == 'write'}" >
                    	<select id="subcategory" name="subcategory" style="width:100%;">
                    		<option value="R">예약</option>
                    		<option value="G">상품</option>
                    		<option value="F">환불</option>
                    		<option value="X">기타</option>
                    	</select>
                    	</c:if>
                    	<c:if test="${mode == 'modify' }" >
                    		${view.SUBCATEGORYNM}<input id="subcategory" name="subcategory" type="hidden" value="${view.SUBCATEGORY}" />
                    	</c:if>
                    </td>                  
                    <th>이메일</th>
                    <td class="end" colspan="5">${view.EMAIL }</td>
                  </tr>
                  <tr>
                    <th>제목</th>
                    <td colspan="5" class="end">
                    	<input type="text" id="subject" name="subject" class="input_st01" style="width:100%" value="${view.SUBJECT}">
                    </td>
                  </tr>
                  <tr>
                    <th>내용</th>
                    <td colspan="5" class="end">
                    	<textarea id="contents" name="contents" class="input_st01" style="width:100%; height:250px;">${view.CONTENTS}</textarea>
                    </td>
                  </tr>
			</c:if>
			<c:if test="${mode == 'view' }" >
			<input type="checkbox" id="secret_at" name="secret_at" <c:if test="${view.SECRET_AT == 'Y'}"> checked</c:if> style="display:none;">
            <table  class="review_wr">
                <col width="15%" />
                <col/>
                <col width="15%" />
                <col/>
                <tbody>				
                   <tr>
                    <th>작성자</th>
                    <td <c:if test='${category == "A"}'>colspan="3"</c:if>>${view.USER_NM }</td>
                    <c:if test='${category != "A"}'>
                    <th>문의종류</th>
                    <td class="end">${view.SUBCATEGORYNM }<input id="subcategory" name="subcategory" type="hidden" value="${view.SUBCATEGORY}" /></td>
                    </c:if>
                  </tr>
                   <tr>
                    <th>작성일</th>
                    <td>${view.WRITNG_DT }</td>
                    <th>이메일</th>
                    <td class="end">${view.EMAIL }</td>
                  </tr>
                  <tr>
                    <th>제목</th>
                    <td>
                    	${view.SUBJECT }
                    </td>
                    <th>조회수</th>
                    <td class="end">
                    	${view.VIEWCNT } 
                    </td>
                  </tr>
                  <tr>
                    <th>내용</th>
                    <td colspan="3" class="end">
                    	${view.CONTENTS_VIEW }
                    </td>
                  </tr>
				</c:if>
                </tbody>                	
              </table>
		</div>              
			<c:if test="${mode == 'view' }" >
	        <div class="review_wr_box">
	            <table  class="review_wr"  style="table-layout:fixed;">
	                <col width="15%" />
	                <col width="" />
	                <tbody>
	                	<c:forEach var="item" items="${lstComment}">
	               		<tr>
	               			<th>${item.USER_NM}<br/>(${item.WRITNG_DT})</th>
	               			<td class="end"  style="word-break:break-all">
	               				${item.CMT}
	               				<c:if test="${item.WRITNG_ID == esntl_id}">
		               				<a href="javascript:deleteComment('${item.COMMENT_SN}');" class="button_m1 mr_2" style="float:right; padding:3px;">삭제</a>
	               				</c:if>
	               			</td>
	               		</tr>
	                	</c:forEach>
	                	<c:if test="${!empty esntl_id}">
	                	<tr>
	                		<th>댓글 작성</th>
	                		<td class="end"><input type="text" id="cmt" name="cmt" style="width:calc(100% - 50px);"><a href="javascript:writeComment();" class="button_m1 mr_2" style="float:right; padding:3px;">작성</a></td>
	                	</tr>
	                	</c:if>
	                </tbody>
				</table>              
	        </div>
            </c:if>
        
        
        
         <!--하단버튼/ 페이징 -->
         
         <div class="bbs_bottom">
 			<c:if test="${mode == 'view' and view.WRITNG_ID == esntl_id }" >
                  <div class="left_btn">
                  	<a href="javascript:modifyBbs();" class="button_m2 mr_m1">수정</a>
                  	<a href="javascript:deleteBbs();" class="button_m2">삭제 </a>
                  </div>
            </c:if> 
			       <div class="right_btn"> 
					<c:if test="${mode == 'write' }" >
                  		<a href="javascript:write();" class="button_m1 mr_2">저장</a>
                  	</c:if>
					<c:if test="${mode == 'modify' }" >
                  		<a href="javascript:modifyaction();" class="button_m1 mr_2">수정</a>
                  	</c:if>
                  	<c:if test="${(author_cl == 'A' or author_cl == 'M') and mode == 'view'}">
  	             		<a href="#" data-featherlight="#answerbbs" class="button_m1 mr_2">답글</a>
                  	</c:if>
                  	<a href="javascript:goBbsList();" class="button_m2">목록</a> 
			       	</div>
       
      </div>
   
      <!--//하단버튼/ 페이징 -->
      </div></div>
	   <div class="sp_50"></div>
</div>

<div class="lightbox" id="answerbbs">
  <div class="popup_com">
    <div class="title">답글 작성 </div>
    <div class="popup_cont">
      <div class="tb_01_box">
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="">
          <tbody>
            <tr>
              <th >제목</th>
              <td><input type="text" placeholder="" class="w_100p input_st" id="answer_subject" name="answer_subject"></td>
            </tr>
            <tr>
              <th >내용쓰기</th>
              <td><textarea name="answer_contents" id="answer_contents" class="w_100p input_st"  placeholder="" style="height: 300px"></textarea></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn">
      	<a href="javascript:writeanswer();">등록하기</a>&nbsp;&nbsp;
      	<c:if test="${author_cl == 'A'}">
      		<a href="javascript:deletebbsadmin();">사용자글 삭제하기</a>
      	</c:if>
      </div>
    </div>
  </div>
</div>

</section>

</body>
