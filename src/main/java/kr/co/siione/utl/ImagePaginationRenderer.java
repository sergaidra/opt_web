package kr.co.siione.utl;

import javax.servlet.ServletContext;

import org.springframework.web.context.ServletContextAware;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;
/**
 * ImagePaginationRenderer.java 클래스
 * 
 * @author 서준식
 * @since 2011. 9. 16.
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    -------------    ----------------------
 *   2011. 9. 16.   서준식       이미지 경로에 ContextPath추가
 * </pre>
 */
public class ImagePaginationRenderer extends AbstractPaginationRenderer implements ServletContextAware{

	private ServletContext servletContext;
	
	public ImagePaginationRenderer() {
	
	}
	
	public void initVariables(){
		firstPageLabel    = "<a href=\"#\" onclick=\"{0}({1});return false; \" title=\"처음\" tabindex=\"79\">처음</p></a>&#160;";
        previousPageLabel = "<a href=\"#\" onclick=\"{0}({1});return false; \" title=\"이전\" tabindex=\"79\">이전</a>&#160;";
        currentPageLabel  = "<a class=\"on\" title=\"{0}\" tabindex=\"-1\">{0}</a>&#160;";
        otherPageLabel    = "<a href=\"#\" onclick=\"{0}({1});return false;\" title=\"{2}\" tabindex=\"79\">{2}</a>&#160;";
        nextPageLabel     = "&#160;<a href=\"#\" onclick=\"{0}({1});return false; \" title=\"다음\" tabindex=\"79\">다음</a>&#160;";
        lastPageLabel     = "<a href=\"#\" onclick=\"{0}({1});return false; \" title=\"마지막\" tabindex=\"79\">마지막</a>&#160;";
	}

	

	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
		initVariables();
	}

}