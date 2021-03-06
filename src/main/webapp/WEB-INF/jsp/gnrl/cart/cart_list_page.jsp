<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<script type="text/javascript">	
	function fnPage() {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidPage]").val(1);
		form.attr({"method":"post","action":"<c:url value='/cart/list/'/>"});
		form.submit();
	}
	
	function fnDetail(cart_sn) {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidCartSn]").val(cart_sn);
		form.attr({"method":"post","action":"<c:url value='/cart/detail/'/>"});
		form.submit();
	}

	function fnDeleteCart(cart_sn) {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidCartSn]").val(cart_sn);
		form.attr({"method":"post","action":"<c:url value='/cart/delAction/'/>"});
		form.submit();
	}

	function fnLinkPage(page){
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidPage]").val(page);
		form.attr({"method":"post","action":"<c:url value='/cart/list/'/>"});
		form.submit();
	}

	function fnCalendar(){
		var popNm = "popCalendar";
		var valUrl = "<c:url value='/cart/calendarPopup/'/>";
		var strStatus = "width=800,height=600,toolbar=no,status=no,scrollbars=yes,resizable=yes";
		var debugWin = window.open(valUrl, popNm, strStatus);
		debugWin.focus();
	}

	function fnSchedule() {
		var popNm = "popSchedule";
		var valUrl = "<c:url value='/cart/schedulePopup/'/>";
		var strStatus = "width=1024,height=768,toolbar=yes,status=yes,scrollbars=yes,resizable=yes";
		var debugWin = window.open(valUrl, popNm, strStatus);
		debugWin.focus();
	}
	
	function fnPurchase(){
	}
	
	function fnSearchGoods() {
		var form = $("form[id=frmGoodsCategory]");
		form.submit();
	}

</script>
<div align="center">
	<form id="frmList" name="frmList" action="<c:url value='/cart/detail/'/>">
	<input type="hidden" id="hidPage" name="hidPage" value="${hidPage}">
	<input type="hidden" id="hidCartSn" name="hidCartSn">
	<table width="1024px" border="1" cellspacing="0" cellpadding="0" height="100%" style="border-collapse:collapse; border:1px gray solid;">
		<tr>
		<c:if test="${fn:length(list) == 0}">
			<td height="100px" align="center">조회된 결과가 없습니다.</td>
		</c:if>
		<c:forEach var="result" items="${list}" varStatus="status">
			<td align="center">	
				<table cellspacing="0" cellpadding="0">
				<tr>		
					<td width="200px" align="center" rowspan="5">
						<a href="javascript:fnDetail('${result.CART_SN}');"><img src="<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}" width="200px" height="150px"></a>
					</td>
					<td width="800px" align="center" title="${result.GOODS_NM}">
						${fn:substring(result.GOODS_NM, 0, 15)}..
					</td>
				</tr>
				<tr>
					<td width="800px" align="center" title="${result.PURCHS_AMOUNT}">
						₩ ${result.PURCHS_AMOUNT}
					</td>
				</tr>
				<tr>
					<td width="800px" align="center">
					<c:if test="${!empty result.TOUR_DE}">
						예정일 : ${fn:substring(result.TOUR_DE,0,4)}. ${fn:substring(result.TOUR_DE,4,6)}. ${fn:substring(result.TOUR_DE,6,8)}
					</c:if>
					<c:if test="${!empty result.CHKIN_DE}">
						숙박일정 : ${fn:substring(result.CHKIN_DE,0,4)}. ${fn:substring(result.CHKIN_DE,4,6)}. ${fn:substring(result.CHKIN_DE,6,8)} ~ ${fn:substring(result.CHCKT_DE,0,4)}. ${fn:substring(result.CHCKT_DE,4,6)}. ${fn:substring(result.CHCKT_DE,6,8)}
					</c:if>					
					</td>
				</tr>
				<tr>
					<td width="800px" align="center">
					<c:if test="${!empty result.BEGIN_TIME}">
						예정시간 : ${fn:substring(result.BEGIN_TIME,0,2)}:${fn:substring(result.BEGIN_TIME,2,4)} ~ ${fn:substring(result.END_TIME,0,2)}:${fn:substring(result.END_TIME,2,4)}
					</c:if>
					</td>
				</tr>

				<tr>
					<td width="800px" align="center">
						<a href="javascript:fnDeleteCart('${result.CART_SN}')">삭제</a>
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
	</form>
</div>

<div style="height:100px;" align="center">
	<p style="vertical-align:middle;">
		<ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fnLinkPage"/>
	</p>
</div>


<div align="center">
	<table width="1024px" cellspacing="0" cellpadding="30" style="border-collapse:collapse; border:1px gray solid;">
		<tr height="200px">
			<td width="40%" valign="top">
				<div align="left" style="font-size:20px">
					<b>결제예정금액</b>
				</div><br><br>
				<div id="divCount" align="center" id="divPay" style="font-size:15px">
					총 ${payCount}개의 제품
				</div>
			</td>
			<td width="30%">
				<div id="divPay" align="left" style="font-size:40px">₩ ${payment}</div>
			</td>
			<td width="30%" align="center">
				<a href="javascript:fnSchedule()">일정표 보기</a><br><br>
				<a href="javascript:fnPurchase()">구매진행</a>
			</td>
		</tr>
	</table>
</div>

<form name="frmGoodsCategory" id="frmGoodsCategory" method="post" action="<c:url value='/goods/list/'/>">
	<input type="hidden" id="hidStayngFcltyAt" name="hidStayngFcltyAt" value="Y">
</form>
