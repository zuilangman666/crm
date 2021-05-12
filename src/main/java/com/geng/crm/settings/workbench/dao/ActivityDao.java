package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int saveActivity(Activity activity);

    int getActivityListNum(Map<String, Object> map);

    int deleteCount(String[] params);

    Activity getActivity(String id);

    int updateActivity(Activity activity);

    Activity solveDetail(String id);

    List<Activity> getActivityList(String name);
}
