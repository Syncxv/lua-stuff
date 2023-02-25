window.__FRVR.buildTimePlatform = 'discord';

;
(function() {
    function getTLD() {
        var fallback = document.location.hostname;
        var hostname = fallback.split('.');
        for (var i = hostname.length - 1; i >= 0; i--) {
            var host = hostname.slice(i).join('.');
            document.cookie = 'get_tld=test;domain=.' + host + ';';
            if (document.cookie.indexOf('get_tld') > -1) {
                document.cookie = 'get_tld=;domain=.' + host +
                    ';expires=Thu, 01 Jan 1970 00:00:01 GMT;';
                return host;
            }
        }
        return '';
    }

    function generateUID(separator) {
        var delim = separator || "-";

        function S4() {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        }
        var st = ((new Date).getTime().toString(16)).slice(0, 11) +
            (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1, 2);
        return (S4() + S4() + delim + S4() + delim +
            S4() + delim + S4() + delim + st);
    }

    window.__FRVR.globalUserId = function() {
        var retval;
        var cm = document.cookie.match('^(?:.*_frvr=([^;]*)).*$');

        retval = (cm && cm[1]) || generateUID();

        // Now update it, so that the validity gets extended
        var result = new Date();
        result.setDate(result.getDate() + 730);
        document.cookie = "_frvr=" + retval +
            "; path=/; expires=" + new Date(result).toUTCString() +
            "; domain=" + getTLD() + ";";

        return retval;
    }

    window.__FRVR.getChannel = function() {
        var channel = 'other'
        var map = {
            edge: 'web_edge',
            firefox: 'web_firefox',
            opera: 'web_opera',
            safari: 'web_safari',
            chrome: 'web_chrome',
            samsungBrowser: 'web_samsung',
            samsungBrowserM4S: 'web_samsung_m4s',
            silk: 'web_silk',
            chromeWrapper: 'chromeos',
            androidWrapper: 'android',
            iOSWrapper: 'ios',
            rcs: 'rcs',
            samsungAppStore: 'samsung_galaxy_store',
            facebookInstant: 'facebook_instant',
            facebookAppWeb: 'facebook_canvasweb',
            facebookApp: 'facebook_canvas',
            samsungBixby: 'bixby',
            samsungGameLauncher: 'samsung_game_launcher',
            samsungInstantPlay: 'samsung_instant_play',
            iMessageContext: 'imessage',
            spilGamesWrapper: 'spil',
            vkru: 'vkru',
            okru: 'okru',
            kongregate: 'kongregate',
            kik: 'kik',
            twitter: 'twitter',
            twitch: 'twitch',
            hago: 'hago',
            oppoGlobal: 'oppo_global',
            tMobile: 'tmobile',
            huawei: 'huawei',
            huaweiquickapp: 'huawei_quick_app',
            yandex: 'yandex',
            crazyGames: 'crazy_games',
            lgtv: 'lg_tv',
            jioStb: 'jio_stb',
            myJio: 'jio_my',
            jioGameslite: 'jio_gameslite',
            rocketChat: 'rocket_chat',
            ufone: 'ufone',
            game8: 'game8',
            mailonline: 'mail_online',
            discord: 'discord',
            harman: 'harman',
        };
        var platformIs = window.__FRVR.platformIs;
        // If there are multiple instances of truthy values, the final one will be used as the channel in the order of map
        for (var key in map)
            if (platformIs[key]) channel = map[key];
        if ((channel === 'web_safari' || channel === 'web_chrome') && platformIs.iOS) channel += '_ios';
        return channel;
    }

    //Local cache to preserve querystrings
    var base_url = window.location.href;
    window.__FRVR.getQueryString = function(name) {
        var url = base_url;
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)", "i"),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    }

    window.__FRVR.platformIs = new(function(w, n, u, l) {
        var that = this;

        // adding build platform variable e.g. XS.is['jio-stb']
        that[window.__FRVR.buildTimePlatform] = true

        /**
         * True if we're in an Android browser or app
         * @memberof XS.is
         */
        that.android = /(android)/i.test(u) && !/(Windows)/i.test(u);
        /**
         * Returns android version of browser view as float. E.g. 4.2 if we are running "4.2.1"
         * Hack? Should we move this to a more sensiable location?
         * @memberof XS.is
         */
        that.androidVersion = (function() {
            var match = navigator.userAgent.toLowerCase().match(/android\s([0-9\.]*)/);
            return parseFloat(match ? match[1] : 0);
        })();
        /**
         * True if we're in Firefox Mobile
         * @memberof XS.is
         */
        that.firefoxMobile = /(Mobile)/i.test(u) && /(Firefox)/i.test(u);
        /**
         * True if we're in an old Android Device
         * @memberof XS.is
         */
        that.slow = that.android && that.androidVersion < 6
            /**
             * True if we're in an iOS browser or app
             * @memberof XS.is
             */
        that.iOS = /(ipod|iphone|ipad)/i.test(u) || (/(Macintosh)/i.test(u) && 'ontouchend' in document); // iPadOS uses the same browser that macOS
        /**
         * True if we're in Windows Mobile
         * @memberof XS.is
         */
        that.windowsMobile = /(IEMobile)/i.test(u);
        /**
         * True if we're in the silk browser
         * @memberof XS.is
         */
        that.silk = /(silk)/i.test(u);
        /**
         * True if we're in the Clay app context
         * @memberof XS.is
         */
        that.clay = /(clay\.io)/i.test(l);
        /**
         * True if we're a Facebook Canvas app
         * @memberof XS.is
         */
        that.facebookApp = /(fb_canvas)/i.test(l);
        /**
         * True if we're a Facebook Canvas Web app
         * @memberof XS.is
         */
        that.facebookAppWeb = /(fb_canvas_web)/i.test(l);
        /**
         * True if we're running in an iframe
         * @memberof XS.is
         */
        that.iframed = w.top !== w.self;
        /**
         * True if we're running in iOS Safari standalone mode
         * @memberof XS.is
         */
        that.standalone = 'standalone' in n && n.standalone;
        /**
         * True if we're running on an iPhone or iPod
         * @memberof XS.is
         */
        that.mobileiOSDevice = u.match(/iPhone/i) || u.match(/iPod/i);
        /**
         * True if we're running on Kongregate
         * @memberof XS.is
         */
        that.kongregate = /(kongregateiframe)/i.test(l);
        /**
         * True if we're running in the KIK messenger
         * @memberof XS.is
         */
        that.kik = /(kik_canvas)/i.test(l);
        /**
         * True if we're running in a Twitter web view
         * @memberof XS.is
         */
        that.twitter = /(twitter)/gi.test(u);
        /**
         * True if we're running in Chrome
         * @memberof XS.is
         */
        that.chrome = /Chrome\//.test(u);
        /**
         * True if we're running in Safari
         * @memberof XS.is
         */
        that.safari = !!navigator.userAgent.match(/Version\/[\d\.]+.*Safari/)
            /**
             * True if we're running from HTTPS
             * @memberof XS.is
             */
        that.secureConnection = window.location.protocol.indexOf('https') == 0
            /**
             * True if we're running as a Facebook Instant app
             * @memberof XS.is
             */
        that.facebookInstant = !!window.FBInstant;
        /**
         * True if we're running as a Facebook Rooms app
         * @memberof XS.is
         */
        that.facebookRooms = window.isFacebookRooms;
        /**
         * True if we're running inside the Spil Games wrapper
         * @memberof XS.is
         */
        that.spilGamesWrapper = /(spilgames)/i.test(l);
        /**
         * True if query string parameter 'social' is set to 'on'
         * @memberof XS.is
         */
        that.social = window.__FRVR.getQueryString("social") == "on";
        /**
         * True if query string parameter 'ads' is set to 'off'
         * @memberof XS.is
         */
        that.advertisementIsDisabled = window.__FRVR.getQueryString("ads") == "off"
            /**
             * True if query string parameter 'int' is set to 'off' window.__FRVR.getQueryString("partnerid")
             * @memberof XS.is
             */
        that.advertisementInterstitialDisabled = window.__FRVR.getQueryString("int") == "off"
            /**
             * True if the advertisement overlay is enabled (if we're not iframed, or inside a partner wrapper)
             * @memberof XS.is
             */
        that.advertisementOverlayEnabled = (!that.iframed) || that.spilGamesWrapper || window.__FRVR.getQueryString("partnerid");

        /**
         * True if nosoc flag is turned on, and social links and buttons should be supressed
         * @memberof XS.is
         */
        that.nosoc = window.__FRVR.getQueryString('nosoc') == "1"
            /**
             * True if the url contains ?fb
             * @memberof XS.is
             */
        that.facebookAd = /(\/\?fb)/i.test(l)

        /**
         * True if we're on any of the mobile platform contexts (android, ios, windows mobile, etc)
         * @memberof XS.is
         */
        that.mobile = that.android || that.windowsMobile || that.iOS || that.silk || that.firefoxMobile;

        /** 
         * True if we're inside the FRVR mobile App wrapper
         * @memberof XS.is 
         */
        that.mobileWrapper = w.iOSWrapper || w.androidWrapper || false

        /**
         * True if we're inside the FRVR iOS App wrapper
         * @memberof XS.is
         */
        that.iOSWrapper = w.iOSWrapper || false;
        /**
         * True if wrapper is running on iPhoneX or later (and hence has a notch) - NB: ONLY WORKS IN WRAPPER SO FAR
         * @memberof XS.is
         */
        that.iPhoneXOrLater = window.__FRVR.getQueryString('iPhoneXOrLater') == "true"
            /**
             * True if wrapper is running in iMessage context on iOS
             * @memberof XS.is
             */
        that.iMessageContext = window.__FRVR.getQueryString('iMessage') == "true"
            /**
             * True if we're inside the FRVR Android App wrapper
             * @memberof XS.is
             */
        that.androidWrapper = w.androidWrapper || false;
        /**
         * True if we're inside the FRVR Chrome App wrapper
         * @memberof XS.is
         */
        that.chromeWrapper = w.isChromeWrapper || false;
        /**
         * True if we are a samsung app store app.
         * @memberof XS.is
         */
        that.samsungAppStore = window.__FRVR.getQueryString("androidStore") == "samsung";
        /**
         * True if we're inside the FRVR Android or iOS App wrapper
         * @memberof XS.is
         */
        that.appWrapper = w.iOSWrapper || w.androidWrapper || that.samsungAppStore;
        /**
         * True if we are using a WebGL Renderer, initialized when XS.renderer is initialized
         * @memberof XS.is
         */
        that.usingWebGLRenderer = false;
        /**
         * True if we are using a Canvas Renderer, initialized when XS.renderer is initialized
         * @memberof XS.is
         */
        that.usingCanvasRenderer = false;
        /**
         * Is a Jio device STB device. NOTE: this is still required because its being used in games, remove it when we introduce capabilities API.
         * @memberof XS.is
         */
        that.jioStb = !!that['jio-stb']
            /**
             * Is a MyJio device
             * @memberof XS.is
             */
        that.myJio = !!that['myjio']
            /**
             * Is a MyJio device
             * @memberof XS.is
             */
        that.jioGameslite = !!that['jio-gameslite']
            /**
             * Is a Jio device
             * @memberof XS.is
             */
        that.jio = that.jioStb || that.myJio || that.jioGameslite
            /**
             * Twitch extension iframe client
             * @memberof XS.is
             */
        that.twitch = window.__FRVR.getQueryString("twitch") == "";
        /**
         * VK.RU iframe client
         * @memberof XS.is
         */
        that.vkru = window.__FRVR.getQueryString("vkru") == "";
        /**
         * OK.RU iframe client
         * @memberof XS.is
         */
        that.okru = window.__FRVR.getQueryString("okru") == "";
        /**
         * t-mobile iframe client
         * @memberof XS.is
         */
        that.tMobile = window.__FRVR.getQueryString("tmobile") == "";
        /**
         * Progressive Web App
         * @memberof XS.is
         */
        that.pwa = window.__FRVR.getQueryString("pwa") == "";
        /**
         * Windows App
         * @memberof XS.is
         */
        that.windowsApp = window.__FRVR.getQueryString("windowsapp") == "";
        /**
         * enableAppStoreLinks - refers to disabling third party app store links in UI
         * @memberof XS.is
         */
        that.enableAppStoreLinks = true;
        /**
         * Samsung GalaxyStore PWA website client
         * @memberof XS.is
         */
        that.samsungGalaxyStorePWA = window.__FRVR.getQueryString("samsung") == "" && window.__FRVR.getQueryString("source") == "galaxystore";
        /**
         * Samsung GameLauncher PWA website client
         * @memberof XS.is
         */
        that.samsungGameLauncherPWA = (window.__FRVR.getQueryString("pwa") == "" || window.__FRVR.getQueryString("samsung") == "") && window.__FRVR.getQueryString("source") == "gamelauncher";
        /**
         * Samsung GameLauncher PWA website client
         * @memberof XS.is
         */
        that.samsungGameLauncher = window.FRVRInstant ? true : false ||
            window.__FRVR.getQueryString("gamelauncher") == "" ||
            window.__FRVR.getQueryString("source") == "gamelauncher"
            /**
             * Samsung Bixby website client
             * @memberof XS.is
             */
        that.samsungBixby = window.__FRVR.getQueryString("samsung") == "" && !that.samsungGalaxyStorePWA;
        /**
         * Samsung browser website uk client
         * @memberof XS.is
         */
        that.samsungBrowserUK = window.__FRVR.getQueryString("samsungbuk") == "";
        /**
         * Samsung browser website us client
         * @memberof XS.is
         */
        that.samsungBrowserUS = window.__FRVR.getQueryString("samsungbus") == "";
        /**
         * Samsung browser website SEA client
         * @memberof XS.is
         */
        that.samsungBrowserSEA = window.__FRVR.getQueryString("samsungbsea") == "";
        /**
         * Samsung browser website client
         * @memberof XS.is
         */
        that.samsungBrowser = window.__FRVR.getQueryString("samsungbrowser") == "";
        /**
         * GL_Fallback
         * @memberof XS.is
         */
        that.samsungGLFallback = window.__FRVR.getQueryString("gl_fallback") == "";
        /**
         * Samsung Instant Play
         * @memberof XS.is
         */
        that.samsungInstantPlay = !!window.GSInstant;
        /**
         * Any Samsung
         * @memberof XS.is
         */
        that.samsung = that.samsungGalaxyStorePWA || that.samsungGameLauncherPWA || that.samsungGameLauncher || that.samsungBixby || that.samsungBrowserUK || that.samsungBrowserUK || that.samsungBrowserUS || that.samsungBrowserSEA || that.samsungBrowser || that.samsungGLFallback || that.samsungInstantPlay
            /**
             * RCS
             * @memberof XS.is
             */
        that.rcs = window.__FRVR.getQueryString("rcsid");
        /**
         * RCS
         * @memberof XS.is
         */
        that.rcsKr = window.__FRVR.getQueryString("rcskr") == "";
        /**
         * Huawei Quick App
         * @memberof XS.is
         */
        that.huaweiquickapp = window.__FRVR.getQueryString("huaweiquickapp") == "";
        /**
         * Huawei Any
         * @memberof XS.is
         */
        that.huawei = window.__FRVR.getQueryString("huawei") == "" || that.huaweiquickapp;
        /**
         * Mozilla
         * @memberof XS.is
         */
        that.mozilla = window.__FRVR.getQueryString("mozilla") == "";
        /**
         * miniclip
         * @memberof XS.is
         */
        that.miniclip = window.__FRVR.getQueryString("miniclip") == "";
        /**
         * Chrome OS Device
         * @memberof XS.is
         */
        that.chromeOSDevice = window.__FRVR.getQueryString("isChromeOSDevice") == "true";
        /**
         * True if we're running in Opera or Opera Mini
         * @memberof XS.is
         */
        that.opera = (!!w.opr && !!w.opr.addons) || !!w.opera || u.indexOf(' OPR/') >= 0;
        /**
         * True if we're running in Yandex
         * @memberof XS.is
         */
        that.yandex = !!window.YaGames
            /**
             * True if we're running in Firefox
             * @memberof XS.is
             */
        that.firefox = w.InstallTrigger !== undefined;
        /**
         * True if we're running in edge 20+
         * @memberof XS.is
         */
        that.edge = /(edge|edgios|edga)\/((\d+)?[\w\.]+)/i.test(u);
        /**
         * True for OPPO's Global H5 Platform
         * @memberof XS.is
         */
        that.oppoGlobal = window.__FRVR.getQueryString("oppo") == "";
        /**
         * True for LG TV platform
         * @memberof XS.is
         */
        that.lgtv = window.__FRVR.getQueryString("lgtv") == "";
        /**
         * True if running in Crazy Games
         * @memberof XS.is
         */
        that.crazyGames = window.__FRVR.getQueryString("partnerid") == "8289067739";
        /**
         * True if running in Mynet
         * @memberof XS.is
         */
        that.mynet = window.__FRVR.getQueryString("mynet") == "";
        /**
         * True if running in ufone
         * @memberof XS.is
         */
        that.ufone = window.__FRVR.getQueryString("partnerid") == "8416254215";
        /**
         * True if running in game8 
         * partner id 3566756403
         * @memberof XS.is
         */
        that.game8 = window.__FRVR.getQueryString("game8") == "";
        /**
         * True if running in MailOnline 
         * partner id 6794212012
         * @memberof XS.is
         */
        that.mailonline = window.__FRVR.getQueryString("partnerid") == "6794212012";
        /**
         * True if true the native brige will not be load
         * @memberof XS.is
         */
        that.disableNativeBridge = window.__FRVR.getQueryString("disableNativeBridge") == "";
        /**
         * True if we're inside the a Partner Android or iOS App wrapper
         * @memberof XS.is
         */
        that.partnerWrapper = !that.disableNativeBridge && (that.mynet || that.tMobile || that.ufone || that.mailonline) && (that.iOS || that.android)
            /**
             * True if we're running in Rocket Chat (should be running alongside nosoc=1 query param)
             * @memberof XS.is
             */
        that.rocketChat = window.__FRVR.getQueryString("rocketchat") == "";
        /**
         * True if we're running in Discord .
         * This is not needed as we can just depend on buildTimePlatform but kept it here to be clearer; can remove in future
         * @memberof XS.is
         */
        that.discord = window.__FRVR.buildTimePlatform === "discord";
        /**
         * True if we're running in Harman
         * @memberof XS.is
         */
        that.harman = window.__FRVR.getQueryString("harman") == "";
        /**
         * is progressive web app enabled
         * @memberof XS.is
         */
        that.progressiveWebAppEnabled = !that.chromeOSDevice && !that.iframed && !that.appWrapper && !that.twitch && !that.vkru && !that.okru && !that.facebookInstant && !that.partnerWrapper
            /**
             * True if platform has a TV UI interface
             * @memberof XS.is
             */
        that.tv = that.jioStb || that.lgTV;
    })(window, navigator, navigator.userAgent, document.location);

})();

; // Important: This file is meant to be XS-agnostic, so it can be
// reused outside.  Please don't add things that are specific to XS
// games.  Don't break abstraction barriers, there is a half-decent
// "exports" section below.  Use that.
(function() {
    var MAX_RETRY = 5;
    var SCRIPT_VERSION = '2.0.0';
    var PROTOCOL_VERSION = 5;
    var PLAY_SESSION_TIMEOUT = 30 * 60 * 1000;
    // var END_POINT_PATH = '/coeus.frvr.com/v1/tm5'; // live
    var END_POINT_PATH = '/coeus/v1/tm5'; // discord

    var queue = [];
    var sendTimer = null;
    var sendEvent = function(eventFields) {
        function dispatchOutstandingEvents() {
            while (queue.length > 0) {
                dispatchEvent(queue.shift());
            }
        }

        queue.push(eventFields);
        if (sendTimer) clearTimeout(sendTimer);
        sendTimer = setTimeout(dispatchOutstandingEvents, 1);
    };

    var sendBeaconAvailable = navigator &&
        (typeof navigator.sendBeacon === "function");

    // Atleast 1 hit must have been send to
    // endpoint with XHR or image before
    // using beacons
    var beaconCanBeUsed = false;

    // Maps internal naming to telemetry protocol format version
    // 5. (Reason is to minimize bytes sent for the common parameters
    // transmitted from client to server)
    var transportCompressionMap = {
        protocol_version: 'f',
        app_version: 'av',
        engine_version: 'ev',
        app_build: 'ab',
        cohort: 'co',
        channel: 'ch',
        games_played: 'gp',
        play_session_id: 'pi',
        play_session_count: 'pc',
        days_elapsed: 'de',
        facebook_player_id: 'fi',
        facebook_context_type: 'fc',
        facebook_entrypoint: 'fe',
        facebook_referral_player_id: 'fr',
        utm_source: 'us',
        utm_medium: 'um',
        utm_campaign: 'uc',
        utm_term: 'ut',
        utm_content: 'uo',
        remote_user_id: 'ru',
        global_user_id: 'guid',
        device_width: 'dw',
        device_height: 'dh',
        non_interaction: 'ni',
        country: 'ct',
        event: 'e',
        game: 'g',
        user: 'u',
        client_time: 't',
        value: 'v',
        provider: 'ao',
        ad_result: 'ar',
        ad_response: 'ag',
        ad_point: 'ap',
        transport: 'tr',
        web_url: 'wu',
        retry: 'r',
        label: 'l',
        advertisement_id: 'ai',
        script_version: 'xv',
        cache_buster: 'n',
        page_session_id: 'si'
    }

    // Local 'Storage' class, seems to be a curious abstraction for a
    // javascript object.
    var Storage = function() {
        try {
            // Check if window.localstorage is fully functional.
            var testKey = '__frvrLocalStorageTest__';
            window.localStorage.setItem(testKey, testKey);
            window.localStorage.removeItem(testKey);
            this.storage = window.localStorage;
            this.type = 'localStorage';
        } catch (_) {
            this.storage = {};
            this.type = 'in-memory';
        }
        this.setItem = function(key, value) {
            this.storage[key] = value;
        }
        this.getItem = function(key) {
            return this.storage[key];
        }
        this.getStorageType = function() {
            return this.type;
        }
    }
    var storage = new Storage();

    function GUID(separator) {
        var delim = separator || "-";

        function S4() {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        }
        var st = ((new Date).getTime().toString(16)).slice(0, 11) +
            (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1, 2);
        return (S4() + S4() + delim + S4() + delim +
            S4() + delim + S4() + delim + st);
    }

    var globalUserIdSource = 'cookie';

    // FIXME: Overrides early-utils.js version with lots of duplicated
    // code!  We should move this code to early-utils.js
    window.__FRVR.globalUserId = function() {

        function getTLD() {
            var fallback = document.location.hostname;
            var hostname = fallback.split('.');
            for (var i = hostname.length - 1; i >= 0; i--) {
                var host = hostname.slice(i).join('.');
                document.cookie = 'get_tld=test;domain=.' + host + ';';
                if (document.cookie.indexOf('get_tld') > -1) {
                    document.cookie = 'get_tld=;domain=.' + host +
                        ';expires=Thu, 01 Jan 1970 00:00:01 GMT;';
                    return host;
                }
            }
            return '';
        }

        var retval;
        // Can we use cookies?
        if (document && document.cookie) {
            var cm = document.cookie.match('^(?:.*_frvr=([^;]*)).*$');
            retval = (cm && cm[1]) || GUID();

            // Now update it, so that the validity gets extended
            var result = new Date();
            result.setDate(result.getDate() + 730);
            document.cookie = "_frvr=" + retval +
                "; path=/; expires=" + new Date(result).toUTCString() +
                "; domain=" + getTLD() + ";";
            globalUserIdSource = 'cookie';
        } else {

            retval = storage.getItem('globalUserId');
            if (!retval) {
                retval = GUID();
                storage.setItem('globalUserId', retval)
            }
            globalUserIdSource = storage.getStorageType();
        }
        return retval;
    };

    function sendData(sendMethod, data, retry) {
        // IE doesn't support default parameters
        retry = typeof retry !== 'undefined' ? retry : MAX_RETRY;

        sendMethod(data, function() {

            if (retry > 0) {

                // retrying with exponential back-off (// 5 sec exponential increments)
                var retryWait =
                    (Math.pow(2, (MAX_RETRY - retry)) + Math.random()) * 5000;
                // Since fields are compresswed ealier "retry" needs to be
                // mapped r manually
                data.r = (MAX_RETRY - retry) + 1;
                setTimeout(sendData.bind(undefined, sendMethod, data, --retry),
                    retryWait); // partial application
            }
        })
    }

    function sendBeacon(path, data, callbackError) {

        if (navigator.sendBeacon(path, JSON.stringify(data)))
            return true;

        callbackError();
    }

    function sendXHR(path, data, callbackError) {

        var xobj = new XMLHttpRequest();

        // Conditional for IE10
        if (xobj.overrideMimeType) xobj.overrideMimeType("text/plain; charset=UTF-8");

        // Try catch block for IE9
        try {
            xobj.open("POST", path + '?' + encodedQueryStringFromObject(data), true);
            xobj.setRequestHeader("Content-type", "text/plain; charset=UTF-8");
            xobj.withCredentials = true;
            xobj.onreadystatechange = function() {
                if (xobj.readyState == 4) {
                    var statusCode = xobj.status;
                    xobj = xobj.onreadystatechange = null;

                    statusCode = parseInt(statusCode)
                    if (statusCode != 200 && statusCode != 204) {
                        // Failure
                        callbackError();
                    } else {
                        beaconCanBeUsed = true;
                    }
                }
            }
            xobj.send();
        } catch (err) {
            callbackError();
        }
    }

    function sendPixel(path, data, callbackError) {

        data.n = Math.random();

        var o = document.createElement('img');
        o.onload = function() {
            beaconCanBeUsed = true;
            o.onerror = o.onload = null;
        }
        o.onerror = function() {
            callbackError();
            o.onerror = null;
        }
        o.src = path + '?' + encodedQueryStringFromObject(data);
        document.body.appendChild(o);
    }

    function getTransportMethod(path, context) {

        // Prefer beacon when present
        if (sendBeaconAvailable && beaconCanBeUsed) {
            context.transport = 'bcn';
            return sendBeacon.bind(undefined, path); // partial application
        }

        // When beacon send fails we default to XHR -> pixel
        if (!!XMLHttpRequest) {
            context.transport = 'xhr';
            return sendXHR.bind(undefined, path); // partial application
        }

        context.transport = 'img';
        return sendPixel.bind(undefined, path + '/i'); // partial application
    }

    function encodedQueryStringFromObject(context) {

        var values = [];
        for (var key in context) {
            values.push(encodeURIComponent(key) +
                '=' + (typeof context[key] !== 'undefined' &&
                    context[key] != null ?
                    encodeURIComponent(context[key]) : ''));
        }
        return values.join('&');
    }

    function compressContext(context) {
        var compressedContext = {};
        for (var key in context) {
            typeof context[key] !== 'undefined' && context[key] != null &&
                (compressedContext[transportCompressionMap[key] ||
                    key] = context[key]);
        }
        return compressedContext;
    }

    function getPageSessionId() {

        var pageSessionId = storage.getItem('pageSessionId');
        if (!pageSessionId) {
            pageSessionId = GUID();
            storage.setItem('pageSessionId', pageSessionId);
        }
        return pageSessionId;
    }

    function getPlaySessionId() {

        var playSessionId = storage.getItem('playSessionId');
        if (playSessionId) {
            var playSessionIdTimeStamp =
                parseInt(storage.getItem('playSessionIdTimeStamp'));
            if ((playSessionIdTimeStamp + PLAY_SESSION_TIMEOUT) < Date.now())
                playSessionId = null; // Play session timeout
        }
        if (!playSessionId) {
            playSessionId = GUID();
            storage.setItem('playSessionId', playSessionId)
        }
        storage.setItem('playSessionIdTimeStamp', Date.now());
        return playSessionId;
    }

    var extraFieldFunctions = [];
    var protocolOverride = undefined;

    function dispatchEvent(fields) {

        var overridingChannel = fields.channel;

        var userId = window.__FRVR.globalUserId();
        var pageSessionId = getPageSessionId();

        for (var i = 0; i < extraFieldFunctions.length; i++) {
            extraFieldFunctions[i](fields);
        }

        // Handle custom webviews etc.
        var protocol = 'unknown://'
        if (document && document.location && document.location.protocol) {
            protocol = document.location.protocol;
        }
        protocol = protocolOverride || protocol;

        var web_url = undefined;
        if (document && document.location && document.location.href) {
            web_url = document.location.href;
        }

        // End point (live)
        // var endpoint = [
        //   protocol,
        //   END_POINT_PATH,
        //   fields.context || '_unspecified_',
        //   userId
        // ].join('/');

        // discord
        var endpoint = [
            END_POINT_PATH,
            fields.context || '_unspecified_',
            userId
        ].join('/');

        // Payload
        // TODO: Allow undefined app version/build
        fields.app_version = fields.app_version || '0.0.0';
        fields.app_build = fields.app_build || '000000';
        fields.channel = overridingChannel || fields.channel;
        fields.web_url = web_url;
        fields.script_version = SCRIPT_VERSION;
        fields.protocol_version = PROTOCOL_VERSION;
        fields.page_session_id = fields.page_session_id || getPageSessionId();
        fields.play_session_id = fields.play_session_id || null;
        fields.cache_buster = Math.random();
        fields.global_user_id = userId;
        fields.global_user_id_source = globalUserIdSource;

        // Platform specifics
        fields.facebook_player_id = window.__FRVR.platformIs.facebookInstant &&
            FBInstant.player &&
            FBInstant.player.getID ? FBInstant.player.getID() : null;

        var offsetMs = new Date().getTimezoneOffset() * 60 * 1000;
        fields.client_time =
            (new Date(Date.now() - offsetMs)).toISOString().slice(0, -1);

        var transportMethod = getTransportMethod(endpoint, fields);
        var compressedPayload = compressContext(fields);
        sendData(transportMethod, compressedPayload);
    }

    exports = window.__FRVR.analytics = {};

    exports.logEvent = function(event, eventFields) {
        if (typeof event === 'object') {
            eventFields = event;
            event = '__unspecified';
        }
        eventFields = eventFields || {};
        eventFields.event = event;
        sendEvent(eventFields);
    }

    exports.logDiscoveryPageView = function(eventFields) {
        eventFields = eventFields || {};
        eventFields.event = 'discovery_page_view';
        sendEvent(eventFields);
    }

    exports.logAdImpression = function(eventFields) {
        eventFields = eventFields || {};
        eventFields.event = 'ad_impression';
        sendEvent(eventFields);
    }

    exports.setProtocolOverride = function(proto) {
        protocolOverride = proto;
    }
    exports.getPageSessionId = getPageSessionId;
    exports.getPlaySessionId = getPlaySessionId;
    exports.compressContext = compressContext;
    exports.extraFieldFunctions = extraFieldFunctions;
})();;

;
(function() {
    var experElem = document.getElementById('ab-experiment');
    var experJSON = experElem && JSON.parse(experElem.innerHTML);

    function selectCohort(chosen, reason) {
        var chosenJs = JSON.parse(chosen.innerHTML);
        chosenJs.cohortName = chosen.getAttribute('data-cohort-name');
        chosenJs.cohortWeight = chosen.__weight;
        chosenJs.cohortIdx = parseInt(chosen.getAttribute('data-cohort-idx'));
        chosenJs.selectionReason = reason;
        chosenJs.experiment = experJSON
        window.__FRVR.cohort = function() { return chosenJs; }
    }

    // Choose cohort at run-time
    var cohortElems = document.getElementsByClassName('cohort');
    if (cohortElems.length === 1) return selectCohort(cohortElems[0], 'single');

    // We got more than one, it's more complicated
    var totalScore = 0;
    var urlParams = URLSearchParams &&
        new URLSearchParams(window.location.search);
    var forceCohort = urlParams && urlParams.get('force-cohort');
    for (var i = 0; i < cohortElems.length; i++) {
        // Count this cohort's weight.
        var weight = cohortElems[i].getAttribute('data-weight');
        cohortElems[i].__weight = (weight && parseInt(weight)) || 100;

        // Consult the force-cohort URL param.
        var name = cohortElems[i].getAttribute('data-cohort-name');
        if (forceCohort && name === forceCohort) {
            window.__FRVR.keepurl = true;
            return selectCohort(cohortElems[i], 'forced');
        }

        totalScore += cohortElems[i].__weight;
    }

    function djb2(str) {
        // simple hash function:  google "djb2 hash"
        for (var i = str.length - 1, count = 5381; i; i--)
            count = str.charCodeAt(i) + (count << 5) + count;
        return count;
    }

    var id = experJSON.name + ':' + window.__FRVR.globalUserId()
    var aleaJactaEst = Math.abs(djb2(id)) % totalScore;

    for (var i = 0; i < cohortElems.length; i++) {
        var ceil = cohortElems[i].__weight;
        if (aleaJactaEst < ceil) {
            return selectCohort(cohortElems[i], 'user-id-random');
        } else aleaJactaEst -= ceil;
    }
})();

;
(function() {
    var __FRVR = window.__FRVR; // for brevity
    var buildJson = __FRVR.cohort().buildJson || {};
    __FRVR.fsxBuildId = buildJson.fsxBuildId;
    try {
        // 'fsx build' style branch info
        // JT@2021-12-12: It's OK to rely on buildJon, but it this isn't
        // correct when NPM package version
        // are used to pin engine versions.
        __FRVR.XSEngineBranch = buildJson.repos['@frvraps/frvr-xs'].branch;
    } catch (ex) {
        console.warn('Could not determine __FRVR.XSEngineBranch')
    }

    try {
        if (__FRVR.XSEngineBranch && __FRVR.XSEngineBranch.indexOf('release/') === 0) {
            // take version number after release/
            __FRVR.XSEngineVersion = __FRVR.XSEngineBranch.slice(8);
        }
    } catch (ex) {};

    // When in a FRVR game, gather more context
    __FRVR.analytics.extraFieldFunctions.push(function(fields) {
        fields.context = __FRVR.cohort().name || '_no_game_'
        fields.app_build = __FRVR.fsxBuildId || __FRVR.cohort()["configJs"]["build"];
        fields.app_version = __FRVR.cohort().version
        fields.channel = __FRVR.getChannel();
        fields.play_session_id = __FRVR.analytics.getPlaySessionId();
    })

    //ignore the document.location.protocol set above, since the native wrappers
    //won't serve the game over https, but rather as http.
    if (window.androidWrapper || window.iOSWrapper) {
        __FRVR.analytics.setProtocolOverride('https://');
    }

    // Snitch home that we're loading the page
    // nb. tracking is disabled for samsung-instant-play
    if (!window.__FRVR.platformIs.samsungInstantPlay) {
        __FRVR.analytics.logEvent('page_loading');
    }
})();;

// Deprecated direct accessors, avoid if possible
window.version = window.__FRVR.cohort().version;
window.gameid = window.__FRVR.cohort().name;
window.gaPath = window.__FRVR.cohort().gaPath;
window.vpath = window.__FRVR.cohort().vpath;
window.spath = window.__FRVR.cohort().spath;
window.extsize = window.__FRVR.cohort().jsSize;
window._jsonData = window.__FRVR.cohort().moreJson;
window.LEGACY_COORD_SYSTEM = false;

window.initTime = window.__FRVR.startTime;

//In seperate code block to load first & not trigger when JS is disabled
var preloader = document.createElement('preloader');
document.body.appendChild(preloader);

; //ie9 polyfill
if (!(window.console && console.log)) {
    var fn = function() {};
    console = { log: fn, debug: fn, info: fn, warn: fn, error: fn };
};

;
Host = {
    Localize: {

        languages: window.__FRVR.cohort().supportedLanguages

    },
    dataUrlsSupported: (function() {
        var c = document.createElement("canvas");
        return c.toDataURL && (c.toDataURL("image/png").indexOf("data:image/png") == 0);
    })()
};
// Local Variables:
// mode: js
// End:
;

;
(function() {
    // Embed general data - this is used by builder.rb's embed_data_content
    //   files: Array of filenames
    //   data : Array of data that mapes to filenames
    window.embeddedFiles = {};
    window.embedFiles = function(files, data) {
        for (var a = 0; a < files.length; a++) {
            var d = data[a]
            window.embeddedFiles[files[a]] = d;
        }
    }

    // Embed image data.  A mapping of
    // {string} logical asset path => {string} png-base64-data |
    //                                {array[2]} svg-commands-and-data
    window.embeddedAssets = {};

    // Only legacy builder.rb uses this.  The new build system builds
    // embeddedAssets directly.
    window.loadAssets = function(files, svgCommands, data) {
        for (var a = 0; a < files.length; a++) {
            var path = files[a]
            var svgCmds = svgCommands[a];
            if (svgCmds) {
                window.embeddedAssets[path] = [svgCmds, data[a]];
            } else {
                window.embeddedAssets[path] = data[a];
            }
        }
    }

})();

;
(function() {
    // implicit exports here:
    //
    //  window.htmlclean
    //  window.htmlprogress,
    //  window.__FRVR.platformSpecificProgress
    //  window.__FRVR.platformSpecificCleanup
    //
    var completed = 0;

    window.htmlprogress = function(total, left) {
        completed = Math.max((left / total), completed)
    }

    var preview = 0;

    var timer = setInterval(function() {
        if (completed < .5) {
            completed += (.5 - completed) / 100
        }
        preview += (completed - preview) / 10
        window.__FRVR.platformSpecificProgress &&
            window.__FRVR.platformSpecificProgress(preview);
    }, 50)

    window.htmlclean = function() {
        window.__FRVR.gameIsLoaded = true;

        // Remove the preloader
        if (preloader) {
            preloader.parentNode && preloader.parentNode.removeChild(preloader)
        }

        // Stop the progress bar timer
        clearInterval(timer)

        window.__FRVR.platformSpecificCleanup &&
            window.__FRVR.platformSpecificCleanup();
    }
})();

;
var gradientBgCanvas, logoBgCanvas, spellcastCanvas, discordCanvas, frvrLogoCanvas, developedBy, developedByText, loadbar, loaderFrame, progressbarTop, progressbarBottom;
if (!window.FBInstant && !window.GSInstant) {

    function logoDraw(actions, cords) {
        function buildCharIndex(chars) {
            var index = {};
            for (var i = 0; i < chars.length; i++) index[chars[i]] = i;
            return index;
        }
        var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/!#$&*-,.:;@()<=>?[]^`{|}";
        var charIndex = buildCharIndex(chars);
        var intChars = "()<=>?[]^`{|}";
        var intCharIndex = buildCharIndex(intChars);
        var cordOffset = 0; // "cord" (sic)
        function getCord() {
            var first = cords[cordOffset++];
            var res, intChar;
            switch (first) {
                case '_':
                    res = 0;
                    break;
                case '~':
                    res = 1;
                    break;
                case '%':
                    res = 149932;
                    break;
                case '\'':
                    res = -149932;
                    break;
                case '@':
                    res =
                        charIndex[cords[cordOffset++]] +
                        charIndex[cords[cordOffset++]] * 74 +
                        charIndex[cords[cordOffset++]] * 5476 // (74 * 74)
                        +
                        charIndex[cords[cordOffset++]] * 405224; // (74 * 74 * 74)
                    res = (res / 100) - 149932;
                    break;
                default:
                    intChar = intCharIndex[first];
                    if (intChar !== undefined) {
                        res = intChar * 88 + charIndex[cords[cordOffset++]];
                    } else {
                        res =
                            charIndex[first] +
                            charIndex[cords[cordOffset++]] * 74 +
                            charIndex[cords[cordOffset++]] * 5476; // (74 * 74)
                        res = (res / 100) - 2026;
                    }
            }
            return res;
        }

        function getColor() {
            return getCord() ?
                'rgb(' + getCord() + ',' + getCord() + ',' + getCord() + ')' :
                'rgba(' + getCord() + ',' + getCord() + ',' + getCord() + ',' + getCord() + ')';
        }

        var canvas = document.createElement('canvas');
        canvas.width = getCord();
        canvas.height = getCord();

        var ctx = canvas.getContext('2d');
        ctx.scale(1, 1);
        var canvasStack = [canvas];
        var fillObject;
        for (var a = 0; a < actions.length; a++) {
            switch (actions[a]) {
                case '4':
                    var newCanvas = document.createElement('canvas');
                    newCanvas.width = getCord();
                    newCanvas.height = getCord();
                    ctx = newCanvas.getContext('2d');
                    canvasStack.push(newCanvas);
                    break;
                case 'b':
                    var pattern = ctx.createPattern(ctx.canvas, 'no-repeat');
                    canvasStack.pop();
                    ctx = canvasStack[canvasStack.length - 1].getContext('2d');
                    ctx.fillStyle = pattern;
                    break;
                case 't':
                    fillObject = ctx.createLinearGradient(getCord(), getCord(), getCord(), getCord());
                    break;
                case 'D':
                    fillObject = ctx.createRadialGradient(getCord(), getCord(), getCord(), getCord(), getCord(), getCord());
                    break;
                case '8':
                    fillObject.addColorStop(getCord(), getColor());
                    break;
                case 'F':
                    ctx.fillStyle = fillObject;
                    break;
                case 'f':
                    ctx.save();
                    break;
                case '/':
                    ctx.bezierCurveTo(getCord(), getCord(), getCord(), getCord(), getCord(), getCord());
                    break;
                case 'p':
                    ctx.strokeStyle = getColor();
                    break;
                case 'w':
                    ctx.lineCap = 'butt';
                    break;
                case 'y':
                    ctx.lineJoin = 'miter';
                    break;
                case '9':
                    ctx.miterLimit = getCord();
                    break;
                case '6':
                    ctx.fillStyle = getColor();
                    break;
                case 'n':
                    ctx.beginPath();
                    break;
                case 'q':
                    ctx.closePath();
                    break;
                case 'o':
                    ctx.fill();
                    break;
                case 'P':
                    ctx.stroke();
                    break;
                case 'r':
                    ctx.restore();
                    break;
                case '2':
                    ctx.arc(getCord(), getCord(), getCord(), getCord(), getCord(), getCord() === 1);
                    break;
                case 'm':
                    ctx.moveTo(getCord(), getCord());
                    break;
                case 'l':
                    ctx.lineTo(getCord(), getCord());
                    break;
                case '5':
                    ctx.quadraticCurveTo(getCord(), getCord(), getCord(), getCord());
                    break;
                case 'C':
                    ctx.clip();
                    break;
                case 'E':
                    ctx.lineWidth = getCord();
                    break;
                case 'A':
                    ctx.transform(getCord(), getCord(), getCord(), getCord(), getCord(), getCord());
                    break;
                case 'u':
                    ctx.translate(getCord(), getCord());
                    break;
                case 'V':
                    ctx.scale(getCord(), getCord());
                    break;
                case '0':
                    ctx.rotate(getCord());
                    break;
                case 'K':
                    ctx.globalAlpha = getCord();
                    break;
                case 'G':
                    ctx.strokeStyle = fillObject;
                    break;
                default:
                    console.error('unhandled', actions[a]);
            }
        }
        // Reset JSG drawing
        cordOffset = 0;
        getCord();
        getCord();
        return canvas;
    }

    var sprites = {
        bgGradient: ["D88Fnml5l5l5l5o", "=4=4):):_):):):_~(K(O<B~~(D(H(?__=4_=4_=4_=4=4=4=4=4=4_=4_=4_=4______"],
        logoBg: ["6nm/22//2///////222/2/l/o6nm22/22/onm/22/2/o6nm//2///onm/2/2//2onm///ll2l2onm22/onm22/22/222222o6nm///2l/onm/2/l/o", "^u<d~(O(f)X$8xRBoErxRBo!XxrCooJxoFoS$waGoKRl6;k3.k~SkwesndjlsAl_~*.wKYnqywOIn]JEIn]CEInEMw1Ln$;v*Rnu:uslmySmzAl_~sRw!9l!$vsVlUHviVlwiuiVlojt+7lc+sSumG8sQsmkosaTmK;r0Zm>VQ1lGEr:;k=c_O#p_lvpKRlkgp+nlqSpaclEApWTlK3o4Sl0HoeRl)446lWunkimS*oDjm(.t-k8*k~w&nKnnEalf.k1-k~*Wn$LoV0lQ:k+.k~J$mXfnkim)*0emMMo6,l1NpzImW:k6.k~9qlcDoiQlHQo_<M^u!io:vyHQoeUyaBo$8xRBo~(T(8)uYAp:,mEApuBokEm2.kO:k_6/oE1nH/lp:k2.k~Kjoy/miOoeJn)})t0voMfnQhlGElTDl~Wvo,nnuclrDlHEl_wSoJRnCqo/,mYAp:,m6Bwswn6BwVdne0vsNn[liNnyWv4LoK:l2.kK.k~.MvUPoA:lZ.k3.k_4rvSRnG*veinG*vk3nvmvG3nWdl!;kvAl_E.vQ#n6Bw)!6Bwswn~_(7),$#sU*m*NtMZmi2t$/lOZuLqlituegl*-uOalYVveWlRIv4imKNm*.ky.k~?#GXl?O-Bmc+sSumdqsSVmKEs8Xm:BsWZmKJsibm04s!gm$#sU*m<,G6lAupial4Dq6AlO4qwFlQXqiWmiWmO:k2.k~5&p0;kOtp!Qlagp+nlW0ouYm0Fm2:k0.k~PYouSl:Co8gl!/ne0l4GofllKeo,bl4zoGcluzocamK:l2.kA;k_s*nIMn*qn)gqpn+knqpn+kn,/msSnilmA-nFlm9-nKmm):kAn-bnltnYwnltnYwnltn0uncDo/un2flt-k1.k_CHoQPny-nKin!Vlh:kw.k~y1m2Jo.1m9to*jl1.kR:k_GxmkfoYal4:k4-k~6amqRoQnm2Joy1m2JooJxaGo:#wkGo(N+;k7.k~qowYrnzgl0Al/;k~e;w#XnC3w6HnOgw6HnSfwgznlrl3.k/,k~qZw)#sulI.k2.k_eww:Ln6$wEcn6$w)5aiwSvn(Y!;koAl_sgwIvn$hlmAl$Al_:8w$Go(IR.ks.k_i+wdNoURlm.kw;k_o/wSNoOQlw;kPAl_m$waGo!Ql8Al_~~(/)F<FCFwSwoG/v:Ro;nvzKoWYv+Ro[e0WoKMvchoKMvssoa:uxho[GQfostu$kow2u<boRlA.k/-k~WFw6woMFwwwoMFwnwoCFwSwoklpYEoMIpYEo88o0RoYxo:lo8Ko<[IVmV:k2.k~M4n!doErnImowln<dCxq<dqiquaol:pYEoklpYEo"],
        discordLogo: ["6nml22222lm2222llonm2l222222l222222l22/2ll22222onm222222l2222222ll22onm2222222222m22222222onml222lllll222onmlll222222222lm222222onm222222l2/222/222l2m222/m2222onm////onm2llo", "):(e~<><><>e:laIlDKmaIlMKmKbluSl1.kS:k_ANmCTlIKlW:kD;k_iMmuSlSKlK;ksAl_fNmMTlMJlrAlhBl_(+(IkSlfBlACl_e:lWdlGJm$Xl(+,Rl6FlGClCBl~DKmCTl0El-Al2;k~gKmaSlWEl-;k4:k~DKmCTlIFl1:ks.k~+Fm4Nl+Fm$XlWomMdllsmoMlARlXClyCl_:jmeWljqmCOlcKl/ClWCl~)A!Gl,RlZCl;Bl~CtmyWlKClSClSBl~)BCYlmAlzBl8;k~0tmCYl*Al7;k!:k~$smSZlUClx:k*.k~7pmAWlLrmkNlkIlNCl-Cl_+om2QlqElFDlEFl_*pmyRl*Flr,kg.k_WtmIZlCOlT.k2.k_usmFkl:Yl5.kA:k_gtm(U*PlI:kf:k_e1moRlPvmWdlQNlc:kC:k~wumKblOLlK:k0.k~usm6PlyrmOQlyrm2Qlasm2QlmAl1-kC*k~0tm,RlywmkSlUwmwZlAHl7.kz:k_4xm4XlqEl3:k-;k_4xmCYlqEl9;kVBl_:tm,Rl2LlSBlECl_gtmqJl(P;BlXCl_d9mucl0#mSUl(HtClaDl_u!mmUlQIlXDlJEl_)QmUl:Jlu-kX,k_:#m!VlcKlj,kL.k_O&mWYlGNlK.k5.k_L*m+YluNly.kh:k_MBnaSl$-mAbl:Jli:kI:k~C,mCYlKHlS:kz.k~a-mqYlyHl6.kA.k~*$mmUl,ClC.k-*k~*$mSUlGDlWDltCl~a-msQleHl0Cl$Bl~4-m,MlELl.BltBl~MBnyWlMBn8blU*mURleMl(BDCl_s&m(KYQl:BlkCl_iInucliNnCTl(IuClVDl_1LnmUlaIlXDlKEl_qLn(PQIlFEl!El_ONnsVlcKlf,kH.k_yOnucl(NS.kP:k_WQnOVl:Jlb:kE;k_wRn(PQIlF;k!;k_SRncUluIl8;ktAl_:QncUl$IlsAlbBl_oOnWOlcPleBllCl_wRnaXlHPn6UlkDl*Al1;k~)h:TlQDl;;k1:k~HPnmUl4Dlz:kr.k~fOncUluDl+.k3,k~UOn(PaDlz,kk-k~fOn6UlkDl2-kn*k~8On+TlgEl*ClACl~yOn0TlqEl.BlDBl~!rnKMl!rnuSl$onuXlwFlh:k1.k~uoneWlgEl7.ks,k~wqnaXl(Fj,kn-k~$jnWdltcnWdltcn!Ll4jn!Ll4jn(Nltn$Sl0Jl8-kj,k_$on6PlMElq,k4.k_qpnwPlCElp.km:k_):8Hl):Mdl48nMdl48nSZlV2nyWl!GlaAlQBl_Y1n6Ul$IlTBl:Bl_Y1n(QQIl:Bl0Cl_m0nyWl2Gl0ClrDl_q4ncUlYLllDlFEl_04nmUliLlt-kO,k_A2ngTlkIlP,k,,k_21n+Tl4IlB.k1.k_K2n,Rl!Glv.kb;k_48n8Hlz7nQXl;4nmUluDl$Al6;k~m5n(PGDl.;k0:k~04nEVlWEl0:k2,k~g4ncUluDlw,kr-k~;4ncUlMElGElIDl~04nCTl:El7ClKBl~wtlQDlUblNsl0slW:k,.k~2zlqJl0TlV,kF,k~(UwolQml,.kl.k~AClqJl0Tlc;kM;k~*Zl:nlmoll.kI.k~CslMdlCslh,ki-k~IAl$hlOalM;kQrl+ClbCl~+OlWnl6Plyll2QlFkl2al(G0dlgClxCl_(M5mlOGl5,kG.k_2algEliflqClaBl~*olQhlOpl(Zspl4hlkclQNl(S~kBl_M!lUWlSeliDlPDl~cZl:*k,vlpBlJBl~v1l$hlMJlCdlqsl;;kB;k~,RlyblQSloWl:ElDClMEl_GSl!Vl+El;DlNGl_yRlAWl:El7.k*;k_yWlSZlwUlybl,Rlybl6jlyblOkleWlIFlFClKEl_FklAWl:ElBElLGl_wjlAWl:El4.k*;k_mjleWlIFl8;k$Bl_GdmKHlIfmKHl2gmsIl2gmcKl2gmNMlIfmuNlGdmuNlFbmuNlgZmNMlgZmcKlgZmsIlFbmKHlGdmKHlgZm*PlGdm!GlqJlkClhBl~2gmWdlgZmWdl"],
        spellcastLogo: ["nmlllllllllllllllllllonmllllllmlllonmlllllllllllmlllonmllllllllllonmllllllllllonmlllllllllllllllonmllllllllmlllonmlllllllllllllllllllonmllllllllllllllo6nmlllllllllllllllllonmllllllmlllonmlllllllllllmlllonmllllllllonmllllllllot888888Fnmlllllllllllllllot888888Fnmllllllllmlllot888888Fnmlllllllllllllllllllot888888Fnmllllllllllllllo", ">y)HqHl+UlqHl49lVjl2DmVjlbUm5clJYm5cl&DmqHlWQmqHl(>Cgl6umk4l(>k4lm#l5clnxl5clFhlVjlXdlVjlbxlk4l:klk4l+UlCglwGlqHl+UlqHl+UlU$lKllU$l6umiNmdimiNmPUmOpmREmOpmKll2Qm,Wl;TmA$liNm3-liNmbxl;Tmutl.ymKll.ym(>fBn6um#Zn(>#ZnICmyEnlOmyEnbUmM:mJYmM:m/Nm#Zn!.l#ZnKllfBn,WlyEnv7lM:md/lM:mbxlyEnutlc/nbUm/4nJYm/4n,WlxjnZjlxjn(>I8n6umqKo(>qKot*lc/nAHmc/nbUmc/nbUmFwobUmppoJYmppo,WlaUoZjlaUo(>8so6umU-o(>U-ot*lFwoAHmFwobUmFwobUm0Gp5Vl0GpYmmngpW1ma6pYmma6pE&l.jpKGm.jpfZmGdpcdmGdpzil.jp2el.jp#9la6p7wla6p5Vlngp7Gl0Gp5Vl0Gp5Vly*p;mly*pW1mERqQomERqAcm-XqDYm-XqW1mYuqQomYuq;mllUqBYl-XqQ:lERqNCmERq&zl-Xq,vlw4q;mlw4qs;l&LriQm&LrfZmCFrcdmCFrONmw4qUamw4qYmmiIrW1mWirYmmWirpDmCFry8lCFr&zl&Lr,vl&Lr,/lWir!ylWir;mliIrBYlw4q;mlw4q;mlTWsU6lTWshglA&rXxlA&rBYlusrHllusrYmmh,rW1mTWsYmmTWsQ:l#;rWLm#;rfZmA&rcdmA&rKBmTWsU6lTWsU6l~<><><>yCl#3lyCl,OlJbl5Alrzl,OlrzlHfldelkrldelgXl!XlNbl!Xlwrlrzlu7lrzl1amJbl$omyCl1amyCleKm!XlB:l!XlRSmdelkOmdel/.lb9lTfl9LmFRlVkmTflVkmZ:lqImYOmqImlcmb9l$omqImkrlqIm!/lGPmJ8lGPm2nl:UnR,l:Un1amm,m$omEum1amEumTflm,mFRl:UnTfl:Un;#lT&m.HmT&mRSm6;mkOm6;muImT&ml5l6;m41l6;m2nlT&mkrlyFo1amQ3n$om4en1am4enidl,znFRl,znRSmj6nkOmj6nJBmyFo2+lb!o1am&no$omhPo1amhPoidlwkoFRlwkoRSmMrokOmMroJBmb!o2+lubpp*mubpS+k-;k~({)a<$YAl~(=)/<&oAl~(()=<&yAl~(2<X<.!Al~(c<!<<:Al~(S<><>7Bp$Pl7Bphgmubpfvmh1phgmh1pM9lFfpSAmFfpnTmNYpkXmNYp7clFfp+YlFfpA4lh1p*qlh1p$Plubp*Al7Bp$Pl7Bp$PlsPqp*msPqS+k-;k~({)a<$YAl~(=)/<&oAl~(()=<&yAl~(2<X<.!Al~(c<!<<:Al~(S<><>5/pIhl5/pfvmLMqZimLMqIWmDTqLSmDTqfvmfpqZimfpqIhlsPqKSlDTqY$lLMqW,lLMqBulDTqEqlqDrp*mqDrS+k-;k~({)a<$YAl~(=)/<&oAl~(()=<&yAl~(2<X<.!Al~(c<!<<:Al~(S<><>3zqIhl3zq0&lAHrrKmAHrnTmJArkXmJArXHm3zqdUm3zqhgmqDrfvmddrhgmddrx.lJAr72lJArBulAHrEqlAHrF6lddr;slddrIhlqDrJSl3zqIhl3zqIhlo#rp*mo#rS+k-;k~({)a<$YAl~(=)/<&oAl~(()=<&yAl~(2<X<.!Al~(c<!<<:Al~(S<><>bRsd0lbRsqalH+rgrlH+rJSl1nrQfl1nrhgmo#rfvmbRshgmbRsY$l;*rfFm;*rnTmH+rkXmH+rT-lbRsd0lbRsd0l"],
        loaderFrame: ["yw6nml2l2l2l2ml2l2l2l2q9opEnmll/lP9nmll/lP9nmll/lP9nmll/lP9nmlP9nmlP9nmlP9nmlP6nml2llll2l2l2lo6nml2l2lllllll2l2o6nmllllonmllllonmllllonmllllonmllllo6nmlllllllllllmllllo9nm2l2l2l2qP", "^u)W~(C<R<tKxx*Kl-Bm*Kl-BmWAmQ/l1.kt-k~oMl(3-BmCAmQ/lGEl:Bl~Kxxf/mKxxCAmQ/l:Bl_~mmy(3Uxx(3H/l_1.k~!/x(3!/x(3:fx(32fl_:Bl_QTmEgmQTmCAm!fl:BlGEl_O9l(3QTmWAm!flt-k1.k_+fxUql+fxWAm!fl1.k__(K~<><><>(C>AgElCerWYlvdmWYlvdmWYl41lUWl8vlw#l*Alw#l(K=[$-m2WrCym(<Cym(<CymM2lE0mGwlzImcAlzIm(K0asgElPcsWYl]/WYl]/WYlUFyUWlQLyw#l^pw#l(K>6$-mQjsCymUdxCymUdxCymKFyE0mQLyzIm6ryzIm(K:3reHl>RAql(KKEseHlKEsAql(K81rA*mr3rEgm(K2DsA*m2DsEgm~_(,)fwmy(3wmy(3Kxx&;l(v_:Bl_S&nf/mswn!5mQUnf/m-Bmf/m-BmCAmQ/l:BlGEl__(3WAmCAmWAmGEl.Bl~4yx)W$yxCAmWAm:Bl_~wmy(3~~)Z).4yx_gAm_WAmWAmWAm2.kt-k~oMl(3ECmgAm(vt-k1.k_,Es*KldRsYQlPcs*Kl>;*KlJ:s8Rl?H*KlKxx*KlKxxgAm(v1.k__^u(3$yxWAmWAm_1.k~~(a)S)!dUvE0mGcvKwm4hvE0mdUvE0mdUvE0m!8pE0m:;p81m:;pPvm!8pE0m!8pE0m5#n0Ylx5n$cl!*nQhl5#n0Yl5#n0YlcJuMTl,BuCYlcJuuclcJuMTlcJuMTl5vuaXl,zu+Ol23uMTl5vuaXl5vuaXl~(a(&)Yyyys9l^ko+l,Zy46leZy4rlm:x+nl!*xikl]>_ktx_w&x!klUPy24lmmy(wGzy(wIXy(r0Ry(pcDy,qlSXywtlSXy(r(K!/x(3:fx(32fl_1.k~QTmUqlQTmWAm!fl1.kt-k~O9l(3QTmCAm!flGEl:Bl~+fxEgm+fxCAm!fl:Bl_~"],
        frvrLogo: ["6nml///l/o4t888888888FfnmlllCfAnml5l5l5l5orrbnml///l/o4t8888888FfnmlllCfAnml5l5l5l5orrbnml///l/onml/6nm//l///l/o6nml/l///l/o6nm/l/l//o6nm//l/l/o6nmllll/lll/llmlllllllllllllm//ll////lllll/lml//lllm//ll////lllll/lml//llo", "`l`R~)&_<>6+ns;sezpARqOep=qMDp=yGzo41q&BoG1qkenMJqken+hpkenHRp4jn2Apysnz8oe0lwpr+PmQUs)Ut6s6+ns;s`l`RPjp@Ka7ik/q@Rh6iEAl~);(L<#fAl~).(M</tAl~)$(O<34Al~)5(R<q#Al~)r(W<X;Al~)a(c)|HBl~)E(j)4NBl~(*(s)V~~(/(u)O__`l_`l`R_`R~__k:k_@MK+i@Wbni@Wbni@+P-p@Wbni@+P-p@Wbni@+P-p@Wbni@+P-p@+P-p@+P-p@+P-p@+P-p@+P-p@Wbni@+P-p@Wbni@+P-p@Wbni@+P-p@Wbni@Wbni@Wbni@Wbni@Wbni@WbniJspN-lAxnY2o).<L<EOOo,yo6No<udNoofp#YoC1p+0om-pWDpQNqwdp*Pqghp*uryYn;Krgymegq6LmJspN-l`l`Rhjs@Z65iTnu@873iIAl~<A(Z(ZNAl~<L(s(aaAl~<h(](bmAl~<y)X(cyAl~<+)s(c+Al~<,)5(dABl~<:)9(d__`l_`l`R_`R~__k:k_@MK+i@Wbni@Wbni@+P-p@Wbni@+P-p@Wbni@+P-p@Wbni@+P-p@+P-p@+P-p@+P-p@+P-p@+P-p@Wbni@+P-p@Wbni@+P-p@Wbni@+P-p@Wbni@Wbni@Wbni@Wbni@Wbni@WbniQNv?v2XxYzqs&woSr8SwmprQrv>H!,ugor+Xu=>!!tLvqO!t=sAFt<*AFt<*OvrqorOXs>=:vtA3tQNv?vosn88oAxnY2onvnk4oCunx6oosn88o~<>_(pfvv_1&t_-gs!$l7uryYn7uryYn8zpOQqUzpARq6+ns;sSIoEEtmco?Dixo?DC*p?D:2qktssvrgorLwr4nrKEsl;qiitY!o[=YBlk*vcAlG6v_fvv_~<>)+(D]!6oq,pzRZn^4vEmErx!Ll[=YBliitO!oAytupoi!t<E!!toUo+XuYwn!,uTbnQrv0anKww&ZnMzx8KoK2x+hpK2x+hpO1xF#pysxQSq]!6oq~<><X_`j0hp`jGzoG&z/.n,pzRZn]!6oqscxhsqMax,vq2XxYzqQNv?vhYvD&t-jvq&tfvvq&t0Hy1&t`j>b`j0hp~_<N<>YxoS8lywmS8lUCl6gnUClXhpUCl=X6Uls.qe0lwprysnz8oCunm6ocvnk4oAxnY2oJspN-laWp(vc;oS8lYxoS8l~<><><>IAl7yvIAla0z5/la0z5/lISy)xISy)x0Ry)x*gx)xmgx5/lmgx5/l:jwC.n:jwC.nqjwC.n7yvC.n[5IAl7yvIAl7yv[g[54Mu^rKLu^rWHt[5ONs[5sNs7yvONs7yv!xta0zCwua0z0Kw7yv0Kw7yv0Kw[5[g[5[g[5c.r4$y!vr*EzecrS;y=.:0yNAr^pm#qiiyK5q!Yye5q!Yye5q!YyGErGVyGOr^UIQrKPyCZr,Ky>BUFy>GI:x#0r!6x>Zqkx>Z]r>ZmQw=^:xvqiq:xvKyo:xvKyoa0z6npa0z6npwcyA4pwcy4XqWDzCArCO0UEswszc.r4$y<;]N=i]Ni4q]N=!i0w=!]r=!Waxi4q];=i];<;];<;]N<;]NoC04$yC1z*EzrhzS;y0Nz:0yYFz^py,yiiyX+y!Yyq+y!Yyq+y!YyTJzGVySTz^UUVzKPyPez,KyCmzUFy6szI:xC6z!6xi,zqkxi,z]ri,zmQw*dz:xv2ny:xvW3w:xvW3wa0z,sxa0z,sxwcyM9xwcy*cyWDzPFzCO0gJ0wszoC04$yatx]Nqly]Nk9y]NIEzi0wIEz]rIEzWaxk9y];qly];atx];atx]N"],
    }

    function getSpriteCanvas(name) {
        var sprite = sprites[name];
        var actions = sprite[0];
        var coords = sprite[1];
        return logoDraw(actions, coords);
    }
    gradientBgCanvas = getSpriteCanvas('bgGradient');
    logoBgCanvas = getSpriteCanvas('logoBg');
    spellcastCanvas = getSpriteCanvas('spellcastLogo');
    discordCanvas = getSpriteCanvas('discordLogo');
    frvrLogoCanvas = getSpriteCanvas('frvrLogo');

    preloader.appendChild(gradientBgCanvas);
    preloader.appendChild(logoBgCanvas);
    preloader.appendChild(spellcastCanvas);
    preloader.appendChild(discordCanvas);
    preloader.appendChild(frvrLogoCanvas);

    loadbar = document.createElement('loadbar');
    progressbarTop = document.createElement('div');
    progressbarBottom = document.createElement('div');
    preloader.appendChild(loadbar);
    loadbar.appendChild(progressbarBottom);
    loadbar.appendChild(progressbarTop);
    loaderFrame = getSpriteCanvas('loaderFrame');
    preloader.appendChild(loaderFrame);

    loadbar.style['background'] = '#3071A9';
    preloader.style['background'] = '#040247';
    progressbarTop.style['background-color'] = '#E46EF8';
    progressbarBottom.style['background-color'] = '#C63AF6';
    progressbarBottom.style['height'] = '50%';

    developedBy = document.createElement('devby');
    developedBy.style['font-family'] = 'Tahoma, "Helvetica neue", helvetica, Verdana, Arial';
    developedBy.style['font-weight'] = '900';
    developedBy.style['text-align'] = 'center';
    developedBy.style['position'] = 'fixed';
    developedBy.style['color'] = '#FFFFFF';
    preloader.appendChild(developedBy);
    developedByText = document.createTextNode('Developed by');
    developedBy.appendChild(developedByText);

    setTimeout(function() {
        loadbar && (loadbar.style.display = "block")
        developedBy.style.display = "block"
    }, 10)
}

var ow = 0
var oh = 0

function handleResize() {
    // FIXME: A noop on FBInstant and GSInstant, so we should
    // rework this so we just don't call it just don't call it
    // in those scenarios
    if (!!!window.FBInstant && !window.GSInstant) {
        var w = document.documentElement.clientWidth;
        var h = Math.min(window.innerHeight, document.documentElement.clientHeight);
        if (ow != w || oh != h) {
            ow = w;
            oh = h;
            var s = Math.min(w, h) * .8 >> 0
            var nh = s * 0.3 >> 0
            var t = ((h - nh * 2) / 2 >> 0)

            gradientBgCanvas.style.height = h + "px";
            gradientBgCanvas.style.width = w + "px";

            logoBgCanvas.style.width = s + "px";
            logoBgCanvas.style.top = t + "px"
            logoBgCanvas.style.left = ((w - s) / 2 >> 0) + "px"

            var spellcastW = (s * 0.6) >> 0;
            var spellcastH = (spellcastW * 0.23) >> 0;
            spellcastCanvas.style.width = spellcastW + "px";
            spellcastCanvas.style.left = ((w - spellcastW) / 2 >> 0) + "px"
            spellcastCanvas.style.top = (t + (s * .29 - spellcastH) * .65) + "px"

            var discordW = (s * 0.21) >> 0;
            var discordH = (s * 0.19) >> 0;
            discordCanvas.style.width = discordW + "px";
            discordCanvas.style.left = ((w - discordW) / 2 >> 0) + "px"
            discordCanvas.style.top = (t + (s * .29 - discordH) * .35) + "px"

            var frameW = s * 0.8 >> 0;
            var frameH = frameW * 0.146 >> 0;
            loaderFrame.style.width = frameW + "px";
            loaderFrame.style.left = ((w - frameW) / 2 >> 0) + "px"
            loaderFrame.style.top = (t + nh * 1.0) + "px"

            var loadbarH = ((frameH * .42) >> 0);
            var loadbarW = ((loadbarH * 16) >> 0);

            loadbar.style.width = loadbarW + "px"
            loadbar.style.height = (loadbarH) + "px"
            loadbar.style.top = ((t + nh * 1.0) + ((frameH - loadbarH) / 2)) + "px"
            loadbar.style.left = ((w - loadbarW) / 2 >> 0) + "px"

            var devByHeight = ((loadbarH * .5) >> 0);
            developedBy.style['font-size'] = devByHeight + "px"
            developedBy.style.width = loadbarW + "px"
            developedBy.style.left = ((w - loadbarW) / 2 >> 0) + "px"
            developedBy.style.top = ((t + nh * 1.02) + frameH) + "px"

            var frvrW = (discordW * 0.4) >> 0;
            frvrLogoCanvas.style.width = frvrW + "px";
            frvrLogoCanvas.style.left = ((w - frvrW) / 2 >> 0) + "px"
            frvrLogoCanvas.style.top = ((t + nh * 1.05) + frameH + devByHeight) + "px"

        }
    }
}
handleResize()

window.__FRVR.platformSpecificProgress = function(preview) {
    progressbarTop && (progressbarTop.style.width = (preview * 100 >> 0) + "%")
    progressbarBottom && (progressbarBottom.style.width = (preview * 100 >> 0) + "%")
    handleResize();
}

window.__FRVR.platformSpecificCleanup = function() {
    // Dealloc the logoCanvas
    if (logoBgCanvas) {
        logoBgCanvas.width = logoBgCanvas.height = 1
    }

    // Garbage collection
    logoBgCanvas = spellcastCanvas = discordCanvas = frvrLogoCanvas = loadbar = loaderFrame = progressbarTop = progressbarBottom = loadbar = progressbar = logoCanvas = preloader = null;
};