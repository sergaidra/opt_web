var xlsForm = Ext.create('Ext.form.Panel', {});		//엑셀 저장용 폼


Ext.define('ExchangeInfo', {
	extend: 'Ext.data.Model',
	fields: ['NAME', 'RATE', 'UP_DT', 'RAWNAME']
});

Ext.define('ExchangeHistoryInfo', {
	extend: 'Ext.data.Model',
	fields: ['NAME', 'RATE', 'ORIGIN_RATE', 'UP_DT']
});

var frPurchs = Ext.create('Ext.form.Panel', {
	id: 'form-sch',
	region: 'north',
	height: 65,
	items: [{
		xtype: 'fieldset',
		title: '검색조건',
		padding: '5 5 5 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
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
		}
		
		
		]
	}]
});

var stPurchs = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	pageSize: 20,
	model: 'ExchangeInfo',
	proxy: {
		type: 'ajax',
		url: '../selectExchangeList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grPurchs = Ext.create('Ext.grid.Panel', {
	title: '환율목록',
	region:'north',
	height: 300,
	store: stPurchs,
	border: true,
	split : true,
	loadMask : true,
	//columnLines: true,
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.',
		getRowClass: function(record, rowIndex, rowParams, store) {
			if (record.get('DELETE_AT') == 'Y') {
				return 'row_red';
			} else {
				return 'row_black';
			}
		}
	},
	columns: [
	{
		text: '통화명',
		width: 100,
		align: 'center',
		dataIndex: 'NAME'
	},{
		text: '환율',
		width: 200,
		align: 'center',
		dataIndex: 'RATE'
	},{
		text: '적용시각',
		width: 200,
		align: 'center',
		dataIndex: 'UP_DT'
	},{
		text: 'RAWNAME',
		width: 200,
		align: 'center',
		dataIndex: 'RAWNAME',
		hidden: true
	}],
	bbar: Ext.create('Ext.PagingToolbar', {
		store: stPurchs,
		displayInfo: true,
		displayMsg: '전체 {2}건 중 {0} - {1}',
		emptyMsg: "조회된 자료가 없습니다."
	}),
	listeners: {
		celldblclick: function(gr, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			stPurchsGoods.proxy.extraParams.NAME = record.data.RAWNAME;
			stPurchsGoods.load();
			grPurchsGoods.setTitle('환율이력  : '+record.data.NAME+'');
		}
	}
});

var stPurchsGoods = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	model: 'ExchangeHistoryInfo',
	proxy: {
		type: 'ajax',
		url: '../selectExchangeHistoryList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grPurchsGoods = Ext.create('Ext.grid.Panel', {
	title: '환율이력',
	region: 'center',
	store: stPurchsGoods,
	border: true,
	split : true,
	viewConfig: {
		stripeRows: true,
		emptyText: '등록된 자료가 없습니다.'
	},
	columnLines: true,
	animCollapse: false,
	columns: [{
		xtype: 'rownumberer'
			},{
	      		text: '통화명',
	      		width: 100,
	      		align: 'center',
	      		dataIndex: 'NAME'
	      	},{
	      		text: '환율',
	      		width: 200,
	      		align: 'center',
	      		dataIndex: 'RATE'
	      	},{
	      		text: '환율(올림 전)',
	      		width: 200,
	      		align: 'center',
	      		dataIndex: 'ORIGIN_RATE'
	      	},{
	      		text: '적용시각',
	      		width: 200,
	      		align: 'center',
	      		dataIndex: 'UP_DT'
	      	}],
	 bbar: Ext.create('Ext.PagingToolbar', {
	      		store: stPurchs,
	      		displayInfo: true,
	      		displayMsg: '전체 {2}건 중 {0} - {1}',
	      		emptyMsg: "조회된 자료가 없습니다."
	      	}),
});

Ext.onReady(function(){
	Ext.create('Ext.Viewport', {
		layout: 'border',
		padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [frPurchs, Ext.create('Ext.panel.Panel',{
			layout: 'border',
			region: 'center',
			style: {
				backgroundColor: '#FFFFFF'
			},
			items: [grPurchs, grPurchsGoods]
		})]
	});	
	
	stPurchs.load({params:{STATUS:'W'}});
});