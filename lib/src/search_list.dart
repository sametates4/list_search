import 'package:flutter/material.dart';

class SearchList<T> extends StatefulWidget {
  const SearchList({
    super.key,
    required this.builder,
    required this.list,
    this.fieldDecoration = const InputDecoration(hintText: 'Search', border: OutlineInputBorder()),
    this.search,
    this.isFieldShow = true,
    this.physics,
    this.searchEmptyWidget = const Center(child: Text('No Result')),
  });

  final List<T> list;
  final Widget searchEmptyWidget;
  final bool isFieldShow;
  final ScrollPhysics? physics;
  final Widget Function(T value, int index) builder;
  final InputDecoration? fieldDecoration;
  final List<T> Function(String query)? search;

  @override
  State<SearchList<T>> createState() => _SearchListState<T>();
}

class _SearchListState<T> extends State<SearchList<T>> {
  late ValueNotifier<List<T>> filteredListNotifier;

  @override
  void initState() {
    super.initState();
    filteredListNotifier = ValueNotifier<List<T>>(widget.list);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.isFieldShow
            ? TextField(
          onChanged: (value) => searchList(value),
          decoration: widget.fieldDecoration,
        )
            : Container(),
        SizedBox(height: widget.isFieldShow == true ? 10 : 0),
        Expanded(
          child: ValueListenableBuilder<List<T>>(
            valueListenable: filteredListNotifier,
            builder: (context, filteredList, _) {
              return filteredList.isEmpty
                  ? widget.searchEmptyWidget
                  : ListView.builder(
                physics: widget.physics,
                itemCount: filteredList.length,
                itemBuilder: (context, index) =>
                    widget.builder(filteredList[index], index),
              );
            },
          ),
        ),
      ],
    );
  }

  void searchList(String value) {
    List<T> tempList = widget.search!(value);
    filteredListNotifier.value = tempList;
  }
}