// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/models/danhmuc.dart';
import 'package:second_hand_store/provider/product_provider.dart';
import 'package:second_hand_store/screens/detail_screen.dart';
import 'package:second_hand_store/utils/colors.dart';
import 'package:second_hand_store/utils/push_screen.dart';
import 'package:second_hand_store/utils/show_toast.dart';

import '../../provider/category_provider.dart';

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
      //Lấy dữ liệu của toàn bộ sản phẩm qua provider
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.getAllProduct(page: page, limit: 5);
      //Lấy dữ liệu của toàn bộ danh mục qua provider
      final providerCategory =
          Provider.of<CategoryProvider>(context, listen: false);
      providerCategory.getAll();
    });
    //sử dụng _scrollController.addListener(() => scrollListener(context)); để lắng nghe sự kiện lần đầu ở initState
    _scrollController.addListener(() => scrollListener(context));
  }

//Hàm xử lý khi cuộn tới cuối
  Future<void> scrollListener(BuildContext context) async {
//Khi đi đến cuối trang sẽ gọi hàm load page
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      //gọi provider để lấy tổng số trang
      final provider = Provider.of<ProductProvider>(context, listen: false);
      // if (isLoadingMore) return;
      page = page + 1;
      if (page <= provider.totalPage) {
        setState(() {
          isLoadingMore = true;
        });
        await provider.getAllProduct(page: page, limit: 5);
        log("Load Page: $page");

        setState(() {
          isLoadingMore = false;
        });
      } else {
        showSnackbar(context, "Không còn sản phẩm nào",
            const Color.fromARGB(255, 9, 177, 104));
      }
    }
  }

  @override
  void dispose() {
    //dispose controller
    _scrollController.dispose();
    super.dispose();
  }

  List listImageSale = [
    "https://previews.123rf.com/images/alhovik/alhovik1606/alhovik160600012/58062462-special-offer-super-sale-banner-design-template-big-super-sale-save-up-to-50.jpg",
    "https://c8.alamy.com/comp/2BTR1PF/sale-banner-template-design-super-sale-special-offer-poster-placard-web-banner-designs-vector-illustration-2BTR1PF.jpg",
    "https://img.freepik.com/free-vector/flash-sale-discount-banner-design-vector-illustration_1017-38420.jpg?w=2000",
    "https://img.freepik.com/premium-psd/big-sale-modern-banner-promotional-template_501916-457.jpg?w=2000"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              onPressed: () {
                showSnackbar(context, "Chức năng đang phát triển!",
                    const Color.fromARGB(255, 9, 177, 104));
              },
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
        child: RefreshIndicator(
          onRefresh: () async {
            final provider =
                Provider.of<ProductProvider>(context, listen: false);
            return Future<void>.delayed(const Duration(milliseconds: 500), () {
              log("reFresh");
              provider.getAllProduct(page: 1, limit: 5);
              page = 1;
            });
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                listViewSale(listImageSale: listImageSale),
                listViewCategory(
                    danhmuc:
                        Provider.of<CategoryProvider>(context, listen: false)
                            .danhmucs),
                Container(
                  height: 8,
                  width: double.infinity,
                  color: lineColor,
                ),
                viewProductHorizontal(
                  products: Provider.of<ProductProvider>(context, listen: true)
                      .sanphams,
                  title: "Sản phẩm mới nhất 🤘",
                  onClickTitle: () {
                    showToast("Chưa xây dựng chức năng", Colors.red);
                  },
                ),
                Container(
                  height: 8,
                  width: double.infinity,
                  color: lineColor,
                ),
                viewProductHorizontal(
                  products: Provider.of<ProductProvider>(context, listen: true)
                      .sanphams,
                  title: "Lượt xem cao nhất ⚡",
                  onClickTitle: () {
                    showToast("Chưa xây dựng chức năng", Colors.red);
                  },
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                              mainAxisExtent: 280,
                            ),
                            itemCount: isLoadingMore
                                ? value.sanphams.length + 1
                                : value.sanphams.length,
                            itemBuilder: (context, index) {
                              if (index < value.sanphams.length) {
                                return Container(
                                  margin: const EdgeInsets.all(8),
                                  child: InkWell(
                                    onTap: () {
                                      // final provider =
                                      //     Provider.of<HideBottomNavProvider>(
                                      //         context,
                                      //         listen: false);
                                      // provider.hideBottomNav();

                                      pushScreen(
                                        context,
                                        DetailScreen(
                                            sanphams: value.sanphams[index],
                                            saleOrEdit: true),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Builder(builder: (context) {
                                              return SizedBox(
                                                height: 200,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    '${dotenv.env["URL_IMAGE"]}${value.sanphams[index].imageArr![0]}',
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
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: const BoxDecoration(
                                                  color: Colors.black87,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Text(
                                                  value
                                                      .sanphams[index].danhmuc!,
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
                                            value.sanphams[index].gia
                                                .toString(),
                                          ),
                                        ),
                                      ],
                                    ),
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
      ),
    );
  }
}

class viewProductHorizontal extends StatelessWidget {
  final List products;
  final String title;
  final Function? onClickTitle;

  const viewProductHorizontal({
    super.key,
    required this.products,
    required this.title,
    this.onClickTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 26, bottom: 26),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  onClickTitle?.call();
                },
                child: const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Điều chỉnh canh giữa
                  children: [
                    // Biểu tượng
                    Text("Xem tất cả"), // Nhãn
                    SizedBox(width: 4), // Khoảng cách giữa biểu tượng và nhãn
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
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      pushScreen(
                        context,
                        DetailScreen(
                            sanphams: products[index], saleOrEdit: true),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.6,
                              // height: MediaQuery.of(context).size.height * 0.2,
                              width: 300,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  '${dotenv.env["URL_IMAGE"]}${products[index].imageArr[0]}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
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
                                  products[index].danhmuc,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            "${products[index].gia} vnđ",
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class listViewCategory extends StatelessWidget {
  const listViewCategory({
    super.key,
    required this.danhmuc,
  });

  final List<DanhMuc> danhmuc;

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
        itemCount: danhmuc.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 34,
                backgroundImage: NetworkImage(
                    'https://icons.veryicon.com/png/o/construction-tools/engineering-physics-color-icon/electronics.png'),
              ),
              Text(
                danhmuc[index].tenDanhmuc!,
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
