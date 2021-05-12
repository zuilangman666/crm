package com.geng.crm.settings.workbench.web.controller;

import com.geng.crm.settings.domain.User;
import com.geng.crm.settings.service.UserService;
import com.geng.crm.settings.service.impl.UserServiceImpl;
import com.geng.crm.settings.workbench.domain.Activity;
import com.geng.crm.settings.workbench.domain.Clue;
import com.geng.crm.settings.workbench.domain.ClueRemark;
import com.geng.crm.settings.workbench.domain.Tran;
import com.geng.crm.settings.workbench.service.ClueService;
import com.geng.crm.settings.workbench.service.impl.ClueServiceImpl;
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

public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path=request.getServletPath();
        if("/workbench/clue/getUserList.do".equals(path)){
            List<User> list=getUserList(request,response);
            PrintJson.printJsonObj(response,list);
        }
        else if("/workbench/clue/saveClue.do".equals(path)){
             saveClue(request,response);
        }
        else if("/workbench/clue/pageList.do".equals(path)){
            pageList(request,response);
        }
        else if("/workbench/clue/getClue.do".equals(path)){
            Clue clue=getClue(request,response);
            System.out.println(clue.getOwner());
            List<User> list=getUserList(request,response);
            Map<String,Object> map=new HashMap<String,Object>();
            map.put("clue",clue);
            map.put("user",list);
            PrintJson.printJsonObj(response,map);
            //思考为什么我使用getClue方法调用getUserList会报错
            //我们知道，我们是使用的sqlSessionUtil类产生代理类，getUserList和getClue都是一个事务，执行完一个事务我们的session就要提交然后关闭了
            //就会报错。https://blog.csdn.net/weixin_40917714/article/details/83059654
        }
        else if("/workbench/clue/updateClue.do".equals(path)){
            updateClue(request,response);
        }
        else if("/workbench/clue/deleteClue.do".equals(path)){
            deleteClue(request,response);
        }
        else if("/workbench/clue/detail.do".equals(path)){
            String id=request.getParameter("id");
            Clue clue=solveDetail(id);
            //String ID=getID(id);
            request.setAttribute("clue",clue);
            //request.setAttribute("ID",ID);
            request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
        }
        else if("/workbench/clue/showRemark.do".equals(path)){
            showRemark(request,response);
        }
        else if("/workbench/clue/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }
        else if("/workbench/clue/updateRemark.do".equals(path)){
              updateRemark(request,response);
        }
        else if("/workbench/clue/deleteRemark.do".equals(path)){
             deleteRemark(request,response);
        }
        else if("/workbench/clue/showRelation.do".equals(path)){
            showRelation(request,response);
        }
        else if("/workbench/clue/unbind.do".equals(path)){
            unbind(request,response);
        }
        else if("/workbench/clue/getActivityListSS.do".equals(path)){
            getActivityListSS(request,response);
        }
        else if("/workbench/clue/bind.do".equals(path)){
            bind(request,response);
        }
        else if("/workbench/clue/showActivityListSSS.do".equals(path)){
            showActivityListSSS(request,response);
        }
        else if("/workbench/clue/convert.do".equals(path)){
            convert(request,response);
        }
    }

    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String clueId=request.getParameter("clueId");
        String flag=request.getParameter("flag");
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        Tran tran=null;
        if("success".equals(flag)){
            //创建交易   获取交易参数
            tran=new Tran();
            String id=UUIDUtil.getUUID();
            String createTime=DateTimeUtil.getSysTime();
           // String owner=request.getParameter("owner");
            String money=request.getParameter("money");
            String name=request.getParameter("name");
            String expectedDate=request.getParameter("expectedDate");
            String stage=request.getParameter("stage");
            String type=request.getParameter("type");
            String source=request.getParameter("source");
            String activityId=request.getParameter("activityId");

            tran.setId(id);
            tran.setActivityId(activityId);
            tran.setCreateBy(createBy);
            tran.setCreateTime(createTime);
            //tran.setOwner(owner);
            tran.setType(type);
            tran.setSource(source);
            tran.setStage(stage);
            tran.setName(name);
            tran.setExpectedDate(expectedDate);
            tran.setMoney(money);

        }
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        boolean temp=clueService.convert(clueId,tran,createBy);
        if(temp){
            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
        }
    }

    private String getID(String id) {
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        return clueService.getID(id);
    }

    private void showActivityListSSS(HttpServletRequest request, HttpServletResponse response) {
        String name=request.getParameter("name");
        String clueId=request.getParameter("clueId");
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        List<Activity> list =clueService.getActivityListSSS(name,clueId);
        PrintJson.printJsonObj(response,list);
    }

    private void bind(HttpServletRequest request, HttpServletResponse response) {
        String clueId=request.getParameter("clueId");
        String[] activityId=request.getParameterValues("activityId");
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.bind(clueId,activityId);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void getActivityListSS(HttpServletRequest request, HttpServletResponse response) {
        String name=request.getParameter("name");
        String clueId=request.getParameter("clueId");
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        List<Activity> list =clueService.getActivityListSS(name,clueId);
        PrintJson.printJsonObj(response,list);
    }

    private void unbind(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.unbind(id);

        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void showRelation(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        List<Activity> list=clueService.getActivityList(id);
        PrintJson.printJsonObj(response,list);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.deleteRemark(id);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        String noteContent=request.getParameter("noteContent");
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editTime=DateTimeUtil.getSysTime();
        String editFlag="1";
        ClueRemark clueRemark=new ClueRemark();
        clueRemark.setId(id);
        clueRemark.setNoteContent(noteContent);
        clueRemark.setEditBy(editBy);
        clueRemark.setEditTime(editTime);
        clueRemark.setEditFlag(editFlag);
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.updateRemark(clueRemark);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("remark",clueRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String clueId=request.getParameter("id");
        String noteContent=request.getParameter("noteContent");
        String id=UUIDUtil.getUUID();
        String editFlag="0";
        String createTime=DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        ClueRemark clueRemark=new ClueRemark();
        clueRemark.setClueId(clueId);
        clueRemark.setCreateBy(createBy);
        clueRemark.setCreateTime(createTime);
        clueRemark.setEditFlag(editFlag);
        clueRemark.setId(id);
        clueRemark.setNoteContent(noteContent);

        boolean flag=clueService.saveRemark(clueRemark);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("remark",clueRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void showRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        List<ClueRemark> clueRemark=clueService.getRemarkList(id);
        System.out.println(clueRemark);
        PrintJson.printJsonObj(response,clueRemark);
    }

    private Clue solveDetail(String id) {
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        return clueService.solveDetail(id);
    }

    private void deleteClue(HttpServletRequest request, HttpServletResponse response) {
        String[] id=request.getParameterValues("id");
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.deleteClue(id);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void updateClue(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        String fullname=request.getParameter("fullname");
        String appellation=request.getParameter("appellation");
        String owner=request.getParameter("owner");
        String company=request.getParameter("company");
        String job=request.getParameter("job");
        String email=request.getParameter("email");
        String phone=request.getParameter("phone");
        String website=request.getParameter("website");
        String mphone=request.getParameter("mphone");
        String state=request.getParameter("state");
        String source=request.getParameter("source");
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editTime= DateTimeUtil.getSysTime();
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");

        Clue clue=new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setCreateBy(editBy);
        clue.setCreateTime(editTime);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.updateClue(clue);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private Clue getClue(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        System.out.println(id);
        return clueService.getClue(id);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        String fullname =request.getParameter("fullname");
        String company=request.getParameter("company");
        String phone=request.getParameter("phone");
        String source=request.getParameter("source");
        String owner=request.getParameter("owner");
        String mphone=request.getParameter("mphone");
        String state=request.getParameter("state");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipNum=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("skipNum",skipNum);
        map.put("pageSize",pageSize);
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("state",state);
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        PaginationVo<Clue> paginationVo=clueService.pageList(map);
        PrintJson.printJsonObj(response,paginationVo);
    }

    private void saveClue(HttpServletRequest request, HttpServletResponse response) {
        String id= UUIDUtil.getUUID();
        String fullname=request.getParameter("fullname");
        String appellation=request.getParameter("appellation");
        String owner=request.getParameter("owner");
        String company=request.getParameter("company");
        String job=request.getParameter("job");
        String email=request.getParameter("email");
        String phone=request.getParameter("phone");
        String website=request.getParameter("website");
        String mphone=request.getParameter("mphone");
        String state=request.getParameter("state");
        String source=request.getParameter("source");
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String createTime= DateTimeUtil.getSysTime();
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");

        Clue clue=new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.saveClue(clue);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private List<User> getUserList(HttpServletRequest request, HttpServletResponse response) {
        UserService userService=(UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> list=userService.getUserList();
        return list;
    }


}
