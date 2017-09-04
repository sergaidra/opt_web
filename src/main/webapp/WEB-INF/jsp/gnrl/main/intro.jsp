<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<!DOCTYPE html>
<body>
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
		<li>최상의 해안뷰 샹그릴라 리조트</li>
		<li>핑크빛 로맨틱 추억</li>
		<li>3박4일 무제한 골프여행</li>
		<li><a href="#">캐리비안 호핑투어</a></li>
		<li>캐리비안 호핑투어</li>
		<li class="btn_right"></li>
	</ul>

</div>

<div id="product_area">
	<ul>
		<li>
			<dl>
				<dt>
					모멘픽리조트
					<스톤마사지 +호핑선택> 4일/5일
				</dt>
				<dd>호핑선택시 스톤마사지 추가진행★</dd>
			</dl>
		</li>
		<li>
			<dl class="lst_second">
				<dt>
					가비/퍼시픽세부리조트 <스톤마사지 + 팡팡랜드> 4일/5일
				</dt>
				<dd>팡팡랜드 무료입장+전일정특식제공</dd>
			</dl>
		</li>
		<li>
			<dl class="lst_third">
				<dt>
					모멘픽리조트 <스톤마사지 +호핑선택> 4일/5일
				</dt>
				<dd>호핑선택시 스톤마사지 추가진행★</dd>
			</dl>
		</li>
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