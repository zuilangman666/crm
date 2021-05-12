package com.geng.crm.settings.workbench.dao;


import com.geng.crm.settings.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int saveClue(Clue clue);
// 这个函数最好使用integer作为返回值，要不当数据表中没有数据的时候就会返回null，产生错误
    int getTotalByCondition(Map<String, Object> map);

    List<Clue> getListByCondition(Map<String, Object> map);

    Clue getClue(String id);

    int updateClue(Clue clue);

    int deleteClue(String[] id);

    Clue getClueSuper(String id);

    String getID(String id);

    int deleteClueS(String clueId);
}
