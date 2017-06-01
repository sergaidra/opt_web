package kr.co.siione.gnrl.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class VideoDAO extends EgovComAbstractDAO {

	public String selectFileID() throws Exception {
		return (String) selectByPk("cmm.selectFileID", "");
	}
	
	public String selectFileNo(HashMap map) throws Exception {
		return (String) selectByPk("cmm.selectFileNo", map);
	}

	public void insertFile(HashMap map) throws Exception {
		insert("cmm.insertFile", map);
	}

	public void insertThumb(HashMap map) throws Exception {
		insert("cmm.insertThumb", map);
	}

	public List selectFileList(HashMap map) throws Exception {
		return list("cmm.selectFileList", map);
	}

	public List selectThumbList(HashMap map) throws Exception {
		return list("cmm.selectThumbList", map);
	}
	
	public HashMap selectFileDetail(HashMap map) throws Exception {
		return (HashMap) selectByPk("cmm.selectFileDetail", map);
	}

	public HashMap selectThumbDetail(HashMap map) throws Exception {
		return (HashMap) selectByPk("cmm.selectThumbDetail", map);
	}
	
	public void updateThumb(HashMap map) throws Exception {
		update("cmm.updateThumb", map);
	}

	public void deleteThumb(HashMap map) throws Exception {
		delete("cmm.deleteThumb", map);
	}

}
