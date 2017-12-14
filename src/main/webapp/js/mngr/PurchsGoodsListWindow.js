/**
 * 결제상품목록 조회 window 화면
 * 
 * 사용하는 화면
 * UserLogManage.js
 * UserPointManage.js
 */

Ext.define('PurchsGoodsInfo', {
	extend: 'Ext.data.Model',
	fields: ['GOODS_NM', 'CL_SE', 'CART_SN', 'GOODS_CODE', 'ESNTL_ID', 'PURCHS_AMOUNT', 'ORIGIN_AMOUNT', 'TOUR_DE', 'BEGIN_TIME', 'END_TIME', 'CHKIN_DE', 'CHCKT_DE', 'EXPRTN_AT', 'PURCHS_AT', 'DELETE_AT', 'FLIGHT_SN'
	       , {name:'CART_LIST', type:'object'}]
});

//stPurchsGoodsWin.getAt(0).get('CART_LIST').length : 4
//stPurchsGoodsWin.getAt(0).get('CART_LIST')[0].CART_SN = 2


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
		url: '../selectPurchsGoodsList/?PURCHS_SN=1',
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
    columnLines: true,
    enableLocking: false,	
    /*plugins: [{
        ptype: 'rowexpander',
        rowBodyTpl : new Ext.XTemplate(
            '<tpl for="CART_LIST">',
            '<p><b>{SETUP_SE_NM}:</b> {NMPR_CND} ({AMOUNT}) {NMPR_CO}{CO_UNIT_SE_NM}</p>',
            '</tpl>'
            )
    }],*/
    //collapsible: true,
    animCollapse: false,	
	columns: [Ext.create('Ext.grid.RowNumberer'),{
		text: '상품',
		width: 180,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'GOODS_NM'
	},{
		text: '선택옵션',
		minWidth: 300,
		flex: 1,
		style: 'text-align:center',
		align: 'left',		
		dataIndex: 'CART_LIST',
		//hidden: true,
		renderer: function(record) {
			var str = '';
			for(var i = 0 ; i < record.length ; i++) {
				str += record[i].SETUP_SE_NM + ': ';
				str += record[i].NMPR_CND + ' (';
				str += record[i].AMOUNT + ') ';
				str += record[i].NMPR_CO;
				str += record[i].CO_UNIT_SE_NM + ' ';
				str += '<br>';
			}
			return str;
		}			
	},{
		text: '실결제금액',
		width: 120,
		style: 'text-align:center',
		align: 'right',
		dataIndex: 'PURCHS_AMOUNT'
	},{
		text: '원래결제금액',
		width: 120,
		style: 'text-align:center',
		align: 'right',
		dataIndex: 'ORIGIN_AMOUNT'
	},{
		text: '여행일자',
		width: 80,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'TOUR_DE'		
	},{		
		text: 'BEGIN_TIME',
		width: 150,
		style: 'text-align:center',
		align: 'center',
		dataIndex: 'BEGIN_TIME'
	},{
		text: 'END_TIME',
		width: 100,
		style: 'text-align:center',
		align: 'center',
		dataIndex: 'END_TIME'
	},{
		text: 'CHKIN_DE',
		width: 120,
		style: 'text-align:center',
		align: 'center',
		dataIndex: 'CHKIN_DE'
	},{
		text: 'CHCKT_DE',
		width: 100,
		style: 'text-align:center',
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

var winPurchsGoodsList = Ext.create('Ext.window.Window', {
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