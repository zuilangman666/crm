package com.geng.crm.settings.web.controller;

import com.geng.crm.exceptions.LoginExce;
import com.geng.crm.settings.domain.User;
import com.geng.crm.settings.service.UserService;
import com.geng.crm.settings.service.impl.UserServiceImpl;
import com.geng.crm.utils.MD5Util;
import com.geng.crm.utils.PrintJson;
import com.geng.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到用户控制器");
        String path=request.getServletPath();
        if("/settings/user/login.do".equals(path)){
            //System.out.println(1);
            login(request,response);
        }
        else if("".equals(path)){

        }
    }
    private void login(HttpServletRequest request,HttpServletResponse response){
        String loginAct=request.getParameter("loginAct");
        String loginPwd=request.getParameter("loginPwd");
        loginPwd= MD5Util.getMD5(loginPwd);
        String ip=request.getRemoteAddr();
        //System.out.println(ip+"+++++"+"  "+loginAct+"  "+loginPwd);
        UserService userService=(UserService) ServiceFactory.getService(new UserServiceImpl());
        try{
            System.out.println(22222);
            User user=userService.login(loginAct,loginPwd,ip);
            PrintJson.printJsonFlag(response,"flag",true);
            request.getSession().setAttribute("user",user);
            //System.out.println(user.toString());
        }
        catch (LoginExce e){
            //e.printStackTrace();
            String msg=e.getMessage();
            System.out.println("------------------"+msg+"--------------------------------");
            Map<String,Object> map=new HashMap<String,Object>();
            map.put("flag",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }
}
