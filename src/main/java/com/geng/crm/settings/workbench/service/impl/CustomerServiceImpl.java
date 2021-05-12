package com.geng.crm.settings.workbench.service.impl;

import com.geng.crm.settings.workbench.dao.ContactsDao;
import com.geng.crm.settings.workbench.dao.CustomerDao;
import com.geng.crm.settings.workbench.dao.CustomerRemarkDao;
import com.geng.crm.settings.workbench.domain.Contacts;
import com.geng.crm.settings.workbench.domain.Customer;
import com.geng.crm.settings.workbench.domain.CustomerRemark;
import com.geng.crm.settings.workbench.service.CustomerService;
import com.geng.crm.utils.SqlSessionUtil;
import com.geng.crm.vo.PaginationVo;

import java.util.List;
import java.util.Map;

public class CustomerServiceImpl implements CustomerService {
    private CustomerDao customerDao= SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao=SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);
    private ContactsDao contactsDao=SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    @Override
    public PaginationVo<Customer> pageList(Map<String, Object> map) {
        int total=customerDao.getTotal(map);
        List<Customer> list=customerDao.getCustomerList(map);
        PaginationVo<Customer> paginationVo=new PaginationVo<Customer>();
        paginationVo.setDataList(list);
        paginationVo.setTotal(total);
        return paginationVo;
    }

    @Override
    public boolean createCustomer(Customer customer) {
        if(customerDao.saveCustomer(customer)!=1){
            return false;
        }
        return true;
    }

    @Override
    public boolean deleteCustomerList(String[] ids) {

        if(customerDao.deleteCustomerList(ids)==ids.length){
            customerRemarkDao.deleteRemarkList(ids);
            return true;
        }
        for(int i=0;i<ids.length;i++){

        }
        return false;
    }

    @Override
    public void deleteContacts(String contactsId) {
        contactsDao.deleteContact(contactsId);
    }

    @Override
    public List<Contacts> showContactsList(String customerId) {
        return contactsDao.showContacts(customerId);
    }

    @Override
    public boolean updateRemark(CustomerRemark customerRemark) {
        if(customerRemarkDao.updateRemark(customerRemark)!=1){
            return false;
        }
        return true;
    }

    @Override
    public boolean deleteRemark(String id) {
        if(customerRemarkDao.deleteRemark(id)!=1){
            return false;
        }
        return true;
    }

    @Override
    public boolean saveRemark(CustomerRemark customerRemark) {
        if(customerRemarkDao.saveRemark(customerRemark)!=1){
            return false;
        }
        return true;
    }

    @Override
    public List<Map<String, Object>> getCustomerECharts() {
        return customerDao.getCustomerECharts();
    }

    @Override
    public List<CustomerRemark> getCustomerRemark(String customerId) {
        return customerRemarkDao.getRemark(customerId);
    }

    @Override
    public boolean updateCustomer(Customer customer) {
        if(customerDao.updateCustomer(customer)!=1){
            return false;
        }
        return true;
    }

    @Override
    public Customer getCustomer(String id) {
        return customerDao.getCustomer(id);
    }
}
