import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/cubit/todo_cubit.dart';
import 'package:todo_cubit/models/todo.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              children: <Widget>[
                a_header(context),
                Divider(),
                b_addTodo(context),
                Divider(),
                c_searchTodo(context),
                Todo_Filter_Row(),
                ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Divider(),
                  itemCount:
                      context.read<TodoCubit>().searchedFilteredList.length,
                  itemBuilder: ((context, index) {
                    return ToDoItem(
                      todo:
                          context.read<TodoCubit>().searchedFilteredList[index],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row a_header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'TODO',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
        Text(
          '${context.watch<TodoCubit>().getActiveCount} items left',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ],
    );
  }
}

TextField b_addTodo(BuildContext context) {
  return TextField(
    onSubmitted: (value) => context.read<TodoCubit>().addTodo(value),
    decoration: InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      hintText: 'What to do?',
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
    ),
  );
}

Container c_searchTodo(BuildContext context) {
  return Container(
    decoration: BoxDecoration(color: Colors.grey.shade200),
    child: TextField(
      onChanged: (value) {
        context.read<TodoCubit>().changeSearchTerm(value);
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        prefixIcon: Icon(
          Icons.search,
        ),
        hintText: 'Search Todos',
        hintStyle: TextStyle(
          color: Colors.grey.shade600,
        ),
      ),
    ),
  );
}

class Todo_Filter_Row extends StatefulWidget {
  Todo_Filter_Row({Key? key}) : super(key: key);

  @override
  State<Todo_Filter_Row> createState() => _Todo_Filter_RowState();
}

class _Todo_Filter_RowState extends State<Todo_Filter_Row> {
  var SelectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                context.read<TodoCubit>().changeFilter(FilterStatus.All);
                SelectedTab = 'All';
              });
            },
            child: Text(
              'All',
              style: TextStyle(
                  fontSize: SelectedTab == 'All' ? 23 : 19,
                  fontWeight: SelectedTab == 'All'
                      ? FontWeight.w800
                      : FontWeight.normal,
                  color: SelectedTab == 'All' ? Colors.blue : Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                context.read<TodoCubit>().changeFilter(FilterStatus.Active);
                SelectedTab = 'Active';
              });
            },
            child: Text(
              'Active',
              style: TextStyle(
                  fontSize: SelectedTab == 'Active' ? 23 : 19,
                  fontWeight: SelectedTab == 'Active'
                      ? FontWeight.w800
                      : FontWeight.normal,
                  color: SelectedTab == 'Active' ? Colors.blue : Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                context.read<TodoCubit>().changeFilter(FilterStatus.Complete);
                SelectedTab = 'Completed';
              });
            },
            child: Text(
              'Completed',
              style: TextStyle(
                  fontSize: SelectedTab == 'Completed' ? 23 : 19,
                  fontWeight: SelectedTab == 'Completed'
                      ? FontWeight.w800
                      : FontWeight.normal,
                  color:
                      SelectedTab == 'Completed' ? Colors.blue : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class ToDoItem extends StatefulWidget {
  late final Todo todo;
  ToDoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  late final TextEditingController txtCtrl;

  @override
  void initState() {
    txtCtrl = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) {
        context.read<TodoCubit>().removeTodo(widget.todo.id);
      },
      background: Container(
        color: Colors.pink[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.delete,
              color: Colors.red,
            ),
            Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ],
        ),
      ),
      key: ValueKey(widget.todo.id),
      child: ListTile(
        leading: Checkbox(
            value: widget.todo.isCompleted,
            onChanged: (_) {
              context.read<TodoCubit>().toggleTodo(widget.todo.id);
            }),
        title: Text(widget.todo.desc),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                txtCtrl.text = widget.todo.desc;
                return AlertDialog(
                  title: Text('edit todo'),
                  actions: <Widget>[
                    TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    TextButton(
                        child: Text('edit'),
                        onPressed: () {
                          context
                              .read<TodoCubit>()
                              .editTodo(widget.todo.id, txtCtrl.text);
                          Navigator.of(context).pop();
                        })
                  ],
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  content: Container(
                    child: TextField(
                      controller: txtCtrl,
                      decoration:
                          InputDecoration(hintText: 'Edit todo description'),
                    ),
                    constraints: const BoxConstraints(
                      minHeight: 250,
                      minWidth: 250,
                      maxHeight: 250,
                      maxWidth: 250,
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
