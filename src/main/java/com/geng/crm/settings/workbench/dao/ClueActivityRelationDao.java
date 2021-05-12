package com.geng.crm.settings.workbench.dao;


import com.geng.crm.settings.workbench.domain.Activity;
import com.geng.crm.settings.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {


    List<ClueActivityRelation> getRelationList(String clueId) ;

    List<Activity> getActivityList(String id);

    int deleteRelation(String id);

    List<Activity> getActivityListSS(String name, String clueId);

    int createRelation(String id,String clueId, String s);

    List<Activity> getActivityListSSS(String name, String clueId);

    int deleteRelationS(String clueId);
}
