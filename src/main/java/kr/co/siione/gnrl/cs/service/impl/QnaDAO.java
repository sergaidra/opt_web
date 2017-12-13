package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;
import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class QnaDAO extends EgovComAbstractDAO {
	public int getOpinionListCount(HashMap map) throws Exception {
		return (Integer)selectByPk("gnrl.opinion.getOpinionListCount", map);
	}

	public List<HashMap> getOpinionList(HashMap map) throws Exception {
		return list("gnrl.opinion.getOpinionList", map);
	}

	public List<HashMap> getOpinionAnswerList(HashMap map) throws Exception {
		return list("gnrl.opinion.getOpinionAnswerList", map);
	}

	public void insertOpinion(HashMap map) throws Exception {
		insert("gnrl.opinion.insertOpinion", map);
    }

    public void updateOpinion(HashMap map) throws Exception {
		insert("gnrl.opinion.updateOpinion", map);
    }

    public HashMap viewOpinion(HashMap map) throws Exception {
		return (HashMap)selectByPk("gnrl.opinion.viewOpinion", map);
	}
    
    public void deleteOpinion(HashMap map) throws Exception {
		insert("gnrl.opinion.deleteOpinion", map);
    }
}
