package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    int getDeleteCount(String[] params);

    int deleteCount(String[] params);

    List<ActivityRemark> getRemarkList(String aId);

    int deleteRemark(String id);

    int saveRemark(ActivityRemark activityRemark);

    int updateRemark(ActivityRemark activityRemark);
}
