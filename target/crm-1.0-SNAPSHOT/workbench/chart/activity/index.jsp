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
                url:"workbench/activity/getActivityECharts.do",
                dataType:"json",
                type:"get",
                success:function (data) {
                    // alert(data.total+"  "+data.dataList);
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));
                    var option = {
                        xAxis: {
                            type: 'category',
                            data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                        },
                        yAxis: {
                            type: 'value'
                        },
                        series: [{
                            data: [150, 230, 224, 218, 135, 147, 260],
                            type: 'line'
                        }]
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
