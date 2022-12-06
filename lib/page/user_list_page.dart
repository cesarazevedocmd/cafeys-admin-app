import 'package:cafeysadmin/config/nav.dart';
import 'package:cafeysadmin/custom_views/app_search_view.dart';
import 'package:cafeysadmin/custom_views/user_list_item_card_view.dart';
import 'package:cafeysadmin/model/user.dart';
import 'package:cafeysadmin/page/user_form_page.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/repository/blocs/user/list_user_bloc.dart';
import 'package:cafeysadmin/repository/pagination_response.dart';
import 'package:cafeysadmin/util/app_assets.dart';
import 'package:cafeysadmin/util/app_constants.dart';
import 'package:cafeysadmin/util/app_functions.dart';
import 'package:cafeysadmin/util/app_space.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:cafeysadmin/util/app_widget.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  UserListPage({Key? key}) : super(key: key);

  final _UserListPageState userListPageState = _UserListPageState();

  @override
  State<UserListPage> createState() => userListPageState;

  void fetch() {
    userListPageState._fetch();
  }

  void validateFetch() {
    userListPageState._validateFetch();
  }

  void swapSearchViewVisibility() {
    userListPageState.swapSearchViewVisibility();
  }
}

class _UserListPageState extends State<UserListPage> {
  bool _loading = false;
  bool _loadingMore = false;
  bool _lastListLoaded = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  ListUserBloc? listUserBloc;
  AppSearchView? _appSearchView;
  List<User> _items = [];

  @override
  void initState() {
    super.initState();
    _initBloc();
    _initScrollController();
    _fetch();
  }

  _initBloc() {
    listUserBloc ??= ListUserBloc();
  }

  void _initScrollController() {
    _scrollController.addListener(
      () {
        double extentLimit = _scrollController.position.maxScrollExtent - AppConstants.VALUE_100.toInt();
        if (_scrollController.position.pixels >= extentLimit && !_loadingMore) {
          _fetchMore();
        }
      },
    );
  }

  Future _fetch() {
    AppFunctions.hideKeyboard(context);
    _setLoadingFlag(true);
    setState(() => _items = []);
    return listUserBloc!.fetch(query: _searchController.text).then(
      (response) {
        _setLoadingFlag(false);
        validateRequestResult(response);
      },
    );
  }

  void _validateFetch() {
    if (_items.isEmpty) _fetch();
  }

  _fetchMore() {
    if (!_lastListLoaded) {
      _setLoadingMoreFlag(true);
      return listUserBloc!.fetchMore(query: _searchController.text).then(
        (response) {
          _setLoadingMoreFlag(false);
          validateRequestResult(response);
        },
      );
    }
  }

  void _setLoadingFlag(bool value) {
    setState(() => _loading = value);
  }

  void _setLoadingMoreFlag(bool value) {
    setState(() => _loadingMore = value);
  }

  void validateRequestResult(BlocResponse<CustomPaginationResponse<User>> response) {
    setState(
      () {
        switch (response.status) {
          case BlocResponseStatus.loading:
            break;
          case BlocResponseStatus.error:
            //AppToast.error(context, response.error ?? AppStrings.requestFailed);
            break;
          case BlocResponseStatus.success:
            if (response.data?.currentPage == null || response.data?.currentPage == 0) {
              _items = response.data?.items ?? [];
            } else {
              _items.addAll(response.data?.items ?? []);
            }
            _lastListLoaded = response.data?.currentPage == response.data?.totalPages;
            break;
          case BlocResponseStatus.unknown:
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initAppSearchView();
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.registeredUsersList),
        actions: [
          IconButton(
            onPressed: () => swapSearchViewVisibility(),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          _appSearchView!,
          Expanded(child: _getContent()),
          _loadingMoreView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openUserForm(),
        child: const Icon(Icons.person_add_outlined),
      ),
    );
  }

  void initAppSearchView() {
    _appSearchView ??= AppSearchView(
      hint: AppStrings.searchUser,
      controller: _searchController,
      clearClick: _clearSearchField,
      okClick: _fetch,
    );
  }

  void _clearSearchField() {
    _searchController.text = "";
    _fetch();
  }

  Widget _getContent() {
    if (_loading) return AppWidget.loading();

    if (_items.isEmpty) {
      return AppWidget.error(
        AppAssets.eyebrowBanner(),
        onClickText: AppStrings.tryAgain,
        onClick: _fetch,
      );
    }

    return AppWidget.refreshIndicator(
      onRefresh: _fetch,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: _items.length,
        itemBuilder: (context, index) {
          var item = _items[index];
          return UserListItemCardView(item: item, itemClick: _itemClick);
        },
      ),
    );
  }

  Widget _loadingMoreView() {
    if (_loadingMore) {
      return Column(
        children: [
          AppSpace.vertical(AppConstants.VALUE_10),
          AppWidget.loading(),
          AppSpace.vertical(AppConstants.VALUE_25),
        ],
      );
    }
    return AppWidget.empty();
  }

  void _itemClick(User user) {
    openUserForm(user: user);
  }

  void swapSearchViewVisibility() => _appSearchView?.swapVisibility();

  openUserForm({User? user}) async {
    var pushResult = await push(context, UserFormPage(user: user));
    if (pushResult != null && pushResult == true) {
      _fetch();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    listUserBloc?.dispose();
  }
}
