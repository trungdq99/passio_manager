import 'package:flutter/material.dart';
import 'package:passio_manager/utils/custom_colors.dart';

class ReportFilterScreen extends StatefulWidget {
  @override
  _ReportFilterScreenState createState() => _ReportFilterScreenState();
}

class _ReportFilterScreenState extends State<ReportFilterScreen> {
  @override
  Widget build(BuildContext context) {
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
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                shadowColor: CustomColors.pale_grey,
                child: ListTile(
                  title: Text(
                    'Chọn cửa hàng',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Tất cả cửa hàng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: CustomColors.cool_grey,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                shadowColor: CustomColors.pale_grey,
                child: ListTile(
                  title: Text(
                    'Thời gian',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Hôm nay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: CustomColors.cool_grey,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                shadowColor: CustomColors.pale_grey,
                child: ListTile(
                  title: Text(
                    'Xem báo cáo',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Sau giảm giá',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: CustomColors.cool_grey,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                shadowColor: CustomColors.pale_grey,
                child: ListTile(
                  title: Text(
                    'Chọn loại',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Sản phẩm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: CustomColors.cool_grey,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ],
          ),
          Align(
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
                onPressed: () {},
                //color: CustomColors.sick_green,
              ),
            ),
          ),
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
}
