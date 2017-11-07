package kr.co.siione.utl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class Test {

	public static void main(String[] args) {
		
		// mail test start
		System.out.println("Send test mail now : "+UserUtils.getDate("yyyy-MM-dd HH:mm:ss"));
		
		MailManager email = new MailManager();
		
		String subject = "[TEST] 에스투원에서 보내는 테스트 메일입니다.";
		String content = "<font color='red'>중요!!!!</font> 메일 내용 테스트<br>";
		String to = "ss9832@hanmail.net";
		
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		Map<String, String> file1 = new HashMap<String, String>();
		file1.put("imgPath", "C:\\tmpkh\\opt_img\\분류_리조트.jpg");
		list.add(file1);
		Map<String, String> file2 = new HashMap<String, String>();
		file2.put("imgPath", "C:\\tmpkh\\opt_img\\pr_img_01.jpg");
		list.add(file2);

		Map<String, Object> attachMap = new HashMap<String, Object>();
		attachMap.put("images", list);
		
		boolean re = email.sendMail(subject, content, to, attachMap);
		System.out.println("메일 발송 결과  : "+ re);
		// mail test end
		

		/*String str = EgovProperties.class.getResource("").getPath().substring(0, EgovProperties.class.getResource("").getPath().lastIndexOf("kr"));
		System.out.println(EgovProperties.class.getResource("").getPath());
		System.out.println(str);
		System.out.println(str+   "property" + "/" + "globals.properties");
		
		
		String b_time = "0700";
		String e_time = "1530";
		
		String b_hh = b_time.substring(0, 2);
		String b_mi = b_time.substring(2, 4);
		
		String e_hh = e_time.substring(0, 2);
		String e_mi = e_time.substring(2, 4);
		
		System.out.println("b_hh:"+b_hh);
		System.out.println("b_mi:"+b_mi);	
		
		
		System.out.println("e_hh:"+e_hh);
		System.out.println("e_mi:"+e_mi);	
		
		
		
		int i_b_hh = Integer.parseInt(b_hh);   Integer.parseInt(b_time.substring(0, 2));
		int i_b_mi = Integer.parseInt(b_mi);   Integer.parseInt(b_time.substring(2, 4));
		
		
		int i_e_hh = Integer.parseInt(e_hh);
		int i_e_mi = Integer.parseInt(e_mi);
		
		
		String w_time = "0130";
		String m_time = "0130";
		
		int i_w_hh = Integer.parseInt(w_time.substring(0, 2));
		int i_w_mi = Integer.parseInt(w_time.substring(2, 4));
		
		
		int i_m_hh = Integer.parseInt(m_time.substring(0, 2));
		int i_m_mi = Integer.parseInt(m_time.substring(2, 4));
		
		System.out.println("i_m_hh:"+i_m_hh);
		System.out.println("i_m_mi:"+i_m_mi);	
		
		double i_bb_hh = i_b_hh - i_w_hh;
		double i_bb_mi = (i_b_mi - i_w_mi) / 60.0;
		
		System.out.println("i_bb_hh:"+i_bb_hh);
		System.out.println("i_bb_mi:"+i_bb_mi);
		
		
		double i_ee_hh = i_e_hh + i_m_hh;
		double i_ee_mi = (i_e_mi + i_m_mi) / 60.0 ;

		
		System.out.println("i_ee_hh:"+i_ee_hh);
		System.out.println("i_ee_mi:"+i_ee_mi);
		
		double i_bb_time = i_bb_hh + i_bb_mi; 
		double i_ee_time = i_ee_hh + i_ee_mi; 
		
		
		

		System.out.println("i_bb_time:"+i_bb_time);
		System.out.println("i_ee_time:"+i_ee_time);
		
		
		
		String a = StringUtils.leftPad(String.valueOf((int)Math.floor(i_bb_time)), 2, "0");
		String b = StringUtils.leftPad(String.valueOf((int)((i_bb_time - Math.floor(i_bb_time)) * 60)), 2, "0"); 
		
		String c = StringUtils.leftPad(String.valueOf((int)Math.floor(i_ee_time)), 2, "0");
		String d = StringUtils.leftPad(String.valueOf((int)((i_ee_time - Math.floor(i_ee_time)) * 60)), 2, "0");
		
		
		System.out.println("a:"+a);
		System.out.println("b:"+b);
		System.out.println("c:"+c);
		System.out.println("d:"+d);
		
		
		double i_bb_time2 = (Integer.parseInt(b_time.substring(0, 2)) - Integer.parseInt(w_time.substring(0, 2))) + ((Integer.parseInt(b_time.substring(2, 4)) - Integer.parseInt(w_time.substring(2, 4))) / 60.0); 
		double i_ee_time2 = (Integer.parseInt(e_time.substring(0, 2)) + Integer.parseInt(m_time.substring(0, 2))) + ((Integer.parseInt(e_time.substring(2, 4)) + Integer.parseInt(m_time.substring(2, 4))) / 60.0); 
	
		
		String a1 = StringUtils.leftPad(String.valueOf((int)Math.floor(i_bb_time2)), 2, "0");
		String b1 = StringUtils.leftPad(String.valueOf((int)((i_bb_time2 - Math.floor(i_bb_time2)) * 60)), 2, "0"); 
		
		String c1 = StringUtils.leftPad(String.valueOf((int)Math.floor(i_ee_time2)), 2, "0");
		String d1 = StringUtils.leftPad(String.valueOf((int)((i_ee_time2 - Math.floor(i_ee_time2)) * 60)), 2, "0");
		
		
		System.out.println("i_bb_time2:"+i_bb_time2);
		System.out.println("i_ee_time2:"+i_ee_time2);
		System.out.println("a1:"+a1);
		System.out.println("b1:"+b1);
		System.out.println("c1:"+c1);
		System.out.println("d1:"+d1);*/
	}
}
