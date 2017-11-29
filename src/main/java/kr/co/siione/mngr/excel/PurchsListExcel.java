package kr.co.siione.mngr.excel;

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


public class PurchsListExcel extends AbstractExcelView {

	protected void buildExcelDocument(Map<String, Object> map, HSSFWorkbook wb, HttpServletRequest req, HttpServletResponse res) throws Exception {
		Map<String, String> param  = UserUtils.getRequestParameter(req);

		// 파일명 한글 처리
		UserUtils.setDisposition(UserUtils.nvl(param.get("FR_PURCHS_DE")).replaceAll("-", "")+"_결제목록.xls", req, res);

		// font
		HSSFFont font = wb.createFont();
		font.setFontName("맑은 고딕");

		HSSFCell cell = null;
		HSSFSheet sheet = wb.createSheet("결제목록");
		cell = getCell(sheet, 0, 1);

		HSSFCellStyle title_cs = wb.createCellStyle();
		title_cs.setFont(font);
		cell.setCellStyle(title_cs);
		setText(cell, "결제목록");

		// set header information
		setText(getCell(sheet, 2,  1), "결제번호");
		setText(getCell(sheet, 2,  2), "구매일자");
		setText(getCell(sheet, 2,  3), "구매시각");
		setText(getCell(sheet, 2,  4), "구매자");
		setText(getCell(sheet, 2,  5), "결제금액");
		setText(getCell(sheet, 2,  6), "실결제금액");
		setText(getCell(sheet, 2,  7), "사용포인트");
		setText(getCell(sheet, 2,  8), "결제수단");
		setText(getCell(sheet, 2,  9), "여행자");
		setText(getCell(sheet, 2, 10), "여행자연락처");
		setText(getCell(sheet, 2, 11), "취소여부");
		setText(getCell(sheet, 2, 12), "취소일시");
		setText(getCell(sheet, 2, 13), "구매상품");

		// set column width
		sheet.setColumnWidth( 0,  1000);
		sheet.setColumnWidth( 1,  4000);
		sheet.setColumnWidth( 2,  4000);
		sheet.setColumnWidth( 3,  4000);
		sheet.setColumnWidth( 4,  4000);
		sheet.setColumnWidth( 5,  4000);
		sheet.setColumnWidth( 6,  4000);
		sheet.setColumnWidth( 7,  4000);
		sheet.setColumnWidth( 8,  4000);
		sheet.setColumnWidth( 9,  4000);
		sheet.setColumnWidth(10,  4000);
		sheet.setColumnWidth(11,  4000);
		sheet.setColumnWidth(12,  6000);
		sheet.setColumnWidth(13, 10000);

		// set header style
		HSSFCellStyle header_cs = wb.createCellStyle();
		header_cs.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		header_cs.setBorderTop(HSSFCellStyle.BORDER_THIN);
		header_cs.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		header_cs.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		header_cs.setBorderRight(HSSFCellStyle.BORDER_THIN);
		header_cs.setTopBorderColor(HSSFColor.BLACK.index);
		header_cs.setBottomBorderColor(HSSFColor.BLACK.index);
		header_cs.setLeftBorderColor(HSSFColor.BLACK.index);
		header_cs.setRightBorderColor(HSSFColor.BLACK.index);
		header_cs.setFont(font);

		getCell(sheet, 2,  1).setCellStyle(header_cs);
		getCell(sheet, 2,  2).setCellStyle(header_cs);
		getCell(sheet, 2,  3).setCellStyle(header_cs);
		getCell(sheet, 2,  4).setCellStyle(header_cs);
		getCell(sheet, 2,  5).setCellStyle(header_cs);
		getCell(sheet, 2,  6).setCellStyle(header_cs);
		getCell(sheet, 2,  7).setCellStyle(header_cs);
		getCell(sheet, 2,  8).setCellStyle(header_cs);
		getCell(sheet, 2,  9).setCellStyle(header_cs);
		getCell(sheet, 2, 10).setCellStyle(header_cs);
		getCell(sheet, 2, 11).setCellStyle(header_cs);
		getCell(sheet, 2, 12).setCellStyle(header_cs);
		getCell(sheet, 2, 13).setCellStyle(header_cs);

		@SuppressWarnings("unchecked")
		List<Map<String, Object>> list = (List<Map<String, Object>>) ((Map<String, Object>) map.get("modelMap")).get("CHILD");

		if(list == null) return;

		// set header style
		HSSFCellStyle left_cs = wb.createCellStyle();
		left_cs.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		left_cs.setBorderTop(HSSFCellStyle.BORDER_THIN);
		left_cs.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		left_cs.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		left_cs.setBorderRight(HSSFCellStyle.BORDER_THIN);
		left_cs.setTopBorderColor(HSSFColor.BLACK.index);
		left_cs.setBottomBorderColor(HSSFColor.BLACK.index);
		left_cs.setLeftBorderColor(HSSFColor.BLACK.index);
		left_cs.setRightBorderColor(HSSFColor.BLACK.index);
		left_cs.setFont(font);

		// set 숫자 style
		HSSFDataFormat format = wb.createDataFormat();
		HSSFCellStyle number_cs = wb.createCellStyle();
		number_cs.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
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

			getCell(sheet, 3 + i,  1).setCellStyle(header_cs);
			getCell(sheet, 3 + i,  2).setCellStyle(header_cs);
			getCell(sheet, 3 + i,  3).setCellStyle(header_cs);
			getCell(sheet, 3 + i,  4).setCellStyle(header_cs);
			getCell(sheet, 3 + i,  5).setCellStyle(number_cs);
			getCell(sheet, 3 + i,  6).setCellStyle(number_cs);
			getCell(sheet, 3 + i,  7).setCellStyle(number_cs);
			getCell(sheet, 3 + i,  8).setCellStyle(header_cs);
			getCell(sheet, 3 + i,  9).setCellStyle(header_cs);
			getCell(sheet, 3 + i, 10).setCellStyle(header_cs);
			getCell(sheet, 3 + i, 11).setCellStyle(header_cs);
			getCell(sheet, 3 + i, 12).setCellStyle(header_cs);
			getCell(sheet, 3 + i, 13).setCellStyle(left_cs);

			getCell(sheet, 3 + i,  1).setCellValue(UserUtils.nvl(item.get("PURCHS_SN")));
			getCell(sheet, 3 + i,  2).setCellValue(UserUtils.nvl(item.get("PURCHS_DE")));
			getCell(sheet, 3 + i,  3).setCellValue(UserUtils.nvl(item.get("PURCHS_TM")));
			getCell(sheet, 3 + i,  4).setCellValue(UserUtils.nvl(item.get("USER_NM")));
			getCell(sheet, 3 + i,  5).setCellValue(Long.parseLong(UserUtils.nvl(item.get("TOT_SETLE_AMOUNT"), "0")));
			getCell(sheet, 3 + i,  6).setCellValue(Long.parseLong(UserUtils.nvl(item.get("REAL_SETLE_AMOUNT"), "0")));
			getCell(sheet, 3 + i,  7).setCellValue(Long.parseLong(UserUtils.nvl(item.get("USE_POINT"), "0")));
			getCell(sheet, 3 + i,  8).setCellValue(UserUtils.nvl(item.get("PYMNT_SE_NM")));
			getCell(sheet, 3 + i,  9).setCellValue(UserUtils.nvl(item.get("TOURIST_NM")));
			getCell(sheet, 3 + i, 10).setCellValue(UserUtils.nvl(item.get("TOURIST_CTTPC")));
			getCell(sheet, 3 + i, 11).setCellValue(UserUtils.nvl(item.get("DELETE_AT_NM")));
			getCell(sheet, 3 + i, 12).setCellValue(UserUtils.nvl(item.get("DELETE_DT")));

			if(!UserUtils.nvl(item.get("GOODS_CNT")).equals("0")) {
				getCell(sheet, 3 + i, 13).setCellValue(UserUtils.nvl(item.get("GOODS_NM"))+" 외 "+UserUtils.nvl(item.get("GOODS_CNT")) + "건");
			} else {
				getCell(sheet, 3 + i, 13).setCellValue(UserUtils.nvl(item.get("GOODS_NM")));
			}
		}
	}

}
