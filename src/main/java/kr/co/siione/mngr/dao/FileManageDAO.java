package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("FileManageDAO")
public class FileManageDAO extends EgovComAbstractDAO {
	
	public Object insertFileManage(Map<String, String> map) throws Exception {
		return insert("FileManageDAO.insertFileManage", map);
	}

	public int deleteFileManage(Map<String, String> map) throws Exception {
		return delete("FileManageDAO.deleteFileManage", map);
	}
	
	public Object insertFileDetail(Map<String, String> map) throws Exception {
		return insert("FileManageDAO.insertFileDetail", map);
	}
	
	public int updateFileDetail(Map<String, String> map) throws Exception {
		return update("FileManageDAO.updateFileDetail", map);
	}
	
	public int deleteFileDetail(Map<String, String> map) throws Exception {
		return delete("FileManageDAO.deleteFileDetail", map);
	}
	
	public int deleteFileDetailInfos(Map<String, String> map) throws Exception {
		return delete("FileManageDAO.deleteFileDetailInfos", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectFileDetailByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("FileManageDAO.selectFileDetailByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectFileDetailList(Map<String, String> param) throws Exception {
		return list("FileManageDAO.selectFileDetailList", param);
	}
	
    public int selectFileReprsntCnt(Map<String, String> param) throws Exception{
        return (Integer)selectByPk("FileManageDAO.selectFileReprsntCnt", param);
    }	
    
	public Object copyFileDetail(Map<String, String> map) throws Exception {
		return insert("FileManageDAO.copyFileDetail", map);
	}    
}
