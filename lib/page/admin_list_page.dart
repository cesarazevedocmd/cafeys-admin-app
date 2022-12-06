import 'package:cafeysadmin/config/admin_manager.dart';
import 'package:cafeysadmin/custom_views/admin_list_item_card_view.dart';
import 'package:cafeysadmin/custom_views/app_search_view.dart';
import 'package:cafeysadmin/custom_views/app_title_view.dart';
import 'package:cafeysadmin/model/admin.dart';
import 'package:cafeysadmin/repository/blocs/admin/list_admin_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/repository/pagination_response.dart';
import 'package:cafeysadmin/util/app_assets.dart';
import 'package:cafeysadmin/util/app_colors.dart';
import 'package:cafeysadmin/util/app_constants.dart';
import 'package:cafeysadmin/util/app_functions.dart';
import 'package:cafeysadmin/util/app_space.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:cafeysadmin/util/app_widget.dart';
import 'package:flutter/material.dart';

class AdminListPage extends StatefulWidget {
  AdminListPage({Key? key}) : super(key: key);

  final _AdminListPageState adminListPageState = _AdminListPageState();

  @override
  State<AdminListPage> createState() => adminListPageState;

  void fetch() {
    adminListPageState._fetch();
  }

  void validateFetch() {
    adminListPageState._validateFetch();
  }

  void swapSearchViewVisibility() {
    adminListPageState.swapSearchViewVisibility();
  }
}

class _AdminListPageState extends State<AdminListPage> {
  bool _loading = false;
  bool _loadingMore = false;
  bool _lastListLoaded = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  ListAdminBloc? listAdminBloc;
  AppSearchView? _appSearchView;
  List<Admin> _items = [];

  @override
  void initState() {
    super.initState();
    _initBloc();
    _initScrollController();
    _fetch();
  }

  _initBloc() {
    listAdminBloc ??= ListAdminBloc();
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
    return listAdminBloc!.fetch(query: _searchController.text).then(
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
      return listAdminBloc!.fetchMore(query: _searchController.text).then(
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

  void validateRequestResult(BlocResponse<CustomPaginationResponse<Admin>> response) {
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
        title: FutureBuilder(
          initialData: null,
          future: AdminManager.getAdmin(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const AppTitleView(text: AppStrings.empty);
            }

            return AppTitleView(
              color: AppColors.white,
              text: "${AppStrings.hello}${AppStrings.comma} ${snapshot.data!.name!}",
              textSize: AppConstants.VALUE_20,
            );
          },
        ),
      ),
      body: Column(
        children: [
          _appSearchView!,
          Expanded(child: _getContent()),
          _loadingMoreView(),
        ],
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
  }

  Widget _getContent() {
    if (_loading) return AppWidget.loading();

    if (_items.isEmpty) {
      return AppWidget.error(
        AppAssets.error404(),
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
          return AdminListItemCardView(item: item, itemClick: _itemClick);
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

  void _itemClick(Admin admin) async {}

  void swapSearchViewVisibility() => _appSearchView?.swapVisibility();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    listAdminBloc?.dispose();
  }
}
