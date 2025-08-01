import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/config/routes.dart';
import 'package:galongo/data/presentation/admin/dashboard/dashboard_bloc.dart';
import 'package:galongo/data/presentation/admin/promo/promo_bloc.dart';
import 'package:galongo/data/presentation/admin/stock/stock_bloc.dart';
import 'package:galongo/data/presentation/auth/bloc/login/login_bloc.dart';
import 'package:galongo/data/presentation/auth/bloc/register/register_bloc.dart';
import 'package:galongo/data/presentation/auth/login_screen.dart';
import 'package:galongo/data/presentation/customer/home/cart/cart_bloc.dart';
import 'package:galongo/data/presentation/customer/home/order_customer_screen.dart';
import 'package:galongo/data/presentation/customer/home/orders/orders_bloc.dart';
import 'package:galongo/data/presentation/customer/home/profile_customer/profile_customer_bloc.dart';
import 'package:galongo/data/presentation/customer/home/report_damage/report_damage_bloc.dart';
import 'package:galongo/data/presentation/customer/home/review/review_bloc.dart';
import 'package:galongo/data/presentation/customer/home/transactions/transaction_bloc.dart';
import 'package:galongo/data/repository/auth_repository.dart';
import 'package:galongo/data/repository/cart_repository.dart';
import 'package:galongo/data/repository/dashboard_repository.dart';
import 'package:galongo/data/repository/order_repository.dart';
import 'package:galongo/data/repository/profile_customer_repository.dart';
import 'package:galongo/data/repository/promo_repository.dart';
import 'package:galongo/data/repository/report_damage_repository.dart';
import 'package:galongo/data/repository/review_repository.dart';
import 'package:galongo/data/repository/stock_repository.dart';
import 'package:galongo/data/repository/transaction_repository.dart';
import 'package:galongo/services/service_http_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) => RegisterBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) => DashboardBloc(dashboardRepository: DashboardRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) => OrdersBloc(orderRepository: OrderRepository(ServiceHttpClient())),
           
        ),
        

        BlocProvider(
          create: (_) => StockBloc(stockRepository: StockRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) => TransactionBloc(TransactionRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) => ReviewBloc(ReviewRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) => PromoBloc(PromoRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) => ReportDamageBloc(ReportDamageRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) => CartBloc(CartRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) => ProfileCustomerBloc(ProfileCustomerRepository(ServiceHttpClient())),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Galongo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: '/login',
        routes: AppRoutes.routes,
      ),
    );  
      
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
