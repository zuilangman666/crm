<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="gyp" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()
			+request.getContextPath()+"/";
%>
<%
	Map<String,String > map=(Map<String,String> )application.getAttribute("pMap");
	Set<String> set =map.keySet();
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
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<script type="text/javascript">
		$(function () {

			var json={
				<%
			   for(String key:set){
			   	String value=map.get(key);
			%>
				"<%=key%>":<%=value%>,
				<%
                }
                %>
			}
			/*对页面的值进行初始化*/
			$("#money").val("${tran.money}");
			$("#name").val("${tran.name}");
			$("#expectedDate").val("${tran.expectedDate}");
			$("#customerId").val("${tran.customerId}");
			$("#stage").val("${tran.stage}");
			$("#type").val("${tran.type}");
			$("#source").val("${tran.source}");
			$("#activityIdSSS").val("${tran.activityId}");
			$("#contactsIdSSS").val("${tran.contactsId}");
			$("#description").val("${tran.description}");
			$("#nextContactTime").val("${tran.nextContactTime}");
			$("#contactSummary").val("${tran.contactSummary}");
			$("#possibility").val(json[$("#stage").val()]);
			//时间控件bootstrap
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			//修改按钮
			$("#editTran").click(function () {
				$("#tranForm").submit();
			})
			$("#cancelBtn").click(function () {

			})
			//提前加载必要的信息
			//加载owner
			showOwner();
			//确定市场活动源
			$("#activitySearch").keydown(function (event) {
				if(event.keyCode==13){
					$.ajax({
						url:"workbench/transaction/showActivity.do",
						dataType: "json",
						type: "get",
						data:{
							"name":$("#activitySearch").val()
						},
						success:function (data) {
							var html="";
							$.each(data,function (i,n) {
								html+='<tr>';
								html+='<td><input type="radio" name="love" value="'+n.id+'"/></td>';
								html+='<td id="'+n.id+'">'+n.name+'</td> ';
								html+='<td>'+n.startDate+'</td>';
								html+='<td>'+n.endDate+'</td>';
								html+='<td>'+n.owner+'</td>';
								html+='</tr>';
							})
							$("#activityBody").html(html);
						}
					})
					return false;
				}
			})
			//提交按钮
			$("#submitBtn").click(function () {
				var id=$("#activityBody input[name='love']:checked").val();
				var name=$("#"+id).html();
				// alert(id+" "+name);
				$("#activityIdSSS").val(id);
				$("#activityId").val(name);
				$("#activitySearch").val("");
				$("#activityBody").html("");
				$("#findMarketActivity").modal("hide");
			})
			//确定联系人
			$("#searchContacts").keydown(function (event) {
				if(event.keyCode==13){
					$.ajax({
						url:"workbench/transaction/showContacts.do",
						dataType: "json",
						type: "get",
						data:{
							"name":$("#searchContacts").val(),
							"customerId":$("#customerId").val()
						},
						success:function (data) {
							if(data.flag){
								var html="";
								$.each(data.list,function (i,n) {
									html+='<tr>';
									html+='<td><input type="radio"  value="'+n.id+'" name="like"/></td>';
									html+='<td id="'+n.id+'">'+n.fullname+'</td>';
									html+='<td>'+n.email+'</td>';
									html+='<td>'+n.mphone+'</td>';
									html+='</tr>';
								})
								$("#contactsBody").html(html);
							}
							else{
								alert("该客户没有联系人");
								$("#contactsIdSSS").val("");
								$("#contactsId").val("无联系人");
								$("#findContacts").modal("hide");
							}

						}
					})
					return false;
				}
			})
			//提交按钮
			$("#submitBtnS").click(function () {
				var id=$("#contactsBody input[name='like']:checked").val();
				var name=$("#"+id).html();
				$("#contactsIdSSS").val(id);
				$("#contactsId").val(name);
				$("#searchContacts").val("");
				$("#contactsBody").html("");
				$("#findContacts").modal("hide");
			})
			//客户自动补全
			//自动补全插件
			$("#customerId").typeahead({
				source: function (query, process) {
					$.get(
							"workbench/transaction/getCustomerName.do",
							{ "name" : query },
							function (data) {
								//alert(data);

								process(data);
							},
							"json"
					);
				},
				delay: 1500
			});

			$("#stage").change(function () {
				var stage =$("#stage").val();
				/*如果我们使用json.stage就不会取到结果，因为此时stage是一个变量
				必须要用[]这样的方式获取json的值
				* */
				$("#possibility").val(json[stage]);
			})
		})
		function showOwner() {
			$.ajax({
				url:"workbench/transaction/showInit.do",
				dataType:"json",
				type:"get",
				data:{
					"contactsId":"${tran.contactsId}",
					"activityId":"${tran.activityId}"
				},
				success:function (data) {
					//拼接字符串
					var id="${tran.owner}";
					var html="<option></option>";
					$.each(data.userList,function (i,n) {
						if(id==n.id){
							html+="<option value='"+n.id+"' selected >"+n.name+"</option>";
						}
						else{
							html+="<option value='"+n.id+"'>"+n.name+"</option>";
						}
					})
					$("#owner").html(html);
					$("#contactsId").val(data.contacts.fullname);
					$("#activityId").val(data.activity.name);
				}
			})
		}
	</script>
</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">查找市场活动</h4>
			</div>
			<div class="modal-body">
				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
					<form class="form-inline" role="form">
						<div class="form-group has-feedback">
							<input type="text" class="form-control"  id="activitySearch" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
							<span class="glyphicon glyphicon-search form-control-feedback"></span>
						</div>
					</form>
				</div>
				<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td></td>
						<td>名称</td>
						<td>开始日期</td>
						<td>结束日期</td>
						<td>所有者</td>
					</tr>
					</thead>
					<tbody id="activityBody">
					</tbody>
				</table>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button"   class="btn btn-primary" id="submitBtn">提交</button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="findContacts" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">查找联系人</h4>
			</div>
			<div class="modal-body">
				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
					<form class="form-inline" role="form">
						<div class="form-group has-feedback">
							<input type="text" class="form-control" id="searchContacts" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
							<span class="glyphicon glyphicon-search form-control-feedback"></span>
						</div>
					</form>
				</div>
				<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td></td>
						<td>名称</td>
						<td>邮箱</td>
						<td>手机</td>
					</tr>
					</thead>
					<tbody id="contactsBody">

					</tbody>
				</table>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button"   class="btn btn-primary" id="submitBtnS">提交</button>
				</div>
			</div>
		</div>
	</div>
</div>


<div style="position:  relative; left: 30px;">
	<h3>修改交易</h3>
	<div style="position: relative; top: -40px; left: 70%;">
		<button type="button"  id="editTran" class="btn btn-primary">更新</button>
		<button type="button"  id="cancelBtn" class="btn btn-default">取消</button>
	</div>
	<hr style="position: relative; top: -40px;">
</div>
<form  method="post" action="workbench/transaction/editTran.do" class="form-horizontal" role="form" id="tranForm" style="position: relative; top: -30px;">
	<input type="hidden" value="${tran.id}" name="id">
	<div class="form-group">
		<label for="owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" id="owner" name="owner">

			</select>
		</div>
		<label for="money" class="col-sm-2 control-label">金额</label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="money" name="money"  >
		</div>
	</div>

	<div class="form-group">
		<label for="name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="name" name="name">
		</div>
		<label for="expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control time" id="expectedDate" name="expectedDate">
		</div>
	</div>

	<div class="form-group">
		<label for="customerId" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="customerId"  name="customerId" placeholder="支持自动补全，输入客户不存在则新建">
			<div id="auto">

			</div>
		</div>
		<label for="stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" id="stage" name="stage">
				<option></option>
				<gyp:forEach items="${stageList}" var="s">
					<option value="${s.value}">${s.text}</option>
				</gyp:forEach>
			</select>
		</div>
	</div>

	<div class="form-group">
		<label for="type" class="col-sm-2 control-label">类型</label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" id="type" name="type">
				<option></option>
				<gyp:forEach items="${transactionTypeList}" var="s">
					<option value="${s.value}">${s.text}</option>
				</gyp:forEach>
			</select>
		</div>
		<label for="possibility" class="col-sm-2 control-label">可能性</label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="possibility" name="possibility">
		</div>
	</div>

	<div class="form-group">
		<label for="source" class="col-sm-2 control-label">来源</label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" id="source" name="source">
				<option></option>
				<gyp:forEach items="${sourceList}" var="s">
					<option value="${s.value}">${s.text}</option>
				</gyp:forEach>
			</select>
		</div>
		<label for="activityId" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="activityId" >
			<input type="hidden" name="activityId" id="activityIdSSS">
		</div>
	</div>

	<div class="form-group">
		<label for="contactsId" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="contactsId" >
			<input type="hidden" name="contactsId" id="contactsIdSSS">
		</div>
	</div>

	<div class="form-group">
		<label for="description" class="col-sm-2 control-label">描述</label>
		<div class="col-sm-10" style="width: 70%;">
			<textarea class="form-control" rows="3" id="description" name="description"></textarea>
		</div>
	</div>
	<div class="form-group">
		<label for="nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control time" id="nextContactTime" name="nextContactTime">
		</div>
	</div>
	<div class="form-group">
		<label for="contactSummary" class="col-sm-2 control-label">联系纪要</label>
		<div class="col-sm-10" style="width: 70%;">
			<textarea class="form-control" rows="3" id="contactSummary" name="contactSummary"></textarea>
		</div>
	</div>



</form>
</body>
</html>