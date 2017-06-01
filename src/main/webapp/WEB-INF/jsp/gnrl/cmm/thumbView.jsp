<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script type="text/javascript">
	function fnDelete(thumb_no) {
		frm01.thumb_no.value = thumb_no;
		frm01.action = "<c:url value='/cmm/thumbDelete/'/>";
		frm01.submit();
	}

	function fnReprsnt(thumb_no) {
		frm01.thumb_no.value = thumb_no;
		frm01.action = "<c:url value='/cmm/thumbReprsnt/'/>";
		frm01.submit();
	}
</script>
</head>
<body>
<form name="frm01" id="frm01" enctype="multipart/form-data" method="post" action="/cmm/thumbDelete/">
<input type="hidden" id="file_id" name="file_id" value="${file_id}">
<input type="hidden" id="file_no" name="file_no" value="${file_no}">
<input type="hidden" id="thumb_no" name="thumb_no">
</form>
<div align="center">
	<table>
		<tr>
		<c:forEach var="result" items="${thumbList}" varStatus="status">
			<td align="center">	
				<table cellspacing="0" cellpadding="0">
				<tr>
					<td align="center">
						<a href="javascript:parent.fnNext('${result.POSITION}');"><img src="<c:url value='/cmm/getThumbnail/'/>?file_id=${file_id}&file_no=${file_no}&thumb_no=${result.THUMB_NO}" width="${600/thumbCnt}"></a>
					</td>
				</tr>
				<tr>
					<td align="center">
						${result.TIME}
					</td>
				</tr>
				<tr>
					<td align="center">
					<c:choose>
						<c:when test="${result.REPRSNT_YN eq 'Y'}">
						대표이미지
						</c:when>
						<c:otherwise>
						<a href="javascript:fnDelete('${result.THUMB_NO}')">삭제</a> | <a href="javascript:fnReprsnt('${result.THUMB_NO}')">대표</a>
						</c:otherwise>
					</c:choose> 
					</td>
				</tr>
				</table>
			</td>
		</c:forEach>
		</tr>
	</table>
</div>

</body>
</html>