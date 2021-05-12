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
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
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
		$("#reminderTime").click(function(){
			if(this.checked){
				$("#reminderTimeDiv").show("200");
			}else{
				$("#reminderTimeDiv").hide("200");
			}
		});
	});
</script>
<script type="text/javascript">
$(function () {
	//alert(123);
	//加载信息
	showOwner();
	//联系人搜索功能
     $("#search").click(function () {
		 $("#findContacts").modal("show");
	 })
	//回车进行搜索
	$("#input").keydown(function (event) {
		if(event.keyCode==13){
			$.ajax({
				url:"workbench/visit/searchContact.do",
				dataType: "json",
				type: "get",
				data:{
					"name":$("#input").val()
				},
				success:function (data) {
                    var html="";
                    $.each(data,function (i,n) {
					    html+='<tr>';
						html+='<td><input value="'+n.id+'" type="radio" name="like"/></td>';
						html+='<td  id="'+n.id+'">'+n.fullname+'</td>';
						html+='<td>'+n.email+'</td>';
						html+='<td>'+n.mphone+'</td>';
						html+='</tr>';
					})
					$("#contactsBody").html(html);
				}
			})
			return false;
		}
	})
	//提交按钮
	$("#submitBtn").click(function () {
		var id=$("#contactsBody input[name='like']:checked").val();
		var name=$("#"+id).html();
		//alert(id+" "+name);
		$("#contacts").val(name);
		$("#contactsId").val(id);
		$("#findContacts").modal("hide");
	})
	//保存
	$("#saveTask").click(function () {
         $("#taskForm").submit();
	})

 })
function showOwner() {
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
			$("#owner").html(html);
		}
	})
}
</script>

</head>
<body>

	<!-- 查找联系人 -->	
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
						    <input type="text" id="input" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
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
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button"   class="btn btn-primary" id="submitBtn">提交</button>
				</div>
			</div>
		</div>
	</div>
	
	<div style="position:  relative; left: 30px;">
		<h3>创建任务</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" id="saveTask" class="btn btn-primary">保存</button>
			<button type="button"  class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" method="get" action="workbench/task/saveTask.do" id="taskForm" role="form">
		<div class="form-group">
			<label for="owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="owner" name="owner">

				</select>
			</div>
			<label for="topic" class="col-sm-2 control-label">主题<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="topic" id="topic">
			</div>
		</div>
		<div class="form-group">
			<label for="endDate" class="col-sm-2 control-label">到期日期</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="endDate" name="endDate">
			</div>
			<label for="contacts" class="col-sm-2 control-label">联系人&nbsp;&nbsp;<a href="javascript:void(0);" id="search"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="contacts">
				<input type="hidden" name="contactsId" id="contactsId">
			</div>
		</div>
	
		<div class="form-group">
			<label for="taskState" class="col-sm-2 control-label">状态</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="taskState" name="taskStage">
					<option></option>
				  <gyp:forEach items="${taskStageList}" var="t">
					  <option value="${t.value}">${t.text}</option>
				  </gyp:forEach>
				</select>
			</div>
			<label for="priority" class="col-sm-2 control-label">优先级</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="priority" name="priority">
				  <option></option>
					<gyp:forEach items="${priorityList}" var="t">
						<option value="${t.value}">${t.text}</option>
					</gyp:forEach>
				</select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="description" name="description"></textarea>
			</div>
		</div>
		
		<div style="position: relative; left: 103px;">
			<span><b>提醒时间</b></span>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="checkbox" id="reminderTime">
		</div>
		
		<div id="reminderTimeDiv" style="width: 500px; height: 180px; background-color: #EEEEEE; position: relative; left: 185px; top: 20px; display: none;">
			<div class="form-group" style="position: relative; top: 10px;">
				<label for="startDate" class="col-sm-2 control-label">开始日期</label>
				<div class="col-sm-10" style="width: 300px;">
					<input type="text" class="form-control time" name="startDate" id="startDate">
				</div>
			</div>
			
			<div class="form-group" style="position: relative; top: 15px;">
				<label for="repeatType" class="col-sm-2 control-label">重复类型</label>
				<div class="col-sm-10" style="width: 300px;">
					<select class="form-control" id="repeatType" name="repeatType">
					  <option></option>
					  <gyp:forEach items="${repeatTypeList}" var="r">
						  <option value="${r.value}">${r.text}</option>
					  </gyp:forEach>
					</select>
				</div>
			</div>
			
			<div class="form-group" style="position: relative; top: 20px;">
				<label for="noticeType" class="col-sm-2 control-label">通知类型</label>
				<div class="col-sm-10" style="width: 300px;">
					<select class="form-control" id="noticeType" name="noticeType">
					  <option></option>
						<gyp:forEach items="${noticeTypeList}" var="r">
							<option value="${r.value}">${r.text}</option>
						</gyp:forEach>
					</select>
				</div>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>