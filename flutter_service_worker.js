'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "d04925c957b88bf192426b9c1605148f",
"assets/AssetManifest.bin.json": "1717fd94448e9f490d9a1ec302ded022",
"assets/AssetManifest.json": "d15180c2339826d0b3722d3361d3b83a",
"assets/assets/logo.png": "ba1deb88d639f40531805150276a225f",
"assets/assets/map/floorplan.jpg": "dca02f98374f25e7ebd5f0fe4b1dcf87",
"assets/assets/products/coffee/oldtown.jpg": "eb5975bbcc99fd5a00434abc390da78f",
"assets/assets/products/coffee/oldtownhazelnut.jpg": "c9ad9991d94d6d73532a5c0638f9e35d",
"assets/assets/products/dairy_product/milk.jpg": "04acda8ff062bae9a3eda8dc5649bf35",
"assets/assets/products/dairy_product/milo.jpg": "e2d2838658106023731e6dc5143e0a8b",
"assets/assets/products/dairy_product/milo2kg.jpg": "fc85bf88f6dd62fa20cea48a88fe853d",
"assets/assets/products/foot_treament/ellgy.jpg": "9268b4ee8b137b7a8d0c0b3678c8bd12",
"assets/assets/products/foot_treament/freeman.jpg": "ba4203fac579e96f62731d0a57eec748",
"assets/assets/products/foot_treament/lotion.jpg": "1e982cbbc47dce3693cfdefbd31d47d3",
"assets/assets/products/groceries/jasmine.jpg": "1f0253ffc04c30ca5074ed0bf12afab4",
"assets/assets/products/groceries/kitkat.jpg": "0b92fc51669c1b9ff5df7c168d11dc18",
"assets/assets/products/groceries/knifeoil.jpg": "7f82294076e6cf39d7c1fa36f71c3aa4",
"assets/assets/products/groceries/kokokrunch.jpg": "b39ce4077dcce105f40fcf0f6c78705d",
"assets/assets/products/groceries/maggiekari.jpg": "f5bcd3016bce2c6b46fdaa2162724791",
"assets/assets/products/groceries/rambutan.jpg": "f1d5d5266a25464ae1432803a85732ae",
"assets/assets/products/groceries/saji.jpg": "b7cc518f2d8f596b84ac231d4137a7da",
"assets/assets/products/groceries/tomatosauce.jpg": "11cbac2d4b250bc86394f20e20fe344e",
"assets/assets/products/groceries/yeoscurry.jpg": "ca8037224e40329662ff88e4c3fd5938",
"assets/assets/products/haircare/amino.jpg": "2bbc24a6a7432dd742405137e90a68ae",
"assets/assets/products/haircare/grafen.jpg": "c7fb24968e5260360eda976ef160eb7d",
"assets/assets/products/haircare/hairtonic.jpg": "9ba8cce2d73474a0cb69c848be787662",
"assets/assets/products/haircare/kundalhoney.jpg": "c3bd6d517b699943102b3cd63e6eee65",
"assets/assets/products/haircare/kundalshampoo.jpg": "0363b8148676a7684595fb5e19243cca",
"assets/assets/products/haircare/pantene.jpg": "31012783a154231da8c635526d0ab2cf",
"assets/assets/products/haircare/ryo.jpg": "dd8aeb9bdda6b238112261c79fec1822",
"assets/assets/products/haircare/ryodamage.jpg": "355cdd31231414dad17e58705c0036f8",
"assets/assets/products/makeup/dryfoundation.jpg": "834b5a2c42b2a35ba8d9da133995c0d3",
"assets/assets/products/makeup/dryfoundation401.jpg": "098ce36c3e97c571be8fcc3da8c76d3b",
"assets/assets/products/makeup/eyeliner.jpg": "eaa529a539454ce96a5a8ab42c686454",
"assets/assets/products/makeup/eyelinerblack.jpg": "a67da0a71a16f5a2b5e062479ddc6228",
"assets/assets/products/makeup/foundation.jpg": "e4d7599822ced558131c238239be1283",
"assets/assets/products/makeup/garnier.jpg": "f46036bd785cc7a4a2aaee43ed4f8ec3",
"assets/assets/products/makeup/garnierblue.jpg": "e627d51f330fbb68264b0109c4a62858",
"assets/assets/products/makeup/hatomugi.jpg": "71f7e208788e572f47b5f1238182a7d9",
"assets/assets/products/makeup/palladio.jpg": "6dc43da5572eaf436acc1318f32d5cfe",
"assets/assets/products/makeup/palladio02.jpg": "b235b67f041129d469a848c4862d055a",
"assets/assets/products/nutrition/birdnest.jpg": "89ce13066cf18570d09c04dadbaa341b",
"assets/assets/products/nutrition/honey.jpg": "681782eadef184e661b3ef6fc807bb7d",
"assets/assets/products/petcare/brush.jpg": "f85f2a146b126812b410960cc5aa64ba",
"assets/assets/products/petcare/dogoral.jpg": "6d7b15f4dbed9956e0112b919ca9ef5d",
"assets/assets/products/petcare/earwash.jpg": "59656270475e948a323dd5e81a16608d",
"assets/assets/products/petcare/naturvet.jpg": "c5a3a98b983f74806f79aedd1af6c416",
"assets/assets/products/petcare/pedigree.jpg": "fb80cdfb47a3278f54db1203c7b005ee",
"assets/assets/products/petcare/pet.jpg": "3833a7ed281fe5a4a17e88a43a5f3853",
"assets/assets/products/petcare/shampoo.jpg": "08a4c6d96ca65ee0db5bb05e619be2d8",
"assets/assets/products/petcare/sheba.jpg": "59533ec200ed18cc99c3977932a29462",
"assets/assets/products/petcare/whiskas.jpg": "b2d4e2696df59c9a4456763212b71d59",
"assets/assets/products/supplements/bioaceplus.jpg": "bf70858bc6a8f0e5a3357735ccbd24d2",
"assets/assets/products/supplements/biozinc.jpg": "42bb81ccad75c73b983bd6c87ba891ac",
"assets/assets/products/supplements/bufferedc.jpg": "0c824beed58ff5d36d2bc05afa993528",
"assets/assets/products/supplements/enzymesplus.jpg": "5e533bf406b2be4274f4472cc5cc1ea4",
"assets/assets/products/supplements/krilloil.png": "c6c11d174080e316e563061e0a25a6c4",
"assets/assets/products/supplements/vitaminc.jpg": "51ebc2a0be5137756b1b327e3e67906a",
"assets/assets/products/tonic/brands.jpg": "e61c1d13d0c4f81c2bc293c9bbb48b05",
"assets/assets/products/tonic/chickenessence.jpg": "8c71d24a263d16e052c2d049a213e157",
"assets/assets/products/traditional_medicine/kangaroo.jpg": "70c5925f8998073be77138207a080e3e",
"assets/assets/products/traditional_medicine/kapak.jpg": "c17f16d45f31a7a6bf7b6c1b04b4ae1d",
"assets/assets/products/traditional_medicine/kwan.jpg": "d0215b7688a5ff0d885b0c2c6223bfff",
"assets/assets/products/traditional_medicine/yuyee.jpg": "5ddedc5320d4a1f988d8c021c094f5df",
"assets/FontManifest.json": "209e66e2f71c646cc7eb744ea1cea0dc",
"assets/fonts/MaterialIcons-Regular.otf": "722cfb4becd8d59d14e264d960e3c6e4",
"assets/NOTICES": "93faefa8eea4ef0e775ed4e8a0dc6f7c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/flutter_charts/google_fonts/Comforter-Regular.ttf": "cff123ea94f9032380183b8bbbf30ec1",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "166cd5e04abaf54fa1378b4d3b9705c5",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "1af728d9b91bb24d4811dc236f0c7c51",
"/": "1af728d9b91bb24d4811dc236f0c7c51",
"main.dart.js": "5edd5f20a274f4d516f629f67dc3d7ea",
"manifest.json": "89e6a3a254ecacf3efcd04d3ddae5339",
"version.json": "362f069ca3c5c9ffb3370df97bc73bce"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
