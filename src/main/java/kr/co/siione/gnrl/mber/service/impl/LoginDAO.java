package kr.co.siione.gnrl.mber.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;
import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class LoginDAO extends EgovComAbstractDAO {
    public HashMap selectUserInfo(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.mber.selectUserInfo", map);
    }

	public void insertUserLog(HashMap map) throws Exception {
		insert("gnrl.mber.insertUserLog", map);
	}

	public String selectEsntlID(HashMap map) throws Exception {
		return (String) selectByPk("gnrl.mber.selectEsntlID", map);
	}

	public void insertUser(HashMap map) throws Exception {
		insert("gnrl.mber.insertUser", map);
	}

}
