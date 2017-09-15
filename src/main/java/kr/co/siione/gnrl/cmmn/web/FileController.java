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

import org.apache.commons.lang3.StringUtils;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "/file/")
public class FileController {

    private String RESOURCE_PATH = "C:" + File.separator + "optFiles" + File.separator;
    private String NO_IMAGE_NAME = "no_img.gif";
    private String NO_IMAGE_PATH = "/images/" + NO_IMAGE_NAME;

	@Resource
	private FileService fileService;

    
    @RequestMapping(value="/imageListIframe/")
    public String imageList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	
    	String file_code = SimpleUtils.default_set(request.getParameter("file_code"));

    	HashMap map = new HashMap();
    	map.put("file_code", file_code);
    	List<HashMap> result = fileService.getFileList(map);
    	
    	
    	System.out.println("[이미지]result:"+result);
    	
    	

        model.addAttribute("result", result);
        return "gnrl/file/imageList";
    }

    @RequestMapping(value="/getImage/")
    public ResponseEntity<byte[]> getImage(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ResponseEntity entity = null;
        HttpHeaders responseHeaders = new HttpHeaders();
        entity = new ResponseEntity(HttpStatus.BAD_REQUEST);

        String file_code = SimpleUtils.default_set(request.getParameter("file_code"));
        String file_sn = SimpleUtils.default_set(request.getParameter("file_sn"));

    	String noImagePath = request.getSession().getServletContext().getRealPath("/") + NO_IMAGE_PATH;
    	String realPath = noImagePath;
    	String fileName = NO_IMAGE_NAME;
        
    	HashMap map = new HashMap();
    	map.put("file_code", file_code);    	
    	map.put("file_cl", "I");
    	
    	//파일번호 없으면 대표이미지 조회
    	if(file_sn.isEmpty()){
        	map.put("reprsnt_at", "Y");
    	}else{
        	map.put("file_sn", file_sn);
    	}
    	HashMap result = fileService.getFileDetail(map);

    	if(result == null){
    		map.put("reprsnt_at", "N");
    		result = fileService.getFileDetail(map);
    	}
    	
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

    @RequestMapping(value="/getImageThumb/")
    public ResponseEntity<byte[]> getImageThumb(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ResponseEntity entity = null;
        HttpHeaders responseHeaders = new HttpHeaders();
        entity = new ResponseEntity(HttpStatus.BAD_REQUEST);

        String file_code = SimpleUtils.default_set(request.getParameter("file_code"));
        String file_sn = SimpleUtils.default_set(request.getParameter("file_sn"));

    	String noImagePath = request.getSession().getServletContext().getRealPath("/") + NO_IMAGE_PATH;
    	String realPath = noImagePath;
    	String fileName = NO_IMAGE_NAME;
        
    	HashMap map = new HashMap();
    	map.put("file_code", file_code);    	
    	map.put("file_cl", "I");
    	
    	//파일번호 없으면 대표이미지 조회
    	if(file_sn.isEmpty()){
        	map.put("reprsnt_at", "Y");
    	}else{
        	map.put("file_sn", file_sn);
    	}
    	HashMap result = fileService.getFileDetail(map);

    	if(result != null){
        	realPath = SimpleUtils.default_set((String) result.get("FILE_PATH"));
        	// 썸네일이미지 가져오기
        	realPath = StringUtils.replace(realPath, "GOODS", "GOODS\\thumb");
        	realPath = realPath.substring(0, realPath.lastIndexOf(".")) + "_resize" + realPath.substring(realPath.lastIndexOf("."));
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
