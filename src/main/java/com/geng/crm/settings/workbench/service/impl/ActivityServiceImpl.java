package com.geng.crm.settings.workbench.service.impl;

import com.geng.crm.exceptions.SaveActivityExce;
import com.geng.crm.settings.workbench.dao.ActivityDao;
import com.geng.crm.settings.workbench.dao.ActivityRemarkDao;
import com.geng.crm.settings.workbench.domain.Activity;
import com.geng.crm.settings.workbench.domain.ActivityRemark;
import com.geng.crm.settings.workbench.service.ActivityService;
import com.geng.crm.utils.SqlSessionUtil;
import com.geng.crm.vo.PaginationVo;

import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao= SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao=SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);

    @Override
    public Activity solveDetail(String id) {
        return activityDao.solveDetail(id);
    }

    @Override
    public boolean updateRemark(ActivityRemark activityRemark) {
        int count= activityRemarkDao.updateRemark(activityRemark);
        if(count==1){
            return true;
        }
        return false;
    }

    @Override
    public boolean saveRemark(ActivityRemark activityRemark) {
        int count =activityRemarkDao.saveRemark(activityRemark);
        if(count==1){
            return true;
        }
        return false;
    }

    @Override
    public boolean deleteRemark(String id) {
        int count=activityRemarkDao.deleteRemark(id);
        if(count==1){
            return true;
        }
        return false;
    }

    @Override
    public List<ActivityRemark> getRemarkList(String aId) {
        return activityRemarkDao.getRemarkList(aId);
    }

    @Override
    public boolean updateActivity(Activity activity) {
        int count =activityDao.updateActivity(activity);
        if(count!=1){
            return false;
        }
        return true;
    }

    @Override
    public Activity getActivity(String id) {
        return activityDao.getActivity(id);
    }

    @Override
    public boolean deleteActivity(String[] params) {
        boolean flag=true;
        int remarkCount=activityRemarkDao.getDeleteCount(params);
        int deleteCount=activityRemarkDao.deleteCount(params);
        if(deleteCount!=remarkCount){
            flag=false;
        }
        int count=activityDao.deleteCount(params);
        if(count!=params.length){
            flag=false;
        }
        return flag;
    }

    @Override
    public PaginationVo<Activity> pageList(Map<String, Object> map) {
        List<Activity> list=activityDao.getActivityListByCondition(map);
        int total=activityDao.getActivityListNum(map);

        PaginationVo<Activity> paginationVo=new PaginationVo<Activity>();
        paginationVo.setDataList(list);
        paginationVo.setTotal(total);
        return paginationVo;
    }

    @Override
    public void saveActivity(Activity activity) throws SaveActivityExce {
         int count=activityDao.saveActivity(activity);
         if(count!=1){
             throw new SaveActivityExce("保存失败");
         }
    }
}
