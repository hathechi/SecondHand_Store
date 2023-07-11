// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/provider/product_provider.dart';
import 'package:second_hand_store/utils/colors.dart';
import 'package:second_hand_store/utils/show_toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //controller khi scroll trang
  final _scrollController = ScrollController();
  //page đầu tiên bằng 1
  int page = 1;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.getAllProduct(page);
    });
    //sử dụng _scrollController.addListener(() => scrollListener(context)); để lắng nghe sự kiện lần đầu ở initState
    _scrollController.addListener(() => scrollListener(context));
  }

//Hàm xử lý khi cuộn tới cuối
  Future<void> scrollListener(BuildContext context) async {
//Khi đi đến cuối trang sẽ gọi hàm load page
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      // if (isLoadingMore) return;

      page = page + 1;
      if (page <= provider.totalPage) {
        setState(() {
          isLoadingMore = true;
        });
        await provider.getAllProduct(page);
        log("Load Page: $page");

        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollController as VoidCallback);
    super.dispose();
  }

  List listImageSale = [
    "https://previews.123rf.com/images/alhovik/alhovik1606/alhovik160600012/58062462-special-offer-super-sale-banner-design-template-big-super-sale-save-up-to-50.jpg",
    "https://c8.alamy.com/comp/2BTR1PF/sale-banner-template-design-super-sale-special-offer-poster-placard-web-banner-designs-vector-illustration-2BTR1PF.jpg",
    "https://img.freepik.com/free-vector/flash-sale-discount-banner-design-vector-illustration_1017-38420.jpg?w=2000",
    "https://img.freepik.com/premium-psd/big-sale-modern-banner-promotional-template_501916-457.jpg?w=2000"
  ];

  List<Category> category = [
    Category(
        urlImage:
            "https://antimatter.vn/wp-content/uploads/2022/11/hinh-anh-gai-xinh-viet-nam-17-tuoi-cute-nhat.jpg",
        title: "Title 1"),
    Category(
        urlImage:
            "https://cdn.24h.com.vn/upload/1-2022/images/2022-03-16/baukrysie_275278910_3174792849424333_1380029197326773703_n-1647427653-670-width1440height1800.jpg",
        title: "Title 2"),
    Category(
        urlImage:
            "https://genk.mediacdn.vn/2020/1/7/photo-1-1578368300431366420427.jpg",
        title: "Title 3"),
    Category(
        urlImage:
            "https://thuthuatnhanh.com/wp-content/uploads/2019/07/anh-girl-xinh-hoc-duong-viet-nam.jpg",
        title: "Title 4"),
    Category(
        urlImage:
            "https://haycafe.vn/wp-content/uploads/2022/10/Hinh-anh-gai-xinh-Viet-Nam-cuoi-tuoi-tan.jpg",
        title: "Title 5"),
    Category(
        urlImage:
            "https://antimatter.vn/wp-content/uploads/2022/11/hinh-anh-gai-xinh-viet-nam-17-tuoi-cute-nhat.jpg",
        title: "Title 6"),
    Category(
        urlImage:
            "https://genk.mediacdn.vn/2020/1/7/photo-1-1578368300431366420427.jpg",
        title: "Title 7"),
    Category(
        urlImage:
            "https://antimatter.vn/wp-content/uploads/2022/11/hinh-anh-gai-xinh-viet-nam-17-tuoi-cute-nhat.jpg",
        title: "Title 1"),
    Category(
        urlImage:
            "https://cdn.24h.com.vn/upload/1-2022/images/2022-03-16/baukrysie_275278910_3174792849424333_1380029197326773703_n-1647427653-670-width1440height1800.jpg",
        title: "Title 2"),
    Category(
        urlImage:
            "https://genk.mediacdn.vn/2020/1/7/photo-1-1578368300431366420427.jpg",
        title: "Title 3"),
    Category(
        urlImage:
            "https://thuthuatnhanh.com/wp-content/uploads/2019/07/anh-girl-xinh-hoc-duong-viet-nam.jpg",
        title: "Title 4"),
    Category(
        urlImage:
            "https://haycafe.vn/wp-content/uploads/2022/10/Hinh-anh-gai-xinh-Viet-Nam-cuoi-tuoi-tan.jpg",
        title: "Title 5"),
    Category(
        urlImage:
            "https://antimatter.vn/wp-content/uploads/2022/11/hinh-anh-gai-xinh-viet-nam-17-tuoi-cute-nhat.jpg",
        title: "Title 6"),
    Category(
        urlImage:
            "https://genk.mediacdn.vn/2020/1/7/photo-1-1578368300431366420427.jpg",
        title: "Title 7"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Timeless",
          style: GoogleFonts.kalam(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.bag,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: primaryColor,
        height: double.infinity,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              listViewSale(listImageSale: listImageSale),
              listViewCategory(category: category),
              Container(
                height: 8,
                width: double.infinity,
                color: lineColor,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Sản phẩm mới nhất 🤘",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            showToast("Chưa xây dựng chức năng", Colors.red);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Điều chỉnh canh giữa
                            children: [
                              // Biểu tượng
                              Text("Xem tất cả"), // Nhãn
                              SizedBox(
                                  width:
                                      4), // Khoảng cách giữa biểu tượng và nhãn
                              Icon(CupertinoIcons.forward),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 280,
                      // height: MediaQuery.of(context).size.height * 0.28,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: listImageSale.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          listImageSale[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          "Hơi nát",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: const Text(
                                    "120.000đ",
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 8,
                width: double.infinity,
                color: lineColor,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Lượt xem cao nhất ⚡",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            showToast("Chưa xây dựng chức năng", Colors.red);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Điều chỉnh canh giữa
                            children: [
                              // Biểu tượng
                              Text("Xem tất cả"), // Nhãn
                              SizedBox(
                                  width:
                                      4), // Khoảng cách giữa biểu tượng và nhãn
                              Icon(CupertinoIcons.forward),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 280,
                      // height: MediaQuery.of(context).size.height * 0.28,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          category[index].urlImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          category[index].title,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: const Text(
                                    "120.000đ",
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 8,
                width: double.infinity,
                color: lineColor,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hót hòn họt 🚀",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      // height: MediaQuery.of(context).size.height * 0.28,
                      child: Consumer<ProductProvider>(
                          builder: (context, value, child) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 250,
                          ),
                          itemCount: isLoadingMore
                              ? value.sanphams.length + 1
                              : value.sanphams.length,
                          itemBuilder: (context, index) {
                            if (index < value.sanphams.length) {
                              return Container(
                                margin: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Builder(builder: (context) {
                                          return SizedBox(
                                            // width: MediaQuery.of(context)
                                            //         .size
                                            //         .width *
                                            //     0.6,
                                            // height: MediaQuery.of(context)
                                            //         .size
                                            //         .height *
                                            //     0.2,
                                            height: 200,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                value.sanphams[index]
                                                        .imageArr![0] ??
                                                    "https://cdn.24h.com.vn/upload/1-2022/images/2022-03-16/baukrysie_275278910_3174792849424333_1380029197326773703_n-1647427653-670-width1440height1800.jpg",
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            ),
                                          );
                                        }),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              value.sanphams[index].danhmuc!,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        value.sanphams[index].gia.toString(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const Align(
                                alignment: Alignment.bottomCenter,
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              );
                            }
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class listViewCategory extends StatelessWidget {
  const listViewCategory({
    super.key,
    required this.category,
  });

  final List<Category> category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          mainAxisExtent: 120,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: category.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 34,
                backgroundImage: NetworkImage(category[index].urlImage),
              ),
              Text(
                category[index].title,
              ),
            ],
          );
        },
      ),
    );
  }
}

class listViewSale extends StatelessWidget {
  const listViewSale({
    super.key,
    required this.listImageSale,
  });

  final List listImageSale;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: listImageSale.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          InkWell(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image.network(
              listImageSale[itemIndex],
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
        ),
      ),
      options: CarouselOptions(
        height: 300.0,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
      ),
    );
  }
}

class Category {
  var urlImage;
  var title;
  Category({
    required this.urlImage,
    required this.title,
  });
}
