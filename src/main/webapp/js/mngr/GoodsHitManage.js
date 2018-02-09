Ext.define('GoodsHitInfo', {
	extend: 'Ext.data.Model',
	fields: ['HIT_SN', 'HIT_ID', 'HIT_NM', 'HIT_IP', 'USER_ID', 'HIT_DT', 'GOODS_CODE', 'GOODS_NM', 'DELETE_AT', 'DELETE_AT_NM']
});

Ext.define('HistInfo', {
	extend: 'Ext.data.Model',
	fields: ['HIT_DT', {name:'HIT_CNT', type:'int'}, {name:'HIT_MBER_CNT', type:'int'}, {name:'HIT_NOT_MBER_CNT', type:'int'}]
});

var frHit = Ext.create('Ext.form.Panel', {
	title: '접속이력',
	id: 'form-hit',
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
				name: 'FR_HIT_DT',
				width: 180,
				fieldLabel: '조회기간', 
				labelSeparator: ': ', 
				labelWidth: 70, 
				labelAlign: 'right', 
				format: 'Y-m-d', 
				altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd', 
				selectOnFocus: true,
				value: new Date()				
			}, {
				xtype: 'datefield', 
				name: 'TO_HIT_DT', 
				width: 125, 
				fieldLabel: '~', 
				labelSeparator: '', 
				labelWidth: 15, 
				labelAlign: 'right', 
				format: 'Y-m-d', 
				altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd', 
				selectOnFocus: true,
				value: new Date()		
			}, {
				xtype: 'button',
				margin: '0 0 0 10',
				text: '조회',
				width: 60,
				listeners: {
					click: function() {
						stHit.proxy.extraParams = Ext.getCmp('form-hit').getForm().getValues();
						stHit.loadPage(1);
					}
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					frHit.getForm().reset();
					stHit.removeAll();
				}
			}]
		}]
	}]
});

var frHitDay = Ext.create('Ext.form.Panel', {
	id: 'form-hit-day',
	title: '접속이력',
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
				name: 'FR_HIT_DT',
				width: 180,
				fieldLabel: '조회기간', 
				labelSeparator: ': ', 
				labelWidth: 70, 
				labelAlign: 'right', 
				format: 'Y-m-d', 
				altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd', 
				selectOnFocus: true,
				value: new Date(Date.parse(new Date())-6*1000*60*60*24)				
			}, {
				xtype: 'datefield', 
				name: 'TO_HIT_DT', 
				width: 125, 
				fieldLabel: '~', 
				labelSeparator: '', 
				labelWidth: 15, 
				labelAlign: 'right', 
				format: 'Y-m-d', 
				altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd', 
				selectOnFocus: true,
				value: new Date()		
			}, {
				xtype: 'button',
				margin: '0 0 0 10',
				text: '조회',
				width: 60,
				listeners: {
					click: function() {
						stHitDay.proxy.extraParams = Ext.getCmp('form-hit-day').getForm().getValues();
						stHitDay.loadPage(1);
					}
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					frHitDay.getForm().reset();
					stHitDay.removeAll();
				}
			}]
		}]
	}]
});

var frHitMonth = Ext.create('Ext.form.Panel', {
	id: 'form-hit-month',
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
				name: 'FR_HIT_DT',
				width: 180,
				fieldLabel: '조회기간', 
				labelSeparator: ': ', 
				labelWidth: 70, 
				labelAlign: 'right', 
				format: 'Y-m-d', 
				altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd', 
				selectOnFocus: true,
				value: Ext.Date.getFirstDateOfMonth(new Date())		
			}, {
				xtype: 'datefield', 
				name: 'TO_HIT_DT', 
				width: 125, 
				fieldLabel: '~', 
				labelSeparator: '', 
				labelWidth: 15, 
				labelAlign: 'right', 
				format: 'Y-m-d', 
				altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd', 
				selectOnFocus: true,
				value: new Date()		
			}, {
				xtype: 'button',
				margin: '0 0 0 10',
				text: '조회',
				width: 60,
				listeners: {
					click: function() {
						stHitMonth.proxy.extraParams = Ext.getCmp('form-hit-month').getForm().getValues();
						stHitMonth.loadPage(1);
					}
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					frHitMonth.getForm().reset();
					stHitMonth.removeAll();
				}
			}]
		}]
	}]
});

var stHit = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	pageSize: 100,
	model: 'GoodsHitInfo',
	proxy: {
		type: 'ajax',
		url: '../selectGoodsHitList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var stHitDay = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	pageSize: 100,
	model: 'HistInfo',
	proxy: {
		type: 'ajax',
		url: '../selectGoodsHitStatsDay/',
		reader: {
			type: 'json',
			root: 'data'
		}
	}
});

var stHitMonth = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	pageSize: 100,
	model: 'HistInfo',
	proxy: {
		type: 'ajax',
		url: '../selectGoodsHitStatsMonth/',
		reader: {
			type: 'json',
			root: 'data'
		}
	}
});

var grHit = Ext.create('Ext.grid.Panel', {
	id: 'grid-hit',
	title: '조회이력',
	region:'center',
	store: stHit,
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
		text: '상품코드',
		width: 120,
		align: 'center',
		dataIndex: 'GOODS_CODE'    	
	},{
		text: '상품명',
		width: 200,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'GOODS_NM'
	},{
		text: '상품상태',
		width: 100,
		align: 'center',
		dataIndex: 'DELETE_AT_NM'
	},{
		text: '접속일시',
		width: 150,
		align: 'center',
		dataIndex: 'HIT_DT'
	},{
		text: '접속IP',
		width: 150,
		align: 'center',
		dataIndex: 'HIT_IP'
	},{
		text: '사용자',
		width: 150,
		align: 'center',
		dataIndex: 'HIT_NM'
	},{
		text: '사용자ID',
		width: 150,
		align: 'center',
		hidden: true,
		dataIndex: 'USER_ID'			
	},{
		flex: 1 
	}],
	bbar: Ext.create('Ext.PagingToolbar', {
		store: stHit,
		displayInfo: true,
		displayMsg: '전체 {2}건 중 {0} - {1}',
		emptyMsg: "조회된 자료가 없습니다."
	})
});

var grHitDay = Ext.create('Ext.grid.Panel', {
	id: 'grid-hit-day',
	title: '일별조회통계',
	region:'center',
	store: stHitDay,
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
		text: '조회일자',
		width: 120,
		align: 'center',
		dataIndex: 'HIT_DT'
	},{
		xtype: 'numbercolumn',
		format: '0,000',
		text : '조회건수',
		width : 120,
        style: 'text-align:center',
		align: 'right',
		dataIndex : 'HIT_CNT'
	},{
		xtype: 'numbercolumn',
		format: '0,000',
		text : '회원 조회',
		width : 120,
        style: 'text-align:center',
		align: 'right',
		dataIndex : 'HIT_MBER_CNT'
	},{
		xtype: 'numbercolumn',
		format: '0,000',
		text : '비회원 조회',
		width : 120,
        style: 'text-align:center',
		align: 'right',
		dataIndex : 'HIT_NOT_MBER_CNT'				
	},{
		flex: 1 
	}]
});

var grHitMonth = Ext.create('Ext.grid.Panel', {
	id: 'grid-hit-month',
	title: '월별조회통계',
	region:'center',
	store: stHitMonth,
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
		text: '조회월',
		width: 120,
		align: 'center',
		dataIndex: 'HIT_DT'
	},{
		xtype: 'numbercolumn',
		format: '0,000',
		text : '조회건수',
		width : 120,
        style: 'text-align:center',
		align: 'right',
		dataIndex : 'HIT_CNT'
	},{
		xtype: 'numbercolumn',
		format: '0,000',
		text : '회원 조회',
		width : 120,
        style: 'text-align:center',
		align: 'right',
		dataIndex : 'HIT_MBER_CNT'
	},{
		xtype: 'numbercolumn',
		format: '0,000',
		text : '비회원 조회',
		width : 120,
        style: 'text-align:center',
		align: 'right',
		dataIndex : 'HIT_NOT_MBER_CNT'					
	},{
		flex: 1 
	}]
});

/*Ext.onReady(function(){
	Ext.create('Ext.Viewport', {
		layout: 'border',
		padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [frHit, grHit]
	});
});*/


var condTab = Ext.create('Ext.tab.Panel', {
	id: 'cond-tab',
	region: 'north',
	border: false,
	tabBar: {
		hidden: true
	},
	items: [frHit, frHitDay, frHitMonth]
});

var gridTab = Ext.create('Ext.tab.Panel', {
	id: 'grid-tab',
	region: 'center',
	border: false,
	items: [grHit, grHitDay, grHitMonth],
	listeners: {
		tabchange: function (pn, newcard, oldcard, opts) {
			Ext.getCmp('cond-tab').setActiveTab('form-' + newcard.getId().substring(5));
		}
	}
});

var center = Ext.create('Ext.panel.Panel', {
	region: 'center',
	border: false,
	layout: 'border',
	items: [condTab, gridTab]
});

Ext.onReady(function() {
	Ext.create('Ext.container.Viewport', {
	    layout: 'border',
	    border: false,
	    padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFF'
		},
	    items: [center]
	});
});