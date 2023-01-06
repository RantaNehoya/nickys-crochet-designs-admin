import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nickys_crochet_designs/presentation/screens/add_stock.dart';
import 'package:nickys_crochet_designs/providers/pages_provider.dart';
import 'package:nickys_crochet_designs/utilities/palette.dart';
import 'package:nickys_crochet_designs/presentation/resources/asset_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/color_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/font_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/string_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/value_manager.dart';
import 'package:nickys_crochet_designs/utilities/constants.dart';
import 'package:nickys_crochet_designs/widgets/page_layout.dart';

class Stock extends StatefulWidget {
  const Stock({Key key}) : super(key: key);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  final _stockCollection =
  FirebaseFirestore.instance.collection(StringManager.stockCollection);

  final TextEditingController _editName = TextEditingController();
  final TextEditingController _editSize = TextEditingController();
  final TextEditingController _editPrice = TextEditingController();

  @override
  void dispose() {
    _editName.dispose();
    _editSize.dispose();
    _editPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Pages page = Provider.of<Pages>(context);
    Size size = MediaQuery
        .of(context)
        .size;
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return PageLayout(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
          ),
          onPressed: () {
            page.changeCurrentPage(const AddStock());
          },
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _stockCollection.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return kProgressIndicator;
              }

              if (snapshot.hasError) {
                return kErrorMessage;
              }

              if (snapshot.data.docs.isEmpty) {
                return kNoStock;
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ValueManager.v_4,
                ),
                itemCount: snapshot.data.size,
                itemBuilder: (context, index) {
                  var doc = snapshot.data.docs[index];
                  return Badge(
                    showBadge: true,
                    badgeContent: IconButton(
                      alignment: Alignment.topRight,
                      icon: const Icon(
                        Icons.delete_outline_outlined,
                      ),
                      onPressed: () {
                        doc.reference.delete();
                      },
                    ),
                    badgeColor: ColorPalette.colorPalette.shade300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        RadiusManager.r_20,
                      ),
                      child: Card(
                        color: Colors.transparent,
                        child: Stack(
                          children: <Widget>[
                            (doc[StringManager.image] == '')
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                RadiusManager.r_8,
                              ),
                              child: Image.asset(
                                AssetManager.logo,
                                fit: BoxFit.cover,
                              ),
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                RadiusManager.r_8,
                              ),
                              child: Image.memory(
                                doc[StringManager.image].bytes,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: ValueManager.v_0.toDouble(),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft:
                                  Radius.circular(RadiusManager.r_8),
                                  bottomRight:
                                  Radius.circular(RadiusManager.r_8),
                                ),
                                child: Container(
                                  width: size.width * SizeManager.s0_19,
                                  color: ColorManager.white70,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            doc[StringManager.prodName],
                                            style: TextStyle(
                                              fontSize:
                                              mediaQuery.textScaleFactor *
                                                  FontSizeManager.f_16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      StringManager.productName,
                                                    ),
                                                    actions: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(
                                                          PaddingManager.p_8,
                                                        ),
                                                        child: TextField(
                                                          controller: _editName,
                                                          decoration:
                                                          const InputDecoration(
                                                            border:
                                                            OutlineInputBorder(),
                                                            focusedBorder:
                                                            OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          try {
                                                            doc.reference
                                                                .update({
                                                              StringManager
                                                                  .prodName:
                                                              _editName.text,
                                                            });
                                                          } catch (e) {
                                                            showDialog(
                                                              context: context,
                                                              builder: (
                                                                  context) {
                                                                return kSnackBar;
                                                              },
                                                            );
                                                          }
                                                          _editName.clear();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                          ColorManager
                                                              .black,
                                                        ),
                                                        child: const Text(
                                                          StringManager.save,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            doc[StringManager.size],
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      StringManager.changeSize,
                                                    ),
                                                    actions: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(
                                                            PaddingManager
                                                                .p_8),
                                                        child: TextField(
                                                          controller: _editSize,
                                                          decoration:
                                                          const InputDecoration(
                                                            border:
                                                            OutlineInputBorder(),
                                                            focusedBorder:
                                                            OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          try {
                                                            doc.reference
                                                                .update({
                                                              StringManager
                                                                  .size:
                                                              '${_editSize
                                                                  .text}cm',
                                                            });
                                                          } catch (e) {
                                                            showDialog(
                                                              context: context,
                                                              builder: (
                                                                  context) {
                                                                return kSnackBar;
                                                              },
                                                            );
                                                          }

                                                          _editSize.clear();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                          Colors.black,
                                                        ),
                                                        child: const Text(
                                                          StringManager.save,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            'N\$${doc[StringManager.price]}',
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      StringManager.changePrice,
                                                    ),
                                                    actions: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(
                                                          PaddingManager.p_8,
                                                        ),
                                                        child: TextField(
                                                          controller:
                                                          _editPrice,
                                                          decoration:
                                                          const InputDecoration(
                                                            border:
                                                            OutlineInputBorder(),
                                                            focusedBorder:
                                                            OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          try {
                                                            doc.reference
                                                                .update({
                                                              StringManager
                                                                  .price:
                                                              '${_editPrice
                                                                  .text}.00',
                                                            });
                                                          } catch (e) {
                                                            showDialog(
                                                              context: context,
                                                              builder: (
                                                                  context) {
                                                                return kSnackBar;
                                                              },
                                                            );
                                                          }
                                                          _editPrice.clear();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                          ColorManager
                                                              .black,
                                                        ),
                                                        child: const Text(
                                                          StringManager.save,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: () {
                                              if (doc[StringManager
                                                  .stockLowercase] ==
                                                  ValueManager.v_0) {
                                                doc.reference.update({
                                                  StringManager.stockLowercase:
                                                  ValueManager.v_0,
                                                });
                                              } else {
                                                try {
                                                  doc.reference.update({
                                                    StringManager
                                                        .stockLowercase:
                                                    doc[StringManager
                                                        .stockLowercase] -
                                                        ValueManager.v_1,
                                                  });
                                                } catch (e) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return const SnackBar(
                                                        content: Text(
                                                            'An error occurred'),
                                                      );
                                                    },
                                                  );
                                                }
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.remove,
                                            ),
                                          ),
                                          Text(
                                            '${doc[StringManager
                                                .stockLowercase]} in Stock',
                                            style: TextStyle(
                                              fontSize:
                                              mediaQuery.textScaleFactor *
                                                  FontSizeManager.f_16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              try {
                                                doc.reference.update({
                                                  StringManager.stockLowercase:
                                                  doc[StringManager
                                                      .stockLowercase] +
                                                      ValueManager.v_1,
                                                });
                                              } catch (e) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return kSnackBar;
                                                  },
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
