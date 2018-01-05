<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<script type="text/javascript">

function write() {
	if($.trim($("#subject").val()) == "") {
		alert("제목을 입력해주세요.");
		$("#subject").focus();
		return false;
	}
	if($.trim($("#contents").val()) == "") {
		alert("내용을 입력해주세요.");
		$("#contents").focus();
		return false;
	}
	
	var url = "<c:url value='/bbs/writeaction'/>";
	var param = {};
	param.category = $("#category").val();
	param.subject = $.trim($("#subject").val());
	param.contents = $.trim($("#contents").val());
	param.secret_at = "N";
	if($("#secret_at").is(":checked")) {
		param.secret_at = "Y";
	}	
	
	
	if(!confirm("등록하겠습니까?"))
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
				alert("등록되었습니다.");
				go_09_01_01();
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

function deleteBbs() {
	
	var url = "<c:url value='/bbs/deleteaction'/>";
	var param = {};
	param.bbs_sn = $("#bbs_sn").val();
	
	
	if(!confirm("삭제하겠습니까?"))
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
				go_09_01_01();
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
		return false;
	}
	if($.trim($("#contents").val()) == "") {
		alert("내용을 입력해주세요.");
		$("#contents").focus();
		return false;
	}
	
	var url = "<c:url value='/bbs/modifyaction'/>";
	var param = {};
	param.category = $("#category").val();
	param.subject = $.trim($("#subject").val());
	param.contents = $.trim($("#contents").val());
	param.bbs_sn = $.trim($("#bbs_sn").val());
	param.secret_at = "N";
	if($("#secret_at").is(":checked")) {
		param.secret_at = "Y";
	}	
	
	
	if(!confirm("수정하겠습니까?"))
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
				alert("수정되었습니다.");
				go_09_01_01();
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


<form id="frmBbs" method="post">
	<input type="hidden" id="category" name="category" value="R">
	<input type="hidden" id="bbs_sn" name="bbs_sn" value="${view.BBS_SN}">
</form>
<!-- 본문 -->
<section>
     
      <div id="container"> 
		  <div class="sp_50"></div>
    <div class="inner2">
              <div class="title_bar">
                <div class="title2">
                  <p class="text1">여행예약</p>
                  <p class="text2">여행예약 게시판은 회원의 전용 게시판입니다. </p>
                </div>
      </div>
             
        <div class="bbs_view01_box">
                  <table cellpadding="0" cellspacing="0"  class="bbs_view01">
            <col width="15%" />
            <col width="" />
             <col width="15%" />
            <col width="" />
            <tbody>
			<c:if test="${mode == 'write' or mode == 'modify' }" >
				<tr>
					<th>제목</th>
					<td class="end">
						<input type="text" id="subject" name="subject" value="${view.SUBJECT}">
					</td>
					<th>비밀글</th>
					<td class="end">
						<input type="checkbox" id="secret_at" name="secret_at" <c:if test="${view.SECRET_AT == 'Y'}" > checked</c:if>>
					</td>
              </tr>
              <tr>
              	<td colspan="4">
              		<textarea id="contents" name="contents">${view.CONTENTS}</textarea>
              	</td>
              </tr>
			</c:if>           
			<c:if test="${mode == 'view' }" >
				<tr>
					<th>제목</th>
					<td colspan="3">${view.SUBJECT }</td>
              </tr>
				<tr>
					<th>작성자</th>
					<td>${view.USER_NM }</td>
					<th>조회수</th>
                    <td  class="end">${view.VIEWCNT }</td>
              </tr>
              <tr>
              	<td colspan="4">
              		${view.CONTENTS }
              	</td>
              </tr>
			</c:if>           
			</tbody>
          </table>
      </div>
       <!--하단버튼 -->
        <div class="bbs_bottom">
			<c:if test="${mode == 'view' and view.WRITNG_ID == esntl_id }" >
                  <div class="left_btn">
                  	<a href="javascript:modifyBbs();" class="button_m2 mr_m1">수정하기</a>
                  	<a href="javascript:deleteBbs();" class="button_m2">삭제하기 </a>
                  </div>
            </c:if>
                  <div class="right_btn">
					<c:if test="${mode == 'write' }" >
                  		<a href="javascript:write();" class="button_m1 mr_m1">글쓰기</a>
                  	</c:if>
					<c:if test="${mode == 'modify' }" >
                  		<a href="javascript:modifyaction();" class="button_m1 mr_m1">수정하기</a>
                  	</c:if>
                  	<a href="javascript:go_09_01_01();" class="button_m2">목록보기</a> 
                  </div>
      </div>
        <!--//하단버튼 --> 
     
              
              <!-- //페이징 -->
        </div> 
		  <div class="sp_50"></div>
  </div>
     
</section>
<!-- //본문 -->
</body>
