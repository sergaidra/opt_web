<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>여행분류수정</title>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/siione2.js'/>"></script>
<script type="text/javascript">
	function f_mod() {
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

		form1.action = "<c:url value='../modTourCl/'/>";
		form1.submit();	
	}
	
	function f_del() {
		form1.action = "<c:url value='../delTourCl/'/>";
		form1.submit();
	}
	
	function f_list() {
		$(location).attr("href", "<c:url value='../tourClManage/'/>");
	}

	<c:if test="${success eq false}">
		alert("조회 중 오류 발생");
	</c:if>
</script>
</head>
<body>
◆ 여행분류수정
<br><br>
<form id="form1" method="post" action="<c:url value='../addTourCl/'/>" enctype="multipart/form-data">
<input type="hidden" id="CL_CODE" name="CL_CODE" value="<c:out value='${tourClInfo.CL_CODE}'/>">
<input type="hidden" id="FILE_CODE" name="FILE_CODE" value="<c:out value='${tourClInfo.FILE_CODE}'/>">
<input type="hidden" id="FILE_PATH" name="FILE_PATH" value="<c:out value='${fileList[0].FILE_PATH}'/>">

<table width="800" cellpadding="5" cellspacing="0" border="1" align="left" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
		<td width="25%">분류이름</td>
		<td width="75%"><input type="text" id="CL_NM" name="CL_NM" size="50" maxlength="200" title="분류이름" value="<c:out value='${tourClInfo.CL_NM}'/>"></td>
	</tr>
	<tr>
		<td width="25%">파일첨부</td>
		<td width="75%"><input type="file" id="FILE_NM" name="FILE_NM" size="50"></td>
	</tr>	
	<tr>
		<td>미리보기</td>
		<td><c:out value='${fileList[0].FILE_PATH}'/></td>
	</tr>
</table>

<table width="800" cellpadding="5" cellspacing="0" border="0" align="left" >
	<tr>
		<td width='100%' align="right">
		<c:if test="${tourClInfo.DELETE_AT == 'N'}">
			<input type="button" value="저장" onclick="f_mod()">
			<input type="button" value="삭제" onclick="f_del()">
		</c:if>
		<c:if test="${tourClInfo.DELETE_AT == 'N'}">
			<input type="button" value="취소" onclick="form1.reset();">
		</c:if>
		<c:if test="${tourClInfo.DELETE_AT == 'Y'}">			
			<input type="button" value="목록" onclick="f_list()">
		</c:if>
		</td>
	</tr>	
</table>
</form>
</body>
</html>