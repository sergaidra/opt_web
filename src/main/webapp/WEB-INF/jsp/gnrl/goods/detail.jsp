<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">

	window.onload = function(){

	}

	function fnList() {
		var form = $("form[id=frmDetail]");
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}

	function fnSearch(cl_code) {
		var form = $("form[id=frmDetail]");
		$("input:hidden[id=hidCategory]").val(cl_code);
		$("input:hidden[id=hidPage]").val(1);
		form.attr({"method":"post","action":"<c:url value='/goods/list/'/>"});
		form.submit();
	}

	function fnTimeClick(){
		$("input:radio[name=rdoTime]").each(function() {
			if($(this).is(":checked")) {
				$("input:hidden[id=hidTime]").val($(this).val());
				$("input:text[id=txtTime]").val($(this).val().substring(0,2) + ":" + $(this).val().substring(2,4) + " ~ " + $(this).val().substring(4,6) + ":" + $(this).val().substring(6,8));
			}
		});
	}

	function fnNmprChange(){
		var form = $("form[id=frmDetail]");

		var payment = 0;
		$("select[name=selNmprCo]").each(function() {
			payment += $("input:hidden[id="+ this.id +"]").val() * this.value;
		});

		$("input:text[id=txtPay]").val("₩ "+payment);
	}

	function fnAddCart(){
		
		if("${stayngFcltyAt}" == "N") {
			var strDate = $("input:text[id=txtDate]").val();
			if(strDate.length!=10){
				alert(strDate);
				return;
			}	
		} else if("${stayngFcltyAt}" == "N") {
			var strDate = $("input:text[id=txtChkinDe]").val();
			if(strDate.length!=10){
				alert("체크인 날짜를 선택하세요.");
				return;
			}
			
			strDate = $("input:text[id=txtChcktDe]").val();
			if(strDate.length!=10){
				alert("체크아웃 날짜를 선택하세요.");
				return;
			}
			
			var chkTimeVal = $("input:radio[name=rdoTime]:checked").val();
			if(!chkTimeVal) {
				alert("시간을 선택하세요");
				return;
			}			
		}

		var totCo = 0;
		$("select[name=selNmprCo]").each(function() {
			totCo+=this.value
		});
		if(totCo < 1){
			alert("인원을 입력하세요");
			return;
		}
		
		var form_data = $("form[id=frmDetail]").serialize();

		$.ajax({
			url : "<c:url value='/cart/addAction/'/>",
			dataType : "json",
			type : "POST",
			async : true,
			data : form_data,
			beforeSend:function(){
				showLoading();
			},
			success : function(json) {
				if(json.result == "0") {
					alert("장바구니에 추가되었습니다.");
					fnCartList();
				} else if(json.result == "-2") {
					alert("로그인이 필요합니다.");
				} else{
					alert("작업을 실패하였습니다.");
				}
			},
			complete:function() {
				hideLoading();
			},
			error : function() {
				alert("오류가 발생하였습니다.");
			}
		});
	}

</script>
<div align="center">
	<form id="frmDetail" name="frmDetail" method="post" action="<c:url value='/goods/list/'/>">
	<input type="hidden" id="hidPage" name="hidPage" value="${hidPage}">
	<input type="hidden" id="hidGoodsCode" name="hidGoodsCode" value="${goods_code}">
	<input type="hidden" id="hidCategory" name="hidCategory" value="${hidCategory}">
	<table width="1024px" border="1" cellspacing="0" cellpadding="0" height="100%" style="border-collapse:collapse; border:1px gray solid;">
		<tr height="100px">
			<td align="center" colspan="3">
				${result.GOODS_NM}
			</td>
		</tr>
		<tr height="150px">
			<td align="center" colspan="3">
				<p>${result.GOODS_INTRCN}</p>
			</td>
		</tr>
		<tr height="430px">
			<td align="center" colspan="3">
			<iframe src="<c:url value='/file/imageListIframe/'/>?file_code=${result.FILE_CODE}" width="100%" height="100%"></iframe>
			</td>
		</tr>
		<tr height="80px">
			<td align="center" colspan="3">
				<c:forEach var="list" items="${clList}" varStatus="status">
				<a href="javascript:fnSearch('${list.CL_CODE}');">#${list.CL_NM}</a>&nbsp;&nbsp;&nbsp;
				</c:forEach>
			</td>
		</tr>
		<tr height="200px">
			<c:if test="${stayngFcltyAt eq 'N'}">
			<td align="center" width="33%">
				<c:forEach var="list" items="${schdulList}" varStatus="status">
				${fn:substring(list.BEGIN_DE,0,4)}. ${fn:substring(list.BEGIN_DE,4,6)}. ${fn:substring(list.BEGIN_DE,6,8)} ~
				${fn:substring(list.END_DE,0,4)}. ${fn:substring(list.END_DE,4,6)}. ${fn:substring(list.END_DE,6,8)}
				&nbsp;&nbsp;&nbsp;
				<a href="javascript:fnCalendarPopup('txtDate','${list.BEGIN_CAL_DE}','${list.END_CAL_DE}')">예약일 선택</a>
				<br><br>
				</c:forEach>
				<input type="text" name="txtDate" id="txtDate" style="width:250px;height:50px;text-align:center;font-size:25px;" value="일정을 선택하세요" readonly onfocus="this.blur()">
			</td>
			<td align="center" width="34%">
				<c:forEach var="list" items="${timeList}" varStatus="status">
				<input type="radio" name="rdoTime" id="rdoTime_${status.count}" value="${list.TOUR_TIME}" onclick="fnTimeClick()">
				<label for="rdoTime_${status.count}">${fn:substring(list.BEGIN_TIME,0,2)} : ${fn:substring(list.BEGIN_TIME,2,4)} ~
				${fn:substring(list.END_TIME,0,2)} : ${fn:substring(list.END_TIME,2,4)}</label>
				&nbsp;&nbsp;&nbsp;
				<br><br>
				</c:forEach>
				<input type="text" name="txtTime" id="txtTime" style="width:250px;height:50px;text-align:center;font-size:25px;" value="시간을 선택하세요" readonly onfocus="this.blur()">
				<input type="hidden" name="hidTime" id="hidTime">
			</td>
			</c:if>
			<c:if test="${stayngFcltyAt ne 'N'}">
			<td align="center" width="33%">
				체크인 날짜<br><br>
				<input type="text" name="txtChkinDe" id="txtChkinDe" style="width:250px;height:50px;text-align:center;font-size:25px;" value="날짜를 선택하세요" readonly onfocus="this.blur()" onclick="fnCalendarPopup('txtChkinDe','${today}','${list.END_CAL_DE}')">
			</td>			
			<td align="center" width="34%">
				체크아웃 날짜<br><br>
				<input type="text" name="txtChcktDe" id="txtChcktDe" style="width:250px;height:50px;text-align:center;font-size:25px;" value="날짜를 선택하세요" readonly onfocus="this.blur()" onclick="fnCalendarPopup('txtChcktDe','${today}','${list.END_CAL_DE}')">
			</td>
			</c:if>			
			<td align="center" width="33%">
				<c:forEach var="list" items="${nmprList}" varStatus="status">
				${list.NMPR_CND} (₩ ${list.SETUP_AMOUNT})
				<select name="selNmprCo" id="txtNmprCo${list.NMPR_SN}" onchange="fnNmprChange()">
					<c:forEach var="i" begin="0" end="10" step="1">
						<option value="${i}" <c:if test="${i == '0'}">selected="selected"</c:if>>${i}</option>
					</c:forEach>
				</select>
				<input type="hidden" name="hidPayment" id="txtNmprCo${list.NMPR_SN}" value="${list.SETUP_AMOUNT}">
				<input type="hidden" name="hidNmprSn" id="hidNmprSn" value="${list.NMPR_SN}">
				<br><br>
				</c:forEach>

				<input type="text" name="txtPay" id="txtPay" style="width:250px;height:50px;text-align:center;font-size:25px;" value ="인원을 입력하세요" readonly onfocus="this.blur()">
			</td>
		</tr>
	</table>
	</form>
</div>

<div style="height:100px;" align="center">
	<p style="vertical-align:middle;">
		<a href="javascript:fnList()">상품 목록</a>&nbsp;&nbsp;&nbsp;
		<a href="javascript:fnAddCart()">장바구니 추가</a>
	</p>
</div>