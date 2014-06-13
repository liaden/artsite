(function() {
  var NodeTypes, ParameterMissing, Utils, defaults,
    __hasProp = {}.hasOwnProperty;

  ParameterMissing = function(message) {
    this.message = message;
  };

  ParameterMissing.prototype = new Error();

  defaults = {
    prefix: "",
    default_url_options: {}
  };

  NodeTypes = {"GROUP":1,"CAT":2,"SYMBOL":3,"OR":4,"STAR":5,"LITERAL":6,"SLASH":7,"DOT":8};

  Utils = {
    serialize: function(object, prefix) {
      var element, i, key, prop, result, s, _i, _len;

      if (prefix == null) {
        prefix = null;
      }
      if (!object) {
        return "";
      }
      if (!prefix && !(this.get_object_type(object) === "object")) {
        throw new Error("Url parameters should be a javascript hash");
      }
      if (window.jQuery) {
        result = window.jQuery.param(object);
        return (!result ? "" : result);
      }
      s = [];
      switch (this.get_object_type(object)) {
        case "array":
          for (i = _i = 0, _len = object.length; _i < _len; i = ++_i) {
            element = object[i];
            s.push(this.serialize(element, prefix + "[]"));
          }
          break;
        case "object":
          for (key in object) {
            if (!__hasProp.call(object, key)) continue;
            prop = object[key];
            if (!(prop != null)) {
              continue;
            }
            if (prefix != null) {
              key = "" + prefix + "[" + key + "]";
            }
            s.push(this.serialize(prop, key));
          }
          break;
        default:
          if (object) {
            s.push("" + (encodeURIComponent(prefix.toString())) + "=" + (encodeURIComponent(object.toString())));
          }
      }
      if (!s.length) {
        return "";
      }
      return s.join("&");
    },
    clean_path: function(path) {
      var last_index;

      path = path.split("://");
      last_index = path.length - 1;
      path[last_index] = path[last_index].replace(/\/+/g, "/");
      return path.join("://");
    },
    set_default_url_options: function(optional_parts, options) {
      var i, part, _i, _len, _results;

      _results = [];
      for (i = _i = 0, _len = optional_parts.length; _i < _len; i = ++_i) {
        part = optional_parts[i];
        if (!options.hasOwnProperty(part) && defaults.default_url_options.hasOwnProperty(part)) {
          _results.push(options[part] = defaults.default_url_options[part]);
        }
      }
      return _results;
    },
    extract_anchor: function(options) {
      var anchor;

      anchor = "";
      if (options.hasOwnProperty("anchor")) {
        anchor = "#" + options.anchor;
        delete options.anchor;
      }
      return anchor;
    },
    extract_options: function(number_of_params, args) {
      var last_el;

      last_el = args[args.length - 1];
      if (args.length > number_of_params || ((last_el != null) && "object" === this.get_object_type(last_el) && !this.look_like_serialized_model(last_el))) {
        return args.pop();
      } else {
        return {};
      }
    },
    look_like_serialized_model: function(object) {
      return "id" in object || "to_param" in object;
    },
    path_identifier: function(object) {
      var property;

      if (object === 0) {
        return "0";
      }
      if (!object) {
        return "";
      }
      property = object;
      if (this.get_object_type(object) === "object") {
        if ("to_param" in object) {
          property = object.to_param;
        } else if ("id" in object) {
          property = object.id;
        } else {
          property = object;
        }
        if (this.get_object_type(property) === "function") {
          property = property.call(object);
        }
      }
      return property.toString();
    },
    clone: function(obj) {
      var attr, copy, key;

      if ((obj == null) || "object" !== this.get_object_type(obj)) {
        return obj;
      }
      copy = obj.constructor();
      for (key in obj) {
        if (!__hasProp.call(obj, key)) continue;
        attr = obj[key];
        copy[key] = attr;
      }
      return copy;
    },
    prepare_parameters: function(required_parameters, actual_parameters, options) {
      var i, result, val, _i, _len;

      result = this.clone(options) || {};
      for (i = _i = 0, _len = required_parameters.length; _i < _len; i = ++_i) {
        val = required_parameters[i];
        if (i < actual_parameters.length) {
          result[val] = actual_parameters[i];
        }
      }
      return result;
    },
    build_path: function(required_parameters, optional_parts, route, args) {
      var anchor, opts, parameters, result, url, url_params;

      args = Array.prototype.slice.call(args);
      opts = this.extract_options(required_parameters.length, args);
      if (args.length > required_parameters.length) {
        throw new Error("Too many parameters provided for path");
      }
      parameters = this.prepare_parameters(required_parameters, args, opts);
      this.set_default_url_options(optional_parts, parameters);
      anchor = this.extract_anchor(parameters);
      result = "" + (this.get_prefix()) + (this.visit(route, parameters));
      url = Utils.clean_path("" + result);
      if ((url_params = this.serialize(parameters)).length) {
        url += "?" + url_params;
      }
      url += anchor;
      return url;
    },
    visit: function(route, parameters, optional) {
      var left, left_part, right, right_part, type, value;

      if (optional == null) {
        optional = false;
      }
      type = route[0], left = route[1], right = route[2];
      switch (type) {
        case NodeTypes.GROUP:
          return this.visit(left, parameters, true);
        case NodeTypes.STAR:
          return this.visit_globbing(left, parameters, true);
        case NodeTypes.LITERAL:
        case NodeTypes.SLASH:
        case NodeTypes.DOT:
          return left;
        case NodeTypes.CAT:
          left_part = this.visit(left, parameters, optional);
          right_part = this.visit(right, parameters, optional);
          if (optional && !(left_part && right_part)) {
            return "";
          }
          return "" + left_part + right_part;
        case NodeTypes.SYMBOL:
          value = parameters[left];
          if (value != null) {
            delete parameters[left];
            return this.path_identifier(value);
          }
          if (optional) {
            return "";
          } else {
            throw new ParameterMissing("Route parameter missing: " + left);
          }
          break;
        default:
          throw new Error("Unknown Rails node type");
      }
    },
    visit_globbing: function(route, parameters, optional) {
      var left, right, type, value;

      type = route[0], left = route[1], right = route[2];
      if (left.replace(/^\*/i, "") !== left) {
        route[1] = left = left.replace(/^\*/i, "");
      }
      value = parameters[left];
      if (value == null) {
        return this.visit(route, parameters, optional);
      }
      parameters[left] = (function() {
        switch (this.get_object_type(value)) {
          case "array":
            return value.join("/");
          default:
            return value;
        }
      }).call(this);
      return this.visit(route, parameters, optional);
    },
    get_prefix: function() {
      var prefix;

      prefix = defaults.prefix;
      if (prefix !== "") {
        prefix = (prefix.match("/$") ? prefix : "" + prefix + "/");
      }
      return prefix;
    },
    _classToTypeCache: null,
    _classToType: function() {
      var name, _i, _len, _ref;

      if (this._classToTypeCache != null) {
        return this._classToTypeCache;
      }
      this._classToTypeCache = {};
      _ref = "Boolean Number String Function Array Date RegExp Object Error".split(" ");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        this._classToTypeCache["[object " + name + "]"] = name.toLowerCase();
      }
      return this._classToTypeCache;
    },
    get_object_type: function(obj) {
      if (window.jQuery && (window.jQuery.type != null)) {
        return window.jQuery.type(obj);
      }
      if (obj == null) {
        return "" + obj;
      }
      if (typeof obj === "object" || typeof obj === "function") {
        return this._classToType()[Object.prototype.toString.call(obj)] || "object";
      } else {
        return typeof obj;
      }
    },
    namespace: function(root, namespaceString) {
      var current, parts;

      parts = (namespaceString ? namespaceString.split(".") : []);
      if (!parts.length) {
        return;
      }
      current = parts.shift();
      root[current] = root[current] || {};
      return Utils.namespace(root[current], parts.join("."));
    }
  };

  Utils.namespace(window, "Routes");

  window.Routes = {
// admin_artwork => /admin/artworks/:id(.:format)
  admin_artwork_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"artworks",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// admin_artworks => /admin/artworks(.:format)
  admin_artworks_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"artworks",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// admin_comment => /admin/comments/:id(.:format)
  admin_comment_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"comments",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// admin_comments => /admin/comments(.:format)
  admin_comments_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"comments",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// admin_controls => /main/admin_controls(.:format)
  admin_controls_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"main",false]],[7,"/",false]],[6,"admin_controls",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// admin_dashboard => /admin/dashboard(.:format)
  admin_dashboard_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"dashboard",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// admin_print => /admin/prints/:id(.:format)
  admin_print_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"prints",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// admin_prints => /admin/prints(.:format)
  admin_prints_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"prints",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// admin_root => /admin(.:format)
  admin_root_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"admin",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// admin_show => /admin/shows/:id(.:format)
  admin_show_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"shows",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// admin_shows => /admin/shows(.:format)
  admin_shows_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"shows",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// artwork => /artworks/:id(.:format)
  artwork_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"artworks",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// artwork_print => /artworks/:artwork_id/prints/:id(.:format)
  artwork_print_path: function(_artwork_id, _id, options) {
  return Utils.build_path(["artwork_id","id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"artworks",false]],[7,"/",false]],[3,"artwork_id",false]],[7,"/",false]],[6,"prints",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// artwork_prints => /artworks/:artwork_id/prints(.:format)
  artwork_prints_path: function(_artwork_id, options) {
  return Utils.build_path(["artwork_id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"artworks",false]],[7,"/",false]],[3,"artwork_id",false]],[7,"/",false]],[6,"prints",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// artworks => /artworks(.:format)
  artworks_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"artworks",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// artworks_by_category => /artworks/filter/:category(.:format)
  artworks_by_category_path: function(_category, options) {
  return Utils.build_path(["category"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"artworks",false]],[7,"/",false]],[6,"filter",false]],[7,"/",false]],[3,"category",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// batch_action_admin_artworks => /admin/artworks/batch_action(.:format)
  batch_action_admin_artworks_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"artworks",false]],[7,"/",false]],[6,"batch_action",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// batch_action_admin_comments => /admin/comments/batch_action(.:format)
  batch_action_admin_comments_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"comments",false]],[7,"/",false]],[6,"batch_action",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// batch_action_admin_prints => /admin/prints/batch_action(.:format)
  batch_action_admin_prints_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"prints",false]],[7,"/",false]],[6,"batch_action",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// batch_action_admin_shows => /admin/shows/batch_action(.:format)
  batch_action_admin_shows_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"shows",false]],[7,"/",false]],[6,"batch_action",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// batch_action_comments => /comments/batch_action(.:format)
  batch_action_comments_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"comments",false]],[7,"/",false]],[6,"batch_action",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// canvas_artwork_prints => /artworks/:artwork_id/prints/canvas(.:format)
  canvas_artwork_prints_path: function(_artwork_id, options) {
  return Utils.build_path(["artwork_id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"artworks",false]],[7,"/",false]],[3,"artwork_id",false]],[7,"/",false]],[6,"prints",false]],[7,"/",false]],[6,"canvas",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// cart => /cart(.:format)
  cart_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"cart",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// checkout => /cart/checkout(.:format)
  checkout_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"cart",false]],[7,"/",false]],[6,"checkout",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// clear_orphans_tags => /tags/clear_orphans(.:format)
  clear_orphans_tags_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"tags",false]],[7,"/",false]],[6,"clear_orphans",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// comment => /comments/:id(.:format)
  comment_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"comments",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// comments => /comments(.:format)
  comments_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"comments",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// commission => /commissions/:id(.:format)
  commission_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"commissions",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// commissions => /commissions(.:format)
  commissions_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"commissions",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_admin_artwork => /admin/artworks/:id/edit(.:format)
  edit_admin_artwork_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"artworks",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_admin_print => /admin/prints/:id/edit(.:format)
  edit_admin_print_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"prints",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_admin_show => /admin/shows/:id/edit(.:format)
  edit_admin_show_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"shows",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_artwork => /artworks/:id/edit(.:format)
  edit_artwork_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"artworks",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_artwork_print => /artworks/:artwork_id/prints/:id/edit(.:format)
  edit_artwork_print_path: function(_artwork_id, _id, options) {
  return Utils.build_path(["artwork_id","id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"artworks",false]],[7,"/",false]],[3,"artwork_id",false]],[7,"/",false]],[6,"prints",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_commission => /commissions/:id/edit(.:format)
  edit_commission_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"commissions",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_idea => /ideas/:id/edit(.:format)
  edit_idea_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"ideas",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_lesson => /classes/:id/edit(.:format)
  edit_lesson_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"classes",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_medium => /medium/:id/edit(.:format)
  edit_medium_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"medium",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_page => /pages/:id/edit(.:format)
  edit_page_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"pages",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_show => /shows/:id/edit(.:format)
  edit_show_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"shows",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_supply => /supplies/:id/edit(.:format)
  edit_supply_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"supplies",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_tag => /tags/:id/edit(.:format)
  edit_tag_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"tags",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_user => /users/:id/edit(.:format)
  edit_user_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"users",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_user_session => /user_sessions/:id/edit(.:format)
  edit_user_session_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"user_sessions",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// home => /index(.:format)
  home_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"index",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// idea => /ideas/:id(.:format)
  idea_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"ideas",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// ideas => /ideas(.:format)
  ideas_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"ideas",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// inventory => /inventory(.:format)
  inventory_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"inventory",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// inventory_edit => /inventory/edit/:id(.:format)
  inventory_edit_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"inventory",false]],[7,"/",false]],[6,"edit",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// inventory_update => /inventory/update/:id(.:format)
  inventory_update_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"inventory",false]],[7,"/",false]],[6,"update",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// lesson => /classes/:id(.:format)
  lesson_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"classes",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// lessons => /classes(.:format)
  lessons_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"classes",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// login => /login(.:format)
  login_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"login",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// logout => /logout(.:format)
  logout_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"logout",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// medium => /medium/:id(.:format)
  medium_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"medium",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// medium_index => /medium(.:format)
  medium_index_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"medium",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_admin_artwork => /admin/artworks/new(.:format)
  new_admin_artwork_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"artworks",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_admin_print => /admin/prints/new(.:format)
  new_admin_print_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"prints",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_admin_show => /admin/shows/new(.:format)
  new_admin_show_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"admin",false]],[7,"/",false]],[6,"shows",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_artwork => /artworks/new(.:format)
  new_artwork_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"artworks",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_artwork_print => /artworks/:artwork_id/prints/new(.:format)
  new_artwork_print_path: function(_artwork_id, options) {
  return Utils.build_path(["artwork_id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"artworks",false]],[7,"/",false]],[3,"artwork_id",false]],[7,"/",false]],[6,"prints",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_commission => /commissions/new(.:format)
  new_commission_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"commissions",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_idea => /ideas/new(.:format)
  new_idea_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"ideas",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_lesson => /classes/new(.:format)
  new_lesson_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"classes",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_medium => /medium/new(.:format)
  new_medium_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"medium",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_page => /pages/new(.:format)
  new_page_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"pages",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_show => /shows/new(.:format)
  new_show_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"shows",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_supply => /supplies/new(.:format)
  new_supply_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"supplies",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_tag => /tags/new(.:format)
  new_tag_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"tags",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_user => /users/new(.:format)
  new_user_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"users",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_user_session => /user_sessions/new(.:format)
  new_user_session_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"user_sessions",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// news => /news(.:format)
  news_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"news",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// original_artwork_prints => /artworks/:artwork_id/prints/original(.:format)
  original_artwork_prints_path: function(_artwork_id, options) {
  return Utils.build_path(["artwork_id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"artworks",false]],[7,"/",false]],[3,"artwork_id",false]],[7,"/",false]],[6,"prints",false]],[7,"/",false]],[6,"original",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// page => /pages/:id(.:format)
  page_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"pages",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// pages => /pages(.:format)
  pages_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"pages",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// photopaper_artwork_prints => /artworks/:artwork_id/prints/photopaper(.:format)
  photopaper_artwork_prints_path: function(_artwork_id, options) {
  return Utils.build_path(["artwork_id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"artworks",false]],[7,"/",false]],[3,"artwork_id",false]],[7,"/",false]],[6,"prints",false]],[7,"/",false]],[6,"photopaper",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// preview_markdown => /markdown/preview(.:format)
  preview_markdown_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"markdown",false]],[7,"/",false]],[6,"preview",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// price_edit => /prices/edit(.:format)
  price_edit_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"prices",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// price_update => /prices/update(.:format)
  price_update_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"prices",false]],[7,"/",false]],[6,"update",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// purchase => /cart/purchase(.:format)
  purchase_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"cart",false]],[7,"/",false]],[6,"purchase",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// purchase_history => /purchase_history(.:format)
  purchase_history_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"purchase_history",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// rails_info_properties => /rails/info/properties(.:format)
  rails_info_properties_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"rails",false]],[7,"/",false]],[6,"info",false]],[7,"/",false]],[6,"properties",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// root => /
  root_path: function(options) {
  return Utils.build_path([], [], [7,"/",false], arguments);
  },
// schedule => /schedule(.:format)
  schedule_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"schedule",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// show => /shows/:id(.:format)
  show_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"shows",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// shows => /shows(.:format)
  shows_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"shows",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// supplies => /supplies(.:format)
  supplies_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"supplies",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// supply => /supplies/:id(.:format)
  supply_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"supplies",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// tag => /tags/:id(.:format)
  tag_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"tags",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// tags => /tags(.:format)
  tags_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"tags",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// user => /users/:id(.:format)
  user_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"users",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// user_session => /user_sessions/:id(.:format)
  user_session_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"user_sessions",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// user_sessions => /user_sessions(.:format)
  user_sessions_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"user_sessions",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// users => /users(.:format)
  users_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"users",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// verify_payment => /cart/checkout(.:format)
  verify_payment_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"cart",false]],[7,"/",false]],[6,"checkout",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  }}
;

  window.Routes.options = defaults;

}).call(this);
