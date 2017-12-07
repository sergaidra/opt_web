package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.bbs.service.BbsService;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cs.service.FaqService;
import kr.co.siione.gnrl.cs.service.LiveViewService;

@Service("FaqService")
public class FaqServiceImpl implements FaqService {

	@Resource(name = "faqDAO")
	private FaqDAO faqDAO;

}
