package kr.co.siione.gnrl.main.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.gnrl.main.service.MainService;

@Service("MainService")
public class MainServiceImpl implements MainService {

	@Resource(name = "mainDAO")
	private MainDAO mainDAO;

    public List<HashMap> getMainImageList() throws Exception {
        return mainDAO.selectMainImageList();
    }

    public List getMySchedule(HashMap map) throws Exception {
    	return mainDAO.getMySchedule(map);
    }
    
    public List getBanner(HashMap map) throws Exception {
    	return mainDAO.getBanner(map);
    }
}
