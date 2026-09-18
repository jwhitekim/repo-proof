PRODUCTS = {
    "pen": {"name": "Pen", "price": 2},
    "paper": {"name": "Paper", "price": 5},
}


def product_handler(product_id: str) -> dict[str, object]:
    """A synchronous WSGI handler performing a bounded in-memory lookup."""
    product = PRODUCTS.get(product_id)
    if product is None:
        return {"status": 404}
    return {"status": 200, "product": product}

