package com.geng.crm.settings.workbench.service;

import com.geng.crm.settings.workbench.domain.Activity;
import com.geng.crm.settings.workbench.domain.Clue;
import com.geng.crm.settings.workbench.domain.ClueRemark;
import com.geng.crm.settings.workbench.domain.Tran;
import com.geng.crm.vo.PaginationVo;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean saveClue(Clue clue);

    PaginationVo<Clue> pageList(Map<String, Object> map);

    Clue getClue(String id);

    boolean updateClue(Clue clue);

    boolean deleteClue(String[] id);

    Clue solveDetail(String id);

    List<ClueRemark> getRemarkList(String id);

    boolean saveRemark(ClueRemark clueRemark);

    boolean deleteRemark(String id);

    boolean updateRemark(ClueRemark clueRemark);

    List<Activity> getActivityList(String id);

    boolean unbind(String id);

    List<Activity> getActivityListSS(String name, String clueId);

    boolean bind(String clueId, String[] activityId);

    List<Activity> getActivityListSSS(String name, String clueId);

    String getID(String id);

    boolean convert(String clueId, Tran tran ,String createBy);
}
