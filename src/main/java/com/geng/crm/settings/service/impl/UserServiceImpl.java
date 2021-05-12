package com.geng.crm.settings.service.impl;

import com.geng.crm.exceptions.LoginExce;
import com.geng.crm.settings.dao.UserDao;
import com.geng.crm.settings.domain.User;
import com.geng.crm.settings.service.UserService;
import com.geng.crm.utils.DateTimeUtil;
import com.geng.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {
    private UserDao userDao= SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public List<User> getUserList() {
        return userDao.getUserList();
    }

    @Override
    public User getUser(String owner) {
        return userDao.getUser(owner);
    }

    @Override
    public User login(String loginAct, String loginPwd, String ip)throws LoginExce {
       /* Map<String,String>map =new HashMap<String,String>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);*/
        User user=userDao.login(loginAct,loginPwd);
        //System.out.println(user.toString());
        if(user==null){
            throw new LoginExce("账号密码错误");
        }

        if(DateTimeUtil.getSysTime().compareTo(user.getExpireTime())>0){
            throw new LoginExce("账号已经过期");
        }

        /*if(user.getAllowIps()==null||!user.getAllowIps().contains(ip)){
          //  System.out.println("+++++"+user.getAllowIps()+"++++++"+ip);
            throw new LoginExce("账号登录ip有问题");
        }*/

        if("0".equals(user.getLockState())){
            throw new LoginExce("账号已经被锁定");
        }
        return user;
    }
}
