package com.geng.crm.settings.workbench.web.controller;

import com.geng.crm.settings.domain.User;
import com.geng.crm.settings.service.UserService;
import com.geng.crm.settings.service.impl.UserServiceImpl;
import com.geng.crm.settings.workbench.domain.Activity;
import com.geng.crm.settings.workbench.domain.Contacts;
import com.geng.crm.settings.workbench.domain.ContactsRemark;
import com.geng.crm.settings.workbench.domain.CustomerRemark;
import com.geng.crm.settings.workbench.service.ContactsService;
import com.geng.crm.settings.workbench.service.CustomerService;
import com.geng.crm.settings.workbench.service.impl.ContactsServiceImpl;
import com.geng.crm.settings.workbench.service.impl.CustomerServiceImpl;
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

public class ContactsController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path=request.getServletPath();
        if("/workbench/contacts/pageList.do".equals(path)){
             pageList(request,response);
        }else if("/workbench/contacts/createContacts.do".equals(path)){
            createContacts(request,response);

        }else if("/workbench/contacts/updateContacts.do".equals(path)){
           Contacts contacts=getContacts(request,response);
           List<User> list=getUserList();
           /*userList contacts*/
           Map<String ,Object> map =new HashMap<String ,Object> ();
           map.put("userList",list);
           map.put("contacts",contacts);
           PrintJson.printJsonObj(response,map);
        }else if("/workbench/contacts/editContacts.do".equals(path)){
            updateContacts(request,response);
        }else if("/workbench/contacts/deleteContacts.do".equals(path)){
            deleteContacts(request,response);
        }else if("/workbench/contacts/detail.do".equals(path)){
            String id=request.getParameter("contactsId");
            ContactsService contactsService=(ContactsService)ServiceFactory.getService(new ContactsServiceImpl());
            Contacts contacts=contactsService.detail(id);
            request.setAttribute("contacts",contacts);
            request.getRequestDispatcher("/workbench/contacts/detail.jsp").forward(request,response);
        }else if("/workbench/contacts/saveRemark.do".equals(path)){
            saveRemark(request,response);
        } else if("/workbench/contacts/updateRemark.do".equals(path)){
            updateRemark(request,response);
        } else if("/workbench/contacts/deleteRemark.do".equals(path)){
              deleteRemark(request,response);
        }else if("/workbench/contacts/showRemark.do".equals(path)) {
            showRemark(request, response);
        }else if("/workbench/contacts/showRelation.do".equals(path)){
            showRelation(request,response);
        }else if("/workbench/contacts/searchBind.do".equals(path)){
            search(request,response);
        }else if("/workbench/contacts/bind.do".equals(path)){
            bind(request,response);
        }else if("/workbench/contacts/unbind.do".equals(path)){
            unbind(request,response);
        }
    }

    private void unbind(HttpServletRequest request, HttpServletResponse response) {
        String contactsId=request.getParameter("contactsId");
        String activityId=request.getParameter("activityId");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        contactsService.unbind(contactsId,activityId);
        PrintJson.printJsonFlag(response,"flag",true);
    }

    private void bind(HttpServletRequest request, HttpServletResponse response) {
        String contactsId=request.getParameter("contactsId");
        String[] activityId=request.getParameterValues("activityId");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        contactsService.bind(contactsId,activityId);
        PrintJson.printJsonFlag(response,"flag",true);
    }

    private void search(HttpServletRequest request, HttpServletResponse response) {
        String name=request.getParameter("name");
        String contactsId=request.getParameter("contactsId");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Activity> list=contactsService.search(name,contactsId);
        PrintJson.printJsonObj(response,list);
    }

    private void showRelation(HttpServletRequest request, HttpServletResponse response) {
        String contactsId=request.getParameter("contactsId");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Activity> list=contactsService.getRelationList(contactsId);
        PrintJson.printJsonObj(response,list);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag=contactsService.deleteRemark(id);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        String noteContent=request.getParameter("noteContent");
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editTime=DateTimeUtil.getSysTime();
        String editFlag="1";
        ContactsRemark contactsRemark=new ContactsRemark();

        contactsRemark.setId(id);
        contactsRemark.setNoteContent(noteContent);
        contactsRemark.setEditFlag(editFlag);
        contactsRemark.setEditTime(editTime);
        contactsRemark.setEditBy(editBy);
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());

        boolean flag=contactsService.updateRemark(contactsRemark);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("remark",contactsRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String contactsId=request.getParameter("contactsId");
        String noteContent=request.getParameter("noteContent");
        String id=UUIDUtil.getUUID();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String createTime=DateTimeUtil.getSysTime();
        String editFlag="0";
       ContactsRemark contactsRemark=new ContactsRemark();

        contactsRemark.setId(id);
        contactsRemark.setContactsId(contactsId);
        contactsRemark.setNoteContent(noteContent);
        contactsRemark.setEditFlag(editFlag);
        contactsRemark.setCreateTime(createTime);
        contactsRemark.setCreateBy(createBy);

        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag=contactsService.saveRemark(contactsRemark);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("remark",contactsRemark);
        PrintJson.printJsonObj(response,map);


    }

    private void showRemark(HttpServletRequest request, HttpServletResponse response) {
        String contactsId=request.getParameter("contactsId");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<ContactsRemark> list=contactsService.getRemarkList(contactsId);
        PrintJson.printJsonObj(response,list);
    }

    private void deleteContacts(HttpServletRequest request, HttpServletResponse response) {
        String[] ids=request.getParameterValues("contactsId");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag=contactsService.deleteContacts(ids);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void updateContacts(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editTime= DateTimeUtil.getSysTime();
        String owner=request.getParameter("owner");
        String source=request.getParameter("source");
        String customer=request.getParameter("customer");
        String fullname=request.getParameter("fullname");
        String appellation=request.getParameter("appellation");
        String email=request.getParameter("email");
        String mphone=request.getParameter("mphone");
        String job=request.getParameter("job");
        String birth=request.getParameter("birth");
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTim");
        String address=request.getParameter("address");
        Contacts contacts=new Contacts();
        contacts.setOwner(owner);
        contacts.setSource(source);
        contacts.setCustomerId(customer);
        contacts.setFullname(fullname);
        contacts.setAppellation(appellation);
        contacts.setJob(job);
        contacts.setEmail(email);
        contacts.setBirth(birth);
        contacts.setDescription(description);
        contacts.setContactSummary(contactSummary);
        contacts.setAddress(address);
        contacts.setMphone(mphone);
        contacts.setNextContactTime(nextContactTime);
        contacts.setId(id);
        contacts.setEditBy(editBy);
        contacts.setEditTime(editTime);

        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag=contactsService.updateContacts(contacts);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private List<User> getUserList() {
        UserService userService= (UserService) ServiceFactory.getService(new UserServiceImpl());
        return userService.getUserList();
    }

    private  Contacts getContacts(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("contactsId");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        return contactsService.getContacts(id);
    }

    private void createContacts(HttpServletRequest request, HttpServletResponse response) {
       String id= UUIDUtil.getUUID();
       String createBy=((User)request.getSession().getAttribute("user")).getName();
       String createTime= DateTimeUtil.getSysTime();
       String owner=request.getParameter("owner");
       String source=request.getParameter("source");
       String customer=request.getParameter("customer");
       String fullname=request.getParameter("fullname");
       String appellation=request.getParameter("appellation");
       String email=request.getParameter("email");
       String mphone=request.getParameter("mphone");
       String job=request.getParameter("job");
       String birth=request.getParameter("birth");
       String description=request.getParameter("description");
       String contactSummary=request.getParameter("contactSummary");
       String nextContactTime=request.getParameter("nextContactTim");
       String address=request.getParameter("address");
       Contacts contacts=new Contacts();
       contacts.setOwner(owner);
       contacts.setSource(source);
       contacts.setCustomerId(customer);
       contacts.setFullname(fullname);
       contacts.setAppellation(appellation);
       contacts.setJob(job);
       contacts.setEmail(email);
       contacts.setBirth(birth);
       contacts.setDescription(description);
       contacts.setContactSummary(contactSummary);
       contacts.setAddress(address);
       contacts.setMphone(mphone);
       contacts.setNextContactTime(nextContactTime);
       contacts.setId(id);
       contacts.setCreateBy(createBy);
       contacts.setCreateTime(createTime);

       ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
       boolean flag=contactsService.createContacts(contacts);
       PrintJson.printJsonFlag(response,"flag",flag);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipNum=(pageNo-1)*pageSize;
        String birth=request.getParameter("birth");
        String fullname=request.getParameter("fullname");
        String source=request.getParameter("source");
        String customer=request.getParameter("customer");
        String owner=request.getParameter("owner");
        Map<String, Object> map=new HashMap<String,Object>();
        System.out.println(map);
        map.put("skipNum",skipNum);
        map.put("pageSize",pageSize);
        map.put("birth",birth);
        map.put("fullname",fullname);
        map.put("source",source);
        map.put("customer",customer);
        map.put("owner",owner);
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        PaginationVo<Contacts> paginationVo=contactsService.pageList(map);
        PrintJson.printJsonObj(response,paginationVo);
    }
}
