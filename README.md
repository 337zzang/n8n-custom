# n8n Custom Docker for Render

업무자동화를 위한 커스텀 n8n Docker 이미지

## 포함된 라이브러리

### JavaScript/Node.js (40+ 패키지)

| 카테고리 | 라이브러리 |
|---------|-----------|
| HTTP/API | axios, node-fetch, form-data, qs |
| 데이터 처리 | lodash, underscore |
| 날짜/시간 | moment, dayjs, date-fns |
| 문자열 | validator, slugify, nanoid, uuid |
| HTML/XML | cheerio, fast-xml-parser, xml2js |
| CSV/Excel | papaparse, xlsx, exceljs |
| PDF | pdf-lib, pdfkit |
| 이미지 | sharp, jimp |
| 압축 | archiver, jszip |
| 암호화 | crypto-js, bcryptjs, jsonwebtoken |
| 템플릿 | handlebars, mustache, ejs |
| 바코드/QR | qrcode, bwip-js |
| 문서 | docx |

### Python (17 패키지)

| 카테고리 | 라이브러리 |
|---------|-----------|
| HTTP | requests |
| 데이터 | pandas |
| Excel | openpyxl, xlrd |
| HTML | beautifulsoup4, lxml |
| 이미지 | Pillow |
| PDF | PyPDF2, reportlab |
| Word | python-docx |
| 클라우드 | boto3, google-api-python-client |
| 메신저 | slack-sdk, python-telegram-bot |

## 배포 방법

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

## Code 노드에서 사용 예시

### JavaScript
```javascript
const axios = require('axios');
const _ = require('lodash');
const moment = require('moment-timezone');

// API 호출
const response = await axios.get('https://api.example.com/data');

// 데이터 처리
const filtered = _.filter(response.data, item => item.active);

// 날짜 포맷
const now = moment().tz('Asia/Seoul').format('YYYY-MM-DD HH:mm:ss');

return filtered.map(item => ({
  json: { ...item, processedAt: now }
}));
```

### Python
```python
import pandas as pd
import requests
from datetime import datetime

# API 호출
response = requests.get('https://api.example.com/data')
data = response.json()

# 데이터 처리
df = pd.DataFrame(data)
filtered = df[df['active'] == True]

return [{"json": row} for row in filtered.to_dict('records')]
```

## 버전

- n8n: 2.0.0
- 생성일: 2025-12
