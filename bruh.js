"use strict";
(this.webpackChunkdiscord_app = this.webpackChunkdiscord_app || []).push([
    [11939], {
        777552: (e, t, r) => {
            r.d(t, {
                uL: () => M,
                mO: () => D,
                Tg: () => G,
                UU: () => A,
                gK: () => F,
                PF: () => Z,
                v2: () => N,
                yC: () => R,
                hM: () => _,
                t1: () => w,
                R7: () => C
            });
            var n = r(496486),
                o = r.n(n),
                i = r(468811),
                c = r.n(i),
                u = r(675860),
                l = r(200637),
                a = r(173436),
                s = r(23816),
                f = r(817513),
                p = r(180918),
                b = r(718862),
                y = r(932847),
                O = r(461061);

            function d(e, t, r) {
                var n = null != t ? function(e, t, r) {
                        t in e ? Object.defineProperty(e, t, {
                            value: r,
                            enumerable: !0,
                            configurable: !0,
                            writable: !0
                        }) : e[t] = r;
                        return e
                    }({}, t, 1) : {},
                    o = null != r ? r : {},
                    i = o.offset,
                    c = o.limit,
                    u = o.results,
                    l = o.totalResults;
                return {
                    search_type: O.aib.GIF,
                    load_id: e,
                    limit: c,
                    offset: i,
                    page: null != c && null != i ? Math.floor(i / c) + 1 : 1,
                    total_results: l,
                    page_results: null != u ? u.length : null,
                    num_modifiers: Object.keys(n).length,
                    modifiers: n
                }
            }
            var g = r(992497),
                v = r(228031),
                m = r(959797);

            function h(e, t, r) {
                t in e ? Object.defineProperty(e, t, {
                    value: r,
                    enumerable: !0,
                    configurable: !0,
                    writable: !0
                }) : e[t] = r;
                return e
            }

            function j(e) {
                for (var t = 1; t < arguments.length; t++) {
                    var r = null != arguments[t] ? arguments[t] : {},
                        n = Object.keys(r);
                    "function" == typeof Object.getOwnPropertySymbols && (n = n.concat(Object.getOwnPropertySymbols(r).filter((function(e) {
                        return Object.getOwnPropertyDescriptor(r, e).enumerable
                    }))));
                    n.forEach((function(t) {
                        h(e, t, r[t])
                    }))
                }
                return e
            }

            function E(e, t) {
                t = null != t ? t : {};
                Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : function(e, t) {
                    var r = Object.keys(e);
                    if (Object.getOwnPropertySymbols) {
                        var n = Object.getOwnPropertySymbols(e);
                        t && (n = n.filter((function(t) {
                            return Object.getOwnPropertyDescriptor(e, t).enumerable
                        })));
                        r.push.apply(r, n)
                    }
                    return r
                }(Object(t)).forEach((function(r) {
                    Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r))
                }));
                return e
            }

            function P(e, t) {
                if (null == e)
                    return {};
                var r, n, o = function(e, t) {
                    if (null == e)
                        return {};
                    var r, n, o = {},
                        i = Object.keys(e);
                    for (n = 0; n < i.length; n++) {
                        r = i[n];
                        t.indexOf(r) >= 0 || (o[r] = e[r])
                    }
                    return o
                }(e, t);
                if (Object.getOwnPropertySymbols) {
                    var i = Object.getOwnPropertySymbols(e);
                    for (n = 0; n < i.length; n++) {
                        r = i[n];
                        t.indexOf(r) >= 0 || Object.prototype.propertyIsEnumerable.call(e, r) && (o[r] = e[r])
                    }
                }
                return o
            }
            var I = /-/g;

            function w(e) {
                var t = null != e ? h({}, e, 1) : {};
                s.ZP.trackWithMetadata(O.rMx.SEARCH_STARTED, {
                    search_type: O.aib.GIF,
                    load_id: b.Z.getAnalyticsID(),
                    num_modifiers: Object.keys(t).length,
                    modifiers: t
                })
            }

            function _(e, t) {
                var r = arguments.length > 2 && void 0 !== arguments[2] ? arguments[2] : {},
                    n = r.startTime,
                    o = P(r, ["startTime"]),
                    i = {
                        offset: 0,
                        limit: null,
                        totalResults: e.length
                    },
                    c = d(b.Z.getAnalyticsID(), t, E(j({}, i, o), {
                        results: e
                    })),
                    u = null == n ? {} : {
                        load_duration_ms: Date.now() - n
                    };
                s.ZP.trackWithMetadata(O.rMx.SEARCH_RESULT_VIEWED, j({}, c, u))
            }

            function S(e, t, r) {
                var n = Date.now();
                w(t);
                u.Z.get({
                    url: O.ANM.GIFS_SEARCH,
                    query: {
                        q: e,
                        media_format: b.Z.getSelectedFormat(),
                        provider: O.Yrq.TENOR,
                        locale: f.default.locale,
                        limit: r
                    },
                    oldFormErrors: !0
                }).then((function(o) {
                    var i = o.body;
                    _(i, t, {
                        startTime: n,
                        limit: r
                    });
                    a.Z.dispatch({
                        type: "GIF_PICKER_QUERY_SUCCESS",
                        query: e,
                        items: i
                    })
                }), (function() {
                    return a.Z.dispatch({
                        type: "GIF_PICKER_QUERY_FAILURE",
                        query: e
                    })
                }))
            }
            var T = o().debounce(S, 250);

            function R(e, t) {
                var r = arguments.length > 2 && void 0 !== arguments[2] && arguments[2],
                    n = arguments.length > 3 ? arguments[3] : void 0;
                if ("" === e)
                    N();
                else {
                    a.Z.dispatch({
                        type: "GIF_PICKER_QUERY",
                        query: e
                    });
                    r ? S(e, t, n) : T(e, t, n)
                }
            }

            function D(e) {
                "" !== e && null != e && u.Z.get({
                    url: O.ANM.GIFS_SUGGEST,
                    query: {
                        q: e,
                        provider: O.Yrq.TENOR,
                        limit: 5,
                        locale: f.default.locale
                    },
                    oldFormErrors: !0
                }).then((function(t) {
                    var r = t.body;
                    a.Z.dispatch({
                        type: "GIF_PICKER_SUGGESTIONS_SUCCESS",
                        query: e,
                        items: r
                    })
                }))
            }

            function N() {
                a.Z.dispatch({
                    type: "GIF_PICKER_QUERY",
                    query: ""
                })
            }

            function C(e) {
                var t = e.type,
                    r = e.index,
                    n = e.offset,
                    o = e.limit,
                    i = e.results,
                    c = e.totalResults,
                    l = e.query,
                    a = e.gifId,
                    f = d(b.Z.getAnalyticsID(), t, {
                        offset: n,
                        limit: o,
                        results: i,
                        totalResults: c
                    });
                s.ZP.trackWithMetadata(O.rMx.SEARCH_RESULT_SELECTED, E(j({}, f), {
                    index_num: r,
                    source_object: "GIF Picker",
                    query: l
                }));
                null != a && u.Z.post({
                    url: O.ANM.GIFS_SELECT,
                    body: {
                        id: a,
                        q: l
                    },
                    oldFormErrors: !0
                })
            }

            function F() {
                var e = c().v4().replace(I, "");
                s.ZP.trackWithMetadata(O.rMx.SEARCH_OPENED, {
                    search_type: O.aib.GIF,
                    load_id: e
                });
                a.Z.wait((function() {
                    a.Z.dispatch({
                        type: "GIF_PICKER_INITIALIZE",
                        analyticsID: e
                    })
                }))
            }

            function G() {
                u.Z.get({
                    url: O.ANM.GIFS_TRENDING,
                    query: {
                        provider: O.Yrq.TENOR,
                        locale: f.default.locale,
                        media_format: b.Z.getSelectedFormat()
                    },
                    oldFormErrors: !0
                }).then((function(e) {
                    var t = e.body,
                        r = t.categories,
                        n = t.gifs;
                    a.Z.dispatch({
                        type: "GIF_PICKER_TRENDING_FETCH_SUCCESS",
                        trendingCategories: r,
                        trendingGIFPreview: n[0]
                    })
                }))
            }

            function A(e) {
                var t = Date.now();
                w(O.wI2.TRENDING_GIFS);
                u.Z.get({
                    url: O.ANM.GIFS_TRENDING_GIFS,
                    query: {
                        media_format: b.Z.getSelectedFormat(),
                        provider: O.Yrq.TENOR,
                        locale: f.default.locale,
                        limit: e
                    },
                    oldFormErrors: !0
                }).then((function(r) {
                    var n = r.body;
                    _(n, O.wI2.TRENDING_GIFS, {
                        startTime: t,
                        limit: e
                    });
                    a.Z.dispatch({
                        type: "GIF_PICKER_QUERY_SUCCESS",
                        items: n
                    })
                }), (function() {
                    a.Z.dispatch({
                        type: "GIF_PICKER_QUERY_FAILURE"
                    })
                }))
            }

            function M(e) {
                p.DZ.updateAsync("favoriteGifs", (function(t) {
                    var r, n = null !== (r = o().max(Object.values(t.gifs).map((function(e) {
                        return e.order
                    })))) && void 0 !== r ? r : 0;
                    t.gifs[e.url] = E(j({}, e), {
                        order: n + 1
                    });
                    if (l.wK.toBinary(t).length > v.vY) {
                        g.Z.show({
                            title: m.Z.Messages.FAVORITES_LIMIT_REACHED_TITLE,
                            body: m.Z.Messages.FAVORITE_GIFS_LIMIT_REACHED_BODY
                        });
                        return !1
                    }
                    o().size(t.gifs) > 2 && (t.hideTooltip = !0)
                }), v.fy.INFREQUENT_USER_ACTION);
                y.default.track(O.rMx.GIF_FAVORITED)
            }

            function Z(e) {
                p.DZ.updateAsync("favoriteGifs", (function(t) {
                    delete t.gifs[e]
                }), v.fy.INFREQUENT_USER_ACTION);
                y.default.track(O.rMx.GIF_UNFAVORITED)
            }
        },
        82834: (e, t, r) => {
            r.d(t, {
                Z: () => a
            });
            var n = r(785893),
                o = (r(667294),
                    r(294184)),
                i = r.n(o),
                c = r(876685),
                u = r.n(c);

            function l(e, t, r) {
                t in e ? Object.defineProperty(e, t, {
                    value: r,
                    enumerable: !0,
                    configurable: !0,
                    writable: !0
                }) : e[t] = r;
                return e
            }
            const a = function(e) {
                var t = e.message,
                    r = e.className,
                    o = e.noResultsImageURL,
                    c = e.forceLightTheme,
                    a = e.suggestions,
                    s = null != o ? {
                        backgroundImage: "url(".concat(o, ")")
                    } : {};
                return (0,
                    n.jsx)("div", {
                    className: i()(l({}, u().forceLightTheme, c), r),
                    children: (0,
                        n.jsxs)("div", {
                        className: u().wrapper,
                        children: [(0,
                            n.jsx)("div", {
                            className: u().sadImage,
                            style: s
                        }), (0,
                            n.jsx)("div", {
                            children: t
                        }), a]
                    })
                })
            }
        },
        992735: (e, t, r) => {
            r.d(t, {
                PG: () => a,
                _Q: () => s,
                j9: () => f,
                RO: () => p,
                hr: () => b,
                $2: () => y,
                ql: () => O,
                Iu: () => d
            });
            var n = r(185253),
                o = r(24029),
                i = r(272729),
                c = r(706594),
                u = Object.freeze({
                    activeView: null,
                    lastActiveView: null,
                    activeViewType: null,
                    searchQuery: "",
                    isSearchSuggestion: !1,
                    searchPlaceholder: null,
                    pickerId: (0,
                        i.hQ)()
                }),
                l = (0,
                    n.Z)((0,
                    o.tJ)((function(e, t) {
                    return u
                }), {
                    name: "expression-picker-last-active-view",
                    partialize: function(e) {
                        return {
                            lastActiveView: e.lastActiveView
                        }
                    }
                })),
                a = function(e, t) {
                    l.setState({
                        activeView: e,
                        activeViewType: t,
                        lastActiveView: l.getState().activeView
                    })
                },
                s = function(e) {
                    void 0 !== e && e !== l.getState().activeViewType || l.setState({
                        activeView: null,
                        activeViewType: null,
                        lastActiveView: l.getState().activeView
                    })
                },
                f = function(e) {
                    var t = l.getState();
                    if (null == t.activeView) {
                        var r;
                        a(null !== (r = t.lastActiveView) && void 0 !== r ? r : c.X1.EMOJI, e)
                    } else
                        s()
                },
                p = function(e, t) {
                    l.getState().activeView === e ? s() : a(e, t)
                },
                b = function(e) {
                    l.setState({
                        activeView: e,
                        lastActiveView: l.getState().activeView
                    })
                },
                y = function(e) {
                    l.setState({
                        searchPlaceholder: e
                    })
                },
                O = function(e) {
                    var t = arguments.length > 1 && void 0 !== arguments[1] && arguments[1];
                    l.setState({
                        searchQuery: e,
                        isSearchSuggestion: t
                    })
                },
                d = l
        },
        751459: (e, t, r) => {
            r.d(t, {
                gG: () => s,
                HI: () => f,
                hb: () => p
            });
            var n = r(667294),
                o = r(496486),
                i = r.n(o),
                c = r(332051);

            function u(e, t, r) {
                t in e ? Object.defineProperty(e, t, {
                    value: r,
                    enumerable: !0,
                    configurable: !0,
                    writable: !0
                }) : e[t] = r;
                return e
            }

            function l(e, t) {
                t = null != t ? t : {};
                Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : function(e, t) {
                    var r = Object.keys(e);
                    if (Object.getOwnPropertySymbols) {
                        var n = Object.getOwnPropertySymbols(e);
                        t && (n = n.filter((function(t) {
                            return Object.getOwnPropertyDescriptor(e, t).enumerable
                        })));
                        r.push.apply(r, n)
                    }
                    return r
                }(Object(t)).forEach((function(r) {
                    Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r))
                }));
                return e
            }
            var a = {};

            function s() {
                var e, t;
                return null !== (t = null === (e = (0,
                    c.D)().favoriteGifs) || void 0 === e ? void 0 : e.gifs) && void 0 !== t ? t : a
            }

            function f() {
                var e = s();
                return n.useMemo((function() {
                    return i()(e).map((function(e, t) {
                        return l(function(e) {
                            for (var t = 1; t < arguments.length; t++) {
                                var r = null != arguments[t] ? arguments[t] : {},
                                    n = Object.keys(r);
                                "function" == typeof Object.getOwnPropertySymbols && (n = n.concat(Object.getOwnPropertySymbols(r).filter((function(e) {
                                    return Object.getOwnPropertyDescriptor(r, e).enumerable
                                }))));
                                n.forEach((function(t) {
                                    u(e, t, r[t])
                                }))
                            }
                            return e
                        }({}, e), {
                            url: t
                        })
                    })).sortBy("order").reverse().value()
                }), [e])
            }

            function p(e) {
                return null != s()[e]
            }
        },
        387736: (e, t, r) => {
            r.d(t, {
                Z: () => C
            });
            var n, o = r(785893),
                i = (r(667294),
                    r(294184)),
                c = r.n(i),
                u = r(791462),
                l = r(600075),
                a = r(666722),
                s = r(402411),
                f = r(72791),
                p = r(461061),
                b = r(233593),
                y = r.n(b);

            function O(e, t, r) {
                t in e ? Object.defineProperty(e, t, {
                    value: r,
                    enumerable: !0,
                    configurable: !0,
                    writable: !0
                }) : e[t] = r;
                return e
            }
            var d, g = (O(n = {}, p.Eu4.NONE, y().iconBackgroundTierNone),
                    O(n, p.Eu4.TIER_1, y().iconBackgroundTierOne),
                    O(n, p.Eu4.TIER_2, y().iconBackgroundTierTwo),
                    O(n, p.Eu4.TIER_3, y().iconBackgroundTierThree),
                    n),
                v = (O(d = {}, p.Eu4.NONE, y().iconTierNone),
                    O(d, p.Eu4.TIER_1, y().iconTierOne),
                    O(d, p.Eu4.TIER_2, y().iconTierTwo),
                    O(d, p.Eu4.TIER_3, y().iconTierThree),
                    d);

            function m(e) {
                var t = e.premiumTier,
                    r = e.iconBackgroundClassName,
                    n = e.iconClassName,
                    i = e.size;
                return (0,
                    o.jsx)(s.Z, {
                    className: c()(r, g[t]),
                    size: i,
                    children: (0,
                        o.jsx)(f.Z, {
                        tier: t,
                        className: c()(n, y().boostedGuildIconGem, v[t])
                    })
                })
            }
            var h = r(212218),
                j = r(859023),
                E = r(709990),
                P = r(757987),
                I = r(75141),
                w = r(959797),
                _ = r(625337),
                S = r.n(_);

            function T(e, t, r) {
                t in e ? Object.defineProperty(e, t, {
                    value: r,
                    enumerable: !0,
                    configurable: !0,
                    writable: !0
                }) : e[t] = r;
                return e
            }

            function R(e, t) {
                t = null != t ? t : {};
                Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : function(e, t) {
                    var r = Object.keys(e);
                    if (Object.getOwnPropertySymbols) {
                        var n = Object.getOwnPropertySymbols(e);
                        t && (n = n.filter((function(t) {
                            return Object.getOwnPropertyDescriptor(e, t).enumerable
                        })));
                        r.push.apply(r, n)
                    }
                    return r
                }(Object(t)).forEach((function(r) {
                    Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r))
                }));
                return e
            }

            function D(e) {
                var t = e.guild,
                    r = e.isBannerVisible,
                    n = e.disableBoostClick,
                    i = (0,
                        u.e7)([j.default, h.ZP], (function() {
                        var e = j.default.getCurrentUser();
                        return h.ZP.isMember(t.id, null == e ? void 0 : e.id)
                    })),
                    c = t.premiumTier,
                    s = t.premiumSubscriberCount;
                if (0 === s && c === p.Eu4.NONE)
                    return null;
                var f = function(e) {
                        e.stopPropagation();
                        e.preventDefault();
                        i && !n && (0,
                            a.f)({
                            guildId: t.id,
                            location: {
                                section: p.jXE.GUILD_HEADER,
                                object: p.qAy.BOOST_GEM_ICON
                            }
                        })
                    },
                    b = c === p.Eu4.NONE ? w.Z.Messages.PREMIUM_GUILD_HEADER_BADGE_NO_TIER : I.nW(c),
                    y = (0,
                        o.jsxs)(o.Fragment, {
                        children: [(0,
                            o.jsx)("div", {
                            className: S().tierTooltipTitle,
                            children: b
                        }), (0,
                            o.jsx)("div", {
                            children: w.Z.Messages.PREMIUM_GUILD_SUBSCRIPTION_SUBSCRIBER_COUNT_TOOLTIP.format({
                                subscriberCount: s
                            })
                        })]
                    });
                return (0,
                    o.jsx)("div", {
                    className: S().guildIconContainer,
                    children: (0,
                        o.jsx)(P.ZP, {
                        text: y,
                        position: P.ZP.Positions.BOTTOM,
                        "aria-label": null != b ? b : "",
                        children: function(e) {
                            return (0,
                                o.jsx)(l.P3, R(function(e) {
                                for (var t = 1; t < arguments.length; t++) {
                                    var r = null != arguments[t] ? arguments[t] : {},
                                        n = Object.keys(r);
                                    "function" == typeof Object.getOwnPropertySymbols && (n = n.concat(Object.getOwnPropertySymbols(r).filter((function(e) {
                                        return Object.getOwnPropertyDescriptor(r, e).enumerable
                                    }))));
                                    n.forEach((function(t) {
                                        T(e, t, r[t])
                                    }))
                                }
                                return e
                            }({}, e), {
                                className: S().premiumGuildIcon,
                                onClick: f,
                                children: (0,
                                    o.jsx)(m, {
                                    premiumTier: c,
                                    iconBackgroundClassName: r ? S().boostedGuildTierIconBackgroundWithVisibleBanner : null,
                                    iconClassName: r && c !== p.Eu4.TIER_3 ? S().boostedGuildTierMutedIconWithVisibleBanner : null
                                })
                            }))
                        }
                    })
                })
            }

            function N(e) {
                var t = e.guild,
                    r = e.disableColor;
                return (0,
                    o.jsx)("div", {
                    className: S().guildIconContainer,
                    children: (0,
                        o.jsx)(E.Z, {
                        guild: t,
                        tooltipPosition: P.ZP.Positions.BOTTOM,
                        tooltipColor: P.ZP.Colors.PRIMARY,
                        className: c()(S().guildBadge, T({}, S().disableColor, r))
                    })
                })
            }

            function C(e) {
                var t = e.guild,
                    r = e.isBannerVisible,
                    n = e.disableBoostClick;
                return t.hasFeature(p.oNc.VERIFIED) || t.hasFeature(p.oNc.PARTNERED) ? (0,
                    o.jsx)(N, {
                    guild: t,
                    disableColor: !r
                }) : (0,
                    o.jsx)(D, {
                    guild: t,
                    isBannerVisible: r,
                    disableBoostClick: n
                })
            }
        },
        495729: (e, t, r) => {
            r.d(t, {
                Z: () => WHERE_IS_IT_CALLED
            });
            var n = r(785893),
                o = r(667294),
                i = r(294184),
                c = r.n(i),
                u = r(600075),
                l = r(777552),
                a = r(751459),
                s = r(757987),
                f = r(810860),
                p = r(934517),
                b = r(882699),
                y = r(461061),
                O = r(959797),
                d = r(264538),
                g = r.n(d);

            function v(e, t) {
                (null == t || t > e.length) && (t = e.length);
                for (var r = 0, n = new Array(t); r < t; r++)
                    n[r] = e[r];
                return n
            }

            function m(e, t, r) {
                t in e ? Object.defineProperty(e, t, {
                    value: r,
                    enumerable: !0,
                    configurable: !0,
                    writable: !0
                }) : e[t] = r;
                return e
            }

            function h(e, t) {
                t = null != t ? t : {};
                Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : function(e, t) {
                    var r = Object.keys(e);
                    if (Object.getOwnPropertySymbols) {
                        var n = Object.getOwnPropertySymbols(e);
                        t && (n = n.filter((function(t) {
                            return Object.getOwnPropertyDescriptor(e, t).enumerable
                        })));
                        r.push.apply(r, n)
                    }
                    return r
                }(Object(t)).forEach((function(r) {
                    Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r))
                }));
                return e
            }

            function j(e, t) {
                return function(e) {
                    if (Array.isArray(e))
                        return e
                }(e) || function(e, t) {
                    var r = null == e ? null : "undefined" != typeof Symbol && e[Symbol.iterator] || e["@@iterator"];
                    if (null != r) {
                        var n, o, i = [],
                            c = !0,
                            u = !1;
                        try {
                            for (r = r.call(e); !(c = (n = r.next()).done); c = !0) {
                                i.push(n.value);
                                if (t && i.length === t)
                                    break
                            }
                        } catch (e) {
                            u = !0;
                            o = e
                        } finally {
                            try {
                                c || null == r.return || r.return()
                            } finally {
                                if (u)
                                    throw o
                            }
                        }
                        return i
                    }
                }(e, t) || function(e, t) {
                    if (!e)
                        return;
                    if ("string" == typeof e)
                        return v(e, t);
                    var r = Object.prototype.toString.call(e).slice(8, -1);
                    "Object" === r && e.constructor && (r = e.constructor.name);
                    if ("Map" === r || "Set" === r)
                        return Array.from(r);
                    if ("Arguments" === r || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(r))
                        return v(e, t)
                }(e, t) || function() {
                    throw new TypeError("Invalid attempt to destructure non-iterable instance.\\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")
                }()
            }
            const WHERE_IS_IT_CALLED = o.memo((function(e) {
                var t = e.width,
                    r = e.height,
                    i = e.src,
                    d = e.url,
                    v = e.format,
                    E = e.className,
                    P = j(o.useState(!1), 2),
                    I = P[0],
                    w = P[1],
                    _ = (0,
                        a.hb)(d),
                    S = _ ? O.Z.Messages.GIF_TOOLTIP_REMOVE_FROM_FAVORITES : O.Z.Messages.GIF_TOOLTIP_ADD_TO_FAVORITES,
                    T = _ ? p.Z : f.Z;
                o.useEffect((function() {
                    if (I) {
                        var e = setTimeout((function() {
                            w(!1)
                        }), 500);
                        return function() {
                            return clearTimeout(e)
                        }
                    }
                }), [I]);
                var R = function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    w(!0);
                    if (_)
                        (0,
                            l.PF)(d);
                    else {
                        (0,
                            l.uL)({
                            url: d,
                            src: i,
                            width: t,
                            height: r,
                            format: v
                        });
                        b.S.dispatch(y.CkL.FAVORITE_GIF)
                    }
                };
                return (0,
                    n.jsx)(s.ZP, {
                    text: S,
                    children: function(e) {
                        var t;
                        return (0,
                            n.jsx)(u.P3, h(function(e) {
                            for (var t = 1; t < arguments.length; t++) {
                                var r = null != arguments[t] ? arguments[t] : {},
                                    n = Object.keys(r);
                                "function" == typeof Object.getOwnPropertySymbols && (n = n.concat(Object.getOwnPropertySymbols(r).filter((function(e) {
                                    return Object.getOwnPropertyDescriptor(r, e).enumerable
                                }))));
                                n.forEach((function(t) {
                                    m(e, t, r[t])
                                }))
                            }
                            return e
                        }({}, e), {
                            className: c()(E, g().size, g().gifFavoriteButton, (t = {},
                                m(t, g().selected, _),
                                m(t, g().showPulse, I),
                                t)),
                            onMouseDown: function(e) {
                                return e.preventDefault()
                            },
                            onClick: R,
                            onDoubleClick: function(e) {
                                return e.preventDefault()
                            },
                            children: (0,
                                n.jsx)(T, {
                                className: g().icon
                            })
                        }))
                    }
                })
            }))
        },
        718862: (e, t, r) => {
            r.d(t, {
                Z: () => N
            });
            var n = r(791462),
                o = r(200637),
                i = r(173436),
                c = r(924987),
                u = r(461061),
                l = r(959797);

            function a(e, t) {
                (null == t || t > e.length) && (t = e.length);
                for (var r = 0, n = new Array(t); r < t; r++)
                    n[r] = e[r];
                return n
            }

            function s(e, t) {
                if (!(e instanceof t))
                    throw new TypeError("Cannot call a class as a function")
            }

            function f(e, t, r) {
                t in e ? Object.defineProperty(e, t, {
                    value: r,
                    enumerable: !0,
                    configurable: !0,
                    writable: !0
                }) : e[t] = r;
                return e
            }

            function p(e) {
                p = Object.setPrototypeOf ? Object.getPrototypeOf : function(e) {
                    return e.__proto__ || Object.getPrototypeOf(e)
                };
                return p(e)
            }

            function b(e, t) {
                t = null != t ? t : {};
                Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : function(e, t) {
                    var r = Object.keys(e);
                    if (Object.getOwnPropertySymbols) {
                        var n = Object.getOwnPropertySymbols(e);
                        t && (n = n.filter((function(t) {
                            return Object.getOwnPropertyDescriptor(e, t).enumerable
                        })));
                        r.push.apply(r, n)
                    }
                    return r
                }(Object(t)).forEach((function(r) {
                    Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r))
                }));
                return e
            }

            function y(e, t) {
                return !t || "object" !== g(t) && "function" != typeof t ? function(e) {
                    if (void 0 === e)
                        throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
                    return e
                }(e) : t
            }

            function O(e, t) {
                O = Object.setPrototypeOf || function(e, t) {
                    e.__proto__ = t;
                    return e
                };
                return O(e, t)
            }

            function d(e) {
                return function(e) {
                    if (Array.isArray(e))
                        return a(e)
                }(e) || function(e) {
                    if ("undefined" != typeof Symbol && null != e[Symbol.iterator] || null != e["@@iterator"])
                        return Array.from(e)
                }(e) || function(e, t) {
                    if (!e)
                        return;
                    if ("string" == typeof e)
                        return a(e, t);
                    var r = Object.prototype.toString.call(e).slice(8, -1);
                    "Object" === r && e.constructor && (r = e.constructor.name);
                    if ("Map" === r || "Set" === r)
                        return Array.from(r);
                    if ("Arguments" === r || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(r))
                        return a(e, t)
                }(e) || function() {
                    throw new TypeError("Invalid attempt to spread non-iterable instance.\\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")
                }()
            }
            var g = function(e) {
                return e && "undefined" != typeof Symbol && e.constructor === Symbol ? "symbol" : typeof e
            };

            function v(e) {
                var t = function() {
                    if ("undefined" == typeof Reflect || !Reflect.construct)
                        return !1;
                    if (Reflect.construct.sham)
                        return !1;
                    if ("function" == typeof Proxy)
                        return !0;
                    try {
                        Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], (function() {})));
                        return !0
                    } catch (e) {
                        return !1
                    }
                }();
                return function() {
                    var r, n = p(e);
                    if (t) {
                        var o = p(this).constructor;
                        r = Reflect.construct(n, arguments, o)
                    } else
                        r = n.apply(this, arguments);
                    return y(this, r)
                }
            }
            var m = u.uYc.MP4,
                h = null,
                j = "",
                E = "",
                P = [],
                I = [],
                w = m,
                _ = [],
                S = [];

            function T(e) {
                switch (e) {
                    case u.Njw.FIXED_HEIGHT_MP4:
                    case u.Njw.FIXED_HEIGHT_SMALL_MP4:
                    case u.Njw.FIXED_WIDTH_MP4:
                    case u.Njw.FIXED_WIDTH_SMALL_MP4:
                    case u.Njw.DOWNSIZED_SMALL_MP4:
                    case u.Njw.ORIGINAL_MP4:
                    case u.uYc.MP4:
                    case u.uYc.TINYMP4:
                    case u.uYc.NANOMP4:
                    case u.uYc.WEBM:
                    case u.uYc.TINYWEBM:
                    case u.uYc.NANOWEBM:
                        return !0;
                    default:
                        return !1
                }
            }

            function R(e) {
                return e.replace(/^https?:/, "")
            }
            var D = function(e) {
                ! function(e, t) {
                    if ("function" != typeof t && null !== t)
                        throw new TypeError("Super expression must either be null or a function");
                    e.prototype = Object.create(t && t.prototype, {
                        constructor: {
                            value: e,
                            writable: !0,
                            configurable: !0
                        }
                    });
                    t && O(e, t)
                }(r, e);
                var t = v(r);

                function r() {
                    s(this, r);
                    return t.apply(this, arguments)
                }
                var n = r.prototype;
                n.getAnalyticsID = function() {
                    return h
                };
                n.getQuery = function() {
                    return j
                };
                n.getResultQuery = function() {
                    return E
                };
                n.getResultItems = function() {
                    return P
                };
                n.getTrendingCategories = function() {
                    return I
                };
                n.getSelectedFormat = function() {
                    return w
                };
                n.getSuggestions = function() {
                    return _
                };
                n.getTrendingSearchTerms = function() {
                    return S
                };
                n.__getLocalVars = function() {
                    return {
                        TENOR_FORMAT: m,
                        analyticsID: h,
                        query: j,
                        resultQuery: E,
                        resultItems: P,
                        trendingCategories: I,
                        selectedFormat: w,
                        suggestions: _,
                        trendingSearchTerms: S
                    }
                };
                return r
            }(n.ZP.Store);
            D.displayName = "GIFPickerViewStore";
            const N = new D(i.Z, {
                GIF_PICKER_INITIALIZE: function(e) {
                    h = e.analyticsID
                },
                GIF_PICKER_QUERY: function(e) {
                    if ("" === (j = e.query)) {
                        E = "";
                        P = [];
                        _ = []
                    }
                },
                GIF_PICKER_QUERY_SUCCESS: function(e) {
                    if (null != e.query && j === E)
                        return !1;
                    null != e.query && (E = e.query);
                    P = e.items.map((function(e) {
                        var t = e.width,
                            r = e.height,
                            n = e.src,
                            i = e.gif_src,
                            c = e.url,
                            u = e.id;
                        return {
                            width: t,
                            height: r,
                            src: R(n),
                            gifSrc: R(i),
                            url: c,
                            id: u,
                            format: T(w) ? o.EO.VIDEO : o.EO.IMAGE
                        }
                    }))
                },
                GIF_PICKER_QUERY_FAILURE: function(e) {
                    var t = e.query;
                    if (null == t)
                        return !1;
                    E = t;
                    P = []
                },
                GIF_PICKER_TRENDING_FETCH_SUCCESS: function(e) {
                    var t = e.trendingCategories,
                        r = null != e.trendingGIFPreview ? [{
                            type: u.wI2.TRENDING_GIFS,
                            icon: c.Z,
                            name: l.Z.Messages.GIF_PICKER_RESULT_TYPE_TRENDING_GIFS,
                            src: R(e.trendingGIFPreview.src),
                            format: o.EO.IMAGE
                        }] : [];
                    I = d(r).concat(d(t.map((function(e) {
                        return b(function(e) {
                            for (var t = 1; t < arguments.length; t++) {
                                var r = null != arguments[t] ? arguments[t] : {},
                                    n = Object.keys(r);
                                "function" == typeof Object.getOwnPropertySymbols && (n = n.concat(Object.getOwnPropertySymbols(r).filter((function(e) {
                                    return Object.getOwnPropertyDescriptor(r, e).enumerable
                                }))));
                                n.forEach((function(t) {
                                    f(e, t, r[t])
                                }))
                            }
                            return e
                        }({}, e), {
                            src: R(e.src),
                            type: u.wI2.TRENDING_CATEGORY,
                            format: o.EO.VIDEO
                        })
                    }))))
                },
                GIF_PICKER_SUGGESTIONS_SUCCESS: function(e) {
                    var t = e.items;
                    _ = t
                },
                GIF_PICKER_TRENDING_SEARCH_TERMS_SUCCESS: function(e) {
                    var t = e.items;
                    S = t
                }
            })
        },
        810860: (e, t, r) => {
            r.d(t, {
                Z: () => l
            });
            var n = r(785893),
                o = (r(667294),
                    r(240243));

            function i(e, t, r) {
                t in e ? Object.defineProperty(e, t, {
                    value: r,
                    enumerable: !0,
                    configurable: !0,
                    writable: !0
                }) : e[t] = r;
                return e
            }

            function c(e, t) {
                t = null != t ? t : {};
                Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : function(e, t) {
                    var r = Object.keys(e);
                    if (Object.getOwnPropertySymbols) {
                        var n = Object.getOwnPropertySymbols(e);
                        t && (n = n.filter((function(t) {
                            return Object.getOwnPropertyDescriptor(e, t).enumerable
                        })));
                        r.push.apply(r, n)
                    }
                    return r
                }(Object(t)).forEach((function(r) {
                    Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r))
                }));
                return e
            }

            function u(e, t) {
                if (null == e)
                    return {};
                var r, n, o = function(e, t) {
                    if (null == e)
                        return {};
                    var r, n, o = {},
                        i = Object.keys(e);
                    for (n = 0; n < i.length; n++) {
                        r = i[n];
                        t.indexOf(r) >= 0 || (o[r] = e[r])
                    }
                    return o
                }(e, t);
                if (Object.getOwnPropertySymbols) {
                    var i = Object.getOwnPropertySymbols(e);
                    for (n = 0; n < i.length; n++) {
                        r = i[n];
                        t.indexOf(r) >= 0 || Object.prototype.propertyIsEnumerable.call(e, r) && (o[r] = e[r])
                    }
                }
                return o
            }

            function l(e) {
                var t = e.width,
                    r = void 0 === t ? 16 : t,
                    l = e.height,
                    a = void 0 === l ? 16 : l,
                    s = e.color,
                    f = void 0 === s ? "currentColor" : s,
                    p = e.foreground,
                    b = u(e, ["width", "height", "color", "foreground"]);
                return (0,
                    n.jsx)("svg", c(function(e) {
                    for (var t = 1; t < arguments.length; t++) {
                        var r = null != arguments[t] ? arguments[t] : {},
                            n = Object.keys(r);
                        "function" == typeof Object.getOwnPropertySymbols && (n = n.concat(Object.getOwnPropertySymbols(r).filter((function(e) {
                            return Object.getOwnPropertyDescriptor(r, e).enumerable
                        }))));
                        n.forEach((function(t) {
                            i(e, t, r[t])
                        }))
                    }
                    return e
                }({}, (0,
                    o.Z)(b)), {
                    width: r,
                    height: a,
                    viewBox: "0 0 24 24",
                    children: (0,
                        n.jsx)("path", {
                        className: p,
                        fill: f,
                        d: "M19.6,9l-4.2-0.4c-0.4,0-0.7-0.3-0.8-0.6l-1.6-3.9c-0.3-0.8-1.5-0.8-1.8,0L9.4,8.1C9.3,8.4,9,8.6,8.6,8.7L4.4,9 c-0.9,0.1-1.2,1.2-0.6,1.8L7,13.6c0.3,0.2,0.4,0.6,0.3,1l-1,4.1c-0.2,0.9,0.7,1.5,1.5,1.1l3.6-2.2c0.3-0.2,0.7-0.2,1,0l3.6,2.2 c0.8,0.5,1.7-0.2,1.5-1.1l-1-4.1c-0.1-0.4,0-0.7,0.3-1l3.2-2.8C20.9,10.2,20.5,9.1,19.6,9z M12,15.4l-3.8,2.3l1-4.3l-3.3-2.9 l4.4-0.4l1.7-4l1.7,4l4.4,0.4l-3.3,2.9l1,4.3L12,15.4z"
                    })
                }))
            }
        },
        934517: (e, t, r) => {
            r.d(t, {
                Z: () => l
            });
            var n = r(785893),
                o = (r(667294),
                    r(240243));

            function i(e, t, r) {
                t in e ? Object.defineProperty(e, t, {
                    value: r,
                    enumerable: !0,
                    configurable: !0,
                    writable: !0
                }) : e[t] = r;
                return e
            }

            function c(e, t) {
                t = null != t ? t : {};
                Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : function(e, t) {
                    var r = Object.keys(e);
                    if (Object.getOwnPropertySymbols) {
                        var n = Object.getOwnPropertySymbols(e);
                        t && (n = n.filter((function(t) {
                            return Object.getOwnPropertyDescriptor(e, t).enumerable
                        })));
                        r.push.apply(r, n)
                    }
                    return r
                }(Object(t)).forEach((function(r) {
                    Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r))
                }));
                return e
            }

            function u(e, t) {
                if (null == e)
                    return {};
                var r, n, o = function(e, t) {
                    if (null == e)
                        return {};
                    var r, n, o = {},
                        i = Object.keys(e);
                    for (n = 0; n < i.length; n++) {
                        r = i[n];
                        t.indexOf(r) >= 0 || (o[r] = e[r])
                    }
                    return o
                }(e, t);
                if (Object.getOwnPropertySymbols) {
                    var i = Object.getOwnPropertySymbols(e);
                    for (n = 0; n < i.length; n++) {
                        r = i[n];
                        t.indexOf(r) >= 0 || Object.prototype.propertyIsEnumerable.call(e, r) && (o[r] = e[r])
                    }
                }
                return o
            }

            function l(e) {
                var t = e.width,
                    r = void 0 === t ? 16 : t,
                    l = e.height,
                    a = void 0 === l ? 16 : l,
                    s = e.color,
                    f = void 0 === s ? "currentColor" : s,
                    p = e.foreground,
                    b = u(e, ["width", "height", "color", "foreground"]);
                return (0,
                    n.jsxs)("svg", c(function(e) {
                    for (var t = 1; t < arguments.length; t++) {
                        var r = null != arguments[t] ? arguments[t] : {},
                            n = Object.keys(r);
                        "function" == typeof Object.getOwnPropertySymbols && (n = n.concat(Object.getOwnPropertySymbols(r).filter((function(e) {
                            return Object.getOwnPropertyDescriptor(r, e).enumerable
                        }))));
                        n.forEach((function(t) {
                            i(e, t, r[t])
                        }))
                    }
                    return e
                }({}, (0,
                    o.Z)(b)), {
                    viewBox: "0 0 24 24",
                    width: r,
                    height: a,
                    children: [(0,
                        n.jsx)("path", {
                        d: "M0,0H24V24H0Z",
                        fill: "none"
                    }), (0,
                        n.jsx)("path", {
                        fill: f,
                        className: p,
                        d: "M12.5,17.6l3.6,2.2a1,1,0,0,0,1.5-1.1l-1-4.1a1,1,0,0,1,.3-1l3.2-2.8A1,1,0,0,0,19.5,9l-4.2-.4a.87.87,0,0,1-.8-.6L12.9,4.1a1.05,1.05,0,0,0-1.9,0l-1.6,4a1,1,0,0,1-.8.6L4.4,9a1.06,1.06,0,0,0-.6,1.8L7,13.6a.91.91,0,0,1,.3,1l-1,4.1a1,1,0,0,0,1.5,1.1l3.6-2.2A1.08,1.08,0,0,1,12.5,17.6Z"
                    })]
                }))
            }
        },
        924987: (e, t, r) => {
            r.d(t, {
                Z: () => l
            });
            var n = r(785893),
                o = (r(667294),
                    r(240243));

            function i(e, t, r) {
                t in e ? Object.defineProperty(e, t, {
                    value: r,
                    enumerable: !0,
                    configurable: !0,
                    writable: !0
                }) : e[t] = r;
                return e
            }

            function c(e, t) {
                t = null != t ? t : {};
                Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : function(e, t) {
                    var r = Object.keys(e);
                    if (Object.getOwnPropertySymbols) {
                        var n = Object.getOwnPropertySymbols(e);
                        t && (n = n.filter((function(t) {
                            return Object.getOwnPropertyDescriptor(e, t).enumerable
                        })));
                        r.push.apply(r, n)
                    }
                    return r
                }(Object(t)).forEach((function(r) {
                    Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r))
                }));
                return e
            }

            function u(e, t) {
                if (null == e)
                    return {};
                var r, n, o = function(e, t) {
                    if (null == e)
                        return {};
                    var r, n, o = {},
                        i = Object.keys(e);
                    for (n = 0; n < i.length; n++) {
                        r = i[n];
                        t.indexOf(r) >= 0 || (o[r] = e[r])
                    }
                    return o
                }(e, t);
                if (Object.getOwnPropertySymbols) {
                    var i = Object.getOwnPropertySymbols(e);
                    for (n = 0; n < i.length; n++) {
                        r = i[n];
                        t.indexOf(r) >= 0 || Object.prototype.propertyIsEnumerable.call(e, r) && (o[r] = e[r])
                    }
                }
                return o
            }

            function l(e) {
                var t = e.width,
                    r = void 0 === t ? 24 : t,
                    l = e.height,
                    a = void 0 === l ? 24 : l,
                    s = e.color,
                    f = void 0 === s ? "currentColor" : s,
                    p = e.foreground,
                    b = u(e, ["width", "height", "color", "foreground"]);
                return (0,
                    n.jsx)("svg", c(function(e) {
                    for (var t = 1; t < arguments.length; t++) {
                        var r = null != arguments[t] ? arguments[t] : {},
                            n = Object.keys(r);
                        "function" == typeof Object.getOwnPropertySymbols && (n = n.concat(Object.getOwnPropertySymbols(r).filter((function(e) {
                            return Object.getOwnPropertyDescriptor(r, e).enumerable
                        }))));
                        n.forEach((function(t) {
                            i(e, t, r[t])
                        }))
                    }
                    return e
                }({}, (0,
                    o.Z)(b)), {
                    width: r,
                    height: a,
                    viewBox: "0 0 24 24",
                    children: (0,
                        n.jsx)("g", {
                        fill: "none",
                        fillRule: "evenodd",
                        transform: "translate(2 6)",
                        children: (0,
                            n.jsx)("path", {
                            className: p,
                            fill: f,
                            d: "M14 0l2.29 2.29-4.88 4.88-4-4L0 10.59 1.41 12l6-6 4 4 6.3-6.29L20 6V0z"
                        })
                    })
                }))
            }
        }
    }
]);
//# sourceMappingURL=effe5a695154b44b5fc2.js.map