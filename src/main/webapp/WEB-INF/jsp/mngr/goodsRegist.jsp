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
<script type="text/javascript" src="<c:url value='/js/Common.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/calendar.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(){
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
			fnCalendarPopup($(this).attr("id"), "2017-06-01", "2030-12-31");
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
			위도 : <input type="text" name="LA" id="LA">&nbsp;&nbsp;&nbsp;
			경도 : <input type="text" name="LO" id="LO">
		</td>
		
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