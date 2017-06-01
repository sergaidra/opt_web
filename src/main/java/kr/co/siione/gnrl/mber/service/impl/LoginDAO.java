package kr.co.siione.gnrl.mber.service.impl;

import java.util.HashMap;
import org.springframework.stereotype.Repository;
import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class LoginDAO extends EgovComAbstractDAO {
    public HashMap selectUserInfo(HashMap map) throws Exception {
        return (HashMap)selectByPk("uia.selectUserInfo", map);
    }
}
