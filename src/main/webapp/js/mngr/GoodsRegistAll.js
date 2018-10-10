var combo1 = new Ext.create('Ext.form.ComboBox', {
	id: 'form-reg-upper-cl-code',
	name: 'UPPER_CL_CODE',
	width: 275,
	fieldLabel: '상품분류',
	labelAlign: 'right',
	labelWidth: 100,	
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
	emptyText: '선택',
	listeners: {
		change: function(combo, newValue, oldValue, eOpts ) {
			Ext.getCmp('form-cl-code').setValue('');
			combo2.getStore().load({params:{UPPER_CL_CODE:newValue}});
		}
	}
});

var combo2 = new Ext.create('Ext.form.ComboBox', {
	id: 'form-reg-cl-code',
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
	    }
	}),
	displayField: 'CL_NM',
	valueField: 'CL_CODE',
	queryMode: 'local',
	typeAhead: true,
	editable: false,
	emptyText: '선택'
});

/*
 * 검색조건 form을 정의
 */
var frReg = Ext.create('Ext.form.Panel', {
	title: '상품정보입력',
	id: 'form-reg',
	region: 'center',
	autoScroll: true,
	//height: 70,
	tbar: [{ 
		xtype: 'button',
		text: '저장',
		margin: '0 0 0 10',
		width: 70
	}],
	items: [{
        xtype: 'fieldset',
        title: '상품 기본 정보',
        padding: '10 20 10 10',
        items: [{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [combo1, {
            	xtype: 'label',
            	width: 5
            }, combo2]
        },{
        	xtype: 'textfield',
        	id: 'form-reg-goods-nm',
        	name: 'GOODS_NM',
        	fieldLabel: '상품명',
			fieldStyle: {'ime-mode':'active'},	
			labelSeparator: ':',
			labelWidth: 100,
			labelAlign: 'right',
			width: 450,
			maxLength: 100,
			enforceMaxLength: true,
			allowBlank: true,
			enableKeyEvents: true
        },{
        	xtype: 'textareafield',
        	id: 'form-reg-goods-intrcn',
        	name: 'GOODS_NM',
        	fieldLabel: '상품설명',
			fieldStyle: {'ime-mode':'active'},	
			labelSeparator: ':',
			labelWidth: 100,
			labelAlign: 'right',
			grow: false,
	    	isFocus: false,
	    	height: 100,
			width: 600,
			//maxLength: 100,
			//enforceMaxLength: true,
			allowBlank: true,
			enableKeyEvents: true
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
                xtype: 'numberfield',
                id: 'form-reg-wait-hour',
            	name: 'WAIT_HOUR',
                width: 160,
                fieldLabel: '대기시간',                
                labelWidth: 100,
                labelAlign: 'right',
                value: 0,
                step: 1,
                minValue: 0,
                maxValue: 10
            },{
            	xtype: 'label',
            	text: '시간',
                margin: '5 5 10 5'
            },{
                xtype: 'numberfield',
                id: 'form-reg-wait-minute',
            	name: 'WAIT_MINUTE',
                width: 55,
                hideLabel: true,                
                value: 0,
                step: 5,
                minValue: 0,
                maxValue: 55
            },{
            	xtype: 'label',
            	text: '분',
                margin: '5 5 10 5'
            },{
                xtype: 'numberfield',
                id: 'form-reg-mvmn-hour',
            	name: 'MVMN_HOUR',
                width: 160,
                fieldLabel: '이동시간',                
                labelWidth: 100,
                labelAlign: 'right',
                value: 0,
                step: 1,
                minValue: 0,
                maxValue: 10
            },{
            	xtype: 'label',
            	text: '시간',
                margin: '5 5 10 5'
            },{
                xtype: 'numberfield',
                id: 'form-reg-mvmn-minute',
            	name: 'MVMN_MINUTE',
                width: 55,
                hideLabel: true,                
                value: 0,
                step: 5,
                minValue: 0,
                maxValue: 55
            },{
            	xtype: 'label',
            	text: '분',
                margin: '5 5 10 5'
            }]
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
                xtype: 'numberfield',
                id: 'form-reg-act-la',
            	name: 'ACT_LA',
                width: 250,
                fieldLabel: '장소위도',                
                labelWidth: 100,
                labelAlign: 'right',
                decimalPrecision: 6,
                // Remove spinner buttons, and arrow key and mouse wheel listeners
                hideTrigger: true,
                keyNavEnabled: false,
                mouseWheelEnabled: false
            },{
            	xtype: 'label',
                width: 5
            },{
                xtype: 'numberfield',
                id: 'form-reg-act-lo',
            	name: 'ACT_LO',
                width: 270,
                fieldLabel: '장소경도',                
                labelWidth: 120,
                labelAlign: 'right',
                decimalPrecision: 6,
                // Remove spinner buttons, and arrow key and mouse wheel listeners
                hideTrigger: true,
                keyNavEnabled: false,
                mouseWheelEnabled: false
            }]
        }]
    },{
        xtype: 'fieldset',
        title: '상품 간략 정보',
        padding: '10 20 10 10',
        items: [{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
                xtype: 'textfield',
                id: 'form-reg-intrcn-goods-ty',
            	name: 'INTRCN_GOODS_TY',
                width: 300,
                fieldLabel: '상품유형',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			maxLength: 10,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true
            },{
                xtype: 'textfield',
                id: 'form-reg-intrcn-use-time',
            	name: 'INTRCN_USE_TIME',
                width: 300,
                fieldLabel: '이용시간',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			maxLength: 10,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true
            }]
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
                xtype: 'textfield',
                id: 'form-reg-intrcn-meet-time',
            	name: 'INTRCN_MEET_TIME',
                width: 300,
                fieldLabel: '집합시간',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			maxLength: 10,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true
            },{
                xtype: 'textfield',
                id: 'form-reg-intrcn-reqre-time',
            	name: 'INTRCN_REQRE_TIME',
                width: 300,
                fieldLabel: '소요시간',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			maxLength: 10,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true
            }]
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
                xtype: 'textfield',
                id: 'form-reg-intrcn-provd-lang',
            	name: 'INTRCN_PROVD_LANG',
                width: 300,
                fieldLabel: '제공언어',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			maxLength: 10,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true
            },{
                xtype: 'textfield',
                id: 'form-reg-intrcn-posbl-age',
            	name: 'INTRCN_POSBL_AGE',
                width: 300,
                fieldLabel: '최소인원',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			maxLength: 10,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true
            }]
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
                xtype: 'textfield',
                id: 'form-reg-intrcn-place',
            	name: 'INTRCN_PLACE',
                width: 300,
                fieldLabel: '장소',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			maxLength: 10,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true
            }]        
        }]
    },{
        xtype: 'fieldset',
        title: '상품 바우처 정보',
        padding: '10 20 10 10',
        items: [{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
                xtype: 'textfield',
                id: 'form-reg-vochr-ticket-ty',
            	name: 'VOCHR_TICKET_TY',
                width: 300,
                fieldLabel: '티켓유형',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			maxLength: 10,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true
            },{
                xtype: 'textfield',
                id: 'form-reg-vochr-ntss-reqre-time',
            	name: 'VOCHR_NTSS_REQRE_TIME',
                width: 300,
                fieldLabel: '발권소요시간',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			maxLength: 10,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true
            }]
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-vochr-use-mth',
            	name: 'VOCHR_USE_MTH',
            	fieldLabel: '사용방법',
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 50,    			
    			maxLength: 250,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true    			
            }]
        }]
    },{
        xtype: 'fieldset',
        title: '상품 이용 안내',
        padding: '10 20 10 10',
        items: [{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-guidance-use-time',
            	name: 'GUIDANCE_USE_TIME',
                width: 300,
                fieldLabel: '이용시간',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 50,    			
    			maxLength: 250,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true 
            }]
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-guidance-reqre-time',
            	name: 'GUIDANCE_REQRE_TIME',
                width: 300,
                fieldLabel: '소요시간',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 50,    			
    			maxLength: 250,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true 
            }]
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-guidance-age-div',
            	name: 'GUIDANCE_AGE_DIV',
                width: 300,
                fieldLabel: '연령구분',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 50,    			
    			maxLength: 250,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true 
            }]  
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-guidance-tour-schdul',
            	name: 'GUIDANCE_TOUR_SCHDUL',
                width: 300,
                fieldLabel: '여행일정',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 150,    			
    			maxLength: 500,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true 
            }]   
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-guidance-prfplc-lc',
            	name: 'GUIDANCE_PRFPLC_LC',
                width: 300,
                fieldLabel: '공연장위치',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 150,    			
    			maxLength: 500,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true 
            }]
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-guidance-edc-crse',
            	name: 'GUIDANCE_EDC_CRSE',
                width: 300,
                fieldLabel: '교육과정',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 150,    			
    			maxLength: 500,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true 
            }] 
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-guidance-optn-matter',
            	name: 'GUIDANCE_OPTN_MATTER',
                width: 300,
                fieldLabel: '옵션사항',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 150,    			
    			maxLength: 500,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true 
            }]    
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-guidance-pickup',
            	name: 'GUIDANCE_PICKUP',
                width: 300,
                fieldLabel: '픽업',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 50,    			
    			maxLength: 250,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true 
            }]    
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-guidance-prparetg',
            	name: 'GUIDANCE_PRPARETG',
                width: 300,
                fieldLabel: '준비물',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 50,    			
    			maxLength: 250,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true 
            }]
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-guidance-incls-matter',
            	name: 'GUIDANCE_INCLS_MATTER',
                width: 300,
                fieldLabel: '포함사항',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 80,    			
    			maxLength: 250,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true 
            }]  
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-guidance-not-incls-matter',
            	name: 'GUIDANCE_NOT_INCLS_MATTER',
                width: 300,
                fieldLabel: '불포함사항',                
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 80,    			
    			maxLength: 250,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true 
            }]        
        }]   
    },{
        xtype: 'fieldset',
        title: '상품 기타 정보',
        padding: '10 20 10 10',
        items: [{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-adit-guidance',
            	name: 'ADIT_GUIDANCE',
            	fieldLabel: '추가안내',
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 150,    			
    			maxLength: 500,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true    			
            }]
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-atent-matter',
            	name: 'ATENT_MATTER',
            	fieldLabel: '유의사항',
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 150,    			
    			maxLength: 500,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true    			
            }]  
        },{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
            	xtype: 'textareafield',
                id: 'form-reg-change-refnd-regltn',
            	name: 'CHANGE_REFND_REGLTN',
            	fieldLabel: '변경/환불규정',
    			fieldStyle: {'ime-mode':'active'},	
    			labelSeparator: ':',
    			labelWidth: 100,
    			labelAlign: 'right',
    			grow: false,
    	    	isFocus: false,
    			width: 600,
    	    	height: 150,    			
    			maxLength: 500,
    			enforceMaxLength: true,
    			allowBlank: true,
    			enableKeyEvents: true    			
            }]         
        }]    
    },{
        xtype: 'fieldset',
        hidden: true,
        title: '검색조건',
        padding: '10 20 10 10',
        items: [{
            xtype: 'fieldcontainer',
            layout: 'hbox',
            items: [{
                xtype: 'button',
                margin: '0 0 0 10',
                text: '조회',
                width: 70,
                handler: function(){}
            },{
                xtype: 'button',
                margin: '0 0 0 5',
                text: '초기화',
                width: 70,
                handler: function(){}
            }]
        }]
    }]
});




Ext.onReady(function(){    
    Ext.create('Ext.Viewport', {
        layout: 'border',
        //padding:'5 5 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
        items: [Ext.create('Ext.tab.Panel', {
        	layout: 'border',
        	region: 'center',
        	padding:'5 5 5 5',
        	style: {
        		backgroundColor: '#FFFFFF'
        	},        	
            items: [frReg]
        })]
    });
});




/*Ext.create('Ext.panel.Panel',{
	layout: 'border',
	region: 'center',
	
	style: {
		backgroundColor: '#FFFFFF'
	},
	items: [frReg]
})*/


/*
 * 화면 레이아웃을 구성한다.
 */
/*Ext.onReady(function(){    
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
        	items: [frReg]
        })]
    });
});*/
