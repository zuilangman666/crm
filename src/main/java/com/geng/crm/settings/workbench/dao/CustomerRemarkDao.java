package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {

    int saveRemark(CustomerRemark customerRemark);

    void deleteRemarkList(String[] ids);

    List<CustomerRemark> getRemark(String customerId);

    int deleteRemark(String id);

    int updateRemark(CustomerRemark customerRemark);
}
