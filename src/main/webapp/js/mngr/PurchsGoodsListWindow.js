/**
 * 사용자 조회 window 화면
 * 
 * 사용하는 화면
 * UserLogManage.js
 * UserPointManage.js
 */

Ext.define('PurchsGoodsInfo', {
	extend: 'Ext.data.Model',
	fields: ['GOODS_NM', 'CL_SE', 'CART_SN', 'GOODS_CODE', 'ESNTL_ID', 'PURCHS_AMOUNT', 'ORIGIN_AMOUNT', 'TOUR_DE', 'BEGIN_TIME', 'END_TIME', 'CHKIN_DE', 'CHCKT_DE', 'EXPRTN_AT', 'PURCHS_AT', 'DELETE_AT', 'FLIGHT_SN'
	       , {name:'CartList', type:'array'}]
});

var stCmmnCode = new Ext.create('Ext.data.JsonStore', {
	autoLoad: true,
	fields:['CODE_ID', 'CODE', 'CODE_NM', 'CODE_DC'],
	pageSize: 100,
	proxy: {
		type: 'ajax',
		url: '../selectCmmnDetailCodeList/?CODE_ID=COM001&USE_AT=Y',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}/*,
	listeners:{
		'load' : function( store, records, successful, eOpts ){
			if(store.getCount() > 0){
				var idx = store.getCount();
				var r = {
					CODE_ID: 'C0005',
					CODE: '00',
					CODE_NM: '전체',
					CODE_DC: '전체선택',
					USE_AT: '',
					FRST_REGIST_PNTTM: '',
					FRST_REGISTER_ID: '',
					LAST_UPDT_PNTTM: '',
					LAST_UPDUSR_ID: ''
				};
				store.insert(idx, r);
			}
		}
	}*/
});

var comboAuthorCl = new Ext.create('Ext.form.ComboBox', {
	store: stCmmnCode,
	displayField: 'CODE_NM',
	valueField: 'CODE',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	lazyRender: true,
	emptyText: '선택'
});

var comboCrtfcAt = new Ext.create('Ext.form.ComboBox', {
	id: 'sch-crtfc-at',
	name: 'CRTFC_AT',
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data:[
		    ['', '전체'],
			['Y', '인증'],
			['N', '미인증']
		]
	}),
	fieldLabel: '인증여부',
	labelAlign: 'right',
	labelWidth: 70,
	width: 170,
	displayField: 'name',
	valueField: 'code',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	editable: false,
	lazyRender: true
});

var comboRecptnAt = new Ext.create('Ext.form.ComboBox', {
	id: 'sch-email-recptn-at',
	name: 'EMAIL_RECPTN_AT',
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data:[
			['', '전체'],
			['Y', '수신'],
			['N', '미수신']
		]
	}),
	fieldLabel: '수신여부',
	labelAlign: 'right',
	labelWidth: 70,
	width: 170,
	displayField: 'name',
	valueField: 'code',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	editable: false,
	lazyRender: true
});

var comboUseAt = new Ext.create('Ext.form.ComboBox', {
	id: 'sch-use-at',
	name: 'USE_AT',
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data:[
			['', '전체'],
			['Y', '사용'],
			['N', '사용안함']
		]
	}),
	fieldLabel: '사용여부',
	labelAlign: 'right',
	labelWidth: 70,
	width: 170,
	displayField: 'name',
	valueField: 'code',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	editable: false,
	lazyRender: true
});

var frPurchsGoodsWin = Ext.create('Ext.form.Panel', {
	id: 'form-user',
	region: 'north',
	//height: 70,
	items: [{
		xtype: 'fieldset',
		title: '검색조건',
		padding: '1 20 2 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'combo',
	    	    id: 'sch-cond',
	    	    width: 80,
	    	    store: Ext.create('Ext.data.ArrayStore', {
	        		fields:['code', 'name'],
	        		data :[
	        	        ['USER_ID', '아이디'],
	        	        ['USER_NM', '이름']
	        	    ]
	        	}),
	    	    displayField: 'name',
	    	    valueField: 'code',
	    	    value: 'USER_NM',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts ) {
						Ext.getCmp('sch-value').setValue('');
						Ext.getCmp('sch-user-id').setValue('');
						Ext.getCmp('sch-user-nm').setValue('');
						if(newValue == 'USER_ID') {
							Ext.getCmp('sch-user-id').focus();	
						} else {
							Ext.getCmp('sch-user-nm').focus();
						}
					}
				}	    	    
			}, {
	            xtype: 'textfield',				
	    	    id: 'sch-value',
	            width: 150,
	            margin: '0 0 0 5',
	            fieldStyle: {'ime-mode':'active'},	            
	            allowBlank: true,
				enableKeyEvents: true,
				listeners: {
					specialkey: function(tf, e){
						if (e.getKey() == e.ENTER) {
							Ext.getCmp('win-search').fireEvent('click');
						}
					}
				}	            
			}, {
				xtype: 'hiddenfield', id: 'sch-user-nm', name: 'USER_NM'
			}, {
				xtype: 'hiddenfield', id: 'sch-user-id', name: 'USER_ID'
			}, {
				xtype: 'button',
				id: 'win-search',
				margin: '0 0 0 10',
				text: '조회',
				width: 60,
				listeners: {
					click: function() {
						if(Ext.getCmp('sch-cond').getValue() == 'USER_ID') {
							Ext.getCmp('sch-user-id').setValue(Ext.getCmp('sch-value').getValue());
							Ext.getCmp('sch-user-nm').setValue('');
						} else {
							Ext.getCmp('sch-user-id').setValue('');
							Ext.getCmp('sch-user-nm').setValue(Ext.getCmp('sch-value').getValue());
						}
						stPurchsGoodsWin.proxy.extraParams = Ext.getCmp('form-user').getForm().getValues();
						stPurchsGoodsWin.loadPage(1);
					}
				}
			}]
		}]
	}]
});

var stPurchsGoodsWin = Ext.create('Ext.data.JsonStore', {
	autoLoad: true,
	model: 'PurchsGoodsInfo',
	proxy: {
		type: 'ajax',
		url: '../selectUserList/?PURCHS_SN=1',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grPurchsGoodsWin = Ext.create('Ext.grid.Panel', {
	title: '구매상품목록',
	region:'center',
	store: stPurchsGoodsWin,
	border: true,
	split : true,
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '순번',
    	xtype: 'rownumberer',
    	align: 'center',
    	width: 50
	},{
		text: '상품이름',
		width: 180,
		align: 'center',
		hidden: true,
		dataIndex: 'GOODS_NM'
	},{
		text: '실결제금액',
		width: 100,
		align: 'center',
		dataIndex: 'PURCHS_AMOUNT'
	},{
		text: '원래결제금액',
		width: 200,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'ORIGIN_AMOUNT'
	},{
		text: '여행일자',
		width: 80,
		align: 'center',
		dataIndex: 'TOUR_DE'
	},{		
		text: 'BEGIN_TIME',
		width: 150,
		align: 'center',
		dataIndex: 'BEGIN_TIME'
	},{
		text: 'END_TIME',
		width: 100,
		align: 'center',
		dataIndex: 'END_TIME',
	},{
		text: 'CHKIN_DE',
		width: 120,
		align: 'center',
		dataIndex: 'CHKIN_DE'
	},{
		text: 'CHCKT_DE',
		width: 100,
		align: 'center',
		dataIndex: 'CHCKT_DE'
	},{
		text: '가입일시',
		width: 150,
		align: 'center',
		dataIndex: 'WRITNG_DT'
	},{
		text: 'FLIGHT_SN',
		width: 150,
		align: 'center',
		dataIndex: 'FLIGHT_SN'
	}],
	listeners: {
		itemdblclick: function(grid, record, item, index, e, eOpts) {
			
		}
	}
});

var winUserList = Ext.create('Ext.window.Window', {
	title: '사용자 조회',
	height: 475,
	width: 700,
	layout: 'border',
	closable: true,
	closeAction: 'hide',
	modal: true,
	padding:'3 10 3 10',
	style: {
		backgroundColor: '#FFFFFF'
	},
	items: [frPurchsGoodsWin, grPurchsGoodsWin],
	listeners: {
		show: function(win, eOpts ) {
			Ext.getCmp('sch-value').focus();
		}
	}
});