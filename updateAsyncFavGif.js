let lodash;
function M(e) {
  p.DZ.updateAsync(
    "favoriteGifs",
    (props) => {
      let something;
      let gifLen =
        null !==
          (something = lodash().max(
            Object.values(props.gifs).map(function (e) {
              return e.order;
            })
          )) && void 0 !== something
          ? something
          : 0;
      props.gifs[e.url] = E(Object.assign({}, e), {
        order: gifLen + 1,
      });
      if (l.wK.toBinary(props).length > v.vY) {
        g.Z.show({
          title: m.Z.Messages.FAVORITES_LIMIT_REACHED_TITLE,
          body: m.Z.Messages.FAVORITE_GIFS_LIMIT_REACHED_BODY,
        });
        return !1;
      }
      lodash().size(props.gifs) > 2 && (props.hideTooltip = !0);
    },
    v.fy.INFREQUENT_USER_ACTION
  );
  y.default.track(O.rMx.GIF_FAVORITED);
}
