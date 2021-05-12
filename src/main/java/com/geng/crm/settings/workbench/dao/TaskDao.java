package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.Task;

import java.util.List;
import java.util.Map;

public interface TaskDao {
    int getTotal(Map<String, Object> map);

    List<Task> getList(Map<String, Object> map);

    int saveTask(Task task);

    int deleteTask(String[] ids);

    Task getTask(String id);

    int updateTask(Task task);

    Task getTaskS(String id);
}
