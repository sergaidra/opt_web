Ext.define('Image', {
    extend: 'Ext.data.Model',
    fields: [
        { name:'src', type:'string' },
        { name:'caption', type:'string' }
    ]
});

Ext.create('Ext.data.Store', {
    id:'imagesStore',
    model: 'Image',
    data: [
        { src:'/file/getImage/?file_code=0000000192&file_sn=11', caption:'Drawing & Charts' },
        { src:'/file/getImage/?file_code=0000000192&file_sn=1', caption:'Drawing & Charts' },
        { src:'/file/getImage/?file_code=0000000192&file_sn=2', caption:'Advanced Data' },
        { src:'/file/getImage/?file_code=0000000216&file_sn=1', caption:'Overhauled Theme' },
        { src:'/file/getImage/?file_code=0000000216&file_sn=2', caption:'Performance Tuned' },
        { src:'/file/getImageThumb/?file_code=0000000216&file_sn=3', caption:'Performance Tuned' }
    ]
});

var imageTpl = new Ext.XTemplate(
    '<tpl for=".">',
        '<div style="margin-bottom: 10px;" class="thumb-wrap">',
          '<img src="{src}"/>',
          '<br/><span>{caption}</span>',
        '</div>',
    '</tpl>'
);


Ext.onReady(function(){
	Ext.create('Ext.view.View', {
	    store: Ext.data.StoreManager.lookup('imagesStore'),
	    tpl: imageTpl,
	    itemSelector: 'div.thumb-wrap',
	    emptyText: 'No images available',
	    renderTo: Ext.getBody()
	});
});


