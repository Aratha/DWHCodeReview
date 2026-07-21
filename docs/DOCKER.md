# Docker ile çalıştırma

Ön koşul: [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/macOS) veya Linux üzerinde Docker Engine + Compose.

## 1) Ortam dosyası

`backend/.env` hazır olmalı (`backend/.env.example` ile oluşturup doldurun).

**Konteyner içinden ana makinedeki SQL Server veya LM Studio’ya bağlanıyorsanız** sunucu adresi olarak `host.docker.internal` kullanın (Docker Desktop bu adı ana makineye yönlendirir).

Örnek:

```env
MSSQL_CONNECTION_STRING=Driver={ODBC Driver 18 for SQL Server};Server=host.docker.internal,1433;Database=YourDb;Trusted_Connection=no;UID=...;PWD=...;Encrypt=yes;TrustServerCertificate=yes;
LLM_BASE_URL=http://host.docker.internal:1234/v1
LLM_HTTP_TRUST_ENV=false
```

`LLM_ENFORCE_PRIVATE_NETWORK=true` iken `host.docker.internal` genelde private IP’ye çözülür. Cloud LLM için `LLM_ALLOW_PUBLIC_HOSTS` ve `docs/ADMIN_GUIDE.md` bölümlerine bakın.

Arayüz **http://localhost:8080** üzerinden nginx ile servis edilir; tarayıcı `/api` isteklerini aynı origin üzerinden backend’e iletir (ekstra CORS ayarı gerekmez).

## 2) Derleme ve başlatma

Depo kökünde:

```powershell
docker compose up --build
```

Arka planda:

```powershell
docker compose up --build -d
```

| Adres | Açıklama |
|--------|-----------|
| http://localhost:8080 | React production build + nginx (`/api` proxy) |
| http://localhost:8000 | FastAPI doğrudan (`/docs`, `/api/health`) |

Durdurmak: `Ctrl+C` veya `docker compose down`.

Windows’ta çift tık: kökte `start-docker.bat`.

## 3) Kalıcı veri

`docker-compose.yml` içinde `./backend/data` → `/app/data` bağlanır (inceleme kuralları ve taslak/yayın snapshot’ları konteyner yeniden oluşsa da kalır). `backend/data/llm_logs` host’ta `.gitignore` ile takip dışıdır.

## 4) Sorun giderme

| Sorun | Olası neden |
|--------|-------------|
| ODBC / pyodbc | İmajda ODBC 18 yüklü; bağlantı dizesinde `ODBC Driver 18 for SQL Server` |
| SQL’e bağlanamıyor | `Server=host.docker.internal,...`; firewall; SQL TCP dinlemesi |
| LLM timeout | LM Studio `0.0.0.0` veya makine IP’sinde; URL’de `host.docker.internal` |
| Ön yüz 502 | `docker compose ps`; `docker compose logs backend` |
| `web` healthy bekliyor | Backend healthcheck; `/api/health` ve `.env` doğruluğu |

## 5) Yerel geliştirme ile fark

| Mod | Arayüz | Backend |
|-----|--------|---------|
| `.bat` / `npm run dev` | Vite `:5173` | Uvicorn `:8000` (reload) |
| Docker | nginx `:8080` (statik build) | Uvicorn konteyner `:8000` |

Geliştirmede hot-reload için `.bat` akışını kullanın; Docker, production’a yakın paketlenmiş çalıştırma içindir.
