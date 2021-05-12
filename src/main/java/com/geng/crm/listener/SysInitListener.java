package com.geng.crm.listener;

import com.geng.crm.settings.domain.DicValue;
import com.geng.crm.settings.service.DicService;
import com.geng.crm.settings.service.impl.DicServiceImpl;
import com.geng.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {
    //该方法是上下文域对象的监听器方法，当系统中创建完毕上下文域对象之后，就会执行该方法
    //event该参数可以获取监听的对象，监听的什么对象我们就可以通过该参数获取什么对象
    //当前我们监听的是上下文域对象，就可以通过event获取上下文域对象
    public void contextInitialized(ServletContextEvent event){
        System.out.println("正在获取数据字典");
        ServletContext application=event.getServletContext();
        DicService dicService=(DicService) ServiceFactory.getService(new DicServiceImpl());
        //得到一个Map<String,List<DicValue> >
        Map<String, List<DicValue> > map=dicService.getAll();
        //将map转换  保存到application当中
        for(String temp:map.keySet()){
            List<DicValue> list=map.get(temp);
            application.setAttribute(temp,list);
        }


        System.out.println("正在解析Stage2Possibility.properties文件");
        Map<String,String > pMap=new HashMap<String,String>();
        ResourceBundle rb=ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> e=rb.getKeys();//一个枚举类型的数组
        while(e.hasMoreElements()){
            String key=e.nextElement();
            String value=rb.getString(key);
            pMap.put(key,value);
        }
        application.setAttribute("pMap",pMap);
    }
}
