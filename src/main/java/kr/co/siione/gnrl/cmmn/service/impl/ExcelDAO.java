package kr.co.siione.gnrl.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class ExcelDAO extends EgovComAbstractDAO {

    public List selectExcelContents(HashMap map) throws Exception {
        return list("cmm.selectExcelContents", map);
    }
}
