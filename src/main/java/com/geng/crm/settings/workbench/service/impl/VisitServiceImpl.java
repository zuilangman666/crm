package com.geng.crm.settings.workbench.service.impl;

import com.geng.crm.settings.workbench.dao.ContactsDao;
import com.geng.crm.settings.workbench.dao.TaskDao;
import com.geng.crm.settings.workbench.dao.TaskRemarkDao;
import com.geng.crm.settings.workbench.domain.Contacts;
import com.geng.crm.settings.workbench.domain.Task;
import com.geng.crm.settings.workbench.domain.TaskRemark;
import com.geng.crm.settings.workbench.service.VisitService;
import com.geng.crm.utils.SqlSessionUtil;
import com.geng.crm.vo.PaginationVo;

import java.util.List;
import java.util.Map;

public class VisitServiceImpl implements VisitService {
    private TaskDao taskDao= SqlSessionUtil.getSqlSession().getMapper(TaskDao.class);
    private ContactsDao contactsDao=SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private TaskRemarkDao taskRemarkDao =SqlSessionUtil.getSqlSession().getMapper(TaskRemarkDao.class);
    @Override
    public boolean saveTask(Task task) {
        if(taskDao.saveTask(task)!=1){
            return false;
        }
        return true;
    }

    @Override
    public List<Contacts> getContactsList(String fullname) {
        return contactsDao.getContactsListSS(fullname);
    }

    @Override
    public boolean saveRemark(TaskRemark taskRemark) {
        if(taskRemarkDao.saveRemark(taskRemark)!=1){
            return false;
        }
        return true;
    }

    @Override
    public List<TaskRemark> getRemarkList(String taskId) {
        return taskRemarkDao.getRemarkList(taskId);
    }

    @Override
    public Task getTaskS(String id) {
        return taskDao.getTaskS(id);
    }

    @Override
    public boolean updateTask(Task task) {
        if(taskDao.updateTask(task)!=1){
            return false;
        }
        return true;
    }

    @Override
    public Task getTask(String id) {
        return taskDao.getTask(id);
    }

    @Override
    public boolean deleteRemark(String id) {
        if(taskRemarkDao.deleteRemarkS(id)!=1){
            return false;
        }
        return true;
    }

    @Override
    public boolean updateRemark(TaskRemark taskRemark) {
        if(taskRemarkDao.updateRemark(taskRemark)!=1){
            return false;
        }
        return true;
    }

    @Override
    public boolean deleteTask(String[] ids) {
        if(taskDao.deleteTask(ids)==ids.length){
            for(int i=0;i<ids.length;i++){
                taskRemarkDao.deleteRemark(ids[i]);
            }
            return true;
        }
        return false;
    }

    @Override
    public PaginationVo<Task> pageList(Map<String, Object> map) {
        int total=taskDao.getTotal(map);
        List<Task> list=taskDao.getList(map);
        System.out.println(list.get(0).toString());
        PaginationVo<Task> paginationVo=new PaginationVo<Task>();
        paginationVo.setDataList(list);
        paginationVo.setTotal(total);
        return paginationVo;
    }
}
