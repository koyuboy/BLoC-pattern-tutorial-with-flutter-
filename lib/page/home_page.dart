import 'package:book_app/main.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../bloc/book_bloc.dart';
import '../models/book.dart';
import '../models/response_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final bookBloc = BookBloc();
  TextEditingController txtController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Type in your text",
                ),
                controller: txtController,
                onChanged: (value) => bookBloc.eventSink
                    .add(Tuple2(BookAction.fetchByTitle, value)),
              ),
            ),
            StreamBuilder<ResponseModel<dynamic>>(
                stream: bookBloc.bookStream,
                builder: (context, snapshot) {
                  if (txtController.text.isEmpty || txtController.text == "") {
                    return const Center(
                        child: Text("Please search for a book"));
                  }
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    if (!snapshot.data!.isSuccess) {
                      Widget errorWidget = snapshot.data!.errorMessage == null
                          ? const Text("Unexpected error!")
                          : Text(snapshot.data!.errorMessage!);

                      Future.delayed(Duration.zero, () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: errorWidget,
                            duration: const Duration(milliseconds: 1000),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      });
                    }
                    return Flexible(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.isSuccess
                              ? snapshot.data!.data.length
                              : 0,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return GestureDetector(
                              onDoubleTap: () => bookBloc.eventSink.add(Tuple2(BookAction.addFavorite, snapshot.data!.data[index].id)),
                              onLongPress: () => bookBloc.eventSink.add(Tuple2(BookAction.removeFavorite, snapshot.data!.data[index].id)),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 3,
                                      color: snapshot.data!.data[index].isFavorite == true ?
                                          Colors.purple:Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  color: Colors.amberAccent.shade100,
                                  child: ListTile(
                                    leading: Image.network(
                                        snapshot.data!.data[index].thumbnail),
                                    title: Text(snapshot.data!.data[index].title),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Divider(
                                            thickness: 1,
                                            color: Colors.purple,
                                            height: 10),
                                        snapshot.data!.data[index].authors == ""
                                            ? const SizedBox.shrink()
                                            : Text(
                                                "Authors: ${snapshot.data!.data[index].authors}"),
                                        snapshot.data!.data[index].publisher == ""
                                            ? const SizedBox.shrink()
                                            : Text(
                                                "Publisher: ${snapshot.data!.data[index].publisher}"),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            snapshot.data!.data[index]
                                                        .publishedDate ==
                                                    ""
                                                ? const SizedBox.shrink()
                                                : Text(
                                                    "Published at: ${snapshot.data!.data[index].publishedDate}"),
                                            snapshot.data!.data[index]
                                                        .pageCount ==
                                                    null
                                                ? const SizedBox.shrink()
                                                : Text(
                                                    "Pages: ${snapshot.data!.data[index].pageCount}"),
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          }),
                    );

                    // Text(snapshot.data!.title);
                  } else {
                    return Text('${snapshot.error}');
                  }
                }),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   // onPressed: bookBloc.bookSink.add(_title),
      //   onPressed: fetchData("müzik"),
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
