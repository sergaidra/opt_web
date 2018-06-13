<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<script type="text/javascript">
var cartInfo = [];

<c:forEach var="item" items="${cartList}" varStatus="status">
	cartInfo.push({ "cart_sn": "${item.CART_SN}", "purchs_amount": "${item.PURCHS_AMOUNT}", "goods_code": "${item.GOODS_CODE}", "origin_amount": "${item.ORIGIN_AMOUNT}", "tour_de":"${item.TOUR_DE}", "chkin_de":"${item.CHKIN_DE}", "chckt_de":"${item.CHCKT_DE}", "hotdeal_at":"${item.HOTDEAL_AT}", "waitreservation_yn":"${item.WAITRESERVATION_YN}", "status":"${item.STATUS}", "chk" : false});
</c:forEach>

$(function(){	
	$("#allCheck").click(function () {
		if($("#allCheck").prop("checked")) { 
			$("input[name='chkCart']").prop("checked",true); 
			for(var cnt = 0; cnt < cartInfo.length; cnt++) {
				cartInfo[cnt].chk = true;
			}
		} else { 
			$("input[name='chkCart']").prop("checked",false); 
			for(var cnt = 0; cnt < cartInfo.length; cnt++) {
				cartInfo[cnt].chk = false;
			}
		}
		calcAmount();
	});
	
	calcAmount();
});

function calcAmount() {
	var originTotalprice = 0;
	var salePrice = 0;
	var totalPrice = 0;
	
	for(var cnt = 0; cnt < cartInfo.length; cnt++) {
		if(cartInfo[cnt].chk == true) {
			originTotalprice += Number(cartInfo[cnt].origin_amount);
			totalPrice += Number(cartInfo[cnt].purchs_amount);
		}
	}
	salePrice = originTotalprice - totalPrice;
	
	$("#originTotalprice").text(numberWithCommas(originTotalprice));
	$("#salePrice").text(numberWithCommas(salePrice));
	$("#totalPrice").text(numberWithCommas(totalPrice));
}

function chkClick(obj, cart_sn) {
	var isCheck = $(obj).prop("checked");
	for(var cnt = 0; cnt < cartInfo.length; cnt++) {
		if(cartInfo[cnt].cart_sn == cart_sn)
			cartInfo[cnt].chk = isCheck;
	}
	$("input[name='chkCart_m']").each(function () {
		if($(this).val() == cart_sn)
			$(this).prop("checked", isCheck);
	});
	$("input[name='chkCart']").each(function () {
		if($(this).val() == cart_sn)
			$(this).prop("checked", isCheck);
	});

	calcAmount();
}

function delCartSingle(cart_sn) {
	var lst = [];
	lst.push(cart_sn);
	delCart(lst);
}

function delCartAll() {
	var lst = [];
	for(var cnt = 0; cnt < cartInfo.length; cnt++) {
		if(cartInfo[cnt].chk == true)
			lst.push(cartInfo[cnt].cart_sn);
	}

	if(lst.length == 0) {
		alert("삭제 건이 없습니다.");
		return;
	}
	delCart(lst);
}

function delCart(cart_sn) {
	var url = "<c:url value='/cart/delAction'/>";
	var param = {};
	param.cart_sn = cart_sn;
	
	if(!confirm("정말 삭제하겠습니까?"))
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

function paymentCart() {
	var lst = "";
	var lstJson = [];
	var today = getToday();

	for(var cnt = 0; cnt < cartInfo.length; cnt++) {
		if(cartInfo[cnt].chk == true) {
			if(cartInfo[cnt].tour_de == "") {
				if(cartInfo[cnt].chkin_de < today) {
					alert("예약일자가 지난 상품은 결제할 수 없습니다.");
					return;
				}
			} else {
				if(cartInfo[cnt].tour_de < today) {
					alert("예약일자가 지난 상품은 결제할 수 없습니다.");
					return;
				}
			}
			lst += cartInfo[cnt].cart_sn + ",";
			lstJson.push( { "cart_sn" : cartInfo[cnt].cart_sn })
		}
	}

	if(lst == "") {
		alert("선택 건이 없습니다.");
		return;
	}
	
	lst = lst.substr(0, lst.length - 1);

	if(!confirm("결제하겠습니까?"))
		return;
	
	var param = {};
	param.lstCart = lstJson;

	url = "<c:url value='/purchs/checkReservationScheduleFlight'/>";
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				url = "<c:url value='/purchs/Order'/>";
				var frm = $("#frm");
				$(frm).find("#lstCart").val(lst);
				$(frm).attr("method", "post");
				$(frm).attr("action", url);
				$(frm).submit();
			} else if(data.result == "-2") {
				alert("로그인이 필요합니다.");
				go_login();
			} else if(data.result == "9") {
				alert(data.message);
			} else if(data.result == "2") {
				alert(data.message);
			} else if(data.result == "3") {
				alert(data.message);
				$.featherlight('/cmmn/popupFlight?callback=inputFlightCart', {});
			} else if(data.result == "4") {
				alert(data.message);
				go_cartpage();
			} else{
				alert("작업을 실패하였습니다.");
			}	        	
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});				
}

function inputFlightCart(flight_sn) {
	var param = {};
	param.flight_sn = flight_sn;
	
	url = "<c:url value='/purchs/setFlightCart'/>";
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
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

function addWish() {
	var lst = [];
	
	for(var cnt = 0; cnt < cartInfo.length; cnt++) {
		if(cartInfo[cnt].chk == true) {
			lst.push( cartInfo[cnt].goods_code );
		}
	}

	if(lst.length == 0) {
		alert("찜하기 건이 없습니다.");
		return;
	}

	var url = "<c:url value='/purchs/insertWish'/>";
	var param = {};
	param.goods_code = lst;
	
	if(!confirm("해당 삼품을 찜하겠습니까?"))
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
				alert("찜하였습니다.");
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

function orderInfo() {
	var lst = "";

	for(var cnt = 0; cnt < cartInfo.length; cnt++) {
		if(cartInfo[cnt].chk == true) {
			lst += cartInfo[cnt].cart_sn + ",";
		}
	}

	if(lst == "") {
		alert("선택 건이 없습니다.");
		return;
	}
	
	lst = lst.substr(0, lst.length - 1);
	
	window.open("<c:url value='/purchs/OrderInfo'/>?cart_sn=" + lst);
}

function numberWithCommas(x) {
	if(x == null)
		return "";
	else
    	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function getToday() {
	var d = new Date();
	return String(d.getFullYear()) + lpad(String(d.getMonth() + 1), 2, "0") + lpad(String(d.getDate()), 2, "0");
}

function lpad(s, padLength, padString){
	 
    while(s.length < padLength)
        s = padString + s;
    return s;
}

</script>
</head>

<body>

<form id="frm">
	<input type="hidden" id="lstCart" name="lstCart" >
</form>

<!-- 본문 -->
<div id="container">
  <div class="inner2">

  <div class="top_title_com">
    <div class="title">
      <div class="text1"><em>예약목록</em>(장바구니)</div>
      <div class="text3">장바구니에 담겨진 상품을 확인하실 수 있습니다.<br />
        </div>
    </div>

  </div>
  <div class="tb_05_box">
    <table width="100%" class="tb_06" >
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
			<td ><input type="checkbox" name="chkCart" value="${result.CART_SN}" onclick="chkClick(this, '${result.CART_SN}');" /><input type="hidden" name="purchs_amount" value="${result.PURCHS_AMOUNT}"><input type="hidden" name="goods_code" value="${result.GOODS_CODE}"></td>
			<td class="left"><div class="cart_img" style="background: url(<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}); background-size: cover; "></div></td>
			<td  class="t_left">
				<div class="cart_pro_text">
					<div class="title">${result.GOODS_NM}
						<c:if test="${result.WAITRESERVATION_YN == 'Y'}">
							<c:if test="${result.STATUS == 'C'}">
								(예약 확정)
							</c:if>
							<c:if test="${result.STATUS == 'W'}">
								(예약 대기)
							</c:if>
						</c:if>
						<br />
						<c:if test="${!empty result.TOUR_DE}">
							${fn:substring(result.TOUR_DE,0,4)}년 ${fn:substring(result.TOUR_DE,4,6)}월 ${fn:substring(result.TOUR_DE,6,8)}일
						</c:if>
						<c:if test="${!empty result.CHKIN_DE}">
							${fn:substring(result.CHKIN_DE,0,4)}년 ${fn:substring(result.CHKIN_DE,4,6)}월 ${fn:substring(result.CHKIN_DE,6,8)}일 ~ ${fn:substring(result.CHCKT_DE,0,4)}년 ${fn:substring(result.CHCKT_DE,4,6)}월 ${fn:substring(result.CHCKT_DE,6,8)}일
						</c:if>
						<br />
					</div>		
					<c:if test="${result.CL_SE ne 'S' && result.CL_SE ne 'T' && result.CL_SE ne 'M'}">
						<div class="text1">${fn:substring(result.BEGIN_TIME,0,2)}시 ${fn:substring(result.BEGIN_TIME,2,4)}분 ~ ${fn:substring(result.END_TIME,0,2)}시 ${fn:substring(result.END_TIME,2,4)}분</div>
					</c:if>
					<c:if test="${result.CL_SE eq 'S'}">
						<c:forEach var="options" items="${result.OPTIONS}" varStatus="status">
							<div class="text1">${options.SETUP_NM} ${options.NMPR_CND} ${options.NMPR_CO}${options.UNIT_NM}</div>
						</c:forEach>
					</c:if>				
					<c:if test="${result.CL_SE ne 'S'}">
						<c:forEach var="options" items="${result.OPTIONS}" varStatus="status">
							<div class="text1">${options.NMPR_CND} ${options.NMPR_CO}${options.UNIT_NM}</div>
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
	  <!--모바일-->
	  <c:forEach var="result" items="${cartList}" varStatus="status">
	  <div class="cart_list_box" style="height:130px;">
	  	<div class="img"><div class="cart_img" style="background: url('<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}'); background-size: cover; "></div></div>
	  	<div class="title">${result.GOODS_NM}<br />
				<c:if test="${!empty result.TOUR_DE}">
					${fn:substring(result.TOUR_DE,0,4)}.${fn:substring(result.TOUR_DE,4,6)}.${fn:substring(result.TOUR_DE,6,8)}
				</c:if>
				<c:if test="${!empty result.CHKIN_DE}">
					${fn:substring(result.CHKIN_DE,0,4)}.${fn:substring(result.CHKIN_DE,4,6)}.${fn:substring(result.CHKIN_DE,6,8)}~${fn:substring(result.CHCKT_DE,0,4)}.${fn:substring(result.CHCKT_DE,4,6)}.${fn:substring(result.CHCKT_DE,6,8)}
				</c:if>  	
				<c:if test="${result.CL_SE ne 'S' && result.CL_SE ne 'T' && result.CL_SE ne 'M'}">
					<div class="text1">${fn:substring(result.BEGIN_TIME,0,2)}:${fn:substring(result.BEGIN_TIME,2,4)} ~ ${fn:substring(result.END_TIME,0,2)}:${fn:substring(result.END_TIME,2,4)}</div>
				</c:if>
				<c:if test="${result.CL_SE eq 'S'}">
					<c:forEach var="options" items="${result.OPTIONS}" varStatus="status">
						<div class="text1">${options.SETUP_NM} ${options.NMPR_CND} ${options.NMPR_CO}${options.UNIT_NM}</div>
					</c:forEach>
				</c:if>
				<c:if test="${result.CL_SE ne 'S'}">
					<c:forEach var="options" items="${result.OPTIONS}" varStatus="status">
						<div class="text1">${options.NMPR_CND} ${options.NMPR_CO}${options.UNIT_NM}</div>
					</c:forEach>
				</c:if>					
	  	</div>
	  	<div class="op"></div>
	  	<div class="um"></div>
	  	<div class="sale">할인 <fmt:formatNumber value="${result.ORIGIN_AMOUNT - result.PURCHS_AMOUNT}" pattern="#,###" />원</div>
	    <div class="total" style="top:90px;">구매예정가 <em><fmt:formatNumber value="${result.PURCHS_AMOUNT}" pattern="#,###" /></em>원</div>
	  	<div class="del"> <a href="javascript:delCartSingle('${result.CART_SN}');" class="sbtn_01">삭제</a></div>
	  	<div style="position:absolute; right:5px; top:30px;"><input type="checkbox" name="chkCart_m" value="${result.CART_SN}" onclick="chkClick(this, '${result.CART_SN}');"/><input type="hidden" name="purchs_amount" value="${result.PURCHS_AMOUNT}"><input type="hidden" name="goods_code" value="${result.GOODS_CODE}"></div>	  	
	  </div>	  
	  </c:forEach>
	<!--//모바일-->    
  </div>
  <div class="sp_30"></div>
  <div class="cart_total">
    <div class="inbox">
      <div class="title">총  주문 금액 </div>
      <div class="price_box">
        <div class="text1">
          <div class="t1">총 상품금액<br />
            <em><label id="originTotalprice"></label></em>원</div>
        </div>
        <div class="text2"><i class="material-icons">&#xE15C;</i></div>
        <div class="text1">
          <div class="t2">총 할인금액<br />
            <em><label id="salePrice"></label></em>원</div>
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
            <em><label id="totalPrice"></label></em>원</div>
        </div>
      </div>
    </div>
  </div>
  <div class="cart_btn">
    <div class="left_btn">
      <div class="btn1"><a href="javascript:addWish();">선택상품찜하기담기</a></div>
      <div class="btn2"><a href="javascript:delCartAll();">선택상품삭제</a></div>
      <!-- <div class="btn2"><a href="#">품절상품삭제</a></div> -->
    </div>
    <div class="right_btn">
      <div class="btn3"><a href="javascript:paymentCart();">선택상품 결제하기</a></div>
      <div class="btn2"><a href="javascript:orderInfo();">일정표미리보기</a></div>
    </div>
  </div>
  <!--//컨텐츠영역 -->
    	<div class="sp_50"></div>
  </div>
</div>

<!-- //본문 -->
        
</body>