# AI SQL Code Review

Bu proje SQL Server nesnelerini (procedure/view/function) LLM ile kurallara gore inceler, sonucu web arayuzunde gosterir ve rapor olarak disari aktarir.

Bu dokuman kurumsal ortamlarda **minimum eforla**, **adim adim** kurulum icin hazirlanmistir.

## Dokuman Haritasi (Kullanici / Sistem)

| Rol | Ne okumali? |
|-----|-------------|
| **Son kullanici** (gunluk inceleme) | [docs/USER_GUIDE.md](docs/USER_GUIDE.md) |
| **Sistem yoneticisi** (kurulum, LLM, guvenlik) | Bu README + [docs/ADMIN_GUIDE.md](docs/ADMIN_GUIDE.md) |
| **Operasyon / IT** (teslim onayi) | [docs/KURULUM_CHECKLIST.md](docs/KURULUM_CHECKLIST.md) |

Arayuzde sol menude **Kullanici** ve **Sistem** bolumleri ayri gruplanmistir; agir sayfalar ihtiyaca gore yuklenir (performans).

## 0) Mimari Ozet

- `backend`:
  - FastAPI
  - SQL Server baglantisi (ODBC)
  - LLM cagrilari
  - Kural motoru ve inceleme sonuclari
- `frontend`:
  - React + Vite
  - Inceleme ekranlari, canli ilerleme ve export

Calisma sirasinda:
1. Kullanici nesne veya SQL script secer.
2. Backend SQL metnini alir/ceker.
3. LLM'e kural bazli inceleme cagrilari yapar.
4. Sonucu UI'ya aktarir.

## 1) Onkosullar (Kurulum Oncesi Kontrol)

Asagidaki kurulumlarin hedef makinede oldugunu dogrulayin:

1. Python 3.10+
2. Node.js 18+
3. ODBC Driver 17 veya 18 for SQL Server
4. SQL Server erisimi (baglanti dizesi hazir)
5. LLM endpoint erisimi (LM Studio vb.)

PowerShell hizli kontrol:

```powershell
python --version
node --version
npm --version
```

ODBC kontrol (opsiyonel):

```powershell
Get-OdbcDriver | Where-Object { $_.Name -match "SQL Server" }
```

## 2) Hizli Kurulum (Onerilen - Tek Komut)

Proje kokunde:

```powershell
.\start.ps1
```

`start.ps1` su adimlari otomatik yapar:

1. 8000 ve 5173 portundaki eski surecleri temizler.
2. `backend/.env` yoksa `backend/.env.example` kopyalar.
3. `backend/.venv` yoksa olusturur.
4. Python bagimliliklarini kurar/gunceller.
5. Backend'i baslatir ve `api/health` ile dogrular.
6. Frontend `node_modules` yoksa `npm install` calistirir.
7. Vite dev server'i baslatir.

Beklenen cikti:
- API: `http://127.0.0.1:8000`
- UI: `http://localhost:5173`

## 3) Adim Adim Manuel Kurulum (Detayli)

Bu bolum tek komut yerine her adimi tek tek uygulamak isteyenler icindir.

### 3.1 Projeyi Hazirlama

```powershell
cd C:\Users\Aratha\Desktop\DWHCodeReview
```

### 3.2 Backend `.env` Hazirlama

```powershell
copy .\backend\.env.example .\backend\.env
```

`backend/.env` dosyasinda minimum zorunlu alanlar:

- `MSSQL_CONNECTION_STRING`
- `LLM_CHAT_API`
- `LLM_BASE_URL` (veya `LLM_CHAT_URL`)
- `LLM_MODEL`
- `SQL_REVIEW_LLM_MODEL`

### 3.3 Backend Sanal Ortam ve Bagimlilik

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install --upgrade pip
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

### 3.4 Backend Calistirma

```powershell
cd ..
.\backend\.venv\Scripts\python.exe -m uvicorn main:app --app-dir .\backend --host 127.0.0.1 --port 8000 --reload
```

Ayrica yeni bir terminalde health kontrol:

```powershell
Invoke-WebRequest -UseBasicParsing http://127.0.0.1:8000/api/health
```

### 3.5 Frontend Kurulum ve Calistirma

```powershell
cd frontend
npm install
npm run dev
```

## 4) `backend/.env` Kurumsal Onerilen Degerler

Ornek:

```env
MSSQL_CONNECTION_STRING=Driver={ODBC Driver 18 for SQL Server};Server=localhost;Database=master;Trusted_Connection=yes;Encrypt=yes;TrustServerCertificate=yes;
LLM_CHAT_API=api_v1_chat
LLM_BASE_URL=http://100.117.10.29:1234/v1
LLM_CHAT_URL=
LLM_MODEL=google/gemma-4-26b-a4b
SQL_REVIEW_LLM_MODEL=google/gemma-4-26b-a4b
LLM_API_KEY=
LLM_HTTP_TRUST_ENV=false
LLM_ENFORCE_PRIVATE_NETWORK=true
LLM_ALLOW_PUBLIC_HOSTS=
LLM_LOG_FULL_PAYLOADS=false
SQL_REVIEW_MAX_CONCURRENT_RULES=6
SQL_REVIEW_TWO_PART_THRESHOLD_CHARS=45000
CORS_ORIGINS=http://localhost:5173,http://127.0.0.1:5173
API_ACCESS_TOKEN=
```

## 5) Kurulum Sonrasi Dogrulama Senaryosu

1. UI'da bir veritabani secin.
2. En az 1 procedure secip inceleme baslatin.
3. Canli ekranda kural kartlarini gorun.
4. Sonucta:
   - `CSV indir` calisiyor mu?
   - `SQL indir` tam script ve yorum blogu ile geliyor mu?
5. `api/health` cevabi `{"status":"ok","rules_api":true}` mi?

## 6) Sik Karsilasilan Sorunlar

### 6.1 `Node.js / npm not found`
- Node.js LTS kurun.
- Yeni terminal acip tekrar deneyin.

### 6.2 `Failed to fetch`
- Backend ayakta mi kontrol edin: `http://127.0.0.1:8000/api/health`
- Port cakismasi varsa `.\start.ps1` tekrar calistirin.

### 6.3 `LLM baglanti hatasi`
- `LLM_BASE_URL` dogru mu?
- Hedef `ip:port` erisilebilir mi?
- LM Studio sunucusu acik mi?
- Firewall 1234 izinli mi?

### 6.4 `ReadTimeout`
- `SQL_REVIEW_MAX_CONCURRENT_RULES` dusurun (onerilen: 4-6).
- LLM modelin bellekte yuklu oldugunu kontrol edin.

## 7) Guvenlik Kontrol Listesi (Canliya Cikis Oncesi)

- `LLM_ENFORCE_PRIVATE_NETWORK=true`
- `LLM_LOG_FULL_PAYLOADS=false`
- `API_ACCESS_TOKEN` tanimli (gerekliyse)
- `CORS_ORIGINS` sadece izinli originler
- Public/cloud cikis politikasi dogrulandi

## 8) Kurulum Dokumanlari

- Adim adim kurulum: bu README
- Yazdirma/PDF checklist: `docs/KURULUM_CHECKLIST.md`

PDF almak icin:
1. `docs/KURULUM_CHECKLIST.md` dosyasini editor'de acin.
2. Print / Export to PDF ile kaydedin.
