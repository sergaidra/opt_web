<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!--팝업 : 이용후기 -->
<div class="lightbox" id="opinion_popup">
	<input type="hidden" id="opinion_sn" value="${opinion_sn}">
	<input type="hidden" id="goods_code" value="${goods_code}" >	
	<input type="hidden" id="callback" value="${callback}" >	
	<input type="hidden" id="parent_opinion_sn" value="${opinion.PARENT_OPINION_SN}">
	<input type="hidden" id="isOpinionInput" value="0">
  <div class="popup_com">
    <div class="title">문의하기 </div>
    <div class="popup_cont">
      <div class="tb_01_box">
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="30%">
          <col width="20%">
          <col width="30%">
          <tbody>
            <tr>
              <th>작성자</th>
              <td>${info.USER_NM}</td>
              <th>작성일</th>
              <td>${info.WRITNG_DT}</td>
            </tr>
            <tr>
              <th>문의종류</th>
              <td>
                  	<select id="category" name="category" style="width:90%;">
                    	<option value="R" <c:if test="${opinion.CATEGORY == 'R'}">selected</c:if>>예약</option>
                    	<option value="G" <c:if test="${opinion.CATEGORY == 'G'}">selected</c:if>>상품</option>
                    	<option value="F" <c:if test="${opinion.CATEGORY == 'F'}">selected</c:if>>환불</option>
                    	<option value="X" <c:if test="${opinion.CATEGORY == 'X'}">selected</c:if>>기타</option>
                    </select>
              </td>
              <th>이메일</th>
              <td>${info.EMAIL}</td>
            </tr>
            <tr>
              <th >제목</th>
              <td colspan="3"><input type="text" placeholder="" class="w_100p input_st" id="opinion_sj" name="opinion_cn" value="${opinion.OPINION_SJ}"></td>
            </tr>
            <tr>
              <th >내용쓰기</th>
              <td colspan="3"><textarea name="opinion_cn" id="opinion_cn" class="w_100p input_st"  placeholder="" style="height: 300px">${opinion.OPINION_CN}</textarea></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn">
      	<c:if test="${opinion == null}">
	      	<a href="javascript:saveOpinion();" id="btnOpinion1">문의하기</a>
	    </c:if>
      	<c:if test="${opinion != null}">
	      	<c:if test="${esntl_id == opinion.WRITNG_ID}">
		      	<a href="javascript:saveOpinion();" id="btnOpinion1">수정하기</a>
		      	<a href="javascript:deleteOpinion();" id="btnOpinion4">삭제하기</a>
			   	<c:if test="${author_cl == 'A' and opinion.PARENT_OPINION_SN == null}">
			      	<a href="javascript:answerOpinion();" id="btnOpinion2">답변하기</a>
			    </c:if>
		    </c:if>
	      	<a href="javascript:saveOpinion();" style="display:none;" id="btnOpinion3">답변등록</a>
			<c:if test="${author_cl == 'A'}">
		      	<a href="javascript:deleteAdmin();" id="btnOpinion5">문의삭제</a>
			</c:if>
      	</c:if>
      </div>
    </div>
  </div>


<script>

if("${mode}" == "A")
	answerOpinion();

function answerOpinion() {
	$(".featherlight #parent_opinion_sn").val($(".featherlight #opinion_sn").val());
	$(".featherlight #opinion_sj").val("[RE] " + $(".featherlight #opinion_sj").val());
	$(".featherlight #opinion_sn").val("");
	$(".featherlight #opinion_cn").val("");
	$(".featherlight #btnOpinion1").hide();	
	$(".featherlight #btnOpinion2").hide();	
	$(".featherlight #btnOpinion4").hide();	
	$(".featherlight #btnOpinion5").show();	
	$(".featherlight #btnOpinion3").show();	
}

function initOpinionStatus() {
	$("#isOpinionInput").val("0");
}

function saveOpinion() {
	if($("#isOpinionInput").val() == "1")
		return;

	$("#isOpinionInput").val("1");

	if($.trim($(".featherlight #opinion_sj").val()) == "") {
		initOpinionStatus();
		alert("제목을 입력해주세요.");
		$(".featherlight #opinion_sj").focus();
		return;
	}
	if($.trim($(".featherlight #opinion_cn").val()) == "") {
		initOpinionStatus();
		alert("내용을 입력해주세요.");
		$(".featherlight #opinion_cn").focus();
		return;
	}
	
	var url = "<c:url value='/cs/saveOpinion'/>";
	
	var param = {};
	param.opinion_sn = $(".featherlight #opinion_sn").val();
	param.opinion_sj = $(".featherlight #opinion_sj").val();
	param.opinion_cn = $(".featherlight #opinion_cn").val();
	param.goods_code = $(".featherlight #goods_code").val();
	param.category = $(".featherlight #category").val();
	param.parent_opinion_sn = $(".featherlight #parent_opinion_sn").val();
	var callback = $(".featherlight #callback").val();

	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
			if(data.result == "0") {	        	
				alert("등록되었습니다.");
				if(callback != "") {
					var fn = window[callback];
					// is object a function?
					if (typeof fn === "function") fn();
				}
				initOpinionStatus();
				$.featherlight.close();
			} else if(data.result == "-2") {
				initOpinionStatus();
				alert("로그인이 필요합니다.");
				go_login();
			} else if(data.result == "9") {
				initOpinionStatus();
				alert(data.message);
			} else{
				initOpinionStatus();
				alert("작업을 실패하였습니다.");
			}	        	
        },
        error : function(request,status,error) {
    		initOpinionStatus();
        	alert(error);
        },
	});			
}

function deleteOpinion() {
	if(!confirm("삭제하겠습니까?"))
		return;
	
	var url = "<c:url value='/cs/deleteOpinion'/>";
	
	var param = {};
	param.opinion_sn = $(".featherlight #opinion_sn").val();
	var callback = $(".featherlight #callback").val();

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
				if(callback != "") {
					var fn = window[callback];
					// is object a function?
					if (typeof fn === "function") fn();
				}
				$.featherlight.close();
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

function deleteAdmin() {
	if($.trim($(".featherlight #opinion_sj").val()) == "") {
		alert("제목을 입력해주세요.");
		$(".featherlight #opinion_sj").focus();
		return;
	}
	if($.trim($(".featherlight #opinion_cn").val()) == "") {
		alert("내용을 입력해주세요.");
		$(".featherlight #opinion_cn").focus();
		return;
	}

	if(!confirm("문의글을 삭제하겠습니까?"))
		return;
	
	var url = "<c:url value='/cs/deleteOpinion'/>";
	
	var param = {};
	var callback = $(".featherlight #callback").val();
	param.opinion_sn = $(".featherlight #opinion_sn").val();
	param.parent_opinion_sn = $(".featherlight #parent_opinion_sn").val();		
	param.opinion_sj = $(".featherlight #opinion_sj").val();
	param.opinion_cn = $(".featherlight #opinion_cn").val();
	param.goods_code = $(".featherlight #goods_code").val();
	param.delete_mode = "A";

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
				if(callback != "") {
					var fn = window[callback];
					// is object a function?
					if (typeof fn === "function") fn();
				}
				$.featherlight.close();
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
</div>
<!--팝업-->
