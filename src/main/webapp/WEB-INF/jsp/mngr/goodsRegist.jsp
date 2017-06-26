<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>상품등록</title>
<link type="text/css" href="/css/jquery-ui.css" rel="stylesheet" media="screen"/>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione2.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/calendar.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$("#BEGIN_DE").click(function(){
			fnCalendarPopup('BEGIN_DE', '2017-06-01', '2017-07-31');
		});
		
		$("#END_DE").click(function(){
			alert( $("#BEGIN_DE").val());
			fnCalendarPopup('END_DE', $("#BEGIN_DE").val(), '2017-07-31');
		});	
		
		$("#btnAddDe").click(function(){
	        var newformgroup = $('#divDeTmp').html();
	        $('#divDe').append(newformgroup);
			
			
		});	
		
	});
	
	function f_add() {
		if(!fnCheckImg($('#FILE_NM'), 'BMP,GIF,JPG,JPEG,PNG')) {
			$('#FILE_NM').val('');
			return;
		}
		if($("#GOODS_NM").val() == '') {
			alert("상품이름은(는) 필수입력항목입니다.");
			focus.focus();
			return;
		}
		if(!fnCheckMaxLength("GOODS_NM", "상품이름")) return;

		form1.submit();	
	}
</script>
</head>
<body>
◆ 여행상품등록
<br><br>

<form id="form1" method="post" action="<c:url value='../addTourCl/'/>" enctype="multipart/form-data">
<table width="800" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
		<td width="25%">상품분류</td>
		<td width="75%"><c:forEach var="tourCl" items="${tourClList}" varStatus="status">
			<checkbox value="<c:out value='${tourCl.TOUR_CL_CODE}'/>"><c:out value='${tourCl.TOUR_CL_NM}'/></checkbox>
		</c:forEach></td>
	</tr>
	<tr>
		<td width="25%">상품명</td>
		<td width="75%"><input type="text" id="GOODS_NM" name="GOODS_NM" size="50" maxlength="200" title="상품이름"></td>
	</tr>	
	<tr>
		<td width="25%">상품설명</td>
		<td width="75%"><textarea id="CMPNY_INTRCN" name="CMPNY_INTRCN" cols="50" rows="10" title="상품설명"></textarea></td>
	</tr>	
	<tr>
		<td width="25%">구매가능 일정</td>
		<td width="75%">
		<div id="divDe">
			<input type="text" name="BEGIN_DE" id="BEGIN_DE" size="20" id="BEGIN_DE"> ~ <input type="text" name="END_DE" id="END_DE" size="20"> 
			<input type="button" value="추가" id="btnAddDe">
		</div>			
		</td>
	</tr>	
	<tr>
		<td width="25%">구매가능 시간</td>
		<td width="75%"></td>
	</tr>	
	<tr>
		<td width="25%">구매 인원</td>
		<td width="75%"></td>
	</tr>	
	<tr>
		<td width="25%">대표이미지</td>
		<td width="75%"><input type="file" id="FILE_NM" name="FILE_NM" size="50"></td>
	</tr>	
	<tr>
		<td width="25%">상품동영상</td>
		<td width="75%"><input type="file" id="FILE_NM" name="FILE_NM" size="50"></td>
	</tr>	
	<tr>
		<td width="25%">상품이미지</td>
		<td width="75%"><input type="file" id="FILE_NM" name="FILE_NM" size="50"></td>
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

<div id="divDeTmp">
	<br><input type="text" name="BEGIN_DE" id="BEGIN_DE" size="20" id="BEGIN_DE"> ~ <input type="text" name="END_DE" id="END_DE" size="20">
	<input type="button" value="삭제" id="btnDel">
</div>

</body>
</html>