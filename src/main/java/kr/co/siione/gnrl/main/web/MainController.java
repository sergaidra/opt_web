package kr.co.siione.gnrl.main.web;

import javax.servlet.http.*;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "/main/")
public class MainController {
    
    @RequestMapping(value="/intro/")
    public String intro(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        return "gnrl/main/intro";
    }
 
    @RequestMapping(value="/indexAction/")
    public String frameReset(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        return "gnrl/main/index";
    }
}
