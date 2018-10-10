package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;
import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class CheckListDAO extends EgovComAbstractDAO {

	public List<HashMap> getChecklist(HashMap map) throws Exception {
		return list("gnrl.checklist.getChecklist", map);
	}

    public void delChecklist(HashMap map) throws Exception {
		insert("gnrl.checklist.delChecklist", map);
    }

    public void insChecklist(HashMap map) throws Exception {
		insert("gnrl.checklist.insChecklist", map);
    }
	
}
