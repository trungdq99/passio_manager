import 'package:flutter/material.dart';
import 'package:passio_manager/blocs/store/store_event.dart';
import '../blocs/search_stores/selected_store_bloc.dart';
import '../blocs/search_stores/search_stores_bloc.dart';
import '../blocs/search_stores/search_stores_event.dart';
import '../blocs/search_stores/search_stores_state.dart';
import '../blocs/login/authentication_event.dart';
import '../models/store_model.dart';
import '../utils/custom_widget.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../bloc_widgets/bloc_state_builder.dart';
import '../blocs/login/authentication_bloc.dart';
import '../blocs/login/authentication_state.dart';
import '../blocs/store/store_bloc.dart';
import '../utils/custom_colors.dart';

class SelectStoreScreen extends StatefulWidget {
  @override
  _SelectStoreScreenState createState() => _SelectStoreScreenState();
}

class _SelectStoreScreenState extends State<SelectStoreScreen> {
  SearchStoresBloc _searchStoresBloc;
  SelectedStoreBloc _selectedStoreBloc;
  TextEditingController _txtSearchController;
  List<StoreModel> _listStores;
  StoreBloc _storeBloc;
  @override
  void initState() {
    super.initState();
    _searchStoresBloc = SearchStoresBloc();
    _selectedStoreBloc = SelectedStoreBloc();
    _txtSearchController = TextEditingController();
    _listStores = [];
  }

  @override
  Widget build(BuildContext context) {
    final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _storeBloc = BlocProvider.of<StoreBloc>(context);
    return BlocEventStateBuilder<AuthenticationState>(
        bloc: _authenticationBloc,
        builder: (context, state) {
          _searchStoresBloc.loadAllStores(state.accessToken).whenComplete(() {
            _searchStoresBloc.emitEvent(SearchStoreEventShowAll());
          });
          return BlocEventStateBuilder<SearchStoresState>(
            bloc: _searchStoresBloc,
            builder: (context, state) {
              List<Widget> _children = [];
              if (state.isSearching) {
                _children.add(CustomWidget.buildProcessing(context));
              }
              if (state.hasFailed) {
                _children.add(CustomWidget.buildErrorMessage(
                    context, 'Something when wrong!', () {
                  _authenticationBloc.emitEvent(AuthenticationEventLogout());
                }));
              }
              if (state.isSearched) {
                _listStores = state.listStores;
                _selectedStoreBloc = SelectedStoreBloc();
                _selectedStoreBloc.setIndex(0);
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
              }

              _children.add(_buildConfirmButton());
              return Scaffold(
                appBar: state.showSearch
                    ? _buildSearchAppBar()
                    : _buildSelectStoreAppBar(),
                body: Stack(
                  fit: StackFit.expand,
                  children: _children,
                ),
                backgroundColor: CustomColors.background,
              );
            },
          );
        });
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
      leading: FlatButton(
        onPressed: () {},
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: 20,
        ),
        minWidth: 50,
      ),
      actions: [
        // Search Button
        FlatButton(
          onPressed: () {
            _searchStoresBloc.emitEvent(SearchStoreEventQuery(listStores: []));
          },
          child: Icon(
            Icons.search,
            color: Colors.black,
            size: 20,
          ),
          minWidth: 50,
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
          List<StoreModel> list = _searchStoresBloc.searchStores(value);
          _searchStoresBloc.emitEvent(SearchStoreEventQuery(listStores: list));
        },
      ),
      backgroundColor: Colors.white,
      leading: FlatButton(
        onPressed: () {
          _searchStoresBloc.emitEvent(SearchStoreEventShowAll());
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
            _searchStoresBloc.emitEvent(SearchStoreEventQuery(listStores: []));
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
          child: StreamBuilder<int>(
              stream: _selectedStoreBloc.selectedIndex,
              builder: (context, snapshot) {
                return FlatButton(
                  child: Text(
                    'Xong',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800),
                  ),
                  onPressed: _listStores.isNotEmpty
                      ? () {
                          if (snapshot.hasData) {
                            print(_listStores[snapshot.data].name);
                          }
                          _storeBloc.emitEvent(StoreEventSelected(
                            store: _listStores[snapshot.data],
                          ));
                        }
                      : null,
                );
              }),
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
          stream: _selectedStoreBloc.selectedIndex,
          builder: (context, snapshot) {
            return Radio(
              value: index,
              groupValue: snapshot.data,
              onChanged: (val) {
                _selectedStoreBloc.setIndex(val);
              },
              activeColor: CustomColors.sick_green,
            );
          },
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: store.address.isNotEmpty ? 8 : 2,
        ),
        onTap: () => _selectedStoreBloc.setIndex(index),
      ),
    );
  }
}
