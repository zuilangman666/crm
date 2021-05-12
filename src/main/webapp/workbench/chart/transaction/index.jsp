<%@ page import="com.geng.crm.settings.domain.DicValue" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
 String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+
    request.getContextPath()+"/";
%>
<%

    List<DicValue> list=(List<DicValue>) application.getAttribute("stageList");
    List<String> stageArray=new ArrayList<String>();
    for(DicValue temp:list){
        stageArray.add(temp.getText());
    }
String[] str=stageArray.toArray(new String[stageArray.size()]);
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <script type="text/javascript" src="ECharts/echarts.min.js"></script>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript">
        $(function () {
              alert(<%=str%>)
        })

    </script>
    <script type="text/javascript">
        $(function () {

           $.ajax({
               url:"workbench/transaction/getTranECharts.do",
               dataType:"json",
               type:"get",
               success:function (data) {
                  // alert(data.total+"  "+data.dataList);
                   // 基于准备好的dom，初始化echarts实例
                   var myChart = echarts.init(document.getElementById('main'));
                   var option = {
                       title: {
                           text: '交易漏斗图',
                           subtext: 'crm2021'
                       },
                       tooltip: {
                           trigger: 'item',
                           formatter: "{a} <br/>{b} : {c}%"
                       },
                       toolbox: {
                           feature: {
                               dataView: {readOnly: false},
                               restore: {},
                               saveAsImage: {}
                           }
                       },
                       series: [
                           {
                               name:'漏斗图',
                               type:'funnel',
                               left: '10%',
                               top: 60,
                               bottom: 60,
                               width: '80%',
                               min: 0,
                               max:data.total,
                               minSize: '0%',
                               maxSize: '100%',
                               sort: 'descending',
                               gap: 2,
                               label: {
                                   show: true,
                                   position: 'inside'
                               },
                               labelLine: {
                                   length: 10,
                                   lineStyle: {
                                       width: 1,
                                       type: 'solid'
                                   }
                               },
                               itemStyle: {
                                   borderColor: '#fff',
                                   borderWidth: 1
                               },
                               emphasis: {
                                   label: {
                                       fontSize: 20
                                   }
                               },
                               data:data.dataList

                           }
                       ]
                   };
                   // 使用刚指定的配置项和数据显示图表。
                   myChart.setOption(option);

               }
           })
        })
    </script>
</head>
<body>

    <div id="main" style="width: 600px;height:400px;"></div>

</body>
</html>
