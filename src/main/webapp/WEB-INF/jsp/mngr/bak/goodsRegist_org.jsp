<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>상품등록</title>
<link type="text/css" href="/css/jquery-ui.css" rel="stylesheet" media="screen"/>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(){
		
		HTMLArea.init(); 
		HTMLArea.onload = initEditor;
		
		var idxDe = 1;
		$("#btnAddDate").click(function(){
			idxDe++;
	        var newDateGroup = "<div class='divDate'> "
	                         + "<input type='text' class='DatePickerBegin' name='BEGIN_DE' id='BEGIN_DE_"+idxDe+"' size='10'> ~ <input type='text' class='DatePickerEnd' name='END_DE' id='END_DE_"+idxDe+"' size='10'> "
	                         /*+ "<input type='checkbox' name='MON' checked>월 "
	                         + "<input type='checkbox' name='TUE' checked>화 "
	                         + "<input type='checkbox' name='WED' checked>수 "
	                         + "<input type='checkbox' name='THU' checked>목 "
	                         + "<input type='checkbox' name='FRI' checked>금 "
	                         + "<input type='checkbox' name='SAT' checked>토 "
	                         + "<input type='checkbox' name='SUN' checked>일 "*/
	                         + "<input type='button' value='삭제' id='btnDelDate'></div>";
	        $("#divDateGroup").append(newDateGroup);
		});

		$("#btnAddTime").click(function(){
			var newTimeGroup = $("#divTimeTmp").html();
			$("#divTimeGroup").append(newTimeGroup);
		});
		
		var idxFile = 2;
		$("#btnAddFile").click(function(){
			idxFile++;
	        var newFileGroup = "<div class='divFile'> "
				             + "<input type='file' name='FILE_NM' id='FILE_NM_"+idxFile+"' size='50'> "
				             + "<input type='button' value='삭제' id='btnDelFile'> "
			                 + "</div>";
	        $('#divFileGroup').append(newFileGroup);
		});		
	});

	$(document).on("click", ".DatePickerBegin", function(){
		var idx = $(this).attr("id").substring($(this).attr("id").lastIndexOf("_")+1);
		if($("#END_DE_"+idx).val()) {
			fnCalendarPopup($(this).attr("id"), "2017-06-01", $("#END_DE_"+idx).val());
		} else {
			fnCalendarPopup($(this).attr("id"), "2017-06-01", "2030-12-31");
		}
	});

	$(document).on("click", ".DatePickerEnd", function(){
		var idx = $(this).attr("id").substring($(this).attr("id").lastIndexOf("_")+1);
		if($("#BEGIN_DE_"+idx).val()) {
			fnCalendarPopup($(this).attr("id"), $("#BEGIN_DE_"+idx).val(), "2030-12-31");
		} else {
			fnCalendarPopup($(this).attr("id"), "2017-08-01", "2030-12-31");
		}
	});

	$(document).on("click","#btnDelDate", function(){
		if($(".divDate").length > 1) {
			$(this).parent().remove();
		} else {
			return;
		}
	});

	$(document).on("click","#btnDelTime", function(){
		if($(".divTime").length > 1) {
			$(this).parent().remove();
		} else {
			return;
		}
	});

	$(document).on("click","#btnDelFile", function(){
		if($(".divFile").length > 1) {
			$(this).parent().remove();
		} else {
			return;
		}
	});

	function f_inputNumberFormat(obj) {
		obj.value = comma(uncomma(obj.value));
	}

	function comma(str) {
		str = String(str);
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, "$1,");
	}

	function uncomma(str) {
		str = String(str);
		return str.replace(/[^\d]+/g, "");
	}

	function f_chkTextVal(objName) {
 		var bRe;
		$("input:text[name='"+objName+"']").each(function(index){
			if(bRe != false && $(this).val()) {
				bRe = true;
			} else {
				bRe = false;
				return false;
			}
		});

		return bRe;
	}

	function f_chkSelectVal(objName) {
 		var bRe;
 		var total = $("select[name='"+objName+"']").length;
		$("select[name='"+objName+"']").each(function(index){
			if(total-1 != index) {
				if(bRe != false && $(this).val()) {
					bRe = true;
				} else {
					bRe = false;
					return false;
				}
			}
		});

		return bRe;
	}
	
	function f_chkFileVal(objName) {
 		var bRe;
 		var sExtsn;

		$("input:file[name='"+objName+"']").each(function(index){
			console.log("[file check]index:"+index + "/"+$(this).attr("id"));
			
			if($(this).attr("id") == "FILE_NM_1") { 
				sExtsn = "AVI,MP4,MKV,WMV,MOV"; // 상품동영상
			} else {  
				sExtsn = "BMP,GIF,JPG,JPEG,PNG"; // 상품대표이미지, 이미지
			}
				
			if(bRe != false && $(this).val()) {
				if(!fnCheckImg($(this), sExtsn)) {
					$(this).val("");
					bRe = false;
					return false;  // break;
				} else {
					bRe = true;	
				}				
			}
		});

		return bRe;
	}	

	function f_add() {

		/* var chk = 0;
		$("input:radio[name='CL_CODE']").each(function(){
			if(this.checked) chk++;
		});

		if(chk == 0) {
			alert("상품분류를 선택하세요.");
			return;
		} */
		
		if(!$("#CL_CODE option:selected").val()) {
			alert("상품분류를 선택하세요.");
			return;
		}
		
		if($("#GOODS_NM").val() == "") {
			alert("상품이름은(는) 필수입력항목입니다.");
			$("#GOODS_NM").focus();
			return;
		}
		if(!fnCheckMaxLength("GOODS_NM", "상품이름")) return;

		if($("#GOODS_INTRCN").val() == "") {
			alert("상품설명은(는) 필수입력항목입니다.");
			$("#GOODS_INTRCN").focus();
			return;
		}

		if(!f_chkTextVal("BEGIN_DE")) {
			alert("구매가능 일정 시작일자를 선택하세요.");
			return;
		}

		if(!f_chkTextVal("END_DE")) {
			alert("구매가능 일정 종료일자를 선택하세요.");
			return;
		}

		if(!f_chkSelectVal("BEGIN_HH")) {
			alert("구매가능 시작시간(시)을 선택하세요.");
			return;
		}

		if(!f_chkSelectVal("BEGIN_MI")) {
			alert("구매가능 시작시간(분)을 선택하세요.");
			return;
		}

		if(!f_chkSelectVal("END_HH")) {
			alert("구매가능 종료시간(시)을 선택하세요.");
			return;
		}

		if(!f_chkSelectVal("END_MI")) {
			alert("구매가능 종료시간(분)을 선택하세요.");
			return;
		}
		
		if(!$('#SETUP_AMOUNT_1').val()) {
			$('#SETUP_AMOUNT_1').focus();
			alert('성인 1인 기준 금액을 입력하세요.');
			return;
		}
		
		
		if(!$("#FILE_NM_0").val()) {
			alert("대표이미지를 선택하세요.");
			return;
		} else {
	 		if(!fnCheckImg($("#FILE_NM_0"), "BMP,GIF,JPG,JPEG,PNG")) {
				$("#FILE_NM_0").val("");
				return;
			}
		}
		
		if(!f_chkFileVal("FILE_NM")) {
			return;
		}
		
		
		var str_mon = "Y;Y;Y;Y;Y;Y;Y;";
		var str_tue = "Y;Y;Y;Y;Y;Y;Y;";
		var str_wed = "Y;Y;Y;Y;Y;Y;Y;";
		var str_thu = "Y;Y;Y;Y;Y;Y;Y;";
		var str_fri = "Y;Y;Y;Y;Y;Y;Y;";
		var str_sat = "Y;Y;Y;Y;Y;Y;Y;";
		var str_sun = "Y;Y;Y;Y;Y;Y;Y;";

		/*
		$("input:checkbox[name='MON']").each(function(){if(this.checked) str_mon += "Y;";else str_mon += "N;";});
		$("input:checkbox[name='TUE']").each(function(){if(this.checked) str_tue += "Y;";else str_tue += "N;";});
		$("input:checkbox[name='WED']").each(function(){if(this.checked) str_wed += "Y;";else str_wed += "N;";});
		$("input:checkbox[name='THU']").each(function(){if(this.checked) str_thu += "Y;";else str_thu += "N;";});
		$("input:checkbox[name='FRI']").each(function(){if(this.checked) str_fri += "Y;";else str_fri += "N;";});
		$("input:checkbox[name='SAT']").each(function(){if(this.checked) str_sat += "Y;";else str_sat += "N;";});
		$("input:checkbox[name='SUN']").each(function(){if(this.checked) str_sun += "Y;";else str_sun += "N;";});
		*/

		$("#txtMon").val(str_mon);
		$("#txtTue").val(str_tue);
		$("#txtWed").val(str_wed);
		$("#txtThu").val(str_thu);
		$("#txtFri").val(str_fri);
		$("#txtSat").val(str_sat);
		$("#txtSun").val(str_sun);
		
		form1.submit();
		
	}
</script>
</head>
<body>
◆ 여행상품등록
<br><br>
<form id="form1" method="post" action="<c:url value='../addGoods/'/>" enctype="multipart/form-data">
<input type="hidden" name="txtMon" id="txtMon">
<input type="hidden" name="txtTue" id="txtTue">
<input type="hidden" name="txtWed" id="txtWed">
<input type="hidden" name="txtThu" id="txtThu">
<input type="hidden" name="txtFri" id="txtFri">
<input type="hidden" name="txtSat" id="txtSat">
<input type="hidden" name="txtSun" id="txtSun">
<table width="800" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
		<td width="25%">상품분류</td>
		<td width="75%">
			<select name="CL_CODE" id="CL_CODE">
				<option value="">선택</option><c:forEach var="tourCl" items="${tourClList}" varStatus="status">
				<option value="${tourCl.CL_CODE}">${tourCl.CL_NM}</option></c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td width="25%">상품명</td>
		<td width="75%"><input type="text" id="GOODS_NM" name="GOODS_NM" size="65" maxlength="200" title="상품이름"></td>
	</tr>
	<tr>
		<td width="25%">상품설명</td>
		<td width="75%"><textarea id="GOODS_INTRCN" name="GOODS_INTRCN" cols="50" rows="10" title="상품설명"></textarea></td>
	</tr>
	<tr>
		<td width="25%">구매가능 날짜</td>
		<td width="75%">
		<div id="divDateGroup">
			<div class="divDate">
				<input type="text" class="DatePickerBegin" name="BEGIN_DE" id="BEGIN_DE_0" size="10"> ~ <input type="text" class="DatePickerEnd" name="END_DE" id="END_DE_0" size="10">
				<!-- <input type="checkbox" name="MON" checked>월
				<input type="checkbox" name="TUE" checked>화
				<input type="checkbox" name="WED" checked>수
				<input type="checkbox" name="THU" checked>목
				<input type="checkbox" name="FRI" checked>금
				<input type="checkbox" name="SAT" checked>토
				<input type="checkbox" name="SUN" checked>일 -->
				<input type="button" value="추가" id="btnAddDate">
			</div>
		</div>
		</td>
	</tr>
	<tr>
		<td width="25%">구매가능 시각</td>
		<td width="75%">
		<div id="divTimeGroup">
			<div class="divTime">
				<select name="BEGIN_HH" id="BEGIN_HH">
					<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
					<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>시</option>
				</c:forEach></select> :
				<select name="BEGIN_MI" id="BEGIN_MI">
					<option value="">선택</option><c:forEach var="i" begin="0" end="50" step="10">
					<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>분</option>
				</c:forEach></select> ~
				<select name="END_HH" id="END_HH">
					<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
					<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>시</option>
				</c:forEach></select> :
				<select name="END_MI" id="END_MI">
					<option value="">선택</option><c:forEach var="i" begin="0" end="50" step="10">
					<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>분</option>
				</c:forEach></select>
				<input type="button" value="추가" id="btnAddTime">
			</div>
		</div>
		</td>
	</tr>
	<tr>
		<td width="25%">대기 시간</td>
		<td width="75%">
			<select name="WAIT_HH" id="WAIT_HH">		
				<c:forEach var="i" begin="0" end="5" step="1">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/></option>
			</c:forEach></select> 시간  &nbsp;
			<select name="WAIT_MI" id="WAIT_MI">		
				<c:forEach var="i" begin="0" end="55" step="5">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/></option>
			</c:forEach></select> 분
		</td>
	</tr>
	<tr>
		<td width="25%">이동 시간</td>
		<td width="75%">
			<select name="MVMN_HH" id="MVMN_HH">		
				<c:forEach var="i" begin="0" end="5" step="1">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/></option>
			</c:forEach></select> 시간  &nbsp;
			<select name="MVMN_MI" id="MVMN_MI">		
				<c:forEach var="i" begin="0" end="55" step="5">
				<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/></option>
			</c:forEach></select> 분
		</td>
	</tr>
<!-- 	<tr>
		<td width="25%">활동 위치</td>
		<td width="75%">
			
		</td>
	</tr> -->
	<tr>
		<td width="25%">구매 인원</td>
		<td width="75%">
			<input type="hidden" name="NMPR_CND" id="NMPR_CND_1" value="성인 1인 기준">성인 1인 기준 : <input type="text" name="SETUP_AMOUNT" id="SETUP_AMOUNT_1" style="text-align:right;" onkeyup="f_inputNumberFormat(this)"><br>
			<input type="hidden" name="NMPR_CND" id="NMPR_CND_2" value="아동 1인 기준">아동 1인 기준 : <input type="text" name="SETUP_AMOUNT" id="SETUP_AMOUNT_2" style="text-align:right;" onkeyup="f_inputNumberFormat(this)">
		</td>
	</tr>
	<tr>
		<td width="25%">대표이미지</td>
		<td width="75%"><input type="file" name="FILE_NM" id="FILE_NM_0" size="50"></td>
	</tr>
	<tr>
		<td width="25%">상품동영상</td>
		<td width="75%"><input type="file" name="FILE_NM" id="FILE_NM_1" size="50"></td>
	</tr>
	<tr>
		<td width="25%">상품이미지</td>
		<td width="75%">
		<div id="divFileGroup">
			<div class="divFile">
				<input type="file" name="FILE_NM" id="FILE_NM_2" size="50">
				<input type="button" value="추가" id="btnAddFile">
			</div>
		</div>
		</td>
	</tr>
	<tr>
		<td>위치</td>
		<td>
			위도 : <input type="text" name="ACT_LA" id="ACT_LA">&nbsp;&nbsp;&nbsp;
			경도 : <input type="text" name="ACT_LO" id="ACT_LO">
		</td>
	</tr>
			<tr>
				<td width="25%">바우처티켓유형</td>
				<td width="75%"><input type="text" id="VOCHR_TICKET_TY"
					name="VOCHR_TICKET_TY" size="65" maxlength="1" title="바우처 티켓 유형"></td>
			</tr>
			<tr>
				<td width="25%">바우처발권소요시간</td>
				<td width="75%"><input type="text" id="VOCHR_NTSS_REQRE_TIME"
					name="VOCHR_NTSS_REQRE_TIME" size="65" maxlength="30"
					title="바우처 발권 소요 시간"></td>
			</tr>
			<tr>
				<td width="25%">바우처사용방법</td>
				<td width="75%"><input type="text" id="VOCHR_USE_MTH"
					name="VOCHR_USE_MTH" size="65" maxlength="1000" title="바우처 사용 방법"></td>
			</tr>
			<tr>
				<td width="25%">안내이용시간</td>
				<td width="75%"><input type="text" id="GUIDANCE_USE_TIME"
					name="GUIDANCE_USE_TIME" size="65" maxlength="100" title="안내 이용 시간"></td>
			</tr>
			<tr>
				<td width="25%">안내소요시간</td>
				<td width="75%"><input type="text" id="GUIDANCE_REQRE_TIME"
					name="GUIDANCE_REQRE_TIME" size="65" maxlength="100"
					title="안내 소요 시간"></td>
			</tr>
			<tr>
				<td width="25%">안내연령구분</td>
				<td width="75%"><input type="text" id="GUIDANCE_AGE_DIV"
					name="GUIDANCE_AGE_DIV" size="65" maxlength="200" title="안내 연령 구분"></td>
			</tr>
			<tr>
				<td width="25%">안내여행일정</td>
				<td width="75%"><input type="text" id="GUIDANCE_TOUR_SCHDUL"
					name="GUIDANCE_TOUR_SCHDUL" size="65" maxlength="1000"
					title="안내 여행 일정"></td>
			</tr>
			<tr>
				<td width="25%">안내공연장위치</td>
				<td width="75%"><input type="text" id="GUIDANCE_PRFPLC_LC"
					name="GUIDANCE_PRFPLC_LC" size="65" maxlength="1000"
					title="안내 공연장 위치"></td>
			</tr>
			<tr>
				<td width="25%">안내교육과정</td>
				<td width="75%"><input type="text" id="GUIDANCE_EDC_CRSE"
					name="GUIDANCE_EDC_CRSE" size="65" maxlength="1000"
					title="안내 교육 과정"></td>
			</tr>
			<tr>
				<td width="25%">안내옵션사항</td>
				<td width="75%"><input type="text" id="GUIDANCE_OPTN_MATTER"
					name="GUIDANCE_OPTN_MATTER" size="65" maxlength="1000"
					title="안내 옵션 사항"></td>
			</tr>
			<tr>
				<td width="25%">안내픽업</td>
				<td width="75%"><input type="text" id="GUIDANCE_PICKUP"
					name="GUIDANCE_PICKUP" size="65" maxlength="200" title="안내 픽업"></td>
			</tr>
			<tr>
				<td width="25%">안내준비물</td>
				<td width="75%"><input type="text" id="GUIDANCE_PRPARETG"
					name="GUIDANCE_PRPARETG" size="65" maxlength="200" title="안내 준비물"></td>
			</tr>
			<tr>
				<td width="25%">안내포함사항</td>
				<td width="75%"><input type="text" id="GUIDANCE_INCLS_MATTER"
					name="GUIDANCE_INCLS_MATTER" size="65" maxlength="500"
					title="안내 포함 사항"></td>
			</tr>
			<tr>
				<td width="25%">안내불포함사항</td>
				<td width="75%"><input type="text"
					id="GUIDANCE_NOT_INCLS_MATTER" name="GUIDANCE_NOT_INCLS_MATTER"
					size="65" maxlength="500" title="안내 불포함 사항"></td>
			</tr>
			<tr>
				<td width="25%">추가안내</td>
				<td width="75%"><input type="text" id="ADIT_GUIDANCE"
					name="ADIT_GUIDANCE" size="65" maxlength="1000" title="추가 안내"></td>
			</tr>
			<tr>
				<td width="25%">유의사항</td>
				<td width="75%"><input type="text" id="ATENT_MATTER"
					name="ATENT_MATTER" size="65" maxlength="1000" title="유의 사항"></td>
			</tr>
			<tr>
				<td width="25%">변경환불규정</td>
				<td width="75%"><input type="text" id="CHANGE_REFND_REGLTN"
					name="CHANGE_REFND_REGLTN" size="65" maxlength="1000"
					title="변경 환불 규정"></td>
			</tr>
			<tr>
				<td width="25%">소개상품유형</td>
				<td width="75%"><input type="text" id="INTRCN_GOODS_TY"
					name="INTRCN_GOODS_TY" size="65" maxlength="20" title="소개 상품 유형"></td>
			</tr>
			<tr>
				<td width="25%">소개이용시간</td>
				<td width="75%"><input type="text" id="INTRCN_USE_TIME"
					name="INTRCN_USE_TIME" size="65" maxlength="20" title="소개 이용 시간"></td>
			</tr>
			<tr>
				<td width="25%">소개집합시간</td>
				<td width="75%"><input type="text" id="INTRCN_MEET_TIME"
					name="INTRCN_MEET_TIME" size="65" maxlength="20" title="소개 집합 시간"></td>
			</tr>
			<tr>
				<td width="25%">소개소요시간</td>
				<td width="75%"><input type="text" id="INTRCN_REQRE_TIME"
					name="INTRCN_REQRE_TIME" size="65" maxlength="20" title="소개 소요 시간"></td>
			</tr>
			<tr>
				<td width="25%">소개제공언어</td>
				<td width="75%"><input type="text" id="INTRCN_PROVD_LANG"
					name="INTRCN_PROVD_LANG" size="65" maxlength="20" title="소개 제공 언어"></td>
			</tr>
			<tr>
				<td width="25%">소개가능연령</td>
				<td width="75%"><input type="text" id="INTRCN_POSBL_AGE"
					name="INTRCN_POSBL_AGE" size="65" maxlength="20" title="소개 가능 연령"></td>
			</tr>
			<tr>
				<td width="25%">소개장소</td>
				<td width="75%"><input type="text" id="INTRCN_PLACE"
					name="INTRCN_PLACE" size="65" maxlength="20" title="소개 장소"></td>
			</tr>
		</table>




<table width="800" cellpadding="5" cellspacing="0" border="0" align="left" >
	<tr>
		<td width='100%' align="right">
			<input type="button" value="저장" onclick="f_add()">
			<input type="button" value="취소" onclick="form1.reset();">
		</td>
	</tr>
</table>
</form>

<div id="divTimeTmp" style="display:none;">
<div class="divTime">
	<select name="BEGIN_HH" id="BEGIN_HH">
		<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
		<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>시</option>
	</c:forEach></select> :
	<select name="BEGIN_MI" id="BEGIN_MI">
		<option value="">선택</option><c:forEach var="i" begin="0" end="50" step="10">
		<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>분</option>
	</c:forEach></select> ~
	<select name="END_HH" id="END_HH">
		<option value="">선택</option><c:forEach var="i" begin="0" end="23" step="1">
		<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>시</option>
	</c:forEach></select> :
	<select name="END_MI" id="END_MI">
		<option value="">선택</option><c:forEach var="i" begin="0" end="50" step="10">
		<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>분</option>
	</c:forEach></select>
	<input type="button" value="삭제" id="btnDelTime">
</div>
</div>

<br>


</body>
</html>