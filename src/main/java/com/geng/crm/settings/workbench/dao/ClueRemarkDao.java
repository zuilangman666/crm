package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    int deleteRemark(String[] id);

    List<ClueRemark> getRemarkList(String id);

    int saveRemark(ClueRemark clueRemark);

    int updateRemark(ClueRemark clueRemark);
    int deleteRemarkSuper(String id);

    int deleteRemarkS(String clueId);
}
