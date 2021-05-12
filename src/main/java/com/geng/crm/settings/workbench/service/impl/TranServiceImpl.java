package com.geng.crm.settings.workbench.service.impl;

import com.geng.crm.settings.workbench.dao.*;
import com.geng.crm.settings.workbench.domain.*;
import com.geng.crm.settings.workbench.service.TranService;
import com.geng.crm.utils.DateTimeUtil;
import com.geng.crm.utils.SqlSessionUtil;
import com.geng.crm.utils.UUIDUtil;
import com.geng.crm.vo.PaginationVo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class TranServiceImpl implements TranService {
    TranDao tranDao= SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    CustomerDao customerDao=SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    TranHistoryDao tranHistoryDao=SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    ActivityDao activityDao=SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
     ContactsDao contactsDao=SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
     TranRemarkDao tranRemarkDao=SqlSessionUtil.getSqlSession().getMapper(TranRemarkDao.class);
    @Override
    public List<String> getCustomer(String name) {
        return customerDao.getCustomerName(name);
    }

    @Override
    public List<Activity> getActivityList(String name) {
        return activityDao.getActivityList(name);
    }

    @Override
    public List<Contacts> getContactsList(String customerId, String fullname) {
        return contactsDao.getContactsListS(customerId,fullname);
    }

    @Override
    public Map<String, Object> getTranECharts() {
        int total=tranDao.getTotalS();

        List<Map<String,Object>> list=tranDao.getDataList();

        Map<String,Object> map=new HashMap<String,Object>();
        map.put("total",total);
        map.put("dataList",list);
        return map;
    }

    @Override
    public Tran changeStage(TranHistory tranHistory) {
        if(tranDao.updateTranS(tranHistory)!=1){
            return null;
        }
        if(tranHistoryDao.saveHistory(tranHistory)!=1){
            return null;
        }
        Tran tran=tranDao.getTran(tranHistory.getTranId());
        tran.setPossibility(tranHistory.getPossibility());
        return  tran;
    }

    @Override
    public Tran getTran(String id) {
        return tranDao.getTran(id);
    }

    @Override
    public boolean deleteContacts(String[] id) {
        int count=tranDao.deleteContacts(id);
        if(count==id.length){
            return true;
        }
        return false;
    }

    @Override
    public List<TranHistory> showHistory(String tranId) {
        return tranHistoryDao.showHistory(tranId);
    }

    @Override
    public boolean updateRemark(TranRemark tranRemark) {
        if(tranRemarkDao.updateRemark(tranRemark)!=1){
            return false;
        }
        return true;
    }

    @Override
    public boolean deleteRemark(String id) {
        if(tranRemarkDao.deleteRemark(id)!=1){
            return false;
        }
        return true;
    }

    @Override
    public boolean saveRemark(TranRemark tranRemark) {
        if(tranRemarkDao.saveRemark(tranRemark)!=1){
            return false;
        }
        return true;
    }

    @Override
    public List<TranRemark> getRemark(String tranId) {
        return tranRemarkDao.getRemark(tranId);
    }

    @Override
    public Tran detail(String id) {
        return tranDao.detail(id);
    }

    @Override
    public boolean updateTran(Tran tran) {
        Customer customer=null;
        customer=customerDao.getCustomerByName(tran.getCustomerId());
        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(tran.getOwner());
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setName(tran.getCustomerId());
            customer.setContactSummary(tran.getContactSummary());
            customer.setDescription(tran.getDescription());
            customer.setNextContactTime(tran.getNextContactTime());
            if(customerDao.saveCustomer(customer)!=1){
                return false;
            }
        }
        tran.setCustomerId(customer.getId());
        Contacts contacts=null;
        contacts=contactsDao.getContacts(tran.getContactsId());
        if(contacts==null){
            contacts=new Contacts();
            contacts.setId(UUIDUtil.getUUID());
            contacts.setOwner(tran.getOwner());
            contacts.setFullname(tran.getContactsId());
            contacts.setCustomerId(tran.getCustomerId());
            contacts.setAddress(customer.getAddress());
            contacts.setCreateBy(tran.getCreateBy());
            contacts.setCreateTime(DateTimeUtil.getSysTime());
            contacts.setContactSummary(tran.getContactSummary());
            contacts.setDescription(tran.getDescription());
            contacts.setNextContactTime(tran.getNextContactTime());
            if(contactsDao.saveContact(contacts)!=1){
                return false;
            }
        }
        tran.setContactsId(contacts.getId());
        if(tranDao.updateTran(tran)!=1){
            return false;
        }
        TranHistory tranHistory=new TranHistory();
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());
        if(tranHistoryDao.saveHistory(tranHistory)!=1){
            return false;
        }
        return true;
    }
    @Override
    public boolean saveTran(Tran tran) {
        Customer customer=null;
        customer=customerDao.getCustomerByName(tran.getCustomerId());
        if(customer==null){
            customer=new Customer();

            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(tran.getOwner());
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setName(tran.getCustomerId());
            customer.setContactSummary(tran.getContactSummary());
            customer.setDescription(tran.getDescription());
            customer.setNextContactTime(tran.getNextContactTime());

            if(customerDao.saveCustomer(customer)!=1){
                return false;
            }
        }
        tran.setCustomerId(customer.getId());
        Contacts contacts=null;
        contacts=contactsDao.getContacts(tran.getContactsId());
        if(contacts==null){
            contacts=new Contacts();
            contacts.setId(UUIDUtil.getUUID());
            contacts.setOwner(tran.getOwner());
            contacts.setFullname(tran.getContactsId());
            contacts.setCustomerId(tran.getCustomerId());
            contacts.setAddress(customer.getAddress());
            contacts.setCreateBy(tran.getCreateBy());
            contacts.setCreateTime(DateTimeUtil.getSysTime());
            contacts.setContactSummary(tran.getContactSummary());
            contacts.setDescription(tran.getDescription());
            contacts.setNextContactTime(tran.getNextContactTime());
            if(contactsDao.saveContact(contacts)!=1){
                return false;
            }
        }
        tran.setContactsId(contacts.getId());
        if(tranDao.saveTran(tran)!=1){
            return false;
        }
        TranHistory tranHistory=new TranHistory();
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());
        if(tranHistoryDao.saveHistory(tranHistory)!=1){
            return false;
        }
        return true;
    }

    @Override
    public PaginationVo<Tran> pageList(Map<String, Object> map) {
        int total=tranDao.getTotal(map);
        List<Tran> list=tranDao.getTranList(map);
        PaginationVo<Tran> paginationVo=new PaginationVo<Tran>();
        paginationVo.setTotal(total);
        paginationVo.setDataList(list);
        return paginationVo;
    }
}
