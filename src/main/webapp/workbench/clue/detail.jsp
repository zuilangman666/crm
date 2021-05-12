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
        //更新按钮
		$("#updateRemarkBtn").click(function () {
			var id=$("#hidden-id").val();
			var noteContent=$("#noteContent").val();
			$.ajax({
				url:"workbench/clue/updateRemark.do",
				dataType:"json",
				type:"post",
				data:{
					"id":id,
					"noteContent":noteContent
				},
				success:function (data) {
					/*
					data.remark
					data.flag
					* */
                    if(data.flag){
                    	$("#"+data.remark.id+" h5").html(data.remark.noteContent);
                    	$("#"+data.remark.id+" small[style='color: gray;']").html(data.remark.editTime +"由"+data.remark.editBy);
                    	$("#noteContent").val("");
                    	$("#editRemarkModal").modal("hide");
					}
                    else{
                    	alert("修改失败");
					}
				}
			})
		})
		//当页面加载之后我们要展示评论
        showRemark();
		//展示关联
		showRelation();
		//我们提供模态窗口的搜索功能
		$("#search").keydown(function (event) {
			var name=$.trim($("#search").val());
             if(event.keyCode==13){
             	//我们发现当我们点击输入框输入内容，按下回车，就会执行alert语句
				 //但是当我们点击弹出框的确定后，模态窗口就会关闭，其实这是keydown函数的自动行为（按下回车，关闭模态窗口）
				 //所以我们应该通过返回值的形式，禁用点这个属性
		// alert(name);
             	//此处添加return false
                 $.ajax({
					 url:"workbench/clue/getActivityListSS.do",
					 dataType:"json",
					 type:"get",
					 data:{
					 	"name":name,
						 "clueId":"${clue.id}"
					 },
					 success:function (data) {
					 	var html="";
                          $.each(data,function (i,n) {
						    html+='<tr>';
							html+='<td><input type="checkbox" name="love" value="'+n.id+'"/></td>';
							html+='<td>'+n.name+'</td>';
							html+='<td>'+n.startDate+'</td>';
							html+='<td>'+n.endDate+'</td>';
							html+='<td>'+n.owner+'</td>';
							html+='</tr>';
						  })
						 $("#searchBody").html(html);
					 }
				 })

				 return false;
			 }
		})
		//checkbox的设置
		$("#gyp").click(function () {
            $("#searchBody input[name='love']").prop("checked",this.checked);
		})
		$("#searchBody").on("click",$("#searchBody input[name='love']"),function () {
              $("#gyp").prop("checked",$("#searchBody input[name='love']").length==$("#searchBody input[name='love']:checked").length);
		})
		//关联按钮绑定事件
		$("#bindBtn").click(function () {
			var $temp=$("#searchBody input[name='love']:checked");
			if($temp.length==0){
				alert("请选择一个要关联的对象");
			}
			else{
				var activityId="";
				for(var i=0;i<$temp.length;i++){
					activityId+="activityId="+$($temp[i]).val();

					activityId+="&";

				}
				activityId+="clueId="+"${clue.id}";
				//alert(activityId);
				$.ajax({
					url:"workbench/clue/bind.do",
					dataType:"json",
					type:"post",
					data:activityId,
					success:function (data) {
						if(data.flag){
							//清空输入界面
							$("#search").val("");
							$("#gyp").prop("checked",false);
							$("#searchBody input[name='love']:checked").prop("checked",false);
							$("#searchBody").html("");
							//刷新一下
							showRelation();
							//关闭模态窗口
							$("#bundModal").modal("hide");
						}
						else{
							alert("关联失败");
						}
					}
				})
			}
		})
        //为评论添加按钮绑定事件
        $("#saveBtn").click(function () {
        	var remark=$("#remark").val();
        	var id="${clue.id}";
            $.ajax({
				url:"workbench/clue/saveRemark.do",
				dataType: "json",
				type: "post",
				data:{
					"id":id,
					"noteContent":remark
				},
				success:function (data) {
					/*
					data.flag
					data.remark
					* */
					if(data.flag){
						var html="";
					    html+='<div class="remarkDiv" id="'+data.remark.id+'" style="height: 60px;">';
						html+='<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html+='<div style="position: relative; top: -40px; left: 40px;" >';
						html+='<h5>'+data.remark.noteContent+'</h5>';
						html+='<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}</b> <small style="color: gray;"> '+(data.remark.editFlag==0?data.remark.createTime:data.remark.editTime)+' 由'+(data.remark.editFlag==0?data.remark.createBy:data.remark.editBy)+'</small>';
						html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" onclick="updateRemark(\''+data.remark.id+'\',\''+data.remark.noteContent+'\')" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						html+='&nbsp;&nbsp;&nbsp;&nbsp;';
					    html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"    onclick="deleteRemark(\''+data.remark.id+'\')"    style="font-size: 20px; color: #E6E6E6;"></span></a>';
						html+='</div>';
						html+='</div>';
						html+='</div>';
						$("#remark").val("");
						$("#remarkDiv").before(html);
					}
					else{
						alert("添加失败");
					}

				}
			})
		})
	})

	//展示关联关系
	function showRelation() {
		$.ajax({
			url:"workbench/clue/showRelation.do",
			dataType:"json",
			type:"get",
			data:{
				"id":"${clue.id}"
			},
			success:function (data) {
				var html="";
				$.each(data,function (i,n) {
				    html+='<tr>';
					html+='<td>'+n.name+'</td>';
					html+='<td>'+n.startDate+'</td>';
					html+='<td>'+n.endDate+'</td>';
					html+='<td>'+n.owner+'</td>';
					html+='<td><a href="javascript:void(0);" onclick="unbind(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
					html+='</tr>';
				})
                $("#activityBody").html(html);
			}
		})
	}
	//解开绑定
	function unbind(id) {
		//alert(id);
		if(confirm("确定要解除绑定?")){
			$.ajax({
				url:"workbench/clue/unbind.do",
				dataType:"json",
				type:"post",
				data:{
					"id":id
				},
				success:function (data) {
                    if(data.flag){
                    	//刷新一下列表
						showRelation();
					}
                    else{
                    	alert("删除失败");
					}
				}
			})
		}
	}
	//展示评论
	function showRemark() {
		$.ajax({
			url:"workbench/clue/showRemark.do",
			dataType:"json",
			type:"get",
			data:{
				"id":"${clue.id}"
			},
			success:function (data) {
				var html="";
				/*
				*
				* */
				//alert(123);
				$.each(data,function (i,n) {

				      html+='<div class="remarkDiv" id="'+n.id+'" style="height: 60px;">';
					  //alert(n.id);
					  html+='<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					  html+='<div style="position: relative; top: -40px; left: 40px;" >';
					  html+='<h5>'+n.noteContent+'</h5>';
					  //alert(n.noteContent);
					  html+='<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}</b> <small style="color: gray;">'+(n.editFlag==0?n.createTime:n.editTime)+'由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
					  html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" onclick="updateRemark(\''+n.id+'\',\''+n.noteContent+'\')" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html+='&nbsp;&nbsp;&nbsp;&nbsp;';
				      html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" onclick="deleteRemark(\''+n.id+'\')" style="font-size: 20px; color: #e6e6e6;"></span></a>';
					  html+='</div>';
					  html+='</div>';
					  html+='</div>';
				})
				$("#remarkDiv").before(html);
			}
		})
	}


	function deleteRemark(id) {
		if(confirm("确定要删除?")){
			$.ajax({
				url:"workbench/clue/deleteRemark.do",
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
	function updateRemark(id,noteContent) {
		alert(123);
		$("#noteContent").val(noteContent);
		$("#editRemarkModal").modal("show");
		$("#hidden-id").val(id);

	}
</script>
</head>
<body>
<input  type="hidden" id="hidden-id" />
<!-- 修改线索备注的模态窗口 -->
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

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="search" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="gyp" /></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody  id="searchBody">
							<%--
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button"   class="btn btn-primary" id="bindBtn">关联</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 修改线索的模态窗口 -->
    <%--由于时间原因，不在详情界面中写修改按钮了--%>
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">																																																			<%--&ID=${ID}*/不用加这个我愚蠢了--%>
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.jsp?clueId=${clue.id}&appellation=${clue.appellation}&fullname=${clue.fullname}&owner=${clue.owner}&company=${clue.company}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                   ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<!-- 备注2 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
					<button  id="saveBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#bundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>