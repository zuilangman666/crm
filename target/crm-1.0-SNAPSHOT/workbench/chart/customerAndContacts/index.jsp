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
                url:"workbench/customer/getCustECharts.do",
                dataType:"json",
                type:"get",
                success:function (data) {
                    // alert(data.total+"  "+data.dataList);
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));
                 var  option = {
                        title: {
                            text: '客户联系人',
                            subtext: 'crm2021',
                            left: 'center'
                        },
                        tooltip: {
                            trigger: 'item'
                        },
                        legend: {
                            orient: 'vertical',
                            left: 'left',
                        },
                        series: [
                            {
                                name: '访问来源',
                                type: 'pie',
                                radius: '50%',
                                data: data.dataList,
                                emphasis: {
                                    itemStyle: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                }
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
