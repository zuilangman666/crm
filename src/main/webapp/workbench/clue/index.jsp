<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--使用下面这个标签我们引入第三方库--%>
<%--因为我们需要在jsp中使用foreach--%>
<%@taglib prefix="gyp" uri="http://java.sun.com/jsp/jstl/core" %>
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
		//页面刷新
		pageList(1,2);
		//时间控件bootstrap
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});
		//创建一个线索createClueBtn
		//此处这个虽然功能和市场活动上的那个一摸一样，但是是不同模块发出的，为了后期的维护性我们还是要需要自己再写一遍。为了后期的维护性  维护性！！！！！
		$("#createClueBtn").click(function () {
			//alert("123");
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
					$("#create-clueOwner").html(html);
					$("#createClueModal").modal("show");
				}
			})
		})
		//为保存按钮绑定事件
		$("#saveClueBtn").click(function () {
             $.ajax({
				 url:"workbench/clue/saveClue.do",
				 dataType: "json",
				 type: "post",
				 data:{
					"fullname":$.trim($("#create-surname").val()),
					"appellation":$.trim($("#create-call").val()),
					"owner":$.trim($("#create-clueOwner").val()),
					"company":$.trim($("#create-company").val()),
					"job":$.trim($("#create-job").val()),
					"email":$.trim($("#create-email").val()),
					"phone":$.trim($("#create-phone").val()),
					"website":$.trim($("#create-website").val()),
					"mphone":$.trim($("#create-mphone").val()),
					"state":$.trim($("#create-state").val()),
					"source":$.trim($("#create-source").val()),
					"description":$.trim($("#create-describe").val()),
					"contactSummary":$.trim($("#create-contactSummary").val()),
					"nextContactTime":$.trim($("#create-nextContactTime").val()),
					"address":$.trim($("#create-address").val())
				 },
				 success:function (data) {
                      if(data.flag){
                      	//刷新列表
						  pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						  //清空并且关闭模态窗口
						  $("#createForm")[0].reset();
						  $("#createClueModal").modal("hide");
					  }
                      else{
                      	alert("创建失败");
					  }
				 }
			 })
		})
		//全选按钮    checkbox
		$("#gyp").click(function () {
			$("#clueBody input[name='love']").prop("checked",this.checked);
		})
		$("#clueBody").on("click",$("#clueBody input[name='love']"),function () {
             $("#gyp").prop("checked",$("#clueBody input[name='love']:checked").length==$("#clueBody input[name='love']").length);
		})
		//修改按钮绑定事件
		$("#editClueBtn").click(function () {
             var count=$("#clueBody input[name='love']:checked").length;
             if(count==0){
             	alert("请选择一个修改的对象");
			 }
             else if(count!=1){
             	alert("最多可以选择一个对象");
			 }
             else{
             	var id=$("#clueBody input[name='love']:checked").val();
             	$.ajax({
					url:"workbench/clue/getClue.do",
					data: {
						"id": id
					},
					dataType:"json",
					type:"get",
					success:function (data) {
						/*
						data.clue
						data.user
						* */
						var html="<option></option>";
						$.each(data.user,function (i,n) {
                             html+="<option value='"+n.id+"'>"+n.name+"</option>"
						})
						$("#edit-clueOwner").html(html);
						//alert(data.clue.owner);
						$("#edit-surname").val(data.clue.fullname);
						$("#edit-call").val(data.clue.appellation);
						$("#edit-clueOwner").val(data.clue.owner);
						$("#edit-company").val(data.clue.company);
						$("#edit-job").val(data.clue.job);
						$("#edit-email").val(data.clue.email);
						$("#edit-phone").val(data.clue.phone);
						$("#edit-website").val(data.clue.website);
						$("#edit-mphone").val(data.clue.mphone);
						$("#edit-state").val(data.clue.state);
						$("#edit-source").val(data.clue.source);
						$("#edit-describe").val(data.clue.description);
						$("#edit-contactSummary").val(data.clue.contactSummary);
						$("#edit-nextContactTime").val(data.clue.nextContactTime);
						$("#edit-address").val(data.clue.address);

						$("#editClueModal").modal("show");

					}
				})
			 }
		})
		//查询按钮
		$("#searchClueBtn").click(function () {
			$("#hidden-fullname").val($("#fullname").val());
			$("#hidden-company").val($("#company").val());
			$("#hidden-phone").val($("#phone").val());
			$("#hidden-source").val($("#source").val());
			$("#hidden-owner").val($("#owner").val());
			$("#hidden-mphone").val($("#mphone").val());
			$("#hidden-state").val($("#state").val());
			pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
		})
		//更新按钮
         $("#updateClueBtn").click(function () {
              $.ajax({
				  url:"workbench/clue/updateClue.do",
				  dataType:"json",
				  type:"post",
				  data:{
					  "id":$("#clueBody input[name='love']:checked").val(),
					  "fullname":$.trim($("#edit-surname").val()),
					  "appellation":$.trim($("#edit-call").val()),
					  "owner":$.trim($("#edit-clueOwner").val()),
					  "company":$.trim($("#edit-company").val()),
					  "job":$.trim($("#edite-job").val()),
					  "email":$.trim($("#edit-email").val()),
					  "phone":$.trim($("#edit-phone").val()),
					  "website":$.trim($("#edit-website").val()),
					  "mphone":$.trim($("#edit-mphone").val()),
					  "state":$.trim($("#edit-state").val()),
					  "source":$.trim($("#edit-source").val()),
					  "description":$.trim($("#edit-describe").val()),
					  "contactSummary":$.trim($("#edit-contactSummary").val()),
					  "nextContactTime":$.trim($("#edit-nextContactTime").val()),
					  "address":$.trim($("#edit-address").val())
				  },
				  success:function (data) {
					  if(data.flag){
						  //刷新列表
						  pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						  //清空并且关闭模态窗口
						  $("#editForm")[0].reset();
						  $("#editClueModal").modal("hide");
					  }
					  else{
						  alert("创建失败");
					  }
				  }
			  })
		 })
		//删除按钮
		$("#deleteClueBtn").click(function () {
            var $temp=$("#clueBody input[name='love']:checked");
            if($temp.length==0){
            	alert("请选择要删除的对象");
			}
            else{
            	var id="";
            	for(var i=0;i<$temp.length;i++){
            		var str=$($temp[i]).val();
            		if(i<$temp.length-1){
						id+="id="+str+"&";
					}
            		else{
						id+="id="+str;
					}
				}
            	//alert(id);
				if(confirm("确定要删除?")){
					$.ajax({
						url:"workbench/clue/deleteClue.do",
						dataType:"json",
						type:"post",
						data:id,
						success:function (data) {
							if(data.flag){
								pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
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
	//$("#cluePage").bs_pagination('getOption', 'currentPage')这个参数是操作后停留在当前页
	//$("#cluePage").bs_pagination('getOption', 'rowsPerPage')这个参数是操作后不改变当前每一页要展示的数据条数
	function pageList(pageNo,pageSize) {
		$("#gyp").prop("checked",false);
		$("#fullname").val($("#hidden-fullname").val());
		$("#company").val($("#hidden-company").val());
		$("#phone").val($("#hidden-phone").val());
		$("#source").val($("#hidden-source").val());
		$("#owner").val($("#hidden-owner").val());
		$("#mphone").val($("#hidden-mphone").val());
		$("#state").val($("#hidden-state").val());
		$.ajax({
			url:"workbench/clue/pageList.do",
			dataType:"json",
			type:"get",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"fullname":$("#fullname").val(),
				"company":$("#company").val(),
				"phone":$("#phone").val(),
				"source":$("#source").val(),
				"owner":$("#owner").val(),
				"mphone":$("#mphone").val(),
				"state":$("#state").val()
			},
			success:function (data) {
                 /*
                 dataList:数据
                 total:数据总数
                 * */

				var html="";
				$.each(data.dataList,function (i,n) {
				    html+='<tr class="active">';
					html+='<td><input type="checkbox" name="love" value="'+n.id+'"/></td>'
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+n.id+'\';">'+n.fullname+'</a></td>';
					html+='<td>'+n.company+'</td>';
					html+='<td>'+n.phone+'</td>';
					html+='<td>'+n.mphone+'</td>';
					html+='<td>'+n.source+'</td>';
					html+='<td>'+n.owner+'</td>';
					html+='<td>'+n.state+'</td>';
					html+='</tr>';
				})
               $("#clueBody").html(html);
				//分页操作
				var totalPages=(data.total%pageSize==0)?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#cluePage").bs_pagination({
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
<input type="hidden" id="hidden-fullname">
<input type="hidden" id="hidden-company">
<input type="hidden" id="hidden-phone">
<input type="hidden" id="hidden-source">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-mphone">
<input type="hidden" id="hidden-state">
<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 90%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">修改线索</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" id="editForm" role="form">

					<div class="form-group">
						<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-clueOwner">

							</select>
						</div>
						<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-company" >
						</div>
					</div>

					<div class="form-group">
						<label for="edit-call" class="col-sm-2 control-label">称呼</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-call">
								<option></option>
								<gyp:forEach items="${appellationList}" var="a">
									<option value="${a.value}">${a.text}</option>
								</gyp:forEach>
							</select>
						</div>
						<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-surname" >
						</div>
					</div>

					<div class="form-group">
						<label for="edit-job" class="col-sm-2 control-label">职位</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-job" >
						</div>
						<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-email" >
						</div>
					</div>

					<div class="form-group">
						<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-phone" >
						</div>
						<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-website" >
						</div>
					</div>

					<div class="form-group">
						<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-mphone" >
						</div>
						<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-state">
								<option></option>
								<gyp:forEach items="${clueStateList}" var="c">
									<option value="${c.value}">${c.text}</option>
								</gyp:forEach>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-source">
								<option></option>
								<gyp:forEach items="${sourceList}" var="s">
								    <option value="${s.value}">${s.text}</option>
							   </gyp:forEach>

							</select>
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
								<input type="text" class="form-control time" id="edit-nextContactTime" >
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
				<button type="button" class="btn btn-primary" data-dismiss="modal" id="updateClueBtn">更新</button>
			</div>
		</div>
	</div>
</div>

<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="createForm" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
								  <gyp:forEach items="${appellationList}" var="a">
									  <option value="${a.value}">${a.text}</option>
								  </gyp:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
								  <gyp:forEach items="${clueStateList}" var="c">
                                       <option value="${c.value}">${c.text}</option>
								  </gyp:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <gyp:forEach items="${sourceList}" var="s">
									  <option value="${s.value}">${s.text}</option>
								  </gyp:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
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
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="saveClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	

	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input class="form-control" id="fullname" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" id="company" type="text">
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
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="source">
					  	  <option></option>
						  <gyp:forEach items="${sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </gyp:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="owner" type="text">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" id="mphone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="state">
					  	<option></option>
					  	<gyp:forEach items="${clueStateList}" var="s">
							<option value="${s.value}">${s.text}</option>
						</gyp:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" id="searchClueBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createClueBtn" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editClueBtn" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox"  id="gyp"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">
					<%--	<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.jsp';">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        --%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="cluePage">

				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>