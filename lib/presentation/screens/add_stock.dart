import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nickys_crochet_designs/presentation/resources/color_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/font_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/string_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/value_manager.dart';
import 'package:nickys_crochet_designs/utilities/palette.dart';
import 'package:nickys_crochet_designs/presentation/screens/stock.dart';
import 'package:nickys_crochet_designs/widgets/page_layout.dart';
import 'package:nickys_crochet_designs/providers/pages_provider.dart';

class AddStock extends StatefulWidget {
  const AddStock({Key key}) : super(key: key);

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  final _stockCollection = FirebaseFirestore.instance.collection('stock');

  Uint8List webImage = Uint8List(ValueManager.v_8);
  XFile image;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _size = TextEditingController();
  final TextEditingController _stock = TextEditingController();

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      image = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
        });
      } else
        return;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _size.dispose();
    _stock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Pages page = Provider.of<Pages>(context);

    Size size = MediaQuery.of(context).size;
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return PageLayout(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: PaddingManager.p_15,
              bottom: PaddingManager.p_15,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                StringManager.addNewProduct,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: mediaQuery.textScaleFactor * FontSizeManager.f_25,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * SizeManager.s0_8,
          ),
          SizedBox(
            child: AddStockTextField(
                controller: _name, label: StringManager.productTitle),
          ),
          SizedBox(
            height: size.height * SizeManager.s0_03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    width: size.width * SizeManager.s0_25,
                    child: AddStockTextField(
                        controller: _price, label: StringManager.priceInNS),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  SizedBox(
                    width: size.width * SizeManager.s0_25,
                    child: AddStockTextField(
                        controller: _size, label: StringManager.sizeUppercase),
                  ),
                  SizedBox(
                    height: size.height * SizeManager.s0_03,
                  ),
                  SizedBox(
                    width: size.width * SizeManager.s0_25,
                    child: AddStockTextField(
                        controller: _stock, label: StringManager.stock),
                  ),
                ],
              ),
              Container(
                width: size.width * SizeManager.s0_35,
                height: size.height * SizeManager.s0_5,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorManager.grey300,
                  ),
                ),
                child: (image == null)
                    ? const Icon(
                        Icons.image,
                        size: SizeManager.s_40,
                      )
                    : Image.memory(
                        webImage,
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: PaddingManager.p_10,
                ),
                child: Column(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: ColorManager.red,
                      ),
                      child: const Text(
                        StringManager.clearImage,
                      ),
                      onPressed: () {
                        setState(() {
                          image = null;
                        });
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: ColorManager.black,
                      ),
                      child: const Text(
                        StringManager.selectImage,
                      ),
                      onPressed: () {
                        _pickImage();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: size.height * SizeManager.s0_03,
          ),
          ElevatedButton(
            onPressed: () {
              _stockCollection.add(
                {
                  StringManager.image: (image == null) ? '' : Blob(webImage),
                  StringManager.price: '${_price.text}.00',
                  StringManager.prodName: _name.text,
                  StringManager.size: '${_size.text}cm',
                  StringManager.stockLowercase: int.parse(_stock.text),
                  StringManager.dateAdded: DateTime.now().toString()
                },
              );
              page.changeCurrentPage(const Stock());
            },
            style: TextButton.styleFrom(
              backgroundColor: ColorPalette.colorPalette.shade200,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * SizeManager.s0_3,
                vertical: size.height * SizeManager.s0_04,
              ),
            ),
            child: const Text(
              StringManager.addNewProduct,
            ),
          )
        ],
      ),
    );
  }
}

class AddStockTextField extends StatelessWidget {
  const AddStockTextField({
    Key key,
    @required this.controller,
    @required this.label,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(
          label,
        ),
        floatingLabelStyle: TextStyle(
          color: ColorPalette.colorPalette.shade500,
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(),
      ),
    );
  }
}
