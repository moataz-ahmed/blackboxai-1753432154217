# Finance Loan Backend API

A comprehensive RESTful API for the Finance Loan Management System built with FastAPI, SQLAlchemy, and SQLite.

## Features

- **User Authentication & Authorization** with JWT tokens
- **User Management** - Registration, login, profile management
- **Bank Management** - CRUD operations for banks
- **Company Management** - CRUD operations for companies
- **Loan Management** - Create, track, and manage loan requests
- **Credit Limit Management** - Manage user credit limits per bank/company
- **Real-time Loan Calculations** - Automatic calculation of monthly payments and total amounts
- **Multi-language Support** - Ready for English, Arabic, and Kurdish
- **Comprehensive API Documentation** - Auto-generated with FastAPI

## Technology Stack

- **FastAPI** - Modern, fast web framework for building APIs
- **SQLAlchemy** - SQL toolkit and Object-Relational Mapping (ORM)
- **SQLite** - Lightweight database (easily replaceable with PostgreSQL)
- **Pydantic** - Data validation using Python type annotations
- **JWT** - JSON Web Tokens for authentication
- **Bcrypt** - Password hashing
- **Uvicorn** - ASGI server implementation

## Project Structure

```
finance_loan_backend/
├── app/
│   ├── api/                 # API route handlers
│   │   ├── auth.py         # Authentication endpoints
│   │   ├── users.py        # User management endpoints
│   │   ├── loans.py        # Loan management endpoints
│   │   ├── banks.py        # Bank management endpoints
│   │   ├── companies.py    # Company management endpoints
│   │   └── credit_limits.py # Credit limit endpoints
│   ├── core/               # Core functionality
│   │   ├── config.py       # Configuration settings
│   │   ├── security.py     # Security utilities (JWT, password hashing)
│   │   └── deps.py         # Dependency injection
│   ├── crud/               # Database operations
│   │   ├── user.py         # User CRUD operations
│   │   ├── loan.py         # Loan CRUD operations
│   │   ├── bank.py         # Bank CRUD operations
│   │   ├── company.py      # Company CRUD operations
│   │   └── credit_limit.py # Credit limit CRUD operations
│   ├── db/                 # Database configuration
│   │   ├── database.py     # Database setup and connection
│   │   └── init_db.py      # Database initialization with sample data
│   ├── models/             # SQLAlchemy models
│   │   ├── user.py         # User model
│   │   ├── loan.py         # Loan model
│   │   ├── bank.py         # Bank model
│   │   ├── company.py      # Company model
│   │   └── credit_limit.py # Credit limit model
│   ├── schemas/            # Pydantic schemas for request/response
│   │   ├── user.py         # User schemas
│   │   ├── loan.py         # Loan schemas
│   │   ├── bank.py         # Bank schemas
│   │   ├── company.py      # Company schemas
│   │   └── credit_limit.py # Credit limit schemas
│   └── main.py             # FastAPI application setup
├── requirements.txt        # Python dependencies
├── run.py                 # Application startup script
├── .env                   # Environment variables
└── README.md              # This file
```

## Installation & Setup

1. **Clone the repository**
   ```bash
   cd finance_loan_backend
   ```

2. **Create a virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment variables**
   Update the `.env` file with your settings:
   ```env
   DATABASE_URL=sqlite:///./finance_loan.db
   SECRET_KEY=your-secret-key-here-change-in-production
   ALGORITHM=HS256
   ACCESS_TOKEN_EXPIRE_MINUTES=30
   ```

5. **Run the application**
   ```bash
   python run.py
   ```

   Or manually:
   ```bash
   uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
   ```

## API Documentation

Once the server is running, you can access:

- **Interactive API Documentation (Swagger UI)**: http://localhost:8000/docs
- **Alternative API Documentation (ReDoc)**: http://localhost:8000/redoc
- **API Base URL**: http://localhost:8000/api

## Sample Data

The application comes with pre-populated sample data:

### Demo User
- **Email**: demo@example.com
- **Password**: demo123

### Sample Banks
- Kurdistan Bank (KDB) - 8.5% interest rate
- Cihan Bank (CHB) - 9.0% interest rate  
- Ashur Bank (ASB) - 7.5% interest rate

### Sample Companies
- Tech Solutions KRG (Technology)
- Kurdistan Oil Company (Energy)
- Erbil Construction Ltd (Construction)
- Kurdistan Healthcare (Healthcare)

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - User login
- `POST /api/auth/login/form` - OAuth2 compatible login

### Users
- `GET /api/users/me` - Get current user profile
- `PUT /api/users/me` - Update current user profile
- `DELETE /api/users/me` - Deactivate user account

### Loans
- `POST /api/loans/` - Create new loan request
- `GET /api/loans/` - Get user's loans
- `GET /api/loans/{loan_id}` - Get specific loan
- `PUT /api/loans/{loan_id}/status` - Update loan status
- `DELETE /api/loans/{loan_id}` - Delete pending loan
- `GET /api/loans/statistics` - Get loan statistics

### Banks
- `GET /api/banks/` - Get all banks
- `GET /api/banks/{bank_id}` - Get specific bank
- `POST /api/banks/` - Create new bank (admin)
- `PUT /api/banks/{bank_id}` - Update bank (admin)
- `DELETE /api/banks/{bank_id}` - Deactivate bank (admin)

### Companies
- `GET /api/companies/` - Get all companies
- `GET /api/companies/{company_id}` - Get specific company
- `POST /api/companies/` - Create new company (admin)
- `PUT /api/companies/{company_id}` - Update company (admin)
- `DELETE /api/companies/{company_id}` - Deactivate company (admin)

### Credit Limits
- `GET /api/credit-limits/` - Get user's credit limits
- `GET /api/credit-limits/available` - Get available credit for bank/company
- `GET /api/credit-limits/{credit_limit_id}` - Get specific credit limit
- `POST /api/credit-limits/` - Create new credit limit (admin)
- `PUT /api/credit-limits/{credit_limit_id}` - Update credit limit (admin)
- `DELETE /api/credit-limits/{credit_limit_id}` - Delete credit limit (admin)

## Authentication

The API uses JWT (JSON Web Tokens) for authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your_jwt_token>
```

## Database Schema

### Users
- id, email, full_name, phone_number, profile_image, hashed_password, is_active, created_at

### Banks
- id, name, code, logo, interest_rate, max_loan_period, is_active

### Companies
- id, name, description, logo, category, is_active, created_at

### Loans
- id, user_id, bank_id, company_id, amount, interest_rate, duration_months, monthly_payment, total_amount, status, request_date, approval_date, rejection_date, rejection_reason, created_at

### Credit Limits
- id, user_id, bank_id, company_id, total_limit, used_limit, available_limit, created_at, updated_at

## Development

### Adding New Features

1. **Models**: Add new SQLAlchemy models in `app/models/`
2. **Schemas**: Create Pydantic schemas in `app/schemas/`
3. **CRUD**: Implement database operations in `app/crud/`
4. **API Routes**: Add endpoints in `app/api/`
5. **Register Routes**: Include new routers in `app/main.py`

### Testing

You can test the API using:
- The interactive documentation at `/docs`
- Tools like Postman or curl
- The Flutter app frontend

### Production Deployment

For production deployment:

1. **Update environment variables**
2. **Use PostgreSQL instead of SQLite**
3. **Set up proper CORS origins**
4. **Use a production ASGI server like Gunicorn**
5. **Implement proper logging**
6. **Add rate limiting and security headers**

## Integration with Flutter App

This backend is designed to work seamlessly with the Flutter Finance Loan App. The API endpoints match the expected data structures and provide all necessary functionality for:

- User authentication and profile management
- Loan application and tracking
- Bank and company information
- Credit limit management
- Transaction history

## Support

For questions or issues, please refer to the API documentation at `/docs` or check the source code comments for detailed implementation notes.
