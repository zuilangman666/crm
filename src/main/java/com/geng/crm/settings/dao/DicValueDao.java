package com.geng.crm.settings.dao;

import com.geng.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getValueByCode(String str);
}
