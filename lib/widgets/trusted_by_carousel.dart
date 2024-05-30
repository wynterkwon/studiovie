import 'dart:async';

import 'package:com.design.studiovie/screens/partners_list_screen.dart';
import 'package:com.design.studiovie/viewmodels/gallery_vm.dart';
import 'package:flutter/material.dart';
import 'package:com.design.studiovie/constants/contents.dart';
import 'package:provider/provider.dart';

class TrustedByCarousel extends StatefulWidget {
  Future<List<String>> getPartners;
  TrustedByCarousel({super.key, required this.getPartners});

  @override
  State<TrustedByCarousel> createState() => _TrustedByCarouselState();
}

class _TrustedByCarouselState extends State<TrustedByCarousel> {
  final ScrollController _controller = ScrollController();
  late Timer _timer;
  int currentItem = 0;
  double get _itemExtent {
    return partners.length * 20;
  }

  void startAutoPlay(int itemCount) {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (currentItem < itemCount - 1) {
        currentItem++;
      } else {
        currentItem = 0;
      }
      _controller.animateTo(currentItem * _itemExtent,
          duration: Duration(milliseconds: 5000), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.getPartners,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return AlertDialog(
            content: Text('Something went wrong'),
          );
        } else {
          if (snapshot.hasData) {
            startAutoPlay(snapshot.data!.length * 200);
            return ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              // itemCount: partners.length,
              itemCount: snapshot.data!.length * 200,
              itemBuilder: ((context, index) {
                final partnerIndex = index % snapshot.data!.length;
                // print('partner index : $partnerIndex');
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      await context
                          .read<GalleryViewModel>()
                          .searchGallery(partners[partnerIndex]);
                      Future.delayed(
                        Duration(milliseconds: 200),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PartnerGalleryScreen(
                                  query: partners[partnerIndex]);
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(snapshot.data![partnerIndex])),
                  ),
                );
              }),
            );
          }
          return SizedBox.shrink();
        }
      },
    );
  }
}
