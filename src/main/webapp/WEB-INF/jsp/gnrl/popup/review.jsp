<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!--팝업 : 이용후기 -->
<div class="lightbox" id="review_popup">
	<input type="hidden" id="review_purchs_sn" value="${purchs_sn}">
	<input type="hidden" id="review_cart_sn" value="${cart_sn}" >
	<input type="hidden" id="review_goods_code" value="${goods_code}" >	
	<input type="hidden" id="callback" value="${callback}" >	
  <div class="popup_com">
    <div class="title">이용후기</div>
    <div class="popup_cont">
      <div class="tb_01_box">
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="">
          <tbody>
            <tr>
              <th >점수</th>
              <td>
              	<div id="revice_score" class="star_icon">
              		<c:if test="${review == null}">
	              		<i class="material-icons">star_rate</i>
	              		<i class="material-icons">star_rate</i>
	              		<i class="material-icons">star_rate</i>
	              		<i class="material-icons">star_rate</i>
	              		<i class="material-icons">star_rate</i>
              		</c:if>
              		<c:if test="${review != null}">
              			<c:forEach var="item" begin="1" end="5">
              				<c:if test="${item <= review.REVIEW_SCORE }">
              					<i class="material-icons on">star_rate</i>
              				</c:if>
              				<c:if test="${item > review.REVIEW_SCORE }">
              					<i class="material-icons">star_rate</i>
              				</c:if>
              			</c:forEach>
              		</c:if>
              	</div>
              </td>
            </tr>
            <tr>
              <th >내용쓰기</th>
              <td>
              	<textarea name="textarea" id="review_cn" class="w_100p input_st"  placeholder="" style="height: 300px">${review.REVIEW_CN}</textarea>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn">
      	<c:if test="${esntl_id == purchs.ESNTL_ID}">
      		<a href="javascript:saveReview();">등록하기</a>
      	</c:if>
      </div>
    </div>
  </div>

<script>

$(".star_icon i").click(function () {
	$(".star_icon i").removeClass("on");
	var myIdx = $(this).index();
	$(".featherlight .star_icon i").each(function (index) {
		if(index <= myIdx)
			$(this).addClass("on");
	});
});

function saveReview() {
	if($.trim($(".featherlight #review_cn").val()) == "") {
		alert("내용을 입력해주세요.");
		$(".featherlight #review_cn").focus();
		return false;
	}
	if($(".featherlight .star_icon").find(".on").length == 0) {
		alert("점수를 선택해주세요.");
		return false;
	}
	
	var url = "<c:url value='/cs/savePurchsReview'/>";
	
	var param = {};
	param.purchs_sn = $(".featherlight #review_purchs_sn").val();
	param.cart_sn = $(".featherlight #review_cart_sn").val();
	param.review_cn = $(".featherlight #review_cn").val();
	param.review_score = $(".featherlight .star_icon").find(".on").length;
	param.goods_code = $(".featherlight #review_goods_code").val();
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

</script>
</div>
<!--팝업-->
