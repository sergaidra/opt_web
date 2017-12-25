package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;
import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class LiveViewDAO extends EgovComAbstractDAO {

    public List<HashMap> mainVideolist(HashMap map) throws Exception {
        return (List<HashMap>)list("gnrl.liveview.mainVideolist", map);
    }
    
    public List<HashMap> videolist(HashMap map) throws Exception {
        return (List<HashMap>)list("gnrl.liveview.videolist", map);
    }
    
    
}
