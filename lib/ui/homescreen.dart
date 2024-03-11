import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fakestore/bloc/mainbloc.dart';
import 'package:fakestore/keep/localstorage.dart';
import 'package:fakestore/ui/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    callFun();
    super.initState();
  }

  callFun() async {
    BlocProvider.of<MainBloc>(context).limit = 10;
    BlocProvider.of<MainBloc>(context).add(GetCourseDetails());
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 226, 226),
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Colors.black,
        ),
        centerTitle: true,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/academylogo.jpg"),
              radius: 15,
              backgroundColor: Colors.grey,
            ),
            onLongPress: () {
              LocalStorage.clearAll();
            },
          ),
          const Padding(
            padding: EdgeInsets.only(left: 3.0),
            child:
                Text("academy", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ]),
      ),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Showing ${context.read<MainBloc>().totalcount} Courses",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                _productlist(context)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _productlist(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      buildWhen: (previous, current) =>
          current is FetchingData ||
          current is CourseDetailsSuccess ||
          current is CourseDetailsFailed ||
          current is GettingMoreUnits ||
          current is MoreUnitsFetched ||
          current is PaginationFailed,
      builder: (context, state) {
        if (state is FetchingData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 1,
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  ))),
            ],
          );
        }
        return Column(
          children: [
            context.read<MainBloc>().courseListModellist == null
                ? _shimmer()
                : context.read<MainBloc>().courseListModellist.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "No Data Found",
                              style: TextStyle(
                                  color: Color(0xff244E82),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: List.generate(
                            context.read<MainBloc>().courseListModellist.length,
                            (index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 6.0, left: 8, right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(22.0),
                                    child: SizedBox(
                                        height: Helper.height(context) / 7.5,
                                        width: Helper.width(context) / 5.5,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: CachedNetworkImage(
                                            fadeInCurve: Curves.ease,
                                            fadeInDuration:
                                                const Duration(milliseconds: 0),
                                            fit: BoxFit.cover,
                                            filterQuality: FilterQuality.low,
                                            memCacheHeight: 450,
                                            progressIndicatorBuilder:
                                                (context, url, progress) {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[200]!,
                                                highlightColor: Colors.white,
                                                child: Container(
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                            imageUrl: context
                                                .read<MainBloc>()
                                                .courseListModellist[index]
                                                .image
                                                .toString(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              'lib/assets/images/noimag.png',
                                            ),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 9),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: Helper.width(context) / 2,
                                          child: Text(
                                              "${context.read<MainBloc>().courseListModellist[index].title}:${context.read<MainBloc>().courseListModellist[index].category}"),
                                        ),
                                        const Text("John Doe",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors
                                                              .white, // Set border color
                                                          width:
                                                              .1), // Set border width
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  0.0)), // Set rounded corner radius
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          blurRadius: .5,
                                                          color: Colors.white,
                                                          // offset: Offset(1, 3)
                                                        )
                                                      ] // Make rounded corner of border
                                                      ),
                                                  width: 100,
                                                  // color: Colors.grey,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: IgnorePointer(
                                                      child: RatingBar.builder(
                                                          initialRating: double.parse(context
                                                              .read<MainBloc>()
                                                              .courseListModellist[
                                                                  index]
                                                              .rating!
                                                              .rate
                                                              .toString()),
                                                          itemSize: 16,
                                                          minRating: 1,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          itemPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      0.0),
                                                          itemBuilder: (context,
                                                                  _) =>
                                                              const Icon(
                                                                  Icons.star,
                                                                  color: Color(
                                                                      0xffFFCC00)),
                                                          onRatingUpdate:
                                                              (rating) {}),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    "(${context.read<MainBloc>().courseListModellist[index].rating!.rate})"),
                                                SizedBox(
                                                    width:
                                                        Helper.width(context) /
                                                            39),
                                                Text(
                                                    "(${context.read<MainBloc>().courseListModellist[index].rating!.count})"),
                                              ],
                                            ),
                                            SizedBox(
                                                width:
                                                    Helper.width(context) / 10),
                                            // const Spacer(),
                                            Text(
                                                '\$${context.read<MainBloc>().courseListModellist[index].price.toString()}')
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
            BlocBuilder<MainBloc, MainState>(
                buildWhen: (previous, current) =>
                    current is GettingMoreUnits ||
                    current is MoreUnitsFetched ||
                    current is PaginationFailed,
                builder: ((context, state) {
                  if (state is GettingMoreUnits) {
                    return const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text("Loading...",
                          style: TextStyle(
                              color: Color.fromARGB(255, 31, 34, 39),
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    );
                  }
                  return const SizedBox.shrink();
                }))
          ],
        );
      },
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      log('load more called');
      BlocProvider.of<MainBloc>(context).add(LoadMoreProduct());
    }
  }

  _shimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!, // Replace with your desired base color
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: List.generate(10, (index) {
              return InkWell(
                child: Card(
                  color: const Color.fromARGB(255, 225, 225, 225),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 2,
                          ),
                          SizedBox(
                              height: Helper.height(context) / 6.6,
                              width: Helper.width(context) / 3.6,
                              child: Image.asset(
                                  "assets/images/academylogo.jpg",
                                  height: 10)),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 20.0, right: 19.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: Helper.height(context) / 70,
                                ),
                                const Text(
                                  "",
                                  style: TextStyle(
                                      color: Color(0xff898989),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, top: 25.0, right: 10.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 238, 238),
                                  radius: 20,
                                  child: Icon(Icons.call,
                                      color: Color(0xff375F96), size: 25),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // Helper.push(context, const FamilyDetailed());
                },
              );
            }),
          ),
        ));
  }
}
