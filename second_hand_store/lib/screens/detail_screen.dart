import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_hand_store/models/sanpham.dart';

// ignore: must_be_immutable
class DetailScreen extends StatelessWidget {
  DetailScreen({super.key, required this.sanphams});
  List arrImage = [
    "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
    "https://us.123rf.com/450wm/dmitryag/dmitryag2105/dmitryag210506008/174519729-woman-outdoors-photographer-landscape-travel-professional-recreation.jpg?ver=6",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPCXISA7AWonO3J24GKCgtJ9e4OTuaJHSBM7rcN3j28GfR6eJAJTe1Gi_AlJpG6wuFnCs&usqp=CAU"
  ];

  // ignore: unused_field
  final int _currentPosition = 0;
  final SanPham sanphams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: imageSlider(
                    arrImage: sanphams.imageArr!,
                    onClickBack: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/avatar.png'),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    sanphams.nguoidung!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${sanphams.gia} vnđ',
                                style: const TextStyle(fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          sanphams.tenSanpham!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text.rich(
                          TextSpan(
                              text: 'Danh mục: ',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: sanphams.danhmuc,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text.rich(
                          TextSpan(
                              text: 'Tình trạng / Mô tả: ',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: sanphams.moTa,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                onPressed: () {},
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Liên hệ người bán',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      CupertinoIcons.chevron_right_2,
                      color: Colors.white,
                    )
                  ],
                )),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

class imageSlider extends StatefulWidget {
  const imageSlider({
    super.key,
    required this.arrImage,
    this.onClickBack,
  });

  final List arrImage;
  final Function? onClickBack;

  @override
  State<imageSlider> createState() => _imageSliderState();
}

class _imageSliderState extends State<imageSlider> {
  int _currentSlide = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.arrImage.length,
          itemBuilder: (BuildContext context, int index, int pageViewIndex) {
            return Image.network(
              widget.arrImage[index],
              fit: BoxFit.cover,
            );
          },
          options: CarouselOptions(
            height: double.infinity,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            initialPage: 0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentSlide = index;
              });
            },
            // autoPlay: true,
            // autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 10,
          child: DotsIndicator(
            dotsCount: widget.arrImage.length,
            position: _currentSlide,
            axis: Axis.vertical,
            reversed: false,
            decorator: const DotsDecorator(
              color: Colors.white,
              activeColor: Colors.orange,
            ),
          ),
        ),
        Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.black.withOpacity(0.6),
              child: IconButton(
                  onPressed: () {
                    widget.onClickBack?.call();
                  },
                  icon: const Icon(
                    CupertinoIcons.chevron_back,
                    size: 26,
                    color: Colors.white,
                  )),
            ))
      ],
    );
  }
}
