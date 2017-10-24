package kr.co.siione.gnrl.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class FileDAO extends EgovComAbstractDAO {

	public List selectFileList(HashMap map) throws Exception {
		return list("gnrl.file.selectFileList", map);
	}

    public HashMap selectFileDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.file.selectFileDetail", map);
    }

    public HashMap selectMainImage(HashMap map) throws Exception {
        return (HashMap)selectByPk("MainImageDAO.selectMainImage", map);
    }
}
