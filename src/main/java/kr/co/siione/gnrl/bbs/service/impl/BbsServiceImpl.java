package kr.co.siione.gnrl.bbs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.bbs.service.BbsService;
import kr.co.siione.gnrl.cart.service.CartService;

@Service("BbsService")
public class BbsServiceImpl implements BbsService {

	@Resource(name = "bbsDAO")
	private BbsDAO bbsDAO;

    public void insertBbs(HashMap map) throws Exception {
    	bbsDAO.insertBbs(map);
    }
    
    public void deleteBbs(HashMap map) throws Exception {
    	bbsDAO.deleteBbs(map);
    }

    public void updateBbs(HashMap map) throws Exception {
    	bbsDAO.updateBbs(map);
    }
    
    public void updateBbsViewCnt(HashMap map) throws Exception {
    	bbsDAO.updateBbsViewCnt(map);
    }

    public HashMap viewBbs(HashMap map)throws Exception {
    	return bbsDAO.viewBbs(map);
    } 
    
    public int selectBbsListCount(HashMap map) throws Exception {
    	return bbsDAO.selectBbsListCount(map);
    }

    public List<HashMap> selectBbsList(HashMap map) throws Exception {
    	return bbsDAO.selectBbsList(map);
    }
}
