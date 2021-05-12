package com.geng.crm.settings.dao;

import com.geng.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    //public User login(Map<String,String> map);
    public User login(String loginAct,String loginPwd);

    public List<User> getUserList();

    User getUser(String owner);
}
