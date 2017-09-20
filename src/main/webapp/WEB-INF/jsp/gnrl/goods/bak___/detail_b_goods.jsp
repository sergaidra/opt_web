<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="<c:url value='/js/jquery.comiseo.daterangepicker.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/moment.min.js'/>"></script>
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
		$("input:hidden[id=hidUpperClCode]").val(cl_code);
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
		if("${stayngFcltyAt}" == "Y") {
			$("select[name=selNmprCo]").each(function() {
				payment += $("input:hidden[id="+ this.id +"]").val() * this.value;
			});
			payment = payment * parseInt($("#txtDateCount").val());
		} else {
			$("select[name=selNmprCo]").each(function() {
				payment += $("input:hidden[id="+ this.id +"]").val() * this.value;
			});
		}

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
			var strDate = $("input:text[id=hidChkinDe]").val();
			if(strDate.length!=10){
				alert("체크인 날짜를 선택하세요.");
				return;
			}

			strDate = $("input:text[id=hidChcktDe]").val();
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
					if(confirm("구매 조건이 수정되었습니다. 장바구니로 이동하시겠습니까?")) {
						fnList();
					} else {
						fnCartList();
					}
				} else if(json.result == "-2") {
					alert("로그인이 필요합니다.");
				} else if(json.result == "9") {
					alert(json.message);					
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
	<input type="hidden" id="hidUpperClCode" name="hidUpperClCode" value="${hidUpperClCode}">
	<input type="hidden" id="hidUpperClCodeNavi" name="hidUpperClCodeNavi" value="${hidUpperClCodeNavi}">
	<input type="hidden" id="hidStayngFcltyAt" name="hidStayngFcltyAt" value="${stayngFcltyAt}">
	<input type="hidden" id="hidWaitTime" name="hidWaitTime" value="${result.WAIT_TIME}">
	<input type="hidden" id="hidMvmnTime" name="hidMvmnTime" value="${result.MVMN_TIME}">
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
		<tr height="450px">
			<td align="center" colspan="3">
			<iframe src="<c:url value='/mngr/gmap/'/>?la=${result.ACT_LA}&lo=${result.ACT_LO}" width="100%" height="100%"></iframe>
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
			<td align="center" width="50%">
				체크인/체크아웃 날짜<br><br>
				<input type="hidden" name="hidChkinDe" id="hidChkinDe">
				<input type="hidden" name="hidChcktDe" id="hidChcktDe">
				<input type="text" id="txtDateRange" name="txtDateRange">
				<input type="text" id="txtDateCount" name="txtDateCount" style="width:40px;height:27px;text-align:center;font-size:15px;border: 0px solid" readonly onfocus="this.blur()">
				<script>
					$(function() {
						$("#txtDateRange").daterangepicker({
							initialText : '기간을 선택하세요.',
							applyButtonText: '선택', // use '' to get rid of the button
							clearButtonText: '초기화', // use '' to get rid of the button
							cancelButtonText: '취소', // use '' to get rid of the button
							dateFormat: 'yy-mm-dd',
							presetRanges: [],
							rangeSplitter: ' ~ ',
							applyOnMenuSelect: false,
							datepickerOptions : {
								numberOfMonths: 2,
								minDate: "${today}",
								maxDate: null
							}
						});

						$("#txtDateRange").on('change', function(event) {
							var __val =  jQuery.parseJSON($("#txtDateRange").val());
							$("#hidChkinDe").val(__val.start);
							$("#hidChcktDe").val(__val.end);

							var arr1 = __val.start.split('-');
							var arr2 = __val.end.split('-');

							var dat1 = new Date(parseInt(arr1[0]), parseInt(arr1[1])-1, parseInt(arr1[2]));
							var dat2 = new Date(parseInt(arr2[0]), parseInt(arr2[1])-1, parseInt(arr2[2]));

							var diff = dat2.getTime() - dat1.getTime() ;
							var currDay = 24 * 60 * 60 * 1000;

							$("#txtDateCount").val(diff/currDay + '박');
							
							fnNmprChange();
						});
					});
				</script>
			</td>
			</c:if>
			<td align="center" width="50%">
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