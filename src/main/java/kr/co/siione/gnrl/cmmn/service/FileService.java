package kr.co.siione.gnrl.cmmn.service;

import java.util.HashMap;
import java.util.List;

public interface FileService {
    public List<HashMap> getFileList(HashMap hashmap) throws Exception;
    public HashMap getFileDetail(HashMap hashmap) throws Exception;
}
