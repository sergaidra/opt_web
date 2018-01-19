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
	<script language="javascript" type="text/javascript" src="https://stdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script>
  
  <!-- 테스트 JS(샘플에 제공된 테스트 MID 전용) -->
	<!--script language="javascript" type="text/javascript" src="https://stgstdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script-->

<script type="text/javascript">
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
	param.real_setle_amount = totalAmount;
	param.use_point = "0";
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
				getSignature(param);
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
	//v_param.price = 1000;
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
				var merchantData = JSON.stringify( param );
				// Test
				//$("#SendPayForm_id").find("input[name='price']").val("1000");
				$("#SendPayForm_id").find("input[name='price").val(param.real_setle_amount);
				$("#SendPayForm_id").find("input[name='signature']").val(data.data);
				$("#SendPayForm_id").find("input[name='merchantData']").val(merchantData);
				var returnUrl = location.protocol + "//" + location.host + "/purchs/payComplete";
				$("#SendPayForm_id").find("input[name='returnUrl']").val(returnUrl);
				
				INIStdPay.pay('SendPayForm_id');
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
          <td ><input name="tourist_nm" type="text" class="input_st01" id="tourist_nm"  style="width:150px" value="${purchs.TOURIST_NM}"/></td>
        </tr>
        <tr>
          <th >연락처(필수)</th>
          <td ><!--기본 셀렉트 박스 .w_100p는 사이즈-->
            <select class="w_10p fl" id="tourist_cttpc1" name="tourist_cttpc1">
              <option <c:if test="${purchs.TOURIST_CTTPC1 == '010'}">selected</c:if>>010</option>
              <option <c:if test="${purchs.TOURIST_CTTPC1 == '011'}">selected</c:if>>011</option>
              <option <c:if test="${purchs.TOURIST_CTTPC1 == '016'}">selected</c:if>>016</option>
              <option <c:if test="${purchs.TOURIST_CTTPC1 == '017'}">selected</c:if>>017</option>
              <option <c:if test="${purchs.TOURIST_CTTPC1 == '018'}">selected</c:if>>018</option>
              <option <c:if test="${purchs.TOURIST_CTTPC1 == '019'}">selected</c:if>>019</option>
            </select>
            <!--//기본 셀렉트 박스 -->
            <input name="tourist_cttpc2" type="text" class="input_st01 fl ml_10" id="tourist_cttpc2"  style="width:100px" value="${purchs.TOURIST_CTTPC2}"/>
            <input name="tourist_cttpc3" type="text" class="input_st01 fl ml_10" id="tourist_cttpc3"  style="width:100px" value="${purchs.TOURIST_CTTPC3}"/></td>
          </tr>
        <tr>
          <th>카카오ID</th>
          <td > <!--기본 셀렉트 박스 .w_100p는 사이즈-->
            <input name="kakao_id" type="text" class="input_st01 fl" id="kakao_id"  style="width:100px" value="${purchs.KAKAO_ID}"/></td>
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
  <div class="order_detail_box">
	  <c:forEach var="item" items="${lstCart}">
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
						<c:if test="${!empty item.TOUR_DE}">
							${fn:substring(item.TOUR_DE,0,4)}년 ${fn:substring(item.TOUR_DE,4,6)}월 ${fn:substring(item.TOUR_DE,6,8)}일
						</c:if>
						<c:if test="${!empty item.CHKIN_DE}">
							${fn:substring(item.CHKIN_DE,0,4)}년 ${fn:substring(item.CHKIN_DE,4,6)}월 ${fn:substring(item.CHKIN_DE,6,8)}일 ~ ${fn:substring(item.CHCKT_DE,0,4)}년 ${fn:substring(item.CHCKT_DE,4,6)}월 ${fn:substring(item.CHCKT_DE,6,8)}일
						</c:if>
					</div>
					<div class="tx2">${item.GOODS_NM}</div>
					<div class="tx3">
						<c:if test="${item.CL_SE ne 'S'}">
							${fn:substring(item.BEGIN_TIME,0,2)}시 ${fn:substring(item.BEGIN_TIME,2,4)}분 ~ ${fn:substring(item.END_TIME,0,2)}시 ${fn:substring(item.END_TIME,2,4)}분
							<c:forEach var="options" items="${item.OPTIONS}" varStatus="status">
								<br>${options.NMPR_CND} ${options.NMPR_CO}명
								<c:if test="${options.SETUP_SE eq 'V'}"><c:set var="nmpr_setup_se_V" value="1"/></c:if>
							</c:forEach>
						</c:if>					
						<c:if test="${item.CL_SE eq 'S'}">
							<c:forEach var="options" items="${item.OPTIONS}" varStatus="status">
								${options.SETUP_NM} ${options.NMPR_CND}<br>
								<c:if test="${options.SETUP_SE eq 'V'}"><c:set var="nmpr_setup_se_V" value="1"/></c:if>
							</c:forEach>
						</c:if>
					</div>					
					<div class="tx4"><em><fmt:formatNumber value="${item.ORIGIN_AMOUNT}" pattern="#,###" /></em>원  </div>
				</div>
			</div>	
			<c:if test="${nmpr_setup_se_V eq '1' or item.CL_SE eq 'P' or item.PICKUP_INCLS_AT eq 'Y'}" >
				<div class="input_box">
					<div class="title"><i class="material-icons">&#xE5DB;</i><p>추가 입력사항</p></div>
					<input name="pickup_place" type="text" class="fl mb_5" id="pickup_place" placeholder="픽업장소를 입력해 주세요 " value="${item.PICKUP_PLACE}" />
					<input name="drop_place" type="text" class="fr mb_5" id="drop_place" placeholder="드랍장소를 입력해 주세요 " value="${item.DROP_PLACE}" />
					<c:if test="${item.PICKUP_INCLS_AT eq 'Y'}" >
						<input name="use_nmpr" type="text" class=" fl mb_5" id="use_nmpr" placeholder="이용 인원을 입력해 주세요  (성인1명 / 아동 0명 / 유아 0명)"  value="${item.USE_NMPR}"/>               
		                <input name="use_pd" type="text" class=" fr" id="use_pd" placeholder="이용 기간을 입력해 주세요 " value="${item.USE_PD}" />
					</c:if>
				</div>			
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
      <p>쿠폰/적립금 사용하기</p>
    </div>
    <div class="tb_04_box">
      <table  class="tb_01">
        <col width="15%" />
        <col width="" />
        <col width="35%" />
        <tbody>
          <tr>
            <th >할인/쿠폰</th>
            <td class="end"><div class="order_font1"> 쿠폰적용후 결제금액</div></td>
            <td class="end"><select name="select5" id="select5" style="width:200px">
                <option>쿠폰을 선택해 주세요</option>
              </select></td>
          </tr>
          <tr>
            <th >적립금</th>
            <td ><div class="order_font1"> 총 34,000점 </div>
              <div class="order_ch"><input type="checkbox"> </div>
			  <div class="order_font2"> 전액사용</div>
			  </td>
            <td ><input name="textfield" type="text" class="input_stst fl w_50p" id="textfield"   value="20,000원"/>
              <a href="#" class="order_tb_btn fl">적립금  </a></td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="sp_30"></div>

      <div class="order_stitle"><i class="material-icons">&#xE5C6;</i>
        <p>쿠폰/적립금 사용하기</p>
      </div>
      <div class="order_select">
        <div class="inbox">
          <div class="select1">
            <input type="radio" name="radio" id="radio" value="radio" />
            신용카드 &nbsp;&nbsp;&nbsp;
            <input type="radio" name="radio" id="radio2" value="radio" />
            실시간 계좌이체&nbsp;&nbsp;&nbsp;
            <input type="radio" name="radio" id="radio3" value="radio" />
            휴대폰 소액결제&nbsp;&nbsp;&nbsp;
            <input type="radio" name="radio" id="radio3" value="radio" />
            무통장입금&nbsp;&nbsp;&nbsp;
            <input type="radio" name="radio" id="radio3" value="radio" />
          </div>
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
          <div class="div_com"> 2016년 01월 27일 까지미입금 시 자동 취소 처리 됩니다. </div>
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
      </div>
  
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
					<div class="right"><fmt:formatNumber value="${purchs_amount - origin_amount}" pattern="#,###" />원</div>
				</div>
			</div>
			<div class="total_2">
				<div class="t1">최종결제금액</div>
				<div class="t2"><em><fmt:formatNumber value="${purchs_amount}" pattern="#,###" /></em>원</div>
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
											<input type="hidden" name="goodname" value="test" >
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
											<input type="hidden" name="offerPeriod" value="20151001-20151231" >
											<input type="hidden" name="acceptmethod" value="CARDPOINT:HPP(1):no_receipt:va_receipt:vbanknoreg(0):below1000" >

											<input type="hidden" name="languageView" value="" >
											<input type="hidden" name="charset" value="UTF-8" >
											<input type="hidden" name="payViewType" value="overlay" >
											<input type="hidden" name="closeUrl" value="" >
											<input type="hidden" name="popupUrl" value="" >

											<input type="hidden" name="merchantData" value="" >																						
										</form>

</body>
