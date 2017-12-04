/*
 * 데이터 저장을 위한 form을 정의
 */
var frSave = Ext.create('Ext.form.Panel', {});

var cr = [{'CL_CODE': '', 'CL_NM': '전체'}];

function fn_search() {
	jsGoods.proxy.extraParams = Ext.getCmp('form-cond').getForm().getValues();
	jsGoods.load();
}

function fn_openPopup(sUrl, sName, iWidth, iHeigth){
    var sw = screen.width;
    var sh = screen.height;
    var x = (sw-iWidth)/2;
    var y = (sh-iHeigth)/2;
    var opts = "width="+iWidth+", height="+iHeigth+", left="+x+", top="+y+", scrollbars=yes, menubar=no, location=no, resize=yes";
    window.open(sUrl, sName, opts).focus();
}

/*
 * 국가 코드 combo
 */
var comboNation = new Ext.create('Ext.form.ComboBox', {
	id: 'form-nation-code',
	name: 'NATION_CODE',
	width: 120,
	fieldLabel: '도시',
	labelAlign: 'right',
	labelWidth: 40,
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
				Ext.getCmp('form-cty-code').setValue('');
				comboCty.getStore().load({params:{NATION_CODE:newValue}});
			}
		}
	}
});

/*
 * 도시 코드 combo
 */
var comboCty = new Ext.create('Ext.form.ComboBox', {
	id: 'form-cty-code',
	name: 'CTY_CODE',
	width: 80,
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

var comboUpperCl = new Ext.create('Ext.form.ComboBox', {
	id: 'form-upper-cl-code',
	name: 'UPPER_CL_CODE',
	width: 160,
	fieldLabel: '분류',
	labelAlign: 'right',
	labelWidth: 40,
	store: new Ext.create('Ext.data.JsonStore', {
		//autoLoad: true,
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
			load: function(st, records, successful, eOpts){}
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
			comboCl.getStore().load({params:{UPPER_CL_CODE:newValue, DELETE_AT:Ext.getCmp('radio-gubun').getValue().DELETE_AT}});
		}
	}
});

var comboCl = new Ext.create('Ext.form.ComboBox', {
	id: 'form-cl-code',
	name: 'CL_CODE',
	width: 120,
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
	height: 90,
	items: [{
		xtype: 'fieldset',
		title: '검색조건',
		padding: '5 5 5 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'radiogroup',
				id: 'radio-gubun',
				fieldLabel: '사용여부',
				labelWidth: 60,
				labelAlign: 'right',
				border: false,
				width: 240,
				items: [{ boxLabel: '전체', id:'radio-delete-all', name: 'DELETE_AT', inputValue:''},
						{ boxLabel: '사용', id:'radio-delete-n', name: 'DELETE_AT', inputValue:'N', checked: true},
						{ boxLabel: '대기', id:'radio-delete-t', name: 'DELETE_AT', inputValue:'T'}],
				listeners: {
					change : function(radio, newValue, oldValue, eOpts ) {
						Ext.getCmp('form-upper-cl-code').setValue('');
						Ext.getCmp('form-cl-code').setValue('');
						comboUpperCl.getStore().load({params:{UPPER_CL_CODE:'00000', DELETE_AT:newValue.DELETE_AT}});
					}
				}
			}, comboUpperCl, {
				xtype: 'label',
				width: 5
			}, comboCl, {
				xtype: 'label',
				width: 5
			}, {
				xtype: 'button',
				margin: '0 0 0 10',
				text: '조회',
				width: 60,
				handler: function(){
					fn_search();
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '신규',
				width: 60,
				handler: function(){
					parent.fn_open_menu('01004','여행상품등록','/mngr/GoodsRegist/');
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '사용안함처리',
				width: 90,
				handler: function(){
					if(confirm('상품을 "사용안함" 처리하시겠습니까?')) {
						var selections = grGoods.getSelectionModel().getSelection();

						if(!selections.length) {
							alert('선택된 항목이 없습니다.');
							return;
						}

						var codes = '';

						for(var i = 0; i < selections.length; i++){
							if(selections[i].get('DELETE_AT') == 'N') {
								codes += ''+selections[i].get('GOODS_CODE') + ',';
							}
						}

						if(!codes) {
							alert('이미 사용안함 처리한 상품입니다.');
						}

						if(codes) {
							Ext.Ajax.request({
								url:'../deleteGoodsMulti/',
								method:'POST',
								timeout:360000,
								params: {
									'GOODS_CODE_LIST':codes
								},
								success:function(response){
									var json = Ext.decode(response.responseText);
									if(json.success){
										Ext.Msg.alert('확인', '사용안함 처리하였습니다.', function(){
											fn_search();
										});
									}else{
										fn_failureMessage(response);
									}
								},
								failure: function(response){
									fn_failureMessage(response);
								}
							});
						}
					}
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
		}, {
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'radiogroup',
				id: 'radio-goods-se',
				fieldLabel: '상품구분',
				labelWidth: 60,
				labelAlign: 'right',
				border: false,
				width: 240,
				items: [{ boxLabel: '전체', name: 'GOODS_SE', inputValue:'', checked: true },
						{ boxLabel: '핫딜', name: 'GOODS_SE', inputValue:'H'},
						{ boxLabel: '추천', name: 'GOODS_SE', inputValue:'R'}],
				listeners: {
					change : function(radio, newValue, oldValue, eOpts ) {
						Ext.getCmp('form-upper-cl-code').setValue('');
						Ext.getCmp('form-cl-code').setValue('');
						comboUpperCl.getStore().load({params:{UPPER_CL_CODE:'00000', GOODS_SE:newValue.GOODS_SE}});
					}
				}			
			}, comboNation, {
				xtype: 'label',
				width: 5
			}, comboCty]
		}]
	}]
});

Ext.define('GoodsInfo', {
	extend: 'Ext.data.Model',
	fields: ['GOODS_CODE', 'CL_NM', 'UPPER_CL_NM', 'GOODS_NM', 'CTY_NM', 'STAYNG_FCLTY_AT', 'SORT_ORDR', 'HOTDEAL_AT', 'RECOMEND_AT', 'HOTDEAL_SORT_ORDR', 'RECOMEND_SORT_ORDR', 'DELETE_AT', 'DELETE_AT_NM', 'WRITNG_DE', 'UPDT_DE', 'FILE_CODE', 'CF_FILE_CNT']
});

var jsGoods = Ext.create('Ext.data.JsonStore', {
	//autoLoad: true,
	pageSize: 50,
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
			//console.log('jsGoods load');
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
	selModel:Ext.create('Ext.selection.CheckboxModel',{showHeaderCheckbox:true}),
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
		text: '상위분류',
		width: 150,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'UPPER_CL_NM'
	},{
		text: '상세분류',
		width: 150,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'CL_NM'
	},{
		text: '도시',
		width: 80,
		style: 'text-align:center',
		align: 'center',
		dataIndex: 'CTY_NM'
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
		hidden: true,
		dataIndex: 'STAYNG_FCLTY_AT'
	},{
		text: '정렬순서',
		width: 80,
		align: 'center',
		dataIndex: 'SORT_ORDR'			
	},{
		text: '핫딜상품',
		width: 80,
		align: 'center',
		dataIndex: 'HOTDEAL_AT',
		renderer: function(value) {
			if(value == 'Y') return '예';
			else return '아니오';
		}
	},{
		text: '핫딜순서',
		width: 80,
		align: 'center',
		dataIndex: 'HOTDEAL_SORT_ORDR'
	},{
		text: '추천상품',
		width: 80,
		align: 'center',
		dataIndex: 'RECOMEND_AT',
		renderer: function(value) {
			if(value == 'Y') return '예';
			else return '아니오';
		}
	},{
		text: '추천순서',
		width: 80,
		align: 'center',
		dataIndex: 'RECOMEND_SORT_ORDR'	
	},{
		text: '사용여부',
		width: 80,
		align: 'center',
		dataIndex: 'DELETE_AT_NM',
		renderer: function(value, metaData, record) {
			if(record.data.DELETE_AT == 'T') return '<font color="blue">' + value + '</font>';
			else return value;
		}
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
	bbar: Ext.create('Ext.PagingToolbar', {
		store: jsGoods,
		displayInfo: true,
		displayMsg: '전체 {2}건 중 {0} - {1}',
		emptyMsg: "조회된 자료가 없습니다."
	}),
	listeners : {
		celldblclick: function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			if(cellIndex == 12) { //사용여부
				fn_openPopup('/goods/detail?adminAt=Y&hidGoodsCode='+record.data.GOODS_CODE, 'winGoodsDetail', 1250, 700);
			} else {
				parent.fn_open_menu('01004','여행상품등록','/mngr/GoodsRegist/?GOODS_CODE='+record.data.GOODS_CODE);	
			}			
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
	comboUpperCl.getStore().load({params:{UPPER_CL_CODE:'00000', DELETE_AT:'N'}});
});
