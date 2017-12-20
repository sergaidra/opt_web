package kr.co.siione.gnrl.purchs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.purchs.service.CancelService;

@Service("CancelService")
public class CancelServiceImpl implements CancelService {

	@Resource(name = "cancelDAO")
	private CancelDAO cancelDAO;
	
	public int getCancelListCount(HashMap map) throws Exception {
		return cancelDAO.getCancelListCount(map);
	}
		
    public List<HashMap> getCancelList(HashMap map) throws Exception {
        return cancelDAO.getCancelList(map);
    }
    
    public List<HashMap> getPurchsCartList(HashMap map) throws Exception {
        return cancelDAO.getPurchsCartList(map);
    }
}
