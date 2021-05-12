package com.geng.crm.settings.workbench.service;

import com.geng.crm.settings.workbench.domain.Activity;
import com.geng.crm.settings.workbench.domain.Contacts;
import com.geng.crm.settings.workbench.domain.ContactsRemark;
import com.geng.crm.vo.PaginationVo;

import java.util.List;
import java.util.Map;

public interface ContactsService {
    PaginationVo<Contacts> pageList(Map<String, Object> map);

    boolean createContacts(Contacts contacts);

    Contacts getContacts(String id);

    boolean updateContacts(Contacts contacts);

    boolean deleteContacts(String[] ids);

    Contacts detail(String id);

    List<ContactsRemark> getRemarkList(String contactsId);

    boolean saveRemark(ContactsRemark contactsRemark);

    boolean updateRemark(ContactsRemark contactsRemark);

    boolean deleteRemark(String id);

    List<Activity> getRelationList(String contactsId);

    List<Activity> search(String name,String contactsId);

    void bind(String contactsId, String[] activityId);

    void unbind(String contactsId, String activityId);

    Contacts getContactsS(String contactsId);
}
