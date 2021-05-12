import com.geng.crm.utils.DateTimeUtil;
import com.geng.crm.utils.MD5Util;
import org.junit.Test;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Test01 {
    @Test
    public void test01(){
        //失效时间
        String expireTime="2021-12-12 12:12:12";
        //锁定状态
        String lockState="0";
        //允许访问的ip地址
        String allowIps="192.168.1.1,192.168.1.2,192.168.1.3,192.168.1.4";
       //当前时间

        //方法1
        /*SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date=new Date();
        String time=simpleDateFormat.format(date);
        System.out.println(time);*/

        //方法2
        /*String time= DateTimeUtil.getSysTime();
        int flag=time.compareTo(expireTime);
        System.out.println(flag);*/
      /*  if("0".equals(lockState)){
            System.out.println("账号已经被锁定");
        }
*/
   /*   String ip="192.169.0.12";
      if(allowIps.contains(ip)){
          System.out.println("ip可以访问");
      }
      else{
          System.out.println("ip不可以访问");
      }*/
      String  psw="775216049gyp";
      String md5= MD5Util.getMD5(psw);
      System.out.println(md5);
    }
}
