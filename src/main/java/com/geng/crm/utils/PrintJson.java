package com.geng.crm.utils;

import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;


public class PrintJson {
    public static void printJsonFlag(HttpServletResponse response,String msg,boolean flag){
        Map<String,Boolean> map=new HashMap<String,Boolean>();
        map.put(msg,flag);
        ObjectMapper om=new ObjectMapper();
        try{
            String json=om.writeValueAsString(map);
            System.out.println(json);
            response.getWriter().println(json);
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }
    public  static void printJsonObj(HttpServletResponse response,Object obj){
        ObjectMapper om=new ObjectMapper();
        try{
            String json=om.writeValueAsString(obj);
            response.getWriter().println(json);
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }
}
