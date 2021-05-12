package com.geng.crm.settings.workbench.web.controller;

import com.geng.crm.settings.domain.User;
import com.geng.crm.settings.service.UserService;
import com.geng.crm.settings.service.impl.UserServiceImpl;
import com.geng.crm.settings.workbench.domain.Contacts;
import com.geng.crm.settings.workbench.domain.Task;
import com.geng.crm.settings.workbench.domain.TaskRemark;
import com.geng.crm.settings.workbench.service.ContactsService;
import com.geng.crm.settings.workbench.service.TranService;
import com.geng.crm.settings.workbench.service.VisitService;
import com.geng.crm.settings.workbench.service.impl.ContactsServiceImpl;
import com.geng.crm.settings.workbench.service.impl.TranServiceImpl;
import com.geng.crm.settings.workbench.service.impl.VisitServiceImpl;
import com.geng.crm.utils.DateTimeUtil;
import com.geng.crm.utils.PrintJson;
import com.geng.crm.utils.ServiceFactory;
import com.geng.crm.utils.UUIDUtil;
import com.geng.crm.vo.PaginationVo;

import javax.jws.soap.SOAPBinding;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VisitController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       String path=request.getServletPath();
       if("/workbench/visit/pageList.do".equals(path)){
            pageList(request,response);
       }
       else if("/workbench/visit/searchContact.do".equals(path)){
           searchContact(request,response);
       }
       else if("/workbench/task/saveTask.do".equals(path)){
           saveTask(request,response);
       }
       else if("/workbench/task/deleteTask.do".equals(path)){
           deleteTask(request,response);
       }
       else if("/workbench/visit/editTask.do".equals(path)){
           Task task=editTask(request,response);
           ContactsService contactsService=(ContactsService)ServiceFactory.getService(new ContactsServiceImpl());
           Contacts contacts=contactsService.getContactsS(task.getContactsId());

           System.out.println("------"+task.toString());
           System.out.println("------"+contacts.toString());
           request.setAttribute("task",task);
           request.setAttribute("contacts",contacts);
           request.getRequestDispatcher("/workbench/visit/editTask.jsp").forward(request,response);
       }
       else if("/workbench/task/editTask.do".equals(path)){
           updateTask(request,response);
       }
       else if("/workbench/visit/detail.do".equals(path)){
           detail(request,response);
       }
       else if("/workbench/visit/showRemark.do".equals(path)){
           showRemark(request,response);
       }
       else if("/workbench/visit/saveRemark.do".equals(path)){
           saveRemark(request,response);
       }
       else if("/workbench/visit/updateRemark.do".equals(path)){
           updateRemark(request,response);
       }
       else if("/workbench/visit/deleteRemark.do".equals(path)){
           deleteRemark(request,response);
       }
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        VisitService visitService=(VisitService) ServiceFactory.getService(new VisitServiceImpl());
        boolean flag=visitService.deleteRemark(id);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        String noteContent=request.getParameter("noteContent");
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editTime=DateTimeUtil.getSysTime();
        String editFlag="1";
        String taskId=request.getParameter("taskId");
        TaskRemark taskRemark=new TaskRemark();
        taskRemark.setEditBy(editBy);
        taskRemark.setTaskId(taskId);
        taskRemark.setEditTime(editTime);
        taskRemark.setEditFlag(editFlag);
        taskRemark.setId(id);
        taskRemark.setNoteContent(noteContent);
        VisitService visitService=(VisitService) ServiceFactory.getService(new VisitServiceImpl());
        boolean flag=visitService.updateRemark(taskRemark);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("remark",taskRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=UUIDUtil.getUUID();
        String noteContent=request.getParameter("noteContent");
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String createTime=DateTimeUtil.getSysTime();
        String editFlag="0";
        String taskId=request.getParameter("taskId");
        TaskRemark taskRemark=new TaskRemark();
        taskRemark.setCreateBy(createBy);
        taskRemark.setCreateTime(createTime);
        taskRemark.setEditFlag(editFlag);
        taskRemark.setId(id);
        taskRemark.setTaskId(taskId);
        taskRemark.setNoteContent(noteContent);
        VisitService visitService=(VisitService) ServiceFactory.getService(new VisitServiceImpl());
        boolean flag=visitService.saveRemark(taskRemark);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("remark",taskRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void showRemark(HttpServletRequest request, HttpServletResponse response) {
        String taskId=request.getParameter("taskId");
        VisitService visitService=(VisitService) ServiceFactory.getService(new VisitServiceImpl());
        List<TaskRemark> list= visitService.getRemarkList(taskId);
        PrintJson.printJsonObj(response,list);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id=request.getParameter("id");
        VisitService visitService=(VisitService) ServiceFactory.getService(new VisitServiceImpl());
        Task task=visitService.getTaskS(id);
        request.setAttribute("task",task);
        request.getRequestDispatcher("/workbench/visit/detail.jsp").forward(request,response);

    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id= request.getParameter("id");
        String owner=request.getParameter("owner");
        String topic=request.getParameter("topic");
        String endDate=request.getParameter("endDate");
        String startDate=request.getParameter("startDate");
        String contactsId=request.getParameter("contactsId");
        String taskStage=request.getParameter("taskStage");
        String priority=request.getParameter("priority");
        String description =request.getParameter("description");
        String repeatType=request.getParameter("repeatType");
        String noticeType=request.getParameter("noticeType");
        String editTime= DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("user")).getName();

        Task task=new Task();
        task.setId(id);
        task.setOwner(owner);
        task.setTopic(topic);
        task.setEndDate(endDate);
        task.setStartDate(startDate);
        task.setTaskStage(taskStage);
        task.setContactsId(contactsId);
        task.setPriority(priority);
        task.setDescription(description);
        task.setRepeatType(repeatType);
        task.setNoticeType(noticeType);
        task.setEditTime(editTime);
        task.setEditBy(editBy);
        System.out.println(task);
        VisitService visitService=(VisitService) ServiceFactory.getService(new VisitServiceImpl());
        boolean flag=visitService.updateTask(task);
        if(flag){
            response.sendRedirect(request.getContextPath()+"/workbench/visit/index.jsp");
        }
    }

    private Task editTask(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        VisitService visitService=(VisitService) ServiceFactory.getService(new VisitServiceImpl());
        return visitService.getTask(id);
    }


    private void deleteTask(HttpServletRequest request, HttpServletResponse response) {
        String[] ids=request.getParameterValues("id");
        VisitService visitService=(VisitService) ServiceFactory.getService(new VisitServiceImpl());
        boolean flag=visitService.deleteTask(ids);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void saveTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id= UUIDUtil.getUUID();
        String owner=request.getParameter("owner");
        String topic=request.getParameter("topic");
        String endDate=request.getParameter("endDate");
        String startDate=request.getParameter("startDate");
        String contactsId=request.getParameter("contactsId");
        String taskStage=request.getParameter("taskStage");
        String priority=request.getParameter("priority");
        String description =request.getParameter("description");
        String repeatType=request.getParameter("repeatType");
        String noticeType=request.getParameter("noticeType");
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("user")).getName();

        Task task=new Task();
        task.setId(id);
        task.setOwner(owner);
        task.setTopic(topic);
        task.setEndDate(endDate);
        task.setStartDate(startDate);
        task.setTaskStage(taskStage);
        task.setContactsId(contactsId);
        task.setPriority(priority);
        task.setDescription(description);
        task.setRepeatType(repeatType);
        task.setNoticeType(noticeType);
        task.setCreateTime(createTime);
        task.setCreateBy(createBy);
        System.out.println(task);
        VisitService visitService=(VisitService) ServiceFactory.getService(new VisitServiceImpl());
        boolean flag=visitService.saveTask(task);
        if(flag){
            response.sendRedirect(request.getContextPath()+"/workbench/visit/index.jsp");
        }
    }

    private void searchContact(HttpServletRequest request, HttpServletResponse response) {
        String fullname=request.getParameter("name");
        VisitService visitService=(VisitService) ServiceFactory.getService(new VisitServiceImpl());
        List<Contacts> list=visitService.getContactsList(fullname);

        PrintJson.printJsonObj(response,list);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        String owner=request.getParameter("owner");
        String topic=request.getParameter("topic");
        String endDate=request.getParameter("endDate");
        String priority=request.getParameter("priority");
        String taskStage=request.getParameter("taskStage");
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipNum=(Integer.valueOf(pageNoStr)-1)*pageSize;
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("owner",owner);
        map.put("topic",topic);
        map.put("endDate",endDate);
        map.put("priority",priority);
        map.put("taskStage",taskStage);
        map.put("pageSize",pageSize);
        map.put("skipNum",skipNum);

        VisitService visitService=(VisitService) ServiceFactory.getService(new VisitServiceImpl());
        PaginationVo<Task> paginationVo=visitService.pageList(map);
        PrintJson.printJsonObj(response,paginationVo);
        
    }
}
