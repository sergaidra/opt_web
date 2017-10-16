package kr.co.siione.gnrl.purchs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.purchs.service.PurchsService;

@Service("PurchsService")
public class PurchsServiceImpl implements PurchsService {

	@Resource(name = "purchsDAO")
	private PurchsDAO purchsDAO;

   
}
