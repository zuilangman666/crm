package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkDao {

    int saveRemark(ContactsRemark contactsRemark);

    void deleteRemark(String[] ids);

    List<ContactsRemark> getRemarkList(String contactsId);

    int updateRemark(ContactsRemark contactsRemark);

    int deleteRemarkSSS(String id);
}
