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
	       , {name:'CART_LIST', type:'object'}, 'PICKUP_PLACE', 'DROP_PLACE', 'USE_NMPR', 'USE_PD']
});

//stPurchsGoodsWin.getAt(0).get('CART_LIST').length : 4
//stPurchsGoodsWin.getAt(0).get('CART_LIST')[0].CART_SN = 2


var frPurchsGoodsWin = Ext.create('Ext.form.Panel', {
	id: 'form-purchs-win',
	region: 'north',
	//height: 70,
	items: [{
		xtype: 'fieldset',
		title: '결제정보',
		padding: '1 20 2 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'hiddenfield', id: 'form-purchs-win-purchs-sn', name: 'PURCHS_SN'
			}, {
				xtype: 'displayfield', id: 'form-purchs-win-purchs-info', flex: 1, margin: '0 0 0 5'
			}, {
				xtype: 'button',
				text:'엑셀',
				width: 60,
				listeners: {
					click: function() {
						xlsForm.getForm().standardSubmit = true;
						xlsForm.getForm().submit({
							url   : '../selectPurchsGoodsListExcel/',
							method: 'POST',
							params: stPurchsGoodsWin.proxy.extraParams
						});
					}
				}
			}]
		}]
	}]
});

var stPurchsGoodsWin = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	model: 'PurchsGoodsInfo',
	proxy: {
		type: 'ajax',
		url: '../selectPurchsGoodsList/',
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
		stripeRows: true,
		emptyText: '등록된 자료가 없습니다.'
	},
	columnLines: true,
	//enableLocking: false,
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
	columns: [{
		xtype: 'rownumberer'
	},{
		text: '상품',
		width: 180,
		style: 'text-align:center',
		align: 'left',
		//locked: true,
		dataIndex: 'GOODS_NM'
	},{
		text: '선택옵션',
		minWidth: 300,
		flex: 1,
		style: 'text-align:center',
		align: 'left',
		//locked: true,
		dataIndex: 'CART_LIST',
		//hidden: true,
		renderer: function(record) {
			var str = '';
			for(var i = 0 ; i < record.length ; i++) {
				str += record[i].SETUP_SE_NM + ': ';
				str += record[i].NMPR_CND;
				if(record[i].SETUP_SE != 'C') {
					str += ' ' + record[i].NMPR_CO;
					str += record[i].CO_UNIT_SE_NM;
				}
				str += ' (' + Ext.util.Format.number(record[i].AMOUNT , '0,000') + '원) ';
				str += '<br>';
			}
			return str;
		}
	},{
		text: '여행일자',
		width: 200,
		//style: 'text-align:center',
		align: 'center',
		dataIndex: 'TOUR_DE',
		renderer: function(value, metaData, record) {
			if(value) {
				return fn_renderDate(value);
			} else {
				return fn_renderDate(record.data.CHKIN_DE)+'~'+fn_renderDate(record.data.CHCKT_DE);
			}
		}
	},{
		text: '시간',
		width: 100,
		align: 'center',
		dataIndex: 'BEGIN_TIME',
		renderer: function(value, metaData, record) {
			if(value) {
				return fn_renderTime(record.data.BEGIN_TIME)+'~'+fn_renderTime(record.data.END_TIME);
			} else {
				return '';
			}
		}	
	},{
		text: '픽업장소',
		width: 150,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'PICKUP_PLACE'
	},{
		text: '드랍장소',
		width: 150,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'DROP_PLACE'
	},{
		text: '이용인원',
		width: 150,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'USE_NMPR'
	},{
		text: '이용기간',
		width: 150,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'USE_PD'					
	},{
		text: '실결제금액',
		width: 120,
		style: 'text-align:center',
		align: 'right',
		dataIndex: 'PURCHS_AMOUNT',
		renderer: function(value, metaData, record) {
			return Ext.util.Format.number(value , '0,000');
		}
	},{
		text: '원래결제금액',
		width: 120,
		style: 'text-align:center',
		align: 'right',
		dataIndex: 'ORIGIN_AMOUNT',
		renderer: function(value, metaData, record) {
			return Ext.util.Format.number(value , '0,000');
		}	
	},{
		text: 'FLIGHT_SN',
		width: 150,
		align: 'center',
		hidden: true,
		dataIndex: 'FLIGHT_SN'
	}],
	listeners: {
		itemdblclick: function(grid, record, item, index, e, eOpts) {

		}
	}
});

var winPurchsGoodsList = Ext.create('Ext.window.Window', {
	title: '사용자 조회',
	height: 500,
	width: 950,
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