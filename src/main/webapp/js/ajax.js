var Ajax = {};

Ajax.getJson = function(iUrl, queryString, processAfterGet){
	$.ajax({
		url: iUrl,
		dataType: 'json',
		type: 'post',  
		async: false,
		data: queryString,
		timeout: 3000,
	    error: function(request, errorType)
		{
			try
			{
				if(errorType == 'timeout')
				{
					if(Ajax.timeoverError){
						alert(Ajax.timeoverError);
					}else{
						alert("Error: reponse time over");
					}
						
				} else
				{
					if(Ajax.retrievefailError){
						alert(Ajax.retrievefailError);
					}else{
						alert("Error: retrieve data fail");
					}
				}
			}
			catch (e) {
			}
		},
		success: function(data)
		{
			if(data != null && data.Error){
					alert(data.Error);
			}else{
				if(typeof processAfterGet === "function"){
					processAfterGet(data);
				}else{
					console.log("not callback!!");
				}
			}
		}
	});
};

Ajax.setErrorMessage = function (timeover, retrievefail){
	Ajax.timeoverError = timeover;
	Ajax.retrievefailError = retrievefail;
};