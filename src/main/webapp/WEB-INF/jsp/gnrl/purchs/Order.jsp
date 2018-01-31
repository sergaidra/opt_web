<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
	<!-- 이니시스 표준결제 js -->
  <!--
    연동시 유의 사항!!
    1) 테스트 URL(stgstdpay.inicis.com) - 샘플에 제공된 테스트 MID 전용으로 실제 가맹점 MID 사용 시 에러가 발생 할 수 있습니다.
    2) 상용 URL(stdpay.inicis.com) - 실제 가맹점 MID 로 테스트 및 오픈 시 해당 URL 변경하여 사용합니다.
    3) 가맹점의 URL이 http: 인경우 js URL도 https://stgstdpay.inicis.com/stdjs/INIStdPay.js 로 변경합니다.	
    4) 가맹점에서 사용하는 케릭터셋이 EUC-KR 일 경우 charset="UTF-8"로 UTF-8 일 경우 charset="UTF-8"로 설정합니다.
  -->	
  
  <!-- 상용 JS(가맹점 MID 변경 시 주석 해제, 테스트용 JS 주석 처리 필수!) -->
	<script language="javascript" type="text/javascript" src="https://${inicis_subdomain}.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script>
  
  <!-- 테스트 JS(샘플에 제공된 테스트 MID 전용) -->
	<!--script language="javascript" type="text/javascript" src="https://stgstdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script-->

<script type="text/javascript">
var real_setle_amount = 0;
var use_point = 0;
var total_point = Number("${point}");

$(function() {
	$(".order_detailinput").each(function () {
		var purchs_amount = $(this).find("#purchs_amount").val();
		real_setle_amount += Number(purchs_amount);
	});	
});

function addAction() {
	var lst = [];
	var totalAmount = 0;
	
	var tourist_nm = "";
	var tourist_cttpc = "";
	var kakao_id = "";
	
	if($.trim($("#tourist_nm").val()) == "") {
		alert("대표여행자 이름을 입력해 주세요.");
		$("#tourist_nm").focus();
		return;
	}
	tourist_nm = $.trim($("#tourist_nm").val());
	
	if($.trim($("#tourist_cttpc2").val()) == "" || $.trim($("#tourist_cttpc3").val()) == "") {
		alert("연락처를 입력해 주세요.");
		$("#tourist_nm").focus();
		return;
	}
	tourist_cttpc = $.trim($("#tourist_cttpc1").val()) + "-" + $.trim($("#tourist_cttpc2").val()) + "-" + $.trim($("#tourist_cttpc3").val());
	kakao_id = $.trim($("#kakao_id").val());
	
	var isOk = true;
	$(".order_detailinput").each(function () {
		var cart_sn = $(this).find("#cart_sn").val();
		var purchs_amount = $(this).find("#purchs_amount").val();
		var pickup_place = "";
		var drop_place = "";
		var use_nmpr = "";
		var use_pd = "";
		
		if($(this).find("#pickup_place").length > 0) {
			if($.trim($(this).find("#pickup_place").val()) == "") {
				alert("픽업장소를 입력해 주세요.");
				isOk = false;
				return false;
			}
			pickup_place = $.trim($(this).find("#pickup_place").val())
		}
		if($(this).find("#drop_place").length > 0) {
			if($.trim($(this).find("#drop_place").val()) == "") {
				alert("드랍장소를 입력해 주세요.");
				isOk = false;
				return false;
			}
			drop_place = $.trim($(this).find("#drop_place").val())
		}
		if($(this).find("#use_nmpr").length > 0) {
			if($.trim($(this).find("#use_nmpr").val()) == "") {
				alert("이용 인원을 입력해 주세요.");
				isOk = false;
				return false;
			}
			use_nmpr = $.trim($(this).find("#use_nmpr").val())
		}
		if($(this).find("#use_pd").length > 0) {
			if($.trim($(this).find("#use_pd").val()) == "") {
				alert("이용 기간을 입력해 주세요.");
				isOk = false;
				return false;
			}
			use_pd = $.trim($(this).find("#use_pd").val())
		}
		
		lst.push( {"cart_sn" : cart_sn, "pickup_place" : pickup_place, "drop_place" : drop_place, "use_nmpr" : use_nmpr, "use_pd" : use_pd } );
		totalAmount += Number(purchs_amount);
	});

	if(isOk == false)
		return;
	if(lst.length == 0) {
		alert("선택 건이 없습니다.");
		return;
	}
	
	if(!confirm("결제하겠습니까?"))
		return;
	
	var param = {};
	param.tot_setle_amount = totalAmount;
	param.real_setle_amount = real_setle_amount - use_point;
	param.use_point = use_point;
	param.lstCart = lst;
	param.tourist_nm = tourist_nm;
	param.tourist_cttpc = tourist_cttpc;
	param.kakao_id = kakao_id;

	var url = "<c:url value='/purchs/checkReservationSchedule'/>";
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				if(param.real_setle_amount == 0) {
					// 결제금액이 0원인경우			
					var url = "<c:url value='/purchs/addAction'/>";
					$.ajax({
				        url : url,
				        type: "post",
				        dataType : "json",
				        async: "true",
				        contentType: "application/json; charset=utf-8",
				        data : JSON.stringify( param ),
				        success : function(data,status,request){
							if(data.result == "0") {
								document.location.href = "/purchs/OrderDetail?purchs_sn=" + data.data;
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
				} else {
					getSignature(param);
				}
			} else if(data.result == "-2") {
				alert("로그인이 필요합니다.");
				go_login();
			} else if(data.result == "9") {
				alert(data.message);
			} else if(data.result == "2") {
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

function getSignature(param) {
	var v_param = {};
	v_param.oid = "${oid}";
	v_param.price = param.real_setle_amount;
	//Test
	if("${inicis_mode}" == "Test")
		v_param.price = 150;
	v_param.timestamp = "${timestamp}";
	
	var url = "<c:url value='/purchs/getSignature'/>";
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( v_param ),
        success : function(data,status,request){
			if(data.result == "0") {
				var merchantData = encodeURI(JSON.stringify( param ));
				// Test
				$("#SendPayForm_id").find("input[name='price']").val(param.real_setle_amount);
				$("#mobileweb_form").find("input[name='P_AMT']").val(param.real_setle_amount);				
				if("${inicis_mode}" == "Test") {
					$("#SendPayForm_id").find("input[name='price']").val("150");
					$("#mobileweb_form").find("input[name='P_AMT']").val("150");
				}
				$("#SendPayForm_id").find("input[name='signature']").val(data.data);
				$("#SendPayForm_id").find("input[name='merchantData']").val(merchantData);
				
				var returnUrl = location.protocol + "//" + location.host + "/purchs/payComplete";
				var closeUrl = location.protocol + "//" + location.host + "/purchs/close";
				var nextUrl = location.protocol + "//" + location.host + "/purchs/payNext";	// 모바일 신용카드
				$("#SendPayForm_id").find("input[name='returnUrl']").val(returnUrl);
				$("#SendPayForm_id").find("input[name='closeUrl']").val(closeUrl);
				$("#SendPayForm_id").find("input[name='gopaymethod']").val($(":input:radio[name=rdoPayMethod]:checked").val());
				
				var gopaymethod = $("#SendPayForm_id").find("input[name='gopaymethod']").val();
				if(gopaymethod == "Card") {
					$("#SendPayForm_id").find("input[name='acceptmethod']").val("below1000:CARDPOINT");
				} else if(gopaymethod == "VBank") {
					// 기한을 하루 뒤로 설정
					var tomorrow = new Date();
					tomorrow.setDate(tomorrow.getDate() + 1);
					var vbankdate = String(tomorrow.getFullYear()) + lpad(String(tomorrow.getMonth() + 1), 2, "0") + lpad(String(tomorrow.getDate()), 2, "0");
					vbankdate += lpad(String(tomorrow.getHours()), 2, "0") + lpad(String(tomorrow.getMinutes()), 2, "0");

					$("#SendPayForm_id").find("input[name='acceptmethod']").val("vbank(" + vbankdate + ")");
				} else {
					$("#SendPayForm_id").find("input[name='acceptmethod']").val("");
				}
				
				if(false) {
					INIStdPay.pay('SendPayForm_id');
				} else {
					var myform = $("#mobileweb_form");
					if(gopaymethod == "Card") {
						$(myform).attr("action", "https://mobile.inicis.com/smart/wcard/");
					} else if(gopaymethod == "VBank") {
						$(myform).attr("action", "https://mobile.inicis.com/smart/vbank/");
					} else {
						$(myform).attr("action", "https://mobile.inicis.com/smart/bank/");
					}
					
					$("#mobileweb_form").find("input[name='P_NEXT_URL']").val(nextUrl);
					$("#mobileweb_form").find("input[name='P_NOTI']").val(merchantData);
					
					$(myform).attr("target", "_self");
					var p_oid = $(myform).find("input[name='P_OID']").val();
					var p_return_url = $(myform).find("input[name='P_RETURN_URL']").val();
					$(myform).find("input[name='P_RETURN_URL']").val(p_return_url + "?P_OID=" + p_oid); // 계좌이체 결제시 P_RETURN_URL로 P_OID값 전송(GET방식 호출)
					$(myform).submit(); 
				}
				//alert("결제되었습니다.");
				//go_mypage();
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
	if("${purchs_sn}" == "") 
		window.open("<c:url value='/purchs/OrderInfo'/>?cart_sn=${cart_sn}");
	else
		window.open("<c:url value='/purchs/OrderInfo'/>?purchs_sn=${purchs_sn}");
}

function orderCancel() {
	if("${purchs.ISCANCEL}" == "Y")
		$.featherlight('/purchs/popupCancel?purchs_sn=${purchs_sn}' + '&callback=saveComplete', {});
	else {
		alert("14일 이내에는 취소할 수 없습니다.");
		return;
	}
}

function viewPoint() {
	$.featherlight("/purchs/popupPoint?esntl_id=${esntl_id}&maxpoint=" + real_setle_amount + "&callback=setPoint", {});
}

function setPoint(point) {
	use_point = Number(point);
	$("#txtPoint").val(numberWithCommas(point));
	$("#discountAmount").text('-'+numberWithCommas(point));
	setAmount();
}

function allPointUse(obj) {
	var point = 0;
	if(total_point > real_setle_amount)
		point = real_setle_amount;
	else
		point = total_point;
	use_point = Number(point);
	$("#txtPoint").val(numberWithCommas(point));
	setAmount();
	$(obj).prop('checked', false); 
}

function setAmount() {
	$("#finalAmount").text(numberWithCommas(real_setle_amount - use_point));
}

function lpad(s, padLength, padString){
	 
    while(s.length < padLength)
        s = padString + s;
    return s;
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


</script>
</head>

<body>

<!-- 본문 -->
<div id="container">
  <div class="inner2">
<div class="sp_50"></div>
	<c:if test="${purchs.DELETE_AT == 'Y'}">
		<div class="order_stitle font_st"><i class="material-icons">&#xE5C6;</i>
			<p>취소정보</p>
		</div>
		<div class="tb_04_box">
			<table  class="tb_01">
				<col width="18%" />
				<col width="" />
				<tbody>
					<tr>
						<th >결제취소 구분</th>
						<td >${purchs.DELETE_RESN_SE}</td>
					</tr>
					<tr>
						<th >결제취소 사유</th>
						<td >${purchs.DELETE_RESN_ETC}</td>
					</tr>
				</tbody>
			</table>
		</div>		
		<div class="sp_30"></div>
	</c:if>    

  <div class="order_stitle font_st"><i class="material-icons">&#xE5C6;</i>
    <p>고객정보</p>
  </div>
  <div class="tb_04_box">
    <table  class="tb_01">
      <col width="18%" />
      <col width="" />
      <tbody>
        <tr>
          <th >대표여행자 이름(필수)</th>
          <td >
          	<c:if test="${purchs == null}">
	          	<input name="tourist_nm" type="text" class="input_st01" id="tourist_nm"  style="width:150px" value="${purchs.TOURIST_NM}"/>
          	</c:if>
          	<c:if test="${purchs != null}">
          		${purchs.TOURIST_NM}
          	</c:if>
          </td>
        </tr>
        <tr>
          <th >연락처(필수)</th>
          <td ><!--기본 셀렉트 박스 .w_100p는 사이즈-->
          	<c:if test="${purchs == null}">
	            <select class="w_80px fl" id="tourist_cttpc1" name="tourist_cttpc1">
	              <option <c:if test="${purchs.TOURIST_CTTPC1 == '010'}">selected</c:if>>010</option>
	              <option <c:if test="${purchs.TOURIST_CTTPC1 == '011'}">selected</c:if>>011</option>
	              <option <c:if test="${purchs.TOURIST_CTTPC1 == '016'}">selected</c:if>>016</option>
	              <option <c:if test="${purchs.TOURIST_CTTPC1 == '017'}">selected</c:if>>017</option>
	              <option <c:if test="${purchs.TOURIST_CTTPC1 == '018'}">selected</c:if>>018</option>
	              <option <c:if test="${purchs.TOURIST_CTTPC1 == '019'}">selected</c:if>>019</option>
	            </select>
	            <!--//기본 셀렉트 박스 -->
	            <input name="tourist_cttpc2" type="text" class="input_st01 fl ml_10" id="tourist_cttpc2"  style="width:70px" value="${purchs.TOURIST_CTTPC2}"/>
	            <input name="tourist_cttpc3" type="text" class="input_st01 fl ml_10" id="tourist_cttpc3"  style="width:70px" value="${purchs.TOURIST_CTTPC3}"/>
            </c:if>
          	<c:if test="${purchs != null}">
          		${purchs.TOURIST_CTTPC}
          	</c:if>
          	</td>
          </tr>
        <tr>
          <th>카카오ID</th>
          <td > <!--기본 셀렉트 박스 .w_100p는 사이즈-->
          	<c:if test="${purchs == null}">
            	<input name="kakao_id" type="text" class="input_st01 fl" id="kakao_id"  style="width:150px" value="${purchs.KAKAO_ID}"/>
            </c:if>
          	<c:if test="${purchs != null}">
          		${purchs.KAKAO_ID}
          	</c:if>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
 <!-- <div class="order_text_r">
    <div class="stext"><p> 위내용을 수정하시려면 수정버튼을 눌러주세요</p><a href="#" class="btn">회원정보 변경</a></div>
  </div>-->

  <div class="sp_30"></div>
  <div class="order_stitle"><i class="material-icons">&#xE5C6;</i>
    <p>세부입력정보</p>
  </div>
  <c:set var="purchs_amount" value="0" />
  <c:set var="origin_amount" value="0" />
  <c:set var="purchs_goods_nm" value="" />
  <div class="order_detail_box">
	  <c:forEach var="item" items="${lstCart}" varStatus="statusCart">
	  	<c:if test="${statusCart.index == 0}">
			<c:set var="purchs_goods_nm" value="${item.GOODS_NM}" />
	  	</c:if>
	  	<c:set var="nmpr_setup_se_V" value="0"/>
		<div class="order_detailinput">
			<input type="hidden" id="cart_sn" name="cart_sn" value="${item.CART_SN}"/>
			<input type="hidden" id="purchs_amount" name="purchs_amount" value="${item.PURCHS_AMOUNT}"/>
			<input type="hidden" id="goods_code" name="goods_code" value="${item.GOODS_CODE}"/>
			<input type="hidden" id="origin_amount" name="origin_amount" value="${item.ORIGIN_AMOUNT}"/>
			<c:set var="purchs_amount" value="${purchs_amount + item.PURCHS_AMOUNT}" />
			<c:set var="origin_amount" value="${origin_amount + item.ORIGIN_AMOUNT}" />
			<div class="pro_info">
				<div class="photo">
					<div class="img" style="background: url(<c:url value='/file/getImage/'/>?file_code=${item.FILE_CODE});)"></div>
				</div>
				<div class="text_box">
					<div class="tx1">
						${item.GOODS_DATE}
					</div>
					<div class="tx2">${item.GOODS_NM}</div>
					<div class="tx3">
						<c:if test="${item.GOODS_TIME != null}">
							${item.GOODS_TIME}<br/>
						</c:if>
						${item.GOODS_OPTION}
					</div>					
					<div class="tx4"><em><fmt:formatNumber value="${item.ORIGIN_AMOUNT}" pattern="#,###" /></em>원  </div>
				</div>
			</div>	
          	<c:if test="${purchs == null}">
			<c:if test="${item.SETUP_SE_V eq 'Y' or item.CL_SE eq 'P' or item.CL_SE eq 'M' or item.PICKUP_INCLS_AT eq 'Y'}" >
				<div class="input_box">
					<div class="title"><i class="material-icons">&#xE5DB;</i><p>추가 입력사항</p></div>
					<input name="pickup_place" type="text" class="fl mb_5" id="pickup_place" placeholder="픽업장소를 입력해 주세요 " value="${item.PICKUP_PLACE}" />
					
					<c:if test="${item.CL_SE ne 'M'}">
						<input name="drop_place" type="text" class="fr mb_5" id="drop_place" placeholder="드랍장소를 입력해 주세요 " value="${item.DROP_PLACE}" />
					</c:if>
					<c:if test="${item.PICKUP_INCLS_AT eq 'Y'}" >
						<input name="use_nmpr" type="text" class=" fl mb_5" id="use_nmpr" placeholder="이용 인원을 입력해 주세요  (성인1명 / 아동 0명 / 유아 0명)"  value="${item.USE_NMPR}"/>               
		                <input name="use_pd" type="text" class=" fr" id="use_pd" placeholder="이용 기간을 입력해 주세요 " value="${item.USE_PD}" />
					</c:if>
				</div>			
			</c:if>
			</c:if>
          	<c:if test="${purchs != null}">
			<c:if test="${item.SETUP_SE_V eq 'Y' or item.CL_SE eq 'P' or item.CL_SE eq 'M' or item.PICKUP_INCLS_AT eq 'Y'}" >
				<div class="input_box">
					<div class="title"><i class="material-icons">&#xE5DB;</i><p>추가 입력사항</p></div>
					픽업장소 : ${item.PICKUP_PLACE}<br/>
					
					<c:if test="${item.CL_SE ne 'M'}">
						드랍장소 : ${item.DROP_PLACE}<br/>
					</c:if>
					<c:if test="${item.PICKUP_INCLS_AT eq 'Y'}" >
						이용인원 : ${item.USE_NMPR}<br/>
						이용기간 : ${item.USE_PD}<br/>
					</c:if>
				</div>			
			</c:if>
			</c:if>
    	</div>
	  </c:forEach>
    
  <!-- 
    <div class="order_detailinput">
      <div class="pro_info">
        <div class="photo">
          <div class="img" style="background: url(../../../images/sub/ex1.jpg)"></div>
        </div>
	    <div class="text_box">
	      <div class="tx1">2017.08.08~2017.08.08</div>
			<div class="tx2">데얼 세부 선셋 호핑투어</div>
			<div class="tx3">옵션 : 선택옵션없음<br>
인원 : 성인1명 / 아동 0명 / 유아 0명</div>
			<div class="tx4"><em>193,000</em>원  </div>
	    </div>
      </div>

	
    </div>
	  <div class="order_detailinput">
      <div class="pro_info">
        <div class="photo">
          <div class="img" style="background: url(../../../images/sub/ex1.jpg)"></div>
        </div>
	    <div class="text_box">
	      <div class="tx1">2017.08.08~2017.08.08</div>
			<div class="tx2">데얼 세부 선셋 호핑투어</div>
			<div class="tx3">옵션 : 선택옵션없음<br>
인원 : 성인1명 / 아동 0명 / 유아 0명</div>
			<div class="tx4"><em>193,000</em>원  </div>
	    </div>
      </div>
	  <div class="input_box">
	    <div class="title"><i class="material-icons">&#xE5DB;</i><p>추가 입력사항</p></div>	
	  
		  <input name="textfield3" type="text" class="fl mb_5" id="textfield3" placeholder="픽업장소를 입력해 주세요 " />
					<input name="textfield6" type="text" class="fr mb_5" id="textfield6" placeholder="드랍장소를 입력해 주세요 " />
					<input name="textfield8" type="text" class=" fl mb_5" id="textfield8" placeholder="인원입력해 주세요  (성인1명 / 아동 0명 / 유아 0명)" />               
                  <input name="textfield7" type="text" class=" fr" id="textfield7" placeholder="인원입력 " /></div>
		
    </div>
	  <div class="order_detailinput">
      <div class="pro_info">
        <div class="photo">
          <div class="img" style="background: url(../../../images/sub/ex1.jpg)"></div>
        </div>
	    <div class="text_box">
	      <div class="tx1">2017.08.08~2017.08.08</div>
			<div class="tx2">3박5일 “시장-체험다이빙-호핑-굿바이” 맞춤투어</div>
			<div class="tx3">옵션 : 선택옵션없음<br>
인원 : 막탄지역 픽/드랍 서비스 추가 별도<br>
인원 : 성인1명 / 아동 0명 / 유아 0명<br>
인원 : 성인1명 / 아동 0명 / 유아 0명</div>
			<div class="tx4"><em>193,000</em>원  </div>
	    </div>
      </div>
	  <div class="input_box">
	    <div class="title"><i class="material-icons">&#xE5DB;</i><p>추가 입력사항</p></div>	
	  
		  <input name="textfield3" type="text" class="fl mb_5" id="textfield3" placeholder="픽업장소를 입력해 주세요 " />
                  <input name="textfield7" type="text" class=" fr" id="textfield7" placeholder="인원입력 " /></div>
		
    </div>	
	
	  	 -->
	
	  </div>
<div class="tb_box"></div>
  <div class="sp_50"></div>
  <div class="order_left">
    <div class="order_stitle"><i class="material-icons">&#xE5C6;</i>
   	<c:if test="${purchs != null}">
      <p>포인트</p>
   	</c:if>
   	<c:if test="${purchs == null}">
      <p>포인트 사용하기</p>
   	</c:if>
    </div>
    <div class="tb_04_box">
      <table  class="tb_01">
        <col width="15%" />
        <col width="" />
        <col width="35%" />
        <tbody>
          <tr>
		   	<c:if test="${purchs != null}">
            <th >사용 포인트</th>
            <td colspan="2"><div class="order_font1"> <fmt:formatNumber value="${purchs.USE_POINT}" pattern="#,###" /> P </div></td>            
		   	</c:if>
		   	<c:if test="${purchs == null}">
            <th >포인트</th>
            <td ><div class="order_font1"> <fmt:formatNumber value="${point}" pattern="#,###" /> P </div>
              <div class="order_ch"><input type="checkbox" onclick="allPointUse(this);"> </div>
			  <div class="order_font2"> 전액사용</div>
			  </td>
            <td ><input name="textfield" type="text" class="input_stst fl w_50p" id="txtPoint"   value="0" readonly/>
              <a href="javascript:viewPoint();" class="order_tb_btn fl">포인트  </a></td>
		   	</c:if>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="sp_30"></div>

   	<c:if test="${purchs != null && pay != null}">
      <div class="order_stitle"><i class="material-icons">&#xE5C6;</i>
        <p>결제 정보</p>
      </div>
		<div class="tb_04_box">
		<table  class="tb_01">
			<col width="18%" />
			<col width="" />
			<tbody>
			<tr>
				<th>결제상태</th>
				<td>
					<c:if test="${purchs.STATUS == 'C'}">결제 완료</c:if>				
					<c:if test="${purchs.STATUS == 'W'}">무통장입금 대기</c:if>				
					<c:if test="${purchs.STATUS == 'R'}">환불</c:if>				
				</td>
			</tr>
			<tr>
				<th>결제수단</th>
				<td>
					<c:if test="${pay.PAYMETHOD == 'VCard' or pay.PAYMETHOD == 'Card'}">신용카드</c:if>
					<c:if test="${pay.PAYMETHOD == 'DirectBank'}">실시간 계좌이체</c:if>
					<c:if test="${pay.PAYMETHOD == 'VBank'}">무통장입금</c:if>
				</td>
			</tr>
			<tr><th>결제금액</th><td><fmt:formatNumber value="${pay.TOTPRICE}" pattern="#,###" /> 원</td></tr>
			<tr><th>거래번호</th><td>${pay.TID}</td></tr>
			<tr><th>승인일자</th><td>${pay.APPLDATE}</td></tr>
			<tr><th>승인시간</th><td>${pay.APPLTIME}</td></tr>
			<c:if test="${pay.PAYMETHOD == 'VCard' or pay.PAYMETHOD == 'Card'}">
			<tr><th>신용카드번호</th><td>${pay.CARD_NUM}</td></tr>
			<tr>
				<th>카드 종류</th>
				<td>
					<c:if test="${pay.CARD_CODE == '01'}">하나(외환)</c:if>				
					<c:if test="${pay.CARD_CODE == '03'}">롯데</c:if>				
					<c:if test="${pay.CARD_CODE == '04'}">현대</c:if>				
					<c:if test="${pay.CARD_CODE == '06'}">국민</c:if>				
					<c:if test="${pay.CARD_CODE == '11'}">BC</c:if>				
					<c:if test="${pay.CARD_CODE == '12'}">삼성</c:if>				
					<c:if test="${pay.CARD_CODE == '14'}">신한</c:if>				
					<c:if test="${pay.CARD_CODE == '21'}">해외 VISA</c:if>				
					<c:if test="${pay.CARD_CODE == '22'}">해외마스터</c:if>				
					<c:if test="${pay.CARD_CODE == '23'}">해외 JCB</c:if>				
					<c:if test="${pay.CARD_CODE == '26'}">중국은련</c:if>				
					<c:if test="${pay.CARD_CODE == '32'}">광주</c:if>				
					<c:if test="${pay.CARD_CODE == '33'}">전북</c:if>				
					<c:if test="${pay.CARD_CODE == '34'}">하나</c:if>				
					<c:if test="${pay.CARD_CODE == '35'}">산업카드</c:if>				
					<c:if test="${pay.CARD_CODE == '41'}">NH</c:if>				
					<c:if test="${pay.CARD_CODE == '43'}">씨티</c:if>				
					<c:if test="${pay.CARD_CODE == '44'}">우리</c:if>				
					<c:if test="${pay.CARD_CODE == '48'}">신협체크</c:if>				
					<c:if test="${pay.CARD_CODE == '51'}">수협</c:if>				
					<c:if test="${pay.CARD_CODE == '52'}">제주</c:if>				
					<c:if test="${pay.CARD_CODE == '54'}">MG새마을금고체크</c:if>				
					<c:if test="${pay.CARD_CODE == '55'}">케이뱅크</c:if>				
					<c:if test="${pay.CARD_CODE == '56'}">카카오뱅크</c:if>				
					<c:if test="${pay.CARD_CODE == '71'}">우체국체크</c:if>				
					<c:if test="${pay.CARD_CODE == '95'}">저축은행체크</c:if>				
				</td>
			</tr>
			<tr>
				<th>카드 발급사</th>
				<td>
					<c:if test="${pay.CARD_BANKCODE == '04'}">국민은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '05'}">하나은행 (구외환)</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '06'}">국민은행 (구 주택)</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '07'}">수협중앙회</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '11'}">농협중앙회</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '12'}">단위농협</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '16'}">축협중앙회</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '20'}">우리은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '21'}">신한은행 (조흥은행)</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '23'}">제일은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '25'}">하나은행 (서울은행)</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '26'}">신한은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '27'}">한국씨티은행 (한미은행)</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '31'}">대구은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '32'}">부산은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '34'}">광주은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '35'}">제주은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '37'}">전북은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '38'}">강원은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '39'}">경남은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '41'}">비씨카드</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '53'}">씨티은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '54'}">홍콩상하이은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '71'}">우체국</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '81'}">하나은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '83'}">평화은행</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '87'}">신세계</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '88'}">신한은행(조흥 통합)</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '97'}">카카오 머니</c:if>			
					<c:if test="${pay.CARD_BANKCODE == '98'}">페이코 (포인트 100% 사용)</c:if>			
				</td>
			</tr>
			</c:if>
			<c:if test="${pay.PAYMETHOD == 'DirectBank'}">
			<tr>
				<th>은행</th>
				<td>
					<c:if test="${pay.ACCT_BANKCODE == '02'}">한국산업은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '03'}">기업은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '04'}">국민은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '05'}">하나은행 (구 외환)</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '06'}">국민은행 (구 주택)</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '07'}">수협중앙회</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '11'}">농협중앙회</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '12'}">단위농협</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '16'}">축협중앙회</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '20'}">우리은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '21'}">구)조흥은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '22'}">상업은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '23'}">SC제일은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '24'}">한일은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '25'}">서울은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '26'}">구)신한은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '27'}">한국씨티은행 (구 한미)</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '31'}">대구은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '32'}">부산은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '34'}">광주은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '35'}">제주은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '37'}">전북은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '38'}">강원은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '39'}">경남은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '41'}">비씨카드</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '45'}">새마을금고</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '48'}">신용협동조합중앙회</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '50'}">상호저축은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '53'}">한국씨티은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '54'}">홍콩상하이은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '55'}">도이치은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '56'}">ABN 암로</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '57'}">JP모건</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '59'}">미쓰비시도쿄은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '60'}">BOA(Bank of America)</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '64'}">산립조합</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '70'}">신안상호저축은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '71'}">우체국</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '81'}">하나은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '83'}">평화은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '87'}">신세계</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == '88'}">신한(통합)은행</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'D1'}">유안타증권(구 동양증권)</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'D2'}">현대증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'D3'}">미래에셋증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'D4'}">한국투자증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'D5'}">우리투자증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'D6'}">하이투자증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'D7'}">HMC 투자증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'D8'}">SK 증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'D9'}">대신증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DA'}">하나대투증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DB'}">굿모닝신한증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DC'}">동부증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DD'}">유진투자증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DE'}">메리츠증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DF'}">신영증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DG'}">대우증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DH'}">삼성증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DI'}">교보증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DJ'}">키움증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DK'}">이트레이드</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DL'}">솔로몬증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DM'}">한화증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DN'}">NH증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DO'}">부국증권</c:if>			
					<c:if test="${pay.ACCT_BANKCODE == 'DP'}">LIG증권</c:if>			
				</td>
			</tr>
			<tr><th>현금영수증 발행 정상여부</th><td>${pay.CSHR_RESULTCODE}</td></tr>
			<tr><th>현금영수증구분</th><td>${pay.CSHR_TYPE}</td></tr>
			</c:if>
			<c:if test="${pay.PAYMETHOD == 'VBank'}">
			<tr><th>입금계좌번호</th><td>${pay.VACT_NUM}</td></tr>
			<tr><th>입금은행명</th><td>${pay.VACTBANKNAME}</td></tr>
			<tr><th>예금주명</th><td>${pay.VACT_NAME}</td></tr>
			<tr><th>송금자명</th><td>${pay.VACT_INPUTNAME}</td></tr>
			<tr><th>송금일자</th><td>${pay.VACT_DATE}</td></tr>
			<tr><th>송금시각</th><td>${pay.VACT_TIME}</td></tr>
			</c:if>
		</tbody>
		</table>
		</div>

   	</c:if>
   	<c:if test="${purchs == null}">
      <div class="order_stitle"><i class="material-icons">&#xE5C6;</i>
        <p>결제 수단 선택</p>
      </div>
      <div class="order_select">
        <div class="inbox">
          <div class="select1">
            <input type="radio" name="rdoPayMethod" id="radio" value="Card" checked />
            신용카드 &nbsp;&nbsp;&nbsp;
            <input type="radio" name="rdoPayMethod" id="radio2" value="DirectBank" />
            실시간 계좌이체&nbsp;&nbsp;&nbsp;
            <input type="radio" name="rdoPayMethod" id="radio3" value="VBank" />
            무통장입금&nbsp;&nbsp;&nbsp;            
		  </div>
		</div> 
      </div>
   	</c:if>

          <!-- 
          <div class="stext">무통장입금</div>
          <div class="div_com">
            <select name="select5" id="select5"  class="w_50p fl">
              <option>은행/계좌를 선택해 주세요 </option>
            </select>
            <div class="text">예금주 :  원패스투어</div>
          </div>
          <div class="stext">입금자</div>
          <div class="div_com">
            <input name="textfield9" type="text" class="input_st01" id="textfield11"  />
          </div>
          <div class="stext">입금예정일</div>
          <div class="div_com"> 2017년 01월 27일까지 미입금 시 자동 취소 처리됩니다. </div>
           -->
          <!-- <div class="stext">환불계좌정보</div>
          <div class="div_com">
            <div class="tb_04_box">
              <table  class="tb_01">
                <col width="15%" />
                <col width="" />
                <col width="35%" />
                <tbody>
                  <tr>
                    <th >은행명</th>
                    <td class="end"><select name="select5" id="select5" style="width:200px">
                        <option selected="selected">은행을 선택해 주세요</option>
                      </select></td>
                  </tr>
                  <tr>
                    <th >계좌번호</th>
                    <td class="end"><input name="textfield" type="text" class="w_30p" id="textfield"  value="20,000원"/></td>
                  </tr>
                  <tr>
                    <th >예금주</th>
                    <td class="end"><input name="textfield" type="text"  class="w_30p fl"  id="textfield"  value="홍길동"/>
                      <a href="#" class="order_tb_btn fl ">환불계좌정보 저장하기 </a></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>-->
  
  </div>
	<div class="order_right">
		<div class="inbox">
			<div class="title">최종결제금액</div>
			<div class="total_1">
				<div class="t1">
					<div class="left">총 주문금액</div>
					<div class="right"><fmt:formatNumber value="${origin_amount}" pattern="#,###" />원</div>
				</div>
				<div class="t1">
					<div class="left">총 할인금액</div>
					<div class="right"><em id="discountAmount"><fmt:formatNumber value="${purchs_amount - origin_amount}" pattern="#,###" /></em>원</div>
				</div>
			</div>
			<div class="total_2">
				<div class="t1">최종결제금액</div>
	          	<c:if test="${purchs != null}">
				<div class="t2"><em id="finalAmount"><fmt:formatNumber value="${purchs.REAL_SETLE_AMOUNT}" pattern="#,###" /></em>원</div>
				</c:if>
	          	<c:if test="${purchs == null}">
				<div class="t2"><em id="finalAmount"><fmt:formatNumber value="${purchs_amount}" pattern="#,###" /></em>원</div>
				</c:if>
			</div>
			<c:if test="${purchs.DELETE_AT == 'Y'}">
				<div class="total_2">
					<div class="t1">환불금액</div>
					<div class="t2"><em><fmt:formatNumber value="${purchs.REFUND_AMOUNT}" pattern="#,###" /></em>원</div>
				</div>
			</c:if>    
		</div>
    <c:if test="${purchs.DELETE_AT != 'Y'}">
		<div class="btn_sc" onclick="orderInfo();" style="cursor:pointer;">일정표 보기</div>
			<c:if test="${purchs_sn == null}">
				<div class="btn_buy" onclick="addAction();" style="cursor:pointer;">결제하기</div>
			</c:if>    
			<c:if test="${purchs_sn != null}">
				<c:if test="${purchs.ISCANCEL == 'Y'}">
					<div class="btn_buy" onclick="orderCancel();" style="cursor:pointer;">취소하기</div>
				</c:if>
				<c:if test="${purchs.ISCANCEL != 'Y'}">
					<div class="btn_buy" onclick="orderCancel();" style="cursor:not-allowed; background-color:#333;">취소하기</div>
				</c:if>
			</c:if>    
			<!-- <div class="btn_buy" onclick="orderCancel();" style="cursor:pointer;">취소하기</div> -->
		</div>
    </c:if>
  
  <!--//컨텐츠영역 -->
	  	<div class="sp_50"></div>
  </div>
</div>

<!-- //본문 -->

										<form id="SendPayForm_id" name="" method="POST" >
											<input type="hidden" name="version" value="1.0" >
											<input type="hidden" name="mid" value="${mid}" >
											<input type="hidden" name="goodname" value="${purchs_goods_nm}" >
											<input type="hidden" name="oid" value="${oid}" >
											<input type="hidden" name="price" value="" >
											<input type="hidden" name="currency" value="WON" >
											<input type="hidden" name="buyername" value="${user_nm}" >
											<input type="hidden" name="buyertel" value="1" >
											<input type="hidden" name="buyeremail" value="${email}" >
											<input type="hidden" name="timestamp" value="${timestamp}" >
											<input type="hidden" name="signature" value="" >
											<input type="hidden" name="returnUrl" value="" >
											<input type="hidden" name="mKey" value="${mKey}" >
											
											<input type="hidden" name="gopaymethod" value="" >
											<!-- <input type="hidden" name="offerPeriod" value="20181001-20181231" > -->
											<input type="hidden" name="acceptmethod" value="" >

											<input type="hidden" name="languageView" value="" >
											<input type="hidden" name="charset" value="UTF-8" >
											<input type="hidden" name="payViewType" value="overlay" >
											<input type="hidden" name="closeUrl" value="" >
											<input type="hidden" name="popupUrl" value="" >

											<input type="hidden" name="merchantData" value="" >																						
										</form>

			<form id="mobileweb_form" name="ini" method="post" action="" accept-charset="euc-kr">
				<input type="hidden" name="P_OID" id="textfield2" value="${oid}" />
				<input type="hidden" name="P_GOODS" value="${purchs_goods_nm}" id="textfield3" />
				<input type="hidden" name="P_AMT" value="" id="P_AMT" />
				<input type="hidden" name="P_UNAME" value="${user_nm}" id="textfield5"/>
				<!-- <input type="hidden" name="P_MNAME" value="이니시스 쇼핑몰" id="textfield6"/> -->
				<input type="hidden" name="P_MOBILE" id="textfield7" />
				<input type="hidden" name="P_EMAIL" value="${email}" id="textfield8"/>
				<input type="hidden" name="P_MID" value="${mid}"> 
				<input type=hidden name="P_NEXT_URL" value="">
				<input type=hidden name="P_NOTI_URL" value="https://mobile.inicis.com/rnoti/rnoti.php">
				<input type=hidden name="P_RETURN_URL" value="https://mobile.inicis.com/rnoti/rnoti.php">
				<input type=hidden name="P_HPP_METHOD" value="1">
				<input type="hidden" name="P_NOTI" value="">
				<input type="hidden" name="P_RESERVED" value="twotrs_isp=Y&block_isp=Y&twotrs_isp_noti=N&below1000=Y"></td> 
			</form>
</body>
