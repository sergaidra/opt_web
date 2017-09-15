<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>항공편</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jquery-ui.css'/>" />
<style type="text/css">
table, th, td {
	border: 1px solid black;
	border-collapse:collapse;
}

#divSchdulListPop {
	width:600px; height:400px; background:#fff; color:#3d3d3d; 
	position:absolute; top:10px; left:100px; text-align:center; 
	border:2px solid #000;
}

</style>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.blockUI.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione.js'/>"></script>
<script type="text/javascript">
	jQuery.fn.center = function() {
	    this.css("position", "absolute");
	    this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
	    this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
	    return this;
	}

	function fnSaveFlight() {
		
		var form_data = $("form[id=frmSave]").serialize();
		var sUrl = "<c:url value='/cart/addFlightAction/'/>";
	
		if("${flight.FLIGHT_SN}") {
			sUrl = "<c:url value='/cart/modFlightAction/'/>";
		}

		$.ajax({
			url : sUrl,
			dataType : "json",
			type : "POST",
			async : true,
			data : form_data,
			beforeSend:function(){
				showLoading();
			},
			success : function(json) {
				if(json.result == "0") {
					alert("항공편이 저장되었습니다.");
					if(window.opener != null && !window.opener.cloed) {
						if($("#hidLayout", opener.document).val() == 'Y') {
							window.opener.fnFlightInfo();							
						} else {
							window.opener.location.reload();
						}
						window.close();
					}
				} else if(json.result == "-2") {
					alert("로그인이 필요합니다.");
				} else{
					alert("작업을 실패하였습니다.");
				}
			},
			complete:function() {
				hideLoading();
			},
			error : function() {
				alert("오류가 발생하였습니다.");
			}
		});		

	}
	
	// div : D(출국), H(입국)
	function fnSearchFlight(schDiv) {
		$('#schDiv').val(schDiv);
		$.ajax({
			url : "<c:url value='/cart/getArlineSchdulAction/'/>",
			dataType : "json",
			type : "POST",
			async : true,
			beforeSend:function(){
				//showLoading();
			},
			success : function(json) {
				if(json.result == "0") {
					if(json.arlineSchdulList.length > 0) {
						//$("#DTRMC_FLIGHT_DESC option").remove();						
						var str = "<table width='500' cellpadding='5' cellspacing='0'>"
						        + "<tr><td>선택</td><td>항공편명</td><td>출국시간</td><td>항공사</td></tr>";
						$.each(json.arlineSchdulList, function(key, value){
							//$("#DTRMC_FLIGHT_DESC").append("<option value='"+value.CF_DESC+"'>"+value.CF_DESC+"</option>");
							str +="<tr><td><input type='radio' name='arlineSchdulInfo'>"
							    + "<input type='hidden' name='POP_ARLINE_NUM' value='"+value.ARLINE_NUM+"'>"
							    + "<input type='hidden' name='POP_SCHDUL_TM' value='"+value.SCHDUL_TM+"'>"
							    + "</td><td>"+value.ARLINE_NUM+"</td><td>"+value.CF_SCHDUL_TM+"</td><td>"+value.ARLINE_NM+"</td></tr>"
						});
						str += "</table>";  
						$("#divSchdulListTable").html(str);
						$("#divSchdulListPop").show().center();	
					}
				} else if(json.result == "-2") {
					//alert("로그인이 필요합니다.");
				} else{
					//alert("작업을 실패하였습니다.");
				}
			},
			complete:function() {
				//hideLoading();
			},
			error : function() {
				alert("오류가 발생하였습니다.");
			}
		});	
	}
	
	function fnClose() {
		$("#divSchdulListPop").hide();
	}
	
	function fnSelectSchedul() {
		$("input[name='arlineSchdulInfo']:radio").each(function(idx , elem){
			if($(this).is(":checked")){
				var arlineNum = $(this).parent().find("input[name='POP_ARLINE_NUM']").val();
				var schdulTm = $(this).parent().find("input[name='POP_SCHDUL_TM']").val();
				if($('#schDiv').val() == 'D') {
					$('#DTRMC_FLIGHT').val(arlineNum);
					$('#DTRMC_START_TM').val(schdulTm);	
					$('#DTRMC_START_HH').val(schdulTm.substring(0,2));	
					$('#DTRMC_START_MI').val(schdulTm.substring(2,4));	
				} else {
					$('#HMCMG_FLIGHT').val(arlineNum);
					$('#HMCMG_START_TM').val(schdulTm);
					$('#HMCMG_START_HH').val(schdulTm.substring(0,2));
					$('#HMCMG_START_MI').val(schdulTm.substring(2,4));
				}
				fnClose();
			}
		});
	}
</script>
</head>
<body>
<form name="frmSave" id="frmSave" method="post" action="../addFlightAction/">
<input type="hidden" name="FLIGHT_SN" id="FLIGHT_SN" value="${flight.FLIGHT_SN}">
<input type="hidden" name="schDiv" id="schDiv">
항공편 입력
<br><br>
출국정보
<br><br>
<table width="500" cellpadding="5" cellspacing="0" >
	<tr>
		<td width="30%" align="center"><font color="red">*</font> 출발공항</td>
		<td width="70%">
			<select name="DTRMC_START_ARPRT_CODE">
			<option value="">선택</option>
			<c:forEach var="list" items="${arprtList}" varStatus="status">
			<option value="<c:out value='${list.ARPRT_CODE}'/>" <c:if test="${flight.DTRMC_START_ARPRT_CODE eq list.ARPRT_CODE}">selected</c:if>>${list.ARPRT_NM}</option>
			</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td width="30%" align="center"><font color="red">*</font> 도착공항</td>
		<td width="70%">
			<select name="DTRMC_ARVL_ARPRT_CODE">
			<option value="">선택</option>
			<c:forEach var="list" items="${arprtList}" varStatus="status">
			<option value="<c:out value='${list.ARPRT_CODE}'/>" <c:if test="${flight.DTRMC_ARVL_ARPRT_CODE eq list.ARPRT_CODE}">selected</c:if>>${list.ARPRT_NM}</option>
			</c:forEach>
			</select>
		</td>
	</tr>	
	<tr>
		<td width="30%" align="center"><font color="red">*</font> 출발일자</td>
		<td width="70%">
			<input type="text" id="DTRMC_START_DE" name="DTRMC_START_DE" size="10" maxlength="10" readonly value="<c:out value="${flight.DTRMC_START_DE}"/>" onfocus="this.blur();" title="출발 일자">
			<input type="button" value="달력" onclick='fnCalendarPopup("DTRMC_START_DE")'>
			<input type="button" value="항공편검색" onclick='fnSearchFlight("D")'>
		</td>
	</tr>	
	<tr>
		<td width="30%" align="center"><font color="red">*</font> 출발시간</td>
		<td width="70%">
			<select name="DTRMC_START_HH" id="DTRMC_START_HH" title="출발 시">
				<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.DTRMC_START_HH eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>시</option>
			</c:forEach></select> :
			<select name="DTRMC_START_MI" id="DTRMC_START_MI" title="출발 분">
				<option value="">선택</option><c:forEach var="i" begin="0" end="55" step="5">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.DTRMC_START_MI eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>분</option>
			</c:forEach></select>
			<input type="text" id="DTRMC_START_TM" name="DTRMC_START_TM" value="<c:out value="${flight.DTRMC_START_TM}"/>" title="출국 시간">
		</td>
	</tr>	
	<tr>
		<td width="30%" align="center"><font color="red">*</font> 항공편명</td>
		<td width="70%">
			<!-- <select id="DTRMC_FLIGHT_DESC" name="DTRMC_FLIGHT_DESC"></select> -->
			<input type="text" id="DTRMC_FLIGHT" name="DTRMC_FLIGHT" size="40" maxlength="50" value="<c:out value="${flight.DTRMC_FLIGHT}"/>" title="출국시 항공편">			
		
		</td>
	</tr>	
</table>
<br>
입국정보
<br><br>
<table width="500" cellpadding="5" cellspacing="0" >
	<tr>
		<td width="30%" align="center"><font color="red">*</font> 출발공항</td>
		<td width="70%">
			<select name="HMCMG_START_ARPRT_CODE">
			<option value="">선택</option>
			<c:forEach var="list" items="${arprtList}" varStatus="status">
			<option value="<c:out value='${list.ARPRT_CODE}'/>" <c:if test="${flight.HMCMG_START_ARPRT_CODE eq list.ARPRT_CODE}">selected</c:if>>${list.ARPRT_NM}</option>
			</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td width="30%" align="center"><font color="red">*</font> 도착공항</td>
		<td width="70%">
			<select name="HMCMG_ARVL_ARPRT_CODE">
			<option value="">선택</option>
			<c:forEach var="list" items="${arprtList}" varStatus="status">
			<option value="<c:out value='${list.ARPRT_CODE}'/>" <c:if test="${flight.HMCMG_ARVL_ARPRT_CODE eq list.ARPRT_CODE}">selected</c:if>>${list.ARPRT_NM}</option>
			</c:forEach>
			</select>
		</td>
	</tr>	
	<tr>
		<td width="30%" align="center"><font color="red">*</font> 출발일자</td>
		<td width="70%">
			<input type="text" id="HMCMG_START_DE" name="HMCMG_START_DE" size="10" maxlength="10" readonly value="<c:out value="${flight.HMCMG_START_DE}"/>" onfocus="this.blur();" title="출발 일자">
			<input type="button" value="달력" onclick='fnCalendarPopup("HMCMG_START_DE")'>
			<input type="button" value="항공편검색" onclick='fnSearchFlight("H")'>
		</td>
	</tr>	
 	<tr>
		<td width="30%" align="center"><font color="red">*</font> 출발일시</td>
		<td width="70%">
			<select name="HMCMG_START_HH" id="HMCMG_START_HH" title="출발 시">
				<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.HMCMG_START_HH eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>시</option>
			</c:forEach></select> :
			<select name="HMCMG_START_MI" id="HMCMG_START_MI" title="출발 분">
				<option value="">선택</option><c:forEach var="i" begin="0" end="55" step="5">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.HMCMG_START_MI eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>분</option>
			</c:forEach></select>
			<input type="text" id="HMCMG_START_TM" name="HMCMG_START_TM" value="<c:out value="${flight.HMCMG_START_TM}"/>" title="입국 시간">
		</td>
	</tr>	
	<tr>
		<td width="30%" align="center"><font color="red">*</font> 항공편명</td>
		<td width="70%">
			<!-- <select id="HMCMG_FLIGHT_DESC" name="HMCMG_FLIGHT_DESC"></select> -->
			<input type="text" id="HMCMG_FLIGHT" name="HMCMG_FLIGHT" size="40" maxlength="50" value="<c:out value="${flight.HMCMG_FLIGHT}"/>" title="입국시 항공편">			
		
		</td>
	</tr>	
</table>
<br><br>
<input type="button" value="저장" onclick='fnSaveFlight();'>
<input type="button" value="닫기" onclick='this.close();'>
</form>

<!-- 항공정보 검색목록 -->
<div id="divSchdulListPop" style="display:none;" align="center">
항공정보 <input type='button' value='X' onclick='fnClose();'><br>
<div id="divSchdulListTable"></div>
<input type="button" value="취소" onclick='fnClose();'>
<input type="button" value="선택" onclick="fnSelectSchedul();">
</div>

</body>
</html>