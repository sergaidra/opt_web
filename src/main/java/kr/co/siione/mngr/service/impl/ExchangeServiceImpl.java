package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.ExchangeDAO;
import kr.co.siione.mngr.service.ExchangeService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("ExchangeService")
public class ExchangeServiceImpl implements ExchangeService {

	private static final Logger LOG = LoggerFactory.getLogger(CmmnCodeManageServiceImpl.class);
	
	@Resource(name = "ExchangeDAO")
	private ExchangeDAO exchangeDAO;
	
	@Override
	public void insertExchange(Map<String, String> param) throws Exception {
		exchangeDAO.insertExchange(param);
	}

	public List<Map<String, Object>> selectExchangeList(Map<String, String> param) throws Exception {
		return exchangeDAO.selectExchangeList(param);
	}
	
	public int selectExchangeListCount(Map<String, String> param) throws Exception {
		return exchangeDAO.selectExchangeListCount(param);
	}

}
