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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
	});
	
</script>
<script type="text/javascript">
	$(function () {
		//删除和编辑评论的按钮设置焦点
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})
		//展示评论
		showRemark();
		//添加
		$("#saveRemark").click(function () {
			$.ajax({
				url:"workbench/visit/saveRemark.do",
				dataType: "json",
				type: "get",
				data:{
					"noteContent":$("#remark").val(),
					"taskId":"${task.id}"
				},

				success:function (data) {
					/*
					data.remark
					data.flag
					* */
					if(data.flag){
						var html="";
						//alert(data.remark.id);
						html+='<div id="'+data.remark.id+'" class="remarkDiv" style="height: 60px;">';
						html+='<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html+='<div style="position: relative; top: -40px; left: 40px;" >';
						html+='<h5>'+data.remark.noteContent+'</h5>';
						html+='<font color="gray">任务</font> <font color="gray">-</font> <b>${task.topic}</b> <small style="color: gray;"> '+data.remark.createBy+'于'+data.remark.createTime+'</small>';
						html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"  onclick="editRemark(\''+data.remark.id+'\',\''+data.remark.noteContent+'\')" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						html+='&nbsp;&nbsp;&nbsp;&nbsp;';
						html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" onclick="removeRemark(\''+data.remark.id+'\')" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						html+='</div>';
						html+='</div>';
						html+='</div>';
						$("#remarkDiv").before(html);
						$("#remark").val("");
					}
					else{
						alert("添加失败");
					}
				}
			})
		})

		//更新按钮
		$("#updateRemarkBtn").click(function () {
			$.ajax({
				url:"workbench/visit/updateRemark.do",
				dataType:"json",
				type:"post",
				data:{
					"noteContent":$("#noteContent").val(),
					"id":$("#hidden_id").val()
				},
				success:function (data) {
					if(data.flag){
						$("#"+data.remark.id+" h5").html(data.remark.noteContent);
						$("#"+data.remark.id+" small[style='color: gray;']").html(data.remark.editTime +"由"+data.remark.editBy);
						$("#editRemarkModal").modal("hide");
					}
					else{
						alert("更新失败");
					}
				}
			})

		})

		//


	})
	function showRemark() {
		//alert(123);
		$.ajax({
			url:"workbench/visit/showRemark.do",
			dataType:"json",
			type:"get",
			data:{
				"taskId":"${task.id}"
			},
			success:function (data) {
				var html="";
				$.each(data,function (i,n) {
					html+='<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
					html+='<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html+='<div style="position: relative; top: -40px; left: 40px;" >';
					html+='<h5>'+n.noteContent+'</h5>';
					html+='<font color="gray">任务</font> <font color="gray">-</font> <b>${task.topic}</b> <small style="color: gray;"> '+(n.editFlag==0?n.createBy:n.editBy)+'于'+(n.editFlag==0?n.createTime:n.editTime)+'</small>';
					html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"  onclick="editRemark(\''+n.id+'\',\''+n.noteContent+'\')" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html+='&nbsp;&nbsp;&nbsp;&nbsp;';
				    html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" onclick="removeRemark(\''+n.id+'\')" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html+='</div>';
					html+='</div>';
					html+='</div>';
				})
				$("#remarkDiv").before(html);

			}
		})
	}
	function editRemark(id,noteContent) {
		$("#hidden_id").val(id);
		$("#editRemarkModal").modal("show");
		$("#noteContent").val(noteContent);
	}
	function removeRemark(id) {
		if(confirm("确定要删除吗?")){
			$.ajax({
				url:"workbench/visit/deleteRemark.do",
				dataType:"json",
				type:"post",
				data:{
					"id":id
				},
				success:function (data) {
					if(data.flag){
						$("#"+id).remove();
					}
					else{
						alert("删除失败");
					}
				}
			})
		}
	}
</script>
</head>
<body>
<input type="hidden" id="hidden_id">
<div class="modal fade" id="editRemarkModal" role="dialog">
	<%-- 备注的id --%>
	<input type="hidden" id="remarkId">
	<div class="modal-dialog" role="document" style="width: 40%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改备注</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<div class="form-group">
						<label for="noteContent" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="noteContent"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
			</div>
		</div>
	</div>
</div>
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${task.topic}</h3>
		</div>

	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">主题</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${task.topic}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">到期日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${task.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">联系人</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${task.contactsId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">任务阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${task.taskStage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">优先级</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${task.priority}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">任务所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${task.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">提醒时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${task.startDate}（${task.repeatType}   ${task.noticeType}}）</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${task.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${task.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${task.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${task.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${task.description}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: -20px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">任务</font> <font color="gray">-</font> <b>拜访客户</b> <small style="color: gray;"> 2017-01-22 10:10:10 星期二由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">任务</font> <font color="gray">-</font> <b>拜访客户</b> <small style="color: gray;"> 2017-01-22 10:10:10 星期二由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveRemark" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>