package kr.co.siione.utl.egov;

public class Test {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

		String str = EgovProperties.class.getResource("").getPath().substring(0, EgovProperties.class.getResource("").getPath().lastIndexOf("kr"));
		System.out.println(EgovProperties.class.getResource("").getPath());
		System.out.println(str);
		System.out.println(str+   "property" + "/" + "globals.properties");
		
	}

}
