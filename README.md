# Rales Engine

## Overview

Rales Engine is a JSON API that exposes data for 6 resources: customers, merchants, items, invoices, invoice items, and transactions. The restful endpoints return data for tables in the database, nested resources, and business intelligence.

## Setup

* Clone this repository and change directories into this project directory
* Run bundle from within the terminal
* Run rake db:{create,migrate} to create database and migrate tables
* Import data from CSVs by running these commands:
  * rails slurp:customers
  * rails slurp:merchants
  * rails slurp:items
  * rails slurp:invoices
  * rails slurp:invoice_items
  * rails slurp:transactions
  * bundle exec rake import
  
## Making API Calls

* Run ```rails s``` from the command line to run your localhost server.
* All calls should have a prefix of ```/api/vi```.
* Example: ```/api/v1/merchants```

## Record Endpoints

Each resource will have the following endpoints. The following endpoints are for merchants, but the same endpoints apply for each resource in the database.

```
'/api/v1/merchants'
'/api/v1/merchants/:id'
'api/v1/merchants/find
'/api/v1/merchants/find_all'
```

## Relationship Endpoints

### Merchants
```
/api/v1/merchants/:id/items
/api/v1/merchants/:id/invoices
```
### Invoices
```
/api/v1/invoices/:id/transactions
/api/v1/invoices/:id/invoice_items
/api/v1/invoices/:id/items
/api/v1/invoices/:id/customer
/api/v1/invoices/:id/merchant
```

### Invoice Items
```
/api/v1/invoice_items/:id/invoice
/api/v1/invoice_items/:id/item
```

### Items
```
/api/v1/items/:id/invoice_items
/api/v1/items/:id/merchant
```

### Transactions
```
/api/v1/transactions/:id/invoice
```

### Customers
```
/api/v1/customers/:id/invoices
/api/v1/customers/:id/transactions
```

## Business Intelligence Endpoints
```
/api/v1/merchants/most_revenue?quantity=x 
/api/v1/merchants/:id/favorite_customer
/api/v1/items/most_revenue?quantity=x 
/api/v1/customers/:id/favorite_merchant
```
