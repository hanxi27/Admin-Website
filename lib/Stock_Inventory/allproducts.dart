import 'package:my_new_project/assets.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, String>> allProducts = [];

Future<void> loadProducts() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('products');
    if (data != null) {
      List<dynamic> jsonData = json.decode(data);
      allProducts = jsonData.map((item) => Map<String, String>.from(item)).toList();
    } else {
      // Load initial data from assets and save to the preferences
      allProducts = [
        {
          "title": "Old Town 2 in 1 White Coffee (Coffee & Creamer) 375g",
          "category": "Coffee",
          "price": "RM 9.99",
          "image": Assets.oldtown,
        },
        {
          "title": "Old Town 3-in-1 Hazelnut Instant White Coffee 570g",
          "category": "Coffee",
          "price": "RM 11.99",
          "image": Assets.oldtownhazelnut,
        },
        {
          "title": "Milo Original Chocolate Malt Drink 30g x 18",
          "category": "Dairy Product",
          "price": "RM 16.99",
          "image": Assets.milo,
        },
        {
          "title": "Milo Soft Pack 2kg",
          "category": "Dairy Product",
          "price": "RM 27.99",
          "image": Assets.milo2kg,
        },
        {
          "title": "Farm Fresh Cows Milk 1L",
          "category": "Dairy Product",
          "price": "RM 8.40",
          "image": Assets.milk,
        },
        {
          "title": "FREEMAN Instant Foot Peeling Spray 118ml",
          "image": Assets.freeman,
          "category": "Foot Treatment",
          "price": "RM 35.90",
        },
        {
          "title": "ELLGY Cracked Heel Cream 50g",
          "image": Assets.ellgy,
          "category": "Foot Treatment",
          "price": "RM 24.00",
        },
        {
          "title": "FREEMAN HYDRATING FOOT LOTION PEPPERMINT&PLUM 150ML",
          "image": Assets.lotion,
          "category": "Foot Treatment",
          "price": "RM 18.00",
        },
        {
          "title": "Nestle Koko Krunch 450g",
          "category": "Groceries",
          "price": "RM 12.99",
          "image": Assets.kokokrunch,
        },
        {
          "title": "Saji Brand Cooking Oil 5kg",
          "category": "Groceries",
          "price": "RM 25.99",
          "image": Assets.saji,
        },
        {
          "title": "Knife Cooking Oil 5kg",
          "category": "Groceries",
          "price": "RM 24.99",
          "image": Assets.knifeoil,
        },
        {
          "title": "Maggi Curry Flavour Instant Noodles 79g x 5",
          "category": "Groceries",
          "price": "RM 4.99",
          "image": Assets.maggiekari,
        },
        {
          "title": "Yeo's Chicken Curry with Potatoes 280g",
          "category": "Groceries",
          "price": "RM 5.99",
          "image": Assets.yeoscurry,
        },
        {
          "title": "Jasmine Super 5 White Rice Imported 5kg",
          "category": "Groceries",
          "price": "RM 18.99",
          "image": Assets.jasmine,
        },
        {
          "title": "Ayam Brand Mackerel in Tomato Sauce 230g",
          "category": "Groceries",
          "price": "RM 7.99",
          "image": Assets.tomatosauce,
        },
        {
          "title": "Cap Rambutan 5% Super Import White Rice 5kg",
          "category": "Groceries",
          "price": "RM 17.99",
          "image": Assets.rambutans,
        },
        {
          "title": "Nestle Kit Kat Sharebag Value Pack 17g x 24",
          "category": "Groceries",
          "price": "RM 14.99",
          "image": Assets.kitkat,
        },
        {
          "title": "KUNDAL Honey & Macadamia Nature Shampoo - Cherry Blossom 500ml",
          "image": Assets.kundalshampoo,
          "category": "Hair Care",
          "price": "RM 29.99",
        },
        {
          "title": "Kundal Honey & Macadamia Hair Treatment - Cherry Blossom 500ml",
          "image": Assets.kundalhoney,
          "category": "Hair Care",
          "price": "RM 34.99",
        },
        {
          "title": "Grafen Perfume Hair Shampoo Emerald Blossom 500ml (Anti-Hair Loss)",
          "image": Assets.grafen,
          "category": "Hair Care",
          "price": "RM 39.99",
        },
        {
          "title": "Ryo Hair Loss Expert Scalp Massage Essence 80ml",
          "image": Assets.ryo,
          "category": "Hair Care",
          "price": "RM 44.99",
        },
        {
          "title": "Kundal Caffeine Scalp Care Tonic 100ml",
          "image": Assets.hairtonic,
          "category": "Hair Care",
          "price": "RM 49.99",
        },
        {
          "title": "Pantene 3Mm Conditioner 480Ml Keratin Silky Smooth",
          "image": Assets.pantene,
          "category": "Hair Care",
          "price": "RM 19.99",
        },
        {
          "title": "Amino Mason Treatment Night Recipe Sleek 450Ml",
          "image": Assets.amino,
          "category": "Hair Care",
          "price": "RM 29.99",
        },
        {
          "title": "Ryo Damage Care And Nourishing Shampoo 480ml",
          "image": Assets.ryodamage,
          "category": "Hair Care",
          "price": "RM 34.99",
        },
        {
          "title": "Garnier Skin Naturals Micellar Water Pink 125ml",
          "image": Assets.garnier,
          "category": "Make Up",
          "price": "RM 19.99",
        },
        {
          "title": "Reihaku Hatomugi Whip Face Wash Cleansing Water (Make Up Remover) 200ml",
          "image": Assets.hatomugi,
          "category": "Make Up",
          "price": "RM 24.99",
        },
        {
          "title": "Garnier Micellar Salicylic BHA 125ml",
          "image": Assets.garnierblue,
          "category": "Make Up",
          "price": "RM 21.99",
        },
        {
          "title": "Silky White Bright Up Liquid Foundation 01 Light",
          "image": Assets.foundation,
          "category": "Make Up",
          "price": "RM 29.99",
        },
        {
          "title": "Palladio Herbal Foundation Tube PFS01 Ivory",
          "image": Assets.palladio,
          "category": "Make Up",
          "price": "RM 34.99",
        },
        {
          "title": "Palladio Herbal Foundation Tube PFS02 Porcelain",
          "image": Assets.palladio02,
          "category": "Make Up",
          "price": "RM 34.99",
        },
        {
          "title": "Palladio Dual Wet & Dry Foundation WD400 Laurel Nude",
          "image": Assets.dryfoundation,
          "category": "Make Up",
          "price": "RM 39.99",
        },
        {
          "title": "Palladio Dual Wet & Dry Foundation WD401 Ivory Myrrh",
          "image": Assets.dryfoundation401,
          "category": "Make Up",
          "price": "RM 39.99",
        },
        {
          "title": "Rimmel Wonder'Ink Ultimate Waterproof Eyeliner",
          "image": Assets.eyeliner,
          "category": "Make Up",
          "price": "RM 19.99",
        },
        {
          "title": "SilkyGirl Long-Wearing Eyeliner 01 Black Black",
          "image": Assets.eyelinerblack,
          "category": "Make Up",
          "price": "RM 17.99",
        },
        {
          "title": "EYS Bird's Nest With Rock Sugar",
          "image": Assets.birdnest,
          "category": "Nutrition",
          "price": "RM 139.99",
        },
        {
          "title": "HM Euphoria Longana Honey",
          "image": Assets.honey,
          "category": "Nutrition",
          "price": "RM 99.99",
        },
        {
          "title": "Dog Dry Food Chicken & Veg 3kg",
          "image": Assets.pedigree,
          "category": "Pets Care",
          "price": "RM 49.99",
        },
        {
          "title": "Cat Wet Food Flake Tuna in Gravy 85gm",
          "image": Assets.sheba,
          "category": "Pets Care",
          "price": "RM 3.99",
        },
        {
          "title": "Dog Oral Care Dentastix Toy 60g",
          "image": Assets.dogoral,
          "category": "Pets Care",
          "price": "RM 14.99",
        },
        {
          "title": "Potty Here Training Aid Spray 8Oz",
          "image": Assets.naturvet,
          "category": "Pets Care",
          "price": "RM 29.99",
        },
        {
          "title": "Ear Wash Liquid 4Oz",
          "image": Assets.earwash,
          "category": "Pets Care",
          "price": "RM 19.99",
        },
        {
          "title": "Peony Anti-Bacteria Formula Pets Shampoo 400ml",
          "image": Assets.shampoo,
          "category": "Pets Care",
          "price": "RM 24.99",
        },
        {
          "title": "Unique Pet Shower Silicon Brush with Soap Container",
          "image": Assets.brush,
          "category": "Pets Care",
          "price": "RM 15.99",
        },
        {
          "title": "Swisse Ultiboost Vitamin C + Manuka Honey 120 Tablets",
          "image": Assets.vitaminc,
          "category": "Supplement",
          "price": "RM 89.90",
        },
        {
          "title": "Swisse Ultiboost High Strength Krill Oil 30 Capsules",
          "image": Assets.krilloil,
          "category": "Supplement",
          "price": "RM 100.90",
        },
        {
          "title": "Blackmores Digestive Enzymes Plus Capsule 60s",
          "image": Assets.enzymesplus,
          "category": "Supplement",
          "price": "RM 79.80",
        },
        {
          "title": "Blackmores Bio Ace Plus Capsule 30s",
          "image": Assets.bioaceplus,
          "category": "Supplement",
          "price": "RM 99.00",
        },
        {
          "title": "Blackmores Bio Zinc Capsule 168s",
          "image": Assets.biozinc,
          "category": "Supplement",
          "price": "RM 95.00",
        },
        {
          "title": "Blackmores Buffered C Capsule 30s",
          "image": Assets.bufferedc,
          "category": "Supplement",
          "price": "RM 58.90",
        },
        {
          "title": "EYS Pure Chicken Essence",
          "image": Assets.chickenessence,
          "category": "Tonic",
          "price": "RM 119.99",
        },
        {
          "title": "Brand's Essence of Chicken 70g x 30's",
          "image": Assets.brands,
          "category": "Tonic",
          "price": "RM 159.99",
        },
        {
          "title": "KANGAROO Eucalyptus Oil 28ml",
          "image": Assets.kangaroo,
          "category": "Traditional Medicine",
          "price": "RM 9.29",
        },
        {
          "title": "AXE Med Oil 10ml",
          "image": Assets.kapak,
          "category": "Traditional Medicine",
          "price": "RM 6.70",
        },
        {
          "title": "KWAN LOONG Kwan Loong Medicated Oil",
          "image": Assets.kwan,
          "category": "Traditional Medicine",
          "price": "RM 13.90",
        },
        {
          "title": "YU YEE Cap Limau Yu Yee Oil 10ml",
          "image": Assets.yuyee,
          "category": "Traditional Medicine",
          "price": "RM 8.70",
        },
      ];
      await saveProducts();
    }
  } catch (e) {
    print("Error loading products: $e");
  }
}

Future<void> saveProducts() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('products', json.encode(allProducts));
  } catch (e) {
    print("Error saving products: $e");
  }
}
