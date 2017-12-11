Ext.tip.QuickTipManager.init();  // enable tooltips

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
			['Y', 'Y'],
			['N', 'N']
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

var storeCoUnitSe = new Ext.create('Ext.data.JsonStore', {
	autoLoad: true,
	fields:['CODE_ID', 'CODE', 'CODE_NM', 'CODE_NM_ENG', 'CODE_DC', 'CODE_NM_2'],
	pageSize: 100,
	proxy: {
		type: 'ajax',
		url: '../selectCmmnDetailCodeList/?CODE_ID=COM008',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var comboCoUnitSe = new Ext.create('Ext.form.ComboBox', {
	id: 'combo-co-unit-se',
	store: storeCoUnitSe,
	displayField: 'CODE_NM_2',
	valueField: 'CODE',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	lazyRender: true,
	editable: false
});

/*var comboFixedAt = new Ext.create('Ext.form.ComboBox', {
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
});*/

var comboFixedAt = new Ext.create('Ext.form.ComboBox', {
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data :[
			['Y', '단가계산'],
			['N', '범위인원수']
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
				if(sm.getSelection()[0].get('SETUP_SE') == 'P') {
					//sm.getSelection()[0].set('SETUP_AMOUNT', '');
					cellEditing3.startEditByPosition({row: selGridNmprIdx, column: 4});
				} else {
					alert( '범위인원수는 단가(인원)만 설정 가능합니다.');
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
	value: '00100',
	//forceSelection: true,
	//emptyText: '선택',
	listeners: {
		afterrender: function(combo, eOpts ){
			comboCty.getStore().load({params:{NATION_CODE:'00100'}});
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

function fn_getByteLength(s) {
	var b, i, c;
	for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?2:c>>7?2:1); return b;
}

function fn_checkValue(objId) {
	var len = Ext.getCmp(objId).maxLength;
	if(fn_getByteLength(Ext.getCmp(objId).getValue()) > len) {
		Ext.Msg.alert('알림', '입력 글자수(한글기준 '+(len/2)+'자)를 초과하였습니다.', function(){Ext.getCmp(objId).focus();});
		return false;
	} else if(fn_getByteLength(Ext.getCmp(objId+'-eng').getValue()) > len) {
		Ext.Msg.alert('알림', '입력 글자수(영문기준 '+len+'자)를 초과하였습니다.', function(){Ext.getCmp(objId+'-eng').focus();});
		return false;
	} else {
		return true;
	}
}

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

	if(sDiv != 'D') {
		if(!frSave.getForm().isValid()) {
			alert('입력값 오류');
			return;
		}

		if(!fn_checkValue('form-reg-goods-nm')) return;
		if(!fn_checkValue('form-reg-goods-intrcn-simpl')) return;
		if(!fn_checkValue('form-reg-vochr-ntss-reqre-time')) return;
		if(!fn_checkValue('form-reg-vochr-use-mth')) return;
		if(!fn_checkValue('form-reg-guidance-use-time')) return;
		if(!fn_checkValue('form-reg-guidance-reqre-time')) return;
		if(!fn_checkValue('form-reg-guidance-age-div')) return;
		if(!fn_checkValue('form-reg-guidance-tour-schdul')) return;
		if(!fn_checkValue('form-reg-guidance-prfplc-lc')) return;
		if(!fn_checkValue('form-reg-guidance-edc-crse')) return;
		if(!fn_checkValue('form-reg-guidance-optn-matter')) return;
		if(!fn_checkValue('form-reg-guidance-pickup')) return;
		if(!fn_checkValue('form-reg-guidance-prparetg')) return;
		if(!fn_checkValue('form-reg-guidance-incls-matter')) return;
		if(!fn_checkValue('form-reg-guidance-not-incls-matter')) return;
		if(!fn_checkValue('form-reg-adit-guidance')) return;
		if(!fn_checkValue('form-reg-atent-matter')) return;
		if(!fn_checkValue('form-reg-change-refnd-regltn')) return;
		if(!fn_checkValue('form-reg-intrcn-use-time')) return;
		if(!fn_checkValue('form-reg-intrcn-meet-time')) return;
		if(!fn_checkValue('form-reg-intrcn-reqre-time')) return;
		if(!fn_checkValue('form-reg-intrcn-provd-lang')) return;
		if(!fn_checkValue('form-reg-intrcn-posbl-age')) return;
		if(!fn_checkValue('form-reg-intrcn-place')) return;
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
	fields: [ {name:'STPLAT_CODE', type:'string'}
			, {name:'STPLAT_SJ', type:'string'}
			, {name:'STPLAT_CN', type:'string'}
			
			]
});

var storeGoods = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	model: 'GoodsInfo',
	proxy: {
		type: 'ajax',
		url: '../selectStplatInfo/',
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
		margin: '0 0 0 420',
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
		title: '<span style="font-weight:bold;">상품 간략 정보</span>',
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
			}]
		}]
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
			items: [frReg]
		})]
	});

	if(sGoodsCode) {
		storeGoods.load({params:{GOODS_CODE:sGoodsCode}});
	}
});

