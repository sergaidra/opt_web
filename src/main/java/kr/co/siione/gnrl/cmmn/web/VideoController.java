package kr.co.siione.gnrl.cmmn.web;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.dist.disk.Operation;
import kr.co.siione.dist.ffmpeg.FFmpeg;
import kr.co.siione.dist.ffmpeg.StreamView;
import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.cmmn.service.VideoService;
import kr.co.siione.utl.Utility;
import net.sf.json.JSONObject;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StopWatch;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
@RequestMapping(value = "/cmm/")
public class VideoController {
	
    private String resourcePath = "C:" + File.separator + "commonFiles" + File.separator;
    private String FFMPEG_EXE = "C:" + File.separator + "Work" + File.separator + "ffmpeg" + File.separator + "bin" + File.separator+"ffmpeg";

	@Resource
	private VideoService videoService;

	FFmpeg ffmpeg = null;
	
    public VideoController() {
    	ffmpeg = new FFmpeg();
        ffmpeg.setFFmpeg(FFMPEG_EXE);
    }
	
    @RequestMapping(value="/fileList/")
    public String fileList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
    	HashMap map = new HashMap();
    	List fileList = videoService.getFileList(map);    	
        model.addAttribute("fileList", fileList);
        return "cmm/fileList";
    }
	
    @RequestMapping(value="/mediaPlayer/")
    public String mediaPlayer(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
        String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
        String file_no = SimpleUtils.default_set(request.getParameter("file_no"));
        
    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	map.put("file_no", file_no);
    	HashMap result = videoService.getFileDetail(map);

        model.addAttribute("file_id", file_id);
        model.addAttribute("file_no", file_no);
        model.addAttribute("sys_file_nm", result.get("SYS_FILE_NM"));
        return "cmm/mediaPlayer";
    }

    @RequestMapping(value="/youtubePlayer/")
    public String youtubePlayer(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
        return "cmm/youtubePlayer";
    }
    
    @RequestMapping(value="/thumbView/")
    public String thumbView(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        
        String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
        String file_no = SimpleUtils.default_set(request.getParameter("file_no"));

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	map.put("file_no", file_no);
    	
    	List thumbList = videoService.getThumbList(map);
        model.addAttribute("file_id", file_id);
        model.addAttribute("file_no", file_no);
        model.addAttribute("thumbList", thumbList);
        model.addAttribute("thumbCnt", thumbList.size());
        model.addAttribute("filePath", file_id+"_"+file_no);
        
        return "cmm/thumbView";
    }

    @RequestMapping(value="/thumbReprsnt/")
    public void thumbReprsnt(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        
        String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
        String file_no = SimpleUtils.default_set(request.getParameter("file_no"));
        String thumb_no = SimpleUtils.default_set(request.getParameter("thumb_no"));

        if(thumb_no.isEmpty()){
        	//error
        	response.sendRedirect("/cmm/thumbView/?file_id="+file_id+"&file_no="+file_no);
        }
        
    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	map.put("file_no", file_no);
    	map.put("thumb_no", thumb_no);
    	
    	videoService.thumbReprsnt(map);
    	response.sendRedirect("/cmm/thumbView/?file_id="+file_id+"&file_no="+file_no);
    }
	
    @RequestMapping(value="/thumbDelete/")
    public void thumbDelete(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        
        String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
        String file_no = SimpleUtils.default_set(request.getParameter("file_no"));
        String thumb_no = SimpleUtils.default_set(request.getParameter("thumb_no"));

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	map.put("file_no", file_no);
    	map.put("thumb_no", thumb_no);
    	
    	HashMap result = videoService.getThumbDetail(map);
    	String thumb_path = (String) result.get("THUMB_PATH");

    	videoService.thumbDelete(map);
    	
        File pathCheck = new File(thumb_path);
        if(pathCheck.exists()) pathCheck.delete();

    	response.sendRedirect("/cmm/thumbView/?file_id="+file_id+"&file_no="+file_no);
    }

    @RequestMapping(value="/thumbExtract/")
    public ResponseEntity<String> thumbExtract (HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
    	ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

    	HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");
		
		String retValue = "-1";

        String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
        String file_no = SimpleUtils.default_set(request.getParameter("file_no"));
        String temp = SimpleUtils.default_set(request.getParameter("position"));
        
        if(!SimpleUtils.isStringDouble(temp)){
    		retValue = "-1";
        }else{
			double sPos = Double.parseDouble(temp);
            //소수점 2자리에서 컷
			sPos = Double.parseDouble(String.format("%.2f",sPos));
			
	    	HashMap map = new HashMap();
	    	map.put("file_id", file_id);
	    	map.put("file_no", file_no);
	    	HashMap result = videoService.getFileDetail(map);
	
	        String videoFilePath = (String) result.get("SYS_FILE_PATH");
	
	        String fString = file_id + "_" + file_no;
	        String thumbPath = resourcePath + fString + File.separator;
	        
	        String sImg = "thumb" + sPos + ".jpg";
	        
	        //섬네일 추출
	        if(ffmpeg.imageExtract(videoFilePath, sPos, thumbPath + sImg, "mjpeg","")){
		        String sTime = SimpleUtils.secondsToTime(sPos);
		    	
		        HashMap tmap = new HashMap();
		        tmap.put("file_id", file_id);
				tmap.put("file_no", file_no);
		        tmap.put("position", sPos);
		        tmap.put("time", sTime);
		        tmap.put("thumb_path", thumbPath + sImg);
		        tmap.put("thumb_nm", sImg);
	        	tmap.put("reprsnt_yn", "N");
	        	
	        	videoService.thumbUpload(tmap);
				retValue = "0";		        	
	        }else{
				retValue = "-1";	
	        }
        }
        
		obj.put("result", retValue);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);
		
    	return entity;
    }


    @RequestMapping(value="/fileCopy/")
    public ResponseEntity<String> fileCopy (HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
    	ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

    	HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");
		
		String retValue = "-1";

        String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
        String file_no = SimpleUtils.default_set(request.getParameter("file_no"));
        String copyPath = SimpleUtils.default_set(request.getParameter("copyPath"));
        String copyOpt = SimpleUtils.default_set(request.getParameter("copyOpt"));

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	map.put("file_no", file_no);
    	HashMap result = videoService.getFileDetail(map);

        String videoFilePath = (String) result.get("SYS_FILE_PATH");
        String videoFileNm = (String) result.get("SYS_FILE_NM");
        //videoFilePath = "D:"+ File.separator +"Down"+ File.separator +"The Prison 2016 720p HDRip 264-[ENTER].mp4";
        
        File pathCheck = new File(copyPath);
        if(!pathCheck.exists() || !pathCheck.isDirectory())
            pathCheck.mkdirs();

		StopWatch stopWatch = new StopWatch();
		stopWatch.start();

		/* FileInputStream 사용     */
		if(copyOpt.equals("1")){
	        File source = new File(videoFilePath);
	        File target = new File(copyPath + videoFileNm);
	
	        BufferedInputStream bis = null;
	        BufferedOutputStream bos = null;
	 
	        try {
	            bis = new BufferedInputStream(new FileInputStream(source));
	            bos = new BufferedOutputStream(new FileOutputStream(target));
	 
	            while (true) {
	                int x = bis.read();
	                if (x == -1) {
	                    break;
	                }
	                bos.write(x);
	            }
	 
	            bis.close();
	            bos.close();
	        } catch (FileNotFoundException e) {
	            e.printStackTrace();
	        } catch (IOException e) {
	            e.printStackTrace();
			} finally {
				retValue = "0";
			}

	    /* copy, del 사용 */
	    }else if(copyOpt.equals("2")){
	    	Operation operation = new Operation();
	    	//파일복사
	        if(operation.copy(videoFilePath, copyPath)){
	        	//복사성공
	        	
	        	//파일삭제
	            //if(operation.del(videoFilePath)){
	            	//삭제성공
	            	retValue = "0";
		        //}
	        }
	    }

		stopWatch.stop();
		System.out.println("stopWatch : "+stopWatch.getTotalTimeMillis()*0.001);

		obj.put("result", retValue);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);
		
    	return entity;
    }

    @RequestMapping(value="/mediaUpload/")
    public void mediaUpload(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		String file_cn = SimpleUtils.default_set(request.getParameter("FILE_CN"));

		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;

    	String filePath = resourcePath;
    	try {
	    	List<MultipartFile> files = multipartRequest.getFiles("FILES");

	    	if (!files.isEmpty()) {
				String file_id = videoService.getFileID();
	    		for (MultipartFile mFile : files) {
	    			if (mFile.isEmpty()) continue;    

	    			String fOrgName = mFile.getOriginalFilename();
	    			String fFormat = "";
	    			if(fOrgName.length() > 0){
	    				fFormat = fOrgName.substring(fOrgName.lastIndexOf(".")+1);
	    			}


	    			//flv format
	    			if(fFormat != null) {
	    			//if(fFormat != null && fFormat.equalsIgnoreCase("flv")) {
	    				HashMap map = new HashMap();
	    				map.put("file_id", file_id);
	    				String file_no = videoService.getFileNo(map);

	    				String fBeforeName = file_id + "_" + file_no + "." + fFormat;
	    				String fRealName = file_id + "_" + file_no + ".flv";
	    				String beforeFilePath = filePath + "beforeConvert" + File.separator + fBeforeName;
   	    				String convertFilePath = filePath+fRealName;

   	    		        Utility utl = Utility.getInstance();
	    				long fSize = utl.saveFile(mFile, beforeFilePath);

		    			//if(ffmpeg.encoding(beforeFilePath, convertFilePath,"flv","20","11025","1280x720")){
		    			if(ffmpeg.encoding(beforeFilePath, convertFilePath,"flv","20","11025","")){
		    				map.put("file_no", file_no);
		    				map.put("file_cn", file_cn);
		    				map.put("file_nm", fOrgName);
		    				map.put("file_size", fSize);
		    				map.put("sys_file_path", convertFilePath);
		    				map.put("sys_file_nm", fRealName);

		    		        String fString = file_id + "_" + file_no;
		    		        String thumbPath = filePath + fString + File.separator;

		    		        //추출할 섬네일 개수
		    		        int thumbCnt = 5;
		    		        File pathCheck = new File(thumbPath);
		    		        if(!pathCheck.exists() || !pathCheck.isDirectory())
		    		            pathCheck.mkdirs();

		    		        //동영상 duration 추출
		    		        double duration = ffmpeg.getDuration(beforeFilePath);
		    		        
		    		        List thumbList = new ArrayList();
		    		        if(duration > 0) {
	    		            	/* 썸네일 추출 - 일괄 */
		    		            double sPos = 0;
    		                    double sSection = Double.parseDouble(String.format("%.2f",duration / thumbCnt));

		    		            String sImg = "";
		    		            String sTime = "";
		    		            //a.jpg를 넣으면 a_1.jpg, a_2.jpg, a_3.jpg
	    		    	        if(ffmpeg.imageExtractFPS(beforeFilePath, duration, sSection, thumbPath + "thumb_init.jpg", "mjpeg","")){
			    		            for(int i = 0; i < thumbCnt; i++) {
			    		                if(i == 0){
			    		                	//구간의 하프
			    		        			sPos = Double.parseDouble(String.format("%.2f",(sSection * 0.5)));
			    		                }else{
			    		        			sPos = Double.parseDouble(String.format("%.2f",(sSection * 0.5)+(sSection * i)));
			    		                }
			    		                sImg = "thumb_init_" + (i+1) + ".jpg";

			    		                sTime = SimpleUtils.secondsToTime(sPos);

			    		                HashMap tmap = new HashMap();
			    		                tmap.put("file_id", file_id);
			    	    				tmap.put("file_no", file_no);
			    		                tmap.put("position", sPos);
			    		                tmap.put("time", sTime);
			    		                tmap.put("thumb_path", thumbPath + sImg);
			    		                tmap.put("thumb_nm", sImg);
			    		                if(i == (thumbCnt/2)){
			    		                	tmap.put("reprsnt_yn", "Y");
				    	    				map.put("sys_file_thumb_path", thumbPath + sImg);
			    		                }else{
			    		                	tmap.put("reprsnt_yn", "N");
			    		                }
			    		                thumbList.add(i, tmap);
			    		            }
	    		    	        }

	    		                /* 썸네일 추출
		    		            float sPoint = 1.0F / (float)thumbCnt;
		    		            double sPos = 0;
		    		            String sImg = "";
		    		            String sTime = "";

		    		            for(int i = 0; i < thumbCnt; i++) {
		    		                if(i == 0){
		    		                    sPos = 1;
		    		                }else{
		    		                	//재생시간을 섬네일 개수로 나눠서 추출시간 설정
		    		                    sPos = (float)duration * (sPoint * (float)i);
		    		                    //소수점 2자리에서 컷
		    		        			sPos = Double.parseDouble(String.format("%.2f",sPos));
		    		                }
		    		                sImg = "thumb" + sPos + ".jpg";

		    		                //썸네일 추출 - 쓰레드 시작
		    		            	ImageExtractThread thread = new ImageExtractThread(FFMPEG_EXE, convertFilePath, sPos, thumbPath + sImg);
				    				thread.start();
		    		                sTime = SimpleUtils.secondsToTime(sPos);

		    		                HashMap tmap = new HashMap();
		    		                tmap.put("file_id", file_id);
		    	    				tmap.put("file_no", file_no);
		    		                tmap.put("position", sPos);
		    		                tmap.put("time", sTime);
		    		                tmap.put("thumb_path", thumbPath + sImg);
		    		                tmap.put("thumb_nm", sImg);
		    		                if(i == (thumbCnt/2)){
		    		                	tmap.put("reprsnt_yn", "Y");
			    	    				map.put("sys_file_thumb_path", thumbPath + sImg);
		    		                }else{
		    		                	tmap.put("reprsnt_yn", "N");
		    		                }
		    		                thumbList.add(i, tmap);
		    		                //썸네일 추출 - 쓰레드 끝 

		    		            	//썸네일 추출 - 일반 시작
		    		    	        if(ffmpeg.imageExtract(convertFilePath, sPos, thumbPath + sImg, "mjpeg","")){
			    		                sTime = SimpleUtils.secondsToTime(sPos);

			    		                HashMap tmap = new HashMap();
			    		                tmap.put("file_id", file_id);
			    	    				tmap.put("file_no", file_no);
			    		                tmap.put("position", sPos);
			    		                tmap.put("time", sTime);
			    		                tmap.put("thumb_path", thumbPath + sImg);
			    		                tmap.put("thumb_nm", sImg);
			    		                if(i == (thumbCnt/2)){
			    		                	tmap.put("reprsnt_yn", "Y");
				    	    				map.put("sys_file_thumb_path", thumbPath + sImg);
			    		                }else{
			    		                	tmap.put("reprsnt_yn", "N");
			    		                }
			    		                thumbList.add(i, tmap);
		    		    	        }
		    		            	//썸네일 추출 - 일반 끝
		    		            }
		    		        	*/
		    		        }

		    		        map.put("thumbList", thumbList);
		    				videoService.fileUpload(map);		    				
		    			}else{
		    				//오류 - 변환실패
		    			}
	    			}
	    		}
	    	}

    	} catch(Exception e) {
    		e.printStackTrace();
    	}

    	response.sendRedirect("/cmm/fileList/");
    }

    @RequestMapping(value="/getThumbnail/")
    public ResponseEntity<byte[]> getThumbnail(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ResponseEntity entity = null;
        HttpHeaders responseHeaders = new HttpHeaders();
        entity = new ResponseEntity(HttpStatus.BAD_REQUEST);

        String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
        String file_no = SimpleUtils.default_set(request.getParameter("file_no"));
        String thumb_no = SimpleUtils.default_set(request.getParameter("thumb_no"));

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	map.put("file_no", file_no);
    	map.put("thumb_no", thumb_no);
    	
    	HashMap result = videoService.getThumbDetail(map);
    	
    	if(result != null){
	    	String realPath = (String) result.get("THUMB_PATH");
	    	String fileName = (String) result.get("THUMB_NM");

	        File getResource = new File(realPath);
	        if(!getResource.exists()){
		    	realPath = request.getSession().getServletContext().getRealPath("/") + "/images/no_img.gif";
		        getResource = new File(realPath);
	        }

	        FileInputStream fileStream = null;  
	
	        try {
	            getResource = new File(realPath);
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
    	}
        return entity;
    }

    @RequestMapping(value="/streamView/")
    public void streamView(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        //대상 동영상 파일명
        String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
        String file_no = SimpleUtils.default_set(request.getParameter("file_no"));
        
    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	map.put("file_no", file_no);
    	HashMap result = videoService.getFileDetail(map);

    	StreamView sv = new StreamView();
    	if(result != null){
	    	String realPath = (String) result.get("SYS_FILE_PATH");
	    	String fileName = (String) result.get("FILE_NM");

			System.out.println(">>>>>>>>>>>>>>>>> streamView");
			//스트리밍 시작
    		sv.makeStream(realPath, request, response);
    	}
    }
    
}
