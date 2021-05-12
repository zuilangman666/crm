package com.geng.crm.settings.workbench.service;

import com.geng.crm.settings.workbench.domain.Contacts;
import com.geng.crm.settings.workbench.domain.Task;
import com.geng.crm.settings.workbench.domain.TaskRemark;
import com.geng.crm.vo.PaginationVo;

import java.util.List;
import java.util.Map;

public interface VisitService {
    PaginationVo<Task> pageList(Map<String, Object> map);

    List<Contacts> getContactsList(String fullname);

    boolean saveTask(Task task);

    boolean deleteTask(String[] ids);

    Task getTask(String id);

    boolean updateTask(Task task);

    Task getTaskS(String id);

    List<TaskRemark> getRemarkList(String taskId);

    boolean saveRemark(TaskRemark taskRemark);

    boolean updateRemark(TaskRemark taskRemark);

    boolean deleteRemark(String id);
}
