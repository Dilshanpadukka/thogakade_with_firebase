import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:thoga_kade/models/inventory_item.dart';
import 'package:thoga_kade/models/order.dart';

class AppState extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  ThemeMode _themeMode = ThemeMode.system;
  List<InventoryItem> _inventory = [];
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  AppState() {
    _initializeFirebaseListeners();
  }

  ThemeMode get themeMode => _themeMode;
  List<InventoryItem> get inventory => _inventory;
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void _initializeFirebaseListeners() {
    _database.child('inventory').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        _inventory = data.entries
            .map((e) => InventoryItem.fromJson(e.key, e.value))
            .toList();
        notifyListeners();
      }
    });

    _database.child('orders').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        _orders = data.entries
            .map((e) => Order.fromJson(e.key, e.value))
            .toList();
        notifyListeners();
      }
    });
  }

  Future<void> addInventoryItem(InventoryItem item) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _database.child('inventory').push().set(item.toJson());
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateInventoryItem(InventoryItem item) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _database.child('inventory').child(item.id).update(item.toJson());
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteInventoryItem(String id) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _database.child('inventory').child(id).remove();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrder(Order order) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _database.child('orders').push().set(order.toJson());
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrder(Order order) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _database.child('orders').child(order.id).update(order.toJson());
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

