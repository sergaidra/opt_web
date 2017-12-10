package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;
import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class FaqDAO extends EgovComAbstractDAO {

    public void insertBbs(HashMap map) throws Exception {
		insert("gnrl.faq.insertBbs", map);
    }

    public void deleteBbs(HashMap map) throws Exception {
		update("gnrl.faq.deleteBbs", map);
    }

    public void updateBbs(HashMap map) throws Exception {
    	update("gnrl.faq.updateBbs", map);
    }

    public HashMap viewBbs(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.faq.viewBbs", map);
    }
    
    public List<HashMap> selectBbsList(HashMap map) throws Exception {
        return (List<HashMap>)list("gnrl.faq.selectBbsList", map);
    }


}
