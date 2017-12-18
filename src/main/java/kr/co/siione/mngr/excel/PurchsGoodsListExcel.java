package kr.co.siione.mngr.excel;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.utl.UserUtils;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.springframework.web.servlet.view.document.AbstractExcelView;

public class PurchsGoodsListExcel extends AbstractExcelView {

	protected void buildExcelDocument(Map<String, Object> map, HSSFWorkbook wb, HttpServletRequest req, HttpServletResponse res) throws Exception {
		Map<String, String> param  = UserUtils.getRequestParameter(req);

		// 파일명 한글 처리
		UserUtils.setDisposition(UserUtils.nvl(param.get("PURCHS_SN")).replaceAll("-", "")+"_결제상품목록.xls", req, res);

		// font
		HSSFFont font = wb.createFont();
		font.setFontName("맑은 고딕");

		HSSFCell cell = null;
		HSSFSheet sheet = wb.createSheet("결제상품목록");
		cell = getCell(sheet, 0, 1);

		HSSFCellStyle title_cs = wb.createCellStyle();
		title_cs.setFont(font);
		cell.setCellStyle(title_cs);
		setText(cell, "결제상품목록");

		// 결제 및 여행사 정보
		setText(getCell(sheet, 2,  1), UserUtils.nvl(param.get("PURCHS_INFO")));
		
		// set header information
		setText(getCell(sheet, 3,  1), "상품");
		setText(getCell(sheet, 3,  2), "선택옵션");
		setText(getCell(sheet, 3,  3), "실결제금액");
		setText(getCell(sheet, 3,  4), "원결제금액");
		setText(getCell(sheet, 3,  5), "여행일자");
		setText(getCell(sheet, 3,  6), "시간");

		// set column width
		sheet.setColumnWidth( 0,  1000);
		sheet.setColumnWidth( 1, 10000);
		sheet.setColumnWidth( 2, 15000);
		sheet.setColumnWidth( 3,  4000);
		sheet.setColumnWidth( 4,  4000);
		sheet.setColumnWidth( 5,  8000);
		sheet.setColumnWidth( 6,  4000);

		// set header style
		HSSFCellStyle header_cs = wb.createCellStyle();
		header_cs.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		header_cs.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		header_cs.setBorderTop(HSSFCellStyle.BORDER_THIN);
		header_cs.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		header_cs.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		header_cs.setBorderRight(HSSFCellStyle.BORDER_THIN);
		header_cs.setTopBorderColor(HSSFColor.BLACK.index);
		header_cs.setBottomBorderColor(HSSFColor.BLACK.index);
		header_cs.setLeftBorderColor(HSSFColor.BLACK.index);
		header_cs.setRightBorderColor(HSSFColor.BLACK.index);
		header_cs.setFont(font);

		getCell(sheet, 3,  1).setCellStyle(header_cs);
		getCell(sheet, 3,  2).setCellStyle(header_cs);
		getCell(sheet, 3,  3).setCellStyle(header_cs);
		getCell(sheet, 3,  4).setCellStyle(header_cs);
		getCell(sheet, 3,  5).setCellStyle(header_cs);
		getCell(sheet, 3,  6).setCellStyle(header_cs);

		@SuppressWarnings("unchecked")
		List<Map<String, Object>> list = (List<Map<String, Object>>) ((Map<String, Object>) map.get("modelMap")).get("CHILD");

		if(list == null) return;

		// set header style
		HSSFCellStyle left_cs = wb.createCellStyle();
		left_cs.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		left_cs.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		left_cs.setBorderTop(HSSFCellStyle.BORDER_THIN);
		left_cs.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		left_cs.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		left_cs.setBorderRight(HSSFCellStyle.BORDER_THIN);
		left_cs.setTopBorderColor(HSSFColor.BLACK.index);
		left_cs.setBottomBorderColor(HSSFColor.BLACK.index);
		left_cs.setLeftBorderColor(HSSFColor.BLACK.index);
		left_cs.setRightBorderColor(HSSFColor.BLACK.index);
		left_cs.setWrapText(true);
		left_cs.setFont(font);

		// set 숫자 style
		HSSFDataFormat format = wb.createDataFormat();
		HSSFCellStyle number_cs = wb.createCellStyle();
		number_cs.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
		number_cs.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		number_cs.setBorderTop(HSSFCellStyle.BORDER_THIN);
		number_cs.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		number_cs.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		number_cs.setBorderRight(HSSFCellStyle.BORDER_THIN);
		number_cs.setTopBorderColor(HSSFColor.BLACK.index);
		number_cs.setBottomBorderColor(HSSFColor.BLACK.index);
		number_cs.setLeftBorderColor(HSSFColor.BLACK.index);
		number_cs.setRightBorderColor(HSSFColor.BLACK.index);
		number_cs.setDataFormat(format.getFormat("#,##0"));
		number_cs.setFont(font);
		
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> item = list.get(i);

			getCell(sheet, 4 + i,  1).setCellStyle(left_cs);
			getCell(sheet, 4 + i,  2).setCellStyle(left_cs);
			getCell(sheet, 4 + i,  3).setCellStyle(number_cs);
			getCell(sheet, 4 + i,  4).setCellStyle(number_cs);
			getCell(sheet, 4 + i,  5).setCellStyle(header_cs);
			getCell(sheet, 4 + i,  6).setCellStyle(header_cs);
			
			getCell(sheet, 4 + i,  1).setCellValue(UserUtils.nvl(item.get("GOODS_NM")));
			
			String sGoods = "";
			String sDate = "";
			String sTime = "";
			List cartList = (List)item.get("CART_LIST");
			for(int j = 0; j < cartList.size(); j++) {
				//Map<String, Object> info = ArrayUtils.toMap(cartList.get(i));
				System.out.println(j+") "+cartList.get(j));
				Map<String, Object> sub = new HashMap<String, Object>();
				sub = (Map<String, Object>)cartList.get(j);
				sGoods += UserUtils.nvl(sub.get("SETUP_SE_NM")) + ": ";
				sGoods += UserUtils.nvl(sub.get("NMPR_CND"));
				if(!UserUtils.nvl(sub.get("SETUP_SE")).equals("C")) {
					sGoods += " " + UserUtils.nvl(sub.get("NMPR_CO"));
					sGoods += UserUtils.nvl(sub.get("CO_UNIT_SE_NM"));
				}
				sGoods += " (" + String.format("%,d", Integer.parseInt(UserUtils.nvl(sub.get("AMOUNT")))) + "원)";
				if(j < cartList.size()-1) sGoods += "\n";
			}
			
			if(!UserUtils.nvl(item.get("TOUR_DE")).equals("")) {
				sDate = UserUtils.convertDate(UserUtils.nvl(item.get("TOUR_DE")));
			} else {
				sDate = UserUtils.convertDate(UserUtils.nvl(item.get("CHKIN_DE"))) + "~" + UserUtils.convertDate(UserUtils.nvl(item.get("CHCKT_DE")));
			}
			
			if(!UserUtils.nvl(item.get("BEGIN_TIME")).equals("")) {
				sTime = UserUtils.convertTime(UserUtils.nvl(item.get("BEGIN_TIME"))) + "~" + UserUtils.convertTime(UserUtils.nvl(item.get("END_TIME")));
			}
			System.out.println("sGoods: "+sGoods);
			System.out.println("sDate: "+sDate);
			System.out.println("sTime: "+sTime);
			
			getCell(sheet, 4 + i,  2).setCellValue(sGoods);
			getCell(sheet, 4 + i,  3).setCellValue(Long.parseLong(UserUtils.nvl(item.get("PURCHS_AMOUNT"), "0")));
			getCell(sheet, 4 + i,  4).setCellValue(Long.parseLong(UserUtils.nvl(item.get("ORIGIN_AMOUNT"), "0")));
			getCell(sheet, 4 + i,  5).setCellValue(sDate);
			getCell(sheet, 4 + i,  6).setCellValue(sTime);

		}
	}

}
