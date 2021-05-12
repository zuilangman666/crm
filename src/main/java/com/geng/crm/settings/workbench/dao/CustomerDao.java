package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

   Customer getCustomerByName(String company);

    int saveCustomer(Customer customer);

    List<Customer> getCustomerList(Map<String, Object> map);

    int getTotal(Map<String, Object> map);

    Customer getCustomer(String id);

    int updateCustomer(Customer customer);

    int deleteCustomerList(String[] ids);

    List<String> getCustomerName(String name);

    List<Map<String, Object>> getCustomerECharts();
}
