package kr.co.siione.gnrl.bbs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;
import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class BbsDAO extends EgovComAbstractDAO {

    public void insertBbs(HashMap map) throws Exception {
		insert("gnrl.bbs.insertBbs", map);
    }

    public void updateBbsViewCnt(HashMap map) throws Exception {
		insert("gnrl.bbs.updateBbsViewCnt", map);
    }


    public void deleteBbs(HashMap map) throws Exception {
		insert("gnrl.bbs.deleteBbs", map);
    }

    public void updateBbs(HashMap map) throws Exception {
		insert("gnrl.bbs.updateBbs", map);
    }

    public HashMap viewBbs(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.bbs.viewBbs", map);
    }
    
    public int selectBbsListCount(HashMap map) throws Exception {
        return (Integer)selectByPk("gnrl.bbs.selectBbsListCount", map);
    }    

    public List<HashMap> selectBbsList(HashMap map) throws Exception {
        return (List<HashMap>)list("gnrl.bbs.selectBbsList", map);
    }

}
