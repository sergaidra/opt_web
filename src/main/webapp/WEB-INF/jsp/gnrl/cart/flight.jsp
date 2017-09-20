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
		
		//alert('TODO 필수입력 체크');
		
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
	
	function fnDeleteFlight() {
		if(!"${flight.FLIGHT_SN}") {
			return;
		}
		
		//alert('TODO 픽업,드랍 서비스는 삭제 불가');
		
		var form_data = $("form[id=frmSave]").serialize();
		$.ajax({
			url : "<c:url value='/cart/delFlightAction/'/>",
			dataType : "json",
			type : "POST",
			async : true,
			data : form_data,
			beforeSend:function(){
				showLoading();
			},
			success : function(json) {
				if(json.result == "0") {
					alert("항공편이 삭제되었습니다.");
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
	
	// div : DTRMC(출국), HMCMG(입국)
	function fnSearchFlight(schDiv) {
		$('#schDiv').val(schDiv);
		if($("#"+schDiv+"_START_ARPRT_CODE option:selected").val() == "ICN" || $("#"+schDiv+"_ARVL_ARPRT_CODE option:selected").val() == "ICN") { // 인천
			var startarvlDiv = (schDiv=='DTRMC'?'S':'A');
			var tourDe = (schDiv=='DTRMC'?$('#DTRMC_START_DE').val():$('#HMCMG_ARVL_DE').val());
			var stdrArprtCode = (schDiv=='DTRMC'?$("#DTRMC_START_ARPRT_CODE option:selected").val():$("#HMCMG_ARVL_ARPRT_CODE option:selected").val());	
			actionUrl = "<c:url value='/cart/getArlineSchdulAction/'/>?STARTARVL_DIV="+startarvlDiv+"&TOUR_DE="+tourDe+"&STDR_ARPRT_CODE="+stdrArprtCode;
		} else {
			var schType = (schDiv=='DTRMC'?'OUT':'IN');			
			var schDate = (schDiv=='DTRMC'?$('#DTRMC_START_DE').val():$('#HMCMG_ARVL_DE').val());		
			var schDeptCityCode = (schDiv=='DTRMC'?$("#DTRMC_START_ARPRT_CODE option:selected").val():$("#HMCMG_ARVL_ARPRT_CODE option:selected").val());
			var schArrvCityCode = (schDiv=='DTRMC'?$("#DTRMC_ARVL_ARPRT_CODE option:selected").val():$("#HMCMG_START_ARPRT_CODE option:selected").val());
			actionUrl = "<c:url value='/flight/getKoreaFlightInfo/'/>?schType="+schType+"&schDate="+schDate+"&schDeptCityCode="+schDeptCityCode+"&schArrvCityCode="+schArrvCityCode;
		}
		
		$.ajax({
			url : actionUrl,
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
						var title = (json.arlineSchdulList[0].STARTARVL_DIV=='S'?"출국시간":"도착시간");
						var str = "<table width='500' cellpadding='5' cellspacing='0'>"
						        + "<tr><td>선택</td><td>출발지</td><td>도착지</td><td>항공편명</td><td>"+title+"</td><td>항공사</td></tr>";
						$.each(json.arlineSchdulList, function(key, value){
							//$("#DTRMC_FLIGHT_DESC").append("<option value='"+value.CF_DESC+"'>"+value.CF_DESC+"</option>");
							str +="<tr><td><input type='radio' name='arlineSchdulInfo'>"
							    + "<input type='hidden' name='POP_ARLINE_NM' value='"+value.ARLINE_NM+"'>"							
							    + "<input type='hidden' name='POP_ARLINE_NUM' value='"+value.ARLINE_NUM+"'>"
							    + "<input type='hidden' name='POP_SCHDUL_TM' value='"+value.SCHDUL_TM+"'>"
							    + "<input type='hidden' name='POP_TMPR_START_DE' value='"+value.CF_TMPR_START_DE+"'>"
							    + "<input type='hidden' name='POP_TMPR_START_TM' value='"+value.CF_TMPR_START_TM+"'>"
							    + "<input type='hidden' name='POP_TMPR_ARVL_DE' value='"+value.CF_TMPR_ARVL_DE+"'>"
							    + "<input type='hidden' name='POP_TMPR_ARVL_TM' value='"+value.CF_TMPR_ARVL_TM+"'>"							    
							    + "</td><td>"+value.CF_START_CTY+"</td><td>"+value.CF_ARVL_CTY+"</td><td>"+value.ARLINE_NUM+"</td><td>"+value.CF_SCHDUL_TM+"</td><td>"+value.ARLINE_NM+"</td></tr>"
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
				var arlineNm = $(this).parent().find("input[name='POP_ARLINE_NM']").val();				
				var arlineNum = $(this).parent().find("input[name='POP_ARLINE_NUM']").val();
				var schdulTm = $(this).parent().find("input[name='POP_SCHDUL_TM']").val();

				if($('#schDiv').val() == 'DTRMC') {
					var tmprDe = $(this).parent().find("input[name='POP_TMPR_ARVL_DE']").val();
					var tmprTm = $(this).parent().find("input[name='POP_TMPR_ARVL_TM']").val();
					$('#DTRMC_FLIGHT_NM').html(arlineNm);					
					$('#DTRMC_FLIGHT').val(arlineNum);
					$('#DTRMC_START_TM').val(schdulTm);	
					$('#DTRMC_START_HH').val(schdulTm.substring(0,2));	
					$('#DTRMC_START_MI').val(schdulTm.substring(2,4));
					if(!$('#DTRMC_ARVL_DE').val()) {
						$('#DTRMC_ARVL_DE').val(tmprDe);	
						$('#DTRMC_ARVL_TM').val(tmprTm);	
						$('#DTRMC_ARVL_HH').val(tmprTm.substring(0,2));	
						$('#DTRMC_ARVL_MI').val(tmprTm.substring(2,4));
					}
				} else {
					var tmprDe = $(this).parent().find("input[name='POP_TMPR_START_DE']").val();
					var tmprTm = $(this).parent().find("input[name='POP_TMPR_START_TM']").val();					
					$('#HMCMG_FLIGHT_NM').html(arlineNm);
					$('#HMCMG_FLIGHT').val(arlineNum);
					$('#HMCMG_ARVL_TM').val(schdulTm);
					$('#HMCMG_ARVL_HH').val(schdulTm.substring(0,2));
					$('#HMCMG_ARVL_MI').val(schdulTm.substring(2,4));
					if(!$('#HMCMG_START_DE').val()) {
						$('#HMCMG_START_DE').val(tmprDe);	
						$('#HMCMG_START_TM').val(tmprTm);	
						$('#HMCMG_START_HH').val(tmprTm.substring(0,2));	
						$('#HMCMG_START_MI').val(tmprTm.substring(2,4));					
					}
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
<table width="700" cellpadding="5" cellspacing="0" >
	<tr align="center" bgcolor="lightgray">
		<td width="20%">구분</td>
		<td width="40%">출발</td>
		<td width="40%">도착</td>
	</tr>
	<tr>
		<td><font color="red">*</font> 공항</td>
		<td>
			<select name="DTRMC_START_ARPRT_CODE" id="DTRMC_START_ARPRT_CODE">
				<option value="">선택</option>
				<c:forEach var="list" items="${arprtList}" varStatus="status">
				<option value="<c:out value='${list.ARPRT_CODE}'/>" <c:if test="${flight.DTRMC_START_ARPRT_CODE eq list.ARPRT_CODE}">selected</c:if>>${list.ARPRT_NM}</option>
				</c:forEach>
			</select>
		</td>
		<td>
			<select name="DTRMC_ARVL_ARPRT_CODE" id="DTRMC_ARVL_ARPRT_CODE">
				<option value="">선택</option>
				<c:forEach var="list" items="${arprtList}" varStatus="status">
				<option value="<c:out value='${list.ARPRT_CODE}'/>" <c:if test="${flight.DTRMC_ARVL_ARPRT_CODE eq list.ARPRT_CODE}">selected</c:if>>${list.ARPRT_NM}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td><font color="red">*</font> 일자</td>
		<td>
			<input type="text" id="DTRMC_START_DE" name="DTRMC_START_DE" size="10" maxlength="10" readonly value="<c:out value="${flight.DTRMC_START_DE}"/>" onfocus="this.blur();" title="출발 일자">
			<input type="button" value="달력" onclick='fnCalendarPopup("DTRMC_START_DE")'>
			<input type="button" value="항공편검색" onclick='fnSearchFlight("DTRMC")'>
		</td>
		<td>
			<input type="text" id="DTRMC_ARVL_DE" name="DTRMC_ARVL_DE" size="10" maxlength="10" readonly value="<c:out value="${flight.DTRMC_ARVL_DE}"/>" onfocus="this.blur();" title="도착 일자">	
			<input type="button" value="달력" onclick='fnCalendarPopup("DTRMC_ARVL_DE")'>
		</td>
	</tr>
	<tr>
		<td><font color="red">*</font> 시간</td>
		<td>
			<select name="DTRMC_START_HH" id="DTRMC_START_HH" title="출발 시">
				<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.DTRMC_START_HH eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>시</option>
			</c:forEach></select> :
			<select name="DTRMC_START_MI" id="DTRMC_START_MI" title="출발 분">
				<option value="">선택</option><c:forEach var="i" begin="0" end="55" step="5">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.DTRMC_START_MI eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>분</option>
			</c:forEach></select>
			<input type="hidden" id="DTRMC_START_TM" name="DTRMC_START_TM" value="<c:out value="${flight.DTRMC_START_TM}"/>" title="출국 시간">
		</td>
		<td>
			<select name="DTRMC_ARVL_HH" id="DTRMC_ARVL_HH" title="도착 시">
				<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.DTRMC_ARVL_HH eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>시</option>
			</c:forEach></select> :
			<select name="DTRMC_ARVL_MI" id="DTRMC_ARVL_MI" title="도착 분">
				<option value="">선택</option><c:forEach var="i" begin="0" end="55" step="5">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.DTRMC_ARVL_MI eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>분</option>
			</c:forEach></select>
			<input type="hidden" id="DTRMC_ARVL_TM" name="DTRMC_ARVL_TM" value="<c:out value="${flight.DTRMC_ARVL_TM}"/>" title="출국 시간">		
		</td>
	</tr>
	<tr>
		<td><font color="red">*</font> 항공편명</td>
		<td colspan="2">
			<input type="text" id="DTRMC_FLIGHT" name="DTRMC_FLIGHT" size="15" maxlength="6" value="<c:out value="${flight.DTRMC_FLIGHT}"/>" title="출국시 항공편명">		
			<span id="DTRMC_FLIGHT_NM">${flight.DTRMC_FLIGHT_NM}</span>
		</td>
	</tr>
</table>
<br>

입국정보
<br><br>
<table width="700" cellpadding="5" cellspacing="0" >
	<tr align="center" bgcolor="lightgray">
		<td width="20%">구분</td>
		<td width="40%">출발</td>
		<td width="40%">도착</td>
	</tr>
	<tr>
		<td><font color="red">*</font> 공항</td>
		<td>
			<select name="HMCMG_START_ARPRT_CODE" id="HMCMG_START_ARPRT_CODE">
				<option value="">선택</option>
				<c:forEach var="list" items="${arprtList}" varStatus="status">
				<option value="<c:out value='${list.ARPRT_CODE}'/>" <c:if test="${flight.HMCMG_START_ARPRT_CODE eq list.ARPRT_CODE}">selected</c:if>>${list.ARPRT_NM}</option>
				</c:forEach>
			</select>
		</td>
		<td>
			<select name="HMCMG_ARVL_ARPRT_CODE" id="HMCMG_ARVL_ARPRT_CODE">
				<option value="">선택</option>
				<c:forEach var="list" items="${arprtList}" varStatus="status">
				<option value="<c:out value='${list.ARPRT_CODE}'/>" <c:if test="${flight.HMCMG_ARVL_ARPRT_CODE eq list.ARPRT_CODE}">selected</c:if>>${list.ARPRT_NM}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td><font color="red">*</font> 일자</td>
		<td>
			<input type="text" id="HMCMG_START_DE" name="HMCMG_START_DE" size="10" maxlength="10" readonly value="<c:out value="${flight.HMCMG_START_DE}"/>" onfocus="this.blur();" title="출발 일자">
			<input type="button" value="달력" onclick='fnCalendarPopup("HMCMG_START_DE")'>
		</td>
		<td>
			<input type="text" id="HMCMG_ARVL_DE" name="HMCMG_ARVL_DE" size="10" maxlength="10" readonly value="<c:out value="${flight.HMCMG_ARVL_DE}"/>" onfocus="this.blur();" title="도착 일자">	
			<input type="button" value="달력" onclick='fnCalendarPopup("HMCMG_ARVL_DE")'>
			<input type="button" value="항공편검색" onclick='fnSearchFlight("HMCMG")'>
		</td>
	</tr>
	<tr>
		<td><font color="red">*</font> 시간</td>
		<td>
			<select name="HMCMG_START_HH" id="HMCMG_START_HH" title="출발 시">
				<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.HMCMG_START_HH eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>시</option>
			</c:forEach></select> :
			<select name="HMCMG_START_MI" id="HMCMG_START_MI" title="출발 분">
				<option value="">선택</option><c:forEach var="i" begin="0" end="55" step="5">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.HMCMG_START_MI eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>분</option>
			</c:forEach></select>
			<input type="hidden" id="HMCMG_START_TM" name="HMCMG_START_TM" value="<c:out value="${flight.HMCMG_START_TM}"/>" title="입국 시간">
		</td>
		<td>
			<select name="HMCMG_ARVL_HH" id="HMCMG_ARVL_HH" title="도착 시">
				<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.HMCMG_ARVL_HH eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>시</option>
			</c:forEach></select> :
			<select name="HMCMG_ARVL_MI" id="HMCMG_ARVL_MI" title="도착 분">
				<option value="">선택</option><c:forEach var="i" begin="0" end="55" step="5">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>" <c:if test="${flight.HMCMG_ARVL_MI eq i}">selected</c:if>><fmt:formatNumber value="${i}" pattern="00"/>분</option>
			</c:forEach></select>
			<input type="hidden" id="HMCMG_ARVL_TM" name="HMCMG_ARVL_TM" value="<c:out value="${flight.HMCMG_ARVL_TM}"/>" title="입국 시간">		
		</td>
	</tr>
	<tr>
		<td><font color="red">*</font> 항공편명</td>
		<td colspan="2">
			<input type="text" id="HMCMG_FLIGHT" name="HMCMG_FLIGHT" size="15" maxlength="6" value="<c:out value="${flight.HMCMG_FLIGHT}"/>" title="입국시 항공편명">		
			<span id="HMCMG_FLIGHT_NM">${flight.HMCMG_FLIGHT_NM}</span>
		</td>
	</tr>
</table>
<br><br>
<input type="button" value="저장" onclick='fnSaveFlight();'>
<input type="button" value="삭제" onclick='fnDeleteFlight();'>
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