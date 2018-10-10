package kr.co.siione.gnrl.bbs.service;

import java.util.HashMap;
import java.util.List;

public interface BbsService {
    public void insertBbs(HashMap map) throws Exception;    
    public void deleteBbs(HashMap map) throws Exception;
    public void deleteAdminBbs(HashMap map) throws Exception;
    public void updateBbs(HashMap map) throws Exception;
    public void updateBbsViewCnt(HashMap map) throws Exception;
    public HashMap viewBbs(HashMap map)throws Exception;
    public int selectBbsListCount(HashMap map) throws Exception;
    public List<HashMap> selectBbsList(HashMap map) throws Exception;
    public List<HashMap> selectChildBbsList(HashMap map) throws Exception;
    
    public void insertComment(HashMap map) throws Exception;    
    public void deleteComment(HashMap map) throws Exception;
    public void updateComment(HashMap map) throws Exception;
    public List<HashMap> selectCommentList(HashMap map) throws Exception;

}
