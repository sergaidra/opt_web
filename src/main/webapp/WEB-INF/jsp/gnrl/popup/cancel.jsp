<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!--팝업 : 이용후기 -->
<div class="lightbox" id="secession_popup">
	<input type="hidden" id="callback" value="${callback}" >	
  <div class="popup_com">
    <div class="title">결제취소하기</div>
    <div class="popup_cont">
      <div class="tb_01_box">
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="">
          <tbody>
			  <tr>
              <th >결제취소 구분</th>
              <td>
              	<select class="w_30p" id="delete_resn_se" name="delete_resn_se">
              		<option>선택</option>
              		<c:forEach var="item" items="${lstCancelCode}">
              			<option value="${item.CODE}">${item.CODE_NM}</option>
              		</c:forEach>
              	</select>
              </td>
            </tr>		  
            <tr>
              <th >결제취소 사유</th>
              <td><textarea name="delete_resn_etc" id="delete_resn_etc" class="w_100p input_st"  placeholder="" style="height: 300px"></textarea></td>
            </tr>
			  <!-- <tr>
              <th >환불계좌정보</th>
              <td><input type="text" placeholder="국민은행 020-000-0000" class="w_100p input_st"></td>
            </tr> -->
            <tr>
            	<th colspan="2">※ 예약 변경 및 취소, 환불 규정은 아래와 같습니다.<br/>
ㅇ 예약일 기준 30일 전 변경·취소 : 100% 환불<br/>
ㅇ 예약일 기준 15일 전 변경·취소 : 50% 환불<br/>
ㅇ 예약일 기준 14일전~당일 변경·취소 : 환불 불가<br/>
ㅇ 예약에 따른 여행당일 NO SHOW : 환불 불가<br/>
ㅇ 예약에 따른 여행일정 진행중 조기 취소 : 환불 불가<br/>
 ＊ 현지 현행법 위반(모든 불법행위) 및 질병 기타 사유로 지속적인 여행일정을 추진할 수 없는 경우</th>
            </tr>
		
          </tbody>
        </table>
      </div>
      <div class="popup_btn"><a href="javascript:cancelPurchs();">결제취소 신청하기</a></div>
    </div>
  </div>



<script>

function cancelPurchs() {
	if($.trim($(".featherlight #delete_resn_se").val()) == "") {
		alert("결제취소 구분을 선택해주세요.");
		$(".featherlight #delete_resn_se").focus();
		return;
	}
	if($.trim($(".featherlight #delete_resn_etc").val()) == "") {
		alert("사유를 입력해주세요.");
		$(".featherlight #delete_resn_etc").focus();
		return;
	}
	
	if(!confirm("정말 취소하겠습니까?"))
		return;
	
	var url = "<c:url value='/purchs/cancelPurchs'/>";
	
	var param = {};
	param.purchs_sn = "${purchs_sn}";
	param.delete_resn_se = $.trim($(".featherlight #delete_resn_se").val());
	param.delete_resn_etc = $.trim($(".featherlight #delete_resn_etc").val());
	param.refund_amount = "";
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
			if(data.result == "0") {
	        	alert("취소되었습니다.");
	        	go_mypage();
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
