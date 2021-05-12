<%@ page import="java.util.Map" %>
<%@ page import="com.geng.crm.settings.domain.DicValue" %>
<%@ page import="java.util.List" %>
<%@ page import="com.geng.crm.settings.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()
+request.getContextPath()+"/";
%>
<%
	Map<String,String> map=(Map<String,String>)application.getAttribute("pMap");
	List<DicValue> list=(List<DicValue>)application.getAttribute("stageList");
	int point =0;
	for(int i=0;i<list.size();i++){
		if("0".equals(map.get(list.get(i).getValue()))){
			point=i;
			break;
		}
	}
	int flag=0;
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
	<style type="text/css">
		.mystage{
			font-size: 20px;
			vertical-align: middle;
			cursor: pointer;
		}
		.closingDate{
			font-size : 15px;
			cursor: pointer;
			vertical-align: middle;
		}
	</style>
<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	//alert(123)
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
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });
		//时间控件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
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
				url:"workbench/transaction/saveRemark.do",
				dataType: "json",
				type: "get",
				data:{
					"noteContent":$("#remark").val(),
					"tranId":"${tran.id}"
				},

				success:function (data) {
					/*
					data.remark
					data.flag
					* */
					if(data.flag){
						var html="";
						//alert(data.remark.id);
						html+='<div class="remarkDiv" id="'+data.remark.id+'" style="height: 60px;">';
						html+='<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html+='<div style="position: relative; top: -40px; left: 40px;" >';
						html+='<h5>'+data.remark.noteContent+'</h5>';
						html+='<font color="gray">交易</font> <font color="gray">-</font> <b>${tran.customerId}-${tran.name}</b> <small style="color: gray;"> '+data.remark.createBy+'于'+data.remark.createTime+'</small>';
						html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" onclick="editRemark(\''+data.remark.id+'\',\''+data.remark.noteContent+'\')" style="font-size: 20px; color: #E6E6E6;"></span></a>';
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
		showHistory();
	});
	function showRemark() {
		//alert(123);
		$.ajax({
			url:"workbench/transaction/showRemark.do",
			dataType:"json",
			type:"get",
			data:{
				"tranId":"${tran.id}"
			},
			success:function (data) {
				var html="";
				$.each(data,function (i,n) {
					html+='<div class="remarkDiv" id="'+n.id+'" style="height: 60px;">';
					html+='<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html+='<div style="position: relative; top: -40px; left: 40px;" >';
					html+='<h5>'+n.noteContent+'</h5>';
					html+='<font color="gray">交易</font> <font color="gray">-</font> <b>${tran.customerId}-${tran.name}</b> <small style="color: gray;"> '+(n.editFlag==0?n.createBy:n.editBy)+'于'+(n.editFlag==0?n.createTime:n.editTime)+'</small>';
					html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" onclick="editRemark(\''+n.id+'\',\''+n.noteContent+'\')" style="font-size: 20px; color: #E6E6E6;"></span></a>';
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
				url:"workbench/transaction/deleteRemark.do",
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
	function showHistory() {
        $.ajax({
			url:"workbench/transaction/showHistory.do",
			dataType:"json",
			type:"get",
			data:{
			    "tranId":"${tran.id}"
			},
			success:function (data) {
				var html="";
                $.each(data,function (i,n) {
				    html+='<tr>';
					html+='<td>'+n.stage+'</td>';
					html+='<td>'+n.money+'</td>';
					html+='<td>'+n.possibility+'</td>';
					html+='<td>'+n.expectedDate+'</td>';
					html+='<td>'+n.createTime+'</td>';
					html+='<td>'+n.createBy+'</td>';
					html+='</tr>';
				})
				$("#historyBody").html(html);
			}
		})
	}
</script>
<script type="text/javascript">
	$(function () {
		//更新按钮
		$("#updateRemarkBtn").click(function () {
			$.ajax({
				url:"workbench/transaction/updateRemark.do",
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

	})

function changeStage(stage,index) {
     if(confirm("确定要转移到该阶段")){
     	$.ajax({
			url:"workbench/transaction/changeStage.do",
			dataType:"json",
			type:"post",
			data:{
				"stage":stage,
				"tranId":"${tran.id}",
				"money":"${tran.money}",
				"expectedDate":"${tran.expectedDate}"
			},
			success:function (data) {
				/*
				tran
				flag
				* */
				if(data.flag){
                   //改变详细内容
					$("#stage").html(data.tran.stage);
					$("#possibility").html(data.tran.possibility);
					$("#editBy").html(data.tran.editBy);
					$("#editTime").html(data.tran.editTime);
					//改变图标
					var currentPossibility=data.tran.possibility;
					if("0"==currentPossibility){
						//alert("currentPossibility="+currentPossibility);
						for(var i=0;i<<%=list.size()%>;i++){
							if(i<<%=point%>){
								//class="glyphicon glyphicon-record mystage"
								$("#"+i).removeClass();
								$("#"+i).addClass("glyphicon glyphicon-record mystage");
								$("#"+i).css("color","#000000");
							}
							//为什么我们要传入i，就是因为我们在java脚本中无法获取这个i的值（在js中无法使用）
							else if(i==index){
								//class="glyphicon glyphicon-remove mystage"	style="color: red;"
								$("#"+i).removeClass();
								$("#"+i).addClass("glyphicon glyphicon-remove mystage");
								$("#"+i).css("color", "red");
							}else{
								//class="glyphicon glyphicon-remove mystage"
								$("#"+i).removeClass();
								$("#"+i).addClass("glyphicon glyphicon-remove mystage");
								$("#"+i).css("color","#000000");
							}
						}
					}
					else{
						//alert("currentPossibility="+currentPossibility);
						for(var i=0;i<<%=list.size()%>;i++){
							if(i<<%=point%>){
                                if(i==index){
                                	//class="glyphicon glyphicon-map-marker mystage" style="color: #90F790;"
									$("#"+i).removeClass();
									$("#"+i).addClass("glyphicon glyphicon-map-marker mystage");
									$("#"+i).css("color","#90F790");
								}
                                else{
                                	if(i>index){
										//class="glyphiconglyphicon-record mystage"
										$("#"+i).removeClass();
										$("#"+i).addClass("glyphicon glyphicon-record mystage");
										$("#"+i).css("color","#000000");
									}
                                	else{
										//class="glyphiconglyphicon-ok-circle mystage" style="color: #90F790;"
										$("#"+i).removeClass();
										$("#"+i).addClass("glyphicon glyphicon-ok-circle mystage");
										$("#"+i).css("color" ,"#90F790");
									}
								}
							}
							else {
								//class="glyphicon glyphicon-remove mystage"
								$("#"+i).removeClass();
								$("#"+i).addClass("glyphicon glyphicon-remove mystage");
								$("#"+i).css("color","#000000");
							}
						}
					}
					//刷新交易历史
					showHistory();
				}
				else{
                    alert("更新失败");
				}
			}
		})
	 }
}
</script>
</head>
<body>
	<input type="hidden" id="hidden_id">
	<%--//编辑评论--%>
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
			<h3>${tran.customerId}-${tran.name} <small>￥${tran.money}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/edit.do?id=${tran.id}';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>

		</div>
	</div>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%--//js对data-content支持并不是很好，所以这里使用java脚本的形式进行显示--%>
		<%
			Tran tran=(Tran) request.getAttribute("tran");
			String currentStage=tran.getStage();
		    String currentPossibility=map.get(currentStage);
		    if("0".equals(currentPossibility)){
		    	for(int i=0;i<list.size();i++){
		    		String stage=list.get(i).getValue();
		    		if(i<point){
						//point之前的全部是   class="glyphiconglyphicon-record mystage"
						//out.print(123);
       %>
						<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')" class="glyphicon glyphicon-record mystage" data-toggle="popover"
			  			data-placement="bottom"
			  			data-content="<%=list.get(i).getText()%>" ></span>
		-----------
		<%
					}
		    		else if(stage.equals(currentStage)){
		    			//此时为currentStage   class="glyphiconglyphicon-remove mystage"	style="color: red;"
		%>
						<span id="<%=i%>" class="glyphicon glyphicon-remove mystage" onclick="changeStage('<%=stage%>','<%=i%>')" data-toggle="popover"
			 			data-placement="bottom"
			 			data-content="<%=list.get(i).getText()%>" style="color: #ff0000;"></span>
		-----------
		<%
					}
		    		else{
                       //此时不是currentStage   class="glyphiconglyphicon-remove mystage"
		%>
						<span id="<%=i%>" class="glyphicon glyphicon-remove mystage" onclick="changeStage('<%=stage%>','<%=i%>')" data-toggle="popover"
			  			data-placement="bottom"
			  			data-content="<%=list.get(i).getText()%>" ></span>
		-----------
		<%
					}
				}
			}
		    else{
				for(int i=0;i<list.size();i++){
					 String stage=list.get(i).getValue();
                     if(i<point){
                     	 if(stage.equals(currentStage)){
							 flag=1;
        %>
                     	 <%--此时为选中状态  class="glyphiconglyphicon-map-marker mystage" style="color: #90F790;"--%>
		                  	<span id="<%=i%>" class="glyphicon glyphicon-map-marker mystage" onclick="changeStage('<%=stage%>','<%=i%>')" data-toggle="popover"
							data-placement="bottom"
							data-content="<%=list.get(i).getText()%>" style="color: #90F790;"></span>
		-----------
		<%

						 }
                     	 else{
                     	 	if(flag==1){
                     	 		//此时为未完成状态 class="glyphiconglyphicon-record mystage"
		%>
							 <span id="<%=i%>" class="glyphicon glyphicon-record mystage" onclick="changeStage('<%=stage%>','<%=i%>')" data-toggle="popover"
			 				 data-placement="bottom"
			  				 data-content="<%=list.get(i).getText()%>" ></span>
		-----------
		<%
							}
                     	 	else{
                            //此时为完成状态  class="glyphiconglyphicon-ok-circle mystage" style="color: #90F790;"
        %>
							<span id="<%=i%>" class="glyphicon glyphicon-ok-circle mystage" onclick="changeStage('<%=stage%>','<%=i%>')" data-toggle="popover"
			  				data-placement="bottom"
			 				data-content="<%=list.get(i).getText()%>" style="color: #90F790;" ></span>
		-----------
		<%
                     	 	}
						 }
					 }
                     else{
                     	//此时为  class="glyphiconglyphicon-remove mystage"
		%>
							<span id="<%=i%>" class="glyphicon glyphicon-remove mystage" onclick="changeStage('<%=stage%>','<%=i%>')" data-toggle="popover" data-placement="bottom" data-content="<%=list.get(i).getText()%>" ></span>
		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>--%>
		-----------
		<%
					 }
				}
				flag=0;
			}
		%>





		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-------------%>
		<span class="closingDate">${tran.expectedDate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}-${tran.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div   style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${tran.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div  style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">${tran.possibility}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div  style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${tran.editBy}&nbsp;</b><small style="font-size: 10px; color: gray;" id="editTime">${tran.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${tran.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<h5>呵呵！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="historyBody">
						<%--<tr>
							<td>资质审查</td>
							<td>5,000</td>
							<td>10</td>
							<td>2017-02-07</td>
							<td>2016-10-10 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>需求分析</td>
							<td>5,000</td>
							<td>20</td>
							<td>2017-02-07</td>
							<td>2016-10-20 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						--%>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>