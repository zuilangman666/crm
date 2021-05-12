package com.geng.crm.settings.workbench.service;

import com.geng.crm.exceptions.SaveActivityExce;
import com.geng.crm.settings.workbench.domain.Activity;
import com.geng.crm.settings.workbench.domain.ActivityRemark;
import com.geng.crm.vo.PaginationVo;

import java.util.List;
import java.util.Map;

/*
* 一般情况下一个表对应着一个dao层的mapper映射文件，对应着一个dao层接口，
* 但是如果当多个dao层接口之间的联系比较紧密，也可以将他们写在一个service接口中。
* */
public interface ActivityService {
    void saveActivity(Activity activity) throws SaveActivityExce;

    PaginationVo<Activity> pageList(Map<String, Object> map);

    boolean deleteActivity(String[] params);

    Activity getActivity(String id);

    boolean updateActivity(Activity activity);

    Activity solveDetail(String id);

    List<ActivityRemark> getRemarkList(String aId);

    boolean deleteRemark(String id);

    boolean saveRemark(ActivityRemark activityRemark);

    boolean updateRemark(ActivityRemark activityRemark);
}
