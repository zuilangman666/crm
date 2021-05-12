package com.geng.crm.settings.workbench.web.controller;

import com.geng.crm.exceptions.SaveActivityExce;
import com.geng.crm.settings.domain.User;
import com.geng.crm.settings.service.UserService;
import com.geng.crm.settings.service.impl.UserServiceImpl;
import com.geng.crm.settings.workbench.domain.Activity;
import com.geng.crm.settings.workbench.domain.ActivityRemark;
import com.geng.crm.settings.workbench.service.ActivityService;
import com.geng.crm.settings.workbench.service.impl.ActivityServiceImpl;
import com.geng.crm.utils.DateTimeUtil;
import com.geng.crm.utils.PrintJson;
import com.geng.crm.utils.ServiceFactory;
import com.geng.crm.utils.UUIDUtil;
import com.geng.crm.vo.PaginationVo;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path=request.getServletPath();
        if("/workbench/activity/getUserList.do".equals(path)){
            List<User> list=getUserList();
            PrintJson.printJsonObj(response,list);
        }
        else if("/workbench/activity/saveActivity.do".equals(path)){
             saveActivity(request,response);
        }
        else if("/workbench/activity/pageList.do".equals(path)){
            pageList(request,response);
        }
        else if("/workbench/activity/deleteActivity.do".equals(path)){
            System.out.println("进行删除操作");
            deleteActivity(request,response);
        }
        else if("/workbench/activity/getUserListAndActivity.do".equals(path)){
            List<User> list=getUserList();
            String id=request.getParameter("id");
            Activity activity=getActivity(id);
            Map<String,Object> map=new HashMap<String,Object>();
            map.put("userList",list);
            map.put("activity",activity);
            PrintJson.printJsonObj(response,map);
        }
        else if("/workbench/activity/updateActivity.do".equals(path)){
            updateActivity(request,response);
        }
        else if("/workbench/activity/detail.do".equals(path)){
            System.out.println("进入详情页");
            String id=request.getParameter("id");
            Activity activity=solveDetail(id);
            request.setAttribute("activity",activity);
            request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);
        }
        else if("/workbench/activityRemark/showRemarkList.do".equals(path)){
            System.out.println("展示信息备注");
            getRemarkList(request,response);
        }
        else if("/workbench/activityRemark/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }
        else if("/workbench/activityRemark/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }
        else if("/workbench/activityRemark/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        String noteContent=request.getParameter("noteContent");
        String id=request.getParameter("id");
        String editTime=DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="1";

        ActivityRemark activityRemark=new ActivityRemark();

        activityRemark.setId(id);
        activityRemark.setEditTime(editTime);
        activityRemark.setEditBy(editBy);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setEditFlag(editFlag);
        System.out.println("---------------------------"+activityRemark.toString());
        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=activityService.updateRemark(activityRemark);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("remark",activityRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String noteContent=request.getParameter("noteContent");
        String activityId=request.getParameter("id");
        String createTime=DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="0";
        String id=UUIDUtil.getUUID();

        ActivityRemark activityRemark=new ActivityRemark();
        activityRemark.setActivityId(activityId);
        activityRemark.setId(id);
        activityRemark.setCreateBy(createBy);
        activityRemark.setCreateTime(createTime);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setEditFlag(editFlag);
        System.out.println("---------------------------"+activityRemark.toString());
        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=activityService.saveRemark(activityRemark);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("remark",activityRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=activityService.deleteRemark(id);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void getRemarkList(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("activityId");
        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImpl());
        List<ActivityRemark> list=activityService.getRemarkList(id);
        PrintJson.printJsonObj(response,list);
    }

    private Activity solveDetail(String id) {
        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImpl());
        return activityService.solveDetail(id);
    }

    private void updateActivity(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String owner =request.getParameter("owner");
        String name =request.getParameter("name");
        String startDate =request.getParameter("startDate");
        String endDate =request.getParameter("endDate");
        String cost =request.getParameter("cost");
        String description =request.getParameter("description");
        String editTime= DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("user")).getName();

        Activity activity=new Activity();

        activity.setId(id);
        activity.setCost(cost);
        activity.setEditBy(editBy);
        activity.setEditTime(editTime);
        activity.setDescription(description);
        activity.setEndDate(endDate);
        activity.setStartDate(startDate);
        activity.setOwner(owner);
        activity.setName(name);

        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=activityService.updateActivity(activity);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private Activity getActivity(String id) {
        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImpl());
        Activity activity=activityService.getActivity(id);
        return activity;
    }

    private void deleteActivity(HttpServletRequest request, HttpServletResponse response) {
        String[] params=request.getParameterValues("id");
        ActivityService activityService=(ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=activityService.deleteActivity(params);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {

        String name=request.getParameter("name");
        String owner=request.getParameter("owner");
        String startDate=request.getParameter("startDate");
        String endDate=request.getParameter("endDate");
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipNum=(pageNo-1)*pageSize;
        //System.out.println(name+" "+owner+" "+startDate+" "+endDate+" "+pageNoStr+" "+pageSizeStr);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("pageNo",pageNo);
        map.put("pageSize",pageSize);
        map.put("skipNum",skipNum);
        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImpl());
        //此时使用一个模板类型是为了方便以后使用，不把类型写死
        PaginationVo<Activity> paginationVo=activityService.pageList(map);
        PrintJson.printJsonObj(response,paginationVo);
    }

    private void saveActivity(HttpServletRequest request, HttpServletResponse response) {
        String id = UUIDUtil.getUUID();
        String owner =request.getParameter("owner");
        String name =request.getParameter("name");
        String startDate =request.getParameter("startDate");
        String endDate =request.getParameter("endDate");
        String cost =request.getParameter("cost");
        String description =request.getParameter("description");
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("user")).getName();

        Activity activity=new Activity();

        activity.setId(id);
        activity.setCost(cost);
        activity.setCreateBy(createBy);
        activity.setCreateTime(createTime);
        activity.setDescription(description);
        activity.setEndDate(endDate);
        activity.setStartDate(startDate);
        activity.setOwner(owner);
        activity.setName(name);

        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImpl());
        try{
            activityService.saveActivity(activity);
            PrintJson.printJsonFlag(response,"flag",true);
        }
        catch (SaveActivityExce e){
            e.printStackTrace();
            System.out.println(e.getMessage());
            PrintJson.printJsonFlag(response,"flag",false);
        }

    }

    private List<User> getUserList(){
        System.out.println("获取用户列表");
        UserService userService=(UserService) ServiceFactory.getService(new UserServiceImpl());
        return userService.getUserList();
    }
}
