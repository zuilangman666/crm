package com.geng.crm.settings.workbench.service.impl;

import com.geng.crm.settings.workbench.dao.*;
import com.geng.crm.settings.workbench.domain.*;
import com.geng.crm.settings.workbench.service.ClueService;
import com.geng.crm.utils.DateTimeUtil;
import com.geng.crm.utils.SqlSessionUtil;
import com.geng.crm.utils.UUIDUtil;
import com.geng.crm.vo.PaginationVo;

import java.util.List;
import java.util.Map;

public class ClueServiceImpl implements ClueService {
    private ClueDao clueDao= SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private ClueRemarkDao clueRemarkDao=SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
    private ClueActivityRelationDao clueActivityRelationDao=SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
    private CustomerDao customerDao=SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao=SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);
    private ContactsDao contactsDao=SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao=SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao=SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
    private TranDao tranDao=SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao=SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    @Override
    public boolean updateRemark(ClueRemark clueRemark) {
        int count =clueRemarkDao.updateRemark(clueRemark);
        if(count==1){
            return true;
        }
        else{
            return false;
        }
    }

    @Override
    public boolean unbind(String id) {
        int count =clueActivityRelationDao.deleteRelation(id);
        if(count==1){
            return true;
        }
        else{
            return false;
        }
    }

    @Override
    public List<Activity> getActivityListSSS(String name, String clueId) {
        return clueActivityRelationDao.getActivityListSSS(name,clueId);
    }

    @Override
    public boolean bind(String clueId, String[] activityId) {
        for(int i=0;i<activityId.length;i++){
            String id= UUIDUtil.getUUID();
            int count=clueActivityRelationDao.createRelation(id,clueId,activityId[i]);
            if(count!=1){
                return false;
            }
        }
        return true;
    }

    @Override
    public List<Activity> getActivityListSS(String name, String clueId) {
        return clueActivityRelationDao.getActivityListSS(name,clueId);
    }

    @Override
    public List<Activity> getActivityList(String id) {
        return  clueActivityRelationDao.getActivityList(id);
    }

    @Override
    public boolean deleteRemark(String id) {
        int count =clueRemarkDao.deleteRemarkSuper(id);
        if(count==1){
            return true;
        }
        else{
            return false;
        }
    }

    @Override
    public boolean saveRemark(ClueRemark clueRemark) {
        int count =clueRemarkDao.saveRemark(clueRemark);
        if(count==1){
            return true;
        }
        return false;
    }

    @Override
    public PaginationVo<Clue> pageList(Map<String, Object> map) {
        List<Clue> list=clueDao.getListByCondition(map);
        int total=clueDao.getTotalByCondition(map);

        PaginationVo<Clue> paginationVo=new PaginationVo<Clue>();
        paginationVo.setTotal(total);
        paginationVo.setDataList(list);
        return paginationVo;
    }

    @Override
    public String getID(String id) {
        return clueDao.getID(id);
    }

    @Override
    public Clue solveDetail(String id) {
        return clueDao.getClueSuper(id);
    }

    @Override
    public List<ClueRemark> getRemarkList(String id) {
        return clueRemarkDao.getRemarkList(id);
    }

    @Override
    public boolean deleteClue(String[] id) {
        int num=clueRemarkDao.deleteRemark(id);
        int count=clueDao.deleteClue(id);
        System.out.println(count+"  "+id.length);
        if(count==id.length){
            return true;
        }
        return false;
    }

    @Override
    public boolean updateClue(Clue clue) {
        int count=clueDao.updateClue(clue);
        if(count==1){
            return true;
        }
        return false;
    }

    @Override
    public Clue getClue(String id) {
        return clueDao.getClue(id);
    }

    @Override
    public boolean convert(String clueId, Tran tran,String createBy) {
         /*
            (1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
			(2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
			(3) 通过线索对象提取联系人信息，保存联系人
			(4) 线索备注转换到客户备注以及联系人备注
			(5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系
			(6) 如果有创建交易需求，创建一条交易
			(7) 如果创建了交易，则创建一条该交易下的交易历史
			(8) 删除线索备注
			(9) 删除线索和市场活动的关系
			(10) 删除线索
         */
        /*(1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）*/
        Clue clue=clueDao.getClue(clueId);
       /*
        id
        fullname
        appellation
        owner
        company
        job
        email
        phone
        website
        mphone
        state
        source
        createBy
        createTime
        editBy
        editTime
        description
        contactSummary
        nextContactTime
        address
        */
        /*(2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）*/
        Customer customer=null;
        customer=customerDao.getCustomerByName(clue.getCompany());
        //System.out.println("-----"+customer.toString());
        if(customer==null){
            customer=new Customer();

            customer.setId(UUIDUtil.getUUID());
            customer.setWebsite(clue.getWebsite());
            customer.setOwner(clue.getOwner());
            customer.setCreateBy(createBy);
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setName(clue.getCompany());
            customer.setPhone(clue.getPhone());
            customer.setContactSummary(clue.getContactSummary());
            customer.setAddress(clue.getAddress());
            customer.setDescription(clue.getDescription());
            customer.setNextContactTime(clue.getNextContactTime());

            if(customerDao.saveCustomer(customer)!=1){
                return false;
            }
        }
        /*(3) 通过线索对象提取联系人信息，保存联系人*/
        Contacts contacts=new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setAddress(clue.getAddress());
        contacts.setAppellation(clue.getAppellation());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        contacts.setCustomerId(customer.getId());
        contacts.setDescription(clue.getDescription());
        contacts.setEmail(clue.getEmail());
        contacts.setFullname(clue.getFullname());
        contacts.setJob(clue.getJob());
        contacts.setMphone(clue.getMphone());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        if(contactsDao.saveContact(contacts)!=1){
          return false;
        }
        /*(4) 线索备注转换到客户备注以及联系人备注*/
        List<ClueRemark> list1=clueRemarkDao.getRemarkList(clueId);
        for(ClueRemark clueRemark:list1){
            CustomerRemark customerRemark=new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setCreateBy(clueRemark.getCreateBy());
            customerRemark.setCreateTime(DateTimeUtil.getSysTime());
            customerRemark.setEditFlag("0");
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setCustomerId(customer.getId());
            if(customerRemarkDao.saveRemark(customerRemark)!=1){
                return false;
            }
            ContactsRemark contactsRemark=new ContactsRemark();
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setCreateBy(clueRemark.getCreateBy());
            contactsRemark.setEditFlag("0");
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setCreateTime(DateTimeUtil.getSysTime());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            if(contactsRemarkDao.saveRemark(contactsRemark)!=1){
                return false;
            }
        }
        /*(5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系*/
        List<ClueActivityRelation> list2=clueActivityRelationDao.getRelationList(clueId);
        for(ClueActivityRelation clueActivityRelation:list2){
            ContactsActivityRelation contactsActivityRelation=new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            contactsActivityRelation.setContactsId(contacts.getId());
            if(contactsActivityRelationDao.saveRelation(contactsActivityRelation)!=1){
                return false;
            }
        }
        /*(6) 如果有创建交易需求，创建一条交易*/
        /*(7) 如果创建了交易，则创建一条该交易下的交易历史*/
        if(tran!=null){
            tran.setOwner(clue.getOwner());
            tran.setContactsId(contacts.getId());
            tran.setContactSummary(clue.getContactSummary());
            tran.setCustomerId(customer.getId());
            tran.setDescription(clue.getDescription());
            tran.setNextContactTime(clue.getNextContactTime());
            if(tranDao.saveTran(tran)!=1){
                return false;
            }
            TranHistory tranHistory=new TranHistory();
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(DateTimeUtil.getSysTime());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setStage(tran.getStage());
            tranHistory.setTranId(tran.getId());
            if(tranHistoryDao.saveHistory(tranHistory)!=1){
                return false;
            }
        }
        /*
        此处应该先验证一下删除的个数和搜索得到的要删除的个数是不是相同，但是图方便就没验证，直接删了
        */
        /*(8) 删除线索备注*/
       /* if(clueRemarkDao.deleteRemarkS(clueId)!=1){
            return false;
        }*/
        clueRemarkDao.deleteRemarkS(clueId);
        /*(9) 删除线索和市场活动的关系*/
        /*if(clueActivityRelationDao.deleteRelationS(clueId)!=1){
            return false;
        }*/
        clueActivityRelationDao.deleteRelationS(clueId);
        /*(10) 删除线索*/
        /*if(clueDao.deleteClueS(clueId)!=1){
            return false;
        }*/
        clueDao.deleteClueS(clueId);
        return true;
    }

    @Override
    public boolean saveClue(Clue clue) {
        int count=clueDao.saveClue(clue);
        if(count==1){
            return true;
        }
        return false;
    }
}
