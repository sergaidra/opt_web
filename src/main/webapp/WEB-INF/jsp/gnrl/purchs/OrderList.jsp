<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<head>

<!-- 날짜선택 -->	
<script src="/jq/time/build/jquery.datetimepicker.full.js"></script> 

<script type="text/javascript">
$.datetimepicker.setLocale('en');

$('#datetimepicker_format').datetimepicker({value:'2015/04/15 05:03', format: $("#datetimepicker_format_value").val()});
$("#datetimepicker_format_change").on("click", function(e){
	$("#datetimepicker_format").data('xdsoft_datetimepicker').setOptions({format: $("#datetimepicker_format_value").val()});
});
$("#datetimepicker_format_locale").on("change", function(e){
	$.datetimepicker.setLocale($(e.currentTarget).val());
});

$('#datetimepicker').datetimepicker({
dayOfWeekStart : 1,
lang:'en',
disabledDates:['1986/01/08','1986/01/09','1986/01/10'],
startDate:	'1986/01/05'
});
$('#datetimepicker').datetimepicker({value:'2015/04/15 05:03',step:10});

$('.some_class').datetimepicker();

$('#default_datetimepicker').datetimepicker({
	formatTime:'H:i',
	formatDate:'d.m.Y',
	//defaultDate:'8.12.1986', // it's my birthday
	defaultDate:'+03.01.1970', // it's my birthday
	defaultTime:'10:00',
	timepickerScrollbar:false
});

$('#datetimepicker10').datetimepicker({
	step:5,
	inline:true
});
$('#datetimepicker_mask').datetimepicker({
	mask:'9999/19/39 29:59'
});

$('#datetimepicker1').datetimepicker({
	datepicker:false,
	format:'H:i',
	step:5
});
$('#datetimepicker2').datetimepicker({
	yearOffset:222,
	lang:'ch',
	timepicker:false,
	format:'d/m/Y',
	formatDate:'Y/m/d',
	minDate:'-1970/01/02', // yesterday is minimum date
	maxDate:'+1970/01/02' // and tommorow is maximum date calendar
});
$('#datetimepicker3').datetimepicker({
	inline:true
});
$('#datetimepicker4').datetimepicker();
$('#open').click(function(){
	$('#datetimepicker4').datetimepicker('show');
});
$('#close').click(function(){
	$('#datetimepicker4').datetimepicker('hide');
});
$('#reset').click(function(){
	$('#datetimepicker4').datetimepicker('reset');
});
$('#datetimepicker5').datetimepicker({
	datepicker:false,
	allowTimes:['12:00','13:00','15:00','17:00','17:05','17:20','19:00','20:00'],
	step:5
});
$('#datetimepicker6').datetimepicker();
$('#destroy').click(function(){
	if( $('#datetimepicker6').data('xdsoft_datetimepicker') ){
		$('#datetimepicker6').datetimepicker('destroy');
		this.value = 'create';
	}else{
		$('#datetimepicker6').datetimepicker();
		this.value = 'destroy';
	}
});
var logic = function( currentDateTime ){
	if (currentDateTime && currentDateTime.getDay() == 6){
		this.setOptions({
			minTime:'11:00'
		});
	}else
		this.setOptions({
			minTime:'8:00'
		});
};
$('#datetimepicker7').datetimepicker({
	onChangeDateTime:logic,
	onShow:logic
});
$('#datetimepicker8').datetimepicker({
	onGenerate:function( ct ){
		$(this).find('.xdsoft_date')
			.toggleClass('xdsoft_disabled');
	},
	minDate:'-1970/01/2',
	maxDate:'+1970/01/2',
	timepicker:false
});
$('#datetimepicker9').datetimepicker({
	onGenerate:function( ct ){
		$(this).find('.xdsoft_date.xdsoft_weekend')
			.addClass('xdsoft_disabled');
	},
	weekends:['01.01.2014','02.01.2014','03.01.2014','04.01.2014','05.01.2014','06.01.2014'],
	timepicker:false
});
var dateToDisable = new Date();
	dateToDisable.setDate(dateToDisable.getDate() + 2);
$('#datetimepicker11').datetimepicker({
	beforeShowDay: function(date) {
		if (date.getMonth() == dateToDisable.getMonth() && date.getDate() == dateToDisable.getDate()) {
			return [false, ""]
		}

		return [true, ""];
	}
});
$('#datetimepicker12').datetimepicker({
	beforeShowDay: function(date) {
		if (date.getMonth() == dateToDisable.getMonth() && date.getDate() == dateToDisable.getDate()) {
			return [true, "custom-date-style"];
		}

		return [true, ""];
	}
});
$('#datetimepicker_dark').datetimepicker({theme:'dark'})


</script>

<script type="text/javascript">

$(function(){	
});

</script>
</head>

<body>

<!-- 본문 -->
<div id="container">
  <div class="inner2">
    <div class="my_box01">
      <div class="info">
        <div class="photo"><img src="/images/com/me_photo.jpg" alt=""/></div>
        <div class="text"><em>홍길동 회원님</em><br>
          환영합니다.</div>
      </div>
      <div class="point">
        <div class="t1">포인트 <em>100,000 P</em></div>
        <div class="btn">자세히보기</div>
      </div>
      <div class="mymenu">
        <ul>
          <li class="on"><a href="#">
            <div class="img"><img src="/images/sub/my_icon01.png"  alt=""/></div>
            <div class="tx"> 결제목록</div>
            </a> </li>
          <li> <a href="#">
            <div class="img"><img src="/images/sub/my_icon02.png"  alt=""/></div>
            <div class="tx"> 취소목록</div>
            </a> </li>
          <li> <a href="#">
            <div class="img"><img src="/images/sub/my_icon03.png"  alt=""/></div>
            <div class="tx"> 찜목록</div>
            </a> </li>
          <li> <a href="javascript:document.location.href='/cart/list';">
            <div class="img"><img src="/images/sub/my_icon04.png"  alt=""/></div>
            <div class="tx"> 예약목록(장바구니)</div>
            </a> </li>
        </ul>
      </div>
    </div>
    <div class="order_search">
      <div class="s_box1">
        <div class="inbox">
          <div class="fl_t1">조회기간 선택</div>
          <div class="fl_t2">
            <input class="to-labelauty st_w2 input_w30" type="checkbox" data-labelauty="오늘" checked/>
            <input class="to-labelauty st_w2 input_w30" type="checkbox" data-labelauty="1주일" />
            <input class="to-labelauty st_w2 fl" type="checkbox" data-labelauty="15일"/>
            <input class="to-labelauty st_w2 fl" type="checkbox" data-labelauty="1개월"/>
            <input class="to-labelauty st_w2 fl" type="checkbox" data-labelauty="3개월"/>
            <input class="to-labelauty st_w2 fl" type="checkbox" data-labelauty="6개월"/>
            <input class="to-labelauty st_w2 fl" type="checkbox" data-labelauty="1년"/>
          </div>
        </div>
        <div class="inbox2">
          <div class="fl_t1">조회기간 선택</div>
          <div class="fl_t2">
            <div class="day_input">
              <input type="text" class="some_class" value="" id="some_class_1"/>
              <i class="material-icons">date_range</i> </div>
            <span>~</span>
            <div class="day_input">
              <input type="text" class="some_class" value="" id="some_class_2"/>
              <i class="material-icons">date_range</i></div>
          </div>
        </div>
        <div class="inbox3">
          <div class="fl_t1">통합검색</div>
          <div class="fl_t2">
            <select class="w_30p">
              <option>통합검색</option>
              <option>통합검색</option>
            </select>
            <input type="text"  value="" id="" class="w_60p"/>
          </div>
        </div>
      </div>
      <div class="s_box2">
        <div class="search_btn">조회하기</div>
      </div>
    </div>
    <div class="order_list">
      <div class="title">결제목록</div>
      <div class="tb_box">
        <div class="tb_05_box">
          <table width="100%" class="tb_05" >
            <col width="15%" />
            <col width="13%" />
            <col width="" />
            <col width="15%" />
            <col width="10%" />
            <col width="10%" />
            <thead>
              <tr>
                <th>이미지</th>
                <th>결제번호</th>
                <th>여행상품명</th>
                <th >인원수</th>
                <th >금액</th>
                <th >결제상태</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td class="left"><img src="/images/sub/ex1.jpg" width="150" alt=""/></td>
                <td >2014121111113<br />
                  <a href="#" class="big-link button white medium" data-reveal-id="myModal" ></a></td>
                <td class="left"><div class="tx1">[10/06~11/16]</div>
                  <div class="tx2">여행명이 나오는 곳입니다.</div>
                  <div class="tx3"> 옵션 : 아동2인 추가</div></td>
                <td >성인2명, 아동2인</td>
                <td class="right"><span class="point_color_b4">1,001,000원</span></td>
                <td >결제진행중<br>
                  <a href="#" class="sbtn_01">취소하기</a></td>
              </tr>
              <tr>
                <td class="left"><img src="/images/sub/ex1.jpg" width="150" alt=""/></td>
                <td >2014121111113<br />
                  <a href="#" class="big-link button white medium" data-reveal-id="myModal" ></a></td>
                <td class="left"><div class="tx1">[10/06~11/16]</div>
                  <div class="tx2">여행명이 나오는 곳입니다.</div>
                  <div class="tx3"> 옵션 : 아동2인 추가</div></td>
                <td >성인2명, 아동2인</td>
                <td class="right"><span class="point_color_b4">1,001,000원</span></td>
                <td >결제진행중<br>
                  <a href="#" class="sbtn_01">취소하기</a></td>
              </tr>
              <tr>
                <td class="left"><img src="/images/sub/ex1.jpg" width="150" alt=""/></td>
                <td >2014121111113<br />
                  <a href="#" class="big-link button white medium" data-reveal-id="myModal" ></a></td>
                <td class="left"><div class="tx1">[10/06~11/16]</div>
                  <div class="tx2">여행명이 나오는 곳입니다.</div>
                  <div class="tx3"> 옵션 : 아동2인 추가</div></td>
                <td >성인2명, 아동2인</td>
                <td class="right"><span class="point_color_b4">1,001,000원</span></td>
                <td >결제진행중<br>
                  <a href="#" class="sbtn_01">취소하기</a></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <!--페이징 -->
      <div class="bbs_bottom"> 
        <div class="paginate">
          <div class="number"><a href="#" class="pre_end">← First</a><a href="#" class="pre">이전</a><a href="#">11</a><a href="#" class="on">12</a><a href="#">13</a><a href="#">14</a><a href="#">15</a><a href="#">16</a><a href="#">17</a><a href="#">18</a><a href="#">19</a><a href="#">20</a><a href="#" class="next">다음</a><a href="#" class="next_end">Last → </a> </div>
        </div>
      </div>
      <!--//페이징 --> 
    </div>
  </div>
</div>

<!-- //본문 -->
</body>
