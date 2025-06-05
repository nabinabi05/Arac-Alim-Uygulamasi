1. Gereksinimler

Flutter 3.29.3 (stable) – Dart 3.7.2

Android SDK (API 36, compile/target)

Android Studio veya VS Code (Flutter & Dart eklentileri)

Xcode 12 veya üzeri (yalnız iOS derlemesi için)

Python 3.8+ ve pip (backend)

---

2. Android Studio Ayarı

Plugins bölümünden Flutter ve Dart eklentilerini yükleyin.

SDK Manager → SDK Platforms sekmesinde Android 14/15 (API 34-36) paketlerini işaretleyin.

AVD Manager’da Pixel 4a (API 36) sistem imajını indirip Baklava adlı emülatör oluşturun.

---

3. OpenRouter API anahtarı

Proje köküne .env dosyası ekleyin:

OPENROUTER_API_KEY=sk-or-xxxxxxxx

---

4. Uygulamayı Çalıştırma

Backend’i başlatın

  cd arac_alim_backend  
  python3 -m venv venv  
  source venv/bin/activate        # Windows: venv\Scripts\activate.bat  
  pip install -r requirements.txt  
  cp .env.example .env            # SECRET_KEY, DATABASE_URL, DEBUG ayarlarını yapın  
  python manage.py migrate  
  python manage.py runserver 0.0.0.0:8000


Android emülatörünü (veya gerçek cihazı) bağlayın

  Android Studio → AVD Manager → “Baklava” (API 36) emülatörünü çalıştırın

Flutter istemciyi derleyip çalıştırın

  cd Arac-Alim-Uygulamasi
  flutter clean
  flutter pub get
  flutter gen-l10n
  flutter run --dart-define=API_BASE="http://10.0.2.2:8000/api"

---

5. Proje bağımlılıkları ve ek build adımları
Bu projede ağ işlemleri için Dio, durum yönetimi için Riverpod, yerel veritabanı için Drift/SQLite, arka plan görevleri için WorkManager ve bağlantı durumu için connectivity_plus kullanılmaktadır. pubspec.yaml dosyasındaki başlıca paketler:

• flutter_riverpod 2.6.1 – durum yönetimi
• dio 5.8.0 + 1 – HTTP istemcisi
• flutter_secure_storage 9.2.4 – JWT saklama
• drift & drift_flutter 2.26.x – SQL/ORM (Drift)
• workmanager 0.6.0 – arka plan görevleri
• flutter_local_notifications 19.2.1 – yerel bildirim
• connectivity_plus 6.1.4 – internet kontrolü
• geolocator / geocoding – GPS ve ters-geocode
• shared_preferences – tema/dil tercihi
• flutter_dotenv – .env dosyasından anahtar ve API adresi okuma

---

## 1. `develop-ui` (Nabi Nabiyev / 220229078)
- Hafta 1
  - `ScreenTemplate` bileşeni eklendi.
  - Home, List, Detail, Profile, Login, Signup sayfalarının temel iskeleti oluşturuldu.
- Hafta 2
  - Riverpod ile temel state management entegre edildi.
  - Tema (Light/Dark) ve dil (TR/EN) switch’leri UI’ya bağlandı.
- Hafta 3
  - Kart, liste ve buton stillerinin görsel uyumu geliştirildi.
  - Yüklenme ve hata durumları için spinner/placeholder eklendi.
- Hafta 4
  - Favori butonları (star/star_border) anında güncellenir hâle getirildi.
  - SnackBar bildirimleri (favori eklendi/çıkarıldı, hata) eklendi.

---

## 2. `develop-db` (Ahmet Mert Kadıoğlu / 220229064)
- Hafta 1
  - Drift/SQLite kullanılarak `Car`, `Favorite`, `Activity`, `User` tabloları tanımlandı.
  - `CarDao` ve `FavoritesDao` için temel CRUD metotları yazıldı.
- Hafta 2
  - DAO metotları test edildi; araç ekleme, güncelleme, silme ve favori listeleme işlevleri çalıştırıldı.
  - Schema migration dosyaları oluşturuldu.
- Hafta 3
  - Offline CRUD akışlarında ilişkili (join) sorgular test edildi.
  - Veritabanı işlemlerine try/catch blokları eklenerek hata kontrolleri sağlandı.
- Hafta 4
  - Sorgulara index ekleyerek veritabanı performansı artırıldı.
  - Son çekilen 20 aracın verisi JSON olarak önbelleğe alınarak listeleme hızlandırıldı.

---

## 3. `develop-auth` (Selçuk Ümit Ateş / 210229034)
- Hafta 1
  - Django REST’te SimpleJWT tabanlı `/token/` ve `/token/refresh/` endpoint’leri hazırlandı.
  - Flutter’da `AuthRepositoryApi` ile login/logout ve token saklama altyapısı eklendi.
- Hafta 2
  - FlutterSecureStorage üzerinden JWT depolama ve Dio interceptor entegre edildi.
  - Login ekranında form validasyonları ve hata mesajları gösterildi.
- Hafta 3
  - Access token süresi dolunca otomatik yenileme (`refresh`) mekanizması test edildi.
  - 401 hatalarında kullanıcıya Snackbar ile geri bildirim eklendi.
- Hafta 4
  - Signup akışına e-posta onay kodu işleme eklendi.
  - Logout sonrasında local cache (kullanıcı verisi, favoriler) temizleme işlemleri iyileştirildi.

---

## 4. `develop-connectivity` (Ahmet Mert Kadıoğlu / 220229064)
- Hafta 1
  - `connectivity_plus` entegre edilerek bağlantı durumu dinlenmeye başlandı.
  - Offline durum için SnackBar uyarıları (`ConnectivityListener`) eklendi.
- Hafta 2
  - API çağrısından önce bağlantı kontrolü yapıldı; offline durumda “internet yok” mesajı gösterildi.
  - Gerçek zamanlı bağlantı değişikliği için `connectivityStatusProvider` yapısı oluşturuldu.
- Hafta 3
  - “Retry” butonu ile manuel yeniden deneme akışı eklendi; bağlantı geri geldiğinde bekleyen istekler tetiklendi.
  - WorkManager görevlerinin offline iken iptal edilip, online olunca yeniden başlatılması mantığı test edildi.
- Hafta 4
  - Bağlantı değişikliklerini dinleyen kodun hata ayıklamaları yapıldı.
  - Offline eklenen verilerin (favori, ilan) bağlantı sağlanır sağlanmaz senkronize edilmesi test edildi.

---

## 5. `develop-storage` (Ahmet Mert Kadıoğlu / 220229064)
- Hafta 1
  - SharedPreferences ile tema (Light/Dark) ve dil (TR/EN) ayar kaydı eklendi.
  - `ThemeNotifier` ve `LanguageNotifier` provider’ları oluşturuldu.
- Hafta 2
  - Uygulama açılışında kayıtlı tema/dil tercihlerinin okunması ve uygulanması sağlandı.
  - Profil sayfasından tema ve dil değiştirme özelliği eklendi.
- Hafta 3
  - Prefs okuma/yazma sırasında hata senaryoları (boş/bozuk değer) için kontroller eklendi.
  - Kullanıcı ayarlarının JSON yedeği alınır ve geri yükleme işlevi prototip olarak eklendi.
- Hafta 4
  - Dil tercihlerinin `cloud_config` üzerinden çekilmesi prototipi hazırlanıp test edildi.
  - Yeni accent renk paleti tercihleri SharedPreferences’a kaydedilip uygulama geneline yansıtıldı.

---

## 6. `develop-cloud` (Selçuk Ümit Ateş / 210229034)
- Hafta 1
  - Firebase/Cloud Storage Flutter paketleri eklendi ve temel yapılandırma yapıldı.
  - Django backend’e medya yükleme (image upload) endpoint’i oluşturuldu.
- Hafta 2
  - “İlan Ekle” ekranına ImagePicker entegrasyonu ve resim sıkıştırma/önbelleğe alma akışı eklendi.
  - Yüklenen resim URL’leri Drift veritabanına ve backend’e kaydedildi.
- Hafta 3
  - `cloud_config` sınıfıyla uzaktan uygulama ayarları (bakım modu vb.) okunmaya başlandı.
  - Resim yükleme hatalarında retry mekanizması ve kullanıcı bilgilendirme dialog’u eklendi.
- Hafta 4
  - Firebase Firestore’da “ilan yorumları” koleksiyon yapısı oluşturuldu.
  - Fotoğraf yükleme performansı için image compression eklendi ve test edildi.

---

## 7. `develop-sensor` (Nabi Nabiyev / 220229078)
- Hafta 1
  - `geolocator` ile GPS konum bilgisi alma entegre edildi.
  - İlan ekleme formuna “konum ekle” butonu eklendi.
- Hafta 2
  - `sensors_plus` ile ivmeölçer/jung verisi alma altyapısı eklendi.
  - Konum tabanlı “yakındaki araçlar” filtreleme için backend query parametreleri ayarlandı.
- Hafta 3
  - Kullanıcının konumuna yakın en yakın 5 aracı getiren sorgu test edildi.
  - GPS sinyal zayıflığında kullanıcıya “konum alınamadı” uyarısı gösterildi.
- Hafta 4
  - GPS sinyal hatası durumunda “yeniden dene” butonu eklenip tekrar deneme akışı eklendi.
  - Sensör dinleyicileri optimize edilerek pil tasarrufu sağlandı.

---

## 8. `develop-broadcast` (Utku Mert Çırakoğlu / 240229097)
- Hafta 1
  - Manifest’e `CONNECTIVITY_CHANGE` ve `BOOT_COMPLETED` BroadcastReceiver tanımlandı.
  - İlk BroadcastReceiver sınıfı eklenerek bağlantı değişikliğinde log tutulmaya başlandı.
- Hafta 2
  - Broadcast alındığında kullanıcıya Notification gösterme (örn. “internet geri geldi”) işlevi eklendi.
  - Cihaz yeniden başlatıldığında WorkManager görevlerinin yeniden kayıt edilmesi sağlandı.
- Hafta 3
  - BroadcastReceiver’dan gelen olaylar Activity tablosuna log olarak kaydedildi.
  - Debounce mekanizması eklenerek gereksiz tekrarlar önlendi.
- Hafta 4
  - Pil seviyesi ve şarj durumu BroadcastReceiver ile dinlenerek Activity kaydına eklendi.
  - Kullanıcı “Aktivite Geçmişi” ekranında bu verileri görüntüleyebilir hâle getirildi.

---

## 9. `develop-background-task` (Utku Mert Çırakoğlu / 240229097)
- Hafta 1
  - WorkManager entegrasyonu yapıldı; `fetchPricesTask` tanımlandı.
  - Android/iOS izinleri manifest ve Info.plist’e eklendi.
- Hafta 2
  - Favori ilanların fiyat kontrolü için her 6 saatte bir çalışan task yazıldı.
  - Task hatalarında retry stratejisi eklendi.
- Hafta 3
  - Uygulama kapalıyken bile WorkManager görevlerinin tetiklenmesi test edildi.
  - Task loglama için print/logcat çıktıları eklendi.
- Hafta 4
  - Günlük hatırlatma işlevi eklendi; kullanıcı belirlediği saatte bildirim gönderen task hazırlandı.
  - Task ayarları (süre, retry sayısı) kullanıcı tercihlerine göre dinamik hale getirildi.

---

## 10. `develop-rest-api` (Selçuk Ümit Ateş / 210229034)
- Hafta 1
  - Django REST Framework kurulumu tamamlandı.
  - `CarViewSet`, `FavoriteViewSet`, `ActivityViewSet`, `UserViewSet` oluşturuldu.
  - `CarSerializer`, `FavoriteSerializer`, `UserSerializer` tanımlandı.
- Hafta 2
  - `IsAuthenticated` ve `IsOwnerOrReadOnly` bazlı permission kontrolleri eklendi.
  - Swagger/OpenAPI dokümantasyonu, Postman collection hazırlandı.
- Hafta 3
  - Model değişiklikleri sonrası `makemigrations` ve `migrate` çalıştırıldı.
  - `ActivityViewSet`’e tarih ve tür filtreleme parametreleri eklendi.
- Hafta 4
  - User profiline avatar yükleme endpoint’i eklendi; image upload testleri yapıldı.
  - `FavoriteViewSet`’e toplu ekleme (bulk create) ve toplu silme (bulk delete) endpoint’leri eklendi.
