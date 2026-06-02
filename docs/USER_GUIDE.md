# Son Kullanıcı Kılavuzu

Bu uygulamayı günlük işinizde kullanmak için yeterli bilgidir; sunucu veya LLM kurulumu gerekmez.

## Ne işe yarar?

Veritabanındaki procedure/view/function nesnelerini seçip kurallara göre otomatik inceler; aynı şekilde elinizdeki SQL metnini de yapıştırarak inceletebilirsiniz.

## Menü (Kullanıcı bölümü)

| Menü | Açıklama |
|------|----------|
| **İnceleme** | Veritabanı ve nesne seçerek inceleme başlatın. |
| **SQL yapıştır** | Nesne seçmeden SQL betiğini yapıştırın. |
| **Analiz geçmişi** | Daha önce tamamlanan analizlere kısa süreli bakın. |

## Tipik akış

1. **İnceleme** sekmesinde veritabanını seçin, nesneleri arayıp işaretleyin, incelemeyi başlatın.
2. Canlı pencerede kural kartlarını izleyin; bitince sonuçları açın.
3. İsterseniz **CSV**, **JSON**, **HTML** veya **SQL** olarak dışa aktarın.
4. Yanlış pozitif gördüğünüz satırları işaretleyin; rapor buna göre güncellenir.

## Dışa aktarılan SQL dosyası

İndirilen `.sql` dosyasının başında, düzeltilmesi gereken satırlar ve kurallar kısa bir yorum bloğunda özetlenir; altında tam nesne tanımı yer alır.

## Sorun yaşarsanız

- Sayfa veri getirmiyorsa: ağ bağlantınızı ve tarayıcı konsolunu kontrol edin.
- İnceleme takılıyorsa: sistem yöneticisine bildirin (LLM veya veritabanı tarafı olabilir).

Daha fazla ayrıntı için ana `README.md` dosyasına bakın.
