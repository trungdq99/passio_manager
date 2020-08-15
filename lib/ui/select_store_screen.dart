import 'package:flutter/material.dart';
import '../blocs/filter/filter_bloc.dart';
import '../blocs/filter/filter_event.dart';
import '../blocs/filter/filter_state.dart';
import '../blocs/search_stores/selected_index_bloc.dart';
import '../blocs/search_stores/search_store_bloc.dart';
import '../blocs/search_stores/search_store_event.dart';
import '../blocs/search_stores/search_store_state.dart';
import '../blocs/login/authentication_event.dart';
import '../models/store_model.dart';
import '../utils/custom_widget.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../bloc_widgets/bloc_state_builder.dart';
import '../blocs/login/authentication_bloc.dart';
import '../blocs/login/authentication_state.dart';
import '../utils/custom_colors.dart';

class SelectStoreScreen extends StatefulWidget {
  final String route;
  SelectStoreScreen({@required this.route});
  @override
  _SelectStoreScreenState createState() =>
      _SelectStoreScreenState(route: route);
}

class _SelectStoreScreenState extends State<SelectStoreScreen> {
  _SelectStoreScreenState({@required this.route});
  final String route;
  SearchStoreBloc _searchStoreBloc;
  TextEditingController _txtSearchController;
  List<StoreModel> _listStores;
  AuthenticationBloc _authenticationBloc;
  FilterBloc _filterBloc;
  SelectedIndexBloc _selectedIndexBloc;

  @override
  void initState() {
    super.initState();
    _searchStoreBloc = SearchStoreBloc();
    _txtSearchController = TextEditingController();
    _listStores = [];
    _selectedIndexBloc = SelectedIndexBloc();
    _selectedIndexBloc.setIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _filterBloc = BlocProvider.of<FilterBloc>(context);
    String accessToken = '';
    if (_authenticationBloc.lastState.isAuthenticated) {
      accessToken = _authenticationBloc.lastState.userModel?.accessToken;
    }
    if (accessToken.isNotEmpty) {
      _searchStoreBloc
          .emitEvent(SearchStoreEventLoad(accessToken: accessToken));
    }
    return BlocEventStateBuilder<SearchStoreState>(
      bloc: _searchStoreBloc,
      builder: (context, searchStoreState) {
        List<Widget> _children = [];
        if (searchStoreState.isLoading) {
          _children.add(CustomWidget.buildProcessing(context));
        }
        if (searchStoreState.hasFailed) {
          CustomWidget.buildErrorMessage(context, 'Something when wrong!', () {
            _authenticationBloc.emitEvent(AuthenticationEventLogout());
          });
        }
        if (searchStoreState.isLoaded) {
          _listStores = searchStoreState.listStores;
        }
        _children.add(
          Container(
            padding: EdgeInsets.only(
              top: 16,
            ),
            child: ListView.builder(
              itemBuilder: (context, index) =>
                  _buildStoreDetail(_listStores[index], index),
              itemCount: _listStores.length,
            ),
          ),
        );
        _children.add(_buildConfirmButton());
        return Scaffold(
          appBar: searchStoreState.showSearch
              ? _buildSearchAppBar()
              : _buildSelectStoreAppBar(),
          body: Stack(
            //fit: StackFit.expand,
            children: _children,
          ),
          backgroundColor: CustomColors.background,
        );
      },
    );
  }

  // Build App Bar
  Widget _buildSelectStoreAppBar() {
    return AppBar(
      centerTitle: false,
      // Title
      title: Text(
        'Chọn cửa hàng',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      backgroundColor: Colors.white,
      leading: BlocEventStateBuilder<FilterState>(
        builder: (context, filterState) {
          return FlatButton(
            onPressed: () {
              if (filterState.notSelectStore) {
                _filterBloc.emitEvent(FilterEventDefaultOverview());
              }
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
              size: 20,
            ),
            minWidth: 50,
          );
        },
        bloc: _filterBloc,
      ),
      actions: [
        // Search Button
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            _searchStoreBloc.emitEvent(SearchStoreEventSearch(searchValue: ''));
            _selectedIndexBloc.setIndex(0);
          },
        ),
      ],
    );
  }

  Widget _buildSearchAppBar() {
    return AppBar(
      centerTitle: false,
      // Title
      title: TextField(
        controller: _txtSearchController,
        keyboardType: TextInputType.text,
        autofocus: true,
        onChanged: (value) {
          _searchStoreBloc
              .emitEvent(SearchStoreEventSearch(searchValue: value));
          _selectedIndexBloc.setIndex(0);
        },
      ),
      backgroundColor: Colors.white,
      leading: FlatButton(
        onPressed: () {
          _txtSearchController.clear();
          _searchStoreBloc.emitEvent(SearchStoreEventShowAll());
          _selectedIndexBloc.setIndex(0);
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: 20,
        ),
        minWidth: 50,
      ),
      actions: [
        // Clear Button
        FlatButton(
          onPressed: () {
            _txtSearchController.clear();
            _searchStoreBloc.emitEvent(SearchStoreEventSearch(searchValue: ''));
          },
          child: Icon(
            Icons.close,
            color: Colors.black,
            size: 20,
          ),
          minWidth: 50,
        ),
      ],
    );
  }

  // Build Confirm Button
  Widget _buildConfirmButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: EdgeInsets.all(25),
          child: BlocEventStateBuilder<AuthenticationState>(
            bloc: _authenticationBloc,
            builder: (context, authenticationState) {
              return StreamBuilder<int>(
                stream: _selectedIndexBloc.selectedIndex,
                builder: (context, snapshot) {
                  return BlocEventStateBuilder<FilterState>(
                    builder: (context, filterState) {
                      return FlatButton(
                        child: Text(
                          'Xong',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800),
                        ),
                        onPressed: snapshot.hasData && _listStores.length > 0
                            ? () {
                                if (filterState.notSelectStore) {
                                  _filterBloc.emitEvent(FilterEventSelected(
                                    storeModel: _listStores[snapshot.data],
                                    dateTimeRange: filterState.dateTimeRange,
                                  ));
                                } else {
                                  _filterBloc.emitEvent(FilterEventUpdate(
                                    storeModel: _listStores[snapshot.data],
                                    dateTimeRange: filterState.dateTimeRange,
                                  ));
                                }
                                Navigator.of(context).pop();
                              }
                            : null,
                      );
                    },
                    bloc: _filterBloc,
                  );
                },
              );
            },
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                  color: CustomColors.tree_green_20,
                  offset: Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 0)
            ],
            color: CustomColors.sick_green,
          )),
    );
  }

  // Build Store Detail
  Widget _buildStoreDetail(StoreModel store, int index) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 3,
      ),
      shadowColor: CustomColors.pale_grey,
      child: ListTile(
        // Title: Name
        title: Text(
          store.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Subtitle: Address
        subtitle: store.address.isNotEmpty
            ? Text(
                store.address,
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.dark_sage,
                ),
              )
            : null,
        leading: StreamBuilder<int>(
          stream: _selectedIndexBloc.selectedIndex,
          builder: (context, snapshot) {
            return Radio(
              value: index,
              groupValue: snapshot.hasData ? snapshot.data : 0,
              onChanged: (val) {
                _selectedIndexBloc.setIndex(val);
              },
              activeColor: CustomColors.sick_green,
            );
          },
        ),

        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: store.address.isNotEmpty ? 8 : 2,
        ),
        onTap: () => _selectedIndexBloc.setIndex(index),
      ),
    );
  }
}
