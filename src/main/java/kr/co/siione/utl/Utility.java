package kr.co.siione.utl;

import java.io.*;
import java.util.*;
import org.springframework.web.multipart.MultipartFile;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class Utility {

	private static Utility instance;

	static {
		instance = new Utility();
	}

	private Utility() {
	}

	public static Utility getInstance() {
		return instance;
	}

    public long saveFile(MultipartFile file, String filePath) throws Exception {
    	File f = new File(filePath);
		
		if(!f.getParentFile().exists()) 					
			f.getParentFile().mkdirs();
		
		OutputStream os = null;
		InputStream is = null;
		final int BUFFER_SIZE = 8192;
		long size = 0;
		
		try {
			os = new FileOutputStream(f);
			
			int bytesRead = 0;
			byte[] buffer = new byte[BUFFER_SIZE];
			is = file.getInputStream();
			
			while ((bytesRead = is.read(buffer, 0, BUFFER_SIZE)) != -1) {
				size += bytesRead;
				os.write(buffer, 0, bytesRead);
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (is != null) 
				is.close();
			if (os != null) 
				os.close();
		}
		return size;
    }

}
