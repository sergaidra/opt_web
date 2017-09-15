<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>
<style type="text/css">
	.checkbox-wrap {
		cursor: pointer;
	}
	.checkbox-wrap .check-icon {
		display: inline-block;
		width: 20px;
		height: 19px;
		background: url(/images/chbox.gif) left center no-repeat;
		vertical-align: middle;
		transition-duration: .3s;
	}
	.checkbox-wrap input[type=checkbox] {
		display: none;
	}
	.checkbox-wrap input[type=checkbox]:checked+.check-icon {
		background-image: url(/images/chbox_hover.gif);
	}
</style>
<script type="text/javascript">
	function fnSearch() {
		var form = $("form[id=frmCategory]");
		var cateList = "";
		$("input:checkbox[id=chkCategory]:checked").each(function() {
			cateList += this.value + "@";	
		});
		$("input:hidden[id=hidUpperClCodeNavi]").val(cateList);
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}

	function fnCheck(cl_code) {
		var obj = $("input[type=checkbox][value*="+cl_code+"]")
		if(obj.is(":checked")){
			obj.prop('checked', false);	
		}else{
			obj.prop('checked', true);	
		}
	}
</script>
</head>
<body>
<div class="location">
	<p class="loc_area">
		홈<span class="arrow_loc"></span>투어상품
	</p>
</div>
<div class="yellowbar">
	<div class="yellowbar_area">
		<span class="yellowbar_txt">여러분이 원하는 모든것을 선택하세요.</span> 
		<a href="javascript:fnSearch();"><span id="btn_ok">확인</span></a>
	</div>
</div>
<form id="frmCategory" name="frmCategory" action="<c:url value='/goods/list/'/>">
<input type="hidden" id="hidUpperClCodeNavi" name="hidUpperClCodeNavi">
<div class="productlst_area">
	<ul>
	<c:forEach var="result" items="${upperTourClList}" varStatus="status">
	<c:if test="${status.count%4 == 0}"><li class="pr_right"></c:if><c:if test="${status.count%4 != 0}"><li></c:if>
		<p class="pr_photo_area"><a href="javascript:fnCheck('${result.CL_CODE}');"><img src="<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}&file_sn=1" width="100%" height="100%"></a></p>
		<p class="pr_txt">${result.DC}<br/><span class="pr_tit">${result.CL_NM}</span></p>
		<p class="ch_box">
			<label class="checkbox-wrap"><input type="checkbox" id="chkCategory" name="chkCategory" value="${result.CL_CODE}"><i class="check-icon"></i></label>
		</p>
	</li><c:if test="${status.count%4 == 0}">
	</ul>
	<ul>
	</c:if></c:forEach>
	</ul>
</div>
</form>
</body>