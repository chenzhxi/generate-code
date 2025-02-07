package ${package.Service};

import com.baomidou.mybatisplus.core.metadata.IPage;
import ${superServiceClassPackage};

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
* 服务类
*
* @author ${author}
* @since ${date}
*/
public interface ${table.serviceName} extends ${superServiceClass}<${entity}> {
    /**
    * 详情
    *
    * @param id 主键
    */
    ${entity}Vo detail(String id);

    /**
    * 根据关键词获取分页数据
    *
    * @param query 分页查询条件
    */
    IPage<${entity}Vo> pageBy(Query query);

    /**
    * 新增
    *
    * @param dto 实体
    */
    void addOrUpdate(${entity}Dto dto);

    /**
    * 删除
    *
    * @param ids 主键列表，多个使用英文逗号分隔
    */
    void delete(String ids);

    /**
    * 导出
    *
    * @param ids 主键列表，以英文逗号分隔，为空则导出全部
    */
    void export(List<String> ids, HttpServletResponse response);
}
