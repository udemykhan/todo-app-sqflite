import 'package:flutter/material.dart';
import 'package:todo_app_sqflite/add_update_task.dart';
import 'package:todo_app_sqflite/db_handler.dart';
import 'package:todo_app_sqflite/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text(
          'Task Todo',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
        centerTitle: true,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.help_outline_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: dataList,
            builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No Task found',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    int todoId = snapshot.data![index].id!.toInt();
                    String todoTitle = snapshot.data![index].title.toString();
                    String todoDesc = snapshot.data![index].desc.toString();
                    String todoDT =
                        snapshot.data![index].dateAndTime.toString();
                    return Dismissible(
                      key: ValueKey<int>(todoId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.redAccent,
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          dbHelper!.delete(todoId);
                          dataList = dbHelper!.getDataList();
                          snapshot.data!.remove(snapshot.data![index]);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.yellow.shade300,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 1)
                            ]),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  todoTitle,
                                  style: const TextStyle(fontSize: 19),
                                ),
                              ),
                              subtitle: Text(
                                todoDesc,
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                              thickness: 0.8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    todoDT,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddUpdateTask(
                                                    todoId: todoId,
                                                    todoDesc: todoDesc,
                                                    todoTitle: todoTitle,
                                                    todoDT: todoDT,
                                                    update: true,
                                                  )));
                                    },
                                    child: const Icon(Icons.edit_note,
                                        size: 28, color: Colors.green),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddUpdateTask()));
        },
      ),
    );
  }
}
