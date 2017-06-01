
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
