<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>

<head>
<link href="/css/jquery-ui.css" rel="stylesheet" type="text/css" media="screen"/>
<script src="/js/jquery-1.11.1.js"></script>
<script src="/js/jquery.blockUI.js"></script>
<script type="text/javascript">
/*
 * loading indicator show/hide
 */
function showLoading() {
	$.blockUI({
		overlayCSS:{
			backgroundColor:'#ffe',
			opacity: .5
		},
		css:{
			border:'none',
			opacity: .5,
			width:'80px',
			left:'45%'
		},
		message:"<img src='/images/loading_white.gif' width='80px'>"
	});
}

function hideLoading() {
	$.unblockUI();
}
</script>
<script type="text/javascript">
	function fnOpen(file_id, file_no) {
		var url = "<c:url value='/cmm/mediaPlayer/'/>?file_id="+file_id+"&file_no="+file_no;
		var name = "";
		var openWindows = window.open(url,name,"width=680,height=600,top=100,left=100,toolbar=no,status=no,location=no,scrollbars=yes,menubar=no,resizable=no");
		if (window.focus) {openWindows.focus()}
	}
	function fnYoutube(file_id, file_no) {
		var url = "<c:url value='/cmm/youtubePlayer/'/>";
		var name = "";
		var openWindows = window.open(url,name,"width=680,height=400,top=100,left=100,toolbar=no,status=no,location=no,scrollbars=yes,menubar=no,resizable=no");
		if (window.focus) {openWindows.focus()}
	}
	
	function fnUpload(){
		frm01.action = "<c:url value='/cmm/mediaUpload/'/>";
		showLoading();
		frm01.submit();		
	}

</script>
</head>
<body>
<form name="frm01" id="frm01" enctype="multipart/form-data" method="post" action="<c:url value='/cmm/mediaUpload/'/>">
	<table width="640px" border="1" cellspacing="0" cellpadding="0" height="100%" style="border-collapse:collapse; border:1px gray solid;"> 
		<tr>
			<th>FILE_CN</th>
			<td>
				<input type="text" name="FILE_CN" id="FILE_CN" size="50">
			</td>
			<td rowspan="2" align="center">
				<a href="javascript:fnUpload();">upload</a>
			</td>
		</tr>  
		<tr>
			<th>FILES</th>
			<td>
				<input type="file" id="FILES" name="FILES" style="width: 100%" multiple>
			</td>
		</tr>
	</table>
</form>
<br>
<a href="javascript:fnYoutube();">youtube</a>
<br><br>
<table width="640px" border="1" cellspacing="0" cellpadding="0" height="100%" style="border-collapse:collapse; border:1px gray solid;">
	<tr>
	<c:forEach var="result" items="${fileList}" varStatus="status">
		<td align="center">	
			<table width="20%" cellspacing="0" cellpadding="0">
			<tr>
				<td align="center">
					<a href="javascript:fnOpen('${result.FILE_ID}','${result.FILE_NO}');"><img src="<c:url value='/cmm/getThumbnail/'/>?file_id=${result.FILE_ID}&file_no=${result.FILE_NO}&thumb_no=" width="300"></a>
				</td>
			</tr>
			<tr>
				<td align="center" title="${result.FILE_NM}">
					${fn:substring(result.FILE_NM, 0, 15)}..
				</td>
			</tr>
			<tr>
				<td align="center" title="${result.FILE_CN}">
					${fn:substring(result.FILE_CN, 0, 15)}..
				</td>
			</tr>
			</table>
		</td>
<c:if test="${status.count%2 == 0}">
	</tr>
	<tr>
</c:if>	
	</c:forEach>
	</tr>
</table>

</body>
</html>