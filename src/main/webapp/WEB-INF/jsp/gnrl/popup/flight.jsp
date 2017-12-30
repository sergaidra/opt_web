<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!--팝업 : 항공편-->
<div class="lightbox" id="pa_airpopup">
	<input type="hidden" id="flight_sn" name="flight_sn" value="${result.FLIGHT_SN}">
	<input type="hidden" id="callback" value="${callback}" >	
  <div class="popup_com">
    <div class="title">항공편 입력</div>
    <div class="popup_cont">
      <div class="tb_01_box">
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="40%">
          <col width="40%">
          <tbody>
            <tr>
              <th >출국정보</th><th >출발</th><th >도착</th>
            </tr>
            <tr>
              <td>공항</td>
              <td>
              	<select id="DTRMC_START_ARPRT_CODE" name="DTRMC_START_ARPRT_CODE" style="width:100%">
              		<option value="">선택</option>
              		<c:forEach var="list" items="${lstFlight}">
	              		<option value="${list.ARPRT_CODE}" <c:if test="${result.DTRMC_START_ARPRT_CODE == list.ARPRT_CODE}">selected</c:if>>${list.ARPRT_NM}</option>
              		</c:forEach>
              	</select>
              </td>
              <td>
              	<select id="DTRMC_ARVL_ARPRT_CODE" name="DTRMC_ARVL_ARPRT_CODE" style="width:100%">
              		<option value="">선택</option>
              		<c:forEach var="list" items="${lstFlight}">
	              		<option value="${list.ARPRT_CODE}" <c:if test="${result.DTRMC_ARVL_ARPRT_CODE == list.ARPRT_CODE}">selected</c:if>>${list.ARPRT_NM}</option>
              		</c:forEach>
              	</select>
              </td>
            </tr>
            <tr>
              <td>일자</td>
              <td id="outStart">
              	<select name="cmdYear" style="min-width:45%; max-width:100%;">
              		<option value="">=년=</option>
              		<c:forEach var="item" items="${lstYear}">
	              		<option value="${item}" <c:if test="${result.DTRMC_START_YEAR == item}">selected</c:if>>${item}년</option>
              		</c:forEach>
              	</select>
              	<select name="cmdMonth" style="min-width:45%; max-width:100%;">
              		<option value="">=월=</option>
              		<c:forEach var="item" begin="1" end="12">              		
              			<fmt:formatNumber minIntegerDigits="2" var="month" value="${item}" type="number"/>
	              		<option value="${month}" <c:if test="${result.DTRMC_START_MONTH == month}">selected</c:if>>${item}월</option>
              		</c:forEach>
              	</select>
              	<br/>
              	<select name="cmdDay" style="min-width:45%; max-width:100%;">
              		<option value="">=일=</option>
              		<c:forEach var="item" begin="1" end="31">
              			<fmt:formatNumber minIntegerDigits="2" var="day" value="${item}" type="number"/>
	              		<option value="${day}" <c:if test="${result.DTRMC_START_DAY == day}">selected</c:if>>${item}일</option>
              		</c:forEach>
              	</select>
              	<select name="cmdTime" style="min-width:45%; max-width:100%;">
              		<option value="">=시간=</option>
              		<c:forEach var="item" begin="0" end="23">
              			<fmt:formatNumber minIntegerDigits="2" var="hour" value="${item}" type="number"/>
              			<c:set var="hour1" value="${hour}:00" /> 
              			<c:set var="hour2" value="${hour}:30" /> 
	              		<option value="${hour1}" <c:if test="${result.DTRMC_START_TIME == hour1}">selected</c:if>>${item}:00</option>
	              		<option value="${hour2}" <c:if test="${result.DTRMC_START_TIME == hour2}">selected</c:if>>${item}:30</option>
              		</c:forEach>
              	</select>
              </td>
              <td id="outEnd">
              	<select name="cmdYear" style="min-width:45%; max-width:100%;">
              		<option value="">=년=</option>
              		<c:forEach var="item" items="${lstYear}">
	              		<option value="${item}" <c:if test="${result.DTRMC_ARVL_YEAR == item}">selected</c:if>>${item}년</option>
              		</c:forEach>
              	</select>
              	<select name="cmdMonth" style="min-width:45%; max-width:100%;">
              		<option value="">=월=</option>
              		<c:forEach var="item" begin="1" end="12">              		
              			<fmt:formatNumber minIntegerDigits="2" var="month" value="${item}" type="number"/>
	              		<option value="${month}" <c:if test="${result.DTRMC_ARVL_MONTH == month}">selected</c:if>>${item}월</option>
              		</c:forEach>
              	</select>
              	<br/>
              	<select name="cmdDay" style="min-width:45%; max-width:100%;">
              		<option value="">=일=</option>
              		<c:forEach var="item" begin="1" end="31">
              			<fmt:formatNumber minIntegerDigits="2" var="day" value="${item}" type="number"/>
	              		<option value="${day}" <c:if test="${result.DTRMC_ARVL_DAY == day}">selected</c:if>>${item}일</option>
              		</c:forEach>
              	</select>
              	<select name="cmdTime" style="min-width:45%; max-width:100%;">
              		<option value="">=시간=</option>
              		<c:forEach var="item" begin="0" end="23">
              			<fmt:formatNumber minIntegerDigits="2" var="hour" value="${item}" type="number"/>
              			<c:set var="hour1" value="${hour}:00" /> 
              			<c:set var="hour2" value="${hour}:30" /> 
	              		<option value="${hour1}" <c:if test="${result.DTRMC_ARVL_TIME == hour1}">selected</c:if>>${item}:00</option>
	              		<option value="${hour2}" <c:if test="${result.DTRMC_ARVL_TIME == hour2}">selected</c:if>>${item}:30</option>
              		</c:forEach>
              	</select>
              </td>
            </tr>
            <tr>
              <td>항공편명</td>
              <td colspan="2"><input type="text"  id="DTRMC_FLIGHT" name="DTRMC_FLIGHT" style="width:100%" value="${result.DTRMC_FLIGHT}"></td>
            </tr>
          </tbody>
        </table>
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="40%">
          <col width="40%">
          <tbody>
            <tr>
              <th >입국정보</th><th >출발</th><th >도착</th>
            </tr>
            <tr>
              <td>공항</td>
              <td>
              	<select id="HMCMG_START_ARPRT_CODE" name="HMCMG_START_ARPRT_CODE" style="width:100%">
              		<option value="">선택</option>
              		<c:forEach var="list" items="${lstFlight}">
	              		<option value="${list.ARPRT_CODE}" <c:if test="${result.HMCMG_START_ARPRT_CODE == list.ARPRT_CODE}">selected</c:if>>${list.ARPRT_NM}</option>
              		</c:forEach>
              	</select>
              </td>
              <td>
              	<select id="HMCMG_ARVL_ARPRT_CODE" name="HMCMG_ARVL_ARPRT_CODE" style="width:100%">
              		<option value="">선택</option>
              		<c:forEach var="list" items="${lstFlight}">
	              		<option value="${list.ARPRT_CODE}" <c:if test="${result.HMCMG_ARVL_ARPRT_CODE == list.ARPRT_CODE}">selected</c:if>>${list.ARPRT_NM}</option>
              		</c:forEach>
              	</select>
              </td>
            </tr>
            <tr>
              <td>일자</td>
              <td id="inStart">
              	<select name="cmdYear" style="min-width:45%; max-width:100%;">
              		<option value="">=년=</option>
              		<c:forEach var="item" items="${lstYear}">
	              		<option value="${item}" <c:if test="${result.HMCMG_START_YEAR == item}">selected</c:if>>${item}년</option>
              		</c:forEach>
              	</select>
              	<select name="cmdMonth" style="min-width:45%; max-width:100%;">
              		<option value="">=월=</option>
              		<c:forEach var="item" begin="1" end="12">              		
              			<fmt:formatNumber minIntegerDigits="2" var="month" value="${item}" type="number"/>
	              		<option value="${month}" <c:if test="${result.HMCMG_START_MONTH == month}">selected</c:if>>${item}월</option>
              		</c:forEach>
              	</select>
              	<br/>
              	<select name="cmdDay" style="min-width:45%; max-width:100%;">
              		<option value="">=일=</option>
              		<c:forEach var="item" begin="1" end="31">
              			<fmt:formatNumber minIntegerDigits="2" var="day" value="${item}" type="number"/>
	              		<option value="${day}" <c:if test="${result.HMCMG_START_DAY == day}">selected</c:if>>${item}일</option>
              		</c:forEach>
              	</select>
              	<select name="cmdTime" style="min-width:45%; max-width:100%;">
              		<option value="">=시간=</option>
              		<c:forEach var="item" begin="0" end="23">
              			<fmt:formatNumber minIntegerDigits="2" var="hour" value="${item}" type="number"/>
              			<c:set var="hour1" value="${hour}:00" /> 
              			<c:set var="hour2" value="${hour}:30" /> 
	              		<option value="${hour1}" <c:if test="${result.HMCMG_START_TIME == hour1}">selected</c:if>>${item}:00</option>
	              		<option value="${hour2}" <c:if test="${result.HMCMG_START_TIME == hour2}">selected</c:if>>${item}:30</option>
              		</c:forEach>
              	</select>
              </td>
              <td id="inEnd">
              	<select name="cmdYear" style="min-width:45%; max-width:100%;">
              		<option value="">=년=</option>
              		<c:forEach var="item" items="${lstYear}">
	              		<option value="${item}" <c:if test="${result.HMCMG_ARVL_YEAR == item}">selected</c:if>>${item}년</option>
              		</c:forEach>
              	</select>
              	<select name="cmdMonth" style="min-width:45%; max-width:100%;">
              		<option value="">=월=</option>
              		<c:forEach var="item" begin="1" end="12">              		
              			<fmt:formatNumber minIntegerDigits="2" var="month" value="${item}" type="number"/>
	              		<option value="${month}" <c:if test="${result.HMCMG_ARVL_MONTH == month}">selected</c:if>>${item}월</option>
              		</c:forEach>
              	</select>
              	<br/>
              	<select name="cmdDay" style="min-width:45%; max-width:100%;">
              		<option value="">=일=</option>
              		<c:forEach var="item" begin="1" end="31">
              			<fmt:formatNumber minIntegerDigits="2" var="day" value="${item}" type="number"/>
	              		<option value="${day}" <c:if test="${result.HMCMG_ARVL_DAY == day}">selected</c:if>>${item}일</option>
              		</c:forEach>
              	</select>
              	<select name="cmdTime" style="min-width:45%; max-width:100%;">
              		<option value="">=시간=</option>
              		<c:forEach var="item" begin="0" end="23">
              			<fmt:formatNumber minIntegerDigits="2" var="hour" value="${item}" type="number"/>
              			<c:set var="hour1" value="${hour}:00" /> 
              			<c:set var="hour2" value="${hour}:30" /> 
	              		<option value="${hour1}" <c:if test="${result.HMCMG_ARVL_TIME == hour1}">selected</c:if>>${item}:00</option>
	              		<option value="${hour2}" <c:if test="${result.HMCMG_ARVL_TIME == hour2}">selected</c:if>>${item}:30</option>
              		</c:forEach>
              	</select>
              </td>
            </tr>
            <tr>
              <td>항공편명</td>
              <td colspan="2"><input type="text" id="HMCMG_FLIGHT" name="HMCMG_FLIGHT" style="width:100%"value="${result.HMCMG_FLIGHT}"></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn">
      	<a href="javascript:inputAir();">저장</a>
      </div>
    </div>
  </div>
<script>

function dtAirValue(id) {
	var dt1 = $("#" + id).find("[name='cmdYear']").val();
	var dt2 = $("#" + id).find("[name='cmdMonth']").val();
	var dt3 = $("#" + id).find("[name='cmdDay']").val();
	var dt4 = $("#" + id).find("[name='cmdTime']").val();
	
	if(dt1 != "" || dt2 != "" || dt3 != "" || dt4 != "") {
		if(dt1 == "")
			return "-1";
		if(dt2 == "")
			return "-1";
		if(dt3 == "")
			return "-1";
		if(dt4 == "")
			return "-1";
		return dt1 + "-" + dt2 + "-" + dt3 + " " + dt4;
	} else {
		return "";
	}
}

function inputAir() {	
	var url = "<c:url value='/cmmn/saveFlight'/>";
	var obj = $(".featherlight");
	
	var flight_sn = $(obj).find("#flight_sn").val();
	var dtrmc_start_dt = dtAirValue("outStart");
	var dtrmc_arvl_dt = dtAirValue("outEnd");
	var hmcmg_start_dt = dtAirValue("inStart");
	var hmcmg_arvl_dt = dtAirValue("inEnd");
	
	if(dtrmc_start_dt == "-1") {
		alert("출국정보 출발일자를 정확히 입력해주세요.");
		return;
	}
	if(dtrmc_arvl_dt == "-1") {
		alert("출국정보 도착일자를 정확히 입력해주세요.");
		return;
	}
	if(hmcmg_start_dt == "-1") {
		alert("입국정보 출발일자를 정확히 입력해주세요.");
		return;
	}
	if(hmcmg_arvl_dt == "-1") {
		alert("입국정보 도착일자를 정확히 입력해주세요.");
		return;
	}
	
	var param = {};
	param.flight_sn = flight_sn;
	param.dtrmc_flight = $(obj).find("#DTRMC_FLIGHT").val();
	param.dtrmc_start_arprt_code = $(obj).find("#DTRMC_START_ARPRT_CODE").val();
	param.dtrmc_start_cty = "";
	param.dtrmc_start_dt = dtrmc_start_dt;
	
	param.dtrmc_arvl_arprt_code = $(obj).find("#DTRMC_ARVL_ARPRT_CODE").val();
	param.dtrmc_arvl_cty = "";
	param.dtrmc_arvl_dt = dtrmc_arvl_dt;

	param.hmcmg_flight = $(obj).find("#HMCMG_FLIGHT").val();
	param.hmcmg_start_arprt_code = $(obj).find("#HMCMG_START_ARPRT_CODE").val();
	param.hmcmg_start_cty = "";
	param.hmcmg_start_dt = hmcmg_start_dt;

	param.hmcmg_arvl_arprt_code = $(obj).find("#HMCMG_ARVL_ARPRT_CODE").val();
	param.hmcmg_arvl_cty = "";
	param.hmcmg_arvl_dt = hmcmg_arvl_dt;

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
				alert("저장되었습니다.");
				if(typeof(detail_flight_sn) != "undefined")
					detail_flight_sn = data.data;
				if(callback != "") {
					var fn = window[callback];
					// is object a function?
					if (typeof fn === "function") fn(data.data);
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
