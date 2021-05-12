<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()
	                +request.getContextPath()+"/";

%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(function () {
			//当登录窗口不是顶级窗口的时候，将其设置成顶级窗口
			if(window.tip!=window){
				window.top.location=window.location;
			}
			//当获取焦点的时候，需要清空msg
			$("#loginAct").focus(function () {
                $("#msg").html("");
				$("#loginAct").val("");
			})
			$("#loginPwd").focus(function () {
				$("#msg").html("");
				$("#loginPwd").val("");
			})



			$("#submitBtn").click(function () {
				//alert("1");
				login();
			})
			//响应回车
			$(window).keydown(function (event) {
				if(event.keyCode==13){

					login();
				}

			})

		})
		function login() {
			var loginAct=$("#loginAct").val();
			var loginPwd=$("#loginPwd").val();
			if(loginAct==""||loginPwd==""){
				$("#msg").html("账号或者密码不能为空");
			}
			else{
				$.ajax({
					url:"settings/user/login.do",
					data:{"loginAct":loginAct,"loginPwd":loginPwd},
					type:"post",
					dataType:"json",
					success:function (data) {
						if(data.flag){
							window.location.href="workbench/index.jsp";
						}
						else{
							$("#msg").html(data.msg);
						}
					}
				})
			}
		}
	</script>
</head>
<body>

<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
	<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
	<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">GYP2021</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
	<div style="position: absolute; top: 0px; right: 60px;">
		<div class="page-header">
			<h1>登录</h1>
		</div>
		<form  class="form-horizontal" role="form">
			<div class="form-group form-group-lg">
				<div style="width: 350px;">
					<input class="form-control" type="text" placeholder="用户名" id="loginAct">
				</div>
				<div style="width: 350px; position: relative;top: 20px;">
					<input class="form-control" type="password" placeholder="密码" id="loginPwd">
				</div>
				<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

					<span id="msg" style="color: red"></span>

				</div>
				<%--此处的type如果为空或者为submit，在form表单中都是提交的意思--%>
				<button type="button"  id="submitBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
			</div>
		</form>
	</div>
</div>
</body>
</html>