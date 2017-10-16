var formSave = Ext.create('Ext.form.Panel', {});

var selGridNmprIdx = 0;

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
	editable: false,
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
	editable: false,
	emptyText: '선택'
});

var storeSetupSe = new Ext.create('Ext.data.ArrayStore', {
	fields:['code', 'name'],
	data :[
		['P', '단가(인원)'],
		['R', '객실'],
		['E', '식사'],
		['C', '체크인/아웃']
	]
});

var comboSetupSe = new Ext.create('Ext.form.ComboBox', {
	id: 'combo-setup-se',
	store: storeSetupSe,
	displayField: 'name',
	valueField: 'code',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	lazyRender: true,
	editable: false
	//emptyText: '선택'
	/*listeners: {
		change : function(combo, newValue, oldValue, eOpts ) {
			if(Ext.getCmp('form-reg-cl-se').getValue() == 'G' || Ext.getCmp('form-reg-cl-se').getValue() == 'P') {
				if(newValue != 'P') {
					Ext.Msg.alert('확인', '일반상품, 픽업서비스는 단가(인원)만 입력합니다.', function(){
						combo.setValue('P');
						return;
					});
				}
			} else {
				if(newValue == 'P') {
					Ext.Msg.alert('확인', '숙박시설은 단가(인원)을 입력하지 않습니다.', function(){
						combo.setValue('P');
						return;
					});
				}
			}
		}
	}*/
});

var comboFixedAt = new Ext.create('Ext.form.ComboBox', {
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data :[
			['Y', '정가'],
			['N', '비율계산']
		]
	}),
	displayField: 'name',
	valueField: 'code',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	lazyRender: true,
	editable: false,
	emptyText: '선택',
	listeners: {
		change : function(combo, newValue, oldValue, eOpts ) {
			var sm = gridNmpr.getSelectionModel();
			if(newValue == 'Y') {
				//console.log('newValue:'+newValue+'/oldValue:'+oldValue);
				sm.getSelection()[0].set('SETUP_RATE', '');
				cellEditing3.startEditByPosition({row: selGridNmprIdx, column: 3});
			} else {
				if(sm.getSelection()[0].get('SETUP_SE') == 'C') {
					sm.getSelection()[0].set('SETUP_AMOUNT', '');
					cellEditing3.startEditByPosition({row: selGridNmprIdx, column: 4});
				} else {
					alert( '비율계산은 체크인/아웃만 설정 가능합니다.');
					//Ext.Msg.alert('확인', '비율계산은 체크인/아웃만 설정 가능합니다.', function(){
						combo.setValue(oldValue);
					//});
				}
			}
		}
	}
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
	editable: false,
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
	editable: false,
	emptyText: '선택'
});

/*
 * 국가 코드 combo
 */
var comboNation = new Ext.create('Ext.form.ComboBox', {
	id: 'form-reg-nation-code',
	name: 'NATION_CODE',
	width: 275,
	fieldLabel: '도시코드',
	labelAlign: 'right',
	labelWidth: 100,
	store: new Ext.create('Ext.data.JsonStore', {
		autoLoad: true,
		fields:['CTY_CODE', 'CTY_NM', 'USE_AT', 'NATION_CODE'],
		proxy: {
			type: 'ajax',
			url: '../selectCtyList/?NATION_CODE=00000',
			reader: {
				type: 'json',
				root: 'data',
				totalProperty: 'rows'
			}
		}
	}),
	displayField: 'CTY_NM',
	valueField: 'CTY_CODE',
	queryMode: 'local',
	typeAhead: true,
	editable: false,
	allowBlank: false,
	value: '00001',
	//forceSelection: true,
	//emptyText: '선택',
	listeners: {
		afterrender: function(combo, eOpts ){
			comboCty.getStore().load({params:{NATION_CODE:'00001'}});
		},
		change: function(combo, newValue, oldValue, eOpts ) {
			var rec = combo.getStore().findRecord('CTY_CODE', newValue);
			if(rec) {
				Ext.getCmp('form-reg-cty-code').setValue('');
				comboCty.getStore().load({params:{NATION_CODE:newValue}});
			}
		}
	}
});

/*
 * 도시 코드 combo
 */
var comboCty = new Ext.create('Ext.form.ComboBox', {
	id: 'form-reg-cty-code',
	name: 'CTY_CODE',
	width: 170,
	store: new Ext.create('Ext.data.JsonStore', {
		autoLoad: false,
		fields:['CTY_CODE', 'CTY_NM', 'USE_AT', 'NATION_CODE'],
		proxy: {
			type: 'ajax',
			url: '../selectCtyList/',
			reader: {
				type: 'json',
				root: 'data',
				totalProperty: 'rows'
			}
		}
	}),
	displayField: 'CTY_NM',
	valueField: 'CTY_CODE',
	queryMode: 'local',
	typeAhead: true,
	allowBlank: false,
	editable: false,
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
		fields:['CL_CODE', 'CL_NM', 'CL_SE', 'DELETE_AT'],
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
	allowBlank: false,
	emptyText: '선택',
	// Template for the dropdown menu.
	// Note the use of "x-boundlist-item" class,
	// this is required to make the items selectable.
	tpl: Ext.create('Ext.XTemplate',
		'<tpl for=".">',
		"<tpl if='DELETE_AT == \"Y\"'><font color='red'>",
			'<div class="x-boundlist-item">{CL_NM} (삭제됨)</div>',
		'</font></tpl>',
		"<tpl if='DELETE_AT != \"Y\"'>",
			'<div class="x-boundlist-item">{CL_NM}</div>',
		'</tpl>',
		'</tpl>'
	),
	// template for the content inside text field
	displayTpl: Ext.create('Ext.XTemplate',
		'<tpl for=".">',
			'{CL_NM}',
		'</tpl>'
	),
	listeners: {
		change: function(combo, newValue, oldValue, eOpts ) {
			var rec = combo.getStore().findRecord('CL_CODE', newValue);
			if(rec) {
				Ext.getCmp('form-reg-cl-se').setValue(rec.get('CL_SE'));
				Ext.getCmp('form-reg-cl-code').setValue('');
				comboCl.getStore().load({params:{UPPER_CL_CODE:newValue}});
			}
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
		fields:['CL_CODE', 'CL_NM', 'CL_SE', 'DELETE_AT'],
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
	allowBlank: false,
	editable: false,
	emptyText: '선택',
	// Template for the dropdown menu.
	// Note the use of "x-boundlist-item" class,
	// this is required to make the items selectable.
	tpl: Ext.create('Ext.XTemplate',
		'<tpl for=".">',
		"<tpl if='DELETE_AT == \"Y\"'><font color='red'>",
			'<div class="x-boundlist-item">{CL_NM} (삭제됨)</div>',
		'</font></tpl>',
		"<tpl if='DELETE_AT != \"Y\"'>",
			'<div class="x-boundlist-item">{CL_NM}</div>',
		'</tpl>',
		'</tpl>'

	),
	// template for the content inside text field
	displayTpl: Ext.create('Ext.XTemplate',
		'<tpl for=".">',
			'{CL_NM}',
		'</tpl>'
	)
});

function fn_activeNextTab() {
	if(Ext.getCmp('form-reg-crud-se').getValue() == 'C') {
		Ext.Msg.confirm('확인', '상품 내용을 계속 입력하시겠습니까?', function(btn) {
			if(btn == 'yes') {
				var activeTab = Ext.getCmp('reg-tabs').getActiveTab();
				var activeTabIndex = Ext.getCmp('reg-tabs').items.findIndex('id', activeTab.id);
				var nextActiveTabIndex = activeTabIndex + 1;
				Ext.getCmp('reg-tabs').setActiveTab(nextActiveTabIndex);
			}
		});
	}
};

/**
 * 상품저장
 * @param sDiv (I:기본정보저장, G:이용안내저장, E:기타정보저장, D:상품삭제)
 * @param frSave
 */
function fn_saveGoodsInfo(sDiv, frSave) {

	var sUrl = '../insertGoods/';
	var stParams = {};
	var sMsg = '저장';

	if(sDiv == 'D') {
		sUrl = '../deleteGoods/';
		sMsg = '사용안함 처리';
	} else if(sDiv != 'I') {
		sUrl = '../updateGoods/';
		stParams = {
			'GOODS_CODE': Ext.getCmp('form-reg-goods-code').getValue(),
			'UPDT_SE': sDiv
		};
	}

	if(!frSave.getForm().isValid()) {
		alert('입력값 오류');
		return;
	}

	Ext.Msg.show({
		 title:'확인',
		 msg: sMsg+'하시겠습니까?',
		 buttons: Ext.Msg.YESNO,
		 icon: Ext.Msg.QUESTION,
		 fn: function(btn){
			if(btn == 'yes'){
				frSave.getForm().submit({
					waitMsg: sMsg+'중입니다...',
					url: sUrl,
					params: stParams,
					success: function(form, action) {
						Ext.Msg.alert('알림', action.result.message, function(){
							if(sDiv == 'I') {
								Ext.getCmp('form-reg-goods-code').setValue(action.result.GOODS_CODE);
								Ext.getCmp('form-reg-crud-se').setValue('C');
							} else if(sDiv == 'D') {
								frReg.getForm().reset();
								frReg2.getForm().reset();
								frReg3.getForm().reset();
								storeSchdul.removeAll();
								storeTime.removeAll();
								storeNmpr.removeAll();
								storeFile.removeAll();
							}
							fn_activeNextTab();
						});
					},
					failure: function(form, action) {
						if(action.result.message) {
							Ext.Msg.alert('알림', action.result.message);
						} else {
							Ext.Msg.alert('알림', sMsg+' 중 오류가 발생하였습니다. 다시 시도하여 주십시오.');
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
			, {name:'NATION_CODE', type:'string'}
			, {name:'CTY_CODE', type:'string'}
			, {name:'CL_SE', type:'string'}
			, {name:'SORT_ORDR', type:'string'}
			, {name:'MAIN_EXPSR_AT_1', type:'string'}
			, {name:'MAIN_EXPSR_AT_2', type:'string'}
			, {name:'CRUD_SE', type:'string'}]
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
			if(store.getCount()) {
				frReg.getForm().loadRecord(store.getAt(0));
				frReg2.getForm().loadRecord(store.getAt(0));
				frReg3.getForm().loadRecord(store.getAt(0));

				storeSchdul.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
				storeTime.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
				storeNmpr.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
				storeFile.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});

				if(store.getAt(0).data.DELETE_AT == 'Y') {
					Ext.getCmp('btn-save1').disable();
					Ext.getCmp('btn-save2').disable();
					Ext.getCmp('btn-save3').disable();
					//Ext.getCmp('btn-add').disable();
					Ext.getCmp('btn-del').disable();

					Ext.getCmp('btn-add-schdul').disable();
					Ext.getCmp('btn-del-schdul').disable();
					Ext.getCmp('btn-save-schdul').disable();

					Ext.getCmp('btn-add-time').disable();
					Ext.getCmp('btn-del-time').disable();
					Ext.getCmp('btn-save-time').disable();

					Ext.getCmp('btn-add-nmpr').disable();
					Ext.getCmp('btn-del-nmpr').disable();
					Ext.getCmp('btn-save-nmpr').disable();

					Ext.getCmp('btn-del-file').disable();
					Ext.getCmp('btn-save-file').disable();
					Ext.getCmp('btn-upload-file').disable();
				}
			}
			Ext.getBody().unmask();
		}
	}
});
/*
 * 검색 form
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
*/
/*
 * 기본정보입력 form 화면(1)
 */
var frReg = Ext.create('Ext.form.Panel', {
	title: '기본정보입력',
	id: 'form-reg',
	region: 'center',
	autoScroll: true,
	margin: '0 5 0 10',
	tbar: [{
		xtype: 'button',
		id: 'btn-save1',
		text: '저장',
		margin: '0 0 0 390',
		width: 60,
		handler: function() {
			if(Ext.getCmp('form-reg-goods-code').getValue()) {
				fn_saveGoodsInfo('U', frReg);
			} else {
				fn_saveGoodsInfo('I', frReg);
			}
		}
	}, {
		xtype: 'button',
		id: 'btn-add',
		text: '신규',
		margin: '0 0 0 5',
		width: 60,
		handler: function() {
			Ext.Msg.confirm('확인', '작업을 중단하고 신규로 작성하시겠습니까?', function(btn) {
				 if(btn == 'yes') {
					Ext.getCmp('btn-save1').enable();
					Ext.getCmp('btn-save2').enable();
					Ext.getCmp('btn-save3').enable();
					Ext.getCmp('btn-del').enable();

					Ext.getCmp('btn-add-schdul').enable();
					Ext.getCmp('btn-del-schdul').enable();
					Ext.getCmp('btn-save-schdul').enable();

					Ext.getCmp('btn-add-time').enable();
					Ext.getCmp('btn-del-time').enable();
					Ext.getCmp('btn-save-time').enable();

					Ext.getCmp('btn-add-nmpr').enable();
					Ext.getCmp('btn-del-nmpr').enable();
					Ext.getCmp('btn-save-nmpr').enable();

					Ext.getCmp('btn-del-file').enable();
					Ext.getCmp('btn-save-file').enable();
					Ext.getCmp('btn-upload-file').enable();

					frReg.getForm().reset();
					frReg2.getForm().reset();
					frReg3.getForm().reset();
					storeSchdul.removeAll();
					storeTime.removeAll();
					storeNmpr.removeAll();
					storeFile.removeAll();
				}
			});
		}
	}, {
		xtype: 'button',
		id: 'btn-del',
		text: '사용안함',
		margin: '0 0 0 5',
		width: 80,
		handler: function() {
			if(Ext.getCmp('form-reg-goods-code').getValue()) {
				fn_saveGoodsInfo('D', frReg)
			} else {
				return;
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
			items: [comboNation, {
				xtype: 'label',
				width: 5
			}, comboCty]
		},{
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
			width: 600,
			maxLength: 100,
			enforceMaxLength: true,
			allowBlank: false,
			enableKeyEvents: true
		},{
			xtype: 'textareafield',
			id: 'form-reg-goods-intrcn',
			name: 'GOODS_INTRCN',
			fieldLabel: '상품설명<br>(4000자)',
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
			allowBlank: false,
			enableKeyEvents: true
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			hidden: true,
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
				width: 60,
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
				width: 60,
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
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'checkboxfield',
				id: 'form-reg-main_expsr_at_1',
				name: 'MAIN_EXPSR_AT_1',
				width: 220,
				fieldLabel: '메인노출여부',
				labelWidth: 100,
				labelAlign: 'right',
				boxLabel  : '첫 번째 노출',
				inputValue: 'Y',
				value: 'Y'
			},{
				xtype: 'label',
				width: 5
			},{
				xtype: 'checkboxfield',
				id: 'form-reg-main_expsr_at_2',
				name: 'MAIN_EXPSR_AT_2',
				hideLabel: true,
				//fieldLabel: '메인노출여부',
				//labelAlign: 'right',
				boxLabel : '두 번째 노출',
				width: 120,
				inputValue: 'Y'
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textfield',
				id: 'form-reg-sort-ordr',
				name: 'SORT_ORDR',
				width: 250,
				fieldLabel: '정렬순서',
				fieldStyle: {'ime-mode':'disabled'},
				labelWidth: 100,
				labelAlign: 'right',
				maskRe: /[0-9]/,
				maxLength: 3,
				enforceMaxLength: true,
				allowBlank: true,
				enableKeyEvents: true
			}]
		}]
	},{
		xtype: 'fieldset',
		title: '<span style="font-weight:bold;">상품 간략 정보</span>(10자 이내로 입력)',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'combobox',
				id: 'form-reg-intrcn-goods-ty',
				name: 'INTRCN_GOODS_TY',
				store: new Ext.create('Ext.data.ArrayStore', {
					fields:['code', 'name'],
					data :[
						['G', '단체투어'],
						['P', '프라이빗투어']
					]
				}),
				width: 300,
				fieldLabel: '상품유형',
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				displayField: 'name',
				valueField: 'code',
				mode: 'local',
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				editable: false,
				emptyText: '선택'
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
				xtype: 'combobox',
				id: 'form-reg-vochr-ticket-ty',
				name: 'VOCHR_TICKET_TY',
				store: new Ext.create('Ext.data.ArrayStore', {
					fields:['code', 'name'],
					data :[
						['V', 'E-바우처'],
						['T', 'E-티켓(캡쳐가능)'],
						['E', '확정메일(캡쳐가능)']
					]
				}),
				width: 300,
				fieldLabel: '티켓유형',
				labelSeparator: ':',
				labelWidth: 100,
				labelAlign: 'right',
				displayField: 'name',
				valueField: 'code',
				mode: 'local',
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				editable: false,
				emptyText: '선택'
			}, {
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
				fieldLabel: '사용방법<br>(500자)',
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
		hidden: true,
		padding: '10 20 10 10',
		items: [{
			xtype: 'textfield', width: 600, labelWidth: 200, labelAlign: 'right',
			id: 'form-reg-goods-code', name: 'GOODS_CODE', fieldLabel: 'GOODS_CODE'
		},{
			xtype: 'textfield', width: 600, labelWidth: 200, labelAlign: 'right',
			id: 'form-reg-cl-se', name: 'CL_SE', fieldLabel: 'CL_SE',
			listeners: {
				change: function(tf, newValue, oldValue, eOpts ) {
					if(newValue == 'S') {
						storeSetupSe = new Ext.create('Ext.data.ArrayStore', {
							fields:['code', 'name'],
							data :[
								['R', '객실'],
								['E', '식사'],
								['C', '체크인/아웃']
							]
						});
					} else {
						storeSetupSe = new Ext.create('Ext.data.ArrayStore', {
							fields:['code', 'name'],
							data :[
								['P', '단가(인원)']							       
							]
						});
					}
					Ext.getCmp('combo-setup-se').getStore().removeAll();
					Ext.getCmp('combo-setup-se').bindStore(storeSetupSe);
				}
			}
		},{
			xtype: 'textfield', width: 600, labelWidth: 200, labelAlign: 'right',
			id: 'form-reg-delete-at', name: 'DELETE_AT', fieldLabel: 'DELETE_AT'
		},{
			xtype: 'textfield', width: 600, labelWidth: 200, labelAlign: 'right',
			id: 'form-reg-crud-se', name: 'CRUD_SE', fieldLabel: 'CRUD_SE'
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
	margin: '0 0 0 10',
	tbar: [{
		xtype: 'button',
		id: 'btn-save2',
		text: '저장',
		margin: '0 0 0 540',
		width: 60,
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
				fieldLabel: '이용시간<br>(50자)',
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
				fieldLabel: '소요시간<br>(50자)',
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
				fieldLabel: '연령구분<br>(100자)',
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
				fieldLabel: '여행일정<br>(500자)',
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
				fieldLabel: '공연장위치<br>(500자)',
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
				fieldLabel: '교육과정<br>(500자)',
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
				fieldLabel: '옵션사항<br>(500자)',
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
				fieldLabel: '픽업<br>(100자)',
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
				fieldLabel: '준비물<br>(100자)',
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
				fieldLabel: '포함사항<br>(250자)',
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
				fieldLabel: '불포함사항<br>(250자)',
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
	margin: '0 0 0 10',
	tbar: [{
		xtype: 'button',
		id: 'btn-save3',
		text: '저장',
		margin: '0 0 0 540',
		width: 60,
		handler: function() {
			fn_saveGoodsInfo('E', frReg3);
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
				fieldLabel: '추가안내<br>(500자)',
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
				fieldLabel: '유의사항<br>(500자)',
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
				fieldLabel: '변경/환불규정<br>(500자)',
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
	id: 'grid-schdul',
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
		id: 'btn-add-schdul',
		margin: '0 5 0 415',
		width: 60,
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
		id: 'btn-del-schdul',
		width: 60,
		handler: function() {
			var sm = gridSchdul.getSelectionModel();
			storeSchdul.remove(sm.getSelection());
			/*if (storeSchdul.getCount() > 0) {
				sm.select(0);
			}*/
		}
	}, {
		text: '저장',
		id: 'btn-save-schdul',
		width: 60,
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
							fn_activeNextTab();
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
	id: 'grid-time',
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
		id: 'btn-add-time',
		margin: '0 5 0 415',
		width: 60,
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
		id: 'btn-del-time',
		width: 60,
		handler: function() {
			var sm = gridTime.getSelectionModel();
			storeTime.remove(sm.getSelection());
			/*if (storeTime.getCount() > 0) {
				sm.select(0);
			}*/
		}
	}, {
		text: '저장',
		id: 'btn-save-time',
		width: 60,
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
							fn_activeNextTab();
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
			, {name:'SETUP_SE', type:'string'}
			, {name:'NMPR_SN', type:'string'}
			, {name:'NMPR_CND', type:'string'}
			, {name:'FIXED_AT', type:'string'}
			, {name:'SETUP_AMOUNT', type:'string'}
			, {name:'SETUP_RATE', type:'string'}
			, {name:'NMPR_CO', type:'string'}
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
	id: 'grid-nmpr',
	//region:'center',
	store: storeNmpr,
	border: true,
	split : true,
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '설정구분',
		width: 100,
		align: 'center',
		editor: comboSetupSe,
		dataIndex: 'SETUP_SE',
		renderer: Ext.ux.comboBoxRenderer(comboSetupSe)
	},{
		text: '조건',
		width: 170,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		editor: {xtype:'textfield', allowBlank: false, maxLength: 50, fieldStyle: {'ime-mode':'active'}, enforceMaxLength: true},
		dataIndex: 'NMPR_CND'
	},{
		text: '정가구분',
		width: 100,
		align: 'center',
		editor: comboFixedAt,
		dataIndex: 'FIXED_AT',
		renderer: Ext.ux.comboBoxRenderer(comboFixedAt)
	},{
		text: '금액',
		width: 100,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		editor: {xtype:'textfield', allowBlank: true, maxLength: 7, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'SETUP_AMOUNT'
	},{
		text: '비율(%)',
		width: 100,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		editor: {xtype:'textfield', allowBlank: true, maxLength: 2, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'SETUP_RATE'
	},{
		text: '수용인원 수',
		width: 100,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		editor: {xtype:'textfield', allowBlank: true, maxLength: 2, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'NMPR_CO'
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
		id: 'btn-add-nmpr',
		margin: '0 5 0 415',
		width: 60,
		handler : function() {
			if(!Ext.getCmp('form-reg-goods-code').getValue()) {
				Ext.Msg.alert("알림", "선택한 상품이 없습니다.");
			} else {
				var idx = storeNmpr.getCount();
				var tmpSetupSe = 'P';
				if(Ext.getCmp('form-reg-cl-se').getValue() == 'S') {
					tmpSetupSe = 'R';
				}
				if(idx > 0) {
					tmpSetupSe = storeNmpr.getAt(idx-1).data.SETUP_SE;
				}
				var r = Ext.create('GoodsNmprInfo', {
					GOODS_CODE : Ext.getCmp('form-reg-goods-code').getValue(),
					SETUP_SE : tmpSetupSe,
					NMPR_SN : '',
					NMPR_CND : '',
					FIXED_AT : 'Y',
					SETUP_AMOUNT : '',
					SETUP_RATE : '',
					NMPR_CO : '',
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
		id: 'btn-del-nmpr',
		width: 60,
		handler: function() {
			var sm = gridNmpr.getSelectionModel();
			storeNmpr.remove(sm.getSelection());
			/*if (storeNmpr.getCount() > 0) {
				sm.select(0);
			}*/
		}
	}, {
		text: '저장',
		id: 'btn-save-nmpr',
		width: 60,
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
							fn_activeNextTab();
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
	plugins: [cellEditing3],
	listeners: {
		cellclick: function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			selGridNmprIdx = rowIndex;
		}
	}
});

/*
 * 이미지등록 form 화면
 */
var frFile = Ext.create('Ext.form.Panel', {
	//title: '상품정보입력',
	id: 'form-file',
	region: 'north',
	height: 80,
	//autoScroll: true,
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
		    		labelWidth: 70,
		    		allowBlank: false,
		    		width: 400,
					listeners:{
						afterrender : function(ff, eOpts ){
							//파일태그옵션에 multiple이라는 옵션을 정의
							ff.fileInputEl.set({
								multiple:'multiple'
							});
						},
					}
				},{
					xtype: 'button',
					id: 'btn-upload-file',
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
									url: '../uploadGoodsFiles/',
									method: 'POST',
									params: {GOODS_CODE: Ext.getCmp('form-reg-goods-code').getValue()},
									success: function(form, action) {
										Ext.Msg.alert('알림', '저장되었습니다.', function(){
											storeFile.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
											frFile.down("filefield").fileInputEl.set({
												multiple:'multiple'
											});
										});
									},
									failure: function(form, action) {
										fn_failureMessage(action.response);
									}
								});
							} else {
								//console.log('is not valid');
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
			, {name:'FILE_PATH', type:'string'}
			, {name:'REPRSNT_AT', type:'string'}
			, {name:'SORT_NO', type:'string'}
			, {name:'FILE_URL', type:'string'}
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
	},
	listeners: {
		load : function(st, records, successful, eOpts ) {
			//alert(st.getCount());
		}
	}
});

var gridFile = Ext.create('Ext.grid.Panel', {
	//title: '이미지등록',
	id: 'grid-file',
	region:'center',
	store: storeFile,
	border: true,
	split : true,
	plugins: Ext.create('Ext.grid.plugin.CellEditing', {clicksToEdit: 1}),
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '파일',
		//width: 300,
		flex: 1,
		style: 'text-align:center',
		sortable: false,
		menuDisabled: true,
		dataIndex: 'FILE_NM'
	},{
		text: '대표여부',
		width: 80,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		editor: comboYn,
		dataIndex: 'REPRSNT_AT',
		renderer: Ext.ux.comboBoxRenderer(comboYn)
	},{
		text: '정렬순서',
		width: 80,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		editor: {xtype:'textfield', allowBlank: false, maxLength: 2, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'SORT_NO'
	},{
		text: 'FILE_CODE',
		hidden: true,
		width: 100,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		dataIndex: 'FILE_CODE'
	},{
		text: 'FILE_SN',
		hidden: true,
		width: 100,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		dataIndex: 'FILE_SN'
	},{
		text: 'FILE_PATH',
		hidden: true,
		width: 100,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		dataIndex: 'FILE_PATH'
	}],
	tbar: [{
		text: '삭제',
		id: 'btn-del-file',
		width: 60,
		margin: '0 5 0 10',
		handler: function() {
			var sm = gridFile.getSelectionModel();
			storeFile.remove(sm.getSelection());
			/*if (storeFile.getCount() > 0) {
				sm.select(0);
			}*/
		}
	}, {
		text: '저장',
		id: 'btn-save-file',
		width: 60,
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

var imageTpl = new Ext.XTemplate(
	 '<div class="thumb-wrap" style="margin-bottom: 10px;">'
	,'<table width="97%">'
	,'<tpl for=".">'
	,'{[xindex % 5 == 1 ? "<tr height=100 valign=top>" : ""]}'
	,'<td width="20%"><img src="{FILE_URL}"/><br>{[xindex]}.{FILE_NM}</td>'
	,'{[xindex % 5 == 0 ? "</tr>" : ""]}'
	,'</tpl>'
	,'</table>'
	,'</div>'
);

var imageView = Ext.create('Ext.view.View', {
    store: storeFile,
    tpl: imageTpl,
    itemSelector: 'div.thumb-wrap',
    emptyText: '&nbsp;&nbsp;&nbsp;&nbsp;이미지가 없습니다.<br>&nbsp;&nbsp;&nbsp;'
});

var imagePanel = new Ext.create('Ext.panel.Panel', {
	id: 'panel-image',
	//region: 'west',
	//layout: 'fit',
	//autoScroll: true,
	//width: '100%',
	border: true,
	///// padding: '5 5 0 0',
	style: {
		backgroundColor: '#FFFFFF'
	},
	items: [imageView]
});

var filePanel = Ext.create('Ext.panel.Panel', {
	title: '이미지등록',
	id: 'file-panel',
	layout : 'border',
	padding : '5 5 5 10',
	style: {
		backgroundColor: '#FFFFFF'
	},
	items : [Ext.create('Ext.panel.Panel',{
		region: 'west',
		layout: 'border',
		width: 500,
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [frFile, gridFile]
	}), Ext.create('Ext.panel.Panel', {
		title: '이미지 미리보기',
    	region: 'center',
    	autoScroll: true,
    	flex: 1,
		//layout: 'border',
    	padding : '5 5 5 5',
    	style: {
			backgroundColor: '#FFFFFF'
		},
    	items: [imagePanel]
    })]
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
		//items: [frSearch, Ext.create('Ext.tab.Panel', {
		items: [Ext.create('Ext.tab.Panel', {
			id: 'reg-tabs',
			activeTab: 0,
			layout: 'border',
			region: 'center',
			//padding:'0 0 0 5',
			style: {
				backgroundColor: '#FFFFFF'
			},
			items: [frReg, frReg2, frReg3, gridNmpr, gridSchdul, gridTime, filePanel]
		})]
	});

	if(sGoodsCode) {
		storeGoods.load({params:{GOODS_CODE:sGoodsCode}});
	}
});
