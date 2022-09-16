<title>KoolClash - Clash for Koolshare OpenWrt/LEDE</title>
<content>
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script type="text/javascript" src="/res/koolclash_base64.js"></script>
    <script type="text/javascript" src="/js/tomato.js"></script>
    <script type="text/javascript" src="/js/advancedtomato.js"></script>
    <script type="text/javascript" src="/layer/layer.js"></script>
    <script type="text/javascript" src="/res/koolclash_help.js"></script>	
    <style type="text/css">
        .box,
        #clash_tabs {
            min-width: 720px;
        }

        .koolclash-divider {
            content: '|';
            margin: 0 5px;
        }

        .koolclash-btn-container {
            padding: 4px;
            padding-left: 8px;
        }

        hr {
            opacity: 1;
            border: 1px solid #ccc;
            margin: 1rem 0;
        }

        #koolclash-ip .ip-title {
            font-weight: bold;
            color: #444;
        }

        #koolclash-ip .sk-text-success {
            color: #32b643
        }

        #koolclash-ip .sk-text-error {
            color: #e85600
        }

        #koolclash-ip p {
            margin: 2px 0;
        }

        #koolclash-btn-upload {
            margin-bottom: 8px;
            margin-left: 4px;
        }

        #koolclash-btn-download {
            margin-bottom: 8px;
            margin-left: 4px;
        }

        #koolclash-btn-submit-watchdog {
            margin-bottom: 5px;
            margin-left: 8px;
        }

        #koolclash-btn-submit-node-memory {
            margin-bottom: 5px;
            margin-left: 8px;
        }

        #koolclash-btn-submit-update-sub {
            margin-bottom: 5px;
            margin-left: 8px;
        }

        #koolclash-dns-msg {
            font-size: 85%;
            margin-top: 8px
        }

        #koolclash-config-dns {
            margin-top: 16px;
        }

        #koolclash-btn-submit-device-control {
            margin-top: 16px;
        }

        #_koolclash_config_suburl {
            width: 61.8%;
        }

        #_koolclash_config_subconverter_url {
            width: 61.8%;
        }

        #koolclash-version-msg {
            font-size: 14px;
        }

        fieldset .help-block {
            margin: 0;
        }

        label {
            cursor: default;
        }

        label.koolclash-nav-label {
            padding: 0;
            cursor: pointer;
        }

        .koolclash-nav-radio {
            display: none;
        }

        .koolclash-nav-tab {
            display: block;
            padding: 0 15px;
            height: 40px;
            font-weight: normal;
            line-height: 40px;
            text-shadow: 0 1px 0 rgba(255, 255, 255, 0.2);
            transition: all 100ms ease;
            -webkit-transition: all 100ms ease;
            text-decoration: none;
            outline: 0;
        }

        .koolclash-nav-tab:hover {
            z-index: 999;
            color: #777777;
            background: rgba(0, 0, 0, 0.05);
            border-bottom: 2px solid rgba(0, 0, 0, 0.05);
            text-decoration: none;
        }


        #koolclash-nav-overview:checked~.nav-tabs .koolclash-nav-overview>.koolclash-nav-tab,
        #koolclash-nav-config:checked~.nav-tabs .koolclash-nav-config>.koolclash-nav-tab,
        #koolclash-nav-firewall:checked~.nav-tabs .koolclash-nav-firewall>.koolclash-nav-tab,
        #koolclash-nav-control:checked~.nav-tabs .koolclash-nav-control>.koolclash-nav-tab,
        #koolclash-nav-additional:checked~.nav-tabs .koolclash-nav-additional>.koolclash-nav-tab,
        #koolclash-nav-log:checked~.nav-tabs .koolclash-nav-log>.koolclash-nav-tab,
        #koolclash-nav-debug:checked~.nav-tabs .koolclash-nav-debug>.koolclash-nav-tab {
            border-bottom: 2px solid #f36c21;
            background: transparent;
            z-index: 999;
            color: #777777;
        }

        .tab-content>* {
            display: none;
        }

        #koolclash-nav-overview:checked~.tab-content>#koolclash-content-overview,
        #koolclash-nav-config:checked~.tab-content>#koolclash-content-config,
        #koolclash-nav-firewall:checked~.tab-content>#koolclash-content-firewall,
        #koolclash-nav-control:checked~.tab-content>#koolclash-content-control,
        #koolclash-nav-additional:checked~.tab-content>#koolclash-content-additional,
        #koolclash-nav-log:checked~.tab-content>#koolclash-content-log,
        #koolclash-nav-debug:checked~.tab-content>#koolclash-content-debug {

            display: block;
        }

        #_koolclash_log {
            max-width: 100%;
            min-width: 100%;
            margin: 0;
            min-height: 300px;
            max-height: 500px;
            font-family: Consolas, "Panic Sans", "DejaVu Sans Mono", Monaco, "Bitstream Vera Sans Mono", 'Andale Mono', Menlo, monospace !important;
        }

        #_koolclash_debug_info {
            max-width: 100%;
            min-width: 100%;
            margin: 0;
            min-height: 600px;
            font-family: Consolas, "Panic Sans", "DejaVu Sans Mono", Monaco, "Bitstream Vera Sans Mono", 'Andale Mono', Menlo, monospace !important;
        }

        table.line-table tr:nth-child(even) {
            background: rgba(0, 0, 0, 0.04)
        }

        table.line-table tr:hover {
            background: #D7D7D7
        }

        table.line-table tr:hover .progress {
            background: #D7D7D7
        }

        .radio-button-1 {
            display: none;
            white-space: nowrap;
            background-color: #d1d1d1;
            border-radius: 4px;
        }

        .radio-button-1 input[type="radio"] {
            display: none;
        }

        .radio-button-1 label {
            display: inline-block;
            font-size: 14px;
            padding: 8px 16px;
            color: white;
            cursor: pointer;
            border-radius: 4px;
        }

        .radio-button-1 input[type="radio"]:checked+label {
            background-color: #1080c1;
        }

        .radio-button-2 {
            display: none;
            white-space: nowrap;
            background-color: #808080;
            border-radius: 4px;
        }

        .radio-button-2 input[type="radio"] {
            display: none;
        }

        .radio-button-2 label {
            display: inline-block;
            font-size: 14px;
            padding: 8px 16px;
            color: white;
            cursor: pointer;
            border-radius: 4px;
        }

        .radio-button-2 input[type="radio"]:checked+label {
            background-color: #000066;
        }

        .myskin {
            background-color: transparent;/*背景透明*/
            box-shadow: 0 0 0 rgba(0,0,0,0);/*前景无阴影*/
        }

        .flow-progressbar {
            color: #0f0f0f;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 3px;
            position: relative;
            min-width: 170px;
            height: 20px;
            line-height: 20px;
            margin: 4px 0;
        }

        .flow-progressbar > div {
            background: #67ba2f;
            height: 100%;
            transition: width .25s ease-in;
            width: 0%;
        }
		
        .flow-progressbar::after {
            position: absolute;
            bottom: 0;
            top: 0;
            right: 0;
            left: 0;
            text-align: center;
            text-shadow: 0 0 2px #fff;
            content: attr(title);
            white-space: pre;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        #koolclash-acl-port-panel {
            margin-top: 16px;
        }

        /* Switch开关样式 */
        /* 必须是input为 checkbox class 添加 switch 才能实现以下效果 */
        input[type='checkbox'].switch {
            outline: none;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            position: relative;
            width: 40px;
            height: 20px;
            background: #ccc;
            border-radius: 10px;
            transition: border-color .3s, background-color .3s;
        }

        input[type='checkbox'].switch::after {
            content: '';
            display: inline-block;
            width: 1rem;
            height:1rem;
            border-radius: 50%;
            background: #fff;
            box-shadow: 0, 0, 2px, #999;
            transition:.4s;
            top: 1px;
            position: absolute;
            left: 2px;
        }

        input[type='checkbox'].switch:checked {
            background: rgb(19, 206, 102);
        }
        /* 当input[type=checkbox]被选中时：伪元素显示下面样式 位置发生变化 */
        input[type='checkbox'].switch:checked::after {
            content: '';
            position: absolute;
            left: 55%;
            top: 1px;
        }

        #koolclash-config > fieldset:nth-child(4) > div {
            padding-top: 12.45;
            padding-bottom: 0px;
            padding-top: 13.5;
            padding-top: 13.5;
            padding-top: 11px;
        }

        input#koolclash-return-chnip.switch {
            color: #fafafa;
            margin: 0;
            line-height: normal;
            font-size: 10pt;
            font-family: "Segoe UI", "Roboto", sans-serif, Helvetica, Arial, sans-serif;
            border: 1px solid #fafafa;
            vertical-align: baseline;
        }

    </style>
    <script>
        var softcenter = 0;
    </script>

    <div class="box">
        <div class="heading">
            <a style="padding-left: 0; color: #0099FF; font-size: 20px;" href="https://koolclash.js.org" target="_blank">KoolClash - Clash for Koolshare OpenWrt/LEDE</a>
            <a href="#/soft-center.asp" class="btn" style="float: right; margin-right: 5px; border-radius:3px; margin-top: 0px;">返回</a>
            <br>
            <span id="koolclash-version-msg"></span>
            <!--<a href="https://github.com/koolshare/ledesoft/blob/master/v2ray/Changelog.txt" target="_blank"
                class="btn btn-primary" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">更新日志</a>-->
            <!--<button type="button" id="updateBtn" onclick="check_update()" class="btn btn-primary" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">检查更新 <i class="icon-upgrade"></i></button>-->
        </div>
        <div class="content">
            <div class="col" style="line-height: 30px;">
                <p style="margin-top: 4px">Clash 是一个基于规则的代理程序，兼容 Shadowsocks、Vmess 等协议，拥有像 Surge 一样强大的代理规则。</p>
                <p>KoolClash 是 Clash 在 Koolshare OpenWrt 上的客户端。</p>

                <p style="margin-top: 12px"><a href="https://github.com/Dreamacro/clash">Clash on GitHub</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://koolclash.js.org" target="_blank">KoolClash 使用文档</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://github.com/houzi-/Koolshare-Clash-hack/releases" target="_blank">KoolClash 更新日志</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://github.com/houzi-/Koolshare-Clash-hack" target="_blank">KoolClash on GitHub</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://telegram.clash.dev" target="_blank">Telrgram</a></p>

            </div>
        </div>
    </div>

    <!-- Basic Elements used for tab -->
    <input class="koolclash-nav-radio" id="koolclash-nav-overview" type="radio" name="nav-tab" checked>
    <input class="koolclash-nav-radio" id="koolclash-nav-config" type="radio" name="nav-tab">
    <input class="koolclash-nav-radio" id="koolclash-nav-firewall" type="radio" name="nav-tab">
    <input class="koolclash-nav-radio" id="koolclash-nav-control" type="radio" name="nav-tab">    
    <input class="koolclash-nav-radio" id="koolclash-nav-additional" type="radio" name="nav-tab">
    <input class="koolclash-nav-radio" id="koolclash-nav-log" type="radio" name="nav-tab">
    <input class="koolclash-nav-radio" id="koolclash-nav-debug" type="radio" name="nav-tab">

    <!-- Msg Elements -->
    <div id="msg_success" class="alert alert-success icon" style="display: none;"></div>
    <div id="msg_error" class="alert alert-error icon" style="display: none;"></div>
    <div id="msg_warning" class="alert alert-warning icon" style="display: none;"></div>

    <ul class="nav nav-tabs">
        <li>
            <label class="koolclash-nav-overview koolclash-nav-label" for="koolclash-nav-overview">
                <div class="koolclash-nav-tab">
                    <i class="icon-info"></i>
                    运行状态
                </div>
            </label>
        </li>
        <li>
            <label class="koolclash-nav-config koolclash-nav-label" for="koolclash-nav-config">
                <div class="koolclash-nav-tab">
                    <i class="icon-system"></i>
                    配置文件
                </div>
            </label>
        </li>
        <li>
            <label class="koolclash-nav-firewall koolclash-nav-label" for="koolclash-nav-firewall">
                <div class="koolclash-nav-tab">
                    <i class="icon-globe"></i>
                    访问控制
                </div>
            </label>
        </li>
        <li>
            <label class="koolclash-nav-control koolclash-nav-label" for="koolclash-nav-control">
                <div class="koolclash-nav-tab">
                    <i class="icon-lock"></i>
                    设备控制
                </div>
            </label>
        </li>
        <li>
            <label class="koolclash-nav-additional koolclash-nav-label" for="koolclash-nav-additional">
                <div class="koolclash-nav-tab">
                    <i class="icon-wake"></i>
                    附加功能
                </div>
            </label>
        </li>
        <li>
            <label class="koolclash-nav-log koolclash-nav-label" for="koolclash-nav-log">
                <div class="koolclash-nav-tab">
                    <i class="icon-hourglass"></i>
                    操作日志
                </div>
            </label>
        </li>
        <li>
            <label class="koolclash-nav-debug koolclash-nav-label" for="koolclash-nav-debug">
                <div class="koolclash-nav-tab">
                    <i class="icon-warning"></i>
                    调试工具
                </div>
            </label>
        </li>
    </ul>
    <div class="tab-content">
        <div id="koolclash-content-overview">
            <div class="box">
                <div class="heading">KoolClash 管理</div>

                <div class="content">
                    <!-- ### KoolClash 运行状态 ### -->
                    <div id="koolclash-field"></div>
                    <div class="koolclash-btn-container">
                        <button type="button" id="koolclash-btn-start-clash" onclick="KoolClash.restart()" class="btn btn-success">启动/重启 Clash</button>
                        <button type="button" id="koolclash-btn-stop-clash" onclick="KoolClash.stop()" class="btn btn-danger">停止 Clash</button>
                    </div>
                </div>
            </div>

            <div id="koolclash-ip" class="box">
                <div class="heading" style="padding-right: 20px;">
                    <div style="display: flex;">
                        <div style="width: 61.8%">IP 地址检查</div>
                        <div style="width: 31.2%">网站访问检查</div>
                    </div>
                </div>

                <div class="content">
                    <!-- ### KoolClash IP ### -->
                    <div style="display: flex;">
                        <div style="width: 61.8%">
                            <p><span class="ip-title">IPIP&nbsp;&nbsp;国内</span>:&nbsp;<span id="ip-ipipnet"></span></p>
                            <!--<p><span class="ip-title">搜狐&nbsp;&nbsp;国内</span>:&nbsp;<span id="ip-sohu"></span>&nbsp;<span id="ip-sohu-ipip"></span></p>-->
							<span class="ip-title"></span><span id="ip-sohu"></span>&nbsp;<span id="ip-sohu-ipip"></span></p>
                            <!-- <p><span class="ip-title">IP.SB&nbsp;海外</span>:&nbsp;<span id="ip-ipsb"></span>&nbsp;<span id="ip-ipsb-geo"></span></p> -->
                            <p><span class="ip-title">IPAPI&nbsp;海外</span>:&nbsp;<span id="ip-ipapi"></span>&nbsp;<span id="ip-ipapi-geo"></span></p>
                        </div>
                        <div style="width: 38.2%">
                            <p><span class="ip-title">百度搜索</span>&nbsp;:&nbsp;<span id="http-baidu"></span></p>
                            <!-- <p><span class="ip-title">网易云音乐</span>&nbsp;:&nbsp;<span id="http-163"></span></p> -->
                            <p><span class="ip-title">GitHub</span>&nbsp;:&nbsp;<span id="http-github"></span></p>
                            <p><span class="ip-title">YouTube</span>&nbsp;:&nbsp;<span id="http-youtube"></span></p>
                        </div>
                    </div>
                    <p><span style="float: right">Powered by <a href="https://ip.skk.moe" target="_blank">ip.skk.moe</a></span></p>
                </div>
            </div>

            <div class="box">
                <div class="heading" style="padding-bottom: 4px">Clash 外部控制</div>
                <div class="content">
                    <!-- ### KoolClash 面板 ### -->
                    <div id="koolclash-dashboard-info"></div>

                    <div class="koolclash-btn-container">
                        <a href="#" target="_blank" id="btn-open-clash-dashboard" class="btn btn-primary">访问 Clash 面板</a>
                        <button type="button" id="koolclash-btn-submit-control" onclick="KoolClash.submitExternalControl();" class="btn">提交外部控制配置</button>
                        <p style="margin-top: 8px">只有在 Clash 正在运行的时候才可以访问 Clash 面板</p>
                    </div>
                </div>
            </div>

        </div>
        <div id="koolclash-content-config">
            <div class="box">
                <div class="heading">KoolClash 配置文件</div>

                <div class="content">
                    <!-- ### KoolClash 运行配置设置 ### -->
                    <div id="koolclash-config"></div>
                    <div class="koolclash-btn-container">
                        <!--
                        <button type="button" id="koolclash-btn-update-sub" onclick="KoolClash.updateRemoteConfig();" class="btn">更新 Clash 托管配置</button>
                        -->
                        <button type="button" id="koolclash-btn-update-subconverter" onclick="KoolClash.updateSubConfig();" class="btn btn-success">开始 Clash 订阅转换</button>
                        <button type="button" id="koolclash-btn-del-suburl" onclick="KoolClash.deleteSuburl();" class="btn btn-danger">删除托管和订阅 URL（保留 Clash 配置）</button>
                    </div>
                </div>
            </div>
            <div class="box">
                <div class="heading">自定义 DNS 配置</div>
                <div class="content">
                    <!-- ### KoolClash DNS 设置 ### -->
                    <div id="koolclash-config-dns"></div>
                    <div class="koolclash-btn-container">
                        <button type="button" id="koolclash-btn-save-dns-config" onclick="KoolClash.submitDNSConfig();" class="btn btn-primary">提交 DNS 配置</button>
                    </div>
                </div>
            </div>
        </div>
        <div id="koolclash-content-firewall">
            <div class="box">
                <!--<div class="heading">访问控制主机</div>
                <div class="content">
                    <div class="tabContent">
                        <table class="line-table" cellspacing="1" id="koolclash-acl-panel"></table>
                    </div>
                </div>-->
                <div class="heading">端口控制</div>
                <div class="content">
                    <!--<p style="color: red; font-weight: 600">功能开发中，尚不可用！</p>-->
                    <p style="color: #999">
                        &nbsp;&nbsp;除了设置的端口控制外，其它端口都将走默认的模式。
                        <br>
                        &nbsp;&nbsp;常用端口包括 21 22 80 8080 8880 2052 2082 2086 2095 443 2053 2083 2087 2096 8443
                    </p>
                    <div id="koolclash-acl-port-panel" class="section"></div>
                    <br>
                    <div class="koolclash-btn-container">
                        <button type="button" id="koolclash-btn-submit-port" onclick="KoolClash.acl.submitPort();" class="btn btn-primary">提交</button>
                    </div>
                </div>
            </div>
            <div class="box">
                <div class="heading">IP/CIDR 白名单</div>
                <div class="content">
                    <div id="koolclash-firewall-ipset"></div>
                    <div class="koolclash-btn-container">
                        <button type="button" id="koolclash-btn-submit-white-ip" onclick="KoolClash.acl.submitWhiteIP();" class="btn btn-primary">提交</button>
                    </div>
                </div>
            </div>
            <div class="box">
                <div class="heading">域名白名单</div>
                <div class="content">
                    <div id="koolclash-firewall-ipset-domain"></div>
                    <div class="koolclash-btn-container">
                        <button type="button" id="koolclash-btn-submit-white-domain" onclick="KoolClash.acl.submitWhiteDOMAIN();" class="btn btn-primary">提交</button>
                    </div>
                </div>
            </div>
            <div class="box">
                <div class="heading">IP/CIDR 黑名单</div>
                <div class="content">
                    <div id="koolclash-firewall-black-ipset"></div>
                    <div class="koolclash-btn-container">
                        <button type="button" id="koolclash-btn-submit-black-ip" onclick="KoolClash.acl.submitBlackIP();" class="btn btn-primary">提交</button>
                    </div>
                </div>
            </div>
            <div class="box">
                <div class="heading">域名黑名单</div>
                <div class="content">
                    <div id="koolclash-firewall-black-ipset-domain"></div>
                    <div class="koolclash-btn-container">
                        <button type="button" id="koolclash-btn-submit-black-domain" onclick="KoolClash.acl.submitBlackDOMAIN();" class="btn btn-primary">提交</button>
                    </div>
                </div>
            </div>
        </div>
        <div id="koolclash-content-control">
            <div class="box">
                <div class="heading" >设备访问控制</div>
                <div class="content">
                    <div class="tabContent">
                        <table class="line-table" cellspacing=1 id="koolclash-acl"></table>
                    </div>
                    <div class="koolclash-btn-container">
                        <button type="button" id="koolclash-btn-submit-device-control" onclick="SubmitControl();" class="btn btn-primary">提交</button>
                    </div>
                </div>
            </div>		
        </div>
        <div id="koolclash-content-log">
            <div class="box">
                <div class="heading">KoolClash 操作日志</div>
                <div class="content">
                    <textarea class="as-script" name="koolclash_log" id="_koolclash_log" readonly wrap="off" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                </div>
            </div>
        </div>
        <div id="koolclash-content-debug">
            <div class="box">
                <div class="heading">KoolClash 调试工具</div>
                <div class="content">
                    <p>KoolClash 的调试工具，可以输出 KoolClash 的相关信息、参数。在反馈 KoolClash 的使用问题时附上相关信息可以帮助开发者更好的定位问题。</p>

                    <button type="button" id="koolclash-btn-debug" onclick="KoolClash.debugInfo();" class="btn btn-danger" style="margin-top: 6px; margin-bottom: 12px">获取 KoolClash 调试信息</button>

                    <textarea class="as-script" name="koolclash_debug_info" id="_koolclash_debug_info" readonly wrap="off" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                </div>
            </div>
        </div>
        <div id="koolclash-content-additional">
            <div class="box">
                <div class="heading">Clash 看门狗</div>
                <div class="content">
                    <p>KoolClash 实现的 Clash 进程守护工具，每 20 秒检查一次 Clash 进程是否存在，如果 Clash 进程丢失则会自动重新拉起。</p>
                    <p style="color:red; margin-top: 8px">注意！Clash 不支持保存节点选择状态！Clash 进程重新启动后节点可能会变动，因此务必谨慎启用该功能！</p>
                    <div id="koolclash-watchdog-panel" style="margin-top: 16px"></div>
                </div>
            </div>
            <div class="box">
                <div class="heading">Clash 节点记忆</div>
                <div class="content">
                    <p>Clash 自带的节点记忆功能，每 1 分钟保存一次节点配置信息，下次 Clash 启动将会沿用上次启动时的配置。</p>
                    <p style="color:red; margin-top: 8px">注意！Clash 节点记忆只针对 proxy group name！Clash 其它配置信息将不会进行保存！机场节点不稳定请谨慎使用该功能！</p>
                    <div id="koolclash-node-memory-panel" style="margin-top: 16px"></div>
                </div>
            </div>
            <div class="box">
                <div class="heading">Clash 配置定时更新</div>
                <div class="content">
                    <p>KoolClash 通过OpenWrt自带的crontab实现每天定时定点更新 Clash 订阅配置文件。</p>
                    <p style="color:red; margin-top: 8px">注意！不支持 Clash配置文件上传的更新，只支持 Clash 订阅 URL 的更新！</p>					
                    <div id="koolclash-update-sub-panel" style="margin-top: 16px"></div>
                </div>
            </div>			
            <div class="box">
                <div class="heading">GeoIP 数据库</div>
                <div class="content">
                    <p>Clash 使用由 <a href="https://www.maxmind.com/" target="_blank">MaxMind</a> 提供的 <a href="https://dev.maxmind.com/geoip/geoip2/geolite2/" target="_blank">GeoLite2</a> IP 数据库解析 GeoIP 规则</p>
                    <div id="koolclash-ipdb-panel" style="margin-top: 8px"></div>
                </div>
            </div>
            <div class="box">
                <div class="heading">CHNRoute 数据库</div>
                <div class="content">
                    <p>Clash 使用由 <a href="https://www.koolcenter.com/" target="_blank">Clang</a> 提供的 <a href="https://ispip.clang.cn/all_cn.txt" target="_blank">CHNRoute</a> IP 数据库分流规则</p>
                    <div id="koolclash-chn-panel" style="margin-top: 8px"></div>
                </div>
            </div>			
        </div>
    </div>

    <script>
        // IP 检查
        var IP = {
            get: (url, type) =>
                fetch(url, { method: 'GET' }).then((resp) => {
                    if (type === 'text')
                        return Promise.all([resp.ok, resp.status, resp.text(), resp.headers]);
                    else {
                        return Promise.all([resp.ok, resp.status, resp.json(), resp.headers]);
                    }
                }).then(([ok, status, data, headers]) => {
                    if (ok) {
                        let json = {
                            ok,
                            status,
                            data,
                            headers
                        }
                        return json;
                    } else {
                        throw new Error(JSON.stringify(json.error));
                    }
                }).catch(error => {
                    throw error;
                }),
//           parseIPIpip: (ip, elID) => {
//               IP.get(`https://api.skk.moe/network/parseIp/ipip/v3/${ip}`, 'json')
//                   .then(resp => {
//                       let x = '';
//                      for (let i of resp.data) {
//                           x += (i !== '') ? `${i} ` : '';
//                       }
//
//                        E(elID).innerHTML = x;
//                        //E(elID).innerHTML = `${resp.data.country} ${resp.data.regionName} ${resp.data.city} ${resp.data.isp}`;
//                    })
//            },
            parseIPIpip: (ip) => {
                IP.get(`https://api.ip.sb/geoip/${ip}`, 'json')
                    .then(resp => {
                        E('ip-ipapi-geo').innerHTML = resp.data.country;
                        return resp.data.country;					
                    })
            },
            getIpipnetIP: () => {
				IP.get(`https://forge.speedtest.cn/api/location/info?${+(new Date)}`, 'json')
                //IP.get(`https://myip.ipip.net?${+(new Date)}`, 'text')
					.then(resp => E('ip-ipipnet').innerHTML = resp.data.full_ip + ' ' + resp.data.city + ' ' + resp.data.distinct + ' ' + resp.data.net_str);
                    //.then(resp => E('ip-ipipnet').innerHTML = resp.data.replace('当前 IP：', '').replace('来自于：', ''));
            },
            //getSohuIP: (data) => {
                //E('ip-sohu').innerHTML = returnCitySN.cip;
                //IP.parseIPIpip(returnCitySN.cip, 'ip-sohu-ipip');
            //},
            //getIpsbIP: (data) => {
                //E('ip-ipsb').innerHTML = data.address;
                //E('ip-ipsb-geo').innerHTML = `${data.country} ${data.province} ${data.city} ${data.isp.name}`
            //},
            getIpApiIP: () => {
                IP.get(`https://api.ipify.org/?format=json&id=${+(new Date)}`, 'json')
                    .then(resp => {
                        E('ip-ipapi').innerHTML = resp.data.ip;
                        return resp.data.ip;
                    })
                    .then(ip => {
                        //IP.parseIPIpip(ip, 'ip-ipapi-geo');
						IP.parseIPIpip(ip);
                    })
            },
        };
        // 将淘宝的 jsonp 回调给 IP 函数
        //window.ipCallback = (data) => IP.getTaobaoIP(data);
        // 网站访问检查
        var HTTP = {
            checker: (domain, cbElID) => {
                let img = new Image;
                let timeout = setTimeout(() => {
                    img.onerror = img.onload = null;
                    img = null;
                    E(cbElID).innerHTML = '<span class="sk-text-error">连接超时</span>'
                }, 5000);

                img.onerror = () => {
                    clearTimeout(timeout);
                    E(cbElID).innerHTML = '<span class="sk-text-error">无法访问</span>'
                }

                img.onload = () => {
                    clearTimeout(timeout);
                    E(cbElID).innerHTML = '<span class="sk-text-success">连接正常</span>'
                }

                img.src = `https://${domain}/favicon.ico?${+(new Date)}`
            },
            runcheck: () => {
                HTTP.checker('www.baidu.com', 'http-baidu');
                //HTTP.checker('s1.music.126.net/style', 'http-163');
                HTTP.checker('github.com', 'http-github');
                HTTP.checker('www.youtube.com', 'http-youtube');
            }
        };

        var Msg = {
            show: (type, text) => {
                E(`msg_${type}`).innerHTML = text;
                $(`#msg_${type}`).show();
            },
            hide: (type) => {
                $(`#msg_${type}`).hide();
                E(`msg_${type}`).innerHTML = '';
            }
        };

        var option_time_hour = [];
        for(var i = 0; i < 24; i++){
            option_time_hour[i] = [i, "每天" + i + "点"];
        };

        var dbus;
        get_arp_list();
        get_dbus_data();
        var options_type = [];
        var options_list = [];
        var option_arp_list = [];
        var option_arp_local = [];
        var option_arp_web = [];
        var kcacl = new TomatoGrid();

        kcacl.exist = function( f, v ) {
            var data = this.getAllData();
            for ( var i = 0; i < data.length; ++i ) {
                if ( data[ i ][ f ] == v ) return true;
            }
            return false;
        }
        kcacl.dataToView = function( data ) {
            if (data[0]){
                return [ "【" + data[0] + "】", data[1], "*****************", ['不通过Clash', '通过Clash'][data[3]] ];
            }else{
                if (data[1]){
                    return [ "【" + data[1] + "】", data[1], "*****************", ['不通过Clash', '通过Clash'][data[3]] ];
                }else{
                    if (data[2]){
                        return [ "【" + data[2] + "】", data[1], "*****************", ['不通过Clash', '通过Clash'][data[3]] ];
                    }
                }
            }
        }
        kcacl.fieldValuesToData = function( row ) {
            var f = fields.getAll( row );
            if (f[0].value){
                return [ f[0].value, f[1].value, f[2].value, f[3].value ];
            }else{
                if (f[1].value){
                    return [ f[1].value, f[1].value, f[2].value, f[3].value ];
                }else{
                    if (f[1].value){
                        return [ f[2].value, f[1].value, f[2].value, f[3].value ];
                    }
                }	
            }
        }
        kcacl.onChange = function(which, cell) {
            return this.verifyFields((which == 'new') ? this.newEditor: this.editor, true, cell);
        }
        kcacl.verifyFields = function( row, quiet, cell) {
            var f = fields.getAll( row );
            if ( $(cell).attr("id") == "_[object HTMLTableElement]_1" ) {
                if (f[0].value){
                    f[1].value = option_arp_list[f[0].selectedIndex][2];
                    f[2].value = option_arp_list[f[0].selectedIndex][3];
                }
            }
            if (f[1].value && !f[2].value){
                return v_ip( f[1], quiet );
            }
            if (!f[1].value && f[2].value){
                return v_mac( f[2], quiet );
            }
            if (f[1].value && f[2].value){
                return v_ip( f[1], quiet ) || v_mac( f[2], quiet );
            }
            if (f[0].value == "自定义"){
                console.log("sucess!");
                kcacl.updateUI;
            }
        }
        kcacl.onAdd = function() {
            var data;
            this.moving = null;
            this.rpHide();
            if (!this.verifyFields(this.newEditor, false)) return;
            data = this.fieldValuesToData(this.newEditor);
            this.insertData(1, data);
            this.disableNewEditor(false);
            this.resetNewEditor();
        }
        kcacl.resetNewEditor = function() {
            var f;
            f = fields.getAll( this.newEditor );
            ferror.clearAll( f );
            f[ 0 ].value = '';
            f[ 1 ].value = '';
            f[ 2 ].value = '';
            f[ 3 ].value = '0';
        }
        kcacl.setup = function() {
            this.init( 'koolclash-acl', 'delete', 250, [
                { type: 'select', maxlen: 25, options:option_arp_list },
                { type: 'text', maxlen: 25 },
                { type: 'text', maxlen: 25 },
                { type: 'select', maxlen: 20, options:[['0', '不通过Clash'], ['1', '通过Clash']], value: window.dbus.koolclash_arp_list || '0' },
            ] );
            this.headerSet( [ '主机别名', 'IP地址', 'MAC地址', '模式控制' ] );
            if(typeof(dbus["koolclash_acl_list"]) != "undefined" ){
                var s = dbus["koolclash_acl_list"].split( '>' );
            }else{
                var s =""
                return false;
            }
            for ( var i = 0; i < s.length; ++i ) {
                var t = s[ i ].split( '<' );
                if ( t.length == 4 ) this.insertData( -1, t );
            }
            this.showNewEditor();
            this.resetNewEditor();
        }
        function get_arp_list() {
            var id = parseInt(Math.random() * 100000000);
            var postData1 = {"id": id, "method": "koolclash_getarp.sh", "params":[], "fields": ""};
            $.ajax({
                type: "POST",
                url: "/_api/",
                async: true,
                cache: false,
                data: JSON.stringify(postData1),
                dataType: "json",
                success: function(response) {
                    if (response) {
                        get_dbus_data();
                        var s2 = dbus["koolclash_arp"].split( '>' );
                        for ( var i = 0; i < s2.length; ++i ) {
                            option_arp_local[i] = [s2[ i ].split( '<' )[0],"【" + s2[ i ].split( '<' )[0] + "】",s2[ i ].split( '<' )[1],s2[ i ].split( '<' )[2]];
                        }
                        var s3 = dbus["koolclash_acl_list"].split( '>' );
                        for ( var i = 0; i < s3.length -1; ++i ) {
                            option_arp_web[i] = [s2[ i ].split( '<' )[0],"【" + s2[ i ].split( '<' )[0] + "】",s2[ i ].split( '<' )[1],s2[ i ].split( '<' )[2]];
                        }
                        //option_arp_web[s2.length -1] = ["自定义", "【自定义设备】","",""];
                        option_arp_web[s3.length -1] = ["自定义", "【自定义设备】","",""];
                        option_arp_list = unique_array(option_arp_local.concat( option_arp_web ));
                        kcacl.setup();
                    }
                },
                error:function() {
                    get_dbus_data();
                    var s2 = dbus["koolclash_arp"].split( '>' );
                    for ( var i = 0; i < s2.length; ++i ) {
                        option_arp_local[i] = [s2[ i ].split( '<' )[0],"【" + s2[ i ].split( '<' )[0] + "】",s2[ i ].split( '<' )[1],s2[ i ].split( '<' )[2]];
                    }
                    var s3 = dbus["koolclash_acl_list"].split( '>' );
                    for ( var i = 0; i < s3.length -1; ++i ) {
                        option_arp_web[i] = [s2[ i ].split( '<' )[0],"【" + s2[ i ].split( '<' )[0] + "】",s2[ i ].split( '<' )[1],s2[ i ].split( '<' )[2]];
                    }
                    //option_arp_web[s2.length -1] = ["自定义", "【自定义设备】","",""];
                    option_arp_web[s3.length -1] = ["自定义", "【自定义设备】","",""];
                    option_arp_list = unique_array(option_arp_local.concat( option_arp_web ));
                    kcacl.setup();
                },
                timeout:1000
            });
        }

        function unique_array(array) {
            var r = [];
            for(var i = 0, l = array.length; i < l; i++) {
                for(var j = i + 1; j < l; j++)
                if (array[i][0] === array[j][0]) j = ++i;
                    r.push(array[i]);
            }
            return r.sort();
        }
		
        function get_dbus_data() {
            $.ajax({
                type: "GET",
                url: "/_api/koolclash_",
                dataType: "json",
                async: false,
                success: function(data){
                    dbus = data.result[0];
                }
            });
        }

        function SubmitControl() {
            var data2 = kcacl.getAllData();
            var acllist = '';
            if(data2.length > 0){
				for ( var i = 0; i < data2.length; ++i ) {
                    acllist += data2[ i ].join( '<' ) + '>';
                }
                dbus["koolclash_acl_list"] = acllist;
            }else{
                dbus["koolclash_acl_list"] = " ";
            }
            KoolClash.disableAllButton();
            E('koolclash-btn-submit-device-control').innerHTML = `提交 Clash 设备控制`;
            var id3 = parseInt(Math.random() * 100000000);
            var postData3 = {"id": id3, "method": "koolclash_config.sh", "params":["acl"], "fields": dbus};
            $.ajax({
                url: "/_api/",
                cache: false,
                type: "POST",
                dataType: "json",
                data: JSON.stringify(postData3),
                success: (resp) => {
                    E('koolclash-btn-submit-device-control').innerHTML = `提交成功，Clash 设备控制已生效！`;
                    setTimeout(() => {
                        KoolClash.enableAllButton();
                        E('koolclash-btn-submit-device-control').innerHTML = '提交';
                    }, 2500)
                },
                error: () => {
                    E('koolclash-btn-submit-device-control').innerHTML = `提交失败，请重试！`;
                    setTimeout(() => {
                        KoolClash.enableAllButton();
                        E('koolclash-btn-submit-device-control').innerHTML = '提交';
                    }, 2500)
                }
            });
        }

        var KoolClash = {
            // KoolClash.renderUI()
            // 创建 KoolClash 界面
            renderUI: () => {
                var inputWidth = `min-width: 220px; max-width: 220px`;
                $('#koolclash-field').forms([
                    {
                        title: '<b>Clash 进程状态</b>',
                        text: '<span id="koolclash_status" name="koolclash_status" color="#1bbf35">正在获取 Clash 进程状态...</span>'
                    },
                    {
                        title: '<b>运行模式</b>',
						name: 'koolclash_switch_run_mode',
						suffix: '<span id="radio-run-mode" class="radio-button-2" style="display: inline-block;"><input type="radio" id="fake-ip-enhanced" name="radios-1" size="0"><label for="fake-ip-enhanced">Fake-IP（增强）</label></span>'
					},
                    {
                        title: '<b style="cursor: pointer;" href="javascript:void(0);" onclick="koolclash_helpSwitchMode();">代理模式</b>',
						name: 'koolclash_switch_rule_mode',
						suffix: '<span id="radio-mode" class="radio-button-1" style="display: inline-block;"><input type="radio" id="rule" name="radios" onclick="KoolClash.switchConfigRule();" size="0"><label for="rule">规则</label><input type="radio" id="global" name="radios" onclick="KoolClash.switchConfigGlobal();" size="0"><label for="global">全局</label><input type="radio" id="direct" name="radios" onclick="KoolClash.switchConfigDirect();" size="0"><label for="direct">直连</label></span>',
                        help: '请点击【代理模式】查看帮助信息'
                    },
                    {
                        title: '<b>Clash 看门狗进程状态</b>',
                        text: '<span id="koolclash_watchdog_status" name="koolclash_watchdog_status" color="#1bbf35">正在获取 Clash 看门狗进程状态...</span>'
                    },
                ]);
                $('#koolclash-dashboard-info').forms([
                    {
                        title: '<b>Host</b>',
                        name: 'koolclash_dashboard_host',
                        type: 'text',
                        value: ''
                    },
                    {
                        title: '<b>端口</b>',
                        text: '6170'
                    },
                    {
                        title: '<b>密钥</b>',
                        text: 'clash'
                    },
                ]);
                $('#koolclash-config').forms([
                    {
                        title: '<b>Clash 配置文件更新时间</b>',
                        name: 'koolclash-config-version',
                        text: `${window.dbus.koolclash_config_version || '<font color="#e85600">没有获取到更新时间</font>'}`
                    },
                    {
                        title: '<b>Clash 订阅到期时间</b>',
                        name: 'koolclash-sub-expiration-time',
                        text: `${window.dbus.koolclash_sub_expiration_time || '<font color="#e85600">没有获取到订阅信息</font>'}`
                    },
                    {
                        title: '<b style="cursor: pointer;" href="javascript:void(0);" onclick="koolclash_helpFlow();">Clash 订阅流量信息</b>',
						name: 'koolclash-flow-show',
                        suffix: '<span id="flow_status" style="float:right;margin-right:5px;margin-top:0px;" class="td left"><div id="flow_status_text" style="font-size: 12px;min-width: 270px;" class="flow-progressbar"><div></div></div></span>',
                        help: '请点击【Clash 订阅流量信息】查看帮助信息'
                    },
                    {
                        title: '<b style="cursor: pointer;" href="javascript:void(0);" onclick="koolclash_helpCHN();">Clash 绕过大陆IP</b>',
                        suffix: `<input type="checkbox" id="koolclash-return-chnip" class="switch" onchange="KoolClash.ReturnChnIP()"></input>`,
                        help: '请点击【Clash 绕过大陆IP】查看帮助信息'
                    },
                    {
                        title: '<b>Clash 配置上传</b>',
                        suffix: '<input type="file" id="koolclash-file-config" size="50"><button id="koolclash-btn-upload" type="button" onclick="KoolClash.submitClashConfig();" class="btn btn-primary">上传配置文件</button>'
                    },
                    {
                        title: '<b>Clash 配置导出</b>',
                        suffix: '<button id="koolclash-btn-download" type="button" onclick="KoolClash.downloadClashConfig();" class="btn btn-primary">导出配置文件</button>'
                    },
                    {
                        title: '<b style="cursor: pointer;" href="javascript:void(0);" onclick="koolclash_helpSubConverter();">Clash 订阅转换 URL</b>',
                        name: 'koolclash_config_subconverter_url',
                        type: 'password',
                        peekaboo: 1,
                        value: window.dbus.koolclash_subconverter_url || '',
                        placeholder: 'https://api.tshl.cc/link/adfjkdlfjsdfje',
                        help: '请点击【Clash 订阅转换 URL】查看帮助信息'
                    },
                ]);
                $('#koolclash-config-dns').forms([
                    {
                        title: '<b>DNS 配置开关</b>',
                        name: 'koolclash-dns-config-switch',
                        type: 'checkbox'
                    },
                    {
                        title: '&nbsp;',
                        text: '<p id="koolclash-dns-msg" style="margin-top: 10px; margin-bottom: 6px"></p>'
                    },
                    {
                        title: '',
                        name: 'koolclash-config-dns',
                        type: 'textarea',
                        value: '正在加载存储的 Clash DNS Config 配置...',
                        style: 'width: 100%; height: 200px;'
                    },
                ]);
                $('#koolclash-acl-port-panel').forms([
                    {
                        title: '模式控制',
                        name: 'koolclash-acl-default-mode',
                        type: 'select',
                        //style: select_style,
                        options: [
                            ['0', '不通过 Clash'],
                            ['1', '通过 Clash']
                        ],
                        value: window.dbus.koolclash_firewall_default_mode || '1'
                    },
                    {
                        title: '<b style="cursor: pointer;" href="javascript:void(0);" onclick="koolclash_portControl_pass();">目标端口</b>',
                        name: 'koolclash-acl-default-port',
                        type: 'select',
                        //style: select_style,
                        options: [
                            ['80443', '80,443'],
                            ['1', '常用端口'],
                            ['all', '全部端口']
                        ],
                        value: window.dbus.koolclash_firewall_default_port_mode || 'all',
                        help: '请点击【目标端口】查看帮助信息'
                    },
                    {
                        title: '<b style="cursor: pointer;" href="javascript:void(0);" onclick="koolclash_portControl_return();">目标端口</b>',
                        name: 'koolclash-acl-base-port',
                        type: 'select',
                        //style: select_style,
                        options: [
                            ['off', '禁用'],
                            ['80443', '80,443'],
                            ['1', '常用端口'],
                            ['0', '自定义端口']
                        ],
                        value: window.dbus.koolclash_firewall_base_port_mode || 'off',
                        help: '请点击【目标端口】查看帮助信息'
                    },
                    {
                        title: '&nbsp;',
                        name: 'koolclash-acl-default-port-user',
                        type: 'textarea',
                        value: Base64.decode(window.dbus.koolclash_firewall_default_port_user || '') || '',
                        style: 'width: 80%; height: 50px;',
                    },
                ]);
                $('#koolclash-firewall-ipset').forms([
                    {
                        title: '<p style="color: #999">不通过 Clash 的 IP/CIDR 外网地址，一行一个，例如：<br>119.29.29.29<br>210.2.4.0/24</p>',
                        name: 'koolclash_firewall_white_ipset',
                        type: 'textarea',
                        value: Base64.decode(window.dbus.koolclash_firewall_whiteip_base64 || '') || '',
                        style: 'width: 80%; height: 150px;'
                    },
                ]);
                $('#koolclash-firewall-ipset-domain').forms([
                    {
                        title: '<p style="color: #999">不通过 Clash 的域名外网地址，一行一个，例如：<br>google.com<br>facebook.com</p>',
                        name: 'koolclash_firewall_white_ipset_domain',
                        type: 'textarea',
                        value: Base64.decode(window.dbus.koolclash_firewall_whitedomain_base64 || '') || '',
                        style: 'width: 80%; height: 150px;'
                    },
                ]);
                $('#koolclash-firewall-black-ipset').forms([
                    {
                        title: '<p style="color: #999">通过 Clash 的 IP/CIDR 外网地址，一行一个，例如：<br>119.29.29.29<br>210.2.4.0/24</p>',
                        name: 'koolclash_firewall_black_ipset',
                        type: 'textarea',
                        value: Base64.decode(window.dbus.koolclash_firewall_blackip_base64 || '') || '',
                        style: 'width: 80%; height: 150px;'
                    },
                ]);
                $('#koolclash-firewall-black-ipset-domain').forms([
                    {
                        title: '<p style="color: #999">通过 Clash 的域名外网地址，一行一个，例如：<br>google.com<br>facebook.com</p>',
                        name: 'koolclash_firewall_black_ipset_domain',
                        type: 'textarea',
                        value: Base64.decode(window.dbus.koolclash_firewall_blackdomain_base64 || '') || '',
                        style: 'width: 80%; height: 150px;'
                    },
                ]);
                $('#koolclash-watchdog-panel').forms([
                    {
                        title: 'Clash 看门狗开关',
                        name: 'koolclash-select-watchdog',
                        type: 'select',
                        options: [
                            ['0', '禁用'],
                            ['1', '开启']
                        ],
                        suffix: '<span> &nbsp;&nbsp;</span><button type="button" id="koolclash-btn-submit-watchdog" onclick="KoolClash.submitWatchdog();" class="btn btn-primary">提交</button>',
                        value: window.dbus.koolclash_watchdog_enable || '0',
                    },
                ]);
                $('#koolclash-node-memory-panel').forms([
                    {
                        title: 'Clash 节点记忆开关',
                        name: 'koolclash-select-node-memory',
                        type: 'select',
                        options: [
                            ['0', '禁用'],
                            ['1', '开启']
                        ],
                        suffix: '<span> &nbsp;&nbsp;</span><button type="button" id="koolclash-btn-submit-node-memory" onclick="KoolClash.submitNodeMemory();" class="btn btn-primary">提交</button>',
                        value: window.dbus.koolclash_node_memory_enable || '0',
                    },
                ]);
                $('#koolclash-update-sub-panel').forms([
                    { title: 'Clash 更新开关', multi: [
						{ name: 'koolclash-select-update-sub', type: 'select', options:[['0', '禁用'],['1', '开启']], value: window.dbus.koolclash_update_sub_enable || '0', suffix: ' &nbsp;&nbsp;', },
						{ name: 'koolclash-select-update-sub-time',type: 'select', options:option_time_hour, value: window.dbus.koolclash_update_sub_time || '3' , },
						{ suffix: '<button type="button" id="koolclash-btn-submit-update-sub" onclick="KoolClash.submitUpdateSub();" class="btn btn-primary">提交</button>', }
                    ]},
                ]);				
                $('#koolclash-ipdb-panel').forms([
                    {
                        title: '<b>当前 IP 数据库版本</b>',
                        name: 'koolclash-ipdb-version',
                        text: `${window.dbus.koolclash_ipdb_version || '没有获取到版本信息'}<button type="button" id="koolclash-btn-update-ipdb" onclick="KoolClash.updateIPDB()" class="btn btn-success" style="margin-left: 16px; margin-top: -6px; ">更新 IP 数据库</button>`,
                    },
                ]);
                $('#koolclash-chn-panel').forms([
                    {
                        title: '<b>当前 CHN 数据库版本</b>',
                        name: 'koolclash-chn-version',
                        text: `${window.dbus.koolclash_chn_version || '没有获取到版本信息'}<button type="button" id="koolclash-btn-update-chn" onclick="KoolClash.updateCHN()" class="btn btn-success" style="margin-left: 16px; margin-top: -6px; ">更新 CHN 数据库</button>`,
                    },
                ]);				

                if (E('_koolclash-select-update-sub').value === '0') {
                    $('#_koolclash-select-update-sub-time').hide();
                } else if (E('_koolclash-select-update-sub').value === '1') {
                    $('#_koolclash-select-update-sub-time').show();
                }

                if (E('_koolclash-acl-default-mode').value === '0') {
                    $('#koolclash-acl-port-panel > fieldset:nth-child(3)').show();
                    $('#koolclash-acl-port-panel > fieldset:nth-child(2)').hide();
                    if (E('_koolclash-acl-base-port').value === '0') {
                        $('#_koolclash-acl-default-port-user').show();
                    }
                } else if (E('_koolclash-acl-default-mode').value === '1') {
                    $('#koolclash-acl-port-panel > fieldset:nth-child(2)').show();
                    $('#koolclash-acl-port-panel > fieldset:nth-child(3)').hide();
                    $('#_koolclash-acl-default-port-user').hide();
                }

                //if (E('_koolclash-acl-default-port').value === '0') {
                //    $('#_koolclash-acl-default-port-user').show();
                //} else {
                //    $('#_koolclash-acl-default-port-user').hide();
                //}

                if (E('_koolclash-acl-default-mode').value === '0') {
                    if (E('_koolclash-acl-base-port').value === '0') {			
                        $('#_koolclash-acl-default-port-user').show();
                    } else {
                        $('#_koolclash-acl-default-port-user').hide();
                    }
                }

                $('.koolclash-nav-log').on('click', KoolClash.getLog);
            },
            // 选择 Tab
            // 注意选择的方式是使用 input 的 ID
            selectTab: (inputId) => {
                for (let i of document.getElementsByClassName('koolclash-nav-radio')) {
                    i.removeAttribute('checked');
                }
                E(inputId).click();
            },
            checkUpdate: () => {
                let installed = '',
                    remote = '';
                // 获取本地版本号
                $.ajax({
                    type: "GET",
                    cache: false,
                    url: "/res/koolclash_.version",
                    success: (resp) => {
                        installed = resp;
                        E('koolclash-version-msg').innerHTML = `当前安装版本&nbsp;:&nbsp;${installed}`;
                        // 获取远端版本号
                        $.ajax({
                            type: "GET",
                            cache: false,
                            url: "https://raw.githubusercontent.com/houzi-/Koolshare-Clash-hack/main/koolclash_version",
                            success: (resp) => {
                                remote = resp;
                                E('koolclash-version-msg').innerHTML = `当前安装版本&nbsp;:&nbsp;${installed}&nbsp;&nbsp;/&nbsp;&nbsp;最新发布版本&nbsp;:&nbsp;${remote}`;

                                if (installed !== remote) {
                                    E('koolclash-version-msg').innerHTML = `当前安装版本&nbsp;:&nbsp;${installed}&nbsp;&nbsp;|&nbsp;&nbsp;最新发布版本&nbsp;:&nbsp;${remote}<br>发现「当前安装版本」与「最新发布版本」版本号不同，可能是 KoolClash 有新版本发布，请前往 <a href="https://github.com/houzi-/Koolshare-Clash-hack/releases" target="_blank" style="padding: 0; color: navy">GitHub Release</a> 查看更新日志`;
                                }
                            }
                        });
                    },
                    error: () => {
                        E('koolclash-version-msg').innerHTML = `检测版本失败！`
                    }
                });


                E('koolclash-version-msg').innerHTML = `当前安装版本&nbsp;:&nbsp;<span id="koolclash-version-installed"></span>&nbsp;&nbsp;|&nbsp;&nbsp;最新发布版本&nbsp;:&nbsp;<span id="koolclash-version-remote"></span>`;
            },
            defaultDNSConfig: `# 没有找到保存的 Clash 自定义 DNS 配置，推荐使用以下的配置
dns:
  enable: true
  ipv6: false
  listen: 0.0.0.0:53
  enhanced-mode: fake-ip
  nameserver:
    - 119.28.28.28
    - 119.29.29.29
    - 223.5.5.5
    - tls://dns.rubyfish.cn:853
  fallback:
    - tls://1.0.0.1:853
    - tls://8.8.4.4:853
`,
            // getClashStatus
            // 获取 Clash 进程 PID
            getClashStatus: () => {
                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        id,
                        "method": "koolclash_status.sh",
                        "params": [],
                        "fields": ""
                    });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (softcenter === 1) {
                            return false;
                        }

                        let data = resp.result.split('@'),
                            pid_text = data[0],
                            pid_watchdog_text = data[1],
                            dnsmode = data[2],
                            control_data = data[3],
                            secret = data[4],
                            fallbackdns = data[6];

                        if (fallbackdns === '') {
                            E('_koolclash-config-dns').innerHTML = KoolClash.defaultDNSConfig;
                        } else {
                            E('_koolclash-config-dns').innerHTML = Base64.decode(fallbackdns || '') || KoolClash.defaultDNSConfig;
                        }

                        let control_host = control_data.split(':')[0],
                            control_port = control_data.split(':')[1];

                        control_host = (control_host.length === 0) ? `请先上传 Clash 配置文件！` : control_host;
                        E('koolclash_status').innerHTML = pid_text;
                        E('koolclash_watchdog_status').innerHTML = pid_watchdog_text;
                        E('_koolclash_dashboard_host').value = control_host;
                        E('btn-open-clash-dashboard').href = `http://${control_host}:6170/ui/?hostname=${control_host}&port=6170&secret=${secret}`

                        /*
                         * 0 没有找到 config.yaml
                         * 1 origin.yml DNS 配置合法
                         * 2 origin.yml DNS 配置合法 但是用户想要自定义 DNS
                         * 3 origin.yml DNS 配置不合法而且没有 dns.yml
                         * (4) origin.yml DNS 配置不合法但是有 dns.yml
                         */
                        if (dnsmode === '0') {
                            E('_koolclash-dns-config-switch').checked = false;
                            E('_koolclash-dns-config-switch').setAttribute('disabled', '');
                            $('#koolclash-btn-save-dns-config').hide();
                            $('#_koolclash-config-dns').hide();
                            E('koolclash-dns-msg').innerHTML = `请先上传 Clash 配置文件！`
                        } else if (dnsmode === '1') {
                            E('_koolclash-dns-config-switch').checked = false;
                            $('#koolclash-btn-save-dns-config').hide();
                            $('#_koolclash-config-dns').hide();
                            E('koolclash-dns-msg').innerHTML = `Clash 配置文件存在且 DNS 配置合法。如果想覆盖 Clash 配置文件中的 DNS 配置请勾选上面的单选框`
                        } else if (dnsmode === '2') {
                            E('_koolclash-dns-config-switch').checked = true;
                            $('#koolclash-btn-save-dns-config').show();
                            $('#_koolclash-config-dns').show();
                            E('koolclash-dns-msg').innerHTML = `已经使用下面的 DNS 配置覆盖 Clash 配置文件中的 DNS 配置`
                        } else if (dnsmode === '3') {
                            E('_koolclash-dns-config-switch').checked = true;
                            E('_koolclash-dns-config-switch').setAttribute('disabled', '');
                            $('#koolclash-btn-save-dns-config').show();
                            $('#_koolclash-config-dns').show();
                            E('koolclash-dns-msg').innerHTML = `Clash 配置文件存在，但配置文件中不存在 DNS 配置或配置不合法。请在下面提交 DNS 配置！`
                        } else {
                            E('_koolclash-dns-config-switch').checked = true;
                            E('_koolclash-dns-config-switch').setAttribute('disabled', '');
                            $('#koolclash-btn-save-dns-config').show();
                            $('#_koolclash-config-dns').show();
                            E('koolclash-dns-msg').innerHTML = `Clash 配置文件存在，但原始配置文件中不存在 DNS 配置或配置不合法，已经生效下面的 DNS 配置`
                        }
                    },
                    error: () => {
                        if (softcenter === 1) {
                            return false;
                        }
                        E('koolclash_status').innerHTML = `<span style="color: red">获取 Clash 进程运行状态失败！请刷新页面重试`;
                        E('koolclash_watchdog_status').innerHTML = `<span style="color: red">获取 Clash 看门狗进程运行状态失败！请刷新页面重试`;
                    }
                });
            },
            checkIP: () => {
                IP.getIpipnetIP();
                //IP.getSohuIP();
                IP.getIpApiIP();
                HTTP.runcheck();
            },
            disableAllButton: () => {
                let btnList = document.getElementsByTagName('button');
                for (let i of btnList) {
                    i.setAttribute('disabled', '');
                }
            },
            enableAllButton: () => {
                let btnList = document.getElementsByTagName('button');
                for (let i of btnList) {
                    i.removeAttribute('disabled');
                }
            },
            switchConfigRule: () => {
                let id = parseInt(Math.random() * 100000000);
                let postData = JSON.stringify({
                    id,
                    "method": "koolclash_switch_rule.sh",
                    "params": [],
                    "fields": ""
                });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    async: true,
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result === 'rule') {
                            $('#rule').attr('checked', '');
                            alert("提交成功，已切换至该模式！");
                        }
                    },
                });	
            },
            switchConfigGlobal: () => {
                let id = parseInt(Math.random() * 100000000);
                let postData = JSON.stringify({
                    id,
                    "method": "koolclash_switch_global.sh",
                    "params": [],
                    "fields": ""
                });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    async: true,
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result === 'global') {
                            $('#global').attr('checked', '');
                            alert("提交成功，已切换至该模式！");
                        }
                    },
                });	
            },
            switchConfigDirect: () => {
                let id = parseInt(Math.random() * 100000000);
                let postData = JSON.stringify({
                    id,
                    "method": "koolclash_switch_direct.sh",
                    "params": [],
                    "fields": ""
                });
				
                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    async: true,
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result === 'direct') {
                            $('#direct').attr('checked', '');
                            alert("提交成功，已切换至该模式！");
                        }
                    },
                });	
            },
            ReturnChnIP: () => {
                let id = parseInt(Math.random() * 100000000);
                let postData = JSON.stringify({
                    id,
                    "method": "koolclash_return_chnip.sh",
                    "params": [],
                    "fields": ""
                });
				
                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    async: true,
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result === 'chnip_on') {
                            $('#koolclash-return-chnip').attr('checked', '');
                            setTimeout(() => {
                                alert("已切换至绕过大陆IP！");
                            }, 1000)
                        } else if (resp.result === 'chnip_off') {
                            setTimeout(() => {
                                alert("已关闭绕过大陆IP！");
                            }, 1000)
                        }
                    },
                });	
            },
            submitExternalControl: () => {
                KoolClash.disableAllButton();

                let id = parseInt(Math.random() * 100000000);
                let postData = JSON.stringify({
                    id,
                    "method": "koolclash_save_control.sh",
                    "params": [`${E('_koolclash_dashboard_host').value}`],
                    "fields": ""
                });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        E('koolclash-btn-submit-control').innerHTML = '外部控制 IP 设置成功！页面将会自动刷新！';
                        setTimeout(() => {
                            window.location.reload();
                        }, 3000)
                    },
                    error: () => {
                        E('koolclash-btn-submit-control').innerHTML = '外部控制 IP 设置失败！';
                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-submit-control').innerHTML = '提交外部控制设置';
                        }, 3000)
                    }
                });
            },
            downloadClashConfig: () => {
                KoolClash.disableAllButton();
                E('koolclash-btn-download').innerHTML = '正在导出 Clash 配置...';

                let id = parseInt(Math.random() * 100000000);
                let postData = JSON.stringify({
                    id,
                    "method": "koolclash_download_config.sh",
                    "params": [],
                    "fields": ""
                });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    async: true,
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result === 'notfound') {
							E('koolclash-btn-download').innerHTML = 'Clash 配置文件找不到了！请重试！';
                        } else {
                            let a = document.createElement('A');
                            a.href = "/files/config.yaml";
                            a.download = 'config.yaml';
                            document.body.appendChild(a);
                            a.click();
                            document.body.removeChild(a);							
                            E('koolclash-btn-download').innerHTML = 'Clash 配置导出成功，页面将自动刷新<span id="koolclash-wait-time"></span>';
                                KoolClash.tminus(5);
                                setTimeout(() => {
                                    window.location.reload();
                                }, 5000)
                        }
                    },
                });					
            },
            submitClashConfig: () => {
                KoolClash.disableAllButton();
                E('koolclash-btn-upload').innerHTML = '正在上传 Clash 配置...';

                let formData = new FormData();
                formData.append('clash.config.yaml', $('#koolclash-file-config')[0].files[0]);
                $.ajax({
                    url: '/_upload',
                    type: 'POST',
                    async: true,
                    cache: false,
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: (resp) => {
                        E('koolclash-btn-upload').innerHTML = '正在上传 Clash 配置...';
                        (() => {
                            let id = parseInt(Math.random() * 100000000),
                                postData = JSON.stringify({
                                    id,
                                    "method": "koolclash_save_config.sh",
                                    "params": [],
                                    "fields": ""
                                });

                            $.ajax({
                                type: "POST",
                                cache: false,
                                url: "/_api/",
                                data: postData,
                                dataType: "json",
                                success: (resp) => {
                                    if (resp.result === 'notfound') {
                                        E('koolclash-btn-upload').innerHTML = '上传的配置文件找不到了！请重试！';
                                        setTimeout(() => {
                                            KoolClash.enableAllButton();
                                            E('koolclash-btn-upload').innerHTML = '上传配置文件';
                                        }, 3000)
                                    } else if (resp.result === 'nofallbackdns') {
                                        E('koolclash-btn-upload').innerHTML = '在配置文件中没有找到 DNS 设置，请在下面添加 DNS 配置！';
                                        // KoolClash.selectTab('koolclash-nav-config')
                                        E('koolclash-btn-upload').classList.remove('btn-primary');
                                        E('koolclash-btn-upload').classList.add('btn-danger');
                                        E('koolclash-btn-save-dns-config').removeAttribute('disabled');
                                        E('_koolclash-dns-config-switch').checked = true;
                                        E('_koolclash-dns-config-switch').setAttribute('disabled', '');
                                        $('#_koolclash-config-dns').show();
                                        $('#koolclash-btn-save-dns-config').show();
                                        E('koolclash-dns-msg').innerHTML = `Clash 配置文件存在，但配置文件中不存在 DNS 配置或配置不合法，请在下面提交 DNS 配置`;
                                    } else {
                                        E('koolclash-btn-upload').innerHTML = 'Clash 配置上传成功，页面将自动刷新<span id="koolclash-wait-time"></span>';
                                        KoolClash.tminus(5);
                                        setTimeout(() => {
                                            window.location.reload();
                                        }, 5000)
                                    }
                                },
                                error: () => {
                                    E('koolclash-btn-upload').innerHTML = '配置文件上传失败！';

                                    setTimeout(() => {
                                        KoolClash.enableAllButton();
                                        E('koolclash-btn-upload').innerHTML = '上传配置文件';
                                    }, 3000)
                                }
                            });
                        })();
                    },
                    error: () => {
                        if (softcenter === 1) {
                            return false;
                        }
                        E('koolclash-btn-save-config').innerHTML = '配置文件上传失败，请重试';

                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-upload').innerHTML = '上传配置文件';
                        }, 4000)
                    }
                });
            },
            tminus: (second) => {
                setInterval(() => {
                    second--;
                    E('koolclash-wait-time').innerHTML = `（${second}）`;
                }, 1000);
            },
            submitDNSConfig: () => {
                KoolClash.disableAllButton();
                E('koolclash-btn-save-dns-config').innerHTML = '正在提交...';
                let id = parseInt(Math.random() * 100000000),
                    postData,
                    checked;

                if (E('_koolclash-dns-config-switch').checked) {
                    checked = '1';
                } else {
                    checked = '0'
                }

                postData = JSON.stringify({
                    id,
                    "method": "koolclash_save_dns_config.sh",
                    "params": [`${Base64.encode(E('_koolclash-config-dns').value.replace('# 没有找到保存的 Clash 自定义 DNS 配置，推荐使用以下的配置\n', ''))}`, checked],
                    "fields": ""
                });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result === 'nofallbackdns') {
                            E('koolclash-btn-save-dns-config').innerHTML = '不能提交空的 DNS 配置！';
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-save-dns-config').innerHTML = '提交 Clash 自定义 DNS 设置';
                            }, 4000)
                        } else {
                            E('koolclash-btn-save-dns-config').innerHTML = '提交成功！页面将会自动刷新！<span id="koolclash-wait-time"></span>';
                            KoolClash.tminus(5);
                            setTimeout(() => {
                                window.location.reload();
                            }, 5000)
                        }
                    },
                    error: () => {
                        E('koolclash-btn-save-dns-config').innerHTML = '提交失败！请重试';
                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-save-dns-config').innerHTML = '提交 Clash 自定义 DNS 设置';
                        }, 4000)
                    }
                });
            },
            restart: () => {
                KoolClash.disableAllButton();
                Msg.show('warning', '正在启动 Clash，请不要刷新或关闭页面！');

                setTimeout(() => {
                    KoolClash.selectTab('koolclash-nav-log');
                    KoolClash.getLog();
                }, 100);

                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        id,
                        "method": "koolclash_control.sh",
                        "params": ['start'],
                        "fields": ""
                    });

                $.ajax({
                    type: "POST",
                    cache: false,
                    async: true,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result === 'nofile') {
                            Msg.hide('warning');
                            Msg.show('error', '关键文件缺失，Clash 无法启动！');
                            Msg.show('warning', '请不要刷新或关闭页面，务必等待页面自动刷新！<span id="koolclash-wait-time"></span>');
                            setTimeout(() => {
                                window.location.reload();
                            }, 5000)
                        } else if (resp.result === 'nodns') {
                            Msg.hide('warning');
                            Msg.show('error', '在 Clash 配置文件中没有找到正确的 DNS 设置！');
                            Msg.show('warning', '请不要刷新或关闭页面，务必等待页面自动刷新！<span id="koolclash-wait-time"></span>');
                            KoolClash.tminus(5);
                            setTimeout(() => {
                                window.location.reload();
                            }, 5000)
                        } else {
                            Msg.hide('warning');
                            Msg.show('success', 'Clash 成功启动！');
                            Msg.show('error', '请在【设备控制】页面添加需要代理的设备，默认所有设备不走代理！');							
                            Msg.show('warning', '请不要刷新或关闭页面，务必等待页面自动刷新！<span id="koolclash-wait-time"></span>');
                            KoolClash.tminus(6);
                            setTimeout(() => {
                                window.location.reload();
                            }, 6000)
                        }
                    },
                    error: () => {
                        Msg.show('error', 'Clash (可能)启动失败！请在页面自动刷新之后检查 Clash 运行状态！');
                        Msg.show('warning', '请不要刷新或关闭页面，务必等待页面自动刷新！<span id="koolclash-wait-time"></span>');
                        KoolClash.selectTab('koolclash-nav-log');
                        KoolClash.tminus(5);
                        setTimeout(() => {
                            window.location.reload();
                        }, 5000)
                    }
                });
            },
            stop: () => {
                KoolClash.disableAllButton();
                Msg.show('warning', '正在关闭 Clash，请不要刷新或关闭页面！');

                setTimeout(() => {
                    KoolClash.selectTab('koolclash-nav-log');
                    KoolClash.getLog();
                }, 100);

                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        id,
                        "method": "koolclash_control.sh",
                        "params": ['stop'],
                        "fields": ""
                    });

                $.ajax({
                    type: "POST",
                    cache: false,
                    async: true,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        Msg.hide('warning');
                        Msg.show('success', 'Clash 成功关闭！');
                        Msg.show('warning', '请不要刷新或关闭页面，务必等待页面自动刷新！<span id="koolclash-wait-time"></span>');
                        KoolClash.tminus(5);
                        setTimeout(() => {
                            window.location.reload();
                        }, 5000)
                    },
                    error: () => {
                        Msg.hide('warning');
                        Msg.show('error', 'Clash (可能)关闭失败！请在页面自动刷新之后检查 Clash 运行状态！');
                        Msg.show('warning', '请不要刷新或关闭页面，务必等待页面自动刷新！<span id="koolclash-wait-time"></span>');
                        KoolClash.tminus(5);
                        setTimeout(() => {
                            window.location.reload();
                        }, 5000)
                    }
                });
            },			
            get_flow_status: () => {
                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        id,
                        "method": "koolclash_flow_status.sh",
                        "params": [],
                        "fields": ""
                    });

                $.ajax({
                    type: "POST",
                    cache: false,
                    async: true,					
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result != -1) {
                            var ot = resp.result.split(">")[0] + " GB";
                            var ou = resp.result.split(">")[1] + " GB";
                            var op = Math.round(parseInt(ou) / parseInt(ot) * 1000) / 10.00;
                            var info = "已用流量：" + ou + " / " + ot + " (" + op + "%)";
                            $("#flow_status").show();
                            $("#flow_status_text").attr("title", info);
                            $("#flow_status_text div").attr("style", "width: " + op + "%;");
			            }
		            },
	            });
            },			
            deleteSuburl: () => {
                KoolClash.disableAllButton();
                E('koolclash-btn-del-suburl').innerHTML = `正在删除 Clash 托管配置 URL`;
                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        id,
                        "method": "koolclash_sub.sh",
                        "params": ['del'],
                        "fields": ""
                    });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result === '1') {
                            E('koolclash-btn-del-suburl').innerHTML = `删除成功！`;
                            E('_koolclash_config_suburl').value = '';
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-del-suburl').innerHTML = '删除托管 URL（保留 Clash 配置）';
                            }, 2500)
                        } else if (resp.result === '2') {
                            E('koolclash-btn-del-suburl').innerHTML = `删除成功！`;
                            E('_koolclash_config_subconverter_url').value = '';
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-del-suburl').innerHTML = '删除托管和订阅 URL（保留 Clash 配置）';
                            }, 2500)                            
						}
                    },
                    error: () => {
                        E('koolclash-btn-del-suburl').innerHTML = `删除失败！`;

                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-del-suburl').innerHTML = '删除托管和订阅 URL（保留 Clash 配置）';
                        }, 2500)
                    }
                });
            },
            updateRemoteConfig: () => {
                KoolClash.disableAllButton();
                E('koolclash-btn-update-sub').innerHTML = `正在下载最新托管配置`;
                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        id,
                        "method": "koolclash_sub.sh",
                        "params": ['update', `${Base64.encode(E('_koolclash_config_suburl').value)}`],
                        "fields": ""
                    });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result === 'nocurl') {
                            E('koolclash-btn-update-sub').innerHTML = `你的路由器中没有 curl，不能更新！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-update-sub').innerHTML = '更新 Clash 托管配置';
                            }, 3500)
                        } else if (resp.result === 'fail') {
                            E('koolclash-btn-update-sub').innerHTML = `Clash 托管配置下载失败！已经自动恢复到旧的配置文件！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-update-sub').innerHTML = '更新 Clash 托管配置';
                            }, 4000)
                        } else if (resp.result === 'nofallbackdns') {
                            E('koolclash-btn-update-sub').innerHTML = '在托管配置中没有找到 DNS 设置，请在下面添加 DNS 配置！';
                            E('_koolclash-dns-config-switch').checked = true;
                            E('_koolclash-dns-config-switch').setAttribute('disabled', '');
                            $('#_koolclash-config-dns').show();
                            $('#koolclash-btn-save-dns-config').show();
                            E('koolclash-btn-save-dns-config').removeAttribute('disabled');
                            E('koolclash-dns-msg').innerHTML = `Clash 托管配置文件已经更新，但托管配置中不存在 DNS 配置或配置不合法，请在下面提交 DNS 配置`;
                        } else {
                            E('koolclash-btn-update-sub').innerHTML = 'Clash 配置更新成功，页面将自动刷新<span id="koolclash-wait-time"></span>';
                            KoolClash.tminus(5);
                            setTimeout(() => {
                                window.location.reload();
                            }, 5000)
                        }
                    },
                    error: () => {
                        E('koolclash-btn-update-sub').innerHTML = `Clash 托管配置更新失败！`;

                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-update-sub').innerHTML = '更新 Clash 托管配置';
                        }, 2500)
                    }
                });
            },
            updateSubConfig: () => {
                KoolClash.disableAllButton();
                E('koolclash-btn-update-subconverter').innerHTML = `正在下载最新订阅配置`;
                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        id,
                        "method": "koolclash_subconverter.sh",
                        "params": ['update', `${Base64.encode(E('_koolclash_config_subconverter_url').value)}`],
                        "fields": ""
                    });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result === 'nocurl') {
                            E('koolclash-btn-update-subconverter').innerHTML = `你的路由器中没有 curl，不能订阅转换！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-update-subconverter').innerHTML = '开始 Clash 订阅转换';
                            }, 3500)
                        } else if (resp.result === 'fail') {
                            E('koolclash-btn-update-subconverter').innerHTML = `Clash 订阅转换配置下载失败！已经自动恢复到旧的配置文件！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-update-subconverter').innerHTML = '开始 Clash 订阅转换';
                            }, 4000)
                        } else if (resp.result === 'nofallbackdns') {
                            E('koolclash-btn-update-subconverter').innerHTML = '在托管配置中没有找到 DNS 设置，请在下面添加 DNS 配置！';
                            E('_koolclash-dns-config-switch').checked = true;
                            E('_koolclash-dns-config-switch').setAttribute('disabled', '');
                            $('#_koolclash-config-dns').show();
                            $('#koolclash-btn-save-dns-config').show();
                            E('koolclash-btn-save-dns-config').removeAttribute('disabled');
                            E('koolclash-dns-msg').innerHTML = `Clash 订阅转换配置文件已经更新，但订阅转换配置中不存在 DNS 配置或配置不合法，请在下面提交 DNS 配置`;
                        } else {
                            E('koolclash-btn-update-subconverter').innerHTML = 'Clash 配置更新成功，页面将自动刷新<span id="koolclash-wait-time"></span>';
                            KoolClash.tminus(5);
                            setTimeout(() => {
                                window.location.reload();
                            }, 5000)
                        }
                    },
                    error: () => {
                        E('koolclash-btn-update-subconverter').innerHTML = `Clash 订阅转换配置更新失败！`;

                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-update-subconverter').innerHTML = '开始 Clash 订阅转换';
                        }, 2500)
                    }
                });
            },
            updateIPDB: () => {
                KoolClash.disableAllButton();
                E('koolclash-btn-update-ipdb').innerHTML = `开始下载最新 IP 解析库并更新`;
                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        "id": id,
                        "method": "koolclash_update_ipdb.sh",
                        "params": [],
                        "fields": ""
                    });

//                setTimeout(() => {
//                    KoolClash.selectTab('koolclash-nav-log');
//                   KoolClash.getLog();
//                }, 100);

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result === 'nodl') {
                            E('koolclash-btn-update-ipdb').innerHTML = `你的路由器中既没有 curl 也没有 wget，不能下载更新！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-update-ipdb').innerHTML = '更新 IP 数据库';
                            }, 5500)
                        } else {
                            E('koolclash-btn-update-ipdb').innerHTML = `IP 解析库更新成功！页面将自动刷新<span id="koolclash-wait-time"></span>`;
                            KoolClash.tminus(3);
                            setTimeout(() => {
                                window.location.reload();
                            }, 3000)
                        }
                    },
                    error: () => {
                        E('koolclash-btn-update-ipdb').innerHTML = `IP 解析库更新失败！`;
                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-update-ipdb').innerHTML = '更新 IP 数据库';
                        }, 3000)
                    }
                });
            },
            updateCHN: () => {
                KoolClash.disableAllButton();
                E('koolclash-btn-update-chn').innerHTML = `开始下载最新 CHN 数据库并更新`;
                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        "id": id,
                        "method": "koolclash_update_chn.sh",
                        "params": [],
                        "fields": ""
                    });

//                setTimeout(() => {
//                    KoolClash.selectTab('koolclash-nav-log');
//                    KoolClash.getLog();
//                }, 100);

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (resp.result === 'nodl') {
                            E('koolclash-btn-update-chn').innerHTML = `你的路由器中既没有 curl 也没有 wget，不能下载更新！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-update-chn').innerHTML = '更新 CHN 数据库';
                            }, 5500)
                        } else {
                            E('koolclash-btn-update-chn').innerHTML = `CHN 数据库更新成功！页面将自动刷新<span id="koolclash-wait-time"></span>`;
                            KoolClash.tminus(3);
                            setTimeout(() => {
                                window.location.reload();
                            }, 3000)
                        }
                    },
                    error: () => {
                        E('koolclash-btn-update-chn').innerHTML = `CHN 解析库更新失败！`;
                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-update-chn').innerHTML = '更新 CHN 数据库';
                        }, 3000)
                    }
                });
            },			
            getLog: () => {
                if (typeof _responseLen === undefined) {
                    let _responseLen = 0;
                } else {
                    _responseLen = 0;
                }

                let noChange = 0;

                $.ajax({
                    url: '/_temp/koolclash_log.txt',
                    type: 'GET',
                    cache: false,
                    dataType: 'text',
                    success: (response) => {
                        var retArea = E("_koolclash_log");
                        if (response.search("XU6J03M6") !== -1) {
                            retArea.value = response.replace("XU6J03M6", " ");
                            retArea.scrollTop = retArea.scrollHeight;
                            return true;
                        }
                        if (_responseLen === response.length) {
                            noChange++;
                        } else {
                            noChange = 0;
                        }
                        if (noChange > 8000) {
                            KoolClash.selectTab('koolclash-nav-overview');
                            return false;
                        } else {
                            setTimeout(() => {
                                KoolClash.getLog();
                            }, 100);
                        }
                        retArea.value = response.replace("XU6J03M6", " ");
                        retArea.scrollTop = retArea.scrollHeight;
                        _responseLen = response.length;
                    },
                    error: () => {
                        E("_koolclash_log").value = "获取日志失败！";
                        return false;
                    }
                });
            },
            debugInfo: () => {
                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        id,
                        "method": "koolclash_debug.sh",
                        "params": [""],
                        "fields": ""
                    });

                fetch(`/_api/`, {
                    body: postData,
                    method: 'POST',
                    cache: 'no-cache',
                }).then((resp) => Promise.all([resp.ok, resp.status, resp.json(), resp.headers]))
                    .then(([ok, status, data, headers]) => {
                        if (ok) {
                            return JSON.parse(data.result);
                        } else {
                            throw new Error(JSON.stringify(json.error));
                        }
                    })
                    .then((data) => {
                        let getBrowser = () => {
                            let ua = navigator.userAgent,
                                tem,
                                M = ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
                            if (ua.match("MicroMessenger"))
                                return "Weixin";

                            if (/trident/i.test(M[1])) {
                                tem = /\brv[ :]+(\d+)/g.exec(ua) || [];
                                return 'IE ' + (tem[1] || '');
                            }
                            if (M[1] === 'Chrome') {
                                tem = ua.match(/\b(OPR|Edge)\/(\d+)/);
                                if (tem != null) return tem.slice(1).join(' ').replace('OPR', 'Opera');
                            }
                            M = M[2] ? [M[1], M[2]] : [navigator.appName, navigator.appVersion, '-?'];
                            if ((tem = ua.match(/version\/(\d+)/i)) != null) M.splice(1, 1, tem[1]);
                            return M.join(' ');
                        };

                        E('_koolclash_debug_info').value = `
======================== KoolClash 调试工具 ========================
调试信息生成于 ${new Date().toString()}
当前浏览器：${getBrowser()}
-------------------- Koolshare OpenWrt 基本信息 --------------------
固件版本：${data.koolshare_version}
路由器 LAN IP：${data.lan_ip}
------------------------ KoolClash 基本信息 ------------------------
KoolClash 版本：${window.dbus.koolclash_version}
Clash 核心版本：${data.clash_version}
KoolClash 当前状态：${(window.dbus.koolclash_enable === '1') ? `Clash 进程正在运行` : `Clash 进程未在运行`}
用户指定 Clash 外部控制 Host：${(window.dbus.koolclash_api_host) ? window.dbus.koolclash_api_host : `未改动`}
-------------------------- Clash 进程信息 --------------------------
${Base64.decode(data.clash_process)}
------------------------ Clash 配置文件目录 ------------------------
${Base64.decode(data.clash_config_dir)}
------------------------ Clash 配置文件信息 ------------------------
Clash 代理模式：${data.clash_mode}
Clash 透明代理端口：${data.clash_redir}
Clash 是否允许局域网连接：${data.clash_allow_lan}
Clash 外部控制监听地址：${data.clash_ext_controller}
--------------------- Clash 配置文件 DNS 配置 ----------------------
Clash DNS 是否启用：${data.clash_dns_enable}
Clash DNS 解析 IPv6：${(data.clash_dns_ipv6 === 'null') ? `false` : data.clash_dns_ipv6}
Clash DNS 增强模式：${data.clash_dns_mode}
Clash DNS 监听：${data.clash_dns_listen}
KoolClash 当前 DNS 模式：${dbus.koolclash_dnsmode}
-------------------- KoolClash 自定义 DNS 配置 ---------------------
${Base64.decode(data.fallbackdns)}
------------------------- iptables 条目 ---------------------------
 * iptables mangle 中 Clash 相关条目
${Base64.decode(Base64.decode(data.iptables_mangle))}

 * iptables nat 中 Clash 相关条目
${Base64.decode(Base64.decode(data.iptables_nat))}

 * iptables mangle 中 koolclash 链
${Base64.decode(Base64.decode(data.iptables_mangle_clash))}

 * iptables nat 中 koolclash 链
${Base64.decode(Base64.decode(data.iptables_nat_clash))}

 * iptables nat 中 OUTPUT 链
${Base64.decode(Base64.decode(data.iptables_mangle_clash_dns))}

 * iptables nat 中 koolclash_output 链
${Base64.decode(Base64.decode(data.iptables_nat_clash_dns))}

 * iptables nat 中 53 端口相关条目
${Base64.decode(data.chromecast_nu)}
---------------------- ipset 白名单 IP 列表 ------------------------
${Base64.decode(data.firewall_white_ip)}
------------------------- ipset 集合列表 ---------------------------
${Base64.decode(data.firewall_ipset_list)}
===================================================================
`;
                    })
            },
            acl: {
                submitPort: () => {
                    KoolClash.disableAllButton();
                    document.getElementById('koolclash-btn-submit-port').innerHTML = `正在提交`;
                    let id = parseInt(Math.random() * 100000000),
                        postData = JSON.stringify({
                            id,
                            "method": "koolclash_firewall.sh",
                            "params": ['default', `${document.getElementById('_koolclash-acl-default-mode').value}`, `${document.getElementById('_koolclash-acl-default-port').value}`, `${document.getElementById('_koolclash-acl-base-port').value}`, `${Base64.encode(document.getElementById('_koolclash-acl-default-port-user').value)}`],
                            "fields": ""
                        });
                    $.ajax({
                        type: "POST",
                        cache: false,
                        url: "/_api/",
                        data: postData,
                        dataType: "json",
                        success: (resp) => {
                            document.getElementById('koolclash-btn-submit-port').innerHTML = `提交成功，下次启动 Clash 时生效！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                document.getElementById('koolclash-btn-submit-port').innerHTML = '提交';
                            }, 2500)
                        },
                        error: () => {
                            document.getElementById('koolclash-btn-submit-port').innerHTML = `提交失败，请重试！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                document.getElementById('koolclash-btn-submit-port').innerHTML = '提交';
                            }, 2500)
                        }
                    });
                },
                submitWhiteIP: () => {
                    KoolClash.disableAllButton();
                    let data = Base64.encode(E('_koolclash_firewall_white_ipset').value);

                    E('koolclash-btn-submit-white-ip').innerHTML = `正在提交`;
                    let id = parseInt(Math.random() * 100000000),
                        postData = JSON.stringify({
                            id,
                            "method": "koolclash_firewall.sh",
                            "params": ['white', `${data}`],
                            "fields": ""
                        });

                    $.ajax({
                        type: "POST",
                        cache: false,
                        url: "/_api/",
                        data: postData,
                        dataType: "json",
                        success: (resp) => {
                            E('koolclash-btn-submit-white-ip').innerHTML = `提交成功，下次启动 Clash 时生效！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-submit-white-ip').innerHTML = '提交';
                            }, 2500)
                        },
                        error: () => {
                            E('koolclash-btn-submit-white-ip').innerHTML = `提交失败，请重试！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-submit-white-ip').innerHTML = '提交';
                            }, 2500)
                        }
                    });
                },
                submitWhiteDOMAIN: () => {
                    KoolClash.disableAllButton();
                    let data = Base64.encode(E('_koolclash_firewall_white_ipset_domain').value);

                    E('koolclash-btn-submit-white-domain').innerHTML = `正在提交`;
                    let id = parseInt(Math.random() * 100000000),
                        postData = JSON.stringify({
                            id,
                            "method": "koolclash_firewall.sh",
                            "params": ['white-domain', `${data}`],
                            "fields": ""
                        });

                    $.ajax({
                        type: "POST",
                        cache: false,
                        url: "/_api/",
                        data: postData,
                        dataType: "json",
                        success: (resp) => {
                            E('koolclash-btn-submit-white-domain').innerHTML = `提交成功，下次启动 Clash 时生效！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-submit-white-domain').innerHTML = '提交';
                            }, 2500)
                        },
                        error: () => {
                            E('koolclash-btn-submit-white-domain').innerHTML = `提交失败，请重试！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-submit-white-domain').innerHTML = '提交';
                            }, 2500)
                        }
                    });
                },
                submitBlackIP: () => {
                    KoolClash.disableAllButton();
                    let data = Base64.encode(E('_koolclash_firewall_black_ipset').value);

                    E('koolclash-btn-submit-black-ip').innerHTML = `正在提交`;
                    let id = parseInt(Math.random() * 100000000),
                        postData = JSON.stringify({
                            id,
                            "method": "koolclash_firewall.sh",
                            "params": ['black', `${data}`],
                            "fields": ""
                        });

                    $.ajax({
                        type: "POST",
                        cache: false,
                        url: "/_api/",
                        data: postData,
                        dataType: "json",
                        success: (resp) => {
                            E('koolclash-btn-submit-black-ip').innerHTML = `提交成功，下次启动 Clash 时生效！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-submit-black-ip').innerHTML = '提交';
                            }, 2500)
                        },
                        error: () => {
                            E('koolclash-btn-submit-black-ip').innerHTML = `提交失败，请重试！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-submit-black-ip').innerHTML = '提交';
                            }, 2500)
                        }
                    });
                },
                submitBlackDOMAIN: () => {
                    KoolClash.disableAllButton();
                    let data = Base64.encode(E('_koolclash_firewall_black_ipset_domain').value);

                    E('koolclash-btn-submit-black-domain').innerHTML = `正在提交`;
                    let id = parseInt(Math.random() * 100000000),
                        postData = JSON.stringify({
                            id,
                            "method": "koolclash_firewall.sh",
                            "params": ['black-domain', `${data}`],
                            "fields": ""
                        });

                    $.ajax({
                        type: "POST",
                        cache: false,
                        url: "/_api/",
                        data: postData,
                        dataType: "json",
                        success: (resp) => {
                            E('koolclash-btn-submit-black-domain').innerHTML = `提交成功，下次启动 Clash 时生效！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-submit-black-domain').innerHTML = '提交';
                            }, 2500)
                        },
                        error: () => {
                            E('koolclash-btn-submit-black-domain').innerHTML = `提交失败，请重试！`;
                            setTimeout(() => {
                                KoolClash.enableAllButton();
                                E('koolclash-btn-submit-black-domain').innerHTML = '提交';
                            }, 2500)
                        }
                    });
                },
            },
            submitWatchdog: () => {
                KoolClash.disableAllButton();
                E('koolclash-btn-submit-watchdog').innerHTML = `正在提交`;

                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        id,
                        "method": "koolclash_watchdog_config.sh",
                        "params": [`${E('_koolclash-select-watchdog').value}`],
                        "fields": ""
                    });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        E('koolclash-btn-submit-watchdog').innerHTML = `提交成功，下次启动 Clash 时生效！`;
                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-submit-watchdog').innerHTML = '提交';
                        }, 2500)
                    },
                    error: () => {
                        E('koolclash-btn-submit-watchdog').innerHTML = `提交失败，请重试！`;
                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-submit-watchdog').innerHTML = '提交';
                        }, 2500)
                    }
                });
            },
            submitNodeMemory: () => {
                KoolClash.disableAllButton();
                E('koolclash-btn-submit-node-memory').innerHTML = `正在提交`;

                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        id,
                        "method": "koolclash_node_memory.sh",
                        "params": [`${E('_koolclash-select-node-memory').value}`],
                        "fields": ""
                    });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        E('koolclash-btn-submit-node-memory').innerHTML = `提交成功，下次启动 Clash 时生效！`;
                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-submit-node-memory').innerHTML = '提交';
                        }, 2500)
                    },
                    error: () => {
                        E('koolclash-btn-submit-node-memory').innerHTML = `提交失败，请重试！`;
                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-submit-node-memory').innerHTML = '提交';
                        }, 2500)
                    }
                });
            },	
            submitUpdateSub: () => {
                KoolClash.disableAllButton();
                E('koolclash-btn-submit-update-sub').innerHTML = `正在提交`;

                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        id,
                        "method": "koolclash_update_sub_config.sh",
                        "params": [`${E('_koolclash-select-update-sub').value},${E('_koolclash-select-update-sub-time').value}`],
                        "fields": ""
                    });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        E('koolclash-btn-submit-update-sub').innerHTML = `提交成功，下次启动 Clash 时生效！`;
                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-submit-update-sub').innerHTML = '提交';
                        }, 2500)
                    },
                    error: () => {
                        E('koolclash-btn-submit-update-sub').innerHTML = `提交失败，请重试！`;
                        setTimeout(() => {
                            KoolClash.enableAllButton();
                            E('koolclash-btn-submit-update-sub').innerHTML = '提交';
                        }, 2500)
                    }
                });
            },			
            load: (cb) => {
                window.dbus = {}
                document.title = 'KoolClash - Clash for Koolshare OpenWrt/LEDE';

                fetch(`/_api/koolclash`, { method: 'GET' })
                    .then((resp) => Promise.all([resp.ok, resp.status, resp.json(), resp.headers]))
                    .then(([ok, status, data, headers]) => {
                        if (ok) {
                            window.dbus = data.result[0];
                        } else {
                            throw new Error(JSON.stringify(json.error));
                        }
                    })
                    .then((res) => {
                        if (typeof $('#koolclash-field').forms === 'function') {
                            KoolClash.renderUI();
                        } else {
                            console.clear();
                            setTimeout(() => {
                                console.clear();
                                window.location.reload();
                            }, 1000);
                        }
                    })
                    .then((res) => {
                        KoolClash.getClashStatus();
                        KoolClash.checkUpdate();
						KoolClash.get_flow_status();
                        if (window.dbus.koolclash_sub_information === 'hide') {
                            $('#koolclash-config > fieldset:nth-child(2)').hide();
                            $('#koolclash-config > fieldset:nth-child(3)').hide();
                        }
                        if (window.dbus.koolclash_update_mode === '2') {
                            $('#koolclash-content-additional > div:nth-child(2)').show();
                        } else {
                            $('#koolclash-content-additional > div:nth-child(2)').hide();
                        }
                        $('#koolclash-ip').on('click', function() {
                            koolclash_CheckIP();
                        });
                        if (window.dbus.koolclash_enable === '1') {
                            if (window.dbus.koolclash_switch_config_mode === '1') {
                                $('#rule').attr('checked', '');
                            }
                            if (window.dbus.koolclash_switch_config_mode === '2') {
                                $('#global').attr('checked', '');		
                            }
                            if (window.dbus.koolclash_switch_config_mode === '3') {
                                $('#direct').attr('checked', '');
                            }
                            if (window.dbus.koolclash_switch_run_mode === '1') {
                                $('#fake-ip-enhanced').attr('checked', '');
                            }
                            if (window.dbus.koolclash_return_chnip === '1') {
                                $('#koolclash-return-chnip').attr('checked', '');
                            }							
                        }
                    })
            },
        }

        function verifyFields(r) {
            // 自定义 DNS 配置的显示隐藏
            if (r.getAttribute('id') === '_koolclash-acl-default-mode') {
                if (E('_koolclash-acl-default-mode').value === '0') {
                    $('#koolclash-acl-port-panel > fieldset:nth-child(3)').show();
                    $('#koolclash-acl-port-panel > fieldset:nth-child(2)').hide();
                    if (E('_koolclash-acl-base-port').value === '0') {
                        $('#_koolclash-acl-default-port-user').show();
                    }
                } else if (E('_koolclash-acl-default-mode').value === '1') {
                    $('#koolclash-acl-port-panel > fieldset:nth-child(2)').show();
                    $('#koolclash-acl-port-panel > fieldset:nth-child(3)').hide();
                    $('#_koolclash-acl-default-port-user').hide();
                }
            }				
            if ($(r).attr("id") === "_koolclash-dns-config-switch") {
                if (E('_koolclash-dns-config-switch').checked) {
                    $('#_koolclash-config-dns').show();
                    $('#koolclash-btn-save-dns-config').show();
                } else {
                    $('#_koolclash-config-dns').hide();
                    if (window.dbus.koolclash_dnsmode === '1') {
                        $('#koolclash-btn-save-dns-config').hide();
                    }
                }
            }/* else if (r.getAttribute('id') === '_koolclash-acl-default-port') {
                if (E('_koolclash-acl-default-port').value === '0') {
                    $('#_koolclash-acl-default-port-user').show();
                } else {
                    $('#_koolclash-acl-default-port-user').hide();

                }
            }*/
            if (r.getAttribute('id') === '_koolclash-acl-base-port') {
                if (E('_koolclash-acl-base-port').value === '0') {
                    $('#_koolclash-acl-default-port-user').show();
                } else {
                    $('#_koolclash-acl-default-port-user').hide();
                }
			}
            if (r.getAttribute('id') === '_koolclash-select-update-sub') {
                if (E('_koolclash-select-update-sub').value === '0') {
                    $('#_koolclash-select-update-sub-time').hide();
                } else if (E('_koolclash-select-update-sub').value === '1') {
                    $('#_koolclash-select-update-sub-time').show();
                }
			}
        }
    </script>
    <script>
        KoolClash.load();
    </script>
    <script>
        if (document.readyState === 'complete') {
            KoolClash.checkIP();
        } else {
            window.addEventListener('load', () => {
                KoolClash.checkIP();
            });
        }
    </script>
    <!--<script src="https://pv.sohu.com/cityjson?ie=utf-8"></script>-->
    <!--<script src="https://api.ip.sb/jsonip?callback=IP.getIpsbIP"></script>-->
</content>