<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<script type="text/javascript">
$(function(){	
	$("#allCheck").click(function () {
		if($("#allCheck").prop("checked")) { 
			$("input[name='chkCart']").prop("checked",true); 
		} else { 
			$("input[name='chkCart']").prop("checked",false); 
		}
	});

});

function delCartSingle(cart_sn) {
	var lst = [];
	lst.push(cart_sn);
	delCart(lst);
}

function delCartAll() {
	var lst = [];
	$("input[name='chkCart']:checked").each(function() {
		lst.push($(this).val());
	});
	if(lst.length == 0) {
		alert("삭제 건이 없습니다.");
		return false;
	}
	delCart(lst);
}

function delCart(cart_sn) {
	var url = "<c:url value='/cart/delAction'/>";
	var param = {};
	param.cart_sn = cart_sn;
	console.log(param);
	
	if(!confirm("정말 삭제하겠습니까?"))
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
				document.location.reload();
			} else if(data.result == "-2") {
				alert("로그인이 필요합니다.");
				$(".login").click();
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

function paymentCart() {
	var url = "<c:url value='/purchs/addAction'/>";
	var lst = [];
	var totalAmount = 0;
	$("input[name='chkCart']:checked").each(function() {
		lst.push( {"cart_sn" : $(this).val() } );
		totalAmount += Number($(this).parent().find("input[name='purchs_amount']").val());
	});
	if(lst.length == 0) {
		alert("선택 건이 없습니다.");
		return false;
	}
	
	if(!confirm("결제하겠습니까?"))
		return false;
	
	var param = {};
	param.tot_setle_amount = totalAmount;
	param.real_setle_amount = totalAmount;
	param.use_point = "0";
	param.lstCart = lst;
	console.log(param);
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("결제되었습니다.");
				document.location.reload();
			} else if(data.result == "-2") {
				alert("로그인이 필요합니다.");
				$(".login").click();
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

function toPickAll() {
	var lst = [];
	$("input[name='chkCart']:checked").each(function() {
		lst.push($(this).val());
	});
	if(lst.length == 0) {
		alert("찜하기 건이 없습니다.");
		return false;
	}

	var url = "<c:url value='/cart/changeCartMode'/>";
	var param = {};
	param.cart_sn = lst;
	param.cart_mode = "P"
	console.log(param);
	
	if(!confirm("해당 삼품을 찜하기로 이동하겠습니까?"))
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
				alert("이동하였습니다.");
				document.location.reload();
			} else if(data.result == "-2") {
				alert("로그인이 필요합니다.");
				$(".login").click();
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

<!-- 본문 -->
<div id="container">
  <div class="inner2">

  <div class="top_title_com">
    <div class="title">
      <div class="text1"><em>예약목록</em>(장바구니)</div>
      <div class="text2">장바구니에 담겨진 상품을 확인하실 수 있습니다.<br />
        </div>
    </div>

  </div>
  <div class="tb_05_box">
    <table width="100%" class="tb_05" >
      <col width="5%" />
      <col width="15%" />
      <col width="" />
      <col width="7%" />
      <!--<col width="10%" />-->
      <col width="10%" />
      <col width="10%" />
      <col width="13%" />
      <thead>
        <tr>
          <th><input type="checkbox" name="checkbox" id="allCheck" /></th>
          <th>&nbsp;</th>
          <th>상품정보</th>
          <th >판매가격</th>
          <!-- <th >수량</th> -->
          <th >할인</th>
          <th >구매예정가</th>
          <th >삭제</th>
        </tr>
      </thead>
      <tbody>
		<c:set var="originTotalprice" value="0" />
		<c:set var="salePrice" value="0" />
		<c:set var="totalPrice" value="0" />
		<c:forEach var="result" items="${cartList}" varStatus="status">
		<tr>
			<td ><input type="checkbox" name="chkCart" value="${result.CART_SN}" /><input type="hidden" name="purchs_amount" value="${result.PURCHS_AMOUNT}"></td>
			<td class="left"><div class="cart_img" style="background: url(<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}); background-size: cover; "></div></td>
			<td  class="t_left">
				<div class="cart_pro_text">
					<div class="title">${result.GOODS_NM}<br />
						<c:if test="${!empty result.TOUR_DE}">
							${fn:substring(result.TOUR_DE,0,4)}년 ${fn:substring(result.TOUR_DE,4,6)}월 ${fn:substring(result.TOUR_DE,6,8)}일
						</c:if>
						<c:if test="${!empty result.CHKIN_DE}">
							${fn:substring(result.CHKIN_DE,0,4)}년 ${fn:substring(result.CHKIN_DE,4,6)}월 ${fn:substring(result.CHKIN_DE,6,8)}일 ~ ${fn:substring(result.CHCKT_DE,0,4)}년 ${fn:substring(result.CHCKT_DE,4,6)}월 ${fn:substring(result.CHCKT_DE,6,8)}일
						</c:if>
						<br />
					</div>		
					<c:if test="${result.CL_SE ne 'S'}">
						<div class="text1">${fn:substring(result.BEGIN_TIME,0,2)}시 ${fn:substring(result.BEGIN_TIME,2,4)}분 ~ ${fn:substring(result.END_TIME,0,2)}시 ${fn:substring(result.END_TIME,2,4)}분</div>
						<c:forEach var="options" items="${result.OPTIONS}" varStatus="status">
							<div class="text1">${options.NMPR_CND} ${options.NMPR_CO}명 </div>
						</c:forEach>
					</c:if>					
					<c:if test="${result.CL_SE eq 'S'}">
						<c:forEach var="options" items="${result.OPTIONS}" varStatus="status">
							<div class="text1">${options.SETUP_NM} ${options.NMPR_CND} </div>
						</c:forEach>
					</c:if>					
					<!-- <div class="option_re">
						<div class="select_box">
							<select name="" class="w_30p">
								<option>옵션변경1</option>
							</select>
							<select name="" class="w_30p">
								<option>옵션변경2</option>
							</select>
						</div>
						<div class="text1">옵션변경</div>
            		</div> -->
            	</div>
            </td>
			<td >
				<div class="cart_price2">
					<fmt:formatNumber value="${result.ORIGIN_AMOUNT}" pattern="#,###" />원
				</div>
			</td>
			<!-- <td >
				<div class="cart_umber">
					<div class="input_bst1">
						<input type="text" name="textfield" id="textfield" />
					</div>
					<div class="input_bst2">
						<img src="/images/sub/icon_up.gif" alt=""/>
						<img src="/images/sub/icon_down.gif"  alt=""/>
					</div>
				</div>
				<div class="cart_umber_btn"><a href="#">수량변경</a></div>
			</td> -->
			<td><fmt:formatNumber value="${result.ORIGIN_AMOUNT - result.PURCHS_AMOUNT}" pattern="#,###" />원<!-- 할인이벤트명<br />
            	-3,000원 --></td>
			<td ><div class="cart_price3"><fmt:formatNumber value="${result.PURCHS_AMOUNT}" pattern="#,###" />원</div></td>
			<td > <a href="javascript:delCartSingle('${result.CART_SN}');" class="sbtn_01">삭제하기</a></td>
		</tr>
		<c:set var="originTotalprice" value="${originTotalprice + result.ORIGIN_AMOUNT }" />
		<c:set var="salePrice" value="${salePrice + (result.ORIGIN_AMOUNT - result.PURCHS_AMOUNT) }" />
		<c:set var="totalPrice" value="${totalPrice + result.PURCHS_AMOUNT }" />		
		</c:forEach>      

      </tbody>
    </table>
  </div>
  <div class="sp_30"></div>
  <div class="cart_total">
    <div class="inbox">
      <div class="title">총  주문 금액 </div>
      <div class="price_box">
        <div class="text1">
          <div class="t1">총 상품금액<br />
            <em><fmt:formatNumber value="${originTotalprice}" pattern="#,###" /></em>원</div>
        </div>
        <div class="text2"><i class="material-icons">&#xE15C;</i></div>
        <div class="text1">
          <div class="t2">총 할인금액<br />
            <em><fmt:formatNumber value="${salePrice}" pattern="#,###" /></em>원</div>
        </div>
         <div class="text2"><i class="material-icons">&#xE15C;</i></div>
        <div class="text1">
          <div class="t2">포인트 사용<br />
            <em>0</em>원</div>
        </div>
      </div>
      <div class="price_toral">
        <div class="toral_icon"><i class="material-icons">&#xE035;</i></div>
        <div class="text3">
          <div class="t1">최종결제예정금액<br />
            <em><fmt:formatNumber value="${totalPrice}" pattern="#,###" /></em>원</div>
        </div>
      </div>
    </div>
  </div>
  <div class="cart_btn">
    <div class="left_btn">
      <div class="btn1"><a href="javascript:toPickAll();">선택상품찜하기담기</a></div>
      <div class="btn2"><a href="javascript:delCartAll();">선택상품삭제</a></div>
      <!-- <div class="btn2"><a href="#">품절상품삭제</a></div> -->
    </div>
    <div class="right_btn">
      <div class="btn3"><a href="#">여행상품보기</a></div>
      <div class="btn2"><a href="javascript:paymentCart();">선택상품 결제하기</a></div>
    </div>
  </div>
  <!--//컨텐츠영역 -->
    	<div class="sp_50"></div>
  </div>
</div>

<!-- //본문 -->
        
</body>