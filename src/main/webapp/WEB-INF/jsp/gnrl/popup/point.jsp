<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!--팝업 : 이용후기 -->
<div class="lightbox" id="opinion_popup">
	<input type="hidden" id="maxpoint" value="${maxpoint}">
	<input type="hidden" id="point" value="${point}" >	
	<input type="hidden" id="callback" value="${callback}" >	
  <div class="popup_com">
    <div class="title">포인트 사용하기 </div>
    <div class="popup_cont">
      <div class="tb_01_box">
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="">
          <tbody>
            <tr>
              <th>나의 포인트</th>
              <td><fmt:formatNumber value="${point}" pattern="#,###" /></td>
            </tr>
            <tr>
              <th>사용 가능 포인트</th>
              <td><fmt:formatNumber value="${maxpoint}" pattern="#,###" /></td>
            </tr>
            <tr>
              <th>사용 포인트</th>
              <td><input type="text" id="txtUsePoint" value="0" /></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn">
      	<a href="javascript:usePoint();" id="btnOpinion1">사용하기</a>
      	<a href="javascript:cancelPoint();" id="btnOpinion1">취소</a>
      </div>
    </div>
  </div>


<script>

function usePoint() {
	var callback = $(".featherlight #callback").val();
	var point = Number($(".featherlight #txtUsePoint").val());
	var maxpoint = Number("${maxpoint}");
	var mypoint = Number("${point}");
	
	if(maxpoint > mypoint) {
		if(mypoint < point) {
			alert("최대 사용 가능 포인트는 " + mypoint + "입니다.");
			return;
		}
	} else {
		if(maxpoint < point) {
			alert("최대 사용 가능 포인트는 " + maxpoint + "입니다.");
			return;
		}
	}

	if(callback != "") {
		var fn = window[callback];
		// is object a function?
		if (typeof fn === "function") fn(point);
	}
	$.featherlight.close();
}

function cancelPoint() {
	$.featherlight.close();
}

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

function saveOpinion() {
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
	
	var url = "<c:url value='/cs/saveOpinion'/>";
	
	var param = {};
	param.opinion_sn = $(".featherlight #opinion_sn").val();
	param.opinion_sj = $(".featherlight #opinion_sj").val();
	param.opinion_cn = $(".featherlight #opinion_cn").val();
	param.goods_code = $(".featherlight #goods_code").val();
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
