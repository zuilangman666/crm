package com.geng.crm.settings.workbench.dao;

import com.geng.crm.settings.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int saveHistory(TranHistory tranHistory);

    List<TranHistory> showHistory(String tranId);
}
