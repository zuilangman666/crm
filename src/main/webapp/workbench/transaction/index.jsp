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
			pickerPosition: "top-left"
		});
		pageList(1,2);
         $("#createTrans").click(function () {
			 window.location.href='workbench/transaction/save.jsp';
			 pageList(1,$("#transPage").bs_pagination('getOption', 'rowsPerPage'));
		 })
		$("#editTrans").click(function () {
			var $temp=$("#transBody input[name='love']:checked");
			if($temp.length==1){
				var id=$temp.val();
				window.location.href='workbench/transaction/edit.do?id='+id+'';
				pageList(1,$("#transPage").bs_pagination('getOption', 'rowsPerPage'));
			}
			else if($temp.length==0){
				alert("请选择一个要修改的对象");
			}
			else{
				alert("最多修改一个对象");
			}

		})
		//查询
		$("#searchBtn").click(function () {
			$("#hidden-owner").val($("#owner").val());
			$("#hidden-name").val($("#name").val());
			$("#hidden-source").val($("#source").val());
			$("#hidden-stage").val($("#stage").val());
			$("#hidden-type").val($("#type").val());
			$("#hidden-contactsId").val($("#contactsId").val());
			$("#hidden-customerId").val($("#customerId").val());
			pageList(1,$("#transPage").bs_pagination('getOption', 'rowsPerPage'));
		})
		//设置全选
		$("#gyp").click(function () {
            $("#transBody input[name='love']").prop("checked",this.checked);
		})
		$("#transBody").on("click",$("#transBody input[name='love']"),function () {
           $("#gyp").prop("checked",$("#transBody input[name='love']").length==$("#transBody input[name='love']:checked").length);
		})
		//删除
		$("#deleteTrans").click(function () {
              var ids="";
              var $temp=$("#transBody input[name='love']");
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
						url:"workbench/transaction/deleteContacts.do",
						dataType: "json",
						type:"post",
						data:ids,
						success:function (data) {
                            if(data.flag){
								pageList(1,$("#transPage").bs_pagination('getOption', 'rowsPerPage'));
							}
                            else{
                            	alert("删除失败");
							}
						}

					})
				}

			  }

		})
		
	});
	//$("#transPage").bs_pagination('getOption', 'currentPage')这个参数是操作后停留在当前页
	//$("#transPage").bs_pagination('getOption', 'rowsPerPage')这个参数是操作后不改变当前每一页要展示的数据条数
	function pageList(pageNo,pageSize) {
		$("#owner").val($("#hidden-owner").val());
		$("#name").val($("#hidden-name").val());
		$("#source").val($("#hidden-source").val());
		$("#stage").val($("#hidden-stage").val());
		$("#type").val($("#hidden-type").val());
		$("#contactsId").val($("#hidden-contactsId").val());
		$("#customerId").val($("#hidden-customerId").val());
		$("#gyp").prop("checked",false);
        $("#transBody input[name='love']:checked").prop("checked",false);
		$.ajax({
			url:"workbench/transaction/pageList.do",
			dataType:"json",
			type:"get",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
                "owner":$("#owner").val(),
				"name":$("#name").val(),
				"customerId":$("#customerId").val(),
				"contactsId":$("#contactsId").val(),
				"type":$("#type").val(),
				"source":$("#source").val(),
				"stage":$("#stage").val()
			},
			success:function (data) {
				/*
                dataList:数据
                total:数据总数
                */
				var html="";
				$.each(data.dataList,function (i,n) {
				    html+='<tr>';
					html+='<td><input type="checkbox" name="love" value="'+n.id+'" /></td>';
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?transId='+n.id+'\';">'+n.customerId+'-'+n.name+'</a></td>';
					html+='<td>'+n.customerId+'</td>';
					html+='<td>'+n.stage+'</td>';
					html+='<td>'+n.type+'</td>';
					html+='<td>'+n.owner+'</td>';
					html+='<td>'+n.source+'</td>';
					html+='<td>'+n.contactsId+'</td>';
					html+='</tr>';
				})
				$("#transBody").html(html);
				//分页操作
				var totalPages=(data.total%pageSize==0)?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#transPage").bs_pagination({
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
</head>
<body>
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-customerId">
<input type="hidden" id="hidden-stage">
<input type="hidden" id="hidden-type">
<input type="hidden" id="hidden-source">
<input type="hidden" id="hidden-contactsId">
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="customerId">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="stage">
					  	<option></option>
						  <gyp:forEach items="${stageList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </gyp:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="type">
					  	<option></option>
						  <gyp:forEach items="${transactionTypeList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </gyp:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="source">
						  <option></option>
						 <gyp:forEach items="${sourceList}" var="s">
							 <option value="${s.value}">${s.text}</option>
						 </gyp:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="contactsId">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createTrans"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editTrans"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"   id="deleteTrans"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="gyp"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="transBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="transPage">

				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>