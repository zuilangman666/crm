<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+
	                request.getContextPath()+"/";
%>

<html>
<head>
<meta charset="UTF-8">
<base href="<%=basePath%>">
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
		//删除按钮
		$("#deleteActivityBtn").click(function () {
			if(confirm("确定要删除吗？")){
				var temp="${activity.id}";
				var param="id="+temp;
				//alert(param);
				$.ajax({
					url:"workbench/activity/deleteActivity.do",
					data:param,
					dataType:"json",
					type:"post",
					success:function (data) {
						if(data.flag){
							//window.history.back();
							window.location.href="workbench/activity/index.jsp";
						}
						else{
							alert("删除失败");
						}
					}
				})
			}
		})

		//修改按钮
		$("#editActivityBtn").click(function () {
			$("#editActivityModal").modal("show");
			var id="${activity.id}";
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

		})
		//更新按钮
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
						//刷新当前页面
						window.location.href=window.location;
						/*$("#editform")[0].reset();
						$("#editActivityModal").modal("hide");*/
					}
					else{
						alert("修改失败");
					}
				}
			})
		})
	})
</script>

	<script type="text/javascript">
		$(function () {
			//显示页面的remark
			showRemarkList();
			$("#remarkBody").on("mouseover",".remarkDiv",function(){
				$(this).children("div").children("div").show();
			})
			$("#remarkBody").on("mouseout",".remarkDiv",function(){
				$(this).children("div").children("div").hide();
			})
            //更新按钮
            $("#updateRemarkBtn").click(function () {
               var tempNote=$("#noteContent").val();
               var tempId= $("#hidden-remarkId").val();
                $.ajax({
                    url:"workbench/activityRemark/updateRemark.do",
                    data:{
                        "id":tempId,
                        "noteContent":tempNote
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data) {
                        if(data.flag){


                            $("#"+tempId+" h5").html(data.remark.noteContent);
                            var temp=""+data.remark.editTime+" 由"+data.remark.editBy+"";
                            $("#"+tempId+" small[style='color: gray;']").html(temp);
                            $("#noteContent").val("");
                            $("#editRemarkModal").modal("hide");
                        }
                        else{
                            alert("修改失败");
                        }

                    }
                })
            })
            //添加按钮
            $("#saveRemarkBtn").click(function () {
                $.ajax({
                    url:"workbench/activityRemark/saveRemark.do",
                    data:{
                        "id":"${activity.id}",
                        "noteContent":$("#remark").val()
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data) {
                         if(data.flag){
                             //清空textarea
                             $("#remark").val("");
                            // alert("22222");
                             var html="";
                             html+='<div class="remarkDiv" id="'+data.remark.id+'" style="height: 60px;">';
                             html+='<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                             html+='<div style="position: relative; top: -40px; left: 40px;" >';
                             html+='<h5>'+data.remark.noteContent+'</h5>';
                             html+='<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> '+data.remark.createTime+' 由'+data.remark.createBy+'</small>';
                             html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                             html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"  onclick="updateRemark(\''+data.remark.id+'\',\''+data.remark.noteContent+'\')" style="font-size: 20px; color: #E6E6E6;"></span></a> ';
                             html+='&nbsp;&nbsp;&nbsp;&nbsp;';
                             html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"  onclick="deleteRemark(\''+data.remark.id+'\')" style="font-size: 20px; color: #E6E6E6;"></span></a>';
                             html+='</div>';
                             html+='</div>';
                             html+='</div>';
                           //  alert("11111");
                             $("#remarkDiv").before(html);
                         }
                         else{
                             alert("添加失败");
                         }
                    }
                })
            })

		})
		function showRemarkList() {
          $.ajax({
			  url:"workbench/activityRemark/showRemarkList.do",
			  data:{
			  	"activityId":"${activity.id}"
			  },
			  dataType:"json",
			  type:"get",
			  success:function (data) {

                 var html="";
                 $.each(data,function (i,n) {
					 html+='<div class="remarkDiv" id="'+n.id+'" style="height: 60px;">';
					 html+='<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					 html+='<div style="position: relative; top: -40px; left: 40px;" >';
					 html+='<h5>'+n.noteContent+'</h5>';
					 html+='<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
					 html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					 html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" onclick="updateRemark(\''+n.id+'\',\''+n.noteContent+'\')" style="font-size: 20px; color: #E6E6E6;"></span></a> ';
					 html+='&nbsp;&nbsp;&nbsp;&nbsp;';
					 html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"  onclick="deleteRemark(\''+n.id+'\')" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					 html+='</div>';
					 html+='</div>';
					 html+='</div>';
					 /*
					 * class="glyphicon glyphicon-edit"    修改样式
					 * class="glyphicon glyphicon-remove"   删除样式
					 * href="javascript:void(0);"超链接禁用  只能使用触发事件的形式来操作
					 * onclick="deleteRemark(\''+n.id+'\')"由于是动态生成的html，所以需要这样转义和添加双引号。。。。。。
					 * */
				 })
				  $("#remarkDiv").before(html);
			  }
		  })
		}
		function deleteRemark(id) {
             $.ajax({
				 url:"workbench/activityRemark/deleteRemark.do",
				 data:{
				 	"id":id
				 },
				 dataType:"json",
				 type:"post",
				 success:function (data) {
                      if(data.flag){
                          /*由于上面我们使用的是before，所以当他重新调用的时候他并不会清空原本的html内容。
                          此时我们应该使用为每次动态生成的div设计一个id，然后通过id删除他们。
                          **/
                      	//showRemarkList();
                          $("#"+id).remove();
					  }
                      else{
                      	alert("删除失败");
					  }
				 }
			 })
		}

		function updateRemark(id,data) {
		    //初始化修改备注的窗口中的内容（不过后台），此处有两种方法，一种是将n.noteContent当作函数的参数传入，一种是设置标签名，通过选择器获取
            $("#hidden-remarkId").val(id);
		    $("#noteContent").val(data);
		    $("#editRemarkModal").modal("show");
		}
	</script>
</head>
<body>
	<input type="hidden" id="hidden-id"/>
    <input type="hidden" id="hidden-remarkId"/>
	<!-- 修改市场活动备注的模态窗口 -->
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
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
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

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabelX">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

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
                                <input type="text" class="form-control" id="edit-startTime" >
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-endTime" >
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div  id="remarkBody"  style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
					<button type="button"   id="saveRemarkBtn" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>