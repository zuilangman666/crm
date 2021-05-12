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
		//时间控件
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
		//展示列表
		pageList(1,2);
		//查询按钮
		$("#searchBtn").click(function () {
			$("#hidden-owner").val($("#owner").val());
			$("#hidden-name").val($("#name").val());
			$("#hidden-phone").val($("#phone").val());
			$("#hidden-website").val($("#website").val());
			pageList(1,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
		})
		//创建按钮
		$("#createModalBtn").click(function () {

			$.ajax({
				url:"workbench/clue/getUserList.do",
				dataType:"json",
				type:"get",
				success:function (data) {
					//拼接字符串
					var id="${user.id}";
					var html="<option></option>";
					$.each(data,function (i,n) {
						if(id==n.id){
							html+="<option value='"+n.id+"' selected >"+n.name+"</option>";
						}
						else{
							html+="<option value='"+n.id+"'>"+n.name+"</option>";
						}
					})
					$("#create-customerOwner").html(html);
					$("#createCustomerModal").modal("show");
				}
			})
		})
		//添加按钮
		$("#saveCustomerBtn").click(function () {
			$.ajax({
				url:"workbench/customer/createCustomer.do",
				dataType:"json",
				type:"post",
				data:{
					"owner":$("#create-customerOwner").val(),
					"name":$("#create-customerName").val(),
					"website":$("#create-website").val(),
					"phone":$("#create-phone").val(),
					"description":$("#create-describe").val(),
					"contactSummary":$("#create-contactSummary").val(),
					"nextContactTime":$("#create-nextContactTime").val(),
					"address":$("#create-address").val()
				},
				success:function (data) {
					if(data.flag){
						//清空  刷新  关闭
						$("#createForm")[0].reset();
						pageList(1,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#createCustomerModal").modal("hide");
					}
					else{
						alert("添加失败");
					}
				}
			})
		})
		//全选按钮
		$("#gyp").click(function () {
			$("#customerBody input[name='love']").prop("checked",this.checked);
		})
		$("#customerBody").on("click", $("#customerBody input[name='love']"),function () {
			$("#gyp").prop("checked", $("#customerBody input[name='love']").length==$("#customerBody input[name='love']:checked").length);
		})
		//编辑按钮
		$("#editModalBtn").click(function () {
			var $temp=$("#customerBody input[name='love']:checked");
			if($temp.length==0){
				alert("请选择一个修改的对象");
			}
			else if($temp.length>1){
				alert("每次最多修改一个");
			}else{
				$.ajax({
					url:"workbench/customer/updateCustomer.do",
					dataType:"json",
					type:"post",
					data:{
						"customerId":$temp.val()
					},
					success:function (data) {
						/*
                        data.userList
                        data.customer
                        * */
						var html="<option></option>";
						$.each(data.userList,function (i,n) {
							html+="<option value='"+n.id+"'>"+n.name+"</option>";
						})
						$("#edit-customerOwner").html(html);
						$("#edit-customerOwner").val(data.customer.owner);
						$("#edit-phone").val(data.customer.phone);
						$("#edit-customerName").val(data.customer.name);
						$("#edit-website").val(data.customer.website);
						$("#edit-describe").val(data.customer.description);
						$("#edit-contactSummary").val(data.customer.contactSummary);
						$("#edit-nextContactTime").val(data.customer.nextContactTime);
						$("#edit-address").val(data.customer.address);
						$("#editCustomerModal").modal("show");
					}
				})
			}
		})
		//更新按钮
		$("#updateCustomerBtn").click(function () {
			var id=$("#customerBody input[name='love']:checked").val();
			$.ajax({
				url:"workbench/customer/editCustomer.do",
				dataType:"json",
				type:"post",
				data:{
					"id":id,
					"owner":$("#edit-customerOwner").val(),
                    "name":$("#edit-customerName").val(),
					"website":$("#edit-website").val(),
					"phone":$("#edit-phone").val(),
					"description":$("#edit-describe").val(),
					"contactSummary":$("#edit-contactSummary").val(),
					"nextContactTime":$("#edit-nextContactTime").val(),
					"address":$("#edit-address").val()
				},
				success:function (data){
					if(data.flag){
						pageList($("#customerPage").bs_pagination('getOption', 'currentPage'),
								$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editCustomerModal").modal("hide");
					}
					else{
						alert("更新失败");
					}
				}
			})
		})
		//删除
		$("#deleteBtn").click(function () {
			var $temp=$("#customerBody input[name='love']:checked");
			var customerId="";
			for(var i=0;i<$temp.length;i++){
				customerId+="customerId="+$($temp[i]).val();
				if(i<$temp.length-1){
					customerId+="&";
				}
			}
			if(confirm("确定要删除？")){
				$.ajax({
					url:"workbench/customer/deleteCustomer.do",
					dataType:"json",
					type:"post",
					data:customerId,
					success:function (data) {
						if(data.flag){
							pageList(1,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
						}
						else{
							alert("删除失败");
						}
					}
				})
			}
		})
	});
	function pageList(pageNo,pageSize) {
		//alert("123");
		$("#customerBody input[name='love']").prop("checked",false);
		$("#gyp").prop("checked",false);
		$("#owner").val($("#hidden-owner").val());
		$("#website").val($("#hidden-website").val());
		$("#name").val($("#hidden-name").val());
		$("#phone").val($("#hidden-phone").val());
		//alert($("#owner").val()+$("#name").val()+$("#website").val()+$("#phone").val()+"1234");
		$.ajax({
			url:"workbench/customer/pageList.do",
			dataType:"json",
			type:"get",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"phone":$("#phone").val(),
				"name":$("#name").val(),
				"website":$("#website").val(),
				"owner":$("#owner").val()
			},
			success:function (data) {
				/*
                data.total:总数
                data.dataList:客户列表
                * */
				//alert("1234");
				var html="";
				$.each(data.dataList,function (i,n) {
				    html+='<tr>';
					html+='<td><input type="checkbox" value="'+n.id+'" name="love" /></td>';
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?customerId='+n.id+'\';">'+n.name+'</a></td>';
					html+='<td>'+n.owner+'</td>';
					html+='<td>'+n.phone+'</td>';
					html+='<td>'+n.website+'</td>';
				    html+='</tr>';
				})
				$("#customerBody").html(html);
				var totalPages=(data.total%pageSize==0)?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#customerPage").bs_pagination({
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
<input type="hidden" id="hidden-phone">
<input type="hidden" id="hidden-website">

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="createForm" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">

								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCustomerBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">

								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" >
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" >
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateCustomerBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" id="name" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="owner" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" id="phone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" id="website" type="text">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createModalBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editModalBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="gyp" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
							<td>zhangsan</td>
							<td>010-84846003</td>
							<td>http://www.bjpowernode.com</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/customer/detail.jsp';">动力节点</a></td>
                            <td>zhangsan</td>
                            <td>010-84846003</td>
                            <td>http://www.bjpowernode.com</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="customerPage">

				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>