package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.Tran;
import com.geng.crm.settings.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int saveTran(Tran tran);

    List<Tran> getTranList(Map<String, Object> map);

    int getTotal(Map<String, Object> map);

    int deleteContacts(String[] id);

    Tran getTran(String id);

    int updateTran(Tran tran);

    Tran detail(String id);

    int updateTranS(TranHistory tranHistory);

    int getTotalS();

    List<Map<String, Object>> getDataList();
}
