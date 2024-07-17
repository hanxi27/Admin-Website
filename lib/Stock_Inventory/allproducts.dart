import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:my_new_project/assets.dart'; // Replace 'your_project' with the actual project name

List<Map<String, String>> allProducts = [];

Future<void> loadProducts() async {
  final databaseReference = FirebaseDatabase.instance.ref();
  DatabaseEvent event = await databaseReference.child('products').once();
  DataSnapshot snapshot = event.snapshot;
  if (snapshot.value != null) {
    List<dynamic> jsonData = snapshot.value as List<dynamic>;
    allProducts = jsonData.map((item) => Map<String, String>.from(item as Map<dynamic, dynamic>)).toList();
  } else {
    // Load initial data from assets and save to the Firebase
    allProducts = [
      {
        "title": "Old Town 2 in 1 White Coffee (Coffee & Creamer) 375g",
        "category": "Coffee",
        "price": "RM 9.99",
        "image": Assets.oldtown,
        "quantity": "10",
      },
      {
        "title": "Old Town 3-in-1 Hazelnut Instant White Coffee 570g",
        "category": "Coffee",
        "price": "RM 11.99",
        "image": Assets.oldtownhazelnut,
        "quantity": "10",
      },
      {
        "title": "Milo Original Chocolate Malt Drink 30g x 18",
        "category": "Dairy Product",
        "price": "RM 16.99",
        "image": Assets.milo,
        "quantity": "10",
      },
      {
        "title": "Milo Soft Pack 2kg",
        "category": "Dairy Product",
        "price": "RM 27.99",
        "image": Assets.milo2kg,
        "quantity": "10",
      },
      {
        "title": "Farm Fresh Cows Milk 1L",
        "category": "Dairy Product",
        "price": "RM 8.40",
        "image": Assets.milk,
        "quantity": "10",
      },
      {
        "title": "FREEMAN Instant Foot Peeling Spray 118ml",
        "category": "Foot Treatment",
        "price": "RM 35.90",
        "image": Assets.freeman,
        "quantity": "10",
      },
      {
        "title": "ELLGY Cracked Heel Cream 50g",
        "category": "Foot Treatment",
        "price": "RM 24.00",
        "image": Assets.ellgy,
        "quantity": "10",
      },
      {
        "title": "FREEMAN HYDRATING FOOT LOTION PEPPERMINT&PLUM 150ML",
        "category": "Foot Treatment",
        "price": "RM 18.00",
        "image": Assets.lotion,
        "quantity": "10",
      },
      {
        "title": "Nestle Koko Krunch 450g",
        "category": "Groceries",
        "price": "RM 12.99",
        "image": Assets.kokokrunch,
        "quantity": "10",
      },
      {
        "title": "Saji Brand Cooking Oil 5kg",
        "category": "Groceries",
        "price": "RM 25.99",
        "image": Assets.saji,
        "quantity": "10",
      },
      {
        "title": "Knife Cooking Oil 5kg",
        "category": "Groceries",
        "price": "RM 24.99",
        "image": Assets.knifeoil,
        "quantity": "10",
      },
      {
        "title": "Maggi Curry Flavour Instant Noodles 79g x 5",
        "category": "Groceries",
        "price": "RM 4.99",
        "image": Assets.maggiekari,
        "quantity": "10",
      },
      {
        "title": "Yeo's Chicken Curry with Potatoes 280g",
        "category": "Groceries",
        "price": "RM 5.99",
        "image": Assets.yeoscurry,
        "quantity": "10",
      },
      {
        "title": "Jasmine Super 5 White Rice Imported 5kg",
        "category": "Groceries",
        "price": "RM 18.99",
        "image": Assets.jasmine,
        "quantity": "10",
      },
      {
        "title": "Ayam Brand Mackerel in Tomato Sauce 230g",
        "category": "Groceries",
        "price": "RM 7.99",
        "image": Assets.tomatosauce,
        "quantity": "10",
      },
      {
        "title": "Cap Rambutan 5% Super Import White Rice 5kg",
        "category": "Groceries",
        "price": "RM 17.99",
        "image": Assets.rambutans,
        "quantity": "10",
      },
      {
        "title": "Nestle Kit Kat Sharebag Value Pack 17g x 24",
        "category": "Groceries",
        "price": "RM 14.99",
        "image": Assets.kitkat,
        "quantity": "10",
      },
      {
        "title": "KUNDAL Honey & Macadamia Nature Shampoo - Cherry Blossom 500ml",
        "category": "Hair Care",
        "price": "RM 29.99",
        "image": Assets.kundalshampoo,
        "quantity": "10",
      },
      {
        "title": "Kundal Honey & Macadamia Hair Treatment - Cherry Blossom 500ml",
        "category": "Hair Care",
        "price": "RM 34.99",
        "image": Assets.kundalhoney,
        "quantity": "10",
      },
      {
        "title": "Grafen Perfume Hair Shampoo Emerald Blossom 500ml (Anti-Hair Loss)",
        "category": "Hair Care",
        "price": "RM 39.99",
        "image": Assets.grafen,
        "quantity": "10",
      },
      {
        "title": "Ryo Hair Loss Expert Scalp Massage Essence 80ml",
        "category": "Hair Care",
        "price": "RM 44.99",
        "image": Assets.ryo,
        "quantity": "10",
      },
      {
        "title": "Kundal Caffeine Scalp Care Tonic 100ml",
        "category": "Hair Care",
        "price": "RM 49.99",
        "image": Assets.hairtonic,
        "quantity": "10",
      },
      {
        "title": "Pantene 3Mm Conditioner 480Ml Keratin Silky Smooth",
        "category": "Hair Care",
        "price": "RM 19.99",
        "image": Assets.pantene,
        "quantity": "10",
      },
      {
        "title": "Amino Mason Treatment Night Recipe Sleek 450Ml",
        "category": "Hair Care",
        "price": "RM 29.99",
        "image": Assets.amino,
        "quantity": "10",
      },
      {
        "title": "Ryo Damage Care And Nourishing Shampoo 480ml",
        "category": "Hair Care",
        "price": "RM 34.99",
        "image": Assets.ryodamage,
        "quantity": "10",
      },
      {
        "title": "Garnier Skin Naturals Micellar Water Pink 125ml",
        "category": "Make Up",
        "price": "RM 19.99",
        "image": Assets.garnier,
        "quantity": "10",
      },
      {
        "title": "Reihaku Hatomugi Whip Face Wash Cleansing Water (Make Up Remover) 200ml",
        "category": "Make Up",
        "price": "RM 24.99",
        "image": Assets.hatomugi,
        "quantity": "10",
      },
      {
        "title": "Garnier Micellar Salicylic BHA 125ml",
        "category": "Make Up",
        "price": "RM 21.99",
        "image": Assets.garnierblue,
        "quantity": "10",
      },
      {
        "title": "Silky White Bright Up Liquid Foundation 01 Light",
        "category": "Make Up",
        "price": "RM 29.99",
        "image": Assets.foundation,
        "quantity": "10",
      },
      {
        "title": "Palladio Herbal Foundation Tube PFS01 Ivory",
        "category": "Make Up",
        "price": "RM 34.99",
        "image": Assets.palladio,
        "quantity": "10",
      },
      {
        "title": "Palladio Herbal Foundation Tube PFS02 Porcelain",
        "category": "Make Up",
        "price": "RM 34.99",
        "image": Assets.palladio02,
        "quantity": "10",
      },
      {
        "title": "Palladio Dual Wet & Dry Foundation WD400 Laurel Nude",
        "category": "Make Up",
        "price": "RM 39.99",
        "image": Assets.dryfoundation,
        "quantity": "10",
      },
      {
        "title": "Palladio Dual Wet & Dry Foundation WD401 Ivory Myrrh",
        "category": "Make Up",
        "price": "RM 39.99",
        "image": Assets.dryfoundation401,
        "quantity": "10",
      },
      {
        "title": "Rimmel Wonder'Ink Ultimate Waterproof Eyeliner",
        "category": "Make Up",
        "price": "RM 19.99",
        "image": Assets.eyeliner,
        "quantity": "10",
      },
      {
        "title": "SilkyGirl Long-Wearing Eyeliner 01 Black Black",
        "category": "Make Up",
        "price": "RM 17.99",
        "image": Assets.eyelinerblack,
        "quantity": "10",
      },
      {
        "title": "EYS Bird's Nest With Rock Sugar",
        "category": "Nutrition",
        "price": "RM 139.99",
        "image": Assets.birdnest,
        "quantity": "10",
      },
      {
        "title": "HM Euphoria Longana Honey",
        "category": "Nutrition",
        "price": "RM 99.99",
        "image": Assets.honey,
        "quantity": "10",
      },
      {
        "title": "Dog Dry Food Chicken & Veg 3kg",
        "category": "Pets Care",
        "price": "RM 49.99",
        "image": Assets.pedigree,
        "quantity": "10",
      },
      {
        "title": "Cat Wet Food Flake Tuna in Gravy 85gm",
        "category": "Pets Care",
        "price": "RM 3.99",
        "image": Assets.sheba,
        "quantity": "10",
      },
      {
        "title": "Dog Oral Care Dentastix Toy 60g",
        "category": "Pets Care",
        "price": "RM 14.99",
        "image": Assets.dogoral,
        "quantity": "10",
      },
      {
        "title": "Potty Here Training Aid Spray 8Oz",
        "category": "Pets Care",
        "price": "RM 29.99",
        "image": Assets.naturvet,
        "quantity": "10",
      },
      {
        "title": "Ear Wash Liquid 4Oz",
        "category": "Pets Care",
        "price": "RM 19.99",
        "image": Assets.earwash,
        "quantity": "10",
      },
      {
        "title": "Peony Anti-Bacteria Formula Pets Shampoo 400ml",
        "category": "Pets Care",
        "price": "RM 24.99",
        "image": Assets.shampoo,
        "quantity": "10",
      },
      {
        "title": "Unique Pet Shower Silicon Brush with Soap Container",
        "category": "Pets Care",
        "price": "RM 15.99",
        "image": Assets.brush,
        "quantity": "10",
      },
      {
        "title": "Swisse Ultiboost Vitamin C + Manuka Honey 120 Tablets",
        "category": "Supplement",
        "price": "RM 89.90",
        "image": Assets.vitaminc,
        "quantity": "10",
      },
      {
        "title": "Swisse Ultiboost High Strength Krill Oil 30 Capsules",
        "category": "Supplement",
        "price": "RM 100.90",
        "image": Assets.krilloil,
        "quantity": "10",
      },
      {
        "title": "Blackmores Digestive Enzymes Plus Capsule 60s",
        "category": "Supplement",
        "price": "RM 79.80",
        "image": Assets.enzymesplus,
        "quantity": "10",
      },
      {
        "title": "Blackmores Bio Ace Plus Capsule 30s",
        "category": "Supplement",
        "price": "RM 99.00",
        "image": Assets.bioaceplus,
        "quantity": "10",
      },
      {
        "title": "Blackmores Bio Zinc Capsule 168s",
        "category": "Supplement",
        "price": "RM 95.00",
        "image": Assets.biozinc,
        "quantity": "10",
      },
      {
        "title": "Blackmores Buffered C Capsule 30s",
        "category": "Supplement",
        "price": "RM 58.90",
        "image": Assets.bufferedc,
        "quantity": "10",
      },
      {
        "title": "EYS Pure Chicken Essence",
        "category": "Tonic",
        "price": "RM 119.99",
        "image": Assets.chickenessence,
        "quantity": "10",
      },
      {
        "title": "Brand's Essence of Chicken 70g x 30's",
        "category": "Tonic",
        "price": "RM 159.99",
        "image": Assets.brands,
        "quantity": "10",
      },
      {
        "title": "KANGAROO Eucalyptus Oil 28ml",
        "category": "Traditional Medicine",
        "price": "RM 9.29",
        "image": Assets.kangaroo,
        "quantity": "10",
      },
      {
        "title": "AXE Med Oil 10ml",
        "category": "Traditional Medicine",
        "price": "RM 6.70",
        "image": Assets.kapak,
        "quantity": "10",
      },
      {
        "title": "KWAN LOONG Kwan Loong Medicated Oil",
        "category": "Traditional Medicine",
        "price": "RM 13.90",
        "image": Assets.kwan,
        "quantity": "10",
      },
      {
        "title": "YU YEE Cap Limau Yu Yee Oil 10ml",
        "category": "Traditional Medicine",
        "price": "RM 8.70",
        "image": Assets.yuyee,
        "quantity": "10",
      },
    ];
    await saveProducts();
  }
}

Future<void> saveProducts() async {
  final databaseReference = FirebaseDatabase.instance.ref();
  await databaseReference.child('products').set(allProducts);
}
