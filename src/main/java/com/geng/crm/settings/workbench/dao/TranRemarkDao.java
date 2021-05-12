package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkDao {
    List<TranRemark> getRemark(String tranId);

    int saveRemark(TranRemark tranRemark);

    int deleteRemark(String id);

    int updateRemark(TranRemark tranRemark);
}
