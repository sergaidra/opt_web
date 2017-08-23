/*Ext.define('Ext.ux.form.MultiFile', {
    extend: 'Ext.form.field.File',
    alias: 'widget.multifilefield',
 
    initComponent: function () {
        var me = this;
 
        me.on('render', function () {
            me.fileInputEl.set({ multiple: 'multiple' });
        });
 
        me.callParent(arguments);
    },
 
    onFileChange: function (button, e, value) {
        var me = this,
            upload = me.fileInputEl.dom,
            files = upload.files,
            names = [];
 
        if (files) {
            for (var i = 0; i < files.length; i++)
                names.push(files[i].name);
            value = names.join(', ');
        }
 
        me.callParent(arguments);
    }
});
 
Ext.onReady(function () {
    var grid = Ext.widget({
        xtype: 'grid',
        width: 400,
        height: 200,
        store: {
            fields: ['name', 'size']
        },
        tbar: [{
            text: 'Add files',
            handler: function () {
                var win = Ext.widget({
                    xtype: 'window',
                    title: 'Upload form',
                    width: 500,
                    autoShow: true,
                    items: {
                        xtype: 'form',
                        border: false,
                        bodyStyle: {
                            padding: '10px'
                        },
                        items: {
                            xtype: 'multifilefield',
                            id: 'ATTACH_FLIE',
                            labelWidth: 80,
                            fieldLabel: 'Choose file(s)',
                            anchor: '100%',
                            allowBlank: false,
                            margin: 0
                        }
                    },
                    buttons: [{
                        text: 'Upload',
                        handler: function () {
                            var form = win.down('form').getForm();
 
                            if (!form.isValid()) return;
 
                            form.submit({
                                url: '/mngr/uploadfiles/',
                                waitMsg: 'Uploading your file(s)...',
                                success: function (f, a) {
                                    var data = a.result.data;
                                    if (data.length) {
                                        grid.store.loadData(data, true);
                                    }
                                    win.close();
                                },
                                failure: function (f, a) {
                                    Ext.Msg.alert('Failure', a.result.msg || 'server error', function () {
                                        win.close();
                                    });
                                }
                            });
                        }
                    }, {
                        text: 'Cancel',
                        handler: function () {
                            win.close();
                        }
                    }]
                });
            }
        }],
        columns: [
            { text: 'name', dataIndex: 'name', width: 200 },
            { text: 'size', dataIndex: 'size', width: 100, renderer: Ext.util.Format.fileSize }
        ],
        renderTo: Ext.getBody()
    });
});*/


Ext.onReady(function(){
   var panel = Ext.create('Ext.form.Panel',{
	   title : '폼패널 - 파일첨부',
	   id: 'form-file',
	   renderTo : Ext.getBody(),
	   items : [{
/*				xtype : 'filefield',
				name : 'ATTACH_FLIE',
				id: 'ATTACH_FLIE',
				buttonOnly: true,
				allowBlank : false,
				buttonText : '찾아보기',*/
		   
				xtype: 'filefield',
	    		name: 'ATTACH_FLIE',
	    		regex: /^.*\.(BMP|GIF|JPG|JPEG|PNG|bmp|gif|jpg|jpeg|png)$/,
	    		regexText: '이지미 파일을 선택하세요.',
	    		buttonText: '찾기...',
	    		fieldLabel: '첨부파일',
	    		labelAlign: 'right',
	    		labelSeparator: ':',
	    		labelWidth: 100,
	    		allowBlank: false,
	    		width: 510,		   
		   
				listeners:{
					afterrender:function(fileObj){
						//파일태그옵션에 multiple이라는 옵션을 정의
						fileObj.fileInputEl.set({
							multiple:'multiple'
						});
					},
/*					change : function(){
						//파일첨부를 다중으로 선택시 열시버튼 누르면
						//change 이벤트를 발생시켜 폼 submit!
						var frm = panel.getForm();
						if(frm.isValid()) {
							frm.submit({
								url: '/mngr/uploadfiles/',
								success : function(fp, res) {
									var jsonResult = Ext.JSON.decode(res.response.responseText);
									var msg = "업로드된 파일명<br/>";
									Ext.each(jsonResult.fileList,function(obj){
										msg += obj.fileName+",";
									});
									msg = msg.substring(0,msg.length-1);
									Ext.MessageBox.show({
												title : '업로드된파일명',
												msg : msg,
												buttons : Ext.MessageBox.YES,
												icon : Ext.MessageBox.INFO
									});
									//한번 submit 처리가 되면 filefield는 초기화 되므로
									//다시 filefield에 multiple 속성 설정
									panel.down("filefield").fileInputEl.set({
										multiple:'multiple'
									});
								}
							});
						}
					}*/
				}
		}, {
			xtype: 'button',
			id: 'btn-upload-file',
			text: '업로드',
			width: 60,
			margin: '0 0 0 5',
			listeners: {
				click: function (btn, e, opts) {
					var form = Ext.getCmp('form-file').getForm();
					if (form.isValid()) {
						form.submit({
							timeout: 30*60*1000,
							waitMsg: '잠시만 기다려주십시오...',
							url: '../uploadfiles/',
							method: 'POST',
							//params: {GOODS_CODE: Ext.getCmp('form-reg-goods-code').getValue()},
							success: function(form, action) {
								Ext.Msg.alert('알림', '저장되었습니다.', function(){
									alert('성공');
									//Ext.getCmp("filefield").fileInputEl.set({
									panel.down("filefield").fileInputEl.set({
										multiple:'multiple'
									});
									//storeFile.load({params:{GOODS_CODE:Ext.getCmp('form-reg-goods-code').getValue()}});
								});
							},
							failure: function(form, action) {
								alert('실패');
								//fn_failureMessage(action.response);
							}
						});
					} else {
						console.log('is not valid');
						Ext.Msg.alert('확인', '업로드할 파일(png,jpg)을 선택하십시오.');
					}
				}
			}			
		}]
   })
});

