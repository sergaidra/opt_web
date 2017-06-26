package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.service.MngrManageService;

import org.springframework.stereotype.Service;

@Service("MngrManageService")
public class MngrManageServiceImpl implements MngrManageService {

	@Resource(name = "MngrDAO")
	private MngrDAO mngrDAO;

	@Override
	public void insertMngr(Map<String, String> param) throws Exception {
		mngrDAO.insertMngr(param);
	}

	@Override
	public int updateMngr(Map<String, String> param) throws Exception {
		return mngrDAO.updateMngr(param);
	}

	@Override
	public int deleteMngr(Map<String, String> param) throws Exception {
		return mngrDAO.deleteMngr(param);
	}

	@Override
	public int confrmMngr(Map<String, String> param) throws Exception {
		return mngrDAO.confrmMngr(param);
	}
	
	@Override
	public Map<String, String> selectMngrByPk(Map<String, String> param) throws Exception {
		return mngrDAO.selectMngrByPk(param);
	}
	
	@Override
	public List<Map<String, String>> selectMngrList(Map<String, String> param) throws Exception {
		return mngrDAO.selectMngrList(param);
	}

	@Override
	public String selectMngrIdForDup(Map<String, String> param) throws Exception {
		return mngrDAO.selectMngrIdForDup(param);
	}
}
