Ext.define('PointInfo', {
	extend: 'Ext.data.Model',
	fields: ['ESNTL_ID', 'POINT_SN', 'POINT', 'POINT_ABS', 'POINT_DIV', 'ACCML_SE_NM', 'ACCML_SE', 'ACCML_DT', 'VALID_DT']
});

var frPoint = Ext.create('Ext.form.Panel', {
	id: 'form-sch',
	region: 'north',
	height: 75,
	items: [{
		xtype: 'fieldset',
		title: '검색조건',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'hiddenfield',
				id: 'sch-ds-esntl-id',
				name: 'ESNTL_ID',
			}, {
				xtype: 'textfield',
				id: 'sch-ds-user-nm',
				name: 'ESNTL_ID',
				fieldLabel: '사용자정보',				
				labelWidth: 80,
				labelAlign: 'right',
				border: false,
				width: 160,
				readOnly: true,
				enableKeyEvents: true,
				listeners: {
					focus: function(tf, e, eOpts ) {
						Ext.getCmp('btn-search-user').fireEvent('click');
					}
				}				
			}, {
				xtype: 'textfield',
				id: 'sch-ds-user-id',
				hideLabel : true,
				border: false,
				width: 200,
				margin: '0 0 0 5',
				readOnly: true,
				enableKeyEvents: true,
				listeners: {
					focus: function(tf, e, eOpts ) {
						Ext.getCmp('btn-search-user').fireEvent('click');
					}
				}
			}, {
				xtype: 'button',
				id: 'btn-search-user',
				iconCls: 'icon-search',
				margin: '0 0 0 5',
				listeners: {
					click: function() {
						winUserList.show();
					}
				}				
			}, {
				xtype: 'datefield',
				vtype: 'daterange',
				id: 'sch-fr-date',
				name: 'FR_ACCML_DT',
				format: 'Y-m-d',
				altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd',
				fieldLabel: '검색일자',
				labelAlign: 'right',
				labelWidth: 80,
				width: 200,
				allowBlank: false,
				value: new Date(Date.parse(new Date())-6*1000*60*60*24),
				endDateField: 'sch-to-date',
				autoCreate: { tag: 'input', type: 'text', maxLength: '10' },
				style: { 'ime-mode': 'disabled' },
				maskRe: /[0-9]/,
				maxLength: 10,
				enforceMaxLength: true,
				selectOnFocus: true,
				enableKeyEvents: true,
				listeners: {
					'keyup': function(tf, e) {
						var dt = tf.getRawValue().replace(/-/gi,'');
						if(dt.length == 8){
							if(e.getKey() != 13 && e.getKey() != 39 && e.getKey() != 37 && e.getKey() != 8 && e.getKey() != e.TAB){
								tf.setValue(fn_renderDate(dt));
								Ext.getCmp('sch-to-date').focus();
							}
							if(e.getKey() == 13){
								Ext.getCmp('btn-search-point').fireEvent('click');
							}
						}
					}
				}				
			}, {
				xtype: 'datefield',
				vtype: 'daterange',
				id: 'sch-to-date',
				name: 'TO_ACCML_DT',
				format: 'Y-m-d',
				altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd',
				fieldLabel: '-',
				labelAlign: 'right',
				labelSeparator: '',
				labelWidth: 10,
				width: 130,
				allowBlank: false,
				value: new Date(),
				startDateField : 'sch-fr-date',
				autoCreate: { tag: 'input', type: 'text', maxLength: '10' },
				style: { 'ime-mode': 'disabled' },
				maskRe: /[0-9]/,
				maxLength: 10,
				enforceMaxLength: true,
				selectOnFocus: true,
				enableKeyEvents: true,
				listeners: {
					'keyup': function(tf, e) {
						var dt = tf.getRawValue().replace(/-/gi,'');
						if(dt.length == 8){
							if(e.getKey() != 13 && e.getKey() != 39 && e.getKey() != 37 && e.getKey() != 8 && e.getKey() != e.TAB){
								tf.setValue(fn_renderDate(dt));
							}
							if(e.getKey() == 13){
								Ext.getCmp('btn-search-point').fireEvent('click');
							}
						}
					}
				}				
			}, {
				xtype: 'button',
				id: 'btn-search-point',
				margin: '0 0 0 10',
				text: '조회',
				width: 60,
				listeners: {
					click: function() {
						if(!Ext.getCmp('sch-ds-esntl-id').getValue()) {
							Ext.Msg.alert('확인', '사용자를 선택하세요.', function(){
								Ext.getCmp('btn-search-user').fireEvent('click');
							});
						} else {
							stPoint.proxy.extraParams = Ext.getCmp('form-sch').getForm().getValues();
							stPoint.loadPage(1);							
						}
					}
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					frPoint.getForm().reset();
					frUser.getForm().reset();
					stPoint.removeAll();
					stUser.removeAll();
				}
			}]
		}]
	}]
});

var stPoint = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	pageSize: 20,
	model: 'PointInfo',
	proxy: {
		type: 'ajax',
		url: '../selectPointList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grPoint = Ext.create('Ext.grid.Panel', {
	title: '회원목록',
	region:'center',
	store: stPoint,
	border: true,
	split : true,
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		/*text: '순번',
    	xtype: 'rownumberer',
    	align: 'center',
    	width: 50
	},{*/
		text: '일자',
		width: 100,
		align: 'center',
		dataIndex: 'ACCML_DT'
	},{
		text: '적립/사용구분',
		width: 180,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'ACCML_SE_NM'
	},{
		text: '적립포인트',
		width: 120,
		style: 'text-align:center',
		align: 'right',
		dataIndex: 'POINT_ABS',
		renderer: function(value, metaData, record) {
			if(record.data.POINT_DIV == '적립') return Ext.util.Format.number(value , '0,000');
		}
	},{
		text: '차감포인트',
		width: 120,
		style: 'text-align:center',
		align: 'right',
		dataIndex: 'POINT_ABS',
		renderer: function(value, metaData, record) {
			if(record.data.POINT_DIV == '차감') return '<font color="red">-'+Ext.util.Format.number(value , '0,000') +'</font>';
		}
	},{
		text: '만료일자',
		width: 100,
		align: 'center',
		dataIndex: 'VALID_DT'
	},{
		flex: 1
	}],
	bbar: Ext.create('Ext.PagingToolbar', {
		store: stPoint,
		displayInfo: true,
		displayMsg: '전체 {2}건 중 {0} - {1}',
		emptyMsg: "조회된 자료가 없습니다."
	})
});

Ext.onReady(function(){
	Ext.create('Ext.Viewport', {
		layout: 'border',
		padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [frPoint, grPoint]
	});
});