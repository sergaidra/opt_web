Ext.define('PurchsInfo', {
	extend: 'Ext.data.Model',
	fields: ['PURCHS_SN', 'ESNTL_ID', 'USER_NM', 'PURCHS_DE', 'SETLE_DT', 'TOT_SETLE_AMOUNT', 'PYMNT_SE', 'PYMNT_SE_NM',
	         'TOURIST_NM', 'TOURIST_CTTPC', 'KAKAO_ID', 'DELETE_AT', 'DELETE_DT']
});

Ext.define('PurchsGoodsInfo', {
	extend: 'Ext.data.Model',
	fields: ['GOODS_NM', 'CL_SE', 'CART_SN', 'GOODS_CODE', 'ESNTL_ID', 'PURCHS_AMOUNT', 'ORIGIN_AMOUNT', 'TOUR_DE', 'BEGIN_TIME', 'END_TIME', 'CHKIN_DE', 'CHCKT_DE', 'EXPRTN_AT', 'PURCHS_AT', 'DELETE_AT', 'FLIGHT_SN'
	       , {name:'CART_LIST', type:'object'}, 'PICKUP_PLACE', 'DROP_PLACE', 'USE_NMPR', 'USE_PD']
});

var frCond = Ext.create('Ext.form.Panel', {
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
				xtype: 'datefield',
				vtype: 'daterange',
				id: 'sch-fr-date',
				name: 'FR_TOUR_DE',
				format: 'Y-m-d',
				altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd',
				fieldLabel: '검색일자',
				labelAlign: 'right',
				labelWidth: 80,
				width: 200,
				allowBlank: false,
				//value: new Date(Date.parse(new Date())-6*1000*60*60*24),
				value: Ext.Date.getFirstDateOfMonth(new Date()),
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
								Ext.getCmp('btn-search-log').fireEvent('click');
							}
						}
					}
				}
			}, {
				xtype: 'datefield',
				vtype: 'daterange',
				id: 'sch-to-date',
				name: 'TO_TOUR_DE',
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
								Ext.getCmp('btn-search-log').fireEvent('click');
							}
						}
					}
				}
			}, {
				xtype: 'radiogroup',
				id: 'sch-rd-delete-at',
				fieldLabel: '결제취소여부',
				labelWidth: 100,
				labelAlign: 'right',
				border: false,
				width: 300,
				items: [{ boxLabel: '전체', id:'radio-delete-all', name: 'DELETE_AT', inputValue:''},
						{ boxLabel: '결제', id:'radio-delete-n', name: 'DELETE_AT', inputValue:'N', checked: true},
						{ boxLabel: '취소', id:'radio-delete-y', name: 'DELETE_AT', inputValue:'Y'}]
			}, {
				xtype: 'button',
				id: 'btn-search-log',
				margin: '0 0 0 10',
				text: '조회',
				width: 60,
				listeners: {
					click: function() {
						stPurchs.proxy.extraParams = Ext.getCmp('form-sch').getForm().getValues();
						stPurchs.loadPage(1);
					}
				}
			}]
		}]
	}]
});

var stPurchs = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	pageSize: 20,
	model: 'PurchsInfo',
	proxy: {
		type: 'ajax',
		url: '../selectPurchsListForSchdul/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grPurchs = Ext.create('Ext.grid.Panel', {
	title: '결제목록',
	region:'north',
	height: 300,
	store: stPurchs,
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
		text: '결제번호',
		width: 150,
		align: 'center',
		dataIndex: 'PURCHS_SN'
	},{
		text: '결제자',
		width: 120,
		align: 'center',
		dataIndex: 'USER_NM'
	},{
		text: '결제일자',
		width: 150,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'SETLE_DT'
	},{
		text: '결제금액',
		width: 150,
		style: 'text-align:center',
		align: 'right',
		dataIndex: 'TOT_SETLE_AMOUNT',
		renderer: function(value, metaData, record) {
			return Ext.util.Format.number(value , '0,000');
		}
	},{
		text: '여행자이름',
		width: 150,
		align: 'center',
		dataIndex: 'TOURIST_NM'
	},{
		text: '여행자연락처',
		width: 150,
		align: 'center',
		dataIndex: 'TOURIST_CTTPC'
	},{
		text: '카카오톡ID',
		width: 150,
		align: 'center',
		dataIndex: 'KAKAO_ID'
	},{
		text: '취소여부',
		width: 100,
		align: 'center',
		dataIndex: 'DELETE_AT'
	},{
		text: '　　　취소일자',
		minWidth: 150,
		flex: 1,
		align: 'left',
		dataIndex: 'DELETE_DT'
	}],
	bbar: Ext.create('Ext.PagingToolbar', {
		store: stPurchs,
		displayInfo: true,
		displayMsg: '전체 {2}건 중 {0} - {1}',
		emptyMsg: "조회된 자료가 없습니다."
	}),
	listeners: {
		cellclick: function(gr, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			stPurchsGoods.proxy.extraParams.PURCHS_SN = record.data.PURCHS_SN;
			stPurchsGoods.load();
		},
		celldblclick: function(gr, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			fn_openPopup('/purchs/OrderInfoAdmin?purchs_sn='+record.data.PURCHS_SN, 'winOrderInfo_'+record.data.PURCHS_SN, 950, 600, true);
		}
	}
});

var stPurchsGoods = Ext.create('Ext.data.JsonStore', {
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

var grPurchsGoods = Ext.create('Ext.grid.Panel', {
	title: '구매상품목록',
	region: 'center',
	store: stPurchsGoods,
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
		minWidth: 250,
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
				//str += ' (' + Ext.util.Format.number(record[i].AMOUNT , '0,000') + '원) ';
				str += '<br>';
			}
			return str;
		}
	},{
		text: '여행일자',
		width: 180,
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
		hidden: true,
		dataIndex: 'PURCHS_AMOUNT',
		renderer: function(value, metaData, record) {
			return Ext.util.Format.number(value , '0,000');
		}
	},{
		text: '원래결제금액',
		width: 120,
		style: 'text-align:center',
		align: 'right',
		hidden: true,
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
	}]
});

Ext.onReady(function(){
	Ext.create('Ext.Viewport', {
		layout: 'border',
		padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		//items: [frCond, grPurchs, grPurchsGoods]
		items: [frCond, Ext.create('Ext.panel.Panel',{
			layout: 'border',
			region: 'center',
			style: {
				backgroundColor: '#FFFFFF'
			},
			items: [grPurchs, grPurchsGoods]
		})]
	});
});