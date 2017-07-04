<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>상품수정</title>
<link type="text/css" href="/css/jquery-ui.css" rel="stylesheet" media="screen"/>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione2.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/calendar.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(){
		var i = 0;
		$("#btnAddDate").click(function(){
			i++;
	        var newDateGroup = "<div class='divDate'> "
	                         + "<input type='text' class='DatePickerBegin' name='BEGIN_DE' id='BEGIN_DE_"+i+"' size='10'> ~ <input type='text' class='DatePickerEnd' name='END_DE' id='END_DE_"+i+"' size='10'> "
	                         + "<input type='checkbox' name='MON' checked>월 "
	                         + "<input type='checkbox' name='TUE' checked>화 "
	                         + "<input type='checkbox' name='WED' checked>수 "
	                         + "<input type='checkbox' name='THU' checked>목 "
	                         + "<input type='checkbox' name='FRI' checked>금 "
	                         + "<input type='checkbox' name='SAT' checked>토 "
	                         + "<input type='checkbox' name='SUN' checked>일 "
	                         + "<input type='button' value='삭제' id='btnDelDate'></div>";
	        $('#divDateGroup').append(newDateGroup);
		});	
		
		$("#btnAddTime").click(function(){
	        var newTimeGroup = $('#divTimeTmp').html();
	        $('#divTimeGroup').append(newTimeGroup);
		});
		
		$("#btnAddFile").click(function(){
	        var newFileGroup = $('#divFileTmp').html();
	        $('#divFileGroup').append(newFileGroup);
		});		
	});
	
    $(document).on("click", ".DatePickerBegin", function(){
    	var idx = $(this).attr('id').substring($(this).attr('id').lastIndexOf('_')+1);
    	if($("#END_DE_"+idx).val()) {
    		fnCalendarPopup($(this).attr('id'), '2017-06-01', $("#END_DE_"+idx).val());	
    	} else {
    		fnCalendarPopup($(this).attr('id'), '2017-06-01', '2030-12-31');
    	}
        
    });
	
    $(document).on("click", ".DatePickerEnd", function(){
    	var idx = $(this).attr('id').substring($(this).attr('id').lastIndexOf('_')+1);
    	if($("#BEGIN_DE_"+idx).val()) {
    		fnCalendarPopup($(this).attr('id'), $("#BEGIN_DE_"+idx).val(), '2030-12-31');	
    	} else {
    		fnCalendarPopup($(this).attr('id'), '2017-06-01', '2030-12-31');
    	}
		
	});		
	
	$(document).on('click','#btnDelDate', function(){
	    if($('.divDate').length > 1) {
	        $(this).parent().remove();
	    } else {
	    	return;
	    }
	});
	
	$(document).on('click','#btnDelTime', function(){
	    if($('.divTime').length > 1) {
	        $(this).parent().remove();
	    } else {
	    	return;
	    }
	});	
	
	$(document).on('click','#btnDelFile', function(){
	    if($('.divFile').length > 1) {
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
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'); 
	} 

	function uncomma(str) { 
		str = String(str); 
		return str.replace(/[^\d]+/g, ''); 
	}
		
	function f_add() {
/* 		if(!fnCheckImg($('#FILE_NM'), 'BMP,GIF,JPG,JPEG,PNG')) {
			$('#FILE_NM').val('');
			return;
		}
		if($("#GOODS_NM").val() == '') {
			alert("상품이름은(는) 필수입력항목입니다.");
			focus.focus();
			return;
		}
		if(!fnCheckMaxLength("GOODS_NM", "상품이름")) return;
 */
 
/* 
		$('input:checkbox[name="CL_CODE"]').each(function(){
			if(this.checked) 
				alert($(this).val());
			else 
				alert('not checked');
		});
  */
	
	
 
 
		var str_mon = '';
		var str_tue = '';
		var str_wed = '';
		var str_thu = '';
		var str_fri = '';
		var str_sat = '';
		var str_sun = '';

		$('input:checkbox[name="MON"]').each(function(){if(this.checked) str_mon += 'Y;';else str_mon += 'N;';});
		$('input:checkbox[name="TUE"]').each(function(){if(this.checked) str_tue += 'Y;';else str_tue += 'N;';});
		$('input:checkbox[name="WED"]').each(function(){if(this.checked) str_wed += 'Y;';else str_wed += 'N;';});
		$('input:checkbox[name="THU"]').each(function(){if(this.checked) str_thu += 'Y;';else str_thu += 'N;';});
		$('input:checkbox[name="FRI"]').each(function(){if(this.checked) str_fri += 'Y;';else str_fri += 'N;';});
		$('input:checkbox[name="SAT"]').each(function(){if(this.checked) str_sat += 'Y;';else str_sat += 'N;';});
		$('input:checkbox[name="SUN"]').each(function(){if(this.checked) str_sun += 'Y;';else str_sun += 'N;';});


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
◆ 여행상품수정
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
		<table>
		<c:forEach var="tourCl" items="${tourClList}" varStatus="status">
			<c:if test="${status.count%4 == 1}"><tr></c:if>
				<td><input type="checkbox" name="CL_CODE" value="<c:out value='${tourCl.CL_CODE}'/>" size=10><c:out value='${tourCl.CL_NM}'/></td>
			<c:if test="${status.count%4 == 0 || status.last}"></tr></c:if>
		</c:forEach>			
		</table>
		</td>
	</tr>	
	<tr>
		<td width="25%">상품명</td>
		<td width="75%"><input type="text" id="GOODS_NM" name="GOODS_NM" size="50" maxlength="200" title="상품이름"></td>
	</tr>	
	<tr>
		<td width="25%">상품설명</td>
		<td width="75%"><textarea id="GOODS_INTRCN" name="GOODS_INTRCN" cols="50" rows="10" title="상품설명"></textarea></td>
	</tr>	
	<tr>
		<td width="25%">구매가능 일정</td>
		<td width="75%">
		<div id="divDateGroup">
			<div class="divDate">
				<input type="text" class="DatePickerBegin" name="BEGIN_DE" id="BEGIN_DE_0" size="10"> ~ <input type="text" class="DatePickerEnd" name="END_DE" id="END_DE_0" size="10"> 
				<input type="checkbox" name="MON" checked>월
				<input type="checkbox" name="TUE" checked>화
				<input type="checkbox" name="WED" checked>수
				<input type="checkbox" name="THU" checked>목
				<input type="checkbox" name="FRI" checked>금
				<input type="checkbox" name="SAT" checked>토
				<input type="checkbox" name="SUN" checked>일
				<input type="button" value="추가" id="btnAddDate">
			</div>			
		</div>			
		</td>
	</tr>	
	<tr>
		<td width="25%">구매가능 시간</td>
		<td width="75%">
		<div id="divTimeGroup">
			<div class="divTime">
				<select name="BEGIN_HH" id="BEGIN_HH"><c:forEach var="i" begin="0" end="23" step="1">
					<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>시</option>
				</c:forEach></select> : 
				<select name="BEGIN_MM" id="BEGIN_MM"><c:forEach var="i" begin="0" end="50" step="10">
	      			<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>분</option>
				</c:forEach></select> ~ 
				<select name="END_HH" id="END_HH"><c:forEach var="i" begin="0" end="23" step="1">
					<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>시</option>
				</c:forEach></select> : 
				<select name="END_MM" id="END_MM"><c:forEach var="i" begin="0" end="50" step="10">
	      			<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>분</option>
				</c:forEach></select>
				<input type="button" value="추가" id="btnAddTime">			
			</div>
		</div>
		</td>
	</tr>	
	<tr>
		<td width="25%">구매 인원</td>
		<td width="75%">
			<input type="hidden" name="NMPR_CND" id="NMPR_CND_1" value="성인 1인 기준">성인 1인 기준 : <input type="text" name="SETUP_AMOUNT" id="SETUP_AMOUNT_1" style="text-align:right;" onkeyup="f_inputNumberFormat(this)"><br>
			<input type="hidden" name="NMPR_CND" id="NMPR_CND_2" value="아동 1인 기준">아동 1인 기준 : <input type="text" name="SETUP_AMOUNT" id="SETUP_AMOUNT_2" style="text-align:right;" onkeyup="f_inputNumberFormat(this)">
		</td>
	</tr>	
	<tr>
		<td width="25%">대표이미지</td>
		<td width="75%"><input type="file" name="FILE_NM" size="50"></td>
	</tr>	
	<tr>
		<td width="25%">상품동영상</td>
		<td width="75%"><input type="file" name="FILE_NM" size="50"></td>
	</tr>	
	<tr>
		<td width="25%">상품이미지</td>
		<td width="75%">
		<div id="divFileGroup">
			<div class="divFile">
				<input type="file" name="FILE_NM" size="50">
				<input type="button" value="추가" id="btnAddFile">
			</div>
		</div>
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
	<select name="BEGIN_HH" id="BEGIN_HH"><c:forEach var="i" begin="0" end="23" step="1">
		<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>시</option>
	</c:forEach></select> : 
	<select name="BEGIN_MM" id="BEGIN_MM"><c:forEach var="i" begin="0" end="50" step="10">
    	<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>분</option>
	</c:forEach></select> ~ 
	<select name="END_HH" id="END_HH"><c:forEach var="i" begin="0" end="23" step="1">
		<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>시</option>
	</c:forEach></select> : 
	<select name="END_MM" id="END_MM"><c:forEach var="i" begin="0" end="50" step="10">
   		<option value="<fmt:formatNumber value="${i}" pattern="00"/>"><fmt:formatNumber value="${i}" pattern="00"/>분</option>
	</c:forEach></select>
	<input type="button" value="삭제" id="btnDelTime">			
</div>
</div>

<div id="divFileTmp" style="display:none;">
<div class="divFile">
	<input type="file" id="FILE_NM" name="FILE_NM" size="50">
	<input type="button" value="삭제" id="btnDelFile">
</div>
</div>

<br>
<br>
<br>
<br>
<br>

</body>
</html>