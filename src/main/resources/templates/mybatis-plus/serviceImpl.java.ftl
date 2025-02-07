package ${package.ServiceImpl};

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.lang.Assert;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import ${superServiceImplClassPackage};
import com.smartweb.common.office.excel.utils.ExcelUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;


/**
* 服务实现类
*
* @author ${author}
* @since ${date}
*/
@Slf4j
@Service
public class ${table.serviceImplName} extends ${superServiceImplClass}<${table.mapperName}, ${entity}> implements ${table.serviceName} {

    /**
    * 获取详情
    *
    * @param id 主键
    */
    @Override
    public ${entity}Vo detail(String id){
        ${entity} entity = getById(id);
        Assert.notNull(entity, "xxx[" + id + "]不存在");
        return BeanUtil.copyProperties(entity, ${entity}Vo.class);
    }


    /**
    * 根据关键词获取分页数据
    *
    * @param query 分页查询条件
    */
    @Override
    public IPage<${entity}Vo> pageBy(Query query){
        Page<${entity}> pageable = new Page<>(query.getPage(), query.getRows());
        Page<${entity}> pageData = page(pageable, query.build());
        return PageUtil.convertPage(pageData, ${entity}Vo.class);
    }

    /**
    * 新增
    *
    * @param dto 实体
    */
    @Override
    public void addOrUpdate(${entity}Dto dto) {
        boolean modify = StringUtils.isNotBlank(dto.getId());
        if (modify) {
            ${entity} info = getById(dto.getId());
            Assert.notNull(info, "xxx不存在");
        }

        ${entity} entity = BeanUtil.copyProperties(dto, ${entity}.class);
        saveOrUpdate(entity);
    }


    /**
    * 删除
    *
    * @param ids 主键列表，多个使用英文逗号分隔
    */
    @Override
    public void delete(String ids) {
        List<String> idList = Arrays.asList(ids.split(","));
        List<${entity}> entityList = listByIds(idList);
        // 校验规则
        // entityList.forEach(entity -> Assert.isTrue(entity.getEndTime().after(new Date()), "xxxx，不允许删除"));

        // 逻辑删除
        removeBatchByIds(idList);
    }

    /**
    * 导出
    *
    * @param ids 主键请列表，以英文逗号分隔，为空则导出全部
    */
    @Override
    public void export(List<String> ids, HttpServletResponse response) {
        // 根据勾选数据导出，为空则导出全部
        LambdaQueryWrapper<${entity}> wrapper = new LambdaQueryWrapper<${entity}>().orderByDesc(${entity}::getCreateTime);
        if (CollUtil.isNotEmpty(ids)) {
            wrapper.in(${entity}::getId, ids);
        }
        List<${entity}> entityList = this.list(wrapper);
        // 数据转换
        List<${entity}Vo> exportList = entityList.stream().map(entity -> {
            ${entity}Vo vo = BeanUtil.copyProperties(entity, ${entity}Vo.class);
            // 字典转换
            // vo.setType(AttendanceTypeEnum.resolve(entity.getType()).getName());
            return vo;
        }).collect(Collectors.toList());
        try {
            ExcelUtils.webWriteExcel(response, exportList, ${entity}Vo.class, "xxxxx数据导出");
        } catch (IOException ex) {
            throw new IllegalArgumentException("导出xxxxx数据发生异常:" + ex.getLocalizedMessage());
        }
    }

}
