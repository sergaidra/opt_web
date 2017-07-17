<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>분류등록</title>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/Common.js'/>"></script>
<script type="text/javascript">
	function f_add() {
		if(!fnCheckImg($('#FILE_NM'), 'BMP,GIF,JPG,JPEG,PNG')) {
			$('#FILE_NM').val('');
			return;
		}
		if($("#CL_NM").val() == '') {
			alert("분류이름은(는) 필수입력항목입니다.");
			focus.focus();
			return;
		}
		if(!fnCheckMaxLength("CL_NM", "분류이름")) return;

		form1.submit();	
	}
</script>
</head>
<body>
◆ 여행분류등록
<br><br>

<form id="form1" method="post" action="<c:url value='../addTourCl/'/>" enctype="multipart/form-data">
<table width="800" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
		<td width="25%">분류이름</td>
		<td width="75%"><input type="text" id="CL_NM" name="CL_NM" size="50" maxlength="200" title="분류이름"></td>
	</tr>
	<tr>
		<td width="25%">파일첨부</td>
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

</body>
</html>