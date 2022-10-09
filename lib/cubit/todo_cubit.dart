import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_cubit/models/todo.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoState.initial());

  void addTodo(String desc) {
    List<Todo> newTodoList = [...state.todoList, Todo(desc: desc)];
    emit(state.copyWith(todoList: newTodoList));
    print(state.todoList.length);
  }

  void removeTodo(String id) {
    List<Todo> newTodoList =
        state.todoList.where((element) => element.id != id).toList();

    emit(state.copyWith(todoList: newTodoList));
    print(state.todoList.length);
  }

  void toggleTodo(String id) {
    List<Todo> newTodoList = state.todoList.map((element) {
      if (element.id != id) {
        return element;
      } else
        return element.copyWith(isCompleted: !element.isCompleted);
    }).toList();

    emit(state.copyWith(todoList: newTodoList));
    print(state.todoList.length);
  }

  void editTodo(String id, String newDesc) {
    List<Todo> newTodoList = state.todoList.map((element) {
      if (element.id != id) {
        return element;
      } else
        return element.copyWith(desc: newDesc);
    }).toList();

    emit(state.copyWith(todoList: newTodoList));
    print(state.todoList.length);
  }

  int get getActiveCount {
    List<Todo> newTodoList = state.todoList
        .where((element) => element.isCompleted == false)
        .toList();

    print(state.todoList.length);

    return newTodoList.length;
  }

  void changeFilter(FilterStatus filter) {
    emit(state.copyWith(filterStatus: filter));
  }

  void changeSearchTerm(String newTerm) {
    emit(state.copyWith(searchTerm: newTerm));
  }

  List<Todo> get searchedFilteredList {
    List<Todo> filteredTodoList = [];
    switch (state.filterStatus) {
      case FilterStatus.Active:
        filteredTodoList = state.todoList
            .where((element) => element.isCompleted == false)
            .toList();
        break;
      case FilterStatus.Complete:
        filteredTodoList = state.todoList
            .where((element) => element.isCompleted == true)
            .toList();
        break;

      default:
        filteredTodoList = state.todoList;
    }
    List<Todo> searchedFilteredTodoList = filteredTodoList
        .where(
            (element) => element.desc.toLowerCase().contains(state.searchTerm))
        .toList();
    return searchedFilteredTodoList;
  }
}
