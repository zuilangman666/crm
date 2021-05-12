package com.geng.crm.filter;

import com.geng.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request=(HttpServletRequest)servletRequest;
        HttpServletResponse response=(HttpServletResponse)servletResponse;
        User user=(User)request.getSession().getAttribute("user");
        /*
        * 在实际项目开发中，无论是重定向还是请求转发，我们都应该使用绝对路径
        * 重定向：/crm/login.jsp
        * 请求转发：这个方式的路径比较特殊，因为它使用的是内部路径   /login.jsp
        *这个因为我们在验证该用户没有登陆过以后，我们要跳转到login.jsp，如果使用请求转发的是不会改变地址的，所以要使用重定向。
        *
        * */
        /*
        * 由于会拦截所有的.jsp .do请求，所以需要将login.do  和login.jsp放行
        * */
        String path=request.getServletPath();
        if("/settings/user/login.do".equals(path)||"/login.jsp".equals(path)){
            filterChain.doFilter(servletRequest,servletResponse);
        }
        else{
            if(user==null){
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }
            else{
                filterChain.doFilter(servletRequest,servletResponse);
            }
        }
    }
}
