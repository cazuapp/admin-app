/*
 * CazuApp - Delivery at convenience.  
 * 
 * Copyright 2023-2024, Carlos Ferry <cferry@cazuapp.dev>
 *
 * This file is part of CazuApp. CazuApp is licensed under the New BSD License: you can
 * redistribute it and/or modify it under the terms of the BSD License, version 3.
 * This program is distributed in the hope that it will be useful, but without
 * any warranty.
 *
 * You should have received a copy of the New BSD License
 * along with this program. <https://opensource.org/licenses/BSD-3-Clause>
 */

class AppRoutes {
  /* Bans */

  static const String listAllBans = "app/managed/bans/list";
  static const String searchBans = "app/managed/bans/search";
  static const String banSet = "app/bans/upsert";
  static const String banInfo = "app/bans/info";
  static const String banDelete = "app/bans/delete";

  /* Server */

  static const String servercaCheReset = "app/status/reset";

  static const String productDelete = "app/managed/products/delete";
  static const String adminSearch = "app/managed/admin/search";
  static const String admingetAll = "app/managed/admin/list";

  /* Address */

  static const String addressAdd = "app/address/add";
  static const String addressUpdate = "app/address/update";
  static const String addressGet = "app/address/get";
  static const String addressInfo = "app/address/info";
  static const String addressgetDefault = "app/address/getdefault";

  /* Preferences */

  static const String preferencesSet = "app/preferences/set";
  static const String preferencesGetAll = "app/preferences/getall";

  /* Settings */

  static const String settingsGetAll = "app/managed/settings/getall";
  static const String settingsSet = "app/managed/settings/set";

  /* Payments */

  static const String paymentsGetAll = "app/payments/getall";

  /* holds */

  static const String holdsUpsert = "app/holds/upsert";

  /* Flags */

  static const String flagsUpsert = "app/roles/upsert";

  /* Drivers */

  static const String driversGetfullavailable = "app/managed/drivers/getfullavailable";
  static const String driverStats = "app/managed/drivers/stats";
  static const String orderStats = "app/managed/orders/stats";
  static const String driverSearchQuery = "app/managed/drivers/search";
  static const String driverList = "app/managed/drivers/list";

  /* User */

  static const String whoami = "app/user/whoami";
  static const String holdsGet = "app/user/holds/get";
  static const String userLogout = "app/user/logout";
  static const String userClose = "app/user/close";
  static const String userLast = "app/user/last";
  static const String userListQuery = "app/managed/users/list";
  static const String userSearchQuery = "app/managed/users/search";

  static const String userGet = "app/managed/users/search/get";
  static const String userSuperInfo = "app/managed/users/info";

  /* Drivers */

  static const String deleteDriver = "app/managed/drivers/delete";
  static const String addDriver = "app/managed/drivers/add";
  static const String setStatus = "app/driver/setstatus";
  static const String assignOrder = "app/managed/drivers/assign";
  static const String unassign = "app/managed/drivers/unassign";

  /* Variants */

  static const String variantImages = "app/variants/images";
  static const String variantsGet = "app/variants/get";
  static const String variantsAdd = "app/managed/variants/add";
  static const String variantInfo = "app/variants/info";
  static const String variantsList = "app/managed/variants/list";
  static const String variantSearchAllBy = "app/managed/variants/search";

  /* Session */

  static const String adminLogin = "app/noauth/admin_login";
  static const String login = "app/noauth/login";
  static const String forgot = "app/noauth/forgot";
  static const String forgotAhead = "app/noauth/forgot_ahead";
  static const String tokenLogin = "app/noauth/token_login";

  /* Initial */

  static const String initPing = "app/startup/ping";

  static const String favoritesGetJoin = "app/favorites/getjoin";
  static const String favoritesSmart = "app/favorites/smart";

  static const String appDelete = "app/address/delete";
  static const String searchQuery = "app/home/query";
  static const String homeGet = "app/home/list";
  static const String productsInfo = "app/products/info";

  static const String passwd = "app/noauth/passwd";
  static const String extend = "app/noauth/token_login";
  static const String signup = "app/noauth/signup";

  /* Orders */

  static const String orderGet = "app/orders/get";
  static const String orderGetBy = "app/orders/getby";
  static const String preOrder = "app/orders/preorder";
  static const String addOrder = "app/orders/add";
  static const String orderInfo = "app/orders/info";
  static const String historicInfo = "app/orders/historic/info";
  static const String orderCancel = "app/orders/cancel";
  static const String getItems = "app/orders/items";
  static const String getHome = "app/managed/orders/getallpending";

  static const String orderGetAllBy = "app/driver/orders/get";

  static const String orderSearchAllBy = "app/managed/orders/pendingsearch";
  static const String pendingSearch = "/orders/pendingsearch";

  /* Collections */

  static const String collectionsGet = "app/collections/list";
  static const String collectionsSearch = "app/collections/search";
  static const String collectionsInfo = "app/collections/info";

  static const String collectionsAdd = "app/managed/collections/add";
  static const String collectionsDelete = "app/managed/collections/delete";
  static const String collectionsUpdate = "app/managed/collections/update";

  /* Products */

  static const String productsAdd = "app/managed/products/add";
  static const String productsDelete = "app/managed/products/delete";
  static const String productsUpdate = "app/managed/products/update";

  /* Uploads */

  static const String upload = "app/managed/images/submit";
}
