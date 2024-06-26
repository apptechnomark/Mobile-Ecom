/// Product details screen 
/// includes product image, product name, sizes, rating, price, short description 
/// favourite toggle icon, buy now button, add to cart button

import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_e_commerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_e_commerce_app/models/cart.dart';
import 'package:nineteenfive_e_commerce_app/models/product.dart';
import 'package:nineteenfive_e_commerce_app/models/product_rating.dart';
import 'package:nineteenfive_e_commerce_app/utils/color_palette.dart';
import 'package:nineteenfive_e_commerce_app/utils/constants.dart';
import 'package:nineteenfive_e_commerce_app/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_e_commerce_app/widgets/cards/size_card.dart';
import 'package:nineteenfive_e_commerce_app/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_e_commerce_app/widgets/image/image_network.dart';

import '../../utils/data/static_data.dart';

class ItemDetails extends StatefulWidget {
  final Product product;
  final heroTag;

  ItemDetails(this.product, {this.heroTag});

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int selectedImage = 0;
  late ScrollController scrollController;
  late PageController pageController;
  bool isLiked = false;
  Uri? uri; 

  // Timer timerLink;
  bool addingToCart = false;

  double countRating() {
    double rating = 0;
    if (widget.product.productRatings == null ||
        widget.product.productRatings!.isEmpty) {
      return 5;
    } else {
      widget.product.productRatings!.forEach((ratingMapData) {
        rating += ratingMapData.rating;
      });
    }
    return rating / widget.product.productRatings!.length;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    pageController = PageController(initialPage: selectedImage);
    if (StaticData.userData.likedProducts == null) {
      StaticData.userData.likedProducts = [];
      isLiked = false;
    } else {
      isLiked =
          StaticData.userData.likedProducts!.contains(widget.product.productId);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
    pageController.dispose();
  }

  // Rating dialog 
  addRating() {
    double rating = 0;
    for (int i = 0; i < widget.product.productRatings!.length; i++) {
      if (widget.product.productRatings![i].userId ==
          StaticData.userData.userId) {
        rating = widget.product.productRatings![i].rating;
      }
    }
    showDialog(
        context: context,
        barrierColor: ColorPalette.black.withOpacity(0.2),
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: ImageNetwork(
                    imageUrl: widget.product.productImages.first,
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setWidth(80),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Rate This Product",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Tap a star to give your rating.',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            content: StatefulBuilder(builder: (context, setState) {
              return Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: RatingBar.builder(
                      itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: ColorPalette.yellow,
                          ),
                      allowHalfRating: true,
                      direction: Axis.horizontal,
                      glowColor: ColorPalette.yellow.withOpacity(0.1),

                      itemCount: 5,
                      itemSize: 35.sp,
                      initialRating: rating,
                      itemPadding: EdgeInsets.symmetric(horizontal: 8.sp,),
                      minRating: 1,
                      onRatingUpdate: (newRating){
                        setState.call((){rating = newRating;});
                      }));
            }),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.black),
                ),
              ),
              ElevatedButton(
                 style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.blue),
                onPressed: () => submitRating(rating),
                child: Text(
                  'Submit',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.black),
                ),
              )
            ],
          );
        });
  }
  
  submitRating(double rating) async {
    MyDialog.showLoading(context);
    bool contains = false;
    widget.product.productRatings!.forEach((element) {
      if (element.userId == StaticData.userData.userId) {
        element.rating = rating;
        contains = true;
      }
    });
    if (!contains) {
      widget.product.productRatings!.add(ProductRating(
          userId: StaticData.userData.userId,
          rating: rating,
          ratingTime: DateTime.now()));
    }

    await FirebaseDatabase.storeProduct(widget.product);
    Navigator.pop(context);
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: ScreenUtil().setWidth(25),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Product Details',
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                size: ScreenUtil().setWidth(25),
                color: isLiked ? ColorPalette.darkBlue : Colors.black,
              ),
              onPressed: () async {
                if (isLiked) {
                  StaticData.userData.likedProducts!
                      .remove(widget.product.productId);
                } else {
                  StaticData.userData.likedProducts!
                      .add(widget.product.productId);
                }
                await FirebaseDatabase.storeUserData(StaticData.userData);
                setState(() {
                  isLiked = !isLiked;
                });
              }),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(0.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                height: ScreenUtil().setHeight(530),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().radius(35))),
                child: Stack(
                  children: [
                    Hero(
                      tag: widget.heroTag ?? widget.product.productId,
                      child: PageView.builder(
                        itemCount: widget.product.productImages.length,
                        scrollDirection: Axis.horizontal,
                        controller: pageController,
                        onPageChanged: (value) {
                          if ((selectedImage > value || selectedImage >= 6) &&
                              widget.product.productImages.length > 1) {
                            scrollController.animateTo((value - 1) * 18.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeOutExpo);
                          }
                          setState(() {
                            selectedImage = value;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().radius(35)),
                                child: ImageNetwork(
                                  imageUrl: widget.product.productImages[index],
                                  fit: BoxFit.cover,
                                )),
                          );
                        },
                      ),
                    ),
                    if (widget.product.productImages.length > 1)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 8,
                          width: 125,
                          margin: EdgeInsets.only(bottom: 15),
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: scrollController,
                              scrollDirection: Axis.horizontal,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.product.productImages.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    pageController.animateToPage(index,
                                        duration: Duration(seconds: 2),
                                        curve: Curves.easeOutExpo);
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear,
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: index == selectedImage
                                            ? Colors.white
                                            : ColorPalette.white
                                                .withOpacity(0.5)),
                                    width: 8,
                                    height: 8,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 60,
                      right: 40,
                      child: InkWell(
                        onTap: () {
                          // addRating();
                        },
                        child: Container(
                            width: ScreenUtil().setWidth(40),
                            height: ScreenUtil().setWidth(40),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.star_border,
                              size: 24.sp,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 40,
                      child: InkWell(
                        onTap: () {
                          // createShareLink();
                        },
                        child: Container(
                            width: ScreenUtil().setWidth(40),
                            height: ScreenUtil().setWidth(40),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.share,
                              size: 24.sp,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 20, horizontal: ScreenUtil().setWidth(50)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product.productName,
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: Colors.black, fontSize: 22.sp)),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              Constants.currencySymbol +
                                  widget.product.productPrice.toString(),
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 1.5,
                                  fontSize: 32.sp),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            if (widget.product.productMrp != null)
                              Text(
                                Constants.currencySymbol +
                                    widget.product.productMrp.toString(),
                                style: GoogleFonts.openSans(
                                    color: ColorPalette.grey,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                    decoration: TextDecoration.lineThrough),
                              )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: ColorPalette.yellow,
                              size: 30.sp,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              countRating().toString(),
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  letterSpacing: 1.5,
                                  fontSize: 20.sp),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      children: List.generate(
                          widget.product.productSizes!.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizeCard(
                            size: widget.product.productSizes![index],
                            isSelected: false,
                          ),
                        );
                      }),
                    ),
                    if (widget.product.returnTime != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.history,
                              color: ColorPalette.darkGrey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              (widget.product.returnTime! + " Return Policy"),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: ColorPalette.darkGrey,
                                      letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      widget.product.productDescription,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.darkGrey,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(100),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: LongBlueButton(
                onPressed: () {
                  MyDialog.showMyDialog(context, "Payment gatway");
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Checkout(
                  //               widget.product,
                  //             )));
                },
                text: 'Buy Now',
              ),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  addingToCart = true;
                });
                if (StaticData.userData.cart == null) {
                  StaticData.userData.cart = [];
                }
                StaticData.userData.cart!.add(Cart(
                    productId: widget.product.productId,
                    productSize: widget.product.productSizes != null &&
                            widget.product.productSizes!.isNotEmpty
                        ? widget.product.productSizes!.first
                        : null,
                    numberOfItems: 1));
                await FirebaseDatabase.storeUserData(StaticData.userData);
                Future.delayed(Duration(seconds: 1)).then((value) {
                  setState(() {
                    addingToCart = false;
                  });
                });
              },
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.elasticInOut,
                height: ScreenUtil().setHeight(75),
                width: ScreenUtil().setWidth(70),
                padding: EdgeInsets.all(
                    ScreenUtil().setWidth(addingToCart ? 25 : 20)),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().radius(17)),
                    color: ColorPalette.lightGrey),
                child: Image.asset('assets/icons/shopping_cart.png'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
