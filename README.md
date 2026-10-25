# TrustVault — Full-stack local demo

TrustVault is a FastAPI + SQLite + HTML/CSS/JavaScript document-management demo. It includes login, admin/owner/viewer roles, document uploads, per-document sharing, permission revocation, archived documents, and audit events.

> **Important:** This is a local educational starter project, not a production-certified security product. Before using real confidential documents, add CSRF protection if changing cookie behavior, HTTPS, stronger operational controls, rate limiting, formal migrations, malware scanning, backup/retention policy, and a reviewed audit-integrity strategy. The development cookie is configured for localhost (`secure=False`). Do not deploy as-is.

## Requirements
- Python 3.12 or later
- Visual Studio Code (optional)

## Run on Windows PowerShell
Open the terminal in the folder that contains `app/` and `requirements.txt`.

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
$env:ADMIN_EMAIL="admin@trustvault.local"
$env:ADMIN_PASSWORD="ChangeThisPassword123!"
$env:TRUSTVAULT_SECRET="replace-this-with-a-long-random-secret"
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload
```

If `python` is not recognized, install Python from python.org, enable **Add Python to PATH**, restart VS Code, then check `python --version`.

Open:
- Website: http://127.0.0.1:8000
- API documentation: http://127.0.0.1:8000/docs
- Health check: http://127.0.0.1:8000/api/health

Default local demo login (unless environment variables override it):
- Email: `admin@trustvault.local`
- Password: `ChangeThisPassword123!`

Change these values before use beyond a local demo. The database is created automatically at first startup. The initial admin is only inserted if its email does not already exist.

## Run using the batch file
Double-click `run.bat`, or run it from a terminal. Edit the development password and secret in the batch file before running if needed.

## Features
- FastAPI backend with SQLite persistence
- Password hashing using PBKDF2-HMAC-SHA256
- Signed, expiring HttpOnly session cookie
- Admin, document owner, and viewer roles
- Document upload with file extension and size checks
- Files stored outside the public static directory with randomized storage names
- Per-document sharing and download permission
- Revocable and expiring permission records (expiry accepted as Unix timestamp in API)
- Server-side document authorization
- Audit events for login, upload, download, sharing, revocation, archive, and denied access
- Administrator user management and audit CSV export
- Responsive frontend served by FastAPI

## API notes
- Login: `POST /api/auth/login`
- Current user: `GET /api/auth/me`
- List documents: `GET /api/documents`
- Upload: `POST /api/documents` (multipart fields `title`, optional `description`, `upload`)
- Download: `GET /api/documents/{id}/download`
- Share: `POST /api/documents/{id}/share` with JSON `{ "email": "viewer@example.com", "can_download": false, "expires_at": null }`
- Revoke: `DELETE /api/documents/{id}/permissions/{permission_id}`
- Audit: `GET /api/audit-logs`
- Admin audit CSV: `GET /api/audit-logs/export`

## Role behavior
- **Administrator:** can manage users, view all documents, and inspect/export audit logs. Administrative access to document content is still recorded through the download endpoint.
- **Owner:** can upload, share, download, and archive documents they own.
- **Viewer:** can view/download only explicitly shared documents and cannot upload or archive.

## Known limitations
- This starter currently uses SQLite and no migration framework.
- Preview, folder management, password-change UI, organization/tenant support, and full production hardening are not implemented in this compact demo.
- The project logs application-level audit records, but SQLite rows are not tamper-proof against a database administrator.
- Cookie `Secure` is false for localhost; configure HTTPS and secure cookies for deployment.
- File type validation uses an extension allowlist and size check; it is not a full malware scanner or robust content-signature validation.
- There is no built-in rate limiting yet.

## Troubleshooting
- `Could not import module "main"`: run from the project root and use `python -m uvicorn app.main:app --reload`.
- `404` for CSS/JS: make sure `app/static/style.css` and `app/static/app.js` exist and start the server from the project root.
- `python-multipart` error: run `python -m pip install -r requirements.txt` using the same Python environment used to start Uvicorn.
- Port busy: run `python -m uvicorn app.main:app --reload --port 8001` and open `http://127.0.0.1:8001`.
