package kr.co.siione.gnrl.cmmn.service;

import java.util.HashMap;
import java.util.List;

public interface FileService {
    public List<HashMap> getFileList(HashMap map) throws Exception;
    public HashMap getFileDetail(HashMap map) throws Exception;
    public HashMap getMainImage(HashMap map) throws Exception;
}
