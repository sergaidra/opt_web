<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">
	function fnSearch() {
		var form = $("form[id=frmCategory]");
		var cateList = "";
		$("input:checkbox[id=chkCategory]:checked").each(function() {
			if(this.value == 'XXXXX') {
				cateList += "${clCodeStayng}@";
			} else {
				cateList += this.value + "@";	
			}
		});
		$("input:hidden[id=hidCategoryNavi]").val(cateList);
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
<div class="location">
	<p class="loc_area">홈<span class="arrow_loc"></span>투어상품</p>
</div>
<div class="yellowbar_area">
	<span class="yellowbar_txt">여러분이 원하는 모든것을 선택하세요.</span>
	<span id="btn_ok">확인</span>
	<div class="productlst_area">
		<ul>
			<c:forEach var="result" items="${tourList}" varStatus="status">
			<c:if test="${status.count%4 == 0}"><li class="pr_right"></c:if><c:if test="${status.count%4 != 0}"><li></c:if>
				<p class="pr_photo_area"><img src="<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}&file_sn=1" width="100%" height="100%"></p>
				<p class="pr_txt">${result.DC}<br/><span class="pr_tit">${result.CL_NM}</span></p>
				<p class="ch_box">
					<span><img src="<c:url value='/images/chbox.gif'/>" onClick="this.src=(this.src=='<c:url value='/images/chbox.gif'/>')?'<c:url value='/images/chbox.gif'/>':'<c:url value='/images/chbox_hover.gif'/>'; document.getElementsByName('my_num')[4].checked=(this.src=='<c:url value='/images/chbox_hover.gif'/>')?true:false;"></span>
				</p>
			</li><c:if test="${status.count%4 == 0}">
		</ul>
		<ul>
		</c:if></c:forEach>
		</ul>
	</div>
</div>
<div id="footer">
	<div class="area_footer">
		<ul class="f_nav">
			<li class="m_first">개인정보취급방침</li>
			<li>이용약관</li>
			<li>여행자약관</li>
			<li class="m_last">about onepasstour</li>
		</ul>
		<span class="txt_copyright">Copyright 2017 SⅡONE.CO.LTD. All Right Resesrved.</span>
	</div>
</div>