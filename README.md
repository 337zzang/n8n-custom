# n8n Custom Docker for Render

업무자동화를 위한 커스텀 n8n Docker 이미지 (Alpine Linux 호환)

## 📦 포함된 라이브러리 (39개)

모든 패키지는 **순수 JavaScript**로, Alpine Linux에서 네이티브 빌드 없이 설치됩니다.

### 1. HTTP/API 통신 (3개)
| 라이브러리 | 용도 |
|-----------|------|
| axios | Promise 기반 HTTP 클라이언트 |
| got | 고급 HTTP 클라이언트 (재시도, 스트리밍) |
| node-fetch@2 | Fetch API 스타일 HTTP 클라이언트 |

### 2. 날짜/시간 처리 (4개)
| 라이브러리 | 용도 |
|-----------|------|
| moment | 날짜/시간 조작 (레거시 호환) |
| dayjs | 경량 날짜 라이브러리 |
| date-fns | 함수형 날짜 유틸리티 |
| luxon | 타임존, 인터벌 지원 |

### 3. 데이터 처리/유틸리티 (3개)
| 라이브러리 | 용도 |
|-----------|------|
| lodash | 배열/객체/문자열 유틸리티 |
| uuid | UUID 생성 |
| nanoid | URL-safe 고유 ID 생성 |

### 4. HTML/XML 파싱 (4개)
| 라이브러리 | 용도 |
|-----------|------|
| cheerio | jQuery 스타일 HTML 파서 |
| xml2js | XML ↔ JSON 변환 |
| fast-xml-parser | 빠른 XML 파서 |
| sanitize-html | HTML 살균 (XSS 방지) |

### 5. CSV/Excel/데이터 포맷 (4개)
| 라이브러리 | 용도 |
|-----------|------|
| papaparse | CSV 파싱/생성 |
| xlsx | Excel 읽기/쓰기 |
| js-yaml | YAML 파싱/생성 |
| ajv | JSON 스키마 검증 |

### 6. 암호화/인증 (4개)
| 라이브러리 | 용도 |
|-----------|------|
| crypto-js | 암호화 (AES, SHA 등) |
| bcryptjs | 비밀번호 해싱 (순수 JS) |
| jsonwebtoken | JWT 토큰 생성/검증 |
| jose | 모던 JWT/JWE/JWS 라이브러리 |

### 7. 템플릿 엔진 (3개)
| 라이브러리 | 용도 |
|-----------|------|
| handlebars | 템플릿 엔진 |
| mustache | 경량 템플릿 |
| ejs | 임베디드 JavaScript 템플릿 |

### 8. 압축/아카이브 (2개)
| 라이브러리 | 용도 |
|-----------|------|
| jszip | ZIP 파일 생성/읽기 |
| archiver | 아카이브 생성 (ZIP, TAR) |

### 9. QR코드/PDF/유틸 (4개)
| 라이브러리 | 용도 |
|-----------|------|
| qrcode | QR 코드 생성 |
| iconv-lite | 문자 인코딩 변환 |
| pdf-lib | PDF 생성/편집 (순수 JS) |
| zod | 타입스크립트 우선 스키마 검증 |

### 10. 속도 제한/동시성/재시도 (4개)
| 라이브러리 | 용도 |
|-----------|------|
| bottleneck | API 속도 제한 |
| p-limit | 동시 실행 제한 |
| p-retry | 자동 재시도 로직 |
| pino | 고성능 JSON 로깅 |

### 11. 금융/수학 계산 (2개)
| 라이브러리 | 용도 |
|-----------|------|
| decimal.js | 정밀 소수점 계산 |
| big.js | 큰 숫자 처리 |

### 12. 문자열/검증 (3개)
| 라이브러리 | 용도 |
|-----------|------|
| validator | 이메일/URL 등 검증 |
| slugify | URL 슬러그 생성 |
| html-to-text | HTML → 텍스트 변환 |

---

## 🚀 배포 방법

### 1. GitHub에 레포지토리 생성

1. GitHub에서 새 레포지토리 생성 (예: `n8n-custom`)
2. 이 폴더의 파일들을 업로드

### 2. Render에서 배포

1. [Render Dashboard](https://dashboard.render.com) 접속
2. **New** → **Web Service**
3. **Connect a repository** → GitHub 레포 선택
4. 자동으로 Dockerfile 감지됨
5. **Create Web Service** 클릭

### 3. 환경변수 설정

Render 대시보드 → Environment에서:

```
WEBHOOK_URL=https://your-service.onrender.com
```

---

## 💻 Code 노드에서 사용 예시

### HTTP API 호출
```javascript
const axios = require('axios');
const response = await axios.get('https://api.example.com/data');
return response.data.map(item => ({ json: item }));
```

### 날짜 처리
```javascript
const dayjs = require('dayjs');
const now = dayjs().format('YYYY-MM-DD HH:mm:ss');
return [{ json: { timestamp: now } }];
```

### Excel 처리
```javascript
const XLSX = require('xlsx');
// 바이너리 데이터에서 워크북 읽기
const workbook = XLSX.read(binaryData, { type: 'buffer' });
const sheet = workbook.Sheets[workbook.SheetNames[0]];
const data = XLSX.utils.sheet_to_json(sheet);
return data.map(row => ({ json: row }));
```

### CSV 파싱
```javascript
const Papa = require('papaparse');
const result = Papa.parse(csvString, { header: true });
return result.data.map(row => ({ json: row }));
```

### JSON 스키마 검증
```javascript
const Ajv = require('ajv');
const ajv = new Ajv();

const schema = {
  type: 'object',
  properties: {
    name: { type: 'string' },
    age: { type: 'number' }
  },
  required: ['name']
};

const validate = ajv.compile(schema);
const valid = validate($input.first().json);
return [{ json: { valid, errors: validate.errors } }];
```

### QR 코드 생성
```javascript
const QRCode = require('qrcode');
const qrDataUrl = await QRCode.toDataURL('https://example.com');
return [{ json: { qrCode: qrDataUrl } }];
```

### API 속도 제한
```javascript
const Bottleneck = require('bottleneck');
const limiter = new Bottleneck({ maxConcurrent: 2, minTime: 1000 });

const results = await Promise.all(
  items.map(item => limiter.schedule(() =>
    axios.get(`https://api.example.com/${item.id}`)
  ))
);
return results.map(r => ({ json: r.data }));
```

---

## ⚠️ 제외된 패키지 (네이티브 빌드 필요)

다음 패키지들은 C++ 컴파일이 필요하여 제외되었습니다:

- **이미지 처리**: sharp, jimp, canvas
- **PDF**: pdfkit (pdf-lib 대신 사용 권장)
- **바코드**: bwip-js
- **암호화**: bcrypt (bcryptjs 대신 사용)
- **데이터베이스**: better-sqlite3, sqlite3

---

## 📋 버전 정보

- **n8n**: 2.0.0
- **Node.js**: n8n 이미지 기본값
- **패키지 수**: 39개
- **생성일**: 2025-12
