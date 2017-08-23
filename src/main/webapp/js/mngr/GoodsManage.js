/*
 * 데이터 저장을 위한 form을 정의
 */
var frSave = Ext.create('Ext.form.Panel', {});

var cr = [{'CL_CODE': '', 'CL_NM': '전체'}];

var comboUpperCl = new Ext.create('Ext.form.ComboBox', {
	id: 'form-upper-cl-code',
	name: 'UPPER_CL_CODE',
	width: 220,
	fieldLabel: '분류',
	labelAlign: 'right',
	labelWidth: 50,	
	store: new Ext.create('Ext.data.JsonStore', {
		autoLoad: true,
		fields:['CL_CODE', 'CL_NM'],
		proxy: {
			type: 'ajax',
			url: '../selectTourClUpperList/?UPPER_CL_CODE=00000',
			reader: {
				type: 'json',
				root: 'data',
				totalProperty: 'rows'
			}
		},
		listeners: {
			load: function(st, records, successful, eOpts ){
			}
		}
	}),
	displayField: 'CL_NM',
	valueField: 'CL_CODE',
	queryMode: 'local',
	typeAhead: true,
	editable: false,
	emptyText: '전체',
	listeners: {
		change: function(combo, newValue, oldValue, eOpts ) {
			Ext.getCmp('form-cl-code').setValue('');
			comboCl.getStore().load({params:{UPPER_CL_CODE:newValue}});
		}
	}
});

var comboCl = new Ext.create('Ext.form.ComboBox', {
	id: 'form-cl-code',
	name: 'CL_CODE',
	width: 170,
	store: new Ext.create('Ext.data.JsonStore', {
		autoLoad: false,
		fields:['CL_CODE', 'CL_NM'],
		proxy: {
			type: 'ajax',
			url: '../selectTourClUpperList/',
			reader: {
				type: 'json',
				root: 'data',
				totalProperty: 'rows'
			}
		},
		listeners: {
			load: function(st, records, successful, eOpts ){
				st.insert(0, cr);
			}
		}
	}),
	displayField: 'CL_NM',
	valueField: 'CL_CODE',
	queryMode: 'local',
	typeAhead: true,
	editable: false,
	emptyText: '전체'
});

/*
 * 검색조건 form을 정의
 */
var frCond = Ext.create('Ext.form.Panel', {
	id: 'form-cond',
	region: 'north',
	height: 70,
	items: [{
		xtype: 'fieldset',
		title: '검색조건',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [comboUpperCl, {
				xtype: 'label',
				width: 5
			}, comboCl, {
				xtype: 'button',
				margin: '0 0 0 10',
				text: '조회',
				width: 60,
				handler: function(){
					jsGoods.proxy.extraParams = Ext.getCmp('form-cond').getForm().getValues();
					jsGoods.load();
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '신규',
				width: 60,
				handler: function(){
					parent.fn_open_menu('00201','여행상품등록','/mngr/GoodsRegist/');
				}            	
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					Ext.getCmp('form-cond').getForm().reset();
					jsGoods.removeAll();
				}
			}]
		}]
	}]
});

Ext.define('GoodsInfo', {
    extend: 'Ext.data.Model',
    fields: ['GOODS_CODE', 'CL_NM', 'GOODS_NM', 'STAYNG_FCLTY_AT', 'SORT_ORDR', 'DELETE_AT', 'WRITNG_DE', 'UPDT_DE', 'FILE_CODE', 'CF_FILE_CNT']
});

var jsGoods = Ext.create('Ext.data.JsonStore', {
	autoLoad: true,
	//pageSize: 20,
	model: 'GoodsInfo',
	proxy: {
		type: 'ajax',
		url: '../selectGoodsListForSearch/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	},
	listeners: {
		load: function (store, records, successful, eOpts) {
			console.log('jsGoods load');
		}
	}
});

/*
 * grid 정의
 */
var grGoods = Ext.create('Ext.grid.Panel', {
	id: 'grid-goods',
	title: '여행상품목록',
	region:'center',
	border: true,
	padding: '10 0 0 0',
	style: {
		backgroundColor: '#FFFFFF'
	},
	store: jsGoods,
	viewConfig: {
		emptyText: '검색된 자료가 없습니다.'
	},
	columns: [{
		text: '순번',
		width: 50,
		align: 'center',
		xtype: 'rownumberer'
	},{
		text: '상품코드',
		width: 120,
		align: 'center',
		dataIndex: 'GOODS_CODE'
	},{
		text: '상품분류',
		width: 150,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'CL_NM'
	},{
		text: '상품명',
		width: 300,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'GOODS_NM'
	},{
		text: '숙박시설',
		width: 80,
		align: 'center',
		dataIndex: 'STAYNG_FCLTY_AT'
	},{
		text: '정렬순서',
		width: 80,
		align: 'center',
		dataIndex: 'SORT_ORDR'
	},{
		text: '삭제여부',
		width: 80,
		align: 'center',
		dataIndex: 'DELETE_AT'
	},{
		 text: '사진수',
		 width: 80,
		 align: 'center',
		 dataIndex: 'CF_FILE_CNT'     
	},{
		 text: '작성일자',
		 width: 100,
		 align: 'center',
		 dataIndex: 'WRITNG_DE'     
	},{
		text: '수정일자',
		width: 100,
		align: 'center',
		dataIndex: 'UPDT_DE'
	},{
		text: 'FILE_CODE',
		width: 100,
		align: 'center',
		hidden: true,
		dataIndex: 'FILE_CODE'        	
	},{
		flex: 1
	}],
	/*bbar: Ext.create('Ext.PagingToolbar', {
	store: jsGoods,
	displayInfo: true,
	displayMsg	: '전체 {2}건 중 {0} - {1}',
	emptyMsg	: "조회된 자료가 없습니다."
	})*/      
	listeners : {
		celldblclick: function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			parent.fn_open_menu('00201','여행상품등록','/mngr/GoodsRegist/?GOODS_CODE='+record.data.GOODS_CODE);
		}
	}
});

/*
 * 화면 레이아웃을 구성한다.
 */
Ext.onReady(function(){    
	Ext.create('Ext.Viewport', {
		layout: 'border',
		padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [Ext.create('Ext.panel.Panel',{
			layout: 'border',
			region: 'center',
			style: {
				backgroundColor: '#FFFFFF'
			},
			items: [frCond, grGoods]
		})]
	});
});
