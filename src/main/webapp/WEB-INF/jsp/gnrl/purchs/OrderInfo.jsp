<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=0.1">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>원패스투어</title>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/layout.css'/>" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/content.css'/>" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/ay_com.css'/>" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/btn.css'/>" media="all">	
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/bbs.css'/>" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/mail.css'/>" media="all">
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

	<script src="<c:url value='/jq/pdf/bluebird.min.js' />" type="text/javascript"></script>
	<script src="<c:url value='/jq/pdf/html2canvas.min.js' />" type="text/javascript"></script>
	<script src="<c:url value='/jq/pdf/jspdf.min.js' />" type="text/javascript"></script>


</head>

<body>
<div id="wrap" class="mail_box">
	<div class="head_box"><img src="<c:url value='/images/mail/mail_a_01.jpg'/>" width="223" height="53" alt=""/>
		<div class="go_btn"><a href="javascript:savePDF();" class="btnst1">저장하기</a><a href="javascript:window.print();" class="btnst2">인쇄하기</a></div>
	</div>
	<div class="tb_box ">
		<c:forEach var="flight" items="${lstFlight}">
			<div class="tb_01_box">
				<table class="tb_01">
					<col width="20%">
					<col width="">
					<tbody>
					<tr>
						<td rowspan="2">출국</td>
						<td class="left">${flight.DTRMC_START_ARPRT_NM} &rarr; ${flight.DTRMC_ARVL_ARPRT_NM} (항공편명:${flight.DTRMC_FLIGHT})</td>
					</tr>
					<tr>
						<td class="left">[출발] ${flight.DTRMC_START_DT} [도착] ${flight.DTRMC_ARVL_DT}<br></td>
					</tr>
					<tr>
						<td rowspan="2">입국</td>
						<td class="left">${flight.HMCMG_START_ARPRT_NM} &rarr; ${flight.HMCMG_ARVL_ARPRT_NM} (항공편명:${flight.HMCMG_FLIGHT})</td>
					</tr>
					<tr>
						<td class="left">[출발] ${flight.HMCMG_START_DT} [도착] ${flight.HMCMG_ARVL_DT}<br></td>
					</tr>
					</tbody>
				</table>
			</div>
			<div class="sp_box1"></div>
		</c:forEach>
		<div class="tb_01_box">
			<table class="tb_01">
				<col width="15%">
				<col width="15%">
				<col width="">
				<tbody>
				<c:forEach var="item" items="${lstReservation}" varStatus="status1">
					<c:forEach var="list" items="${item.list}" varStatus="status2">
						<tr>
						<c:if test="${status2.index == 0}">
							<td rowspan='${fn:length(item.list)}'>${item.day}</td>
						</c:if>
						<td>${list.time}</td><td align="left">${list.text}</td>
						<td align="left">${list.options}</td>
						</tr>
					</c:forEach>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

	<c:forEach var="item" items="${lstReservation}" varStatus="status1">
	<c:forEach var="list" items="${item.list}" varStatus="status2">
	<div class="info_box">
		<div class="title">
			<i class="material-icons">&#xE147;</i>  <div class="tx"><em>여행일자 : </em>  ${item.day} ${list.time}</div>
		</div>
		<div class="sp_box1"></div>
		<div class="title">
			<i class="material-icons">&#xE147;</i>  <div class="tx" style="max-width:750px;"><em>${list.text} : </em> <c:out value="${fn:replace(list.options, '<br/>', ', ')}"/></div>
		</div>
		<%-- <c:if test="${list.purchs.PICKUP_PLACE != null }">
			<div class="sp_box1"></div>
			<div class="title">
				<i class="material-icons">&#xE147;</i>  <div class="tx"><em>픽업장소 : </em> ${list.purchs.PICKUP_PLACE}</div>
			</div>
		</c:if>
		<c:if test="${list.purchs.DROP_PLACE != null }">
			<div class="sp_box1"></div>
			<div class="title">
				<i class="material-icons">&#xE147;</i>  <div class="tx"><em>드랍장소 : </em> ${list.purchs.DROP_PLACE}</div>
			</div>
		</c:if>
		<c:if test="${list.purchs.USE_NMPR != null }">
			<div class="sp_box1"></div>
			<div class="title">
				<i class="material-icons">&#xE147;</i>  <div class="tx"><em>이용 인원 : </em> ${list.purchs.USE_NMPR}</div>
			</div>
		</c:if>
		<c:if test="${list.purchs.USE_PD != null }">
			<div class="sp_box1"></div>
			<div class="title">
				<i class="material-icons">&#xE147;</i>  <div class="tx"><em>이용 기간 : </em> ${list.purchs.USE_PD}</div>
			</div>
		</c:if> --%>
		<c:if test="${list.purchs.PICKUP_PLACE != null }">
			<div class="incont">
				<div class="stitle">픽업장소 : ${list.purchs.PICKUP_PLACE}</div> 
			</div>
		</c:if>		
		<c:if test="${list.purchs.DROP_PLACE != null }">
			<div class="incont">
				<div class="stitle">드랍장소 : ${list.purchs.DROP_PLACE}</div> 
			</div>
		</c:if>		
		<c:if test="${list.purchs.USE_NMPR != null }">
			<div class="incont">
				<div class="stitle">이용인원 : ${list.purchs.USE_NMPR}</div> 
			</div>
		</c:if>
		<c:if test="${list.purchs.USE_PD != null }">
			<div class="incont">
				<div class="stitle">이용기간 : ${list.purchs.USE_PD}</div> 
			</div>
		</c:if>		
		
		<div class="incont mb_20">
			<c:if test="${fn:length(list.goods.lstFile) > 0}">
			<c:set var="doneLoop" value="false"/>
			<c:forEach var="file" items="${list.goods.lstFile}" varStatus="status3">
				<c:if test="${not doneLoop}">
					<img src="<c:url value='/file/getImageThumb/'/>?file_code=${file.FILE_CODE}&file_sn=${file.FILE_SN}" width="300" height="225" alt=""/>
				</c:if>
				<c:if test="${status3.index == 1}">
					<c:set var="doneLoop" value="true"/>
				</c:if>
			</c:forEach>
			</c:if>
		</div>
		<div class="incont">${list.goods.GOODS_INTRCN}
		</div>
		<c:if test="${fn:length(list.goods.lstVoucher) > 0}">
		<!---->		
			<div class="sp_box1"></div>
			<div class="title">
				<i class="material-icons">&#xE147;</i>  <div class="tx"><em>바우처 : </em>  </div>
			</div>
			<c:forEach var="desc" items="${list.goods.lstVoucher}">
				<div class="incont">
					<div class="stitle">${desc.text}</div>
					<div class="inin">${desc.value} </div>
				</div>
			</c:forEach>
		<!---->		
		</c:if>
		<c:if test="${fn:length(list.goods.lstOpGuide) > 0}">
		<!---->		
			<div class="sp_box1"></div>
			<div class="title">
				<i class="material-icons">&#xE147;</i>  <div class="tx"><em>이용안내 : </em>  </div>
			</div>
			<c:forEach var="desc" items="${list.goods.lstOpGuide}">
				<div class="incont">
					<div class="stitle">${desc.text}</div>
					<div class="inin">${desc.value} </div>
				</div>
			</c:forEach>
		<!---->		
		</c:if>
		<c:if test="${fn:length(list.goods.lstEtcInfo) > 0}">
		<!---->		
			<div class="sp_box1"></div>
			<div class="title">
				<i class="material-icons">&#xE147;</i>  <div class="tx"><em>기타정보 : </em>  </div>
			</div>
			<c:forEach var="desc" items="${list.goods.lstEtcInfo}">
				<div class="incont">
					<div class="stitle">${desc.text}</div>
					<div class="inin">${desc.value} </div>
				</div>
			</c:forEach>
		<!---->		
		</c:if>
	</div>
	
	<c:if test="${!(status1.last and status2.last)}">
		<div class="line"></div>
	</c:if>
	
	</c:forEach>
	</c:forEach>	
 
</div>
<div id="blankImage" style="width:100%; height:10px; background:white;">
</div>
<!-- //본문 -->
<script>
var blankImage = null;
var blankWidth = null;
var blankHeight = null;
html2canvas(document.getElementById("blankImage"), {
	  onrendered: function(canvas) {
		  blankImage = canvas.toDataURL('image/png');
		  blankWidth = canvas.width;
		  blankHeight = canvas.height;
	  }
});

function savePDF() {
	html2canvas(document.getElementById("wrap"), {
		  onrendered: function(canvas) {
				 
			    // 캔버스를 이미지로 변환
			    var imgData = canvas.toDataURL('image/png');
			    var padding = 10;
			     
			    var imgWidth = 210; // 이미지 가로 길이(mm) A4 기준
			    var pageHeight = imgWidth * 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
			    var imgHeight = canvas.height * imgWidth / canvas.width;
			    var heightLeft = imgHeight;
			     
			        var doc = new jsPDF('p', 'mm');
			        var position = 0;
			         
			        // 첫 페이지 출력
			        doc.addImage(imgData, 'PNG', padding, padding, imgWidth - (padding * 2), imgHeight);
			        doc.addImage(blankImage, 'PNG', 0, pageHeight - blankHeight, blankWidth, blankHeight);
			        heightLeft -= (pageHeight - blankHeight * 3);
			         
			        // 한 페이지 이상일 경우 루프 돌면서 출력
			        while (heightLeft >= 0) {
			          position = heightLeft - imgHeight;
			          doc.addPage();
			          doc.addImage(imgData, 'PNG', padding, position, imgWidth - (padding * 2), imgHeight);
			          doc.addImage(blankImage, 'PNG', 0, 0, blankWidth, blankHeight);
			          doc.addImage(blankImage, 'PNG', 0, pageHeight - blankHeight, blankWidth, blankHeight);
			          heightLeft -= (pageHeight - blankHeight * 2);
			        }
			 
			        // 파일 저장
			        // 결제일자_대표여행자이름_결제번호.pdf
			        <c:if test="${purchs != null}">
				        doc.save('${purchs.PURCHS_DE}_${purchs.TOURIST_NM}_${purchs.PURCHS_SN}.pdf');
			        </c:if>
			        <c:if test="${purchs == null}">
			        	doc.save('Itinerary.pdf');
			        </c:if>
		  }
		});	
}
</script>	
</body>
</html>