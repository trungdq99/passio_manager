import 'package:flutter/material.dart';
import '../utils/custom_search_delegate.dart';
import '../blocs/search_stores/selected_store_bloc.dart';
import '../blocs/search_stores/search_stores_bloc.dart';
import '../blocs/search_stores/search_stores_event.dart';
import '../blocs/search_stores/search_stores_state.dart';
import 'package:passio_manager/ui/home.dart';
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

  @override
  Widget build(BuildContext context) {
    final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocEventStateBuilder<AuthenticationState>(
      bloc: _authenticationBloc,
      builder: (context, state) {
        final _storeBloc = StoreBloc(state.accessToken);
//        final _storeBloc = StoreBloc(
//            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjN2JhMDkzMS1jMWRjLTQ2ZGUtYmE0My01NTIxN2VhZGMyMmUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiZGVtbyIsImV4cCI6MTU5NTcyODU3NCwiaXNzIjoiVGhpcyBpcyBJc3Nlci4iLCJhdWQiOiJUaGlzIGlzIElzc2VyLiJ9.o6OE4vQZr5vlSJXuUu-Okeyw9mzM9ceuYR2L4uuu9jk');
        return BlocProvider<StoreBloc>(
          bloc: _storeBloc,
          child: StreamBuilder<StoreModel>(
            stream: _storeBloc.storeStream,
            builder: (context, snapshot) {
              if (snapshot.hasError && snapshot.error == 'UnAuthorize') {
                return CustomWidget.buildErrorMessage(context, snapshot.error,
                    () {
                  _authenticationBloc.emitEvent(AuthenticationEventLogout());
                });
              } else if (!snapshot.hasData) {
                _searchStoresBloc = SearchStoresBloc();
                _loadAllStores(state.accessToken);
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
                        _authenticationBloc
                            .emitEvent(AuthenticationEventLogout());
                      }));
                    }
                    if (state.isSearched) {
                      List<StoreModel> list = [
                        StoreModel(id: -1, name: 'Tất cả cửa hàng'),
                      ];
                      list.addAll(state.listStores);
                      _selectedStoreBloc = SelectedStoreBloc();
                      _selectedStoreBloc.setIndex(0);
                      _children.add(
                        Container(
                          padding: EdgeInsets.only(
                            top: 16,
                          ),
                          child: ListView.builder(
                            itemBuilder: (context, index) =>
                                _buildStoreDetail(list[index], index),
                            itemCount: list.length,
                          ),
                        ),
                      );
                      print('Search successful!');
                    }

                    _children.add(_buildConfirmButton());
                    return Scaffold(
                      appBar: _buildAppBar(),
                      body: Stack(
                        fit: StackFit.expand,
                        children: _children,
                      ),
                      backgroundColor: CustomColors.background,
                    );
                  },
                );
              } else {
                return Home();
              }
            },
          ),
        );
      },
    );
  }

  _loadAllStores(String accessToken) async {
//    List<StoreModel> listStores = await _searchStoresBloc.loadAllStores(
//        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjN2JhMDkzMS1jMWRjLTQ2ZGUtYmE0My01NTIxN2VhZGMyMmUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiZGVtbyIsImV4cCI6MTU5NTcyODU3NCwiaXNzIjoiVGhpcyBpcyBJc3Nlci4iLCJhdWQiOiJUaGlzIGlzIElzc2VyLiJ9.o6OE4vQZr5vlSJXuUu-Okeyw9mzM9ceuYR2L4uuu9jk');
    List<StoreModel> listStores =
        await _searchStoresBloc.loadAllStores(accessToken);
    _searchStoresBloc.emitEvent(SearchStoresEvent(listStores: listStores));
  }

  // Build App Bar
  Widget _buildAppBar() {
    return AppBar(
      centerTitle: false,
      // Title
      title: _buildTitle(),
      backgroundColor: Colors.white,
      actions: [
        // Search Button
        _buildSearchButton(),
      ],
    );
  }

  // Build Title
  Widget _buildTitle() {
    return Text(
      'Chọn cửa hàng',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  // Build Search Button
  Widget _buildSearchButton() {
    return FlatButton(
      onPressed: () {
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        );
      },
      child: Icon(
        Icons.search,
        color: Colors.black,
        size: 20,
      ),
      minWidth: 50,
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
          child: FlatButton(
            child: Text(
              'Xong',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800),
            ),
            onPressed: () {},
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
          stream: _selectedStoreBloc.selectedIndex,
          builder: (context, snapshot) {
            return Radio(
              value: index,
              groupValue: snapshot.data,
              onChanged: (val) {
                _selectedStoreBloc.setIndex(val);
                print('$index');
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
