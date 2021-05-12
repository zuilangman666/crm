<%@ taglib prefix="gyp" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()
+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<link type="text/css" rel="stylesheet" href="jquery/bs_pagination/jquery.bs_pagination.min.css" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	$(function(){

		//时间控件bootstrap
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		pageList(1,2);
	});
	//$("#taskPage").bs_pagination('getOption', 'currentPage')这个参数是操作后停留在当前页
	//$("#taskPage").bs_pagination('getOption', 'rowsPerPage')这个参数是操作后不改变当前每一页要展示的数据条数
	function pageList(pageNo,pageSize) {
		$("#gyp").prop("checked",false);
		$("#taskBody input[name='love']:checked").prop("checked",false);
		$("#owner").val($("#hidden_owner").val());
		$("#topic").val($("#hidden_topic").val());
		$("#endDate").val($("#hidden_endDate").val());
		$("#priority").val($("#hidden_priority").val());
		$("#taskStage").val($("#hidden_taskStage").val());
		$("#contacts").val($("#hidden_contacts").val());
		$.ajax({
			url:"workbench/visit/pageList.do",
			dataType:"json",
			type:"get",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"owner":$("#owner").val(),
				"topic":$("#topic").val(),
				"endDate":$("#endDate").val(),
				"priority":$("#priority").val(),
				"taskStage":$("#taskStage").val(),
				"contacts":$("#contacts").val()
			},
			success:function(data) {
				/*
                dataList:数据
                total:数据总数
                * */
				var html="";
				$.each(data.dataList,function (i,n) {
					html+='<tr>';
					html+='<td><input name="love" type="checkbox" value="'+n.id+'"/></td>';
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/visit/detail.do?id='+n.id+'\';">'+n.topic+'</a></td>';
					html+='<td>'+n.startDate+'</td>';
					html+='<td>'+n.contactsId+'</td>';
					html+='<td>'+n.taskStage+'</td>';
					html+='<td>'+n.priority+'</td>';
					html+='<td>'+n.owner+'</td>';
					html+='</tr>';
				})
				$("#taskBody").html(html);
				//分页操作
				var totalPages=(data.total%pageSize==0)?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#taskPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数
					visiblePageLinks: 3, // 显示几个卡片
					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
			}
		})
	}
</script>
	<script type="text/javascript">
		$(function () {

			//创建任务
			$("#createTask").click(function () {
				window.location.href='workbench/visit/saveTask.jsp';
				pageList(1,$("#taskPage").bs_pagination('getOption', 'rowsPerPage'));
			})
			//查询按钮
			$("#search").click(function () {
				$("#hidden_owner").val($("#owner").val());
				$("#hidden_topic").val($("#topic").val());
				$("#hidden_endDate").val($("#topic").val());
				$("#hidden_priority").val($("#priority").val());
				$("#hidden_taskStage").val($("#taskStage").val());
				$("#hidden_contacts").val($("#contacts").val());
				pageList(1,$("#taskPage").bs_pagination('getOption', 'rowsPerPage'));
			})
			//全选
			$("#gyp").click(function () {
				$("#taskBody input[name='love']").prop("checked",this.checked);
			})
			$("#taskBody").on("click",$("#taskBody input[name='love']"),function () {
				$("#gyp").prop("checked",$("#taskBody input[name='love']").length==$("#taskBody input[name='love']:checked").length);
			})
			//修改
            $("#editTask").click(function () {
				var $temp=$("#taskBody input[name='love']:checked");
				if($temp.length==1){
					var id=$temp.val();
					window.location.href='workbench/visit/editTask.do?id='+id+'';
					pageList(1,$("#taskPage").bs_pagination('getOption', 'rowsPerPage'));
				}
				else if($temp.length==0){
					alert("请选择一个要修改的对象");
				}
				else{
					alert("最多修改一个对象");
				}
			})
			//删除
            $("#deleteTask").click(function () {
				var ids="";
				var $temp=$("#taskBody input[name='love']");
				if($temp.length==0){
					alert("请选择一个要删除的对象");
				}
				else{
					if(confirm("确定要删除吗?")){
						for(var i=0;i<$temp.length;i++){
							ids+="id="+$($temp[i]).val();
							if(i<$temp.length-1){
								ids+="&";
							}
						}
						$.ajax({
							url:"workbench/task/deleteTask.do",
							dataType: "json",
							type:"post",
							data:ids,
							success:function (data) {
								if(data.flag){
									pageList(1,$("#taskPage").bs_pagination('getOption', 'rowsPerPage'));
								}
								else{
									alert("删除失败");
								}
							}
						})
					}
				}
			})


		})

	</script>
</head>
<body>
<input type="hidden" id="hidden_owner">
<input type="hidden" id="hidden_topic">
<input type="hidden" id="hidden_endDate">
<input type="hidden" id="hidden_contacts">
<input type="hidden" id="hidden_taskStage">
<input type="hidden" id="hidden_priority">
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>任务列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >所有者</div>
						<input class="form-control" type="text" id="owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">主题</div>
				      <input class="form-control" type="text" id="topic">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">到期日期</div>
				      <input class="form-control time" type="text" id="endDate">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人</div>
				      <input class="form-control" type="text" id="contacts">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">状态</div>
					  <select class="form-control" id="taskStage">
					  	<option></option>
					    <gyp:forEach items="${taskStageList}" var="t">
							<option value="${t.value}">${t.text}</option>
						</gyp:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">优先级</div>
					  <select class="form-control" id="priority">
					  	<option></option>
						  <gyp:forEach items="${priorityList}" var="t">
							  <option value="${t.value}">${t.text}</option>
						  </gyp:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <button type="button"  id="search" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createTask" ><span class="glyphicon glyphicon-plus"></span> 任务</button>
				  <button type="button" class="btn btn-default" onclick="alert('可以自行实现对通话的管理');"><span class="glyphicon glyphicon-plus"></span> 通话</button>
				  <button type="button" class="btn btn-default" id="editTask" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteTask"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="gyp" type="checkbox" /></td>
							<td>主题</td>
							<td>到期日期</td>
							<td>联系人</td>
							<td>状态</td>
							<td>优先级</td>
							<td>所有者</td>
						</tr>
					</thead>
					<tbody id="taskBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">拜访客户</a></td>
							<td>2017-07-09</td>
							<td>李四先生</td>
							<td>未启动</td>
							<td>高</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/visit/detail.jsp';">拜访客户</a></td>
							<td>2017-07-09</td>
							<td>李四先生</td>
							<td>未启动</td>
							<td>高</td>
							<td>zhangsan</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;" id="taskPage">

			</div>
			
		</div>
		
	</div>
</body>
</html>