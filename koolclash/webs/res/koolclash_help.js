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

function koolclash_helpSub(){
    layer.open({
        type: 0,
        shade: 0.1,
        skin: 'layui-layer-lan',
        scrollbar: 0,
        title: 'Clash 托管配置 URL【指南】',
        area: ['500px', '260px'],
        fixed: false, //不固定
        resize: false, //禁止拉伸
        maxmin: true,
        shadeClose: 1,
        id: 'LAY_switch_rule_mode',
        content: '<b>只能转换由专业机场提供的 Clash 独有链接，比如：</b><br><b>● 带有clash字样的托管链接</b><br><b>● 托管链接能直接访问并下载到Clash节点信息的</b><br><b>● 如果不符合以上两个条件，可以直接使用【Clash 订阅转换 URL】</b><br><b>● 如果需要定时更新，到【附加功能】开启</b>',
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