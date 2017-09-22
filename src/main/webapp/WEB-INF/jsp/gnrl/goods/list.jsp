<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<head>
<script type="text/javascript">	
	window.onload = function(){
		$("#sboxClCode").change(function(){
			if($(this).val() == "0") {
				fnSearchUpperCl("${hidUpperClCode}");
			} else {
				fnSearchCl($(this).val());	
			}
		});

		$("#sboxCtyCode").change(function(){
			if($(this).children("option:selected").val() == "0") {
				fnSearchCty("");
			} else {
				fnSearchCty($(this).children("option:selected").val());	
			}
		});
	}

	function fnPage() {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidPage]").val(1);
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}
	
	function fnDetail(goods_code) {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidGoodsCode]").val(goods_code);
		form.attr({"method":"post","action":"<c:url value='/goods/detail/'/>"});
		form.submit();
	}
	
	function fnLinkPage(page){
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidPage]").val(page);
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}
	
	function fnSearchUpperCl(cl_code) {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidUpperClCode]").val(cl_code);
		$("input:hidden[id=hidClCode]").val('');
		$("input:hidden[id=hidPage]").val(1);
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}	

	function fnSearchCl(cl_code) {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidClCode]").val(cl_code);
		$("input:hidden[id=hidPage]").val(1);
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}
	
	function fnSearchCty(cty_code) {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidCtyCode]").val(cty_code);
		$("input:hidden[id=hidPage]").val(1);
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
		
	}
</script>
</head>
<body>
<form id="frmList" name="frmList" action="<c:url value='/goods/detail/'/>">
<input type="hidden" id="hidPage" name="hidPage" value="${hidPage}">
<input type="hidden" id="hidGoodsCode" name="hidGoodsCode">
<input type="hidden" id="hidCtyCode" name="hidCtyCode" value="${hidCtyCode}">
<input type="hidden" id="hidClCode" name="hidClCode" value="${hidClCode}">
<input type="hidden" id="hidUpperClCode" name="hidUpperClCode" value="${hidUpperClCode}">
<input type="hidden" id="hidUpperClCodeNavi" name="hidUpperClCodeNavi" value="${hidUpperClCodeNavi}">
	<div class="location">
		<p class="loc_area">
			홈<span class="arrow_loc"></span>투어상품
		</p>
	</div>
	<!--컨텐츠 시작-->
	<div class="infor_area">
		<!--result 탭시작-->
		<div id="result_set_02">
		<c:forEach var="result" items="${upperTourClList}" varStatus="status">
			<p class="line-left"></p>
			<c:if test="${result.CL_CODE eq hidUpperClCode}">
			<p class="rtab_selected">
				<a href="javascript:fnSearchUpperCl('${result.CL_CODE}');">${result.CL_NM}</a>
			</p>
			</c:if><c:if test="${result.CL_CODE ne hidUpperClCode}">
			<p class="rtab">
				<a href="javascript:fnSearchUpperCl('${result.CL_CODE}');">${result.CL_NM}</a>
			</p>
			</c:if>
		</c:forEach>
		<!--result 탭끝-->
		</div>
		<div class="whitebar">
			<span class="wbar_txt">총 ${fn:length(goodsList)}개의 상품이 검색되었습니다.</span>
			<fieldset>
				<select name="" class="wsh_sbox">
					<option value="0">정렬기준</option>
					<option value="ACOUNT_ASC">낮은가격순</option>
					<option value="ACOUNT_DESC">높은가격순</option>
				</select>
				<select name="sboxCtyCode" id="sboxCtyCode" class="wsh_sbox">
					<option value="0">도시선택</option>
					<c:forEach var="result" items="${ctyList}" varStatus="status">
					<option value="${result.CTY_CODE}" <c:if test="${result.CTY_CODE eq hidCtyCode}">selected</c:if>>#${result.CTY_NM}</option>
					</c:forEach>					
				</select>				
				<select name="sboxClCode" id="sboxClCode" class="wsh_sbox">
					<option value="0">상세분류</option>
					<c:forEach var="result" items="${tourClList}" varStatus="status">
					<option value="${result.CL_CODE}" <c:if test="${result.CL_CODE eq hidClCode}">selected</c:if>>#${result.CL_NM}</option>
					</c:forEach>					
				</select>					
				<legend>검색</legend>
				<div class="w_window">
					<input name="searchWrd" title="검색어 입력" class="winput_txt" type="text" size="35" value="" maxlength="35" onkeypress="press(event)">
				</div>
				<button tabindex="3" title="검색" class="wsch_smit" type="submit">
					<span class="blind"></span> <span class="ico_search_submit"></span>
				</button>
			</fieldset>
		</div>
		<!--rtab_01 시작-->
		<div class="rtab_01_area">
			<div class="resultlst_area">
			<c:forEach var="result" items="${goodsList}" varStatus="status">
				<c:if test="${status.index%2 == 0}"><ul></c:if>
					<li <c:if test="${status.index%2 == 1}">class="pr2_right"</c:if>>
						<p class="pr2_photo_area">
							<a href="javascript:fnDetail('${result.GOODS_CODE}');"><img src="<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}" width="200" height="160"></a>
						</p>
						<div class="pr2_rtxt_area">
							<p class="fl_left circle">A</p>
							<dl>
								<dt>
									<span class="p_head"><a href="javascript:fnDetail('${result.GOODS_CODE}');">${result.GOODS_NM}</a></span>
									<span class="p_like"><img src="/images/blt_wheart.gif" width="21" height="17"></span>
									<span class="p_sub">Shangri-La Mactan Resort</span>
									<div class="star_score_big">
										<span class="point40"><span class="blind">4점</span></span>
									</div>
								</dt>
								<dd>
									<span class="price_blank">&nbsp;</span>
									${result.CF_MIN_AMOUNT}<span class="txt_won">원</span>
								</dd>
							</dl>
						</div>
						<p class="category">${result.CTY_NM} > ${result.UPPER_CL_NM} > ${result.CL_NM}</p>
					</li>
				<c:if test="${status.index%2 == 1}"><ul></c:if>				
			</c:forEach>				
			</div>
		</div>
		<!--rtab영역 끝-->
	</div>
	<!--컨텐츠 끝-->
</form>	
</body>          