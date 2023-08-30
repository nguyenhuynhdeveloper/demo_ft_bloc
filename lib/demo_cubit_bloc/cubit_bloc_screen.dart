import 'package:demo_ft_bloc/demo_cubit_bloc/bloc/person_bloc.dart';
import 'package:demo_ft_bloc/demo_cubit_bloc/bloc/person_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

class CubitBlocScreen extends StatefulWidget {
  const CubitBlocScreen({Key? key}) : super(key: key);

  @override
  State<CubitBlocScreen> createState() => _CubitBlocScreenState();
}

class _CubitBlocScreenState extends State<CubitBlocScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonBloc>(
      create: (_) => PersonBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('xincchafo')),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Text('xin chào các bạn'),

              //------------BLocBuilder-----
              BlocBuilder<PersonBloc, PersonState>(
                  builder: (context, state) => Column(
                        children: [
                          Text("Sử dụng BlocBuilder"),
                          Text('------- ${state.age}'),
                        ],
                      )),
              const SizedBox(
                height: 20,
              ),
              //-----------BlocSelector-------
              BlocSelector<PersonBloc, PersonState, String>(
                  selector: ((state) => state.position),
                  builder: ((context, state) {
                    return Column(
                      children: [
                        Text("Sử dụng BlocSelector"),
                        Text("${state}")
                      ],
                    );
                  })),
              const SizedBox(
                height: 20,
              ),

              //--------BlocSelector + Tuple123
              BlocSelector<PersonBloc, PersonState, Tuple2<String, String>>(
                // Khi nào mà lấy từ 2 trường state trở lên thì mới phải sử dụng Tuple2 , còn không có thể sử dụng BlocSelector bình thường
                selector: (state) => Tuple2(state.fullName, state.position),
                builder: ((context, state) => Column(
                      children: [
                        Text("Sử dụng BlocSelector with Tuple2"),
                        Text(
                            'fullNamae: ${state.item1} --- possition: ${state.item2}'),
                      ],
                    )),
              ),
              const SizedBox(
                height: 20,
              ),

              //--------BlocListener---------
              BlocListener<PersonBloc, PersonState>(
                listenWhen: (previous, current) =>
                    current.age == 20, // Khi listenWhen trả ra 1 kết quả là true thì listener sẽ được chạy
                listener: (context, state) {
                  print("State đã được thay đổi tuổi đã là 20");

                  //Có thể gọi hàm thay đổi state ở ngay đây
                  //BlocListener chỉ làm thao tác sử ký dữ liệu chứ không có hàm build để xử lý giao diện 
                  context.read<PersonBloc>().emit(state.copyWith(age: 30));
                },
                child: Text(' Số tuổi của bạn '),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            BlocBuilder<PersonBloc, PersonState>(
              builder: (context, state) => FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () => {
                        context
                            .read<PersonBloc>()
                            .changeFullName("nguyen van huynh "),
                        context.read<PersonBloc>().changePosition("Senior"),
                        context.read<PersonBloc>().changeAge(20)
                      }),
            ),
            const SizedBox(height: 4),
            FloatingActionButton(
              child: const Icon(Icons.remove),
              onPressed: () => context.read<PersonBloc>().changeAge(18),
            ),
          ],
        ),
      ),
    );
  }
}
