library paginationList;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef PaginationBuilder<T> = Future<List<T>> Function(int currentListSize);

class PaginationList<T> extends StatefulWidget {
  const PaginationList({
    Key key,
    @required this.itemBuilder,
    @required this.onError,
    @required this.onEmpty,
    @required this.pageFetch,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.padding = const EdgeInsets.all(0),
    this.initialData = const [],
    this.physics,
    this.separatorWidget = const SizedBox(height: 0, width: 0),
    this.onPageLoading = const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(
          height: 25,
          width: 25,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            backgroundColor: Colors.amber,
          ),
        ),
      ),
    ),
    this.onLoading = const SizedBox(
      height: 25,
      width: 25,
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        backgroundColor: Colors.amber,
      ),
    ),
  }) : super(key: key);

  final Axis scrollDirection;
  final bool shrinkWrap;
  final EdgeInsets padding;
  final List<T> initialData;
  final PaginationBuilder<T> pageFetch;
  final ScrollPhysics physics;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget onEmpty;
  final Widget Function(dynamic) onError;
  final Widget separatorWidget;
  final Widget onPageLoading;
  final Widget onLoading;

  @override
  _PaginationListState<T> createState() => _PaginationListState<T>();
}

Widget Img() {
  return new Image(
    image: AssetImage("assets/loadingRainbow.gif"),
    height: 25,
    width: 25,
  );
}

class _PaginationListState<T> extends State<PaginationList<T>>
    with AutomaticKeepAliveClientMixin<PaginationList<T>> {
  final List<T> _itemList = <T>[];
  dynamic _error;
  final StreamController<PageState> _streamController =
      StreamController<PageState>();

  @override
  void initState() {
    _itemList.addAll(widget.initialData);
    if (widget.initialData.length > 0) _itemList.add(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<PageState>(
      stream: _streamController.stream,
      initialData:
          (_itemList.length == 0) ? PageState.firstLoad : PageState.pageLoad,
      builder: (BuildContext context, AsyncSnapshot<PageState> snapshot) {
        if (!snapshot.hasData) {
          return widget.onLoading;
        }
        if (snapshot.data == PageState.firstLoad) {
          fetchPageData();
          return widget.onLoading;
        }
        if (snapshot.data == PageState.firstEmpty) {
          return widget.onEmpty;
        }
        if (snapshot.data == PageState.firstError) {
          return widget.onError(_error);
        }
        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            if (_itemList[index] == null &&
                snapshot.data == PageState.pageLoad) {
              fetchPageData(offset: index);
              return widget.onPageLoading;
            }
            if (_itemList[index] == null &&
                snapshot.data == PageState.pageError) {
              return widget.onError(_error);
            }
            return widget.itemBuilder(
              context,
              _itemList[index],
            );
          },
          shrinkWrap: widget.shrinkWrap,
          scrollDirection: widget.scrollDirection,
          physics: widget.physics,
          padding: widget.padding,
          itemCount: _itemList.length,
          separatorBuilder: (BuildContext context, int index) =>
              widget.separatorWidget,
        );
      },
    );
  }

  void fetchPageData({int offset = 0}) {
    widget.pageFetch(offset - widget.initialData.length).then(
      (List<T> list) {
        if (_itemList.contains(null)) {
          _itemList.remove(null);
        }
        list = list ?? <T>[];
        if (list.isEmpty) {
          if (offset == 0) {
            _streamController.add(PageState.firstEmpty);
          } else {
            _streamController.add(PageState.pageEmpty);
          }
          return;
        }

        _itemList.addAll(list);
        _itemList.add(null);
        _streamController.add(PageState.pageLoad);
      },
      onError: (dynamic _error) {
        this._error = _error;
        if (offset == 0) {
          _streamController.add(PageState.firstError);
        } else {
          if (!_itemList.contains(null)) {
            _itemList.add(null);
          }
          _streamController.add(PageState.pageError);
        }
      },
    );
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

enum PageState {
  pageLoad,
  pageError,
  pageEmpty,
  firstEmpty,
  firstLoad,
  firstError,
}
