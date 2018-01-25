Ext.namespace("Ext.ux");

var console = window.console || { log:function(){} };

/*
 * 콤보박스로 구성된 항목일 경우 화면에 명칭을 보여준다.
 * @param   ComboBox 객체
 * @return  Display Field 값
 *
 */
Ext.ux.comboBoxRenderer = function(combo) {
	return function(value) {
		var idx = combo.store.find(combo.valueField, value);
		var rec = combo.store.getAt(idx);
		return rec.get(combo.displayField);
	};
};

/*
 * Editable Grid에서 사용되는 editing 프러그인을 정의
 */
var cellEditing = Ext.create('Ext.grid.plugin.CellEditing', {
    clicksToEdit: 1
});

/*
 * Editable Grid에서 사용되는 editing 프러그인을 정의
 */
var rowEditing = Ext.create('Ext.grid.plugin.RowEditing', {
    clicksToEdit: 1
});

/*
 * 사용여부에 대한 콤보박스를 정의
 */
var comboUseYn = new Ext.create('Ext.form.ComboBox', {
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data :[
	        ['Y', '사용'],
	        ['N', '사용안함']
	    ]
	}),
	displayField: 'name',
	valueField: 'code',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	lazyRender: true,
	emptyText: '선택'
});

/*
 * 성별에 대한 콤보박스를 정의
 */
var comboSex = new Ext.create('Ext.form.ComboBox', {
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data :[
	        ['M', '남'],
	        ['F', '여']
	    ]
	}),
	displayField: 'name',
	valueField: 'code',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	lazyRender: true,
	emptyText: '선택'
});

/*
 * 날짜를 렌더링한다.
 */
function fn_renderDate(value) {
	if(!value) return value;
	value = value.replace(/-/gi, '');
	if (value == null || value == '' || value.length < 8) return value;
	return value.substr(0,4) + '-' + value.substr(4,2) + '-'+ value.substr(6,2);
}

/*
 * 시간을 렌더링한다.
 */
function fn_renderTime(value) {
	if(!value) return value;
	value = value.replace(/:/gi, '');
	if (value == null || value == '' || value.length < 4) return value;
	return value.substr(0,2) + ':' + value.substr(2,2);
}


/**
 *	문자에 따른 남여 render
 */
function fn_renderSex(val){
	var ret = '';

	if(val == '1') ret = '남';
	else if(val == '2') ret = '여';
	else if(val == 'M') ret = '남';
	else if(val == 'F') ret = '여';

	return ret;
}

//생년월일에 '-'문자를 삽입한다.
var fn_renderBirthDay = function(value) {
	var year;
	var month;
	var day;
	try {
		value = value.replace(/-/gi,'');
		if(value.length == 8) {
			year = value.substring(0,4);
			month = value.substring(4,6);
			day = value.substring(6,8);
			return year + '-' + month + '-' + day;
		}
	} catch(e) {
		alert(e);
	} finally {
		year = null;
		month = null;
		day = null;
	}
};

function fn_chkGridAllowBlank(store, allowObj){	//체크할 스토어, 필수항목 Object

	var modified = store.getUpdatedRecords();
	var inserted = store.getNewRecords();
	var objSize = Ext.Object.getSize(allowObj);
	var keyArr = Ext.Object.getKeys(allowObj);
	var valArr = Ext.Object.getValues(allowObj);

	if (modified.length + inserted.length  > 0) {
		for (var i = 0; i < modified.length; i++) {
			for(var j=0; j<objSize; j++){
				if(modified[i].get(keyArr[j]) == '' || modified[i].get(keyArr[j]) == null){
					alert(valArr[j] + '은(는) 필수입력입니다.');
					return true;
				}
			}
		}

		for (var i = 0; i < inserted.length; i++) {
			for(var j=0; j<objSize; j++){
				if(inserted[i].get(keyArr[j]) == '' || inserted[i].get(keyArr[j]) == null){
					alert(valArr[j] + '은(는) 필수입력입니다.');
					return true;
				}
			}
		}
	}

	return false;
}

Ext.apply(Ext.form.field.VTypes, {
    daterange : function(val, field) {

        var date = field.parseDate(val);
        if(!date){
            return;
        }

        if (field.startDateField && (!this.dateRangeMax || (date.getTime() != this.dateRangeMax.getTime()))) {
            var start = Ext.getCmp(field.startDateField);
            //start.setMaxValue(date);
            //this.dateRangeMax = date;
            //start.validate();
        }
        else if (field.endDateField && (!this.dateRangeMin || (date.getTime() != this.dateRangeMin.getTime()))) {
            var end = Ext.getCmp(field.endDateField);
            //end.setMinValue(date);
            //this.dateRangeMin = date;
            //end.validate();
        }
        /*
         * Always return true since we're only using this vtype to set the
         * min/max allowed values (these are tested for after the vtype test)
         */
        return true;
    }
});


/**
 * 서버오류 공통메시지 처리
 * @param {} response
 */
function fn_failureMessage(response){
    var title = "";
    var message = "";
    var status = "";

    switch(response.status){
        case -1:    message = '[' + response.status + ' ' + response.statusText + ']\n' +  "서버 응답시간 초과!";break;
        case 0:     message = '[' + response.status + ' ' + response.statusText + ']\n' + "서버접속에 장애가 발생하였습니다.\n잠시후 다시 시도해주시기 바랍니다.";break;
        case 200:   message = '[알림]\n\n' + Ext.decode(response.responseText).message;break;
        case 400:   message = '[' + response.status + ' ' + response.statusText + ']\n' + "인수정보가 올바르지 않습니다.\n잘못된 요청입니다";break;
        case 404:   message = '[' + response.status + ' ' + response.statusText + ']\n' + "요청수행 서버를 찾을 수 없습니다\n잠시후 다시 시도해주시기 바랍니다";break;
        case 405:   message = '[' + response.status + ' ' + response.statusText + ']\n' + "허용된 Method가 아닙니다";break;
        case 500:   message = '[' + response.status + ' ' + response.statusText + ']\n' + "서버오류가 발생하였습니다\n잠시후 다시 시도해주시기 바랍니다";break;
        default:	message = '[' + response.status + ' ' + response.statusText + ']\n' + response.responseText;break;
    }
    alert(message);
}


//▼ Toolbar Component
/** 페이징 툴바****************************************************************************************************
 * @name 		createPagingToolbarNoButton
 * @comment		페이지 사이즈 콤보박스 - 페이징바에 사용될 콤보박스 생성
 * @param 		store				(스토어)
 * 				pageSizeComboBox	(페이징 콤보박스)
 * 				pageId				(화면 아이디)
 * 				page				(페이징 사이즈)
 *****************************************************************************************************/
function createPagingToolbarNoButton(store, pageId, size){
	var comboStore	=	Ext.create('Ext.data.Store', {
		fields		: ['code', 'name'],
		data   		: [{code: 10, name : '10건'},
						{code: 20, name : '20건'},
						{code: 30, name : '30건'},
						{code: 40, name : '40건'},
						{code: 50, name : '50건'},
						{code: 100, name : '100건'},
						{code: 300, name : '300건'},
						{code: 500, name : '500건'}
						]
	});
	comboStore.load();
	store.pageSize = size;
	var searchResultPagingSize = {
		xtype			:'combobox',
		store			: comboStore,
		width			: 70,
		displayField	: 'name',
		valueField		: 'code',
		typeAhead		: true,
		mode			: 'local',
		readOnly 		: false,
		editable 		: false,
		triggerAction	: 'all',
		selectOnFocus	: true,
		value			: size,
		listeners		:{
			'select': function(combo, record, idx){
				store.pageSize = combo.getValue('code');
				if(store.getCount() > 0) {
					var paramObj = store.proxy.extraParams;
					//[2014.12.19] 기존 공통코드인 paramObj.start = 1; 로 고정시키는 것을 자동으로 기본 순번 계산법으로 하기 위해 주석처리한다.
					//[2014.12.19] 기존대로 모든 데이터를 계속 조회할려면 0으로 수정해야 한다. 현재 crims 쿼리는 start+1로 계산된다.
//					paramObj.start = 0;
					paramObj.limit = combo.getValue('code');
					store.proxy.extraParams = paramObj;
					store.loadPage(1);
				}
			}
		}
	};
	var obj = Ext.create('Ext.PagingToolbar', {
	    pageSize   : size,
	    store      : store,
	    displayInfo: true,
	    displayMsg : '현재건수:<b><font color="green">{0} - {1}</font></b> /&nbsp;총건수: <b><font color="red">{2}</font></b>&nbsp;&nbsp;',
	    emptyMsg   : "<b>해당자료가 없습니다.</b>",
		items      : [
						//'-',
						searchResultPagingSize
						//'-',
						//pageId,
						//'-',
						//new Ext.form.DisplayField()
		],
		listeners:{
			'beforechange':function(toolbar, page, opt){
				if(store.getCount() < 1){
					Ext.Msg.alert("알림","조회 먼저 하셔야 합니다.");
					return false;
				}
			}
		}
	});
	return obj;
}

//주민번호 Vtype 생성 및 적용
var juminNumberRegex = /^\d{6}\-?\d{7}$/;
var juminNumberVType = {
		juminNumber: function(val, field){
			return juminNumberRegex.test(val);
		},
		juminNumberText: '주민번호형식으로 입력해야 합니다.',
		juminNumberMask: /^[0-9.]$/
};

//지문번호 Vtype 생성 및 적용
var jimunNumberRegex = /^\d{5}\-?\d{5}$/;
var jimunNumberVType = {
		jimunNumber: function(val, field){
			return jimunNumberRegex.test(val);
		},
		jimunNumberText: '지문가치번호 형식으로 입력해야 합니다.',
		jimunNumberMask: /^[0-9.]$/
};

//10자리 Vtype 생성 및 정용
var tenNumberResex = /^\d{10}/;
var tenNumberVType = {
		tenNumber: function(val, field) {
			return tenNumberResex.test(val);
		},
		tenNumberText: '10자리로 입력해야 합니다.',
		tenNumberMask: /^[0-9]$/
};

//6자리 Vtype 생성 및 적용
var sixNumberResex = /^\d{6}/;
var sixNumberVType = {
		sixNumber: function(val, field) {
			return sixNumberResex.test(val);
		},
		sixNumberText: '6자리로 입력해야 합니다.',
		sixNumberMask: /^[0-9]$/
};

//6자리 Vtype 생성 및 적용
var eightNumberResex = /^\d{8}/;
var eightNumberVType = {
		eightNumber: function(val, field) {
			return eightNumberResex.test(val);
		},
		eightNumberText: '8자리로 입력해야 합니다.',
		eightNumberMask: /^[0-9]$/
};

//4자리 Vtype 생성 및 적용
var fourNumberResex = /^\d{4}/;
var fourNumberVType = {
		fourNumber: function(val, field) {
			return fourNumberResex.test(val);
		},
		fourNumberText: '4자리로 입력해야 합니다.',
		fourNumberMask: /^[0-9]$/
};

/* 날짜형 VTYPE 선언 */
var dateRegex = /^\d{4}\-?\d{2}\-?\d{2}$/;
var dateVType = {
		dateType: function(val, field){
			return dateRegex.test(val);
		},
		dateTypeText: 'YYYYmmdd형식으로 입력해야 합니다.',
		dateTypeMask: /^[0-9]$/
};

//생년월일 Vtype 생성 및 적용
var birthDayRegex = /^\d{4}\-?\d{2}\-?\d{2}$/;
var birthDayVType = {
		birthDay: function(val, field){
			return birthDayRegex.test(val);
		},
		birthDayText: '생년월일 형식으로 입력해야 합니다.',
		birthDayMask: /^[0-9.]$/
};

/* VTYPE 등록 */
Ext.apply(Ext.form.field.VTypes, tenNumberVType);
Ext.apply(Ext.form.field.VTypes, juminNumberVType);
Ext.apply(Ext.form.field.VTypes, sixNumberVType);
Ext.apply(Ext.form.field.VTypes, fourNumberVType);
Ext.apply(Ext.form.field.VTypes, eightNumberVType);
Ext.apply(Ext.form.field.VTypes, jimunNumberVType);
Ext.apply(Ext.form.field.VTypes, dateVType);
Ext.apply(Ext.form.field.VTypes, birthDayVType);

/**
 * 성별 M, F로 가져온다.
 * @param ihidnum
 */
function fn_getSexdstn(ihidnum) {

	if(ihidnum) {
		ihidnum = ihidnum.replace(/-/gi);

		if(ihidnum.length == 13) {
			var senventh = ihidnum.substring(6,7);
			var sexdstn = 'M';
			switch(senventh) {
			case 1: sexdstn = 'M'; break;
			case 2: sexdstn = 'F'; break;
			case 3: sexdstn = 'M'; break;
			case 4: sexdstn = 'F'; break;
			case 5: sexdstn = 'M'; break;
			case 6: sexdstn = 'F'; break;
			case 7: sexdstn = 'M'; break;
			case 8: sexdstn = 'F'; break;
			}

			return sexdstn;
		}
	}

	return 'M';
}

/**
 * 데이터 앞에 문자 추가
 * @param value
 * @param character
 * @param maxCount
 * @returns
 */
function fn_renderPreData(value, character, maxCount) {
	if(!value) return value;
	for(var i = value.length; i < maxCount; i++){
		value = character + value;
	}
	return value;
}


/**
 * container 각 필드 모두 초기화
 * @param v
 */
function fn_resetContainer(v) {
	v.items.each(function(f){
		if(Ext.isFunction(f.reset)) {
			f.reset();
		}
	});
}

/**
 * 공통코드 combobox
 * @param objId : combobox object id
 * @param objName : combobox object name
 * @param sCodeId : CODE_ID
 * @param sUseAt : 사용여부
 * @param bAll : 전체여부
 * @returns {Ext.create}
 */
function fn_cmmnCombo(sLabel, objId, objName, sCodeId, sUseAt, bAll, iWidth, iWidthLabel) {

	var stCmmnCode = new Ext.create('Ext.data.JsonStore', {
		autoLoad: true,
		fields:['CODE_ID', 'CODE', 'CODE_NM', 'CODE_NM_ENG', 'CODE_DC'],
		pageSize: 100,
		proxy: {
			type: 'ajax',
			url: '../selectCmmnDetailCodeList/?CODE_ID='+sCodeId+'&USE_AT='+sUseAt,
			reader: {
				type: 'json',
				root: 'data',
				totalProperty: 'rows'
			}
		},
		listeners:{
			'load' : function( store, records, successful, eOpts ){
				if(bAll) {
					if(store.getCount() > 0){
						//var idx = store.getCount();
						var r = {
							CODE_ID: sCodeId,
							CODE: '',
							CODE_NM: '전체',
							CODE_NM_ENG: 'All',
							CODE_DC: '전체'
						};
						store.insert(0, r);
					}
				}
			}
		}
	});

	var cbCmmnCode = new Ext.create('Ext.form.ComboBox', {
		id: objId,
		name: objName,
		store: stCmmnCode,
		width: iWidth,
		fieldLabel: sLabel,
		labelAlign: 'right',
		labelWidth: iWidthLabel,
		displayField: 'CODE_NM',
		valueField: 'CODE',
		mode: 'local',
		typeAhead: false,
		triggerAction: 'all',
		lazyRender: true,
		emptyText: (bAll?'전체':'선택')
	});

	return cbCmmnCode;
}

function fn_openPopup(sUrl, sName, iWidth, iHeigth, sResizable, sMenubar){
    var sw = screen.width;
    var sh = screen.height;
    var x = (sw-iWidth)/2;
    var y = (sh-iHeigth)/2;
    var opts = "width="+iWidth+", height="+iHeigth+", left="+x+", top="+y+", scrollbars=yes, menubar="+(sMenubar?sMenubar:'no')+", location=no, resizable="+sResizable;
    window.open(sUrl, sName, opts).focus();
}