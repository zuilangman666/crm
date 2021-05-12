package com.geng.crm.settings.service;

import com.geng.crm.exceptions.LoginExce;
import com.geng.crm.settings.domain.User;

import java.util.List;

public interface UserService {

    User login(String loginAct, String loginPwd, String ip) throws LoginExce;

    List<User> getUserList();

    User getUser(String owner);
}
