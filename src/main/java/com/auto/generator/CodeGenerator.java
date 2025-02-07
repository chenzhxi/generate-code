package com.auto.generator;

import com.baomidou.mybatisplus.core.toolkit.StringPool;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.InjectionConfig;
import com.baomidou.mybatisplus.generator.config.*;
import com.baomidou.mybatisplus.generator.config.converts.MySqlTypeConvert;
import com.baomidou.mybatisplus.generator.config.converts.PostgreSqlTypeConvert;
import com.baomidou.mybatisplus.generator.config.po.TableInfo;
import com.baomidou.mybatisplus.generator.config.rules.DbColumnType;
import com.baomidou.mybatisplus.generator.config.rules.IColumnType;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;

import java.util.ArrayList;
import java.util.List;

/**
 * 代码生成器入口
 *
 * @author czx
 */
public class CodeGenerator {

    // 支持mysql、postgresql
    static String URL = "jdbc:postgresql://localhost:5432/test";
    static String DRIVER = "org.postgresql.Driver";
    static String USERNAME = "postgres";
    static String PASSWORD = "postgres";
    // 表名，多个用英文逗号分隔
    static String TABLENAME = "t_index_day";

    public static void main(String[] args) {

        // 全局配置
        GlobalConfig globalConfig = new GlobalConfig();
        String projectPath = System.getProperty("user.dir");
        globalConfig.setOutputDir(projectPath + "/src/main/java");
        globalConfig.setAuthor("czx");
        globalConfig.setOpen(false);
        globalConfig.setBaseColumnList(true);
        globalConfig.setFileOverride(true);
        globalConfig.setServiceName("I%sService");

        // 数据源配置
        DataSourceConfig dataSourceConfig = new DataSourceConfig();
        dataSourceConfig.setUrl(URL);
        dataSourceConfig.setDriverName(DRIVER);
        dataSourceConfig.setUsername(USERNAME);
        dataSourceConfig.setPassword(PASSWORD);
        // 数据库方言字段类型转换
        dataSourceConfig.setTypeConvert(new PostgreSqlTypeConvert() {
            @Override
            public IColumnType processTypeConvert(GlobalConfig globalConfig, String s) {
                if ("datetime".equalsIgnoreCase(s) || "timestamp".equals(s)) {
                    return DbColumnType.DATE;
                }
                return super.processTypeConvert(globalConfig, s);
            }
        });

        // 包名配置
        PackageConfig packageConfig = new PackageConfig();
        packageConfig.setModuleName("czx");
        packageConfig.setParent("com.auto");

        // 自定义配置
        InjectionConfig injectionConfig = new InjectionConfig() {
            @Override
            public void initMap() {
                // to do nothing
            }
        };

        injectionConfig.setFileOutConfigList(injectionConfig(projectPath));

        // 配置模板
        TemplateConfig templateConfig = new TemplateConfig();
        templateConfig.setController("/templates/mybatis-plus/controller.java");
        templateConfig.setEntity("/templates/mybatis-plus/entity.java");
        templateConfig.setService("/templates/mybatis-plus/service.java");
        templateConfig.setServiceImpl("/templates/mybatis-plus/serviceImpl.java");
        templateConfig.setXml(null);

        // 策略配置
        StrategyConfig strategyConfig = new StrategyConfig();
        strategyConfig.setNaming(NamingStrategy.underline_to_camel);
        strategyConfig.setColumnNaming(NamingStrategy.underline_to_camel);
        strategyConfig.setEntityLombokModel(true);
        strategyConfig.setRestControllerStyle(true);
        strategyConfig.setTablePrefix("");
        strategyConfig.setInclude(TABLENAME.split(","));
        strategyConfig.setControllerMappingHyphenStyle(true);
        strategyConfig.setTablePrefix(packageConfig.getModuleName() + "_");
        strategyConfig.entityTableFieldAnnotationEnable(true);

        new AutoGenerator()
                .setGlobalConfig(globalConfig)
                .setDataSource(dataSourceConfig)
                .setPackageInfo(packageConfig)
                .setCfg(injectionConfig)
                .setTemplate(templateConfig)
                .setTemplateEngine(new FreemarkerTemplateEngine())
                .setStrategy(strategyConfig)
                .execute();
    }

    /**
     * 新增输出自定义文件，如Dto、Vo、Mapper.xml等
     *
     * @param projectPath 文件路径
     */
    private static List<FileOutConfig> injectionConfig(String projectPath) {
        // 如果模板引擎是 freemarker
        String templatePath = "/templates/mapper.xml.ftl";
        String dtoPath = "/templates/mybatis-plus/dto.java.ftl";
        String voPath = "/templates/mybatis-plus/vo.java.ftl";
        // 自定义输出配置
        List<FileOutConfig> focList = new ArrayList<>();
        // 自定义配置会被优先输出
        focList.add(new FileOutConfig(templatePath) {
            @Override
            public String outputFile(TableInfo tableInfo) {
                // 自定义输出文件名 ， 如果你 Entity 设置了前后缀、此处注意 xml 的名称会跟着发生变化！！
                return projectPath + "/src/main/resources/mapper/" + tableInfo.getEntityName() + "Mapper" + StringPool.DOT_XML;
            }
        });
        // 新增dto文件
        focList.add(new FileOutConfig(dtoPath) {
            @Override
            public String outputFile(TableInfo tableInfo) {
                // 自定义输出文件名 ， 如果你 Entity 设置了前后缀、此处注意 xml 的名称会跟着发生变化！！
                return projectPath + "/src/main/java/com/auto/czx/dto/" + tableInfo.getEntityName() + "Dto" + StringPool.DOT_JAVA;
            }
        });
        // 新增vo文件
        focList.add(new FileOutConfig(voPath) {
            @Override
            public String outputFile(TableInfo tableInfo) {
                // 自定义输出文件名 ， 如果你 Entity 设置了前后缀、此处注意 xml 的名称会跟着发生变化！！
                return projectPath + "/src/main/java/com/auto/czx/vo/" + tableInfo.getEntityName() + "Vo" + StringPool.DOT_JAVA;
            }
        });

        return focList;
    }

}
