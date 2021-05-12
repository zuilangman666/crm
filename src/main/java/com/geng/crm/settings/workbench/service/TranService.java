package com.geng.crm.settings.workbench.service;

import com.geng.crm.settings.workbench.domain.*;
import com.geng.crm.vo.PaginationVo;

import java.util.List;
import java.util.Map;

public interface TranService {
    PaginationVo<Tran> pageList(Map<String, Object> map);

    boolean saveTran(Tran tran);

    List<Activity> getActivityList(String name);

    List<String> getCustomer(String name);

    List<Contacts> getContactsList(String customerId, String fullname);

    boolean deleteContacts(String[] id);

    Tran getTran(String id);

    boolean updateTran(Tran tran);

    Tran detail(String id);

    List<TranRemark> getRemark(String tranId);

    boolean saveRemark(TranRemark tranRemark);

    boolean deleteRemark(String id);

    boolean updateRemark(TranRemark tranRemark);

    List<TranHistory> showHistory(String tranId);

    Tran changeStage(TranHistory tranHistory);

    Map<String, Object> getTranECharts();
}
