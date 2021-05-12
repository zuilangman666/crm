package com.geng.crm.settings.workbench.service;

import com.geng.crm.settings.workbench.domain.Contacts;
import com.geng.crm.settings.workbench.domain.Customer;
import com.geng.crm.settings.workbench.domain.CustomerRemark;
import com.geng.crm.vo.PaginationVo;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    PaginationVo<Customer> pageList(Map<String, Object> map);

    boolean createCustomer(Customer customer);

    Customer getCustomer(String id);

    boolean updateCustomer(Customer customer);

    boolean deleteCustomerList(String[] ids);

    List<CustomerRemark> getCustomerRemark(String customerId);

    boolean saveRemark(CustomerRemark customerRemark);

    boolean deleteRemark(String id);

    boolean updateRemark(CustomerRemark customerRemark);

    List<Contacts> showContactsList(String customerId);

    void deleteContacts(String contactsId);

    List<Map<String, Object>> getCustomerECharts();
}
