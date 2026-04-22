# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Start development server
bin/rails server

# Database
bin/rails db:create db:migrate db:seed

# Tests
rspec                                        # all tests
rspec spec/requests/v1/users/units_spec.rb   # single file

# Generate Swagger docs
rake rswag:specs:swaggerize

# Console
bin/rails console
```

## Architecture

**Rails 7.1 API-only** (`config.api_only = true`) with PostgreSQL + Elasticsearch (Searchkick).

All routes are namespaced under `/v1/users/` with JWT bearer authentication enforced via `before_action :authorized` in `app/controllers/v1/users/application_controller.rb`. The only public endpoint is `POST /v1/users/sessions` (login).

**JWT config**: secret from `ENV['HASH_TOKEN']`, algorithm HS256.

### Key patterns

**Soft deletes** — never hard-delete records; all models use `is_deleted` boolean. Search methods filter `is_deleted: [false, nil]` automatically.

**Polymorphic references** — Addresses, Contacts, and Notes attach to multiple entity types via `reference_type` / `reference_id`. Example: an address can belong to a Unit or a Participant.

**Searchkick integration** — every searchable model implements:
- `search_default(term, params)` class method — builds filtered queries
- `search_data` instance method — defines what gets indexed
- `agg_search_array` class method — defines aggregation fields

**Search filtering** — controllers accept `params[:term]`, `params[:where]` (JSON), `params[:filter]` (JSON), `params[:order]` (JSON). `ApplicationController` provides `where_params`, `order_params`, and `custom_params` helpers.

**Nested addresses** — Units and Participants use `accepts_nested_attributes_for :addresses, allow_destroy: true`.

**Status enums** — integer-backed: `active=0`, `inactive=1`.

### Core domain models

| Model | Key fields | Notes |
|---|---|---|
| Unit | name, cnpj, status (enum), contact_id | has_many participants, addresses |
| Participant | name, cnpj, status (enum), unit_id, contact_id | has_many addresses |
| Contact | name, email, mobile_phone, reference_type/id | polymorphic owner |
| Address | street…zip_code, city_id, reference_type/id | polymorphic |
| Note | title, content, reference_type/id, user_id | polymorphic |

Geographic lookup tables: Country → State → City.

### Service layer

`app/services/search_service.rb` — builds Searchkick queries with boolean operators, field filters, and aggregations from JSON params.

## Environment variables

Managed via Figaro (`config/application.yml`, not committed). Key vars:
- `HASH_TOKEN` — JWT secret
- `local_database_*` / `teste_database_*` — dev/test DB credentials
- `host`, `port`, `database_user`, `database_pass` — production DB
- `HOST`, `PORT` — used in Swagger host config

## API Documentation

Rswag (OpenAPI 3.0.1) — specs live alongside request specs. Generated output: `swagger/v1/swagger.yaml`.
