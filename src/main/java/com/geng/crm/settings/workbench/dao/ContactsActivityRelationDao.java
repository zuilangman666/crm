package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.Activity;
import com.geng.crm.settings.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationDao {

    int saveRelation(ContactsActivityRelation contactsActivityRelation);

    void deleteRelation(String[] ids);

    List<Activity> getRelationList(String contactsId);

    List<Activity> search(String name,String contactsId);

    void create(String contactsId, String s, String uuid);

    void delete(String contactsId, String activityId);
}
