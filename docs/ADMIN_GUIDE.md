# Sistem Yöneticisi Kılavuzu

Kurulum, güvenlik, LLM ve veritabanı erişimi bu kapsamdadır.

## Sorumluluklar

| Alan | Yönetici görevi |
|------|------------------|
| SQL Server | ODBC sürücüsü, bağlantı dizesi, firewall |
| Backend | Python venv, `backend/.env`, servis çalıştırma |
| LLM | LM Studio veya uyumlu sunucu, ağ erişimi, model yükleme |
| Güvenlik | `API_ACCESS_TOKEN`, `LLM_ENFORCE_PRIVATE_NETWORK`, log ayarları |

## Menü (Sistem bölümü)

| Menü | Açıklama |
|------|----------|
| **Kurallar** | Yayınlanmış inceleme kurallarını düzenleyin (taslak / yayın). |
| **LLM ayarları** | Model, URL, eşzamanlılık ve güvenlik bayrakları. |

## Kritik ortam değişkenleri

- `MSSQL_CONNECTION_STRING` — uygulamanın bağlandığı SQL Server.
- `LLM_BASE_URL` / `LLM_CHAT_URL` — LLM HTTP uç noktası.
- `LLM_ENFORCE_PRIVATE_NETWORK=true` — kurumsal politikaya uygun çıkış kontrolü.
- `LLM_LOG_FULL_PAYLOADS=false` — üretimde ham payload loglamayı kapatır.
- `API_ACCESS_TOKEN` — doluysa `/api/*` için `X-API-Key` zorunludur (`/api/health` hariç).
- `SQL_REVIEW_MAX_CONCURRENT_RULES` — LM Studio yükünü dengelemek için (ör. 4–8).

## Sağlık kontrolü

```powershell
Invoke-WebRequest -UseBasicParsing http://127.0.0.1:8000/api/health
```

Beklenen: `{"status":"ok","rules_api":true}`

## Sorun giderme

- **LLM timeout / ReadTimeout:** Eşzamanlılığı düşürün; LM Studio’da modelin bellekte olduğundan emin olun; ağ gecikmesini kontrol edin.
- **Bağlantı reddedildi:** Tailscale/firewall; LM Studio’nun doğru arayüzde dinlemesi.
- **Eski API:** Eski `uvicorn` süreci kalmış olabilir; port 8000’i temizleyip `.\start.ps1` ile yeniden başlatın.

Tam kurulum adımları için `README.md` ve operasyon onayı için `docs/KURULUM_CHECKLIST.md` dosyalarına bakın.
