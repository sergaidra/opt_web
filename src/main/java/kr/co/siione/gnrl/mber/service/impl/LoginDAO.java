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
	
	public void insertConnectLog(HashMap map) throws Exception {
		insert("gnrl.mber.insertConnectLog", map);
	}	

	public int chkUserInfo(HashMap map) throws Exception {
		return (Integer) selectByPk("gnrl.mber.chkUserInfo", map);
	}
	
	public String getMaxEsntlId(HashMap map)throws Exception {
		return (String) selectByPk("gnrl.mber.getMaxEsntlId", map);
	} 

	public void insertUser(HashMap map) throws Exception {
		insert("gnrl.mber.insertUser", map);
	}

	public int chkUserCert(HashMap map) throws Exception {
		return (Integer) selectByPk("gnrl.mber.chkUserCert", map);
	}

	public void updateUserCert(HashMap map) throws Exception {
		insert("gnrl.mber.updateUserCert", map);
	}

	public String selectEsntlID(HashMap map) throws Exception {
		return (String) selectByPk("gnrl.mber.selectEsntlID", map);
	}


    public List<HashMap> chkUserInfoPw(HashMap map) throws Exception {
        return (List<HashMap>)list("gnrl.mber.chkUserInfoPw", map);
    }

	public void updateCertKey(HashMap map) throws Exception {
		insert("gnrl.mber.updateCertKey", map);
	}

	public void updatePassword(HashMap map) throws Exception {
		insert("gnrl.mber.updatePassword", map);
	}

}
