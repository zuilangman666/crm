package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.TaskRemark;

import java.util.List;

public interface TaskRemarkDao {
    List<TaskRemark> getRemarkList(String taskId);

    int saveRemark(TaskRemark taskRemark);

    void deleteRemark(String id);

    int updateRemark(TaskRemark taskRemark);

    int deleteRemarkS(String id);
}
