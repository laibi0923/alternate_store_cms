import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/model/coupon_model.dart';
import 'package:asher_store_cms/screen/coupon/coupon_editor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CouponListView extends StatefulWidget {
  const CouponListView({ Key? key }) : super(key: key);

  @override
  _CouponListViewState createState() => _CouponListViewState();
}

class _CouponListViewState extends State<CouponListView> {

  final List<CouponModel> _searchList = [];
  final TextEditingController _searchTextController = TextEditingController();
  late int _searchResultCounter = 0; 

  void _searchCoupon(String val, List<CouponModel> list){
    setState(() {
      _searchList.clear();
      _searchResultCounter = 0;
      if(val.isNotEmpty) {
        for(int i = 0; i < list.length; i++){
          if(list[i].couponCode.toUpperCase().contains(val.toUpperCase())){
            _searchList.add(list[i]);
            _searchResultCounter = _searchList.length;
          } 
        }
      }  
    });
  }

  Future<void> _editCoupon(CouponModel couponModel) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CouponEditor(editModel: true, couponModel: couponModel,)));
    if(result == true){
      _searchList.clear();
      _searchResultCounter = 0;
      _searchTextController.clear();
    }
  }

  void _addCoupon() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CouponEditor(editModel: false, couponModel: CouponModel.initialData(),)));
  }

  @override
  Widget build(BuildContext context) {

    final _dbCouponList = Provider.of<List<CouponModel>>(context);
    // ignore: unnecessary_null_comparison
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCoupon(),
        child: const Icon(Icons.add, color: Colors.grey),
        backgroundColor: const Color(primaryDark),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _buildSearchAppBar(context, _dbCouponList),
      body: Column(
        children: [
          _searchResultCounter == 0 ? Container() :
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              '共找到 $_searchResultCounter 筆相關資料',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: _searchTextController.text.isNotEmpty || _searchList.isNotEmpty ?
            _couponListView(_searchList) :
            _couponListView(_dbCouponList)
          )
        ],
      )
      
    );
  }

  AppBar _buildSearchAppBar(BuildContext context, List<CouponModel> list){
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Container(
        decoration: BoxDecoration(
          color: const Color(primaryDark),
          borderRadius: BorderRadius.circular(7)
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context), 
              icon: const Icon(
                Icons.arrow_back, 
                size: 20,
                color: Colors.white,
              )
            ),
            Expanded(
              child: TextField(
                controller: _searchTextController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  isDense: true,
                  hintText: '優惠碼捜尋'
                ),
                onChanged: (val) => _searchCoupon(val, list),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.search,
                color: Colors.white
              )
            )
          ],
        ),
      ),
    );
  }
  
  Widget _couponListView(List<CouponModel> list){

    // ignore: unnecessary_null_comparison
    if(list == null){
      return const Center(
        child: CircularProgressIndicator(color: Colors.grey),
      );
    }

    if(list.isEmpty){
      return const Center(
        child: Text(
          '找不到捜尋結果',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 150),
      itemCount: list.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: () => _editCoupon(list[index]),
          child: _couponItemView(list[index])
        );
      }
    );

  }

  Widget _couponItemView(CouponModel couponModel){
    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            decoration: BoxDecoration(
              color: const Color(primaryDark),
              borderRadius: BorderRadius.circular(7)
            ),
            child: couponModel.percentage !=0 ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${couponModel.percentage.toStringAsFixed(0)}%'),
                const Text('OFF'),
              ],
            ) : 
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('全單扣減'),
                Text('\$${couponModel.discountAmount.toStringAsFixed(2)}'),
              ],
            ) ,
          ),
          Container(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '建立日期 : ${ 
                  DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(couponModel.createDate.microsecondsSinceEpoch))
                }',
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                '折扣代碼: ${couponModel.couponCode}',
              ),
              const Spacer(),
              couponModel.unLimited == false ? 
              Text(
                '使用限期: ${ 
                  DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(couponModel.validDate.microsecondsSinceEpoch))
                }',
                style: const TextStyle(color: Colors.grey),
              ) :
              const Text(
                '無限期',
                style: TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
          const Spacer(),
          const Center(
            child: Icon(Icons.more_vert, color: Colors.grey)
          )
        ],
      ),
    );
  }

}