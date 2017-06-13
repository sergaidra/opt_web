package kr.co.siione.gnrl.cmmn.web;

import java.io.File;
import java.io.FileInputStream;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.dist.ffmpeg.StreamView;
import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.cmmn.service.FileService;

import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "/file/")
public class FileController {

    private String resourcePath = "C:" + File.separator + "optFiles" + File.separator;

	@Resource
	private FileService fileService;
	
    @RequestMapping(value="/getImage/")
    public ResponseEntity<byte[]> getThumbnail(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ResponseEntity entity = null;
        HttpHeaders responseHeaders = new HttpHeaders();
        entity = new ResponseEntity(HttpStatus.BAD_REQUEST);

        String file_code = SimpleUtils.default_set(request.getParameter("file_code"));
        String file_sn = SimpleUtils.default_set(request.getParameter("file_sn"));

    	String noImagePath = request.getSession().getServletContext().getRealPath("/") + "/images/no_img.gif";
    	String realPath = noImagePath;
    	String fileName = "no_img.gif";
        
    	HashMap map = new HashMap();
    	map.put("file_code", file_code);
    	map.put("file_sn", file_sn);
    	map.put("file_cl", "I");
    	HashMap result = fileService.getFileDetail(map);

    	if(result != null){
        	realPath = SimpleUtils.default_set((String) result.get("FILE_PATH"));
        	fileName = SimpleUtils.default_set((String) result.get("FILE_NM"));
    	}

        FileInputStream fileStream = null;  

        try {
            File getResource = new File(realPath);
            if(!getResource.exists()){
    	    	realPath = noImagePath;
    	        getResource = new File(realPath);
            }
            byte byteStream[] = new byte[(int)getResource.length()];
            fileStream = new FileInputStream(getResource);
            int i = 0;
            for(int j = 0; (i = fileStream.read()) != -1; j++)
                byteStream[j] = (byte)i;

            responseHeaders.setContentType(MediaType.IMAGE_JPEG);
            responseHeaders.set("Content-Disposition", "attatchment; filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO-8859-1") +"\"");
            entity = new ResponseEntity(byteStream, responseHeaders, HttpStatus.OK);
    	} catch(Exception e) {
    		e.printStackTrace();
            fileStream.close();
        } finally {
            fileStream.close();
    	}
        return entity;
    }

    @RequestMapping(value="/getStream/")
    public void streamView(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        //대상 동영상 파일명
        String file_code = SimpleUtils.default_set(request.getParameter("file_code"));
        String file_sn = SimpleUtils.default_set(request.getParameter("file_sn"));
        
    	HashMap map = new HashMap();
    	map.put("file_code", file_code);
    	map.put("file_sn", file_sn);
    	map.put("file_cl", "M");
    	HashMap result = fileService.getFileDetail(map);

    	StreamView sv = new StreamView();
    	if(result != null){
    		String realPath = (String) result.get("FILE_PATH");
        	String fileName = (String) result.get("FILE_NM");
			//스트리밍 시작
    		sv.makeStream(realPath, request, response);
    	}
    }
    
}
