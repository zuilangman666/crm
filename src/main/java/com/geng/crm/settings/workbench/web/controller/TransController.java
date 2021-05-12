package com.geng.crm.settings.workbench.web.controller;

import com.geng.crm.settings.domain.User;
import com.geng.crm.settings.service.UserService;
import com.geng.crm.settings.service.impl.UserServiceImpl;
import com.geng.crm.settings.workbench.domain.*;
import com.geng.crm.settings.workbench.service.*;
import com.geng.crm.settings.workbench.service.impl.*;
import com.geng.crm.utils.DateTimeUtil;
import com.geng.crm.utils.PrintJson;
import com.geng.crm.utils.ServiceFactory;
import com.geng.crm.utils.UUIDUtil;
import com.geng.crm.vo.PaginationVo;
import javafx.beans.binding.ObjectExpression;

import javax.jws.soap.SOAPBinding;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class TransController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path=request.getServletPath();
        if("/workbench/transaction/pageList.do".equals(path)){
              pageList(request,response);
        }
        else if("/workbench/transaction/detail.do".equals(path)){
               detail(request,response);
        }
        else if("/workbench/transaction/saveTran.do".equals(path)){
            saveTran(request,response);
        }
        else if("/workbench/transaction/showActivity.do".equals(path)){
            activityList(request,response);
        }
        else if("/workbench/transaction/getCustomerName.do".equals(path)){
            System.out.println("自动补全功能");
            getCustomerName(request,response);
        }
        else if("/workbench/transaction/showContacts.do".equals(path)){
            contactsList(request,response);
        }
        else if("/workbench/transaction/deleteContacts.do".equals(path)){
            deleteContacts(request,response);
        }
        else if("/workbench/transaction/editTran.do".equals(path)){
            editTran(request,response);
        }
        else if("/workbench/transaction/edit.do".equals(path)){
            edit(request,response);
        }
        else if("/workbench/transaction/showInit.do".equals(path)){
            String contactsId=request.getParameter("contactsId");
            String activityId=request.getParameter("activityId");
            UserService userService=(UserService)ServiceFactory.getService(new UserServiceImpl());
            List<User> userList=userService.getUserList();

            ContactsService contactsService=(ContactsService)ServiceFactory.getService(new ContactsServiceImpl());
            Contacts contacts=contactsService.getContacts(contactsId);

            ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImpl());
            Activity activity=activityService.getActivity(activityId);

            Map<String,Object> map=new HashMap<String,Object>();
            map.put("userList",userList);
            map.put("activity",activity);
            map.put("contacts",contacts);
            PrintJson.printJsonObj(response,map);
        }
        else if("/workbench/transaction/showRemark.do".equals(path)){
            showRemark(request,response);
        }
        else if("/workbench/transaction/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }
        else if("/workbench/transaction/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }
        else if("/workbench/transaction/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }
        else if("/workbench/transaction/showHistory.do".equals(path)){
            showHistory(request,response);
        }
        else if("/workbench/transaction/changeStage.do".equals(path)){
            changeStage(request,response);
        }
        else if("/workbench/transaction/getTranECharts.do".equals(path)){
            getTranECharts(request,response);
        }
    }

    private void getTranECharts(HttpServletRequest request, HttpServletResponse response) {
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        Map<String,Object> map=tranService.getTranECharts();
        PrintJson.printJsonObj(response,map);
    }

    private void changeStage(HttpServletRequest request, HttpServletResponse response) {
        String id= UUIDUtil.getUUID();
        String stage=request.getParameter("stage");
        String money=request.getParameter("money");
        String expectedDate=request.getParameter("expectedDate");
        String createTime=DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String tranId=request.getParameter("tranId");
        TranHistory tranHistory=new TranHistory();
        tranHistory.setId(id);
        tranHistory.setTranId(tranId);
        tranHistory.setStage(stage);
        tranHistory.setMoney(money);
        tranHistory.setExpectedDate(expectedDate);
        tranHistory.setCreateTime(createTime);
        tranHistory.setCreateBy(createBy);
        ServletContext application=request.getServletContext();
        Map<String,String> pMap=(Map<String,String>)application.getAttribute("pMap");
        tranHistory.setPossibility(pMap.get(tranHistory.getStage()));
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran=tranService.changeStage(tranHistory);
        boolean flag=false;
        if(tran!=null){
            flag=true;
        }
       Map<String, Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("tran",tran);
        PrintJson.printJsonObj(response,map);
    }

    private void showHistory(HttpServletRequest request, HttpServletResponse response) {
        String tranId=request.getParameter("tranId");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranHistory> list=tranService.showHistory(tranId);
        ServletContext application=request.getServletContext();
        Map<String,String> map=(Map<String,String>)application.getAttribute("pMap");
        for(TranHistory tranHistory:list){
            tranHistory.setPossibility(map.get(tranHistory.getStage()));
        }
        PrintJson.printJsonObj(response,list);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        String noteContent=request.getParameter("noteContent");
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editTime=DateTimeUtil.getSysTime();
        String editFlag="1";
        TranRemark tranRemark=new TranRemark();

        tranRemark.setId(id);
        tranRemark.setNoteContent(noteContent);
        tranRemark.setEditFlag(editFlag);
        tranRemark.setEditBy(editBy);
        tranRemark.setEditTime(editTime);

        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag=tranService.updateRemark(tranRemark);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("remark",tranRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag=tranService.deleteRemark(id);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=UUIDUtil.getUUID();
        String noteContent=request.getParameter("noteContent");
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String createTime=DateTimeUtil.getSysTime();
        String editFlag="0";
        String tranId=request.getParameter("tranId");
        TranRemark tranRemark=new TranRemark();

        tranRemark.setId(id);
        tranRemark.setTranId(tranId);
        tranRemark.setNoteContent(noteContent);
        tranRemark.setEditFlag(editFlag);
        tranRemark.setCreateTime(createTime);
        tranRemark.setCreateBy(createBy);

        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag=tranService.saveRemark(tranRemark);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("remark",tranRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void showRemark(HttpServletRequest request, HttpServletResponse response) {

        String tranId=request.getParameter("tranId");
        System.out.println(tranId);
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranRemark> list=tranService.getRemark(tranId);
        PrintJson.printJsonObj(response,list);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id=request.getParameter("transId");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran=tranService.detail(id);

        //获取application的几种方式
        /*ServletContext application1=this.getServletContext();
        ServletContext application2=request.getServletContext();
        ServletContext application3=this.getServletConfig().getServletContext();*/
         ServletContext application =this.getServletContext();
        Map<String,String>map=(Map<String, String>) application.getAttribute("pMap");
        tran.setPossibility(map.get(tran.getStage()));
        request.setAttribute("tran",tran);
        System.out.println(tran.toString());
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        System.out.println("进行跳转edit.jsp");
        String id=request.getParameter("id");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran=tranService.getTran(id);
        request.setAttribute("tran",tran);
        System.out.println(tran.toString());
        //response.sendRedirect(request.getContextPath()+"/workbench/transaction/edit.jsp");
        request.getRequestDispatcher("/workbench/transaction/edit.jsp").forward(request,response);
    }

    private void editTran(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id= request.getParameter("id");
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editTime= DateTimeUtil.getSysTime();
        String owner =request.getParameter("owner");
        String money =request.getParameter("money");
        String name =request.getParameter("name");
        String expectedDate =request.getParameter("expectedDate");
        String customerId =request.getParameter("customerId");
        String stage =request.getParameter("stage");
        String type =request.getParameter("type");
        String source =request.getParameter("source");
        String activityId =request.getParameter("activityId");
        String contactsId =request.getParameter("contactsId");
        String description =request.getParameter("description");
        String contactSummary =request.getParameter("contactSummary");
        String nextContactTime =request.getParameter("nextContactTime");
        Tran tran=new Tran();
        tran.setOwner(owner);
        tran.setMoney(money);
        tran.setName(name);
        tran.setExpectedDate(expectedDate);
        tran.setCustomerId(customerId);
        tran.setStage(stage);
        tran.setType(type);
        tran.setSource(source);
        tran.setActivityId(activityId);
        tran.setContactsId(contactsId);
        tran.setDescription(description);
        tran.setContactSummary(contactSummary);
        tran.setNextContactTime(nextContactTime);
        tran.setId(id);
        tran.setEditBy(editBy);
        tran.setEditTime(editTime);
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag=tranService.updateTran(tran);
        if(flag){
            response.sendRedirect(request.getContextPath()+"/workbench/transaction/index.jsp");
        }
    }

    private void deleteContacts(HttpServletRequest request, HttpServletResponse response) {
        String[] id=request.getParameterValues("id");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag=tranService.deleteContacts(id);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void contactsList(HttpServletRequest request, HttpServletResponse response) {
        String customerId=request.getParameter("customerId");
        String fullname=request.getParameter("name");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        List<Contacts> list=tranService.getContactsList(customerId,fullname);
        boolean flag=false;
        if(list.size()!=0){
            flag=true;
        }
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("list",list);
        PrintJson.printJsonObj(response,map);
    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        String name=request.getParameter("name");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        List<String> list=tranService.getCustomer(name);
        PrintJson.printJsonObj(response,list);
    }

    private void activityList(HttpServletRequest request, HttpServletResponse response) {
        String name=request.getParameter("name");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        List<Activity> list =tranService.getActivityList(name);
        PrintJson.printJsonObj(response,list);

    }

    private void saveTran(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id= UUIDUtil.getUUID();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String createTime= DateTimeUtil.getSysTime();
        String owner =request.getParameter("owner");
        String money =request.getParameter("money");
        String name =request.getParameter("name");
        String expectedDate =request.getParameter("expectedDate");
        String customerId =request.getParameter("customerId");
        String stage =request.getParameter("stage");
        String type =request.getParameter("type");
        String source =request.getParameter("source");
        String activityId =request.getParameter("activityId");
        String contactsId =request.getParameter("contactsId");
        String description =request.getParameter("description");
        String contactSummary =request.getParameter("contactSummary");
        String nextContactTime =request.getParameter("nextContactTime");
        Tran tran=new Tran();
        tran.setOwner(owner);
        tran.setMoney(money);
        tran.setName(name);
        tran.setExpectedDate(expectedDate);
        tran.setCustomerId(customerId);
        tran.setStage(stage);
        tran.setType(type);
        tran.setSource(source);
        tran.setActivityId(activityId);
        tran.setContactsId(contactsId);
        tran.setDescription(description);
        tran.setContactSummary(contactSummary);
        tran.setNextContactTime(nextContactTime);
        tran.setId(id);
        tran.setCreateTime(createTime);
        tran.setCreateBy(createBy);
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag=tranService.saveTran(tran);
        if(flag){
            response.sendRedirect(request.getContextPath()+"/workbench/transaction/index.jsp");
        }
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        String owner=request.getParameter("owner");
        String name=request.getParameter("name");
        String customerId=request.getParameter("customerId");
        String stage=request.getParameter("stage");
        String type=request.getParameter("type");
        String source=request.getParameter("source");
        String contactsId=request.getParameter("contactsId");
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipNum=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("owner",owner);
        map.put("name",name);
        map.put("customerId",customerId);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contactsId",contactsId);
        map.put("skipNum",skipNum);
        map.put("pageSize",pageSize);
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        PaginationVo<Tran> paginationVo=tranService.pageList(map);
        PrintJson.printJsonObj(response,paginationVo);
    }
}
