package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;
import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class NoticeDAO extends EgovComAbstractDAO {

    public void insertBbs(HashMap map) throws Exception {
		insert("gnrl.notice.insertBbs", map);
    }

    public void deleteBbs(HashMap map) throws Exception {
		update("gnrl.notice.deleteBbs", map);
    }

    public void updateBbs(HashMap map) throws Exception {
    	update("gnrl.notice.updateBbs", map);
    }

    public HashMap viewBbs(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.notice.viewBbs", map);
    }


}
