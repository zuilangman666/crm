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
	//$("#cluePage").bs_pagination('getOption', 'currentPage')这个参数是操作后停留在当前页
	//$("#cluePage").bs_pagination('getOption', 'rowsPerPage')这个参数是操作后不改变当前每一页要展示的数据条数
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
			$("#hidden-birth").val($("#birth").val());
			$("#hidden-fullname").val($("#fullname").val());
			$("#hidden-customer").val($("#customer").val());
			$("#hidden-source").val($("#source").val());
			pageList(1,$("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
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
						$("#create-contactsOwner").html(html);
						$("#createContactsModal").modal("show");
					}
				})
			})
		//添加按钮
		$("#saveContactsBtn").click(function () {
            $.ajax({
				url:"workbench/contacts/createContacts.do",
				dataType:"json",
				type:"post",
				data:{
					"owner":$("#create-contactsOwner").val(),
					"source":$("#create-clueSource").val(),
					"customer":$("#create-customerName").val(),
					"fullname":$("#create-surname").val(),
					"appellation":$("#create-call").val(),
					"job":$("#create-job").val(),
					"email":$("#create-email").val(),
					"birth":$("#create-birth").val(),
					"description":$("#create-describe").val(),
					"contactSummary":$("#create-contactSummary").val(),
					"nextContactTime":$("#create-nextContactTime").val(),
					"address":$("#create-address").val(),
					"mphone":$("#create-mphone").val()
				},
				success:function (data) {
                     if(data.flag){
                     	//清空  刷新  关闭
						 $("#createForm")[0].reset();
						 pageList(1,$("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
						 $("#createContactsModal").modal("hide");
					 }
                     else{
                     	alert("添加失败");
					 }
				}
			})
		})
		//全选按钮
         $("#gyp").click(function () {
             $("#contactsBody input[name='love']").prop("checked",this.checked);
		 })
		$("#contactsBody").on("click", $("#contactsBody input[name='love']"),function () {
			$("#gyp").prop("checked", $("#contactsBody input[name='love']").length==$("#contactsBody input[name='love']:checked").length);
		})
		//编辑按钮
		$("#editModalBtn").click(function () {
            var $temp=$("#contactsBody input[name='love']:checked");
            if($temp.length==0){
            	alert("请选择一个修改的对象");
			}
            else if($temp.length>1){
            	alert("每次最多修改一个");
			}else{
				$.ajax({
					url:"workbench/contacts/updateContacts.do",
					dataType:"json",
					type:"post",
					data:{
                       "contactsId":$temp.val()
					},
					success:function (data) {
                        /*
                        data.userList
                        data.contacts
                        * */
						var html="<option></option>";
						$.each(data.userList,function (i,n) {
							html+="<option value='"+n.id+"'>"+n.name+"</option>";
						})
						$("#edit-contactsOwner").html(html);
						$("#edit-contactsOwner").val(data.contacts.owner);
						$("#edit-clueSource").val(data.contacts.source);
						$("#edit-customerName").val(data.contacts.customerId);
						$("#edit-surname").val(data.contacts.fullname);
						$("#edit-call").val(data.contacts.appellation);
						$("#edit-job").val(data.contacts.job);
						$("#edit-email").val(data.contacts.email);
						$("#edit-birth").val(data.contacts.birth);
						$("#edit-describe").val(data.contacts.description);
						$("#edit-contactSummary").val(data.contacts.contactSummary);
						$("#edit-nextContactTime").val(data.contacts.nextContactTime);
						$("#edit-address").val(data.contacts.address);
						$("#edit-mphone").val(data.contacts.mphone);


						$("#editContactsModal").modal("show");
					}
				})
			}
		})
		//更新按钮
		$("#updateContactsBtn").click(function () {
			var id=$("#contactsBody input[name='love']:checked").val();
			$.ajax({
				url:"workbench/contacts/editContacts.do",
				dataType:"json",
				type:"post",
				data:{
					"id":id,
					"owner":$("#edit-contactsOwner").val(),
					"source":$("#edit-clueSource").val(),
					"customer":$("#edit-customerName").val(),
					"fullname":$("#edit-surname").val(),
					"appellation":$("#edit-call").val(),
					"job":$("#edit-job").val(),
					"email":$("#edit-email").val(),
					"birth":$("#edit-birth").val(),
					"description":$("#edit-describe").val(),
					"contactSummary":$("#edit-contactSummary").val(),
					"nextContactTime":$("#edit-nextContactTime").val(),
					"address":$("#edit-address").val(),
					"mphone":$("#edit-mphone").val()
				},
				success:function (data){
					if(data.flag){
                       pageList($("#contactsPage").bs_pagination('getOption', 'currentPage'),
						$("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
                       $("#editContactsModal").modal("hide");
					}
					else{
						alert("更新失败");
					}
				}
			})
		})
		//删除
		$("#deleteBtn").click(function () {
            var $temp=$("#contactsBody input[name='love']:checked");
            var contactsId="";
            for(var i=0;i<$temp.length;i++){
            	 contactsId+="contactsId="+$($temp[i]).val();
            	 if(i<$temp.length-1){
					 contactsId+="&";
				 }
			}
            if(confirm("确定要删除？")){
				$.ajax({
					url:"workbench/contacts/deleteContacts.do",
					dataType:"json",
					type:"post",
					data:contactsId,
					success:function (data) {
						if(data.flag){
							pageList(1,$("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
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
		$("#contactsBody input[name='love']").prop("checked",false);
		$("#gyp").prop("checked",false);
		$("#owner").val($("#hidden-owner").val());
		$("#birth").val($("#hidden-birth").val());
		$("#fullname").val($("#hidden-fullname").val());
		$("#customer").val($("#hidden-customer").val());
		$("#source").val($("#hidden-source").val());
        //alert($("#birth").val()+$("#fullname").val()+$("#source").val()+$("#customer").val()+$("#owner").val());
		$.ajax({
			url:"workbench/contacts/pageList.do",
			dataType:"json",
			type:"get",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"birth":$("#birth").val(),
				"fullname":$("#fullname").val(),
				"source":$("#source").val(),
				"customer":$("#customer").val(),
				"owner":$("#owner").val()
			},
			success:function (data) {
				/*
                data.total:总数
                data.contactsList:联系人列表
                * */
				var html="";
				$.each(data.dataList,function (i,n) {
					html+='<tr class="active">';
					html+='<td><input type="checkbox" name="love" value="'+n.id+'"/></td>';
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/detail.do?contactsId='+n.id+'\';">'+n.fullname+n.appellation+'</a></td>';
					html+='<td>'+n.customerId+'</td>';
					html+='<td>'+n.owner+'</td>';
					html+='<td>'+n.source+'</td>';
					html+='<td>'+n.birth+'</td>';
					html+='</tr>';
				})
				$("#contactsBody").html(html);
				var totalPages=(data.total%pageSize==0)?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#contactsPage").bs_pagination({
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
<input type="hidden" id="hidden-birth">
<input type="hidden" id="hidden-fullname">
<input type="hidden" id="hidden-customer">
<input type="hidden" id="hidden-source">
	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="createForm" role="form">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">

								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
								  <option></option>
								  <gyp:forEach items="${sourceList}" var="s">
									  <option value="${s.value}">${s.text}</option>
								  </gyp:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
								  <gyp:forEach items="${appellationList}" var="a">
									  <option value="${a.value}">${a.text}</option>
								  </gyp:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
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
					<button type="button" class="btn btn-primary" id="saveContactsBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">

								</select>
							</div>
							<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource">
								  <option></option>
								  <gyp:forEach items="${sourceList}" var="s">
									  <option value="${s.value}">${s.text}</option>
								  </gyp:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" >
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
									<gyp:forEach items="${appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</gyp:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" >
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" >
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" >
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
					<button type="button" class="btn btn-primary" id="updateContactsBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" id="searchBody" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="owner" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" id="fullname" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" id="customer" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
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
				      <div class="input-group-addon">生日</div>
				      <input class="form-control time" id="birth" type="text">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary"  id="createModalBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default"  id="editModalBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="gyp"/></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="contactsBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>2000-10-10</td>
						</tr>
                        --%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 10px;">
				<div id="contactsPage">

				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>