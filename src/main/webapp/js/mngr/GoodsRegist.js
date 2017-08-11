
var formSave = Ext.create('Ext.form.Panel', {});

var combo = new Ext.create('Ext.form.ComboBox', {
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data :[
			['N', '사용'],
			['Y', '사용안함']
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

var comboYn = new Ext.create('Ext.form.ComboBox', {
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data :[
			['Y', '예'],
			['N', '아니오']
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

var comboBeginTime = new Ext.create('Ext.form.ComboBox', {
	store: new Ext.create('Ext.data.ArrayStore', {
		fields: ['code', 'name'],
		data: [ ['0000', '12:00 AM'],
				['0010', '12:10 AM'],
				['0020', '12:20 AM'],
				['0030', '12:30 AM'],
				['0040', '12:40 AM'],
				['0050', '12:50 AM'],
				['0100', '01:00 AM'],
				['0110', '01:10 AM'],
				['0120', '01:20 AM'],
				['0130', '01:30 AM'],
				['0140', '01:40 AM'],
				['0150', '01:50 AM'],
				['0200', '02:00 AM'],
				['0210', '02:10 AM'],
				['0220', '02:20 AM'],
				['0230', '02:30 AM'],
				['0240', '02:40 AM'],
				['0250', '02:50 AM'],
				['0300', '03:00 AM'],
				['0310', '03:10 AM'],
				['0320', '03:20 AM'],
				['0330', '03:30 AM'],
				['0340', '03:40 AM'],
				['0350', '03:50 AM'],
				['0400', '04:00 AM'],
				['0410', '04:10 AM'],
				['0420', '04:20 AM'],
				['0430', '04:30 AM'],
				['0440', '04:40 AM'],
				['0450', '04:50 AM'],
				['0500', '05:00 AM'],
				['0510', '05:10 AM'],
				['0520', '05:20 AM'],
				['0530', '05:30 AM'],
				['0540', '05:40 AM'],
				['0550', '05:50 AM'],
				['0600', '06:00 AM'],
				['0610', '06:10 AM'],
				['0620', '06:20 AM'],
				['0630', '06:30 AM'],
				['0640', '06:40 AM'],
				['0650', '06:50 AM'],
				['0700', '07:00 AM'],
				['0710', '07:10 AM'],
				['0720', '07:20 AM'],
				['0730', '07:30 AM'],
				['0740', '07:40 AM'],
				['0750', '07:50 AM'],
				['0800', '08:00 AM'],
				['0810', '08:10 AM'],
				['0820', '08:20 AM'],
				['0830', '08:30 AM'],
				['0840', '08:40 AM'],
				['0850', '08:50 AM'],
				['0900', '09:00 AM'],
				['0910', '09:10 AM'],
				['0920', '09:20 AM'],
				['0930', '09:30 AM'],
				['0940', '09:40 AM'],
				['0950', '09:50 AM'],
				['1000', '10:00 AM'],
				['1010', '10:10 AM'],
				['1020', '10:20 AM'],
				['1030', '10:30 AM'],
				['1040', '10:40 AM'],
				['1050', '10:50 AM'],
				['1100', '11:00 AM'],
				['1110', '11:10 AM'],
				['1120', '11:20 AM'],
				['1130', '11:30 AM'],
				['1140', '11:40 AM'],
				['1150', '11:50 AM'],
				['1200', '12:00 PM'],
				['1210', '12:10 PM'],
				['1220', '12:20 PM'],
				['1230', '12:30 PM'],
				['1240', '12:40 PM'],
				['1250', '12:50 PM'],
				['1300', '01:00 PM'],
				['1310', '01:10 PM'],
				['1320', '01:20 PM'],
				['1330', '01:30 PM'],
				['1340', '01:40 PM'],
				['1350', '01:50 PM'],
				['1400', '02:00 PM'],
				['1410', '02:10 PM'],
				['1420', '02:20 PM'],
				['1430', '02:30 PM'],
				['1440', '02:40 PM'],
				['1450', '02:50 PM'],
				['1500', '03:00 PM'],
				['1510', '03:10 PM'],
				['1520', '03:20 PM'],
				['1530', '03:30 PM'],
				['1540', '03:40 PM'],
				['1550', '03:50 PM'],
				['1600', '04:00 PM'],
				['1610', '04:10 PM'],
				['1620', '04:20 PM'],
				['1630', '04:30 PM'],
				['1640', '04:40 PM'],
				['1650', '04:50 PM'],
				['1700', '05:00 PM'],
				['1710', '05:10 PM'],
				['1720', '05:20 PM'],
				['1730', '05:30 PM'],
				['1740', '05:40 PM'],
				['1750', '05:50 PM'],
				['1800', '06:00 PM'],
				['1810', '06:10 PM'],
				['1820', '06:20 PM'],
				['1830', '06:30 PM'],
				['1840', '06:40 PM'],
				['1850', '06:50 PM'],
				['1900', '07:00 PM'],
				['1910', '07:10 PM'],
				['1920', '07:20 PM'],
				['1930', '07:30 PM'],
				['1940', '07:40 PM'],
				['1950', '07:50 PM'],
				['2000', '08:00 PM'],
				['2010', '08:10 PM'],
				['2020', '08:20 PM'],
				['2030', '08:30 PM'],
				['2040', '08:40 PM'],
				['2050', '08:50 PM'],
				['2100', '09:00 PM'],
				['2110', '09:10 PM'],
				['2120', '09:20 PM'],
				['2130', '09:30 PM'],
				['2140', '09:40 PM'],
				['2150', '09:50 PM'],
				['2200', '10:00 PM'],
				['2210', '10:10 PM'],
				['2220', '10:20 PM'],
				['2230', '10:30 PM'],
				['2240', '10:40 PM'],
				['2250', '10:50 PM'],
				['2300', '11:00 PM'],
				['2310', '11:10 PM'],
				['2320', '11:20 PM'],
				['2330', '11:30 PM'],
				['2340', '11:40 PM'],
				['2350', '11:50 PM']
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

var comboEndTime = new Ext.create('Ext.form.ComboBox', {
	store: new Ext.create('Ext.data.ArrayStore', {
		fields: ['code', 'name'],
		data: [ ['0000', '12:00 AM'],
				['0010', '12:10 AM'],
				['0020', '12:20 AM'],
				['0030', '12:30 AM'],
				['0040', '12:40 AM'],
				['0050', '12:50 AM'],
				['0100', '01:00 AM'],
				['0110', '01:10 AM'],
				['0120', '01:20 AM'],
				['0130', '01:30 AM'],
				['0140', '01:40 AM'],
				['0150', '01:50 AM'],
				['0200', '02:00 AM'],
				['0210', '02:10 AM'],
				['0220', '02:20 AM'],
				['0230', '02:30 AM'],
				['0240', '02:40 AM'],
				['0250', '02:50 AM'],
				['0300', '03:00 AM'],
				['0310', '03:10 AM'],
				['0320', '03:20 AM'],
				['0330', '03:30 AM'],
				['0340', '03:40 AM'],
				['0350', '03:50 AM'],
				['0400', '04:00 AM'],
				['0410', '04:10 AM'],
				['0420', '04:20 AM'],
				['0430', '04:30 AM'],
				['0440', '04:40 AM'],
				['0450', '04:50 AM'],
				['0500', '05:00 AM'],
				['0510', '05:10 AM'],
				['0520', '05:20 AM'],
				['0530', '05:30 AM'],
				['0540', '05:40 AM'],
				['0550', '05:50 AM'],
				['0600', '06:00 AM'],
				['0610', '06:10 AM'],
				['0620', '06:20 AM'],
				['0630', '06:30 AM'],
				['0640', '06:40 AM'],
				['0650', '06:50 AM'],
				['0700', '07:00 AM'],
				['0710', '07:10 AM'],
				['0720', '07:20 AM'],
				['0730', '07:30 AM'],
				['0740', '07:40 AM'],
				['0750', '07:50 AM'],
				['0800', '08:00 AM'],
				['0810', '08:10 AM'],
				['0820', '08:20 AM'],
				['0830', '08:30 AM'],
				['0840', '08:40 AM'],
				['0850', '08:50 AM'],
				['0900', '09:00 AM'],
				['0910', '09:10 AM'],
				['0920', '09:20 AM'],
				['0930', '09:30 AM'],
				['0940', '09:40 AM'],
				['0950', '09:50 AM'],
				['1000', '10:00 AM'],
				['1010', '10:10 AM'],
				['1020', '10:20 AM'],
				['1030', '10:30 AM'],
				['1040', '10:40 AM'],
				['1050', '10:50 AM'],
				['1100', '11:00 AM'],
				['1110', '11:10 AM'],
				['1120', '11:20 AM'],
				['1130', '11:30 AM'],
				['1140', '11:40 AM'],
				['1150', '11:50 AM'],
				['1200', '12:00 PM'],
				['1210', '12:10 PM'],
				['1220', '12:20 PM'],
				['1230', '12:30 PM'],
				['1240', '12:40 PM'],
				['1250', '12:50 PM'],
				['1300', '01:00 PM'],
				['1310', '01:10 PM'],
				['1320', '01:20 PM'],
				['1330', '01:30 PM'],
				['1340', '01:40 PM'],
				['1350', '01:50 PM'],
				['1400', '02:00 PM'],
				['1410', '02:10 PM'],
				['1420', '02:20 PM'],
				['1430', '02:30 PM'],
				['1440', '02:40 PM'],
				['1450', '02:50 PM'],
				['1500', '03:00 PM'],
				['1510', '03:10 PM'],
				['1520', '03:20 PM'],
				['1530', '03:30 PM'],
				['1540', '03:40 PM'],
				['1550', '03:50 PM'],
				['1600', '04:00 PM'],
				['1610', '04:10 PM'],
				['1620', '04:20 PM'],
				['1630', '04:30 PM'],
				['1640', '04:40 PM'],
				['1650', '04:50 PM'],
				['1700', '05:00 PM'],
				['1710', '05:10 PM'],
				['1720', '05:20 PM'],
				['1730', '05:30 PM'],
				['1740', '05:40 PM'],
				['1750', '05:50 PM'],
				['1800', '06:00 PM'],
				['1810', '06:10 PM'],
				['1820', '06:20 PM'],
				['1830', '06:30 PM'],
				['1840', '06:40 PM'],
				['1850', '06:50 PM'],
				['1900', '07:00 PM'],
				['1910', '07:10 PM'],
				['1920', '07:20 PM'],
				['1930', '07:30 PM'],
				['1940', '07:40 PM'],
				['1950', '07:50 PM'],
				['2000', '08:00 PM'],
				['2010', '08:10 PM'],
				['2020', '08:20 PM'],
				['2030', '08:30 PM'],
				['2040', '08:40 PM'],
				['2050', '08:50 PM'],
				['2100', '09:00 PM'],
				['2110', '09:10 PM'],
				['2120', '09:20 PM'],
				['2130', '09:30 PM'],
				['2140', '09:40 PM'],
				['2150', '09:50 PM'],
				['2200', '10:00 PM'],
				['2210', '10:10 PM'],
				['2220', '10:20 PM'],
				['2230', '10:30 PM'],
				['2240', '10:40 PM'],
				['2250', '10:50 PM'],
				['2300', '11:00 PM'],
				['2310', '11:10 PM'],
				['2320', '11:20 PM'],
				['2330', '11:30 PM'],
				['2340', '11:40 PM'],
				['2350', '11:50 PM']
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
 * 상위 상품 분류 combo
 */
var comboUpperCl = new Ext.create('Ext.form.ComboBox', {
	id: 'form-reg-upper-cl-code',
	name: 'UPPER_CL_CODE',
	width: 275,
	fieldLabel: '상품분류',
	labelAlign: 'right',
	labelWidth: 100,
	store: new Ext.create('Ext.data.JsonStore', {
		autoLoad: true,
		fields:['CL_CODE', 'CL_NM', 'STAYNG_FCLTY_AT'],
		proxy: {
			type: 'ajax',
			url: '../selectTourClUpperList/?UPPER_CL_CODE=00000',
			reader: {
				type: 'json',
				root: 'data',
				totalProperty: 'rows'
			}
		}
	}),
	displayField: 'CL_NM',
	valueField: 'CL_CODE',
	queryMode: 'local',
	typeAhead: true,
	editable: false,
	emptyText: '선택',
	listeners: {
		change: function(combo, newValue, oldValue, eOpts ) {
			var rec = combo.getStore().findRecord('CL_CODE', newValue);
			Ext.getCmp('form-reg-stayng-fclty-at').setValue(rec.get('STAYNG_FCLTY_AT'));
			Ext.getCmp('form-reg-cl-code').setValue('');
			comboCl.getStore().load({params:{UPPER_CL_CODE:newValue}});
		}
	}
});

/*
 * 상품 분류 combo
 */
var comboCl = new Ext.create('Ext.form.ComboBox', {
	id: 'form-reg-cl-code',
	name: 'CL_CODE',
	width: 170,
	store: new Ext.create('Ext.data.JsonStore', {
		autoLoad: false,
		fields:['CL_CODE', 'CL_NM', 'STAYNG_FCLTY_AT'],
		proxy: {
			type: 'ajax',
			url: '../selectTourClUpperList/',
			reader: {
				type: 'json',
				root: 'data',
				totalProperty: 'rows'
			}
		}
	}),
	displayField: 'CL_NM',
	valueField: 'CL_CODE',
	queryMode: 'local',
	typeAhead: true,
	editable: false,
	emptyText: '선택'
});

/**
 * 상품저장
 * @param sDiv (I:기본정보, G:이용안내, E:기타정보)
 * @param frSave
 */
function fn_saveGoodsInfo(sDiv, frSave) {

	var sUrl = '../insertGoods/';
	var stParams = {};

	if(sDiv != 'I') {
		sUrl = '../updateGoods/';
		stParams = {
			'GOODS_CODE': Ext.getCmp('form-reg-goods-code').getValue(),
			'UPDT_SE': sDiv
		};
	}

	Ext.Msg.show({
		 title:'확인',
		 msg: '저장하시겠습니까?',
		 buttons: Ext.Msg.YESNO,
		 icon: Ext.Msg.QUESTION,
		 fn: function(btn){
			if(btn == 'yes'){
				frSave.getForm().submit({
					waitMsg: '저장중입니다...',
					url: sUrl,
					params: stParams,
					success: function(form, action) {
						Ext.Msg.alert('알림', action.result.message, function(){
							if(sDiv == 'I') {
								Ext.getCmp('form-reg-goods-code').setValue(action.result.GOODS_CODE);
							}
						});
					},
					failure: function(form, action) {
						if(action.result.message) {
							Ext.Msg.alert('알림', action.result.message);
						} else {
							Ext.Msg.alert('알림', '저장 중 오류가 발생하였습니다. 다시 시도하여 주십시오.');
						}
					}
				});
			}
		 }
	});
}


Ext.define('GoodsInfo', {
	extend: 'Ext.data.Model',
	fields: [ {name:'GOODS_CODE', type:'string'}
			, {name:'GOODS_NM', type:'string'}
			, {name:'GOODS_INTRCN', type:'string'}
			, {name:'DELETE_AT', type:'string'}
			, {name:'WRITNG_ID', type:'string'}
			, {name:'UPDT_ID', type:'string'}
			, {name:'FILE_CODE', type:'string'}
			, {name:'WAIT_TIME', type:'string'}
			, {name:'MVMN_TIME', type:'string'}
			, {name:'WRITNG_DE', type:'string'}
			, {name:'UPDT_DE', type:'string'}
			, {name:'ACT_LA', type:'string'}
			, {name:'ACT_LO', type:'string'}
			, {name:'VOCHR_TICKET_TY', type:'string'}
			, {name:'VOCHR_NTSS_REQRE_TIME', type:'string'}
			, {name:'VOCHR_USE_MTH', type:'string'}
			, {name:'GUIDANCE_USE_TIME', type:'string'}
			, {name:'GUIDANCE_REQRE_TIME', type:'string'}
			, {name:'GUIDANCE_AGE_DIV', type:'string'}
			, {name:'GUIDANCE_TOUR_SCHDUL', type:'string'}
			, {name:'GUIDANCE_PRFPLC_LC', type:'string'}
			, {name:'GUIDANCE_EDC_CRSE', type:'string'}
			, {name:'GUIDANCE_OPTN_MATTER', type:'string'}
			, {name:'GUIDANCE_PICKUP', type:'string'}
			, {name:'GUIDANCE_PRPARETG', type:'string'}
			, {name:'GUIDANCE_INCLS_MATTER', type:'string'}
			, {name:'GUIDANCE_NOT_INCLS_MATTER', type:'string'}
			, {name:'ADIT_GUIDANCE', type:'string'}
			, {name:'ATENT_MATTER', type:'string'}
			, {name:'CHANGE_REFND_REGLTN', type:'string'}
			, {name:'INTRCN_GOODS_TY', type:'string'}
			, {name:'INTRCN_USE_TIME', type:'string'}
			, {name:'INTRCN_MEET_TIME', type:'string'}
			, {name:'INTRCN_REQRE_TIME', type:'string'}
			, {name:'INTRCN_PROVD_LANG', type:'string'}
			, {name:'INTRCN_POSBL_AGE', type:'string'}
			, {name:'INTRCN_PLACE', type:'string'}
			, {name:'UPPER_CL_CODE', type:'string'}
			, {name:'CL_CODE', type:'string'}
			, {name:'STAYNG_FCLTY_AT', type:'string'}
			, {name:'SORT_ORDR', type:'string'}]
});


var storeGoods = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
    model: 'GoodsInfo',
    proxy: {
        type: 'ajax',
        url: '../selectGoods/',
        reader: {
            type: 'json',
            root: 'data',
        }
    },
    listeners: {
    	'beforeload': function( store, operation, eOpts ){
    		Ext.getBody().mask('조회 중 입니다. 잠시만 기다려주세요...');
    	},
    	'load': function(store, records, successful, eOpts) {
    		console.log(successful);
//			if(!successful) {
//				Ext.getBody().unmask();
//				Ext.Msg.alert('확인', '조회 중 오류 발생');
//			}
    		
    		console.log(store.data);
    		
			if(store.getCount()) {
				frReg.getForm().loadRecord(store.getAt(0));
				frReg2.getForm().loadRecord(store.getAt(0));
				frReg3.getForm().loadRecord(store.getAt(0));
	    	}
			
			storeSchdul.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
			storeTime.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
			storeNmpr.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
			storeFile.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
			
			Ext.getBody().unmask();
        }
    }
});				

var frSearch = Ext.create('Ext.form.Panel', {
	//title: '상품정보입력',
	id: 'form-search',
	region: 'north',
	//width: 1500,
	padding:'5 5 0 5',
	items: [{
		xtype: 'fieldcontainer',
		layout: 'hbox',
		items: [{
			xtype: 'fieldset',
			//title: '<span style="font-weight:bold;">이미지 등록</span>',
			padding: '10 100 10 10',
			items: [{
				xtype: 'fieldcontainer',
				layout: 'hbox',
				items: [{
					xtype: 'textfield',
					id: 'form-reg-sch-goods-code',
		    		name: 'SCH_GOODS_CODE',
		    		fieldLabel: '상품코드',
		    		labelAlign: 'right',
		    		labelSeparator: ':',
		    		labelWidth: 100,
		    		allowBlank: false,
		    		width: 250
				},{
					xtype: 'button',
					text: '검색',
					width: 60,
					margin: '0 0 0 5',
					handler: function() {
						storeGoods.load({params:{GOODS_CODE:Ext.getCmp('form-reg-sch-goods-code').getValue()}});	
					}
				}]			
			}]
		}]
	}]
});

/*
 * 상품정보입력 form 화면(1)
 */
var frReg = Ext.create('Ext.form.Panel', {
	title: '상품정보입력',
	id: 'form-reg',
	region: 'center',
	autoScroll: true,
	//height: 70,
	tbar: [{
		xtype: 'button',
		id: 'btn-save1',
		text: '저장(1)',
		margin: '0 0 0 530',
		width: 70,
		handler: function() {
			if(Ext.getCmp('form-reg-goods-code').getValue()) {
				fn_saveGoodsInfo('U', frReg);
			} else {
				fn_saveGoodsInfo('I', frReg);
			}
		}
	}],
	items: [{
		xtype: 'fieldset',
		title: '<span style="font-weight:bold;">상품 기본 정보</span>',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [comboUpperCl, {
				xtype: 'label',
				width: 5
			}, comboCl]
		},{
			xtype: 'textfield',
			id: 'form-reg-goods-nm',
			name: 'GOODS_NM',
			fieldLabel: '상품명',
			fieldStyle: {'ime-mode':'active'},
			labelSeparator: ':',
			labelWidth: 100,
			labelAlign: 'right',
			width: 450,
			maxLength: 100,
			enforceMaxLength: true,
			allowBlank: true,
			enableKeyEvents: true
		},{
			xtype: 'textareafield',
			id: 'form-reg-goods-intrcn',
			name: 'GOODS_INTRCN',
			fieldLabel: '상품설명',
			fieldStyle: {'ime-mode':'active'},
			labelSeparator: ':',
			labelWidth: 100,
			labelAlign: 'right',
			grow: false,
			isFocus: false,
			height: 100,
			width: 600,
			//maxLength: 100,
			//enforceMaxLength: true,
			allowBlank: true,
			enableKeyEvents: true
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'numberfield',
				id: 'form-reg-wait-hour',
				name: 'WAIT_HOUR',
				width: 160,
				fieldLabel: '대기시간',
				labelWidth: 100,
				labelAlign: 'right',
				value: 0,
				step: 1,
				minValue: 0,
				maxValue: 10
			},{
				xtype: 'label',
				text: '시간',
				margin: '5 5 10 5'
			},{
				xtype: 'numberfield',
				id: 'form-reg-wait-minute',
				name: 'WAIT_MINUTE',
				width: 55,
				hideLabel: true,
				value: 0,
				step: 5,
				minValue: 0,
				maxValue: 55
			},{
				xtype: 'label',
				text: '분',
				margin: '5 5 10 5'
			},{
				xtype: 'numberfield',
				id: 'form-reg-mvmn-hour',
				name: 'MVMN_HOUR',
				width: 160,
				fieldLabel: '이동시간',
				labelWidth: 100,
				labelAlign: 'right',
				value: 0,
				step: 1,
				minValue: 0,
				maxValue: 10
			},{
				xtype: 'label',
				text: '시간',
				margin: '5 5 10 5'
			},{
				xtype: 'numberfield',
				id: 'form-reg-mvmn-minute',
				name: 'MVMN_MINUTE',
				width: 55,
				hideLabel: true,
				value: 0,
				step: 5,
				minValue: 0,
				maxValue: 55
			},{
				xtype: 'label',
				text: '분',
				margin: '5 5 10 5'
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'numberfield',
				id: 'form-reg-act-la',
				name: 'ACT_LA',
				width: 250,
				fieldLabel: '장소위도',
				labelWidth: 100,
				labelAlign: 'right',
				decimalPrecision: 6,
				// Remove spinner buttons, and arrow key and mouse wheel listeners
				hideTrigger: true,
				keyNavEnabled: false,
				mouseWheelEnabled: false
			},{
				xtype: 'label',
				width: 5
			},{
				xtype: 'numberfield',
				id: 'form-reg-act-lo',
				name: 'ACT_LO',
				width: 270,
				fieldLabel: '장소경도',
				labelWidth: 120,
				labelAlign: 'right',
				decimalPrecision: 6,
				// Remove spinner buttons, and arrow key and mouse wheel listeners
				hideTrigger: true,
				keyNavEnabled: false,
				mouseWheelEnabled: false
			}]
		}]
	},{
		xtype: 'fieldset',
		title: '<span style="font-weight:bold;">상품 간략 정보</span>',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textfield',
				id: 'form-reg-intrcn-goods-ty',
				name: 'INTRCN_GOODS_TY',
				width: 300,
				fieldLabel: '상품유형',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				maxLength: 10,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			},{
				xtype: 'textfield',
				id: 'form-reg-intrcn-use-time',
				name: 'INTRCN_USE_TIME',
				width: 300,
				fieldLabel: '이용시간',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				maxLength: 10,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textfield',
				id: 'form-reg-intrcn-meet-time',
				name: 'INTRCN_MEET_TIME',
				width: 300,
				fieldLabel: '집합시간',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				maxLength: 10,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			},{
				xtype: 'textfield',
				id: 'form-reg-intrcn-reqre-time',
				name: 'INTRCN_REQRE_TIME',
				width: 300,
				fieldLabel: '소요시간',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				maxLength: 10,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textfield',
				id: 'form-reg-intrcn-provd-lang',
				name: 'INTRCN_PROVD_LANG',
				width: 300,
				fieldLabel: '제공언어',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				maxLength: 10,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			},{
				xtype: 'textfield',
				id: 'form-reg-intrcn-posbl-age',
				name: 'INTRCN_POSBL_AGE',
				width: 300,
				fieldLabel: '가능연령',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				maxLength: 10,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textfield',
				id: 'form-reg-intrcn-place',
				name: 'INTRCN_PLACE',
				width: 300,
				fieldLabel: '장소',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				maxLength: 10,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		}]
	},{
		xtype: 'fieldset',
		title: '<span style="font-weight:bold;">상품 바우처 정보</span>',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textfield',
				id: 'form-reg-vochr-ticket-ty',
				name: 'VOCHR_TICKET_TY',
				width: 300,
				fieldLabel: '티켓유형',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				maxLength: 10,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			},{
				xtype: 'textfield',
				id: 'form-reg-vochr-ntss-reqre-time',
				name: 'VOCHR_NTSS_REQRE_TIME',
				width: 300,
				fieldLabel: '발권소요시간',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				maxLength: 10,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-vochr-use-mth',
				name: 'VOCHR_USE_MTH',
				fieldLabel: '사용방법',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 50,
				maxLength: 250,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		}]
	/*},{
		xtype: 'fieldset',
		title: '<span style="font-weight:bold;">대표이미지</span>',
		//hidden: true,
		padding: '10 20 10 10',
		items: [{
			xtype: 'filefield',
    		name: 'ATTACH_FLIE_BAK',
    		regex: /^.*\.(BMP|GIF|JPG|JPEG|PNG|bmp|gif|jpg|jpeg|png)$/,
    		regexText: '이지미 파일을 선택하세요.',
    		buttonText: '찾기...',
    		fieldLabel: '첨부파일',
    		labelAlign: 'right',
    		labelSeparator: ':',
    		labelWidth: 100,
    		allowBlank: false,
    		width: 600
		}]*/
	},{
		xtype: 'fieldset',
		title: 'Hidden Field',
		//hidden: true,
		padding: '10 20 10 10',
		items: [{
			xtype: 'textfield', width: 600, labelWidth: 200, labelAlign: 'right',
			id: 'form-reg-goods-code', name: 'GOODS_CODE', fieldLabel: 'GOODS_CODE'
		},{
			xtype: 'textfield', width: 600, labelWidth: 200, labelAlign: 'right',
			id: 'form-reg-stayng-fclty-at', name: 'STAYNG_FCLTY_AT', fieldLabel: 'STAYNG_FCLTY_AT'
		},{
			xtype: 'textfield', width: 600, labelWidth: 200, labelAlign: 'right',
			id: 'form-reg-sort-ordr', name: 'SORT_ORDR', fieldLabel: 'SORT_ORDR'
		}]
	}]
});

/*
 * 상품정보입력 form 화면(2)
 */
var frReg2 = Ext.create('Ext.form.Panel', {
	title: '이용안내입력',
	id: 'form-reg2',
	region: 'center',
	autoScroll: true,
	//height: 70,
	tbar: [{
		xtype: 'button',
		id: 'btn-save2',
		text: '저장(2)',
		margin: '0 0 0 530',
		width: 70,
		handler: function() {
			fn_saveGoodsInfo('G', frReg2);
		}
	}],
	items: [{
		xtype: 'fieldset',
		title: '<span style="font-weight:bold;">상품 이용 안내</span>',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-guidance-use-time',
				name: 'GUIDANCE_USE_TIME',
				width: 300,
				fieldLabel: '이용시간',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 50,
				maxLength: 250,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-guidance-reqre-time',
				name: 'GUIDANCE_REQRE_TIME',
				width: 300,
				fieldLabel: '소요시간',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 50,
				maxLength: 250,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-guidance-age-div',
				name: 'GUIDANCE_AGE_DIV',
				width: 300,
				fieldLabel: '연령구분',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 50,
				maxLength: 250,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-guidance-tour-schdul',
				name: 'GUIDANCE_TOUR_SCHDUL',
				width: 300,
				fieldLabel: '여행일정',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 150,
				maxLength: 500,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-guidance-prfplc-lc',
				name: 'GUIDANCE_PRFPLC_LC',
				width: 300,
				fieldLabel: '공연장위치',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 150,
				maxLength: 500,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-guidance-edc-crse',
				name: 'GUIDANCE_EDC_CRSE',
				width: 300,
				fieldLabel: '교육과정',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 150,
				maxLength: 500,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-guidance-optn-matter',
				name: 'GUIDANCE_OPTN_MATTER',
				width: 300,
				fieldLabel: '옵션사항',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 150,
				maxLength: 500,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-guidance-pickup',
				name: 'GUIDANCE_PICKUP',
				width: 300,
				fieldLabel: '픽업',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 50,
				maxLength: 250,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-guidance-prparetg',
				name: 'GUIDANCE_PRPARETG',
				width: 300,
				fieldLabel: '준비물',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 50,
				maxLength: 250,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-guidance-incls-matter',
				name: 'GUIDANCE_INCLS_MATTER',
				width: 300,
				fieldLabel: '포함사항',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 80,
				maxLength: 250,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-guidance-not-incls-matter',
				name: 'GUIDANCE_NOT_INCLS_MATTER',
				width: 300,
				fieldLabel: '불포함사항',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 80,
				maxLength: 250,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		}]
	}]
});

/*
 * 상품정보입력 form 화면(3)
 */
var frReg3 = Ext.create('Ext.form.Panel', {
	title: '기타정보입력',
	id: 'form-reg3',
	region: 'center',
	autoScroll: true,
	//height: 70,
	tbar: [{
		xtype: 'button',
		id: 'btn-save3',
		text: '저장(3)',
		margin: '0 0 0 530',
		width: 70,
		handler: function() {
			fn_saveGoodsInfo('E', frReg3);

			Ext.Msg.show({
				 title:'확인',
				 msg: '저장하시겠습니까?',
				 buttons: Ext.Msg.YESNO,
				 icon: Ext.Msg.QUESTION,
				 fn: function(btn){
					if(btn == 'yes'){
						frReg3.getForm().submit({
							waitMsg: '저장중입니다...',
							url: '../updateGoods/',
							params: {
								'GOODS_CODE': Ext.getCmp('form-reg-goods-code').getValue(),
								'UPDT_SE': 'E'
							},
							success: function(form, action) {
								Ext.Msg.alert('알림', action.result.message, function(){
									//alert(action.result.GOODS_CODE);
								});
							},
							failure: function(form, action) {
								if(action.result.message) {
									Ext.Msg.alert('알림', action.result.message);
								} else {
									Ext.Msg.alert('알림', '저장 중 오류가 발생하였습니다. 다시 시도하여 주십시오.');
								}
							}
						});
					}
				 }
			});
		}
	}],
	items: [{
		xtype: 'fieldset',
		title: '<span style="font-weight:bold;">상품 기타 정보</span>',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-adit-guidance',
				name: 'ADIT_GUIDANCE',
				fieldLabel: '추가안내',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 150,
				maxLength: 500,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-atent-matter',
				name: 'ATENT_MATTER',
				fieldLabel: '유의사항',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 150,
				maxLength: 500,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textareafield',
				id: 'form-reg-change-refnd-regltn',
				name: 'CHANGE_REFND_REGLTN',
				fieldLabel: '변경/환불규정',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				grow: false,
				isFocus: false,
				width: 600,
				height: 150,
				maxLength: 500,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		}]
	}]
});

/*
 * 구매가능날짜 입력 grid
 */
Ext.define('GoodsSchdulInfo', {
	extend: 'Ext.data.Model',
	fields: [ {name:'GOODS_CODE', type:'string'}
			, {name:'SCHDUL_SN', type:'string'}
			, {name:'BEGIN_DE', type:'string'}
			, {name:'END_DE', type:'string'}
			, {name:'DELETE_AT', type:'string'}
			, {name:'CRUD', type:'string'}]
});

var storeSchdul = Ext.create('Ext.data.JsonStore', {
	//autoLoad: true,
	//pageSize: 100,
	model: 'GoodsSchdulInfo',
	proxy: {
		type: 'ajax',
		url: '../selectGoodsSchdul/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var gridSchdul = Ext.create('Ext.grid.Panel', {
	title: '구매가능날짜',
	//region:'center',
	store: storeSchdul,
	border: true,
	split : true,
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '시작일자',
		width: 150,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		renderer: Ext.util.Format.dateRenderer('Y-m-d'),
		editor: {xtype:'datefield', format: 'Y-m-d', maskRe: /[0-9]/, maxLength: 10, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'BEGIN_DE'
	},{
		text: '종료일자',
		width: 150,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		renderer: Ext.util.Format.dateRenderer('Y-m-d'),    //, autoCreate		: { tag: 'input', type: 'text', maxLength: '10' },
		editor: {xtype:'datefield', format: 'Y-m-d', maskRe: /[0-9]/, maxLength: 10, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'END_DE'
	},{
		text: '사용여부',
		width: 100,
		align: 'center',
		editor: combo,
		dataIndex: 'DELETE_AT',
		renderer: Ext.ux.comboBoxRenderer(combo)
	},{
		flex: 1
	}],
	tbar: [{
		text: '추가',
		margin: '0 7 0 293',
		width: 50,
		handler : function() {
			if(!Ext.getCmp('form-reg-goods-code').getValue()) {
				Ext.Msg.alert("알림", "선택한 상품이 없습니다.");
			} else {
				var idx = storeSchdul.getCount();
				var r = Ext.create('GoodsSchdulInfo', {
					GOODS_CODE : Ext.getCmp('form-reg-goods-code').getValue(),
					SCHDUL_SN : '',
					BEGIN_DE : '',
					END_DE : '',
					DELETE_AT : 'N',
					CRUD : 'I'
				});
				storeSchdul.insert(idx, r);
				cellEditing.startEditByPosition({row: idx, column: 0});
			}
		}
	}, {
		text: '삭제',
		width: 50,
		handler: function() {
			var sm = gridSchdul.getSelectionModel();
			storeSchdul.remove(sm.getSelection());
			if (storeSchdul.getCount() > 0) {
				sm.select(0);
			}
		}
	}, {
		text: '저장',
		width: 50,
		handler: function() {
			var datas = new Array();

			var inserted = storeSchdul.getNewRecords();
			var modified = storeSchdul.getUpdatedRecords();
			var deleted = storeSchdul.getRemovedRecords();

			if (modified.length + inserted.length + deleted.length > 0) {
				for (var i = 0; i < modified.length; i++) {
					var str  = modified[i].data.BEGIN_DE;
					var str2 = modified[i].data.END_DE;
					var dt  = new Date(str);
					var dt2 = new Date(str2);

					modified[i].set('BEGIN_DE', Ext.Date.format(dt, 'Y-m-d'));
					modified[i].set('END_DE', Ext.Date.format(dt2, 'Y-m-d'));
					modified[i].set('CRUD', 'U');
					datas.push(modified[i].data);
				}

				for (var i = 0; i < inserted.length; i++) {
					var str  = inserted[i].data.BEGIN_DE;
					var str2 = inserted[i].data.END_DE;
					var dt  = new Date(str);
					var dt2 = new Date(str2);

					inserted[i].set('BEGIN_DE', Ext.Date.format(dt, 'Y-m-d'));
					inserted[i].set('END_DE', Ext.Date.format(dt2, 'Y-m-d'));
					inserted[i].set('CRUD', 'C');
					datas.push(inserted[i].data);
				}

				for (var i = 0; i < deleted.length; i++) {
					deleted[i].set('CRUD', 'D');
					datas.push(deleted[i].data);
				}

				formSave.getForm().submit({
					waitMsg: '저장중입니다...',
					url: '../saveGoodsSchdul/',
					params: {'data': Ext.JSON.encode(datas)},
					success: function(form, action) {
						Ext.Msg.alert('알림', '저장되었습니다.', function(){
							storeSchdul.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
						});
					},
					failure: function(form, action) {
						fn_failureMessage(action.response);
					}
				});
			} else {
				alert('변경된 자료가 없습니다.');
			}
		}
	}],
	plugins: [cellEditing]
});

/*
 * 구매가능시각 입력 grid
 */
var cellEditing2 = Ext.create('Ext.grid.plugin.CellEditing', {
    clicksToEdit: 1
});

Ext.define('GoodsTimeInfo', {
	extend: 'Ext.data.Model',
	fields: [ {name:'GOODS_CODE', type:'string'}
			, {name:'TIME_SN', type:'string'}
			, {name:'BEGIN_TIME', type:'string'}
			, {name:'BEGIN_HH', type:'string'}
			, {name:'BEGIN_MI', type:'string'}
			, {name:'END_TIME', type:'string'}
			, {name:'END_HH', type:'string'}
			, {name:'END_MI', type:'string'}
			, {name:'DELETE_AT', type:'string'}
			, {name:'CRUD', type:'string'}]
});

var storeTime = Ext.create('Ext.data.JsonStore', {
	//autoLoad: true,
	//pageSize: 100,
	model: 'GoodsTimeInfo',
	proxy: {
		type: 'ajax',
		url: '../selectGoodsTime/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var gridTime = Ext.create('Ext.grid.Panel', {
	title: '구매가능시각',
	//region:'center',
	store: storeTime,
	border: true,
	split : true,
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '시작시각',
		width: 150,
		align: 'center',
		editor: comboBeginTime,
		dataIndex: 'BEGIN_TIME',
		renderer: Ext.ux.comboBoxRenderer(comboBeginTime)
	},{
		text: '종료시각',
		width: 150,
		align: 'center',
		editor: comboEndTime,
		dataIndex: 'END_TIME',
		renderer: Ext.ux.comboBoxRenderer(comboEndTime)
	},{
		text: '사용여부',
		width: 100,
		align: 'center',
		editor: combo,
		dataIndex: 'DELETE_AT',
		renderer: Ext.ux.comboBoxRenderer(combo)
	},{
		flex: 1
	}],
	/*bbar: Ext.create('Ext.PagingToolbar', {
		store: store,
		displayInfo: true,
		displayMsg: 'Displaying topics {0} - {1} of {2}',
		emptyMsg: "No topics to display"
	}),*/
	tbar: [{
		text: '추가',
		margin: '0 7 0 293',
		width: 50,
		handler : function() {
			if(!Ext.getCmp('form-reg-goods-code').getValue()) {
				Ext.Msg.alert("알림", "선택한 상품이 없습니다.");
			} else {
				var idx = storeTime.getCount();
				var r = Ext.create('GoodsTimeInfo', {
					GOODS_CODE : Ext.getCmp('form-reg-goods-code').getValue(),
					TIME_SN : '',
					BEGIN_TIME : '0000',
					BEGIN_HH : '',
					BEGIN_MI : '',
					END_TIME : '0000',
					END_HH : '',
					END_MI : '',
					DELETE_AT : 'N',
					CRUD : 'I'
				});
				storeTime.insert(idx, r);
				cellEditing2.startEditByPosition({row: idx, column: 0});
			}
		}
	}, {
		text: '삭제',
		width: 50,
		handler: function() {
			var sm = gridTime.getSelectionModel();
			storeTime.remove(sm.getSelection());
			if (storeTime.getCount() > 0) {
				sm.select(0);
			}
		}
	}, {
		text: '저장',
		width: 50,
		handler: function() {
			var datas = new Array();

			var inserted = storeTime.getNewRecords();
			var modified = storeTime.getUpdatedRecords();
			var deleted = storeTime.getRemovedRecords();

			if (modified.length + inserted.length + deleted.length > 0) {
				for (var i = 0; i < modified.length; i++) {
					modified[i].set('CRUD', 'U');
					datas.push(modified[i].data);
				}

				for (var i = 0; i < inserted.length; i++) {
					inserted[i].set('CRUD', 'C');
					datas.push(inserted[i].data);
				}

				for (var i = 0; i < deleted.length; i++) {
					deleted[i].set('CRUD', 'D');
					datas.push(deleted[i].data);
				}

				formSave.getForm().submit({
					waitMsg: '저장중입니다...',
					url: '../saveGoodsTime/',
					params: {'data': Ext.JSON.encode(datas)},
					success: function(form, action) {
						Ext.Msg.alert('알림', '저장되었습니다.', function(){
							storeTime.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
						});
					},
					failure: function(form, action) {
						fn_failureMessage(action.response);
					}
				});
			} else {
				alert('변경된 자료가 없습니다.');
			}
		}
	}],
	plugins: [cellEditing2]
});

/*
 * 금액옵션설정 입력 grid
 */
var cellEditing3 = Ext.create('Ext.grid.plugin.CellEditing', {
    clicksToEdit: 1
});

Ext.define('GoodsNmprInfo', {
	extend: 'Ext.data.Model',
	fields: [ {name:'GOODS_CODE', type:'string'}
			, {name:'NMPR_SN', type:'string'}
			, {name:'NMPR_CND', type:'string'}
			, {name:'SETUP_AMOUNT', type:'string'}
			, {name:'SORT_ORDR', type:'string'}
			, {name:'DELETE_AT', type:'string'}
			, {name:'CRUD', type:'string'}]
});

var storeNmpr = Ext.create('Ext.data.JsonStore', {
	//autoLoad: true,
	//pageSize: 100,
	model: 'GoodsNmprInfo',
	proxy: {
		type: 'ajax',
		url: '../selectGoodsNmpr/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var gridNmpr = Ext.create('Ext.grid.Panel', {
	title: '금액옵션설정',
	//region:'center',
	store: storeNmpr,
	border: true,
	split : true,
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '조건',
		width: 200,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		editor: {xtype:'textfield', allowBlank: false, maxLength: 50, fieldStyle: {'ime-mode':'active'}, enforceMaxLength: true},
		dataIndex: 'NMPR_CND'
	},{
		text: '금액',
		width: 150,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		editor: {xtype:'textfield', allowBlank: false, maxLength: 10, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'SETUP_AMOUNT'
	},{
		text: '정렬순서',
		width: 100,
		align: 'center',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 3, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'SORT_ORDR'
	},{
		text: '사용여부',
		width: 100,
		align: 'center',
		editor: combo,
		dataIndex: 'DELETE_AT',
		renderer: Ext.ux.comboBoxRenderer(combo)
	},{
		flex: 1
	}],
	tbar: [{
		text: '추가',
		margin: '0 7 0 293',
		width: 50,
		handler : function() {
			if(!Ext.getCmp('form-reg-goods-code').getValue()) {
				Ext.Msg.alert("알림", "선택한 상품이 없습니다.");
			} else {
				var idx = storeNmpr.getCount();
				var r = Ext.create('GoodsNmprInfo', {
					GOODS_CODE : Ext.getCmp('form-reg-goods-code').getValue(),
					NMPR_SN : '',
					NMPR_CND : '',
					SETUP_AMOUNT : '',
					SORT_ORDR: '',
					DELETE_AT : 'N',
					CRUD : 'I'
				});
				storeNmpr.insert(idx, r);
				cellEditing3.startEditByPosition({row: idx, column: 0});
			}
		}
	}, {
		text: '삭제',
		width: 50,
		handler: function() {
			var sm = gridNmpr.getSelectionModel();
			storeNmpr.remove(sm.getSelection());
			if (storeNmpr.getCount() > 0) {
				sm.select(0);
			}
		}
	}, {
		text: '저장',
		width: 50,
		handler: function() {
			var datas = new Array();

			var inserted = storeNmpr.getNewRecords();
			var modified = storeNmpr.getUpdatedRecords();
			var deleted = storeNmpr.getRemovedRecords();

			if (modified.length + inserted.length + deleted.length > 0) {
				for (var i = 0; i < modified.length; i++) {
					modified[i].set('CRUD', 'U');
					datas.push(modified[i].data);
				}

				for (var i = 0; i < inserted.length; i++) {
					inserted[i].set('CRUD', 'C');
					datas.push(inserted[i].data);
				}

				for (var i = 0; i < deleted.length; i++) {
					deleted[i].set('CRUD', 'D');
					datas.push(deleted[i].data);
				}

				formSave.getForm().submit({
					waitMsg: '저장중입니다...',
					url: '../saveGoodsNmpr/',
					params: {'data': Ext.JSON.encode(datas)},
					success: function(form, action) {
						Ext.Msg.alert('알림', '저장되었습니다.', function(){
							storeNmpr.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
						});
					},
					failure: function(form, action) {
						fn_failureMessage(action.response);
					}
				});
			} else {
				alert('변경된 자료가 없습니다.');
			}
		}
	}],
	plugins: [cellEditing3]
});

/*
 * 이미지등록 form 화면
 */
var frFile = Ext.create('Ext.form.Panel', {
	//title: '상품정보입력',
	id: 'form-file',
	region: 'center',
	autoScroll: true,
	items: [{
		xtype: 'fieldcontainer',
		layout: 'hbox',
		items: [{
			xtype: 'fieldset',
			title: '<span style="font-weight:bold;">이미지 등록</span>',
			padding: '10 20 10 10',
			items: [{
				xtype: 'fieldcontainer',
				layout: 'hbox',
				items: [{
					xtype: 'filefield',
		    		name: 'ATTACH_FLIE',
		    		regex: /^.*\.(BMP|GIF|JPG|JPEG|PNG|bmp|gif|jpg|jpeg|png)$/,
		    		regexText: '이지미 파일을 선택하세요.',
		    		buttonText: '찾기...',
		    		fieldLabel: '첨부파일',
		    		labelAlign: 'right',
		    		labelSeparator: ':',
		    		labelWidth: 100,
		    		allowBlank: false,
		    		width: 510
				},{
					xtype: 'button',
					text: '업로드',
					width: 60,
					margin: '0 0 0 5',
					listeners: {
						click: function (btn, e, opts) {
							var form = Ext.getCmp('form-file').getForm();
							if (form.isValid()) {
								form.submit({
									timeout: 30*60*1000,
									waitMsg: '잠시만 기다려주십시오...',
									url: '../uploadGoodsFile/',
									method: 'POST',
									params: {GOODS_CODE: Ext.getCmp('form-reg-goods-code').getValue()},
									success: function(form, action) {
										Ext.Msg.alert('알림', '저장되었습니다.', function(){
											storeFile.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
										});
									},
									failure: function(form, action) {
										fn_failureMessage(action.response);
									}
								});
							} else {
								console.log('is not valid');
								Ext.Msg.alert('확인', '업로드할 파일(png,jpg)을 선택하십시오.');
							}
						}
					}
				}]
			}]
		}]
	}]
});

/*
 * 이미지목록 grid
 */
Ext.define('GoodsFileInfo', {
	extend: 'Ext.data.Model',
	fields: [ {name:'FILE_CODE', type:'string'}
			, {name:'FILE_SN', type:'string'}
			, {name:'FILE_NM', type:'string'}
			, {name:'REPRSNT_AT', type:'string'}
			, {name:'SORT_NO', type:'string'}
			, {name:'CRUD', type:'string'}]
});

var storeFile = Ext.create('Ext.data.JsonStore', {
	//autoLoad: true,
	//pageSize: 100,
	model: 'GoodsFileInfo',
	proxy: {
		type: 'ajax',
		url: '../selectGoodsFile/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var gridFile = Ext.create('Ext.grid.Panel', {
	//title: '이미지등록',
	//region:'center',
	store: storeFile,
	border: true,
	split : true,
	plugins: Ext.create('Ext.grid.plugin.CellEditing', {clicksToEdit: 1}),
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '파일',
		width: 400,
		style: 'text-align:center',
		sortable: false,
		menuDisabled: true,
		dataIndex: 'FILE_NM'
	},{
		text: '대표여부',
		width: 100,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		editor: comboYn,
		dataIndex: 'REPRSNT_AT',
		renderer: Ext.ux.comboBoxRenderer(comboYn)
	},{
		text: '정렬순서',
		width: 100,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		editor: {xtype:'textfield', allowBlank: false, maxLength: 2, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'SORT_NO'
	},{
		flex: 1
	}],
	tbar: [{
		text: '삭제',
		width: 50,
		margin: '0 7 0 485',
		handler: function() {
			var sm = gridFile.getSelectionModel();
			storeFile.remove(sm.getSelection());
			if (storeFile.getCount() > 0) {
				sm.select(0);
			}
		}
	}, {
		text: '저장',
		width: 50,
		handler: function() {
			var datas = new Array();

			var inserted = storeFile.getNewRecords();
			var modified = storeFile.getUpdatedRecords();
			var deleted = storeFile.getRemovedRecords();

			if (modified.length + inserted.length + deleted.length > 0) {
				for (var i = 0; i < modified.length; i++) {
					modified[i].set('CRUD', 'U');
					datas.push(modified[i].data);
				}

				for (var i = 0; i < deleted.length; i++) {
					deleted[i].set('CRUD', 'D');
					datas.push(deleted[i].data);
				}

				formSave.getForm().submit({
					waitMsg: '저장중입니다...',
					url: '../saveGoodsFile/',
					params: {'data': Ext.JSON.encode(datas)},
					success: function(form, action) {
						Ext.Msg.alert('알림', '저장되었습니다.', function(){
							storeFile.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
						});
					},
					failure: function(form, action) {
						fn_failureMessage(action.response);
					}
				});
			} else {
				alert('변경된 자료가 없습니다.');
			}
		}
	}]
});

var filePanel = Ext.create('Ext.panel.Panel', {
	title: '이미지등록',
	width: 600,
	height: 400,
	layout: {
		type: 'vbox',        // Arrange child items vertically
		align: 'stretch',    // Each takes up full width
		padding: 5
	},
	items: [frFile, {
		xtype: 'splitter'   // A splitter between the two child items
	}, {                    // Details Panel specified as a config object (no xtype defaults to 'panel').
		items: [gridFile],  // An array of form fields
		flex: 2             // Use 2/3 of Container's height (hint to Box layout)
	}]
});

/*
 * 화면 레이아웃을 구성한다.
 */
Ext.onReady(function(){
	Ext.create('Ext.Viewport', {
		layout: 'border',
		//padding:'5 5 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [frSearch, Ext.create('Ext.tab.Panel', {
			id: 'tabs',
			activeTab: 0,
			layout: 'border',
			region: 'center',
			padding:'5 5 5 5',
			style: {
				backgroundColor: '#FFFFFF'
			},
			items: [frReg, frReg2, frReg3, gridNmpr, gridSchdul, gridTime, filePanel]
		})]
	});

	//Ext.getCmp('form-reg-sch-goods-code').setValue('0000000064');
	//Ext.getCmp('form-reg-goods-code').setValue('0000000064');
});

