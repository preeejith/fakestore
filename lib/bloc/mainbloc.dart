import 'dart:async';
import 'dart:developer';

import 'package:fakestore/keep/localstorage.dart';
import 'package:fakestore/models/courselistmodel.dart';
import 'package:fakestore/server/serverhelper.dart';
import 'package:fakestore/ui/authentication/firebase_auth.dart';
import 'package:fakestore/ui/common/initializer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  List<CourseListModel> courseListModellist = [];
  CourseListModel courseListModel = CourseListModel();
  List<CourseListModel> morecourseListModellist = [];
  CourseListModel morecourseListModel = CourseListModel();
  int? totalcount = 0;
  int? limit = 10;
  var data;
  List items = [];
  MainBloc() : super(MainState()) {
    on<SignIn>(signIn);
    on<GetCourseDetails>(getCourseDetails);
    on<LoadMoreProduct>(loadMoreProduct);
  }

  Future<FutureOr<void>> signIn(SignIn event, Emitter<MainState> emit) async {
    final FirebaseAuthService auth = FirebaseAuthService();
    try {
      emit(Loading());

      User? user = await auth.signInWithEmailAndPassword(
          Initializer.email.text.toString(), Initializer.password.text);
      if (user != null) {
        LocalStorage.setIsloggedIn(true);
        emit(SigninSuccess());
      } else {
        Fluttertoast.showToast(msg: "Oops... something went wrong:");

        emit(SigInFailed());
      }
    } catch (e) {
      log("Oops... something went wrong: $e");

      emit(SigInFailed());
      log("Exception on authentication : $e");
    }
  }

  Future<FutureOr<void>> getCourseDetails(
      GetCourseDetails event, Emitter<MainState> emit) async {
    try {
      emit(FetchingData());
      data = await ServerHelper.get(
        '/products?limit=$limit',
      );
      totalcount = data.length;
      for (int i = 0; i < data.length; i++) {
        log(data.length.toString() + i.toString());
        courseListModel = CourseListModel(
            id: data[i]['id'],
            price: data[i]['price'],
            category: data[i]['category'],
            image: data[i]['image'],
            rating: Rating(
                count: data[i]['rating']['count'],
                rate: data[i]['rating']['rate']),
            title: data[i]['title'],
            description: data[i]['description']);

        courseListModellist.add(courseListModel);
      }
      if (courseListModellist.isNotEmpty) {
        emit(CourseDetailsSuccess());
      } else {
        emit(CourseDetailsFailed());
      }
    } catch (e) {
      log("Oops... something went wrong: $e");

      emit(OperationCountFailed());
      log("Exception on authentication : $e");
    }
  }

  FutureOr<void> loadMoreProduct(
      LoadMoreProduct event, Emitter<MainState> emit) async {
    try {
      if (state is! GettingMoreUnits) {
        emit(GettingMoreUnits());
        limit = limit! + 5;
        data = await ServerHelper.get(
          '/products?limit=$limit',
        );
        totalcount = data.length;
        for (int i = 0; i < data.length; i++) {
          log(data.length.toString() + i.toString());
          morecourseListModel = CourseListModel(
              id: data[i]['id'],
              price: data[i]['price'],
              category: data[i]['category'],
              image: data[i]['image'],
              rating: Rating(
                  count: data[i]['rating']['count'],
                  rate: data[i]['rating']['rate']),
              title: data[i]['title'],
              description: data[i]['description']);

          morecourseListModellist.add(morecourseListModel);
        }
        if (morecourseListModellist.isNotEmpty) {
          courseListModellist.clear();
          courseListModellist.addAll(morecourseListModellist);
          emit(MoreUnitsFetched());
        } else {
          emit(PaginationFailed());
        }
      } else {
        log("please wait, fetching more data");
      }
    } catch (e) {
      emit(PaginationFailed());
    }
  }
}

class MainEvent {}

class MainState {}

class StartHome extends MainEvent {}

class FetchingData extends MainState {}

class Loading extends MainState {}

class GettingMoreUnits extends MainState {}

class CourseDetailsSuccess extends MainState {}

class SigninSuccess extends MainState {}

class CourseDetailsFailed extends MainState {}

class MoreUnitsFetched extends MainState {}

class SigInFailed extends MainState {}

class PaginationFailed extends MainState {}

class OperationCountFailed extends MainState {}

class LoadMoreProduct extends MainEvent {
  final int? page, count;
  final String? dist;
  final String? lat, lon;

  LoadMoreProduct({this.count, this.page, this.lat, this.lon, this.dist});
}

class GetCourseDetails extends MainEvent {
  final String? name;
  GetCourseDetails({
    this.name,
  });
}

class SignIn extends MainEvent {
  final String? email;
  final String? password;
  SignIn({this.email, this.password});
}
