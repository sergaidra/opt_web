package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("AuthorMenuDAO")
public class AuthorMenuDAO extends EgovComAbstractDAO {
	
	public Object insertAuthorMenu(Map<String, String> map) throws Exception {
		return insert("AuthorMenuDAO.insertAuthorMenu", map);
	}
	
	public int deleteAuthorMenu(Map<String, String> map) throws Exception {
		return delete("AuthorMenuDAO.deleteAuthorMenu", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectAuthorMenuByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("AuthorMenuDAO.selectAuthorMenuByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectAuthorMenuList(Map<String, String> param) throws Exception {
		return list("AuthorMenuDAO.selectAuthorMenuList", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectAuthorMenuTree(Map<String, String> param) throws Exception {
		return list("AuthorMenuDAO.selectAuthorMenuTree", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectMainMenuTree(Map<String, String> param) throws Exception {
		return list("AuthorMenuDAO.selectMainMenuTree", param);
	}
}
