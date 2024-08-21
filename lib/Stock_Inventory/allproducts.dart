import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_new_project/assets.dart';

ValueNotifier<List<Map<String, String>>> allProductsNotifier = ValueNotifier([]);

void loadProducts() async {
  final databaseReference = FirebaseDatabase.instance.ref();
  
  // First, check if Firebase has data
  DatabaseEvent event = await databaseReference.child('products').once();
  DataSnapshot snapshot = event.snapshot;

  if (snapshot.value == null) {
    // Firebase is empty, load initial products
    List<Map<String, String>> initialProducts = [
      {
        "title": "Old Town 2 in 1 White Coffee (Coffee & Creamer) 375g",
        "category": "Coffee",
        "price": "RM 18.20",
        "quantity": "10",
        "image": Assets.oldtown,
      },
      {
        "title": "Old Town 3-in-1 Hazelnut Instant White Coffee 570g",
        "category": "Coffee",
        "price": "RM 18.20",
        "quantity": "15",
        "image": Assets.oldtownhazelnut,
      },
      {
        "title": "Milo Original Chocolate Malt Drink 30g x 18",
        "category": "Dairy Product",
        "price": "RM 19.00",
        "quantity": "20",
        "image": Assets.milo,
      },
      {
        "title": "Milo Soft Pack 2kg",
        "category": "Dairy Product",
        "price": "RM 42.50",
        "quantity": "25",
        "image": Assets.milo2kg,
      },
      {
        "title": "Farm Fresh Cows Milk 1L",
        "category": "Dairy Product",
        "price": "RM 8.40",
        "quantity": "30",
        "image": Assets.milk,
      },
      {
        "title": "FREEMAN Instant Foot Peeling Spray 118ml",
        "image": Assets.freeman,
        "category": "Foot Treatment",
        "price": "RM 35.90",
        "quantity": "5",
      },
      {
        "title": "ELLGY Cracked Heel Cream 50g",
        "image": Assets.ellgy,
        "category": "Foot Treatment",
        "price": "RM 26.90",
        "quantity": "10",
      },
      {
        "title": "FREEMAN HYDRATING FOOT LOTION PEPPERMINT&PLUM 150ML",
        "image": Assets.lotion,
        "category": "Foot Treatment",
        "price": "RM 22.90",
        "quantity": "8",
      },
      {
        "title": "Nestle Koko Krunch 450g",
        "category": "Groceries",
        "price": "RM 12.99",
        "quantity": "20",
        "image": Assets.kokokrunch,
      },
      {
        "title": "Saji Brand Cooking Oil 5kg",
        "category": "Groceries",
        "price": "RM 30.80",
        "quantity": "50",
        "image": Assets.saji,
      },
      {
        "title": "Knife Cooking Oil 5kg",
        "category": "Groceries",
        "price": "RM 40.00",
        "quantity": "40",
        "image": Assets.knifeoil,
      },
      {
        "title": "Maggi Curry Flavour Instant Noodles 79g x 5",
        "category": "Groceries",
        "price": "RM 5.79",
        "quantity": "60",
        "image": Assets.maggiekari,
      },
      {
        "title": "Yeo's Chicken Curry with Potatoes 280g",
        "category": "Groceries",
        "price": "RM 7.80",
        "quantity": "25",
        "image": Assets.yeoscurry,
      },
      {
        "title": "Jasmine Super 5 White Rice Imported 5kg",
        "category": "Groceries",
        "price": "RM 23.90",
        "quantity": "10",
        "image": Assets.jasmine,
      },
      {
        "title": "Ayam Brand Mackerel in Tomato Sauce 230g",
        "category": "Groceries",
        "price": "RM 7.45",
        "quantity": "15",
        "image": Assets.tomatosauce,
      },
      {
        "title": "Cap Rambutan 5% Super Import White Rice 5kg",
        "category": "Groceries",
        "price": "RM 22.50",
        "quantity": "30",
        "image": Assets.rambutans,
      },
      {
        "title": "Nestle Kit Kat Sharebag Value Pack 17g x 24",
        "category": "Groceries",
        "price": "RM 21.90",
        "quantity": "10",
        "image": Assets.kitkat,
      },
      {
        "title": "KUNDAL Honey & Macadamia Nature Shampoo - Cherry Blossom 500ml",
        "image": Assets.kundalshampoo,
        "category": "Hair Care",
        "price": "RM 33.90",
        "quantity": "20",
      },
      {
        "title": "Kundal Honey & Macadamia Hair Treatment - Cherry Blossom 500ml",
        "image": Assets.kundalhoney,
        "category": "Hair Care",
        "price": "RM 33.90",
        "quantity": "25",
      },
      {
        "title": "Grafen Perfume Hair Shampoo Emerald Blossom 500ml (Anti-Hair Loss)",
        "image": Assets.grafen,
        "category": "Hair Care",
        "price": "RM 74.00",
        "quantity": "15",
      },
      {
        "title": "Ryo Hair Loss Expert Scalp Massage Essence 80ml",
        "image": Assets.ryo,
        "category": "Hair Care",
        "price": "RM 51.80",
        "quantity": "10",
      },
      {
        "title": "Kundal Caffeine Scalp Care Tonic 100ml",
        "image": Assets.hairtonic,
        "category": "Hair Care",
        "price": "RM 45.90",
        "quantity": "20",
      },
      {
        "title": "Pantene 3Mm Conditioner 480Ml Keratin Silky Smooth",
        "image": Assets.pantene,
        "category": "Hair Care",
        "price": "RM 19.24",
        "quantity": "30",
      },
      {
        "title": "Amino Mason Treatment Night Recipe Sleek 450Ml",
        "image": Assets.amino,
        "category": "Hair Care",
        "price": "RM 74.70",
        "quantity": "25",
      },
      {
        "title": "Ryo Damage Care And Nourishing Shampoo 480ml",
        "image": Assets.ryodamage,
        "category": "Hair Care",
        "price": "RM 42.50",
        "quantity": "15",
      },
      {
        "title": "Garnier Skin Naturals Micellar Water Pink 125ml",
        "image": Assets.garnier,
        "category": "Make Up",
        "price": "RM 16.90",
        "quantity": "40",
      },
      {
        "title": "Reihaku Hatomugi Whip Face Wash Cleansing Water (Make Up Remover) 200ml",
        "image": Assets.hatomugi,
        "category": "Make Up",
        "price": "RM 43.90",
        "quantity": "30",
      },
      {
        "title": "Garnier Micellar Salicylic BHA 125ml",
        "image": Assets.garnierblue,
        "category": "Make Up",
        "price": "RM 16.90",
        "quantity": "35",
      },
      {
        "title": "Silky White Bright Up Liquid Foundation 01 Light",
        "image": Assets.foundation,
        "category": "Make Up",
        "price": "RM 18.90",
        "quantity": "25",
      },
      {
        "title": "Palladio Herbal Foundation Tube PFS01 Ivory",
        "image": Assets.palladio,
        "category": "Make Up",
        "price": "RM 55.90",
        "quantity": "15",
      },
      {
        "title": "Palladio Herbal Foundation Tube PFS02 Porcelain",
        "image": Assets.palladio02,
        "category": "Make Up",
        "price": "RM 55.90",
        "quantity": "10",
      },
      {
        "title": "Palladio Dual Wet & Dry Foundation WD400 Laurel Nude",
        "image": Assets.dryfoundation,
        "category": "Make Up",
        "price": "RM 55.90",
        "quantity": "20",
      },
      {
        "title": "Palladio Dual Wet & Dry Foundation WD401 Ivory Myrrh",
        "image": Assets.dryfoundation401,
        "category": "Make Up",
        "price": "RM 55.90",
        "quantity": "30",
      },
      {
        "title": "Rimmel Wonder'Ink Ultimate Waterproof Eyeliner",
        "image": Assets.eyeliner,
        "category": "Make Up",
        "price": "RM 34.90",
        "quantity": "25",
      },
      {
        "title": "SilkyGirl Long-Wearing Eyeliner 01 Black Black",
        "image": Assets.eyelinerblack,
        "category": "Make Up",
        "price": "RM 21.90",
        "quantity": "40",
      },
      {
        "title": "EYS Bird's Nest With Rock Sugar",
        "image": Assets.birdnest,
        "category": "Nutrition",
        "price": "RM 148.00",
        "quantity": "10",
      },
      {
        "title": "HM Euphoria Longana Honey",
        "image": Assets.honey,
        "category": "Nutrition",
        "price": "RM 39.90",
        "quantity": "5",
      },
      {
        "title": "Dog Dry Food Chicken & Veg 3kg",
        "image": Assets.pedigree,
        "category": "Pets Care",
        "price": "RM 31.00",
        "quantity": "15",
      },
      {
        "title": "Cat Wet Food Flake Tuna in Gravy 85gm",
        "image": Assets.sheba,
        "category": "Pets Care",
        "price": "RM 4.60",
        "quantity": "50",
      },
      {
        "title": "Dog Oral Care Dentastix Toy 60g",
        "image": Assets.dogoral,
        "category": "Pets Care",
        "price": "RM 8.00",
        "quantity": "20",
      },
      {
        "title": "Potty Here Training Aid Spray 8Oz",
        "image": Assets.naturvet,
        "category": "Pets Care",
        "price": "RM 29.00",
        "quantity": "10",
      },
      {
        "title": "Ear Wash Liquid 4Oz",
        "image": Assets.earwash,
        "category": "Pets Care",
        "price": "RM 49.00",
        "quantity": "25",
      },
      {
        "title": "YU Peony Anti-Bacteria Formula Pets Shampoo 400ml",
        "image": Assets.shampoo,
        "category": "Pets Care",
        "price": "RM 79.90",
        "quantity": "15",
      },
      {
        "title": "Unique Pet Shower Silicon Brush with Soap Container",
        "image": Assets.brush,
        "category": "Pets Care",
        "price": "RM 13.00",
        "quantity": "20",
      },
      {
        "title": "Swisse Ultiboost Vitamin C + Manuka Honey 120 Tablets",
        "image": Assets.vitaminc,
        "category": "Supplement",
        "price": "RM 122.90",
        "quantity": "10",
      },
      {
        "title": "Swisse Ultiboost High Strength Krill Oil 30 Capsules",
        "image": Assets.krilloil,
        "category": "Supplement",
        "price": "RM 101.60",
        "quantity": "25",
      },
      {
        "title": "Blackmores Digestive Enzymes Plus Capsule 60s",
        "image": Assets.enzymesplus,
        "category": "Supplement",
        "price": "RM 80.50",
        "quantity": "20",
      },
      {
        "title": "Blackmores Bio Ace Plus Capsule 30s",
        "image": Assets.bioaceplus,
        "category": "Supplement",
        "price": "RM 79.00",
        "quantity": "15",
      },
      {
        "title": "Blackmores Bio Zinc Capsule 168s",
        "image": Assets.biozinc,
        "category": "Supplement",
        "price": "RM 80.20",
        "quantity": "10",
      },
      {
        "title": "Blackmores Buffered C Capsule 30s",
        "image": Assets.bufferedc,
        "category": "Supplement",
        "price": "RM 26.70",
        "quantity": "20",
      },
      {
        "title": "EYS Pure Chicken Essence",
        "image": Assets.chickenessence,
        "category": "Tonic",
        "price": "RM 235.00",
        "quantity": "10",
      },
      {
        "title": "Brand's Essence of Chicken 70g x 30's",
        "image": Assets.brands,
        "category": "Tonic",
        "price": "RM 159.00",
        "quantity": "5",
      },
      {
        "title": "KANGAROO Eucalyptus Oil 28ml",
        "image": Assets.kangaroo,
        "category": "Traditional Medicine",
        "price": "RM 10.90",
        "quantity": "50",
      },
      {
        "title": "AXE Med Oil 10ml",
        "image": Assets.kapak,
        "category": "Traditional Medicine",
        "price": "RM 7.00",
        "quantity": "40",
      },
      {
        "title": "KWAN LOONG Kwan Loong Medicated Oil",
        "image": Assets.kwan,
        "category": "Traditional Medicine",
        "price": "RM 16.35",
        "quantity": "30",
      },
      {
        "title": "YU YEE Cap Limau Yu Yee Oil 10ml",
        "image": Assets.yuyee,
        "category": "Traditional Medicine",
        "price": "RM 8.70",
        "quantity": "20",
      },
    ];

    allProductsNotifier.value = initialProducts;

    // Save initial products to Firebase
    await saveProducts();
  } else {
    // Firebase has data, set the products
    Map<dynamic, dynamic> jsonData = snapshot.value as Map<dynamic, dynamic>;
    List<Map<String, String>> productsList = jsonData.values
        .map((item) => Map<String, String>.from(item as Map<dynamic, dynamic>))
        .toList();
    allProductsNotifier.value = productsList;
  }

  // Set up a real-time listener to update products automatically
  databaseReference.child('products').onValue.listen((event) {
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> jsonData = snapshot.value as Map<dynamic, dynamic>;
      List<Map<String, String>> productsList = jsonData.values
          .map((item) => Map<String, String>.from(item as Map<dynamic, dynamic>))
          .toList();
      allProductsNotifier.value = productsList;
    } else {
      allProductsNotifier.value = []; // No products available
    }
  });
}

Future<void> saveProducts() async {
  final databaseReference = FirebaseDatabase.instance.ref();
  await databaseReference.child('products').set(allProductsNotifier.value);
}

