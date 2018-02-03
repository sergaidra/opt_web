Ext.define('PayInfo', {
	extend: 'Ext.data.Model',
	fields: ['PURCHS_SN','TID','RESULTCODE','RESULTMSG','EVENTCODE','TOTPRICE','MOID','PAYMETHOD','APPLNUM','APPLDATE','APPLTIME','CARD_NUM','CARD_INTEREST','CARD_QUOTA','CARD_CODE','CARD_BANKCODE','VACT_NUM','VACT_BANKCODE','VACTBANKNAME','VACT_NAME','VACT_INPUTNAME','VACT_DATE','VACT_TIME','ACCT_BANKCODE','CSHR_RESULTCODE','CSHR_TYPE','PAY_DEVICE','STATUS']
});

var frPay = Ext.create('Ext.form.Panel', {
	id: 'form-sch',
	region: 'north',
	height: 65,
	items: [{
		xtype: 'fieldset',
		title: '검색조건',
		padding: '5 10 5 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'datefield',
				vtype: 'daterange',
				id: 'sch-fr-date',
				name: 'FR_DE',
				format: 'Y-m-d',
				altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd',
				fieldLabel: '검색일자',
				labelAlign: 'right',
				labelWidth: 80,
				width: 200,
				allowBlank: false,
				value: new Date(Date.parse(new Date())-6*1000*60*60*24),
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
								Ext.getCmp('btn-search-pay').fireEvent('click');
							}
						}
					}
				}
			}, {
				xtype: 'datefield',
				vtype: 'daterange',
				id: 'sch-to-date',
				name: 'TO_DE',
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
								Ext.getCmp('btn-search-pay').fireEvent('click');
							}
						}
					}
				}
			}, {
				xtype: 'button',
				id: 'btn-search-pay',
				margin: '0 0 0 10',
				text: '조회',
				width: 60,
				listeners: {
					click: function() {
						stPay.proxy.extraParams = Ext.getCmp('form-sch').getForm().getValues();
						stPay.loadPage(1);
					}
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					frPay.getForm().reset();
					stPay.removeAll();
				}
			}]
		}]
	}]
});

var stPay = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	//pageSize: 20,
	model: 'PayInfo',
	sorters: {property: 'PURCHS_SN', direction: 'desc'},
	proxy: {
		type: 'ajax',
		url: '../selectPayList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grPay = Ext.create('Ext.grid.Panel', {
	title: '결제결과목록',
	region:'center',
	store: stPay,
	border: true,
	columnLines: true,
	split : true,
	viewConfig: {
		stripeRows: true,
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{text: '순번', width: 50, xtype: 'rownumberer'}
			, {text: '결제번호'         , width: 80, align: 'center', dataIndex: 'PURCHS_SN'      , locked: true}
			, {text: 'TID'             , width: 320, align: 'left', dataIndex: 'TID'            , locked: true}
			, {text: 'RESULTCODE'      , width: 150, align: 'left', dataIndex: 'RESULTCODE'     }
			, {text: 'RESULTMSG'       , width: 150, align: 'left', dataIndex: 'RESULTMSG'      }
			, {text: 'EVENTCODE'       , width: 150, align: 'left', dataIndex: 'EVENTCODE'      , hidden: true}
			, {text: 'TOTPRICE'        , width: 150, align: 'left', dataIndex: 'TOTPRICE'       }
			, {text: 'MOID'            , width: 150, align: 'left', dataIndex: 'MOID'           }
			, {text: 'PAYMETHOD'       , width: 150, align: 'left', dataIndex: 'PAYMETHOD'      }
			, {text: 'APPLNUM'         , width: 150, align: 'left', dataIndex: 'APPLNUM'        }
			, {text: 'APPLDATE'        , width: 150, align: 'left', dataIndex: 'APPLDATE'       }
			, {text: 'APPLTIME'        , width: 150, align: 'left', dataIndex: 'APPLTIME'       }
			, {text: 'CARD_NUM'        , width: 150, align: 'left', dataIndex: 'CARD_NUM'       }
			, {text: 'CARD_INTEREST'   , width: 150, align: 'left', dataIndex: 'CARD_INTEREST'  }
			, {text: 'CARD_QUOTA'      , width: 150, align: 'left', dataIndex: 'CARD_QUOTA'     }
			, {text: 'CARD_CODE'       , width: 150, align: 'left', dataIndex: 'CARD_CODE'      }
			, {text: 'CARD_BANKCODE'   , width: 150, align: 'left', dataIndex: 'CARD_BANKCODE'  }
			, {text: 'VACT_NUM'        , width: 150, align: 'left', dataIndex: 'VACT_NUM'       }
			, {text: 'VACT_BANKCODE'   , width: 150, align: 'left', dataIndex: 'VACT_BANKCODE'  }
			, {text: 'VACTBANKNAME'    , width: 150, align: 'left', dataIndex: 'VACTBANKNAME'   }
			, {text: 'VACT_NAME'       , width: 150, align: 'left', dataIndex: 'VACT_NAME'      }
			, {text: 'VACT_INPUTNAME'  , width: 150, align: 'left', dataIndex: 'VACT_INPUTNAME' }
			, {text: 'VACT_DATE'       , width: 150, align: 'left', dataIndex: 'VACT_DATE'      }
			, {text: 'VACT_TIME'       , width: 150, align: 'left', dataIndex: 'VACT_TIME'      }
			, {text: 'ACCT_BANKCODE'   , width: 150, align: 'left', dataIndex: 'ACCT_BANKCODE'  }
			, {text: 'CSHR_RESULTCODE' , width: 150, align: 'left', dataIndex: 'CSHR_RESULTCODE'}
			, {text: 'CSHR_TYPE'       , width: 150, align: 'left', dataIndex: 'CSHR_TYPE'      }
			, {text: 'PAY_DEVICE'      , width: 150, align: 'left', dataIndex: 'PAY_DEVICE'     }
			, {text: 'STATUS'          , width: 150, align: 'left', dataIndex: 'STATUS'         }
	]
	/*bbar: Ext.create('Ext.PagingToolbar', {
		store: stPay,
		displayInfo: true,
		displayMsg: '전체 {2}건 중 {0} - {1}',
		emptyMsg: "조회된 자료가 없습니다."
	})*/
});

Ext.onReady(function(){
	Ext.create('Ext.Viewport', {
		layout: 'border',
		padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [frPay, grPay]
	});
});