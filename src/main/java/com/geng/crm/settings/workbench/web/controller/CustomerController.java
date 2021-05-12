package com.geng.crm.settings.workbench.web.controller;

import com.geng.crm.settings.domain.User;
import com.geng.crm.settings.service.UserService;
import com.geng.crm.settings.service.impl.UserServiceImpl;
import com.geng.crm.settings.workbench.domain.Contacts;
import com.geng.crm.settings.workbench.domain.Customer;
import com.geng.crm.settings.workbench.domain.CustomerRemark;
import com.geng.crm.settings.workbench.service.CustomerService;
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

public class CustomerController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path=request.getServletPath();
        if("/workbench/customer/pageList.do".equals(path)){
            pageList(request,response);

        }else if("/workbench/customer/createCustomer.do".equals(path)){
             createCustomer(request,response);
        }else if("/workbench/customer/updateCustomer.do".equals(path)){
            List<User> list=getUserList();
            Customer customer=getCustomer(request,response);
            Map<String,Object> map =new HashMap<String,Object>();
            map.put("userList",list);
            map.put("customer",customer);
            PrintJson.printJsonObj(response,map);
        }else if("/workbench/customer/editCustomer.do".equals(path)){
            updateCustomer(request,response);
        }else if("/workbench/customer/deleteCustomer.do".equals(path)){
            deleteCustomer(request,response);
        }else if("/workbench/customer/detail.do".equals(path)){
            String id=request.getParameter("customerId");
            Customer customer=getCustomer(request,response);
            User user=getUser(customer.getOwner());
            request.setAttribute("customer",customer);
            request.setAttribute("user",user);
            request.getRequestDispatcher("/workbench/customer/detail.jsp").forward(request,response);
        }else if("/workbench/customer/showRemark.do".equals(path)){
            showRemark(request,response);
        }else if("/workbench/customer/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if("/workbench/customer/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }else if("/workbench/customer/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }else if("/workbench/customer/showContacts.do".equals(path)){
            showContacts(request,response);
        }else if("/workbench/customer/deleteContacts.do".equals(path)){
            deleteContacts(request,response);
        }else if("/workbench/transaction/getCustECharts.do".equals(path)){
            getCustECharts(request,response);
        }
    }

    private void getCustECharts(HttpServletRequest request, HttpServletResponse response) {
        CustomerService customerService=(CustomerService)ServiceFactory.getService(new CustomerServiceImpl());
        List<Map<String,Object>> map=customerService.getCustomerECharts();
        PrintJson.printJsonObj(response,map);
    }

    private void deleteContacts(HttpServletRequest request, HttpServletResponse response) {
        String contactsId=request.getParameter("contactsId");
        CustomerService customerService=(CustomerService)ServiceFactory.getService(new CustomerServiceImpl());
        customerService.deleteContacts(contactsId);
        PrintJson.printJsonFlag(response,"flag",true);
    }

    private void showContacts(HttpServletRequest request, HttpServletResponse response) {
        String customerId=request.getParameter("customerId");
        CustomerService customerService=(CustomerService)ServiceFactory.getService(new CustomerServiceImpl());
        List<Contacts> list=customerService.showContactsList(customerId);
        PrintJson.printJsonObj(response,list);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        String noteContent=request.getParameter("noteContent");
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editTime=DateTimeUtil.getSysTime();
        String editFlag="1";
        CustomerRemark customerRemark=new CustomerRemark();

        customerRemark.setId(id);
        customerRemark.setNoteContent(noteContent);
        customerRemark.setEditFlag(editFlag);
        customerRemark.setEditTime(editTime);
        customerRemark.setEditBy(editBy);

        CustomerService customerService=(CustomerService)ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag=customerService.updateRemark(customerRemark);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("remark",customerRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
         String id=request.getParameter("id");
         CustomerService customerService=(CustomerService)ServiceFactory.getService(new CustomerServiceImpl());
         boolean flag=customerService.deleteRemark(id);

         PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String id=UUIDUtil.getUUID();
        String noteContent=request.getParameter("noteContent");
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String createTime=DateTimeUtil.getSysTime();
        String editFlag="0";
        String customerId=request.getParameter("customerId");
        CustomerRemark customerRemark=new CustomerRemark();

        customerRemark.setId(id);
        customerRemark.setCustomerId(customerId);
        customerRemark.setNoteContent(noteContent);
        customerRemark.setEditFlag(editFlag);
        customerRemark.setCreateTime(createTime);
        customerRemark.setCreateBy(createBy);

        CustomerService customerService=(CustomerService)ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag=customerService.saveRemark(customerRemark);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("flag",flag);
        map.put("remark",customerRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void showRemark(HttpServletRequest request, HttpServletResponse response) {
        String customerId=request.getParameter("customerId");
        CustomerService customerService=(CustomerService)ServiceFactory.getService(new CustomerServiceImpl());
        List<CustomerRemark> list=customerService.getCustomerRemark(customerId);
        PrintJson.printJsonObj(response,list);
    }

    private User getUser(String owner) {
        UserService userService=(UserService)ServiceFactory.getService(new UserServiceImpl());
        return userService.getUser(owner);
    }

    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response) {
        String[] ids=request.getParameterValues("customerId");
        CustomerService customerService=(CustomerService)ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag=customerService.deleteCustomerList(ids);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editTime= DateTimeUtil.getSysTime();
        String owner=request.getParameter("owner");
        String name=request.getParameter("name");
        String website=request.getParameter("website");
        String phone=request.getParameter("phone");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String description=request.getParameter("description");
        String address=request.getParameter("address");
        Customer customer=new Customer();
        customer.setAddress(address);
        customer.setDescription(description);
        customer.setNextContactTime(nextContactTime);
        customer.setEditTime(editTime);
        customer.setContactSummary(contactSummary);
        customer.setName(name);
        customer.setOwner(owner);
        customer.setEditBy(editBy);
        customer.setId(id);
        customer.setPhone(phone);
        customer.setWebsite(website);
        CustomerService customerService=(CustomerService)ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag=customerService.updateCustomer(customer);
        PrintJson.printJsonFlag(response,"flag",flag);
    }

    private Customer getCustomer(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("customerId");
        CustomerService customerService=(CustomerService)ServiceFactory.getService(new CustomerServiceImpl());
        return customerService.getCustomer(id);
    }

    private List<User> getUserList() {
        UserService userService=(UserService)ServiceFactory.getService(new UserServiceImpl());
        return userService.getUserList();
    }

    private void createCustomer(HttpServletRequest request, HttpServletResponse response) {
        String id= UUIDUtil.getUUID();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String createTime= DateTimeUtil.getSysTime();
        String owner=request.getParameter("owner");
        String name=request.getParameter("name");
        String website=request.getParameter("website");
        String phone=request.getParameter("phone");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String description=request.getParameter("description");
        String address=request.getParameter("address");
        Customer customer=new Customer();
        customer.setAddress(address);
        customer.setDescription(description);
        customer.setNextContactTime(nextContactTime);
        customer.setCreateTime(createTime);
        customer.setContactSummary(contactSummary);
        customer.setName(name);
        customer.setOwner(owner);
        customer.setCreateBy(createBy);
        customer.setId(id);
        customer.setPhone(phone);
        customer.setWebsite(website);
        CustomerService customerService=(CustomerService)ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag=customerService.createCustomer(customer);
        PrintJson.printJsonFlag(response,"flag",flag);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipNum=(pageNo-1)*pageSize;
        String name=request.getParameter("name");
        String website=request.getParameter("website");
        String owner=request.getParameter("owner");
        String phone=request.getParameter("phone");
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("name",name);
        map.put("website",website);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("pageSize",pageSize);
        map.put("skipNum",skipNum);
        CustomerService customerService=(CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        PaginationVo<Customer> paginationVo=customerService.pageList(map);
        PrintJson.printJsonObj(response,paginationVo);
    }
}
