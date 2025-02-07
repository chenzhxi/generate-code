package ${package.Controller};

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.smartweb.common.framework.result.impl.Result;
import com.smartweb.common.log.producer.annotation.SysLog;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.util.List;

/**
 * 控制器
 *
 * @author ${author}
 * @since ${date}
 */
@RestController("/")
public class ${table.controllerName} {

    @Resource
    private ${table.serviceName} service;

    /**
    * 获取详情
    *
    * @param id 主键
    */
    @SysLog("获取详情")
    @GetMapping("/detail")
    public Result<${entity}Vo> detail(@RequestParam String id) {
        return Result.ok(service.getById(id));
    }

    /**
    * 根据关键词获取分页数据
    *
    * @param query 分页查询条件
    */
    @SysLog("获取分页数据")
    @GetMapping("/pageBy")
    public Result<IPage<${entity}Vo>> pageBy(Query query) {
        return Result.ok(service.pageBy(query));
    }

    /**
    * 新增
    *
    * @param ${entity ? uncap_first} 实体
    */
    @SysLog("新增")
    @PostMapping("/create")
    public Result<String> create(@Valid @RequestBody ${entity}Dto ${entity ? uncap_first}) {
        service.addOrUpdate(${entity ? uncap_first});
        return Result.ok("新增成功");
    }

    /**
    * 修改
    *
    * @param ${entity ? uncap_first} 实体
    */
    @SysLog("修改")
    @PostMapping("/update")
    public Result<String> update(@Valid @RequestBody ${entity}Dto ${entity ? uncap_first}) {
        service.addOrUpdate(${entity ? uncap_first});
        return Result.ok("修改成功");
    }

    /**
    * 删除
    *
    * @param ids 主键列表，多个使用英文逗号分隔
    */
    @SysLog("删除")
    @PostMapping("/delete")
    public Result<String> delete(@RequestParam String ids) {
        service.delete(ids);
        return Result.ok("删除成功");
    }

    /**
    * 导出
    *
    * @param ids 主键列表，以英文逗号分隔，为空则导出全部
    */
    @SysLog("导出")
    @PostMapping("/export")
    public void export(@RequestBody List<String> ids, HttpServletResponse response) {
        service.export(ids, response);
    }

}
