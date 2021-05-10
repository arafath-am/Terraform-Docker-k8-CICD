# API Examples

## Health Check

```bash
curl http://localhost:8080/api/health
```

## List Products

```bash
curl http://localhost:8080/api/products
```

## Search Products

```bash
curl "http://localhost:8080/api/products?search=book"
```

## Create Product

```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Used Backpack",
    "category": "Supplies",
    "description": "Good condition backpack",
    "price": 22.50,
    "stockQuantity": 4
  }'
```

## Place Order

```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "Arafath",
    "customerEmail": "student@example.com",
    "items": [
      {"productId": 1, "quantity": 1}
    ]
  }'
```
