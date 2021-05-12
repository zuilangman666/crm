package com.geng.crm.settings.domain;

public class User {
    /*
    * 常用的时间表现形式：
    * 日期：yyyy-MM-dd十位字符串
    * 日期加时间：yyyy-MM-dd HH:mm:ss十九位字符串
    *
    * */
    /*
    * 关于登录的问题：
    * 1、账号和密码的验证
    * select count(*)  from tbl_user where loginAct =?  and  loginPwd=?
    * 这样是不太好的，因为我们除了账号密码还有很多其他的信息需要验证
    *  User  user=select count(*)  from tbl_user where loginAct =?  and  loginPwd=?
    * user不为空表示账号密码是对的，但是还需要验证
    * expireTime验证失效时间
    * lockState验证是否锁定
    * allowIps验证ip是否符合要求
    * */
    private String id;//编号  主键
    private String loginAct;//登录账号
    private String name;//用户的真实姓名
    private String loginPwd;//登陆密码
    private String email;//邮箱
    private String expireTime;//失效时间
    private String lockState;//锁定状态（0表示锁定   1表示启用）
    private String deptno;//部门编号
    private String allowIps;//允许访问的ip地址
    private String createBy;//创建人
    private String createTime;//创建时间
    private String editTime;//修改时间
    private String editBy;//修改人

    @Override
    public String toString() {
        return "User{" +
                "id='" + id + '\'' +
                ", loginAct='" + loginAct + '\'' +
                ", name='" + name + '\'' +
                ", loginPwd='" + loginPwd + '\'' +
                ", email='" + email + '\'' +
                ", expireTime='" + expireTime + '\'' +
                ", lockState='" + lockState + '\'' +
                ", deptno='" + deptno + '\'' +
                ", allowIps='" + allowIps + '\'' +
                ", createBy='" + createBy + '\'' +
                ", createTime='" + createTime + '\'' +
                ", editTime='" + editTime + '\'' +
                ", editBy='" + editBy + '\'' +
                '}';
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLoginAct() {
        return loginAct;
    }

    public void setLoginAct(String loginAct) {
        this.loginAct = loginAct;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLoginPwd() {
        return loginPwd;
    }

    public void setLoginPwd(String loginPwd) {
        this.loginPwd = loginPwd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(String expireTime) {
        this.expireTime = expireTime;
    }

    public String getLockState() {
        return lockState;
    }

    public void setLockState(String lockState) {
        this.lockState = lockState;
    }

    public String getDeptno() {
        return deptno;
    }

    public void setDeptno(String deptno) {
        this.deptno = deptno;
    }

    public String getAllowIps() {
        return allowIps;
    }

    public void setAllowIps(String allowIps) {
        this.allowIps = allowIps;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getEditTime() {
        return editTime;
    }

    public void setEditTime(String editTime) {
        this.editTime = editTime;
    }

    public String getEditBy() {
        return editBy;
    }

    public void setEditBy(String editBy) {
        this.editBy = editBy;
    }
}
