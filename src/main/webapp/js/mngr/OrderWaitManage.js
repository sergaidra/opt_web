var xlsForm = Ext.create('Ext.form.Panel', {});		//엑셀 저장용 폼


Ext.define('PurchsInfo', {
	extend: 'Ext.data.Model',
	fields: ['CART_SN', 'CART_DT', 'USER_NM', 'GOODS_NM', 'CHKIN_DE', 'CHCKT_DE', 'STATUS']
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
				xtype: 'radiogroup',
				id: 'sch-rd-delete-at',
				fieldLabel: '구분',
				labelWidth: 150,
				labelAlign: 'right',
				border: false,
				width: 450,
				items: [{ boxLabel: '전체', id:'radio-status-all', name: 'STATUS', inputValue:''},
						{ boxLabel: '확인요청', id:'radio-status-w', name: 'STATUS', inputValue:'W', checked: true},
						{ boxLabel: '확인완료', id:'radio-status-c', name: 'STATUS', inputValue:'C'}]
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
			}, {
				xtype: 'button',
				id: 'btn-excel',
				margin: '0 0 0 10',
				text: '엑셀',
				width: 60,
				listeners: {
					click: function() {
						xlsForm.getForm().standardSubmit = true;
						xlsForm.getForm().submit({
							url   : '../selectOrderWaitListExcel/',
							method: 'POST',
							params: stPurchs.proxy.extraParams
						});
					}
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					frPurchs.getForm().reset();
					frUser.getForm().reset();
					stPurchs.removeAll();
					stUser.removeAll();
				}
			}]
		}
		
		
		]
	}]
});

var stPurchs = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	pageSize: 20,
	model: 'PurchsInfo',
	proxy: {
		type: 'ajax',
		url: '../selectOrderWaitList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grPurchs = Ext.create('Ext.grid.Panel', {
	title: '예약대기목록',
	region:'center',
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
		text: '예약번호',
		width: 100,
		align: 'center',
		dataIndex: 'CART_SN'
	},{
		text: '장바구니 시각',
		width: 200,
		align: 'center',
		dataIndex: 'CART_DT'
	},{
		text: '예약자',
		width: 100,
		align: 'center',
		dataIndex: 'USER_NM'
	},{
		text: '상품명',
		width: 200,
		align: 'center',
		dataIndex: 'GOODS_NM'
	},{
		text: '시작일자',
		width: 100,
		align: 'center',
		dataIndex: 'CHKIN_DE'
	},{
		text: '종료일자',
		width: 100,
		align: 'center',
		dataIndex: 'CHCKT_DE'
	},{
		text: '액션',
		align: 'center',
		renderer: function(value, meta, record) {
			console.log(record);
			if(record.data.STATUS == 'C') 
				return '';
            var id = Ext.id();
            Ext.defer(function(){
                new Ext.Button({
                    text: '확인완료',
                    handler : function(grid, rowIndex, colIndex) {
                    	Ext.MessageBox.confirm("확인", "확인완료처리하시겠습니까?", function(btn) {
        					if(btn == 'yes') {
        						Ext.Ajax.request({
        							url: '../updateReservationStatus/',
        							timeout: 60000,
        							params: {
        								CART_SN: record.data.CART_SN
        							},
        							success: function(response){
        								var result = Ext.decode(response.responseText);
        								Ext.MessageBox.alert('알림', result.message, function(){
        									if(result.success) {
        										stPurchs.reload();
        									}
        								});
        							},
        							failure: function(response){
        								failureMessage(response);
        							}
        						});
        					} else {
        						return;
        					}
        				});
                    }
                }).render(document.body, id);
            },50);
            return Ext.String.format('<div id="{0}"></div>', id);
        }
	}],
	bbar: Ext.create('Ext.PagingToolbar', {
		store: stPurchs,
		displayInfo: true,
		displayMsg: '전체 {2}건 중 {0} - {1}',
		emptyMsg: "조회된 자료가 없습니다."
	}),
	listeners: {
		celldblclick: function(gr, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			alert(cellIndex);
			if(cellIndex == 0) {

			}
		}
	}
});

Ext.onReady(function(){
	Ext.create('Ext.Viewport', {
		layout: 'border',
		padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [frPurchs, grPurchs]
	});
	
	stPurchs.load({params:{STATUS:'W'}});
});