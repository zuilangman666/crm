package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsDao {

    int saveContact(Contacts contacts);

    int getTotal(Map<String, Object> map);

    List<Contacts> getContactsList(Map<String, Object> map);

    Contacts getContacts(String id);

    int updateContacts(Contacts contacts);

    int deleteContacts(String[] ids);

    Contacts getContactsSSS(String id);

    List<Contacts> showContacts(String customerId);

    void deleteContact(String contactsId);

    List<Contacts> getContactsListS(String customerId, String fullname);

    List<Contacts> getContactsListSS(String fullname);


    Contacts getContactS(String contactsId);
}
