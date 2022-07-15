/*
 * koolclash_help.js | @houzi-
 * https://github.com/houzi-/Koolshare-Clash-hack
 */
function koolclash_helpSwitchMode(){
    layer.open({
        type: 0,
        shade: 0.1,
        skin: 'layui-layer-lan',
        scrollbar: 0,
        title: '运行模式【指南】',
        area: ['400px', '250px'],
        fixed: false, //不固定
        resize: false, //禁止拉伸
        maxmin: true,
        shadeClose: 1,
        id: 'LAY_switch_rule_mode',
        content: '<b>● 规则【Rule】所有请求根据配置文件规则进行分流</b><br><b>● 全局【Global】所有请求直接发往代理服务器</b><br><b style="color:red;">（该模式需要在面板选择全局代理服务器节点）</b><br><b>● 直连【Direct】所有请求直接发往目的地</b>',
    });
}

function koolclash_helpFlow(){
    layer.open({
        type: 0,
        shade: 0.1,
        skin: 'layui-layer-lan',
        scrollbar: 0,
        title: 'Clash 订阅流量信息【指南】',
        area: ['500px', '280px'],
        fixed: false, //不固定
        resize: false, //禁止拉伸
        maxmin: true,
        shadeClose: 1,
        id: 'LAY_switch_rule_mode',
        content: '<b>此订阅流量显示只要机场提供接口信息都能获取到，比如：</b><br><b>● 大分部机场都会提供</b><br><b>● 不是通过订阅链接获取的信息无法显示</b><br><b>● 上传 Clash 配置文件的流量也无法显示</b><br><b>● 流量使用情况会有误差和延时，请以机场流量使用情况为准</b><br><b>● 多订阅无法进行准确的流量显示</b>',
    });
}

function koolclash_helpSubConverter(){
    layer.open({
        type: 0,
        shade: 0.1,
        skin: 'layui-layer-lan',
        scrollbar: 0,
        title: 'Clash 订阅转换 URL【指南】',
        area: ['500px', '260px'],
        fixed: false, //不固定
        resize: false, //禁止拉伸
        maxmin: true,
        shadeClose: 1,
        id: 'LAY_switch_rule_mode',
        content: '<b>可以转换SS|SSR|V2ray|Trojan|Clash等订阅链接，比如</b><br><b>● ss://xxx|ssr://xxxx|vemss://xxx|trojan://xxx|https://xxx</b><br><b>● 支持多订阅合并成一个配置，使用“|”分开即可，格式：链接1|链接2</b><br><b>● 订阅框一次输入不能太多（比如超过10个分享链接）可能订阅失败</b><br><b>● 如果需要定时更新，到【附加功能】开启</b>',
    });
}

function koolclash_CheckIP(){
    layer.open({
        type: 2,
        //skin: 'myskin',
        shade: 0.1,
        scrollbar: false,
        title: 'IP地址详情页',
        area: ['750px', '170px'],
        fixed: false, //不固定
        resize: false, //禁止拉伸
        move: false,
        maxmin: true,
        shadeClose: 1,
        id: 'LAY_koolclash-ip',
        content: ['https://ip.skk.moe/simple/', 'no'],
    });
}