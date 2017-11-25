package kr.co.siione.gnrl.purchs.service;

import java.util.HashMap;
import java.util.List;

public interface PointService {
	public int getTotalPoint(HashMap map) throws Exception;
	public int getPointListCount(HashMap map) throws Exception;
	public List<HashMap> getPointList(HashMap map) throws Exception;
}
