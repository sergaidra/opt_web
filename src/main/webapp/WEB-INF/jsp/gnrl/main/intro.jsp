<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<head>
<script type="text/javascript">
	$(document).ready(function(){
 		$("#sub_nav > ul > li > a").hover(function(){
			$("#sub_nav > ul > li").each(function(){
				$(this).removeClass("banner_selected").addClass("banner");
			});
			$(this).parent().removeClass("banner").addClass("banner_selected");
		});
	});
</script>
</head>
<body>
<form id="frmList" name="frmList" action="<c:url value='/goods/detail/'/>">
<input type="hidden" id="hidGoodsCode" name="hidGoodsCode">
</form>
<div class="area_photo">
	<div class="area_search">
		<h2>
			<img src="<c:url value='/images/main_headline.png'/>">
		</h2>
		<fieldset>
			<legend>검색</legend>
			<div class="yellow_window">
				<input name="searchWrd" title="검색어 입력" class="input_txt" type="text" size="35" value="가고 싶은 투어, 여행지, 액티비티 검색어를 입력하세요" maxlength="35" onkeypress="press(event)">
			</div>
			<button tabindex="3" title="검색" class="sch_smit" type="submit">
				<span class="blind"></span> <span class="ico_search_submit"></span>
			</button>
			<!--<span><a href='#' class="sch_smit">성공</a></span>-->
		</fieldset>
	</div>
</div>

<div id="sub_nav">
	<ul>
		<li class="btn_left"></li>
		<c:forEach var="list" items="${expsrList1}" varStatus="status">
		<c:choose>
			<c:when test="${status.index == 0}">
				<li class="banner_selected"><a href="javascript:fnGoGoodsDetail('<c:out value="${list.GOODS_CODE}" />');"><c:out value="${list.GOODS_NM}" /></a></li>
			</c:when>
			<c:when test="${status.index < 5}">
				<li class="banner"><a href="javascript:fnGoGoodsDetail('<c:out value="${list.GOODS_CODE}" />');"><c:out value="${list.GOODS_NM}" /></a></li>
			</c:when>
		<c:otherwise>
		</c:otherwise>
		</c:choose>
		</c:forEach>
		<c:if test="${fn:length(expsrList1) < 5}">
			<c:forEach begin="${4-fn:length(expsrList1)}" end="${fn:length(expsrList1)-1}" var="cnt">
				<li class="banner"></li>
			</c:forEach>
		</c:if>
		<li class="btn_right"></li>
	</ul>
</div>
<div id="product_area">
	<ul>
		<c:forEach var="list" items="${expsrList2}" varStatus="status">
		<li>
			<c:if test="${status.index == 0}"><dl></c:if>
			<c:if test="${status.index == 1}"><dl class="lst_second"></c:if>
			<c:if test="${status.index == 2}"><dl class="lst_third"></c:if>
				<dt>
					<a href="javascript:fnGoGoodsDetail('<c:out value="${list.GOODS_CODE}" />');"><c:out value="${list.GOODS_NM}" /></a>
				</dt>
				<dd>
					<c:out value="${fn:substring(list.GOODS_INTRCN, 0, 30)}" />
				</dd>
			</dl>
		</li>	
		</c:forEach>
		<li class="lst_contact"><span class="txt_head">고객센터 대표번호
				1588-0000<br />(해외 82-2-0000-0000)
		</span><br /> <span class="txt_contact">서울시 종로구 평창 30길 27, 2F<br />
				T. 070-7655-5003&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; F.
				070-7655-5003<br /> e-mail. customer@onepasstour.com
		</span></li>
	</ul>
</div>
</body>
</html>