package kr.co.siione.gnrl.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class CommonDAO extends EgovComAbstractDAO {

	public List<HashMap> getManagerUser(HashMap map) throws Exception {
        return (List<HashMap>)list("gnrl.cmmn.getManagerUser", map);
    }

}
