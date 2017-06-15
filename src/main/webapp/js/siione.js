
	var timerChecker_01 = null;
	var timerChecker_02 = null;

	/**
	 * 타이머 생성 01
	 * @param iSecond
	 * @param htmlID
	 * @param showYn
	 * @returns
	 * @callback fnTimer_01_callback()
	 */
	function fnTimer_01(iSecond, htmlID, showYn){
	    rMinute = parseInt(iSecond / 60);
	    rSecond = iSecond % 60;
	    if(iSecond > 0){
	    	//타이머 표시
	    	if(showYn=="Y")
	    		$("#"+htmlID).html(fnLpad(rMinute, 2)+":"+fnLpad(rSecond, 2));   	
	    	//카운트다운
	    	iSecond--;
	    	timerChecker_01 = setTimeout("fnTimer_01('"+iSecond+"','"+htmlID+"','"+showYn+"')", 1000); // 1초 간격으로 체크
	    }else{
	    	//타이머 반복 종료
	        clearTimeout(timerChecker_01);
	        //타이머 종료 처리 콜백
	        fnTimer_01_callback();
	    }
	}

	/**
	 * 타이머 생성 02
	 * @param iSecond
	 * @param htmlID
	 * @param showYn
	 * @returns
	 * @callback fnTimer_02_callback()
	 */
	function fnTimer_02(iSecond, htmlID, showYn){
	    rMinute = parseInt(iSecond / 60);
	    rSecond = iSecond % 60;
	    if(iSecond > 0){
	    	//타이머 표시
	    	if(showYn=="Y")
	    		$("#"+htmlID).html(fnLpad(rMinute, 2)+":"+fnLpad(rSecond, 2));
	    	//카운트다운
	    	iSecond--;
	    	timerChecker_02 = setTimeout("fnTimer_02('"+iSecond+"','"+htmlID+"','"+showYn+"')", 1000); // 1초 간격으로 체크
	    }else{
	    	//타이머 반복 종료
	        clearTimeout(timerChecker_02);
	        //타이머 종료 처리 콜백
	        fnTimer_02_callback();
	    }
	}


	/**
	 * 숫자 자릿수 맞춤
	 * @param str
	 * @param len
	 * @returns
	 */
	function fnLpad(str, len){
	    str = str + "";
	    while(str.length < len){
	        str = "0"+str;
	    }
	    return str;
	}

	
	function fnIsEmpty(inVal) {
		if (new String(inVal).valueOf() == "undefined")
			return true;
		if (inVal == null)
			return true;
		if (inVal == 'null')
			return true;

		var v_ChkStr = new String(inVal);

		if (v_ChkStr == null)
			return true;
		if (v_ChkStr.toString().length == 0)
			return true;
		return false;
	}

	function fnCalendarPopup(ctl, sDate, eDate) {		
		var id = $("#"+ctl).attr('id');

		$("#" + id).datepicker({
			dateFormat : 'yy-mm-dd',
			monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
			monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
			dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
			dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
			dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
			changeYear : false,
			changeMonth : false,
			showOtherMonths : true,
			selectOtherMonths : false,
			showOn : 'none'
		});

		if(sDate != "") $("#" + id).datepicker("option", "minDate", sDate);
		if(eDate != "") $("#" + id).datepicker("option", "maxDate", eDate);
		
		$("#" + id).datepicker('show');	
	}


	function fnCalendarReset(ctl) {
		var id = $("#"+ctl).attr('id');
		$("#" + id).val("");
	}

	