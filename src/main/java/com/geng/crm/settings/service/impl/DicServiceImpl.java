package com.geng.crm.settings.service.impl;

import com.geng.crm.settings.dao.DicTypeDao;
import com.geng.crm.settings.dao.DicValueDao;
import com.geng.crm.settings.domain.DicType;
import com.geng.crm.settings.domain.DicValue;
import com.geng.crm.settings.service.DicService;
import com.geng.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DicServiceImpl implements DicService {
    private DicTypeDao dicTypeDao = SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);
    private DicValueDao dicValueDao=SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);

    @Override
    public Map<String, List<DicValue>> getAll() {
        Map<String,List<DicValue>> map=new HashMap<String,List<DicValue>>();
        List<DicType> dicTypeList=dicTypeDao.getAll();
        for(DicType temp:dicTypeList){
            String str=temp.getCode();
            List<DicValue> dicValueList=dicValueDao.getValueByCode(str);
            map.put(str+"List",dicValueList);
        }
        return map;
    }
}
