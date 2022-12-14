-- 适用于MySQL5.6.5+
-- 备注：5.5.3开始支持utf8mb4，5.6.5开始支持CURRENT_TIMESTAMP(datetime)
-- 干净的数据


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`torna` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `torna`;

/*Table structure for table `compose_additional_page` */

DROP TABLE IF EXISTS `compose_additional_page`;

CREATE TABLE `compose_additional_page` (
                                           `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                           `project_id` bigint(20) unsigned NOT NULL COMMENT 'compose_project.id',
                                           `title` varchar(64) NOT NULL COMMENT '文档标题',
                                           `content` text COMMENT '文档内容',
                                           `order_index` int(11) NOT NULL DEFAULT '0' COMMENT '排序值',
                                           `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1:启用，0：禁用',
                                           `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                                           `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                           `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                           PRIMARY KEY (`id`) USING BTREE,
                                           KEY `idx_projectid` (`project_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='聚合文档附加页';

/*Table structure for table `compose_common_param` */

DROP TABLE IF EXISTS `compose_common_param`;

CREATE TABLE `compose_common_param` (
                                        `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                        `data_id` varchar(64) NOT NULL DEFAULT '' COMMENT '唯一id，md5(doc_id:parent_id:style:name)',
                                        `name` varchar(64) NOT NULL DEFAULT '' COMMENT '字段名称',
                                        `type` varchar(64) NOT NULL DEFAULT 'String' COMMENT '字段类型',
                                        `required` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否必须，1：是，0：否',
                                        `max_length` varchar(64) NOT NULL DEFAULT '-' COMMENT '最大长度',
                                        `example` varchar(1024) NOT NULL DEFAULT '' COMMENT '示例值',
                                        `description` text NOT NULL COMMENT '描述',
                                        `enum_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'enum_info.id',
                                        `compose_project_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'compose_project.id',
                                        `parent_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                                        `style` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0：path, 1：header， 2：请求参数，3：返回参数，4：错误码',
                                        `order_index` int(11) NOT NULL DEFAULT '0' COMMENT '排序索引',
                                        `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                                        `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                        `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                        PRIMARY KEY (`id`) USING BTREE,
                                        UNIQUE KEY `uk_dataid` (`data_id`) USING BTREE,
                                        KEY `idx_compose_project_id` (`compose_project_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='聚合文档公共参数';

/*Table structure for table `compose_doc` */

DROP TABLE IF EXISTS `compose_doc`;

CREATE TABLE `compose_doc` (
                               `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                               `doc_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'doc_info.id',
                               `project_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'compose_project.id',
                               `is_folder` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否文件夹',
                               `folder_name` varchar(64) NOT NULL DEFAULT '' COMMENT '文件夹名称',
                               `parent_id` bigint(20) NOT NULL DEFAULT '0',
                               `origin` varchar(128) NOT NULL DEFAULT '' COMMENT '文档来源',
                               `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                               `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建人',
                               `order_index` int(10) unsigned NOT NULL DEFAULT '0',
                               `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                               `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                               PRIMARY KEY (`id`) USING BTREE,
                               KEY `idx_projectid` (`project_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='文档引用';

/*Table structure for table `compose_project` */

DROP TABLE IF EXISTS `compose_project`;

CREATE TABLE `compose_project` (
                                   `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                   `name` varchar(64) NOT NULL DEFAULT '' COMMENT '项目名称',
                                   `description` varchar(128) NOT NULL DEFAULT '' COMMENT '项目描述',
                                   `space_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '所属空间，space.id',
                                   `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '访问形式，1：公开，2：加密',
                                   `password` varchar(64) NOT NULL DEFAULT '' COMMENT '访问密码',
                                   `creator_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建者userid',
                                   `creator_name` varchar(64) NOT NULL DEFAULT '',
                                   `modifier_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                                   `modifier_name` varchar(64) NOT NULL DEFAULT '',
                                   `order_index` int(11) NOT NULL DEFAULT '0' COMMENT '排序索引',
                                   `show_debug` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否显示调试',
                                   `gateway_url` varchar(128) NOT NULL DEFAULT '' COMMENT '网关url',
                                   `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1：有效，0：无效',
                                   `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                                   `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                   `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                   PRIMARY KEY (`id`) USING BTREE,
                                   KEY `idx_spaceid` (`space_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='组合项目表';

/*Table structure for table `doc_info` */

DROP TABLE IF EXISTS `doc_info`;

CREATE TABLE `doc_info` (
                            `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                            `data_id` varchar(64) NOT NULL DEFAULT '' COMMENT '唯一id，接口规则：md5(module_id:parent_id:url:http_method)。分类规则：md5(module_id:parent_id:name)',
                            `md5` varchar(32) NOT NULL DEFAULT '' COMMENT '文档内容的md5值',
                            `name` varchar(128) NOT NULL DEFAULT '' COMMENT '文档名称',
                            `description` text NOT NULL COMMENT '文档描述',
                            `author` varchar(64) NOT NULL DEFAULT '' COMMENT '维护人',
                            `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0:http,1:dubbo',
                            `url` varchar(256) NOT NULL DEFAULT '' COMMENT '访问URL',
                            `http_method` varchar(12) NOT NULL DEFAULT '' COMMENT 'http方法',
                            `content_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'contentType',
                            `deprecated` varchar(128) DEFAULT '$false$' COMMENT '废弃信息',
                            `is_folder` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否是分类，0：不是，1：是',
                            `parent_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '父节点',
                            `module_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '模块id，module.id',
                            `is_use_global_headers` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否使用全局请求参数',
                            `is_use_global_params` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否使用全局请求参数',
                            `is_use_global_returns` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否使用全局返回参数',
                            `is_request_array` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否请求数组',
                            `is_response_array` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否返回数组',
                            `request_array_type` varchar(16) NOT NULL DEFAULT 'object' COMMENT '请求数组时元素类型',
                            `response_array_type` varchar(16) NOT NULL DEFAULT 'object' COMMENT '返回数组时元素类型',
                            `create_mode` tinyint(4) NOT NULL DEFAULT '0' COMMENT '新增操作方式，0：人工操作，1：开放平台推送',
                            `modify_mode` tinyint(4) NOT NULL DEFAULT '0' COMMENT '修改操作方式，0：人工操作，1：开放平台推送',
                            `creator_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建人',
                            `creator_name` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者昵称user_info.nickname',
                            `modifier_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '修改人',
                            `modifier_name` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者昵称user_info.realname',
                            `order_index` int(11) NOT NULL DEFAULT '0' COMMENT '排序索引',
                            `remark` text COMMENT '备注',
                            `is_show` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否显示',
                            `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                            `is_locked` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否锁住',
                            `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                            `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                            PRIMARY KEY (`id`) USING BTREE,
                            UNIQUE KEY `uk_data_id` (`data_id`) USING BTREE,
                            KEY `idx_moduleid` (`module_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='文档信息';

/*Table structure for table `doc_param` */

DROP TABLE IF EXISTS `doc_param`;

CREATE TABLE `doc_param` (
                             `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                             `data_id` varchar(64) NOT NULL DEFAULT '' COMMENT '唯一id，md5(doc_id:parent_id:style:name)',
                             `name` varchar(64) NOT NULL DEFAULT '' COMMENT '字段名称',
                             `type` varchar(64) NOT NULL DEFAULT 'String' COMMENT '字段类型',
                             `required` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否必须，1：是，0：否',
                             `max_length` varchar(64) NOT NULL DEFAULT '-' COMMENT '最大长度',
                             `example` varchar(1024) NOT NULL DEFAULT '' COMMENT '示例值',
                             `description` text NOT NULL COMMENT '描述',
                             `enum_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'enum_info.id',
                             `doc_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'doc_info.id',
                             `parent_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                             `style` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0：path, 1：header， 2：请求参数，3：返回参数，4：错误码',
                             `create_mode` tinyint(4) NOT NULL DEFAULT '0' COMMENT '新增操作方式，0：人工操作，1：开放平台推送',
                             `modify_mode` tinyint(4) NOT NULL DEFAULT '0' COMMENT '修改操作方式，0：人工操作，1：开放平台推送',
                             `creator_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                             `creator_name` varchar(64) NOT NULL DEFAULT '',
                             `modifier_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                             `modifier_name` varchar(64) NOT NULL DEFAULT '',
                             `order_index` int(11) NOT NULL DEFAULT '0' COMMENT '排序索引',
                             `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                             `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                             `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`) USING BTREE,
                             UNIQUE KEY `uk_dataid` (`data_id`) USING BTREE,
                             KEY `idx_docid` (`doc_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=697 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='文档参数';

/*Table structure for table `enum_info` */

DROP TABLE IF EXISTS `enum_info`;

CREATE TABLE `enum_info` (
                             `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                             `data_id` varchar(64) NOT NULL DEFAULT '' COMMENT '唯一id，md5(module_id:name)',
                             `name` varchar(128) NOT NULL DEFAULT '' COMMENT '枚举名称',
                             `description` varchar(128) NOT NULL DEFAULT '' COMMENT '枚举说明',
                             `module_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'module.id',
                             `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                             `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                             `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`) USING BTREE,
                             KEY `idx_moduleid` (`module_id`) USING BTREE,
                             KEY `idx_dataid` (`data_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='枚举信息';

/*Table structure for table `enum_item` */

DROP TABLE IF EXISTS `enum_item`;

CREATE TABLE `enum_item` (
                             `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                             `enum_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'enum_info.id',
                             `name` varchar(128) NOT NULL DEFAULT '' COMMENT '名称，字面值',
                             `type` varchar(64) NOT NULL DEFAULT '' COMMENT '类型',
                             `value` varchar(64) NOT NULL DEFAULT '' COMMENT '枚举值',
                             `description` varchar(128) NOT NULL DEFAULT '' COMMENT '枚举描述',
                             `order_index` int(11) NOT NULL DEFAULT '0' COMMENT '排序索引',
                             `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                             `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                             `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`) USING BTREE,
                             KEY `idx_enumid` (`enum_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='枚举详情';

/*Table structure for table `mock_config` */

DROP TABLE IF EXISTS `mock_config`;

CREATE TABLE `mock_config` (
                               `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                               `name` varchar(64) NOT NULL DEFAULT '' COMMENT '名称',
                               `data_id` varchar(64) NOT NULL DEFAULT '' COMMENT 'md5(path+query+body)',
                               `path` varchar(128) NOT NULL DEFAULT '',
                               `ip` varchar(64) NOT NULL DEFAULT '' COMMENT '过滤ip',
                               `request_data` text NOT NULL COMMENT '请求参数',
                               `request_data_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '参数类型，0：KV形式，1：json形式',
                               `http_status` int(11) NOT NULL DEFAULT '200' COMMENT 'http状态',
                               `delay_mills` int(11) NOT NULL DEFAULT '0' COMMENT '延迟时间，单位毫秒',
                               `result_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '返回类型，0：自定义内容，1：脚本内容',
                               `response_headers` text NOT NULL COMMENT '响应header，数组结构',
                               `response_body` text NOT NULL COMMENT '响应结果',
                               `mock_script` text COMMENT 'mock脚本',
                               `mock_result` text COMMENT 'mock结果',
                               `doc_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '文档id',
                               `remark` varchar(128) NOT NULL DEFAULT '' COMMENT '备注',
                               `creator_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人id',
                               `creator_name` varchar(64) NOT NULL DEFAULT '' COMMENT '创建人姓名',
                               `modifier_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '修改人id',
                               `modifier_name` varchar(64) DEFAULT NULL COMMENT '修改人',
                               `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                               `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                               `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                               PRIMARY KEY (`id`) USING BTREE,
                               KEY `idx_docid` (`doc_id`) USING BTREE,
                               KEY `idx_dataid` (`data_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='mock配置';

/*Table structure for table `module` */

DROP TABLE IF EXISTS `module`;

CREATE TABLE `module` (
                          `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                          `name` varchar(64) NOT NULL DEFAULT '' COMMENT '模块名称',
                          `project_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'project.id',
                          `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '模块类型，0：自定义添加，1：swagger导入，2：postman导入',
                          `import_url` varchar(128) NOT NULL DEFAULT '' COMMENT '导入url',
                          `basic_auth_username` varchar(128) NOT NULL DEFAULT '' COMMENT 'basic认证用户名',
                          `basic_auth_password` varchar(128) NOT NULL DEFAULT '' COMMENT 'basic认证密码',
                          `token` varchar(128) NOT NULL DEFAULT '' COMMENT '开放接口调用token',
                          `create_mode` tinyint(4) NOT NULL DEFAULT '0' COMMENT '新增操作方式，0：人工操作，1：开放平台推送',
                          `modify_mode` tinyint(4) NOT NULL DEFAULT '0' COMMENT '修改操作方式，0：人工操作，1：开放平台推送',
                          `creator_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                          `modifier_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                          `order_index` int(11) NOT NULL DEFAULT '0' COMMENT '排序索引',
                          `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                          `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                          `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          PRIMARY KEY (`id`) USING BTREE,
                          UNIQUE KEY `uk_token` (`token`) USING BTREE,
                          KEY `idx_projectid` (`project_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='项目模块';

/*Table structure for table `module_config` */

DROP TABLE IF EXISTS `module_config`;

CREATE TABLE `module_config` (
                                 `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                 `module_id` bigint(11) unsigned NOT NULL DEFAULT '0',
                                 `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '配置类型，1：全局header',
                                 `config_key` varchar(128) NOT NULL DEFAULT '' COMMENT '配置key',
                                 `config_value` varchar(128) NOT NULL DEFAULT '' COMMENT '配置值',
                                 `extend_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                                 `description` varchar(256) NOT NULL DEFAULT '' COMMENT '描述',
                                 `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                                 `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                 `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                 PRIMARY KEY (`id`) USING BTREE,
                                 KEY `idx_moduleid_type` (`module_id`,`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='系统配置';

/*Table structure for table `module_environment` */

DROP TABLE IF EXISTS `module_environment`;

CREATE TABLE `module_environment` (
                                      `id` bigint(20) NOT NULL AUTO_INCREMENT,
                                      `module_id` bigint(20) NOT NULL COMMENT 'module.id',
                                      `name` varchar(64) NOT NULL DEFAULT '' COMMENT '环境名称',
                                      `url` varchar(255) NOT NULL DEFAULT '' COMMENT '调试路径',
                                      `is_public` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否公开',
                                      `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                                      `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                      PRIMARY KEY (`id`) USING BTREE,
                                      KEY `uk_moduleid_name` (`module_id`,`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='模块调试环境';

/*Table structure for table `module_environment_param` */

DROP TABLE IF EXISTS `module_environment_param`;

CREATE TABLE `module_environment_param` (
                                            `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                            `data_id` varchar(64) NOT NULL DEFAULT '' COMMENT '唯一id，md5(doc_id:parent_id:style:name)',
                                            `name` varchar(64) NOT NULL DEFAULT '' COMMENT '字段名称',
                                            `type` varchar(64) NOT NULL DEFAULT 'String' COMMENT '字段类型',
                                            `required` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否必须，1：是，0：否',
                                            `max_length` varchar(64) NOT NULL DEFAULT '-' COMMENT '最大长度',
                                            `example` varchar(1024) NOT NULL DEFAULT '' COMMENT '示例值',
                                            `description` text NOT NULL COMMENT '描述',
                                            `enum_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'enum_info.id',
                                            `environment_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'module_environment.id',
                                            `parent_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                                            `style` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0：path, 1：header， 2：请求参数，3：返回参数，4：错误码',
                                            `create_mode` tinyint(4) NOT NULL DEFAULT '0' COMMENT '新增操作方式，0：人工操作，1：开放平台推送',
                                            `modify_mode` tinyint(4) NOT NULL DEFAULT '0' COMMENT '修改操作方式，0：人工操作，1：开放平台推送',
                                            `creator_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                                            `creator_name` varchar(64) NOT NULL DEFAULT '',
                                            `modifier_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                                            `modifier_name` varchar(64) NOT NULL DEFAULT '',
                                            `order_index` int(11) NOT NULL DEFAULT '0' COMMENT '排序索引',
                                            `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                                            `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                            `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                            PRIMARY KEY (`id`) USING BTREE,
                                            UNIQUE KEY `uk_dataid` (`data_id`) USING BTREE,
                                            KEY `idx_environmentid` (`environment_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='模块公共参数';

/*Table structure for table `module_swagger_config` */

DROP TABLE IF EXISTS `module_swagger_config`;

CREATE TABLE `module_swagger_config` (
                                         `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '涓婚敭id',
                                         `module_id` bigint(20) NOT NULL COMMENT 'module.id',
                                         `url` varchar(128) NOT NULL DEFAULT '' COMMENT 'swagger鏂囨。url',
                                         `content` text NOT NULL COMMENT 'swagger鏂囨。鍐呭',
                                         `auth_username` varchar(128) NOT NULL DEFAULT '' COMMENT '璁よ瘉鐢ㄦ埛鍚�',
                                         `auth_password` varchar(128) NOT NULL DEFAULT '' COMMENT '璁よ瘉瀵嗙爜',
                                         `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                         `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                         PRIMARY KEY (`id`),
                                         KEY `idx_moduleid` (`module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='妯″潡swagger閰嶇疆';

/*Table structure for table `open_user` */

DROP TABLE IF EXISTS `open_user`;

CREATE TABLE `open_user` (
                             `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                             `app_key` varchar(100) NOT NULL COMMENT 'appKey',
                             `secret` varchar(200) DEFAULT NULL COMMENT 'secret',
                             `status` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '1启用，0禁用',
                             `applicant` varchar(64) NOT NULL DEFAULT '',
                             `space_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'space.id',
                             `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                             `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                             `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`) USING BTREE,
                             UNIQUE KEY `uk_app_key` (`app_key`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='开放用户';

/*Table structure for table `project` */

DROP TABLE IF EXISTS `project`;

CREATE TABLE `project` (
                           `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                           `name` varchar(64) NOT NULL DEFAULT '' COMMENT '项目名称',
                           `description` varchar(128) NOT NULL DEFAULT '' COMMENT '项目描述',
                           `space_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '所属空间，space.id',
                           `is_private` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否私有项目，1：是，0：否',
                           `creator_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建者userid',
                           `creator_name` varchar(64) NOT NULL DEFAULT '',
                           `modifier_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                           `modifier_name` varchar(64) NOT NULL DEFAULT '',
                           `order_index` int(11) NOT NULL DEFAULT '0' COMMENT '排序索引',
                           `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                           `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                           `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                           PRIMARY KEY (`id`) USING BTREE,
                           KEY `uk_name` (`creator_id`,`name`) USING BTREE,
                           KEY `idx_spaceid` (`space_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='项目表';

/*Table structure for table `project_user` */

DROP TABLE IF EXISTS `project_user`;

CREATE TABLE `project_user` (
                                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                `project_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'project.id',
                                `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'user_info.id',
                                `role_code` varchar(64) NOT NULL DEFAULT '0' COMMENT '角色，guest：访客，dev：开发者，admin：项目管理员',
                                `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                                `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                PRIMARY KEY (`id`) USING BTREE,
                                UNIQUE KEY `uk_projectid_userid` (`project_id`,`user_id`) USING BTREE,
                                KEY `idx_userid` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='项目用户关系表';

/*Table structure for table `prop` */

DROP TABLE IF EXISTS `prop`;

CREATE TABLE `prop` (
                        `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                        `ref_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '关联id',
                        `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型，0：doc_info属性',
                        `name` varchar(64) NOT NULL DEFAULT '',
                        `val` text NOT NULL,
                        `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                        `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        PRIMARY KEY (`id`) USING BTREE,
                        UNIQUE KEY `uk_docid_name` (`ref_id`,`type`,`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='属性表';

/*Table structure for table `share_config` */

DROP TABLE IF EXISTS `share_config`;

CREATE TABLE `share_config` (
                                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '分享形式，1：公开，2：加密',
                                `password` varchar(128) NOT NULL DEFAULT '' COMMENT '密码',
                                `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态，1：有效，0：无效',
                                `module_id` bigint(20) NOT NULL DEFAULT '0' COMMENT 'module.id',
                                `is_all` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否为全部文档',
                                `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                                `remark` varchar(128) NOT NULL DEFAULT '' COMMENT '备注',
                                `creator_name` varchar(64) NOT NULL DEFAULT '' COMMENT '创建人',
                                `is_show_debug` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否显示调试',
                                `is_all_selected_debug` tinyint(4) NOT NULL DEFAULT '1' COMMENT '调试环境是否全选， 1-全选， 0-不选',
                                `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                PRIMARY KEY (`id`) USING BTREE,
                                KEY `idx_moduleid` (`module_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='分享配置表';

/*Table structure for table `share_content` */

DROP TABLE IF EXISTS `share_content`;

CREATE TABLE `share_content` (
                                 `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                 `share_config_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'share_config.id',
                                 `doc_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '文档id',
                                 `parent_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '父id',
                                 `is_share_folder` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否分享整个分类',
                                 `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                                 `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                 `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                 PRIMARY KEY (`id`) USING BTREE,
                                 KEY `idx_shareconfigid_docid` (`share_config_id`,`doc_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='分享详情';

/*Table structure for table `share_environment` */

DROP TABLE IF EXISTS `share_environment`;

CREATE TABLE `share_environment` (
                                     `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                     `share_config_id` bigint(20) unsigned DEFAULT '0' COMMENT '分享配置id',
                                     `module_environment_id` bigint(20) unsigned DEFAULT '0' COMMENT '模块环境id',
                                     PRIMARY KEY (`id`),
                                     KEY `share_environment_share_config_id_index` (`share_config_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='分享环境关联表';

/*Table structure for table `space` */

DROP TABLE IF EXISTS `space`;

CREATE TABLE `space` (
                         `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                         `name` varchar(64) NOT NULL DEFAULT '' COMMENT '空间名称',
                         `creator_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建者userid',
                         `creator_name` varchar(64) NOT NULL DEFAULT '',
                         `modifier_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建者userid',
                         `modifier_name` varchar(64) NOT NULL DEFAULT '',
                         `is_compose` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否组合空间',
                         `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                         `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                         `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='分组表';

/*Table structure for table `space_user` */

DROP TABLE IF EXISTS `space_user`;

CREATE TABLE `space_user` (
                              `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                              `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'user_info.id',
                              `space_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'space.id',
                              `role_code` varchar(64) NOT NULL DEFAULT '' COMMENT '角色，guest：访客，dev：开发者，admin：空间管理员',
                              `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                              `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                              `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                              PRIMARY KEY (`id`) USING BTREE,
                              UNIQUE KEY `uk_groupid_userid` (`space_id`,`user_id`) USING BTREE,
                              KEY `idx_userid` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='分组用户关系表';

/*Table structure for table `system_config` */

DROP TABLE IF EXISTS `system_config`;

CREATE TABLE `system_config` (
                                 `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                 `config_key` varchar(64) NOT NULL DEFAULT '',
                                 `config_value` varchar(256) NOT NULL DEFAULT '',
                                 `remark` varchar(128) NOT NULL DEFAULT '',
                                 `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                                 `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                 `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                 PRIMARY KEY (`id`) USING BTREE,
                                 UNIQUE KEY `uk_configkey` (`config_key`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='系统配置表';

/*Table structure for table `user_dingtalk_info` */

DROP TABLE IF EXISTS `user_dingtalk_info`;

CREATE TABLE `user_dingtalk_info` (
                                      `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                      `nick` varchar(64) NOT NULL DEFAULT '' COMMENT '用户在钉钉上面的昵称',
                                      `name` varchar(64) NOT NULL DEFAULT '' COMMENT '员工名称。',
                                      `email` varchar(128) NOT NULL DEFAULT '' COMMENT '员工邮箱。',
                                      `userid` varchar(128) NOT NULL DEFAULT '' COMMENT '员工的userid。',
                                      `unionid` varchar(128) NOT NULL DEFAULT '' COMMENT '用户在当前开放应用所属企业的唯一标识。',
                                      `openid` varchar(128) NOT NULL DEFAULT '' COMMENT '用户在当前开放应用内的唯一标识。',
                                      `user_info_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'user_info.id',
                                      `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                      `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                      PRIMARY KEY (`id`) USING BTREE,
                                      UNIQUE KEY `uk_unionid` (`unionid`) USING BTREE,
                                      KEY `idx_openid` (`openid`) USING BTREE,
                                      KEY `idx_userid` (`user_info_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='钉钉开放平台用户';

/*Table structure for table `user_info` */

DROP TABLE IF EXISTS `user_info`;

CREATE TABLE `user_info` (
                             `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                             `username` varchar(128) NOT NULL DEFAULT '' COMMENT '登录账号/邮箱',
                             `password` varchar(128) NOT NULL DEFAULT '' COMMENT '登录密码',
                             `nickname` varchar(64) NOT NULL DEFAULT '' COMMENT '昵称',
                             `is_super_admin` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否是超级管理员',
                             `source` varchar(64) NOT NULL DEFAULT 'register',
                             `email` varchar(128) NOT NULL DEFAULT '',
                             `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0：禁用，1：启用，2：重设密码',
                             `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                             `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                             `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`) USING BTREE,
                             UNIQUE KEY `uk_username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='用户表';

/*Table structure for table `user_message` */

DROP TABLE IF EXISTS `user_message`;

CREATE TABLE `user_message` (
                                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'user_info.id',
                                `message` varchar(256) NOT NULL DEFAULT '',
                                `is_read` tinyint(4) NOT NULL DEFAULT '0',
                                `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '同user_subscribe.type',
                                `source_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '同user_subscribe.source_id',
                                `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                PRIMARY KEY (`id`) USING BTREE,
                                KEY `idx_userid` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='站内消息';

/*Table structure for table `user_subscribe` */

DROP TABLE IF EXISTS `user_subscribe`;

CREATE TABLE `user_subscribe` (
                                  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'user_info.id',
                                  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型，1：订阅接口，2：订阅项目',
                                  `source_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '关联id，当type=1对应doc_info.id；type=2对应project.id',
                                  `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
                                  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                  PRIMARY KEY (`id`) USING BTREE,
                                  UNIQUE KEY `uk_userid_type_sourceid` (`user_id`,`type`,`source_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='用户订阅表';

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


-- INSERT DATA

INSERT INTO `system_config` (`config_key`, `config_value`, `remark`, `is_deleted`)
VALUES ('torna.version', '1160', '当前内部版本号。不要删除这条记录！！', 0);

INSERT INTO `user_info` ( `username`, `password`, `nickname`, `is_super_admin`) VALUES
    ('admin','f9560048604e55186198a4a02ba1b9a9','超级管理员',1);
