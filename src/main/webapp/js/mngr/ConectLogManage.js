Ext.define('ConectInfo', {
	extend: 'Ext.data.Model',
	fields: ['CONECT_SN', 'CONECT_ID', 'USER_NM', 'USER_ID', 'CONECT_IP', 'CONECT_DT']
});

Ext.define('HistInfo', {
	extend: 'Ext.data.Model',
	fields: ['CONECT_DT', {name:'CONECT_CNT', type:'int'}, {name:'CONECT_MBER_CNT', type:'int'}, {name:'CONECT_NOT_MBER_CNT', type:'int'}]
});

var frHist = Ext.create('Ext.form.Panel', {
	title: '접속이력',
	id: 'form-hist',
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
				name: 'FR_CONECT_DT',
				width: 180,
				fieldLabel: '조회기간', 
				labelSeparator: ': ', 
				labelWidth: 70, 
				labelAlign: 'right', 
				format: 'Y-m-d', 
				altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd', 
				selectOnFocus: true,
				value: new Date(Date.parse(new Date())-1000*60*60*24)				
			}, {
				xtype: 'datefield', 
				name: 'TO_CONECT_DT', 
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
						stHist.proxy.extraParams = Ext.getCmp('form-hist').getForm().getValues();
						stHist.loadPage(1);
					}
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					frHist.getForm().reset();
					stHist.removeAll();
				}
			}]
		}]
	}]
});

var frHistDay = Ext.create('Ext.form.Panel', {
	id: 'form-hist-day',
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
				name: 'FR_CONECT_DT',
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
				name: 'TO_CONECT_DT', 
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
						stHistDay.proxy.extraParams = Ext.getCmp('form-hist-day').getForm().getValues();
						stHistDay.loadPage(1);
					}
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					frHistDay.getForm().reset();
					stHistDay.removeAll();
				}
			}]
		}]
	}]
});

var frHistMonth = Ext.create('Ext.form.Panel', {
	id: 'form-hist-month',
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
				name: 'FR_CONECT_DT',
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
				name: 'TO_CONECT_DT', 
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
						stHistMonth.proxy.extraParams = Ext.getCmp('form-hist-month').getForm().getValues();
						stHistMonth.loadPage(1);
					}
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					frHistMonth.getForm().reset();
					stHistMonth.removeAll();
				}
			}]
		}]
	}]
});

var stHist = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	pageSize: 100,
	model: 'ConectInfo',
	proxy: {
		type: 'ajax',
		url: '../selectConectHistList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var stHistDay = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	pageSize: 100,
	model: 'HistInfo',
	proxy: {
		type: 'ajax',
		url: '../selectConectHistStatsDay/',
		reader: {
			type: 'json',
			root: 'data'
		}
	}
});

var stHistMonth = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	pageSize: 100,
	model: 'HistInfo',
	proxy: {
		type: 'ajax',
		url: '../selectConectHistStatsMonth/',
		reader: {
			type: 'json',
			root: 'data'
		}
	}
});

var grHist = Ext.create('Ext.grid.Panel', {
	id: 'grid-hist',
	title: '접속이력',
	region:'center',
	store: stHist,
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
		text: '접속일시',
		width: 150,
		align: 'center',
		dataIndex: 'CONECT_DT'
	},{
		text: '접속IP',
		width: 150,
		align: 'center',
		dataIndex: 'CONECT_IP'
	},{
		text: '사용자',
		width: 150,
		align: 'center',
		dataIndex: 'USER_NM'
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
		store: stHist,
		displayInfo: true,
		displayMsg: '전체 {2}건 중 {0} - {1}',
		emptyMsg: "조회된 자료가 없습니다."
	})
});

var grHistDay = Ext.create('Ext.grid.Panel', {
	id: 'grid-hist-day',
	title: '일별접속통계',
	region:'center',
	store: stHistDay,
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
		text: '접속일자',
		width: 120,
		align: 'center',
		dataIndex: 'CONECT_DT'
	},{
		xtype: 'numbercolumn',
		format: '0,000',
		text : '접속건수',
		width : 120,
        style: 'text-align:center',
		align: 'right',
		dataIndex : 'CONECT_CNT'
	},{
		xtype: 'numbercolumn',
		format: '0,000',
		text : '회원 접속',
		width : 120,
        style: 'text-align:center',
		align: 'right',
		dataIndex : 'CONECT_MBER_CNT'
	},{
		xtype: 'numbercolumn',
		format: '0,000',
		text : '비회원 접속',
		width : 120,
        style: 'text-align:center',
		align: 'right',
		dataIndex : 'CONECT_NOT_MBER_CNT'				
	},{
		flex: 1 
	}]
});

var grHistMonth = Ext.create('Ext.grid.Panel', {
	id: 'grid-hist-month',
	title: '월별접속통계',
	region:'center',
	store: stHistMonth,
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
		text: '접속월',
		width: 120,
		align: 'center',
		dataIndex: 'CONECT_DT'
	},{
		xtype: 'numbercolumn',
		format: '0,000',
		text : '접속건수',
		width : 120,
        style: 'text-align:center',
		align: 'right',
		dataIndex : 'CONECT_CNT'
	},{
		xtype: 'numbercolumn',
		format: '0,000',
		text : '회원 접속',
		width : 120,
        style: 'text-align:center',
		align: 'right',
		dataIndex : 'CONECT_MBER_CNT'
	},{
		xtype: 'numbercolumn',
		format: '0,000',
		text : '비회원 접속',
		width : 120,
        style: 'text-align:center',
		align: 'right',
		dataIndex : 'CONECT_NOT_MBER_CNT'					
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
		items: [frHist, grHist]
	});
});*/


var condTab = Ext.create('Ext.tab.Panel', {
	id: 'cond-tab',
	region: 'north',
	border: false,
	tabBar: {
		hidden: true
	},
	items: [frHist, frHistDay, frHistMonth]
});

var gridTab = Ext.create('Ext.tab.Panel', {
	id: 'grid-tab',
	region: 'center',
	border: false,
	items: [grHist, grHistDay, grHistMonth],
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
	    padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFF'
		},
	    items: [center]
	});
});