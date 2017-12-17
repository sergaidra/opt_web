// INIT
;(function($, window, document, undefined) {
	'use strict';

	// helpers
	function _id(e) { return document.getElementById(e); }
	function _e(e) { return document.querySelector(e); }
	function _ee(e) { return document.querySelectorAll(e); }
	function _for(e,f) { var i, len=e.length; for(i=0;i<len;i++){ f(e[i]); }}
	function log(e, before) { before=before||''; console.log(before+e); }
	function _hasClass(el, selector) { var className = " " + selector + " "; if ((" " + el.className + " ").replace(/[\n\t]/g, " ").indexOf(className) > -1) { return true;  } else { return false; }}
	
	
	// user select/click action
	function userSelect(e,main,month,year){
		
		var sel1 = _id('sel1'),
			sel2 = _id('sel2');
		
		var isDisabled = _hasClass(e, 'disabled');
			
		// first doesnt exist
		if( selectDt.startDt === null && !isDisabled ) {
			e.id = 'sel1';
			e.classList.add('sel1');
			$(e).parent().prevAll('tr').find('td').addClass('disabled'); // ugly code
			$(e).prevAll('td').addClass('disabled'); // ugly code
			//log('select second option');
			
			// temp
			if( _id('out1') === null ) { $('#cal').after('<i id="out1"></i>'); }
			//_id('out1').innerHTML = '<div class=tt1>출발</div>  ' + e.innerText + '/' + month + '/' + year;
			//_id('sel1text').innerHTML = e.innerText + '-' + month + '-' + year;
			_id('sel1text').innerHTML = year + '-' + lpad(month.toString(), 2, "0") + '-' + lpad(e.innerText, 2, "0");
			selectDt.startDt = year + '-' + lpad(month.toString(), 2, "0") + '-' + lpad(e.innerText, 2, "0");
			selectDt.startYear = year;
			selectDt.startMonth = month;
			selectDt.startDay = e.innerText;
			
			var day = Number(e.innerText);
			var dtEndDay = new Date(year, month-1, day);
			dtEndDay.setDate(day + tour_days);
			var endYear = dtEndDay.getFullYear();
			var endMonth = dtEndDay.getMonth() + 1;
			var endDay = dtEndDay.getDate();

			_id('sel2text').innerHTML = String(endYear) + '-' + lpad(endMonth.toString(), 2, "0") + '-' + lpad(String(endDay), 2, "0");
			selectDt.endDt = String(endYear) + '-' + lpad(endMonth.toString(), 2, "0") + '-' + lpad(String(endDay), 2, "0");
			selectDt.endYear = endYear;
			selectDt.endMonth = endMonth;
			selectDt.endDay = endDay;

			var par = e.parentNode,			// tr
			parPar = par.parentNode;	// tbody (main)			
			var td = parPar.querySelectorAll('td');
			
			if(month == dtEndDay.getMonth() + 1) {
				_for(td, function(e){
					if(!e.classList.contains('disabled')) {
						if (e.innerText == String(endDay)){
							e.id = 'sel2';
							e.classList.add('sel2');
						}
					}				
				});			
				
				var isStartSel1 = false;
				var isEndSel1 = false;
				_for(td, function(e){
					if(!e.classList.contains('disabled')) {
						if (e.id == 'sel1'){
							isStartSel1 = true;
						} else if (e.id == 'sel2'){
							isEndSel1 = true;
						} else {
							if(isStartSel1 && !isEndSel1) {
								e.classList.add('range');
							}
						}
					}
				
				});			
			} else {
				var isStartSel1 = false;
				_for(td, function(e){
					if(!e.classList.contains('disabled')) {
						if (e.id == 'sel1'){
							isStartSel1 = true;
						} else {
							if(isStartSel1) {
								e.classList.add('range');
							}
						}
					}
				
				});			
			}
			
		}
	
		// both selections exist
		else {
			var td = e.parentNode.parentNode.querySelectorAll('td');
			_for(td, function(e){ e.classList.remove('range','disabled'); });
			_for(td, function(e){ 
				if(e.classList.contains('stop')) {
					e.classList.add("disabled");
				}
			});
			
			if(sel1 != null) {
				sel1.removeAttribute('class');
				sel1.removeAttribute('id');
			}
			if(sel2 !== null){
				sel2.removeAttribute('class');
				sel2.removeAttribute('id');
			}

			_id('sel1text').innerHTML = "날짜선택";
			_id('sel2text').innerHTML = "날짜선택";
			
			selectDt.startDt = null;
			selectDt.endDt = null;
		} //end else/if
		
		setDateRange();
	} //userSelect(e);

	

	
	
	
	
	
	
	
	
	
	
	/*-----------------------------------------------------
		
		GET MONTH DATA
		
	-----------------------------------------------------*/

	function getMonth(month, year){
	
		/* Expects month to be in 1-12 index based. */
		var monthInformation = function(year, month){
				/* Create a date. Usually month in JS is 0-11 index based but here is a hack that can be used to calculate total days in a month */
				var date = new Date(year, month, 0);
				/* Get the total number of days in a month */
				this.totalDays = date.getDate();
				/* End day of month. Like Saturday is end of month etc. 0 means Sunday and 6 means Saturday */
				this.endDay = date.getDay();
				date.setDate(0);
				/* Start day of month. Like Saturday is start of month etc. 0 means Sunday and 6 means Saturday */
				this.startDay = date.getDay();
				/* Here we generate days for 42 cells of a Month */
				var days = new Array(42);
				/* Here we calculate previous month dates for placeholders if starting day is not Sunday */
				var prevMonthDays = 0;
				var prevMonth = new Date(year, month, 0);
				//prevMonth.setMonth(prevMonth.getMonth() - 1);
				var firstDayOfMonth = new Date(year, month - 1, 1);
				prevMonth = new Date(firstDayOfMonth.setDate(firstDayOfMonth.getDate() - 1));
				if(this.startDay !== 0) prevMonthDays  = prevMonth.getDate() - this.startDay;
				/* This is placeholder for next month. If month does not end on Saturday, placeholders for next days to fill other cells */
				var count = 0;
				// 42 = 7 columns * 6 rows. This is the standard number. Verify it with any standard Calendar
				for(var i = 0; i < 42; i += 1) {
						var day = {};
						/* So start day is not Sunday, so we can display previous month dates. For that below we identify previous month dates */
						if(i < this.startDay) {
								day.date = (prevMonthDays = prevMonthDays + 1);
						/* belong to next month dates. So, month does not end on Saturday. So here we get next month dates as placeholders */
						} else if(i > this.totalDays + (this.startDay - 1)) { 
								day.date = (count = count + 1);
						/* belong to current month dates. */    
						} else {
								day.date = (i - this.startDay) + 1;
						}
						days[i] = day.date;
				}
				this.days = days;
		};


		/* Usage below */
		var m = {};
		monthInformation.call(m, year, month);


			var days = m.days,
					startDay = m.startDay,
					endDay = m.endDay,
					totalDays = m.totalDays,
					len = days.length,
					key, str = '', i=0,
					t = $('#t');

			//console.clear();
			//console.log(m);
			str += '<table class=daytb>';
			str += '<thead><tr><td>월</td><td>화</td><td>수</td><td>목</td><td>금</td><td>토</td><td>일</td></tr></thead><tbody>';
			for(key in days){
				i++;

				if(i === 1) str += '<tr>';
				
				if( key < startDay || key > totalDays + startDay - 1 ) { 
					str += '<td class="notCurMonth disabled stop"><i class="disabled stop">'+days[key]+'</i></td>'; 
				} else {
					var isOk = false;
					var curDt = String(year) + lpad(String(month), 2, "0") + lpad(days[key]+"", 2, "0");
					var curDt2 = String(year) + "-" + lpad(String(month), 2, "0") + "-" + lpad(days[key]+"", 2, "0");
					var curToday = getToday();
					for(var cnt = 0; cnt < lstSchdul.length; cnt++) {
						if(curDt < curToday)
							continue;
						//console.log(lstSchdul[cnt].BEGIN_DE + "-" + lstSchdul[cnt].END_DE + "-" + curDt);
						if(lstSchdul[cnt].BEGIN_DE <= curDt && curDt <= lstSchdul[cnt].END_DE ) {
							isOk = true;
							break;
						}
					}
					if(isOk == true) {
						if(selectDt.startDt != null && selectDt.endDt != null) {
							if(curDt2 == selectDt.startDt) {
								str += '<td class="sel1" id="sel1"><i>'+days[key]+'</i></td>';
							} else if(curDt2 == selectDt.endDt) {
								str += '<td class="sel2" id="sel2"><i>'+days[key]+'</i></td>';
							} else if(curDt2 > selectDt.startDt && curDt2 < selectDt.endDt) {
								str += '<td class="range"><i>'+days[key]+'</i></td>';
							} else {
								str += '<td><i>'+days[key]+'</i></td>';						
							}
						} else if(selectDt.startDt != null) {
							if(curDt2 == selectDt.startDt) {
								str += '<td class="sel1" id="sel1"><i>'+days[key]+'</i></td>';
							} else {
								str += '<td><i>'+days[key]+'</i></td>';						
							}
						} else if(selectDt.endDt != null) {
							if(curDt2 == selectDt.endDt) {
								str += '<td class="sel2" id="sel2"><i>'+days[key]+'</i></td>';
							} else {
								str += '<td><i>'+days[key]+'</i></td>';						
							}
						} else {
							str += '<td><i>'+days[key]+'</i></td>';						
						}
					} else {
						str += '<td class="disabled stop"><i class="disabled stop">'+days[key]+'</i></td>';
					}
				}
				
				if(i === 7) { str += '</tr>'; i=0; }

			}
			str += '</tbody></table>';
			$('#cal').append(str);
		
		
		
	} // end getMonth()
	
// months array (0 based index)
var monthArr = [
	'january',
	'february',
	'march',
	'april',
	'may',
	'june',
	'july',
	'august',
	'september',
	'october',
	'november',
	'december'
]
	
/* INIT */
var date = new Date();
var month = date.getMonth() + 1,
		year = date.getFullYear();
var tour_days = Number($("#tour_days").val());

getMonth(month, year);
//$('#month').text( monthArr[month-1] + ' ' + year); // set month text
$('#month').text( year + "년 " + month + "월"); // set month text
	
function bind(month,year){
	var tb = _id('cal');
	$(tb).on('click', 'td', function(){ userSelect(this,null,month,year); });
	
	// next month
	$('#disp').on('click', 'div', function(){
		var t = this;
		if(t.id == 'next') {
			month++;
			if(month>12){ year++; month=1; } // switch year and reset month
		}
		else {
			month--;
			if(month<1){ year--; month=12; } // switch year and reset month
		}
		
		$('table.daytb').remove();
		getMonth(month,year);
		//$('#month').text( monthArr[month-1] + ' ' + year);
		$('#month').text( year + "년 " + month + "월"); // set month text
	})
	
};
	
bind(month,year);

function lpad(s, padLength, padString){
	 
    while(s.length < padLength)
        s = padString + s;
    return s;
}
 
function rpad(s, padLength, padString){
    while(s.length < padLength)
        s += padString;
    return s;
}

function getToday() {
	var d = new Date();
	return String(d.getFullYear()) + lpad(String(d.getMonth() + 1), 2, "0") + lpad(String(d.getDate()), 2, "0");
}


})(jQuery, window, document); // end() init