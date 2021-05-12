package com.geng.crm.settings.workbench.service.impl;

import com.geng.crm.settings.workbench.dao.ContactsActivityRelationDao;
import com.geng.crm.settings.workbench.dao.ContactsDao;
import com.geng.crm.settings.workbench.dao.ContactsRemarkDao;
import com.geng.crm.settings.workbench.dao.CustomerDao;
import com.geng.crm.settings.workbench.domain.*;
import com.geng.crm.settings.workbench.service.ContactsService;
import com.geng.crm.utils.DateTimeUtil;
import com.geng.crm.utils.SqlSessionUtil;
import com.geng.crm.utils.UUIDUtil;
import com.geng.crm.vo.PaginationVo;

import java.util.List;
import java.util.Map;

public class ContactsServiceImpl implements ContactsService {
    private ContactsDao contactsDao= SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private CustomerDao customerDao=SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao=SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
    private ContactsRemarkDao  contactsRemarkDao =SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    @Override
    public PaginationVo<Contacts> pageList(Map<String, Object> map) {
        int total =contactsDao.getTotal(map);
        //System.out.println("----------------"+total);
        List<Contacts> list=contactsDao.getContactsList(map);
        PaginationVo<Contacts> paginationVo=new PaginationVo<Contacts>();
        paginationVo.setTotal(total);
        paginationVo.setDataList(list);
        return paginationVo;
    }

    @Override
    public boolean deleteContacts(String[] ids) {
        int count=contactsDao.deleteContacts(ids);
        contactsActivityRelationDao.deleteRelation(ids);
        contactsRemarkDao.deleteRemark(ids);

        if(count==ids.length){
            return true;
        }
        return false;
    }

    @Override
    public void unbind(String contactsId, String activityId) {
        contactsActivityRelationDao.delete(contactsId,activityId);
    }

    @Override
    public Contacts getContactsS(String contactsId) {
        return contactsDao.getContactS(contactsId);
    }

    @Override
    public void bind(String contactsId, String[] activityId) {
        for(int i=0;i<activityId.length;i++){
            contactsActivityRelationDao.create(contactsId,activityId[i],UUIDUtil.getUUID());
        }
    }

    @Override
    public List<Activity> search(String name,String contactsId) {
        return contactsActivityRelationDao.search(name,contactsId);
    }

    @Override
    public List<Activity> getRelationList(String contactsId) {
        return contactsActivityRelationDao.getRelationList(contactsId);
    }

    @Override
    public boolean deleteRemark(String id) {
        if(contactsRemarkDao.deleteRemarkSSS(id)!=1){
            return false;
        }
        return true;
    }

    @Override
    public boolean updateRemark(ContactsRemark contactsRemark) {
        if(contactsRemarkDao.updateRemark(contactsRemark)!=1){
            return false;
        }
        return true;
    }

    @Override
    public Contacts getContacts(String id) {
        return contactsDao.getContacts(id);
    }

    @Override
    public boolean saveRemark(ContactsRemark contactsRemark) {
        if(contactsRemarkDao.saveRemark(contactsRemark)!=1){
            return false;
        }
        return true;
    }

    @Override
    public List<ContactsRemark> getRemarkList(String contactsId) {
        return contactsRemarkDao.getRemarkList(contactsId);
    }

    @Override
    public Contacts detail(String id) {
        return contactsDao.getContactsSSS(id);
    }

    @Override
    public boolean updateContacts(Contacts contacts) {
        String name=contacts.getCustomerId();
        Customer customer=null;
        customer=customerDao.getCustomerByName(name);
        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(contacts.getOwner());
            customer.setCreateBy(contacts.getCreateBy());
            customer.setName(contacts.getCustomerId());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setContactSummary(contacts.getContactSummary());
            customer.setNextContactTime(contacts.getNextContactTime());
            customer.setDescription(contacts.getDescription());
            customer.setAddress(contacts.getAddress());

            if(customerDao.saveCustomer(customer)!=1){
                return false;
            }
        }
        contacts.setCustomerId(customer.getId());
        int count =contactsDao.updateContacts(contacts);
        if(count!=1){
            return false;
        }
        return true;
    }

    @Override
    public boolean createContacts(Contacts contacts) {
        String name=contacts.getCustomerId();
        Customer customer=null;
        customer=customerDao.getCustomerByName(name);
        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(contacts.getOwner());
            customer.setCreateBy(contacts.getCreateBy());
            customer.setName(contacts.getCustomerId());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setContactSummary(contacts.getContactSummary());
            customer.setNextContactTime(contacts.getNextContactTime());
            customer.setDescription(contacts.getDescription());
            customer.setAddress(contacts.getAddress());

            if(customerDao.saveCustomer(customer)!=1){
                return false;
            }
        }
        contacts.setCustomerId(customer.getId());
        if(contactsDao.saveContact(contacts)!=1){
            return false;
        }
        return true;
    }
}
