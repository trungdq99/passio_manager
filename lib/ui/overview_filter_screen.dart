import 'package:flutter/material.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../bloc_widgets/bloc_state_builder.dart';
import '../blocs/filter/filter_bloc.dart';
import '../blocs/filter/filter_event.dart';
import '../blocs/filter/filter_state.dart';
import '../models/store_model.dart';
import './select_store_screen.dart';
import '../utils/custom_colors.dart';

class OverviewFilterScreen extends StatefulWidget {
  @override
  _OverviewFilterScreenState createState() => _OverviewFilterScreenState();
}

class _OverviewFilterScreenState extends State<OverviewFilterScreen> {
  FilterBloc _filterBloc;
  @override
  Widget build(BuildContext context) {
    _filterBloc = BlocProvider.of<FilterBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Tuỳ chỉnh',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        leading: FlatButton(
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 16,
              ),
              _buildSelectStore(),
              SizedBox(
                height: 16,
              ),
              _buildSelectDate(),
            ],
          ),
          _buildConfirmButton(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 50),
              child: FlatButton(
                child: Text(
                  'Trở về mặc định',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: () {},
                //color: CustomColors.sick_green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectStore() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      shadowColor: CustomColors.pale_grey,
      child: ListTile(
        title: _buildListTileTitle('Chọn cửa hàng'),
        subtitle: BlocEventStateBuilder<FilterState>(
          bloc: _filterBloc,
          builder: (context, state) {
            String storeName = state.storeModel?.name;
            return _buildListTileSubTitle(storeName);
          },
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: CustomColors.cool_grey,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        onTap: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SelectStoreScreen(
                route: '/overview_filter',
              ),
            ));
          });
        },
      ),
    );
  }

  Widget _buildSelectDate() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      shadowColor: CustomColors.pale_grey,
      child: ListTile(
        title: _buildListTileTitle('Thời gian'),
        subtitle: _buildListTileSubTitle('Hôm nay'),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: CustomColors.cool_grey,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildListTileTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        color: Colors.black,
      ),
    );
  }

  Widget _buildListTileSubTitle(String subTitle) {
    return Text(
      subTitle,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildConfirmButton() {
    return BlocEventStateBuilder<FilterState>(
        builder: (context, state) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.maxFinite,
              height: 50,
              color: CustomColors.sick_green,
              margin: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 100,
              ),
              child: FlatButton(
                child: Text(
                  'Áp dụng',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: () {
                  StoreModel storeModel = state?.storeModel;
                  DateTimeRange dateTimeRange = state?.dateTimeRange;
                  _filterBloc.emitEvent(FilterEventSelected(
                    dateTimeRange: dateTimeRange,
                    storeModel: storeModel,
                  ));
                  Navigator.of(context).pop();
                },
                //color: CustomColors.sick_green,
              ),
            ),
          );
        },
        bloc: _filterBloc);
  }
}
