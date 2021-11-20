import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/model/product_model.dart';
import 'package:alternate_store_cms/screen/proudct/product_editor.dart';
import 'package:alternate_store_cms/service/product_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productModel = Provider.of<List<ProductModel>>(context);

    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _buildSearchAppBar(context),
      body: ListView.builder(
        itemCount: productModel.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: () {},
            child: productListItem(context, productModel[index])
          );
        }
      ),
    );
  }
}

AppBar _buildSearchAppBar(BuildContext context){
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
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
                isDense: true,
                hintText: 'Product Name'
              ),
              onChanged: (val){},
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

FloatingActionButton _buildFloatingActionButton(BuildContext context){
  return FloatingActionButton(
    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductEditor())),
    child: const Icon(Icons.add, color: Colors.grey),
    backgroundColor: const Color(primaryDark),
    elevation: 0,
  );
}

Widget productListItem(BuildContext context, ProductModel productModel){
  return Container(
    height: 120,
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: const Color(primaryDark),
            borderRadius: BorderRadius.circular(7),
            image: DecorationImage(
              image: NetworkImage(productModel.imagePatch[0])
            )
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(productModel.productNo)
                  ),
                  productModel.inStock ? Container() :
                  const Text(
                    '已下架',
                    style: TextStyle(color: Colors.redAccent),
                  )
                ],
              ),
              Text(
                productModel.productName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text('已售出 : ${productModel.sold}'),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'HKD\$ ${productModel.price.toStringAsFixed(2)}',
                    style: productModel.discountPrice == 0 ? 
                    const TextStyle() : 
                    const TextStyle(decoration: TextDecoration.lineThrough)
                  ),
                  Container(width: 10,),
                  productModel.discountPrice == 0 ? const Text('') :
                  Text(
                    'HKD\$ ${productModel.discountPrice.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
              )

            ],
          ),
        )
      ],
    ),
  );
}