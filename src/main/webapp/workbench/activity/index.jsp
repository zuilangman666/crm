<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
 String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+
		 request.getContextPath()+"/";
%>
<html>
<head>
<meta charset="UTF-8">
<base href="<%=basePath%>">

<%--css的引入和javascript的引入顺序一定要注意--%>
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link type="text/css" rel="stylesheet" href="jquery/bs_pagination/jquery.bs_pagination.min.css" />
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	$(function(){
		pageList(1,2);
		//时间控件bootstrap
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		//修改信息按钮
		$("#editBtn").click(function () {
           var $temp=$("input[name=love]:checked");
           if($temp.length==0){
           	alert("请选择一个要修改的对象");
		   }
           else if($temp.length>1){
           	alert("只能选择一条记录进行修改");
		   }
           else{
           	 var id=$temp.val();
           	 //alert(id);
           	 $.ajax({
				 url:"workbench/activity/getUserListAndActivity.do",
				 data:{"id":id},
				 dataType:"json",
				 type:"get",
				 success:function (data) {
				 	/*
				 	* userList:
				 	* activity
				 	* */
                    var html="<option></option>";
                    var sss="${user.id}";
                    $.each(data.userList,function (i,n) {
						html+="<option value='"+n.id+"'>"+n.name+"</option>";
					})
					 $("#edit-marketActivityOwner").html(html);
                     $("#edit-marketActivityOwner").val(data.activity.owner);
                     $("#edit-marketActivityName").val(data.activity.name);
					 $("#edit-startTime").val(data.activity.startDate);
					 $("#edit-endTime").val(data.activity.endDate);
					 $("#hidden-id").val(data.activity.id);
					 $("#edit-cost").val(data.activity.cost);
					 $("#edit-describe").val(data.activity.description);
					 $("#editActivityModal").modal("show");
				 }

			 })
		   }
		})
		/*
		在js中使用el表达式一定要用双引号括起来，否则就会出错
		*/
		/*使用js操作模态窗口
		1、获取模态框口对象
		2、调用modal方法
		3、参数为show为创建  参数为hide为关闭

		*/

		/*pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
				,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));*/
		//$("#activityPage").bs_pagination('getOption', 'currentPage')这个参数是操作后停留在当前页
        //$("#activityPage").bs_pagination('getOption', 'rowsPerPage')这个参数是操作后不改变当前每一页要展示的数据条数
		$("#updateBtn").click(function () {
			$.ajax({
				url:"workbench/activity/updateActivity.do",
				type:"post",
				dataType: "json",
				data:{
					"owner":$("#edit-marketActivityOwner").val(),
					"name":$("#edit-marketActivityName").val(),
					"startDate":$("#edit-startTime").val(),
					"endDate":$("#edit-endTime").val(),
					"cost":$("#edit-cost").val(),
					"description":$("#edit-describe").val(),
					"id":$("#hidden-id").val()
				},
				success:function (data) {
					if(data.flag){
						//局部刷新
						//更新后要停留在当前页，并且不改变当前页要展示的条数
						//pageList(1,2);
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editform")[0].reset();
						//关闭窗口
						$("#editActivityModal").modal("hide");
					}
					else{
						alert("修改失败");
					}
				}
			})
		})
		$("#addBtn").click(function () {
			//接收用户数据
			$.ajax({
				url:"workbench/activity/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (data) {
					var html="<option></option>";
					var id="${user.id}"
					 $.each(data,function (i,n) {
					 	if(n.id==id){
							html+="<option value='"+n.id+"' selected=true>"+n.name+"</option>";
						}
					 	else{
							html+="<option  value='"+n.id+"'>"+n.name+"</option>";
						}
					 })
					$("#create-marketActivityOwner").html(html);

				}
			})
			//设置默认选中选项  不知道为啥不管用
			/*var name="${user.name}";
			$("#create-marketActivityOwner option").val(name);*/
			//打开模态窗口
			$("#createActivityModal").modal("show");
			$(window).keydown(function (event) {
                if(event.keyCode==13){
                	saveActivity();
				}
			})
		})
         $("#saveBnt").click(function () {
              saveActivity();
		 })

		//点击查询按钮之后
		//$("#activityPage").bs_pagination('getOption', 'currentPage')这个参数是操作后停留在当前页
		//$("#activityPage").bs_pagination('getOption', 'rowsPerPage')这个参数是操作后不改变当前每一页要展示的数据条数
        $("#queryBtn").click(function () {
        	$("#hidden-name").val($("#name").val());
			$("#hidden-owner").val($("#owner").val());
			$("#hidden-start").val($("#startTime").val());
			$("#hidden-end").val($("#endTime").val());
//点击查询后，应该返回首页，但是不改变当前每一页的条数
         // pageList(1,2);
			pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
		})
		//删除按钮
		$("#deleteBtn").click(function () {
			var $temp=$("input[name=love]:checked");
			if($temp.length==0){
				alert("请先选择需要删除的对象");
			}
			else{
			   if(confirm("确定要删除吗？")){
				   var param="";
				   for(var i=0;i<$temp.length;i++){
					   param+="id="+$($temp[i]).val();
					   if(i<$temp.length-1){
						   param+="&";
					   }
				   }
				   //alert(param);
				   $.ajax({
					   url:"workbench/activity/deleteActivity.do",
					   data:param,
					   dataType:"json",
					   type:"post",
					   success:function (data) {
						   if(data.flag){
						   	//删除后应该同查询
							  // pageList(1,2);
							   pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						   }
						   else{
							   alert("删除失败");
						   }
					   }
				   })
			   }
			}

		})
        $("#gyp").click(function () {
             $("input[name=love]").prop("checked",this.checked);
		})
         $("#activityBody").on("click",$("input[name=love]"),function () {
             $("#gyp").prop("checked",$("input[name=love]").length==$("input[name=love]:checked").length)
		 })
	});
	/*
	对于所有的关系型数据库，做前端的分页操作的基础组件就是pageNo （页码） 和pageSize（每一页展现的记录数）
	pageList方法就是发送ajax请求，从后端得到数据，然后做一个局部刷新的操作

	根据实际需求我们可以知道在下面几种情况下我们需要调用pageList方法（对列表进行局部刷新）
	1、点击左侧的市场活动超链接
	2、添加  修改  删除后
	3、点击查询后
	4、点击分页组件之后
	*/
	/*<tr class="active">
			<td><input type="checkbox" /></td>
			<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
	<td>zhangsan</td>
	<td>2020-10-10</td>
	<td>2020-10-20</td>
	</tr>*/
	function pageList(pageNo,pageSize) {
		$("#gyp").prop("checked",false);
		/*
		* 我们使用了一个隐藏域解决了这个查询问题哈哈哈，仔细想想原理
		* */
		$("#name").val($("#hidden-name").val());
		$("#owner").val($("#hidden-owner").val());
		$("#startTime").val($("#hidden-start").val());
		$("#endTime").val($("#hidden-end").val());
        $.ajax({
			url:"workbench/activity/pageList.do",
			type:"get",
			dataType:"json",
			data: {
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#name").val()),
				"startDate":$.trim($("#startTime").val()),
				"endDate":$.trim($("#endTime").val()),
				"owner":$.trim($("#owner").val())

			},
			success:function (data) {
				/*
				* dataList:数据
				* total：数据数目
				* */
				var html="";
				/*$("input[name=love]").click(function () {
                       alert(123);
				})*/
				/*上述方法是无效的，因为动态生成的标签是不可以通过普通的绑定事件进行操作的
				* 动态生成的元素我们要以on方法的形式来触发事件
				* 语法：
				* $(需要绑定元素的有效外层元素).on(绑定事件的方式，需要绑定的的元素的jquery对象，回调函数)
				* */
				$.each(data.dataList,function (i,n) {
				    html += '<tr class="active">';
				    html += '<td><input type="checkbox" name="love" value='+n.id+'></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.startDate+'</td>';
					html += '<td>'+n.endDate+'</td>';
					html += '</tr>';
				})
                $("#activityBody").html(html);
				//进行分页操作
				var totalPages=(data.total%pageSize==0)?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#activityPage").bs_pagination({
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
	function saveActivity() {
		$.ajax({
			url:"workbench/activity/saveActivity.do",
			type:"post",
			dataType: "json",
			data:{
				"owner":$("#create-marketActivityOwner").val(),
				"name":$("#create-marketActivityName").val(),
				"startDate":$("#create-startTime").val(),
				"endDate":$("#create-endTime").val(),
				"cost":$("#create-cost").val(),
				"description":$("#create-describe").val()
			},
			//$("#activityPage").bs_pagination('getOption', 'currentPage')这个参数是操作后停留在当前页
			//$("#activityPage").bs_pagination('getOption', 'rowsPerPage')这个参数是操作后不改变当前每一页要展示的数据条数
			success:function (data) {
				if(data.flag){
					//局部刷新
					pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
					//清空窗口中的数据

					/*
                    由于这是一个一个form表单，我们都知道form表单是存在submit和reset两个按钮的，但我们不可能是
                    让用户自己去点击按钮，所以我们就需要调用函数执行这个reset
                    但是此处需要注意，jquery给我们提供了submit方法，让我们提交表单，但是并没有给我们这个reset方法
                    又但是  原生的javascript给我们提供了reset方法，所以我们需要将jquery转换成javascript对象
                    */
					$("#create-activity-form")[0].reset();
					//关闭窗口
					$("#createActivityModal").modal("hide");
				}
				else{
					alert("添加失败");
				}
			}
		})
	}
</script>
</head>
<body>
<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-start"/>
<input type="hidden" id="hidden-end"/>
<input type="hidden" id="hidden-id"/>
<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 85%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
			</div>
			<div class="modal-body">

				<form class="form-horizontal" role="form" id="editform">

					<div class="form-group">
						<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-marketActivityOwner">

							</select>
						</div>
						<label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-marketActivityName" >
						</div>
					</div>

					<div class="form-group">
						<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control time" id="edit-startTime" >
						</div>
						<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control time" id="edit-endTime">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-cost" class="col-sm-2 control-label">成本</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-cost" >
						</div>
					</div>

					<div class="form-group">
						<label for="edit-describe" class="col-sm-2 control-label">描述</label>
						<div class="col-sm-10" style="width: 81%;">
							<%--
                            关于文本域  textarea：
                            1、一定要以标签对的形式呈现，正常情况下标签对要紧挨着（不要有多余的空格和回车）
                            2、textarea虽然是以标签对的形式呈现的，但是他也是属于表单元素（我们要操作textarea中的值，
                            我们应该统一使用val（），不要使用html（））
                            --%>
							<textarea class="form-control" rows="3" id="edit-describe"></textarea>
						</div>
					</div>

				</form>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
			</div>
		</div>
	</div>
</div>
	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form  id="create-activity-form" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control  time" id="create-endTime">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<%--
					data-dismiss关闭模态窗口
					--%>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBnt">保存</button>
				</div>
			</div>
		</div>
	</div>
	

	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <input class="form-control" type="text" id="name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="startTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="endTime">
				    </div>
				  </div>
				  
				  <button type="button"  id="queryBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">

					<%--
					data-toggle=“modal”表示当前要打开模态对话框
					data-target=“#”表示打开那个id的模态窗口
					使用这种方法（设置属性和属性值）可以打开模态对话框，
					但是也存在一些问题，比如我们要实现打开对话框之前要弹出alert提示就无法做到
                    所以最好是通过js设置这个属性，这样就比较自由
                    data-toggle="modal" data-target="#createActivityModal"
                    data-toggle="modal" data-target="#editActivityModal"
					--%>
				  <button type="button" class="btn btn-primary" id="addBtn" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"   id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox"  id="gyp"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage">

				</div>

			</div>
			
		</div>
		
	</div>
</body>
</html>